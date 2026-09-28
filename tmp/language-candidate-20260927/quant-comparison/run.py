"""Controlled open Q4/Q6 comparison using the immutable rev9 source snapshot."""

import argparse
import hashlib
import http.client
import importlib.util
import json
import math
from pathlib import Path
import statistics
import subprocess
import sys
import time


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
SNAPSHOT = ROOT / "tmp/language-candidate-20260927/clause-accountable-rev9/conversation-revision9.py"
CORPUS = ROOT / "tmp/language-candidate-20260927/clause-accountable-rev9/open-development.json"
SERVER = ROOT / "tmp/language-candidate-20260922/windows/llama-server.exe"
PORT = 8084


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("model", choices=["q4", "q6"])
    args = parser.parse_args()
    preflight = json.loads((HERE / "preflight.json").read_text(encoding="utf-8"))
    profile = preflight["models"][args.model]
    model = ROOT / profile["path"]
    for path, expected in ((SNAPSHOT, preflight["source_snapshot_sha256"]),
                           (CORPUS, preflight["corpus_sha256"]),
                           (SERVER, preflight["server_sha256"]),
                           (model, profile["sha256"])):
        if not path.is_file() or sha256(path) != expected:
            raise RuntimeError(f"Frozen input mismatch: {path}")
    if model.stat().st_size != profile["bytes"]:
        raise RuntimeError("Model size mismatch")
    output = HERE / args.model
    if output.exists():
        raise FileExistsError(f"Refusing to overwrite comparison evidence: {output}")
    output.mkdir()
    sys.path.insert(0, str(ROOT))
    spec = importlib.util.spec_from_file_location("bgd_vision.quant_snapshot", SNAPSHOT)
    conversation = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = conversation
    spec.loader.exec_module(conversation)
    cases = json.loads(CORPUS.read_text(encoding="utf-8"))
    command = [str(SERVER), "-m", str(model), "--host", "127.0.0.1",
               "--port", str(PORT), "-t", "2", "-tb", "2", "-c", "2048",
               "-np", "1", "--jinja", "--no-webui"]
    ready_start = time.perf_counter()
    with (output / "server.stdout.log").open("wb") as stdout, \
            (output / "server.stderr.log").open("wb") as stderr:
        server = subprocess.Popen(command, cwd=ROOT, stdout=stdout, stderr=stderr,
                                  creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        try:
            while time.perf_counter() - ready_start < 120:
                if server.poll() is not None:
                    raise RuntimeError(f"Server exited early: {server.returncode}")
                try:
                    connection = http.client.HTTPConnection("127.0.0.1", PORT, timeout=2)
                    connection.request("GET", "/health")
                    response = connection.getresponse()
                    response.read()
                    connection.close()
                    if response.status == 200:
                        break
                except OSError:
                    pass
                time.sleep(0.5)
            else:
                raise TimeoutError("Server did not become ready")
            server_ready_ms = round((time.perf_counter() - ready_start) * 1000, 1)
            interpreter = conversation.LocalSemanticInterpreter(PORT, 30)
            rows = []
            for case in cases:
                clean = conversation.clean_text(case["text"])
                policy = conversation._request_policy_result(clean, case.get("context"))
                source = (None if policy is not None else
                          conversation._source_grounded_plan(clean, case.get("context")))
                route = ("policy_prepass" if policy is not None else
                         "source_fast_path" if source is not None else "model_fallback")
                started = time.perf_counter()
                try:
                    result = interpreter(case["text"], case.get("context"))
                    passed = (result["status"] in case["statuses"]
                              and result["steps"] == case["steps"])
                    error = None
                except ValueError as exc:
                    result, passed, error = None, False, str(exc)
                rows.append({
                    "id": case["id"], "text": case["text"],
                    "critical": case.get("critical") is True,
                    "expected_statuses": case["statuses"],
                    "expected_steps": case["steps"], "route": route,
                    "passed": passed, "result": result, "error": error,
                    "elapsed_ms": round((time.perf_counter() - started) * 1000, 1),
                    "model_diagnostic": (interpreter.last_diagnostic if route == "model_fallback"
                                         else None),
                })
                print(json.dumps({key: rows[-1][key] for key in
                                  ("id", "critical", "route", "passed", "elapsed_ms")}),
                      flush=True)
            model_rows = [row for row in rows if row["route"] == "model_fallback"]
            model_times = sorted(row["elapsed_ms"] for row in model_rows)
            critical = [row for row in rows if row["critical"]]
            ordinary = [row for row in rows if not row["critical"]]
            summary = {
                "model": args.model, "purpose": preflight["purpose"],
                "total": len(rows), "passed": sum(row["passed"] for row in rows),
                "critical_total": len(critical),
                "critical_passed": sum(row["passed"] for row in critical),
                "ordinary_total": len(ordinary),
                "ordinary_passed": sum(row["passed"] for row in ordinary),
                "model_requests": len(model_rows),
                "cold_model_ms": model_rows[0]["elapsed_ms"] if model_rows else None,
                "model_median_ms": statistics.median(model_times) if model_times else None,
                "model_p95_ms": model_times[math.ceil(.95 * len(model_times)) - 1]
                                if model_times else None,
                "server_ready_ms": server_ready_ms,
                "misses": [row["id"] for row in rows if not row["passed"]],
                "rows": rows,
            }
            (output / "results.json").write_text(json.dumps(summary, indent=2) + "\n",
                                                 encoding="utf-8")
        finally:
            server.terminate()
            try:
                server.wait(timeout=10)
            except subprocess.TimeoutExpired:
                server.kill()
                server.wait(timeout=10)
    manifest = {
        "model": args.model, "server_stopped": server.poll() is not None,
        "command": command[1:],
        "inputs": {str(path.relative_to(ROOT)): sha256(path)
                   for path in (SNAPSHOT, CORPUS, SERVER, model,
                                HERE / "preflight.json", HERE / "run.py")},
        "prompt_sha256": hashlib.sha256(conversation.SYSTEM_PROMPT.encode("utf-8")).hexdigest(),
        "schema_sha256": hashlib.sha256(json.dumps(conversation.SEMANTIC_SCHEMA,
                                                    sort_keys=True).encode("utf-8")).hexdigest(),
        "results_sha256": sha256(output / "results.json"),
    }
    (output / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n",
                                           encoding="utf-8")
    print(json.dumps({key: value for key, value in summary.items() if key != "rows"}), flush=True)


if __name__ == "__main__":
    main()
