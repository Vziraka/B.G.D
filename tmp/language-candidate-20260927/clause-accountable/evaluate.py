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


ALLOWED_CORPORA = {
    "conversation-eval.json",
    "conversation-development-v2.json",
}
PROFILE_DIR = Path(__file__).resolve().parent
CRITICAL_CATEGORIES = {"unsupported", "negation", "bypass", "ambiguity"}


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
    if corpus_path.name not in ALLOWED_CORPORA:
        raise ValueError("This runner accepts only the two open development corpora")
    if corpus_path.parent.name != "fixtures":
        raise ValueError("Corpus must be a checked-in development fixture")
    for path in (args.output, args.raw_jsonl):
        if path.exists():
            raise FileExistsError(f"Refusing to overwrite prior evidence: {path}")

    prompt_path = PROFILE_DIR / "system-prompt.txt"
    schema_path = PROFILE_DIR / "schema.json"
    prompt_bytes = prompt_path.read_bytes()
    if prompt_bytes.decode("utf-8") != conversation.SYSTEM_PROMPT:
        raise RuntimeError("Saved prompt does not match the production profile")
    saved_schema = json.loads(schema_path.read_text(encoding="utf-8"))
    if saved_schema != conversation.SEMANTIC_SCHEMA:
        raise RuntimeError("Saved schema does not match the production profile")

    cases = json.loads(corpus_path.read_text(encoding="utf-8"))
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
            self.trace["raw_api_response"] = raw.decode("utf-8", errors="replace")
            self.trace["raw_api_response_base64"] = base64.b64encode(raw).decode("ascii")
            self.trace["finish_reason"] = None
            self.trace["model_completion_raw"] = None
            self.trace["model_completion_parsed"] = None
            try:
                choice = json.loads(raw)["choices"][0]
                self.trace["finish_reason"] = choice.get("finish_reason")
                self.trace["model_completion_raw"] = choice["message"]["content"]
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
            trace["policy_prepass_result"] = conversation._request_policy_result(
                conversation.clean_text(text))
            active_trace[0] = trace
            started = time.perf_counter()
            try:
                return self.interpreter(text, context)
            finally:
                trace["interpreter_elapsed_ms"] = round((time.perf_counter() - started) * 1000, 1)
                trace["execution_path"] = ("local_model" if trace["model_inference_performed"]
                                           else "policy_prepass")
                traces.append(trace)
                active_trace[0] = None

    conversation.http.client.HTTPConnection = CapturedConnection
    try:
        summary = evaluate_language.evaluate(AuditedInterpreter(args.port, args.timeout), cases)
    finally:
        conversation.http.client.HTTPConnection = real_connection

    rows = []
    for case, evaluated, trace in zip(cases, summary["cases"], traces, strict=True):
        rows.append({
            **evaluated,
            "input_text": case["text"],
            "context": case.get("context"),
            "expected_statuses": case["statuses"],
            "expected_steps": case.get("steps"),
            "validated_result": evaluated["result"],
            **trace,
        })

    model_rows = [row for row in rows if row["model_inference_performed"]]
    times = [row["elapsed_ms"] for row in model_rows]
    critical_rows = [row for row in rows if row["category"] in CRITICAL_CATEGORIES]
    ordinary_rows = [row for row in rows if row["category"] not in CRITICAL_CATEGORIES]
    summary.update({
        "corpus": str(corpus_path.relative_to(ROOT)),
        "corpus_sha256": sha256_file(corpus_path),
        "production_prompt_sha256": sha256_bytes(prompt_bytes),
        "saved_schema_sha256": sha256_file(schema_path),
        "raw_rows": rows,
        "critical_score": {"passed": sum(row["passed"] for row in critical_rows),
                           "total": len(critical_rows)},
        "ordinary_score": {"passed": sum(row["passed"] for row in ordinary_rows),
                           "total": len(ordinary_rows)},
        "critical_misses": [row["id"] for row in critical_rows if not row["passed"]],
        "ordinary_misses": [row["id"] for row in ordinary_rows if not row["passed"]],
        "model_inference_requests": len(model_rows),
        "policy_prepass_cases": [row["id"] for row in rows if not row["model_inference_performed"]],
        "first_evaluated_case_latency_ms": rows[0]["elapsed_ms"] if rows else None,
        "first_model_inference_case": ({"id": model_rows[0]["id"],
                                        "latency_ms": model_rows[0]["elapsed_ms"]}
                                       if model_rows else None),
        "model_latency_median_ms": statistics.median(times) if times else None,
        "model_latency_p95_ms": (times[math.ceil(.95 * len(times)) - 1] if times else None),
        "latency_definition": "Per-case elapsed time includes production prepass, HTTP request, parsing, validation and reconciliation; model median/p95 include inference cases only.",
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
    parser.add_argument("--port", type=int, default=8081)
    parser.add_argument("--timeout", type=float, default=30)
    parser.add_argument("--corpus", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--raw-jsonl", type=Path, required=True)
    args = parser.parse_args()
    return run(args)


if __name__ == "__main__":
    raise SystemExit(main())
