"""Frozen route counterfactual, not tuning or a qualification run."""

import argparse
import hashlib
import http.client
import importlib.util
import json
import socket
import statistics
import subprocess
import sys
import time
from collections import Counter
from datetime import datetime, timezone
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(ROOT))
from bgd_vision import conversation as live

CORPORA = {
    "original30": ("tests/vision/fixtures/conversation-eval.json", "tmp/language-candidate-20260927/clause-accountable-rev13/selected-old30-results.json"),
    "development58": ("tests/vision/fixtures/conversation-development-v2.json", "tmp/language-candidate-20260927/clause-accountable-rev13/selected-v2-results.json"),
    "root_rev13_38": ("tmp/language-candidate-20260927/root-open-probe-rev13/cases.json", "tmp/language-candidate-20260927/root-open-probe-rev13/probe-results.json"),
    "worker_rev13_48": ("tmp/language-candidate-20260927/clause-accountable-rev13/worker-open-rev13.json", "tmp/language-candidate-20260927/clause-accountable-rev13/ab-baseline-results.json"),
    "sealed_v3_100": ("tests/vision/fixtures/conversation-heldout-20260927-v3.json", "tmp/language-candidate-20260927/sealed-v3/sealed-results.json"),
}
PROFILES = {
    "old_sampling": {"temperature": 0.7, "top_p": 0.8, "top_k": 20, "min_p": 0, "presence_penalty": 1.5, "seed": 42},
    "greedy_zero_penalty": {"temperature": 0, "top_p": 0.8, "top_k": 20, "min_p": 0, "presence_penalty": 0, "seed": 42},
}


