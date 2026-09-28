"""Capture a frozen, text-only evaluation through the production interpreter."""

import argparse
import base64
import hashlib
import json
import math
from pathlib import Path
import statistics
import sys
import time

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))

from bgd_vision import conversation, evaluate_language


HERE = Path(__file__).resolve().parent
OLD30_CRITICAL_CATEGORIES = {"ambiguity", "negation", "unsupported", "injection"}


def sha256_bytes(value):
    return hashlib.sha256(value).hexdigest()


def sha256_file(path):
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def run(args):
    corpus_path = args.corpus.resolve()
    allowed_corpora = {
        (ROOT / "tests/vision/fixtures/conversation-eval.json").resolve(),
        (ROOT / "tests/vision/fixtures/conversation-development-v2.json").resolve(),
        (HERE / "worker53-open.json").resolve(),
        (HERE / "root35-open.json").resolve(),
        (HERE / "open-development-rev12.json").resolve(),
        (HERE / "prompt-ab-rev12.json").resolve(),
    }
    if corpus_path not in allowed_corpora:
        raise ValueError("This runner accepts only the pinned open-development corpora")
    for path in (args.output, args.raw_jsonl):
        if path.exists():
            raise FileExistsError(f"Refusing to overwrite prior evidence: {path}")

    lock_path = HERE / "run-lock.json"
    lock = json.loads(lock_path.read_text(encoding="utf-8"))
    lock_mismatches = []
    for relative, expected in lock["files"].items():
        current = ROOT / relative
        if (not current.is_file() or current.stat().st_size != expected["bytes"]
                or sha256_file(current) != expected["sha256"]):
            lock_mismatches.append(relative)
    if lock_mismatches:
        raise RuntimeError("Revision-12 lock mismatch: " + ", ".join(lock_mismatches))
    corpus_relative = str(corpus_path.relative_to(ROOT)).replace("\\", "/")
    if corpus_relative not in lock["files"]:
        raise RuntimeError("Corpus is not pinned in the revision-12 run lock")

    prompt_path = (HERE / args.prompt_file).resolve()
    prompt_variants = lock["prompt_variants"]
    if args.prompt_file not in prompt_variants:
        raise ValueError("Prompt variant is not listed in the run lock")
    if prompt_path != (HERE / args.prompt_file).resolve():
        raise ValueError("Prompt file must remain inside the Rev12 evidence directory")
    schema_path = HERE / "schema.json"
    prompt_bytes = prompt_path.read_bytes()
    prompt_text = prompt_bytes.decode("utf-8")
    if hashlib.sha256(prompt_bytes).hexdigest() != prompt_variants[args.prompt_file]["sha256"]:
        raise RuntimeError("Prompt file does not match the pinned variant")
    conversation.SYSTEM_PROMPT = prompt_text
    saved_schema = json.loads(schema_path.read_text(encoding="utf-8"))
    if saved_schema != conversation.SEMANTIC_SCHEMA:
        raise RuntimeError("Saved schema does not match the production profile")

    cases = json.loads(corpus_path.read_text(encoding="utf-8"))
    if args.verify_only:
        print(json.dumps({
            "trial_id": lock["trial_id"],
            "corpus": corpus_relative,
            "corpus_sha256": sha256_file(corpus_path),
            "case_count": len(cases),
            "prompt_sha256": sha256_bytes(prompt_bytes),
            "schema_sha256": sha256_file(schema_path),
            "locked_files": len(lock["files"]),
            "inference_performed": False,
        }, ensure_ascii=False), flush=True)
        return 0
    traces = []
    active_trace = [None]
    real_connection = conversation.http.client.HTTPConnection

    class CapturedResponse:
        def __init__(self, response, trace):
            self.response, self.trace = response, trace

        def __getattr__(self, name):
            return getattr(self.response, name)

        def read(self, limit):
            raw = self.response.read(limit)
            self.trace["http_status"] = self.response.status
            self.trace["raw_api_response_bytes"] = len(raw)
            self.trace["raw_api_response"] = raw.decode("utf-8", errors="replace")
            self.trace["raw_api_response_base64"] = base64.b64encode(raw).decode("ascii")
            self.trace["finish_reason"] = None
            self.trace["model_completion_raw"] = None
            self.trace["model_completion_parsed"] = None
            self.trace["model_completion_bytes"] = None
            self.trace["model_completion_chars"] = None
            self.trace["api_usage"] = None
            try:
                response_value = json.loads(raw)
                choice = response_value["choices"][0]
                self.trace["api_usage"] = response_value.get("usage")
                self.trace["finish_reason"] = choice.get("finish_reason")
                self.trace["model_completion_raw"] = choice["message"]["content"]
                self.trace["model_completion_bytes"] = len(
                    self.trace["model_completion_raw"].encode("utf-8"))
                self.trace["model_completion_chars"] = len(self.trace["model_completion_raw"])
                try:
                    self.trace["model_completion_parsed"] = json.loads(
                        self.trace["model_completion_raw"])
                except (TypeError, json.JSONDecodeError):
                    pass
            except (TypeError, KeyError, IndexError, json.JSONDecodeError):
                pass
            return raw

    class CapturedConnection:
        def __init__(self, *connection_args, **connection_kwargs):
            self.connection = real_connection(*connection_args, **connection_kwargs)

        def request(self, method, url, body=None, headers=None, *, encode_chunked=False):
            trace = active_trace[0]
            trace["request_method"] = method
            trace["request_path"] = url
            trace["request_body"] = body.decode("utf-8", errors="replace") \
                if isinstance(body, bytes) else body
            trace["request_headers"] = headers
            trace["request_body_bytes"] = (len(body) if isinstance(body, bytes)
                                            else len(body.encode("utf-8")) if isinstance(body, str)
                                            else None)
            try:
                payload = json.loads(body)
                system_message = next(message for message in payload["messages"]
                                      if message["role"] == "system")
                trace["system_prompt_bytes"] = len(system_message["content"].encode("utf-8"))
                user_message = next(message for message in payload["messages"]
                                    if message["role"] == "user")
                trace["user_message_bytes"] = len(user_message["content"].encode("utf-8"))
            except (TypeError, KeyError, StopIteration, json.JSONDecodeError):
                trace["system_prompt_bytes"] = None
                trace["user_message_bytes"] = None
            trace["model_inference_performed"] = True
            return self.connection.request(method, url, body, headers,
                                           encode_chunked=encode_chunked)

        def getresponse(self):
            return CapturedResponse(self.connection.getresponse(), active_trace[0])

        def close(self):
            return self.connection.close()

    class AuditedInterpreter:
        def __init__(self, port, timeout):
            self.interpreter = conversation.LocalSemanticInterpreter(port, timeout)

        def __call__(self, text, context=None):
            trace = {"model_inference_performed": False}
            clean_request = conversation.clean_text(text)
            trace["policy_prepass_result"] = conversation._request_policy_result(clean_request, context)
            trace["source_fast_path_result"] = (
                None if trace["policy_prepass_result"] is not None
                else conversation._source_grounded_plan(clean_request, context))
            trace["execution_path"] = (
                "policy_prepass" if trace["policy_prepass_result"] is not None
                else "source_fast_path" if trace["source_fast_path_result"] is not None
                else "model_fallback")
            active_trace[0] = trace
            started = time.perf_counter()
            try:
                return self.interpreter(text, context)
            finally:
                trace["interpreter_elapsed_ms"] = round((time.perf_counter() - started) * 1000, 1)
                traces.append(trace)
                active_trace[0] = None

    conversation.http.client.HTTPConnection = CapturedConnection
    try:
        summary = evaluate_language.evaluate(AuditedInterpreter(args.port, args.timeout), cases)
    finally:
        conversation.http.client.HTTPConnection = real_connection

    rows = []
    for case, evaluated, trace in zip(cases, summary["cases"], traces, strict=True):
        if "critical" in case:
            scoring_critical = case.get("critical") is True
            scoring_basis = "fixture critical flag"
        else:
            scoring_critical = case["category"] in OLD30_CRITICAL_CATEGORIES
            scoring_basis = ("legacy frozen30 category grouping" if corpus_path.name == "conversation-eval.json"
                             else "no explicit critical flag")
        rows.append({
            **evaluated,
            "input_text": case["text"],
            "context": case.get("context"),
            "expected_statuses": case["statuses"],
            "expected_steps": case.get("steps"),
            "scoring_critical": scoring_critical,
            "scoring_basis": scoring_basis,
            "validated_result": evaluated["result"],
            **trace,
        })

    model_rows = [row for row in rows if row["model_inference_performed"]]
    times = sorted(row["interpreter_elapsed_ms"] for row in model_rows)
    critical_rows = [row for row in rows if row["scoring_critical"]]
    ordinary_rows = [row for row in rows if not row["scoring_critical"]]
    completion_bytes = [row["model_completion_bytes"] for row in model_rows
                        if row["model_completion_bytes"] is not None]
    scoring_basis = ("Explicit fixture critical=true field; cases without true are ordinary."
                     if corpus_path.name != "conversation-eval.json"
                     else "Fixture has no critical field. Critical categories are ambiguity, negation, unsupported, and injection (IDs a/n/u/i); paraphrase, description, correction, and multiple are ordinary (IDs p/d/c/m).")
    summary.update({
        "corpus": str(corpus_path.relative_to(ROOT)),
        "corpus_sha256": sha256_file(corpus_path),
        "production_prompt_sha256": sha256_bytes(prompt_bytes),
        "prompt_variant": args.prompt_file,
        "saved_schema_sha256": sha256_file(schema_path),
        "run_lock_sha256": sha256_file(lock_path),
        "runner_sha256": sha256_file(Path(__file__)),
        "raw_rows": rows,
        "critical_score": {"passed": sum(row["passed"] for row in critical_rows),
                           "total": len(critical_rows)},
        "ordinary_score": {"passed": sum(row["passed"] for row in ordinary_rows),
                           "total": len(ordinary_rows)},
        "critical_misses": [row["id"] for row in critical_rows if not row["passed"]],
        "ordinary_misses": [row["id"] for row in ordinary_rows if not row["passed"]],
        "scoring_basis": scoring_basis,
        "model_inference_requests": len(model_rows),
        "policy_prepass_cases": [row["id"] for row in rows
                                 if row["execution_path"] == "policy_prepass"],
        "source_fast_path_cases": [row["id"] for row in rows
                                   if row["execution_path"] == "source_fast_path"],
        "model_fallback_cases": [row["id"] for row in rows
                                 if row["execution_path"] == "model_fallback"],
        "first_evaluated_case_latency_ms": rows[0]["elapsed_ms"] if rows else None,
        "first_model_inference_case": ({"id": model_rows[0]["id"],
                                        "latency_ms": model_rows[0]["interpreter_elapsed_ms"]}
                                       if model_rows else None),
        "cold_model_latency_ms": (model_rows[0]["interpreter_elapsed_ms"] if model_rows else None),
        "model_latency_median_ms": statistics.median(times) if times else None,
        "model_latency_p95_ms": (times[math.ceil(.95 * len(times)) - 1] if times else None),
        "system_prompt_bytes": len(prompt_bytes),
        "model_completion_bytes": {
            "count": len(completion_bytes),
            "median": statistics.median(completion_bytes) if completion_bytes else None,
            "p95": sorted(completion_bytes)[math.ceil(.95 * len(completion_bytes)) - 1]
            if completion_bytes else None,
            "per_case_field": "model_completion_bytes in raw_rows",
        },
        "latency_definition": "Cold is the first actual model inference. Model latency median/p95 use sorted interpreter_elapsed_ms for model requests only and include HTTP request, parsing, validation and reconciliation; policy-prepass rows are excluded.",
        "prompt_byte_definition": "UTF-8 byte length of the exact system prompt sent in the request; each inference row also records system_prompt_bytes and request body bytes.",
    })
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with args.raw_jsonl.open("x", encoding="utf-8", newline="\n") as output:
        for row in rows:
            output.write(json.dumps(row, ensure_ascii=False) + "\n")
    summary["raw_rows"] = None
    args.output.write_text(json.dumps(summary, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps({key: value for key, value in summary.items() if key != "cases"},
                     ensure_ascii=False), flush=True)
    return 0 if summary["passed"] == summary["total"] else 1


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--port", type=int, default=8084)
    parser.add_argument("--timeout", type=float, default=30)
    parser.add_argument("--prompt-file", choices=("prompt-baseline.txt", "prompt-candidate.txt"), required=True)
    parser.add_argument("--corpus", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--raw-jsonl", type=Path, required=True)
    parser.add_argument("--verify-only", action="store_true")
    args = parser.parse_args()
    return run(args)


if __name__ == "__main__":
    raise SystemExit(main())
