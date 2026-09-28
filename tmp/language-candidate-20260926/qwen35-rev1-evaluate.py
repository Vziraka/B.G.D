"""One frozen30 run with raw completion capture; production code remains untouched."""

import argparse
import hashlib
import http.client
import json
import math
from pathlib import Path
import statistics
import sys
import threading
import time


REPO_ROOT = Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO_ROOT))

from bgd_vision import conversation


PROMPT_PATH = Path(__file__).resolve().with_name("qwen35-rev1-profile-system-prompt.txt")
PROMPT = PROMPT_PATH.read_text(encoding="utf-8")
PROMPT_SHA256 = hashlib.sha256(PROMPT.encode("utf-8")).hexdigest()
if PROMPT_SHA256 != "44a458cf75f1c476d622850c89d85f0a6d15d4c168ac5c566684e1d5e4c3e66a":
    raise RuntimeError("Pinned revision-1 prompt hash mismatch; refusing to run")
if PROMPT.endswith("/no_think"):
    raise RuntimeError("Qwen3.5 profile must not contain /no_think")
conversation.SYSTEM_PROMPT = PROMPT


class CapturingLocalInterpreter:
    """Same local request profile and validator, retaining the response content."""

    def __init__(self, port=8081, timeout=30):
        if type(port) is not int or not 1 <= port <= 65535:
            raise ValueError("Use a valid local model port")
        if not 0 < timeout <= 30:
            raise ValueError("Model timeout must be between 0 and 30 seconds")
        self.port, self.timeout = port, timeout
        self.busy = threading.Lock()
        self.last_capture = None

    def __call__(self, text, context=None):
        capture = {
            "raw_api_response": None,
            "http_status": None,
            "finish_reason": None,
            "model_completion_raw": None,
            "model_completion_parsed": None,
            "validated_result": None,
            "error_stage": None,
            "interpreter_error": None,
        }
        self.last_capture = capture
        if not self.busy.acquire(blocking=False):
            capture["error_stage"] = "busy"
            capture["interpreter_error"] = "Language interpretation is busy; try again shortly"
            raise ValueError(capture["interpreter_error"])
        connection = http.client.HTTPConnection("127.0.0.1", self.port, timeout=self.timeout)
        try:
            payload = {
                "messages": [{"role": "system", "content": PROMPT},
                             {"role": "user", "content": json.dumps({
                                 "pending_proposal": context,
                                 "request": conversation.clean_text(text)})}],
                "response_format": {"type": "json_schema", "json_schema": {
                    "name": "desk_proposal", "strict": True,
                    "schema": conversation.SEMANTIC_SCHEMA}},
                "chat_template_kwargs": {"enable_thinking": False},
                "temperature": 0.7, "top_p": 0.8, "top_k": 20, "min_p": 0,
                "presence_penalty": 1.5, "max_tokens": 300, "stream": False,
                "seed": 42,
            }
            connection.request("POST", "/v1/chat/completions", json.dumps(payload),
                               {"Content-Type": "application/json"})
            response = connection.getresponse()
            raw = response.read(32769)
            capture["http_status"] = response.status
            capture["raw_api_response"] = raw.decode("utf-8", errors="replace")
            if response.status != 200 or len(raw) > 32768:
                capture["error_stage"] = "http_response"
                raise ValueError("The local language model is unavailable")
            reply = json.loads(raw)["choices"][0]
            capture["finish_reason"] = reply.get("finish_reason")
            capture["model_completion_raw"] = reply["message"]["content"]
            if capture["finish_reason"] != "stop":
                capture["error_stage"] = "finish_reason"
                raise ValueError("The language model did not finish its interpretation")
            capture["error_stage"] = "completion_json"
            completion = json.loads(capture["model_completion_raw"])
            capture["model_completion_parsed"] = completion
            capture["error_stage"] = "semantic_validation"
            result = conversation.validate_semantic_result(completion)
            capture["validated_result"] = result
            capture["error_stage"] = None
            return result
        except (OSError, http.client.HTTPException, KeyError, IndexError, TypeError,
                json.JSONDecodeError, UnicodeDecodeError) as exc:
            capture["error_stage"] = capture["error_stage"] or "response_decode"
            capture["interpreter_error"] = "The local language model could not interpret this request"
            raise ValueError(capture["interpreter_error"]) from exc
        except ValueError as exc:
            capture["interpreter_error"] = str(exc)
            raise
        finally:
            connection.close()
            self.busy.release()


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--port", type=int, default=8081)
    parser.add_argument("--timeout", type=float, default=30)
    parser.add_argument("--corpus", type=Path,
                        default=Path("tests/vision/fixtures/conversation-eval.json"))
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--raw-jsonl", type=Path, required=True)
    args = parser.parse_args()
    if args.output.exists() or args.raw_jsonl.exists():
        raise FileExistsError("Refusing to overwrite prior revision-1 evidence")
    cases = json.loads(args.corpus.read_text(encoding="utf-8"))
    interpreter = CapturingLocalInterpreter(args.port, args.timeout)
    rows = []
    times = []
    with args.raw_jsonl.open("x", encoding="utf-8", newline="\n") as raw_log:
        for case in cases:
            started = time.monotonic()
            try:
                result = interpreter(case["text"], case.get("context"))
                passed = result["status"] in case["statuses"]
                if "steps" in case:
                    passed = passed and result["steps"] == case["steps"]
                error = None
            except ValueError as exc:
                result, passed, error = None, False, str(exc)
            elapsed_ms = round((time.monotonic() - started) * 1000, 1)
            times.append(elapsed_ms)
            capture = interpreter.last_capture or {}
            row = {
                "id": case["id"],
                "category": case["category"],
                "input_text": case["text"],
                "context": case.get("context"),
                "passed": passed,
                "elapsed_ms": elapsed_ms,
                "model_completion_raw": capture.get("model_completion_raw"),
                "model_completion_parsed": capture.get("model_completion_parsed"),
                "validated_result": result,
                "error": error,
                "error_stage": capture.get("error_stage"),
                "interpreter_error": capture.get("interpreter_error"),
                "http_status": capture.get("http_status"),
                "finish_reason": capture.get("finish_reason"),
                "raw_api_response": capture.get("raw_api_response"),
            }
            rows.append(row)
            line = json.dumps(row, ensure_ascii=False)
            raw_log.write(line + "\n")
            raw_log.flush()
            print(line, flush=True)
    ordered = sorted(times)
    summary = {
        "cases": rows,
        "passed": sum(row["passed"] for row in rows),
        "total": len(rows),
        "latency_median_ms": statistics.median(ordered),
        "latency_p95_ms": ordered[math.ceil(0.95 * len(ordered)) - 1],
        "limits": "Synthetic text cases; no ASR, identity, camera, flight or Pi load qualification.",
        "corpus": str(args.corpus),
        "timeout_seconds": args.timeout,
        "prompt_sha256": PROMPT_SHA256,
        "corpus_sha256": hashlib.sha256(args.corpus.read_bytes()).hexdigest(),
        "seed": 42,
    }
    args.output.write_text(json.dumps(summary, indent=2, ensure_ascii=False) + "\n",
                           encoding="utf-8")
    print(json.dumps({key: value for key, value in summary.items() if key != "cases"}), flush=True)
    return 0 if summary["passed"] == summary["total"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
