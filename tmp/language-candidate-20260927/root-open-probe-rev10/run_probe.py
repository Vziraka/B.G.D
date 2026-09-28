"""Root's independent OPEN meaning probe; never reads a sealed fixture."""

import hashlib
import http.client
import json
from pathlib import Path
import statistics
import subprocess
import sys
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(ROOT))

from bgd_vision import conversation

MODEL = ROOT / "tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf"
SERVER = ROOT / "tmp/language-candidate-20260922/windows/llama-server.exe"
SOURCE = ROOT / "bgd_vision/conversation.py"
CORPUS = HERE / "cases.json"
PORT = 8083


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main():
    preflight = json.loads((HERE / "preflight.json").read_text(encoding="utf-8"))
    if sha256(CORPUS) != preflight["fixture_sha256"]:
        raise RuntimeError("The predeclared root probe changed")
    output_paths = [HERE / name for name in
                    ("probe-results.json", "probe-raw.jsonl", "probe-manifest.json",
                     "server.stdout.log", "server.stderr.log")]
    if any(path.exists() for path in output_paths):
        raise FileExistsError("Refusing to overwrite root probe evidence")
    cases = json.loads(CORPUS.read_text(encoding="utf-8"))
    if (len(cases) != preflight["case_count"]
            or sum(case.get("critical") is True for case in cases) != preflight["critical_count"]):
        raise RuntimeError("Root probe counts changed")
    source_hash = sha256(SOURCE)
    prompt_hash = hashlib.sha256(conversation.SYSTEM_PROMPT.encode("utf-8")).hexdigest()
    schema_hash = hashlib.sha256(json.dumps(conversation.SEMANTIC_SCHEMA,
                                            sort_keys=True).encode("utf-8")).hexdigest()
    arguments = [str(SERVER), "-m", str(MODEL), "--host", "127.0.0.1",
                 "--port", str(PORT), "-t", "2", "-tb", "2", "-c", "2048",
                 "-np", "1", "--jinja", "--no-webui"]
    started = time.perf_counter()
    with (HERE / "server.stdout.log").open("wb") as stdout, \
            (HERE / "server.stderr.log").open("wb") as stderr:
        process = subprocess.Popen(arguments, cwd=ROOT, stdout=stdout, stderr=stderr,
                                   creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        try:
            while time.perf_counter() - started < 120:
                if process.poll() is not None:
                    raise RuntimeError(f"Model server exited: {process.returncode}")
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
                raise TimeoutError("Model server did not become ready")
            ready_ms = round((time.perf_counter() - started) * 1000, 1)
            real_connection = conversation.http.client.HTTPConnection
            current_trace = [None]

            class CapturedResponse:
                def __init__(self, inner):
                    self.inner = inner

                def __getattr__(self, name):
                    return getattr(self.inner, name)

                def read(self, limit):
                    raw = self.inner.read(limit)
                    trace = current_trace[0]
                    trace["api_status"] = self.inner.status
                    trace["raw_api_response"] = raw.decode("utf-8", errors="replace")
                    try:
                        reply = json.loads(raw)["choices"][0]
                        trace["model_completion_raw"] = reply["message"]["content"]
                        trace["finish_reason"] = reply.get("finish_reason")
                    except (TypeError, ValueError, KeyError, IndexError):
                        pass
                    return raw

            class CapturedConnection:
                def __init__(self, *args, **kwargs):
                    self.inner = real_connection(*args, **kwargs)

                def request(self, method, path, body=None, headers=None, **kwargs):
                    current_trace[0]["model_inference_performed"] = True
                    current_trace[0]["request_body"] = body
                    return self.inner.request(method, path, body, headers, **kwargs)

                def getresponse(self):
                    return CapturedResponse(self.inner.getresponse())

                def close(self):
                    return self.inner.close()

            rows = []
            conversation.http.client.HTTPConnection = CapturedConnection
            try:
                interpreter = conversation.LocalSemanticInterpreter(PORT, 30)
                for case in cases:
                    trace = {"model_inference_performed": False}
                    current_trace[0] = trace
                    clean = conversation.clean_text(case["text"])
                    policy = conversation._request_policy_result(clean, case.get("context"))
                    source = (None if policy is not None else
                              conversation._source_grounded_plan(clean, case.get("context")))
                    trace["route"] = ("policy_prepass" if policy is not None else
                                      "source_fast_path" if source is not None else "model_fallback")
                    start_case = time.perf_counter()
                    try:
                        result = interpreter(case["text"], case.get("context"))
                        passed = (result["status"] in case["statuses"]
                                  and result["steps"] == case["steps"])
                        error = None
                    except ValueError as exc:
                        result, passed, error = None, False, str(exc)
                    row = {"id": case["id"], "category": case["category"],
                           "critical": case.get("critical") is True,
                           "text": case["text"], "expected_statuses": case["statuses"],
                           "expected_steps": case["steps"], "passed": passed,
                           "elapsed_ms": round((time.perf_counter() - start_case) * 1000, 1),
                           "result": result, "error": error, **trace}
                    rows.append(row)
                    print(json.dumps({key: row[key] for key in
                                      ("id", "passed", "elapsed_ms", "route", "error")}), flush=True)
            finally:
                conversation.http.client.HTTPConnection = real_connection
                current_trace[0] = None
            critical = [row for row in rows if row["critical"]]
            ordinary = [row for row in rows if not row["critical"]]
            model_rows = [row for row in rows if row["model_inference_performed"]]
            ordinary_model = [row for row in ordinary if row["model_inference_performed"]]
            model_times = sorted(row["elapsed_ms"] for row in model_rows)
            result = {
                "purpose": "Independent open development probe, not sealed qualification",
                "critical_passed": sum(row["passed"] for row in critical),
                "critical_total": len(critical),
                "ordinary_passed": sum(row["passed"] for row in ordinary),
                "ordinary_total": len(ordinary),
                "ordinary_model_fallback": len(ordinary_model),
                "model_inference_requests": len(model_rows),
                "cold_model_ms": model_rows[0]["elapsed_ms"] if model_rows else None,
                "model_median_ms": statistics.median(model_times) if model_times else None,
                "misses": [row["id"] for row in rows if not row["passed"]],
                "rows": rows,
            }
            result["meets_preflight"] = (
                result["critical_passed"] >= preflight["minimum_critical_correct"]
                and result["ordinary_passed"] >= preflight["minimum_ordinary_correct"]
                and len(ordinary_model) >= preflight["minimum_ordinary_model_fallback"])
            (HERE / "probe-results.json").write_text(json.dumps(result, indent=2) + "\n",
                                                     encoding="utf-8")
            with (HERE / "probe-raw.jsonl").open("w", encoding="utf-8") as raw:
                for row in rows:
                    raw.write(json.dumps(row, ensure_ascii=False) + "\n")
        finally:
            process.terminate()
            try:
                process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait(timeout=10)
    if sha256(SOURCE) != source_hash:
        raise RuntimeError("Source changed during root probe")
    manifest = {
        "server_ready_ms": ready_ms, "server_stopped": process.poll() is not None,
        "server_arguments": arguments[1:],
        "inputs": {str(path.relative_to(ROOT)): sha256(path)
                   for path in (CORPUS, MODEL, SERVER, SOURCE, HERE / "preflight.json",
                                HERE / "run_probe.py")},
        "prompt_sha256": prompt_hash, "schema_sha256": schema_hash,
        "outputs": {path.name: sha256(path) for path in output_paths[:2]},
    }
    (HERE / "probe-manifest.json").write_text(json.dumps(manifest, indent=2) + "\n",
                                               encoding="utf-8")
    print(json.dumps({key: value for key, value in result.items() if key != "rows"}), flush=True)


if __name__ == "__main__":
    main()
