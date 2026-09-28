"""Evaluate Phi-4-mini via the unchanged production interpreter on frozen30."""

import argparse
import hashlib
import json
import math
from pathlib import Path
import statistics
import sys


REPO_ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO_ROOT))

from bgd_vision import conversation, evaluate_language


def digest(data):
    if isinstance(data, str):
        data = data.encode("utf-8")
    return hashlib.sha256(data).hexdigest()


class CapturingResponse:
    def __init__(self, response, captures, request_metadata):
        self.response, self.captures = response, captures
        self.request_metadata = request_metadata

    def __getattr__(self, name):
        return getattr(self.response, name)

    def read(self, limit):
        raw = self.response.read(limit)
        capture = {
            **self.request_metadata,
            "http_status": self.response.status,
            "raw_api_response": raw.decode("utf-8", errors="replace"),
            "finish_reason": None,
            "model_completion_raw": None,
            "model_completion_parsed": None,
        }
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
        raise FileExistsError("Refusing to overwrite prior Phi frozen30 evidence")
    cases = json.loads(corpus_path.read_text(encoding="utf-8"))
    corpus_hash = digest(corpus_path.read_bytes())
    if corpus_hash != "f734fc1ab630a236a14b50f8b7e4031b0e92e0fa717130171589bcf28cc95a1b":
        raise RuntimeError("Development corpus differs from the frozen 30-case fixture")

    prompt_hash = digest(conversation.SYSTEM_PROMPT)
    if prompt_hash != "44a458cf75f1c476d622850c89d85f0a6d15d4c168ac5c566684e1d5e4c3e66a":
        raise RuntimeError("Production prompt differs from the frozen desk profile")
    schema_path = REPO_ROOT / "tmp/language-candidate-20260926/qwen35-rev1-schema.json"
    saved_schema_bytes = schema_path.read_bytes()
    saved_schema = json.loads(saved_schema_bytes)
    if saved_schema != conversation.SEMANTIC_SCHEMA:
        raise RuntimeError("Production semantic schema differs from the frozen schema")
    schema_hash = digest(saved_schema_bytes)

    captures = []
    request_count = [0]
    real_connection = conversation.http.client.HTTPConnection
    baseline_settings = {
        "temperature": 0.7,
        "top_p": 0.8,
        "top_k": 20,
        "min_p": 0,
        "presence_penalty": 1.5,
        "max_tokens": 300,
        "stream": False,
        "seed": 42,
    }

    class AuditedConnection:
        def __init__(self, *connection_args, **connection_kwargs):
            self.connection = real_connection(*connection_args, **connection_kwargs)
            if self.connection.host != "127.0.0.1":
                raise RuntimeError("Phi evaluation only supports the existing loopback server")
            self.request_metadata = {}

        def request(self, *request_args, **request_kwargs):
            positional = list(request_args)
            if len(positional) < 3:
                raise RuntimeError("Unexpected production HTTP request shape")
            method, path, original_body = positional[:3]
            headers = positional[3] if len(positional) > 3 else request_kwargs.get("headers", {})
            if method != "POST" or path != "/v1/chat/completions":
                raise RuntimeError("Unexpected production HTTP destination")
            original_text = original_body.decode("utf-8") if isinstance(original_body, bytes) else original_body
            payload = json.loads(original_text)
            if "chat_template_kwargs" not in payload or payload["chat_template_kwargs"] != {"enable_thinking": False}:
                raise RuntimeError("Unexpected baseline chat-template controls")
            if payload.get("temperature") != baseline_settings["temperature"]:
                raise RuntimeError("Unexpected baseline temperature")
            for key, value in baseline_settings.items():
                if payload.get(key) != value:
                    raise RuntimeError(f"Unexpected baseline request setting: {key}")

            before = json.loads(json.dumps(payload))
            payload["temperature"] = 0.0
            payload.pop("chat_template_kwargs")
            modified_text = json.dumps(payload)
            for key in before:
                if key not in {"temperature", "chat_template_kwargs"} and payload.get(key) != before[key]:
                    raise RuntimeError(f"Phi adapter unexpectedly changed request field: {key}")
            if set(payload) != set(before) - {"chat_template_kwargs"}:
                raise RuntimeError("Phi adapter changed unexpected request fields")

            settings = {key: payload[key] for key in baseline_settings}
            settings_hash = digest(json.dumps(settings, sort_keys=True, separators=(",", ":")))
            self.request_metadata = {
                "original_payload_sha256": digest(original_text),
                "effective_payload_sha256": digest(modified_text),
                "effective_settings": settings,
                "effective_settings_sha256": settings_hash,
                "model_specific_changes": [
                    "temperature: 0.7 to 0.0 per Microsoft Phi-4-mini model card",
                    "omit Qwen-only chat_template_kwargs.enable_thinking; use Phi GGUF chat template via llama.cpp --jinja",
                ],
            }
            positional[2] = modified_text
            request_count[0] += 1
            return self.connection.request(*positional, **request_kwargs)

        def getresponse(self):
            return CapturingResponse(self.connection.getresponse(), captures, self.request_metadata)

        def close(self):
            return self.connection.close()

    conversation.http.client.HTTPConnection = AuditedConnection
    production_interpreter = conversation.LocalSemanticInterpreter(args.port, args.timeout)
    traces = []

    class AuditedInterpreter:
        """Call production parsing, shared fail-closed prepass, and validator unchanged."""

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
            "original_payload_sha256": trace.get("original_payload_sha256"),
            "effective_payload_sha256": trace.get("effective_payload_sha256"),
            "effective_settings": trace.get("effective_settings"),
            "effective_settings_sha256": trace.get("effective_settings_sha256"),
            "model_specific_changes": trace.get("model_specific_changes"),
        })
    summary["cases"] = rows
    model_times = sorted(row["elapsed_ms"] for row in rows if row["model_inference_performed"])
    first_model_row = next((row for row in rows if row["model_inference_performed"]), None)
    settings = {
        "temperature": 0.0,
        "top_p": 0.8,
        "top_k": 20,
        "min_p": 0,
        "presence_penalty": 1.5,
        "max_tokens": 300,
        "stream": False,
        "seed": 42,
        "chat_template_kwargs": None,
        "chat_format": "messages rendered using GGUF Phi template by llama.cpp --jinja",
    }
    summary.update({
        "corpus": str(args.corpus),
        "corpus_sha256": corpus_hash,
        "prompt_sha256": prompt_hash,
        "schema_file": str(schema_path.relative_to(REPO_ROOT)),
        "schema_sha256": schema_hash,
        "sampling_and_chat_settings": settings,
        "settings_sha256": digest(json.dumps(settings, sort_keys=True, separators=(",", ":"))),
        "seed": 42,
        "timeout_seconds": args.timeout,
        "model_inference_requests": request_count[0],
        "prepass_cases": sum(not row["model_inference_performed"] for row in rows),
        "prepass_case_ids": [row["id"] for row in rows if not row["model_inference_performed"]],
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
