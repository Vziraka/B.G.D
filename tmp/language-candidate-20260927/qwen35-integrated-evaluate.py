"""Run the production semantic interpreter against the frozen30 development corpus."""

import argparse
import hashlib
import json
import math
from pathlib import Path
import statistics
import statistics
import sys


REPO_ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO_ROOT))

from bgd_vision import conversation, evaluate_language


class CapturingResponse:
    def __init__(self, response, captures):
        self.response, self.captures = response, captures

    def __getattr__(self, name):
        return getattr(self.response, name)

    def read(self, limit):
        raw = self.response.read(limit)
        capture = {"http_status": self.response.status,
                   "raw_api_response": raw.decode("utf-8", errors="replace"),
                   "finish_reason": None, "model_completion_raw": None,
                   "model_completion_parsed": None}
        try:
            payload = json.loads(raw)
            choice = payload["choices"][0]
            capture["finish_reason"] = choice.get("finish_reason")
            capture["model_completion_raw"] = choice["message"]["content"]
            try:
                capture["model_completion_parsed"] = json.loads(capture["model_completion_raw"])
            except (TypeError, json.JSONDecodeError):
                pass
        except (TypeError, KeyError, IndexError, json.JSONDecodeError):
            pass
        self.captures.append(capture)
        return raw


def run(args):
    corpus_path = args.corpus.resolve()
    output_path = args.output.resolve()
    raw_path = args.raw_jsonl.resolve()
    if output_path.exists() or raw_path.exists():
        raise FileExistsError("Refusing to overwrite prior integrated-evaluation evidence")
    cases = json.loads(corpus_path.read_text(encoding="utf-8"))
    prompt_hash = hashlib.sha256(conversation.SYSTEM_PROMPT.encode("utf-8")).hexdigest()
    if prompt_hash != "44a458cf75f1c476d622850c89d85f0a6d15d4c168ac5c566684e1d5e4c3e66a":
        raise RuntimeError("Production prompt does not match the pinned Qwen3.5 revision-1 profile")
    schema_path = REPO_ROOT / "tmp/language-candidate-20260926/qwen35-rev1-schema.json"
    saved_schema = json.loads(schema_path.read_text(encoding="utf-8"))
    if saved_schema != conversation.SEMANTIC_SCHEMA:
        raise RuntimeError("Production semantic schema differs from the pinned schema")

    captures = []
    request_count = [0]
    real_connection = conversation.http.client.HTTPConnection

    class AuditedConnection:
        def __init__(self, *connection_args, **connection_kwargs):
            self.connection = real_connection(*connection_args, **connection_kwargs)

        def request(self, *request_args, **request_kwargs):
            request_count[0] += 1
            return self.connection.request(*request_args, **request_kwargs)

        def getresponse(self):
            return CapturingResponse(self.connection.getresponse(), captures)

        def close(self):
            return self.connection.close()

    conversation.http.client.HTTPConnection = AuditedConnection
    production_interpreter = conversation.LocalSemanticInterpreter(args.port, args.timeout)
    traces = []

    class AuditedInterpreter:
        """Delegate every case to the production interpreter and attach raw evidence."""

        def __call__(self, text, context=None):
            before_requests = request_count[0]
            before_captures = len(captures)
            prepass = conversation._flight_clause_result(conversation.clean_text(text))
            try:
                return production_interpreter(text, context)
            finally:
                made_request = request_count[0] > before_requests
                capture = captures[-1] if made_request and len(captures) > before_captures else {}
                traces.append({
                    "execution_path": "local_model" if made_request else "flight_clause_polarity_prepass",
                    "model_inference_performed": made_request,
                    "prepass_result": prepass,
                    **capture,
                })

    try:
        summary = evaluate_language.evaluate(AuditedInterpreter(), cases)
    finally:
        conversation.http.client.HTTPConnection = real_connection

    rows = []
    for case, row, trace in zip(cases, summary["cases"], traces, strict=True):
        rows.append({
            **row,
            "input_text": case["text"],
            "context": case.get("context"),
            "validated_result": row["result"],
            "execution_path": trace["execution_path"],
            "model_inference_performed": trace["model_inference_performed"],
            "prepass_result": trace.get("prepass_result"),
            "http_status": trace.get("http_status"),
            "finish_reason": trace.get("finish_reason"),
            "model_completion_raw": trace.get("model_completion_raw"),
            "model_completion_parsed": trace.get("model_completion_parsed"),
            "raw_api_response": trace.get("raw_api_response"),
        })
    summary["cases"] = rows
    model_times = sorted(row["elapsed_ms"] for row in rows if row["model_inference_performed"])
    first_model_row = next((row for row in rows if row["model_inference_performed"]), None)
    summary.update({
        "corpus": str(args.corpus),
        "corpus_sha256": hashlib.sha256(corpus_path.read_bytes()).hexdigest(),
        "prompt_sha256": prompt_hash,
        "schema_sha256": hashlib.sha256(schema_path.read_bytes()).hexdigest(),
        "seed": 42,
        "timeout_seconds": args.timeout,
        "model_inference_requests": request_count[0],
        "prepass_cases": sum(not row["model_inference_performed"] for row in rows),
        "cold_case": {"id": rows[0]["id"], "elapsed_ms": rows[0]["elapsed_ms"]} if rows else None,
        "first_model_case": ({"id": first_model_row["id"], "elapsed_ms": first_model_row["elapsed_ms"]}
                             if first_model_row else None),
        "model_latency_median_ms": statistics.median(model_times) if model_times else None,
        "model_latency_p95_ms": model_times[math.ceil(.95 * len(model_times)) - 1] if model_times else None,
    })
    with raw_path.open("x", encoding="utf-8", newline="\n") as raw_log:
        for row in rows:
            raw_log.write(json.dumps(row, ensure_ascii=False) + "\n")
    output_path.write_text(json.dumps(summary, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps({key: value for key, value in summary.items() if key != "cases"}), flush=True)
    return 0 if summary["passed"] == summary["total"] else 1


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--port", type=int, default=8081)
    parser.add_argument("--timeout", type=float, default=30)
    parser.add_argument("--corpus", type=Path, default=Path("tests/vision/fixtures/conversation-eval.json"))
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--raw-jsonl", type=Path, required=True)
    args = parser.parse_args()
    return run(args)


if __name__ == "__main__":
    raise SystemExit(main())