def sha(path):
    digest = hashlib.sha256()
    with Path(path).open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def write(path, value):
    Path(path).write_text(json.dumps(value, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")


def exact(case, result):
    return (isinstance(result, dict) and result.get("status") in case["statuses"]
            and ("steps" not in case or result.get("steps") == case["steps"]))


def frozen_module():
    path = ROOT / "tmp/language-candidate-20260927/boundary-v14-baseline/rev13-conversation.py"
    spec = importlib.util.spec_from_file_location("bgd_vision._frozen_step0_rev13", path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def replay(module, case, completion):
    """Apply existing pure routing/validation to this same raw completion."""
    text, context = module.clean_text(case["text"]), case.get("context")
    try:
        policy = module._request_policy_result(text, context)
        if policy is not None:
            return {"route": "policy_prepass", "result": policy, "passed": exact(case, policy)}
        source = module._source_grounded_plan(text, context)
        if source is not None:
            return {"route": "source_fast_path", "result": source, "passed": exact(case, source)}
        value = json.loads(completion)
        if (isinstance(value, dict) and value.get("status") == "planned"
                and isinstance(value.get("steps"), list)
                and any(isinstance(step, dict) and step.get("action") == "scout"
                        and isinstance(step.get("target"), str) and step["target"].strip()
                        for step in value["steps"])):
            value = {"status": "clarification_required", "message": "Scout actions must have an empty target", "steps": []}
        if (isinstance(value, dict) and set(value) == {"status", "message", "steps"}
                and value["status"] == "planned" and isinstance(value["message"], str)
                and len(value["message"]) <= 300 and value["steps"] == []):
            value = {"status": "clarification_required", "message": "What would you like me to do?", "steps": []}
        result = module._reconcile_model_plan(text, module.validate_semantic_result(value), context)
        return {"route": "model_fallback", "result": result, "passed": exact(case, result)}
    except (ValueError, TypeError) as exc:
        return {"route": "model_fallback", "result": None, "passed": False, "error": str(exc)}


def infer(port, case, profile):
    text = live.clean_text(case["text"])
    payload = {
        "messages": [{"role": "system", "content": live.SYSTEM_PROMPT},
                     {"role": "user", "content": json.dumps({"pending_proposal": case.get("context"), "request": text})}],
        "response_format": {"type": "json_schema", "json_schema": {"name": "desk_proposal", "strict": True, "schema": live.SEMANTIC_SCHEMA}},
        "chat_template_kwargs": {"enable_thinking": False},
        "max_tokens": 300, "stream": False, **profile,
    }
    started = time.perf_counter()
    row = {"request_payload": payload, "raw_response": None, "completion": None,
           "result": None, "passed": False, "error": None}
    connection = http.client.HTTPConnection("127.0.0.1", port, timeout=30)
    try:
        connection.request("POST", "/v1/chat/completions", json.dumps(payload), {"Content-Type": "application/json"})
        response = connection.getresponse()
        raw = response.read(32769)
        row.update(http_status=response.status, raw_response=raw.decode("utf-8", "replace")[:32768])
        if response.status != 200 or len(raw) > 32768:
            raise ValueError("Unavailable or oversized model response")
        reply = json.loads(raw)["choices"][0]
        row["completion"] = reply["message"]["content"]
        row["finish_reason"] = reply.get("finish_reason")
        if reply.get("finish_reason") != "stop":
            raise ValueError("Model completion did not finish")
        row["result"] = live.validate_semantic_result(json.loads(row["completion"]))
        row["passed"] = exact(case, row["result"])
    except (OSError, http.client.HTTPException, ValueError, KeyError, TypeError, IndexError) as exc:
        row["error"] = {"type": type(exc).__name__, "message": str(exc)}
    finally:
        connection.close()
    row["elapsed_ms"] = round((time.perf_counter() - started) * 1000, 3)
    return row


def score(rows, key):
    return {"passed": sum(row[key] for row in rows), "total": len(rows)}


def summarize(rows):
    def group(subset):
        return {"bare_model": score(subset, "passed"), **{
            version: {"passed": sum(row[version]["passed"] for row in subset), "total": len(subset),
                      "answered_before_model": sum(row[version]["route"] != "model_fallback" for row in subset),
                      "routes": dict(Counter(row[version]["route"] for row in subset)),
                      "correct_model_discarded_by_reconciliation": sum(row["passed"] and not row[version]["passed"]
                          and row[version]["route"] == "model_fallback" for row in subset),
                      "correct_model_replaced_with_wrong_prepass": sum(row["passed"] and not row[version]["passed"]
                          and row[version]["route"] != "model_fallback" for row in subset)}
            for version in ("rev13_counterfactual", "rev14_counterfactual")}}
    times = sorted(row["elapsed_ms"] for row in rows)
    return {"overall": group(rows), "reduced_scope": group([row for row in rows if row["in_reduced_scope"]]),
            "boundary_and_wider": group([row for row in rows if not row["in_reduced_scope"]]),
            "latency_median_ms": statistics.median(times), "latency_p95_ms": times[int((len(times) - 1) * .95)],
            "transport_or_schema_errors": sum(row["error"] is not None for row in rows),
            "misses": [row["id"] for row in rows if not row["passed"]]}


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--output", required=True, type=Path)
    parser.add_argument("--scope", required=True, type=Path)
    parser.add_argument("--port", type=int, default=8085)
    args = parser.parse_args()
    args.output.mkdir(parents=True, exist_ok=False)
    scope = json.loads(args.scope.read_text(encoding="utf-8"))
    corpora = {name: json.loads((ROOT / pair[0]).read_text(encoding="utf-8")) for name, pair in CORPORA.items()}
    model = ROOT / "tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf"
    server = ROOT / "tmp/language-candidate-20260922/windows/llama-server.exe"
    rev13 = frozen_module()
    if live.SYSTEM_PROMPT != rev13.SYSTEM_PROMPT or live.SEMANTIC_SCHEMA != rev13.SEMANTIC_SCHEMA:
        raise RuntimeError("Rev13 and current prompt/schema differ")
    with socket.socket() as probe:
        if probe.connect_ex(("127.0.0.1", args.port)) == 0:
            raise RuntimeError("Evaluation port is already occupied")
    inputs = [Path(__file__), args.scope, model, server, ROOT / "bgd_vision/conversation.py",
              ROOT / "bgd_vision/commands.py", ROOT / "tests/vision/test_conversation.py",
              ROOT / "tmp/language-candidate-20260927/boundary-v14-baseline/rev13-conversation.py"]
    inputs += [ROOT / path for pair in CORPORA.values() for path in pair]
    manifest = {"purpose": "Consumed labeled corpora route counterfactual, not tuning and not qualification. No prompt/code changes in response to individual cases.",
                "started_utc": datetime.now(timezone.utc).isoformat(), "profiles": PROFILES,
                "scope": scope, "inputs": {str(path): sha(path) for path in inputs},
                "prompt_sha256": hashlib.sha256(live.SYSTEM_PROMPT.encode()).hexdigest(),
                "schema_sha256": hashlib.sha256(json.dumps(live.SEMANTIC_SCHEMA, sort_keys=True).encode()).hexdigest(),
                "limits": ["PC text only; no Pi, speech, hardware or qualification claims.",
                           "Strict exact labels are retained even for wider phrasing. Honest clarification is not counted as exact fulfillment of a planned label.",
                           "Guarded counterfactuals replay the same raw completion through frozen code; they are not historical reruns.",
                           "Both decoding defects change together; this measures their combined effect, not either effect separately."],
                "server_runs": [], "historical": {}, "summaries": {}}
    for name, (_, history_path) in CORPORA.items():
        history = json.loads((ROOT / history_path).read_text(encoding="utf-8"))
        historical_rows = {row["id"]: row for row in history.get("cases", history.get("rows", []))}
        rows = [{"id": case["id"], "in_reduced_scope": scope["corpora"][name][case["id"]]["in_reduced_scope"],
                 "passed": exact(case, historical_rows[case["id"]].get("result"))} for case in corpora[name]]
        manifest["historical"][name] = {"source": history_path, "overall": score(rows, "passed"),
            "reduced_scope": score([row for row in rows if row["in_reduced_scope"]], "passed")}
    write(args.output / "manifest-before.json", manifest)
    write(args.output / "system-prompt.txt.json", live.SYSTEM_PROMPT)
    write(args.output / "schema.json", live.SEMANTIC_SCHEMA)
    for profile_name, profile in PROFILES.items():
        stdout = (args.output / (profile_name + "-server.stdout.log")).open("wb")
        stderr = (args.output / (profile_name + "-server.stderr.log")).open("wb")
        arguments = [str(server), "-m", str(model), "--host", "127.0.0.1", "--port", str(args.port),
                     "-t", "2", "-tb", "2", "-c", "2048", "-np", "1", "--jinja", "--no-webui"]
        process = subprocess.Popen(arguments, cwd=ROOT, stdout=stdout, stderr=stderr,
                                   creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        run = {"profile": profile_name, "pid": process.pid, "arguments": arguments[1:]}
        manifest["server_runs"].append(run)
        started = time.perf_counter()
        try:
            while time.perf_counter() - started < 120:
                if process.poll() is not None:
                    raise RuntimeError("Model server exited before readiness")
                connection = http.client.HTTPConnection("127.0.0.1", args.port, timeout=2)
                try:
                    connection.request("GET", "/health")
                    response = connection.getresponse()
                    response.read()
                    if response.status == 200:
                        break
                except OSError:
                    pass
                finally:
                    connection.close()
                time.sleep(.5)
            else:
                raise TimeoutError("Model readiness exceeded 120 seconds")
            run["health_ready_ms"] = round((time.perf_counter() - started) * 1000, 3)
            manifest["summaries"][profile_name] = {}
            for name, cases in corpora.items():
                rows = []
                with (args.output / f"{profile_name}-{name}-raw.jsonl").open("x", encoding="utf-8") as raw:
                    for case in cases:
                        row = infer(args.port, case, profile)
                        row.update(id=case["id"], text=case["text"], context=case.get("context"), category=case["category"],
                                   expected_statuses=case["statuses"], expected_steps=case.get("steps"),
                                   in_reduced_scope=scope["corpora"][name][case["id"]]["in_reduced_scope"])
                        completion = row["completion"] if row.get("finish_reason") == "stop" else None
                        row["rev13_counterfactual"] = replay(rev13, case, completion)
                        row["rev14_counterfactual"] = replay(live, case, completion)
                        rows.append(row)
                        raw.write(json.dumps(row, ensure_ascii=False) + "\n")
                        raw.flush()
                        if len(rows) % 10 == 0 or len(rows) == 1:
                            print(json.dumps({"profile": profile_name, "corpus": name, "done": len(rows), "total": len(cases),
                                              "bare_passed": sum(row["passed"] for row in rows)}), flush=True)
                summary = summarize(rows)
                manifest["summaries"][profile_name][name] = summary
                write(args.output / f"{profile_name}-{name}-summary.json", summary)
                write(args.output / "manifest-progress.json", manifest)
                print(json.dumps({"profile": profile_name, "corpus": name, "summary": summary}), flush=True)
        finally:
            process.terminate()
            try:
                process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait(timeout=10)
            stdout.close()
            stderr.close()
            run.update(stopped=process.poll() is not None, exit_code=process.returncode)
            write(args.output / "manifest-progress.json", manifest)
    manifest["finished_utc"] = datetime.now(timezone.utc).isoformat()
    manifest["inputs_unchanged"] = all(sha(path) == manifest["inputs"][str(path)] for path in inputs)
    manifest["outputs"] = {path.name: sha(path) for path in args.output.iterdir() if path.is_file()}
    write(args.output / "manifest-final.json", manifest)
    print(json.dumps({"finished": True, "inputs_unchanged": manifest["inputs_unchanged"]}), flush=True)


if __name__ == "__main__":
    main()
