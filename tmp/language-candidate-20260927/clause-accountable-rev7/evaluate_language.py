"""Reproducible text-only model evaluation; never connects to the camera service."""

import argparse
import hashlib
import json
import math
from pathlib import Path
import statistics
import time

from .conversation import LocalSemanticInterpreter, SYSTEM_PROMPT


def evaluate(interpreter, cases):
    rows = []
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
        rows.append({"id": case["id"], "category": case["category"], "passed": passed,
                     "elapsed_ms": round((time.monotonic() - started) * 1000, 1),
                     "result": result, "error": error})
        print(json.dumps(rows[-1]), flush=True)
    times = sorted(row["elapsed_ms"] for row in rows)
    return {"cases": rows, "passed": sum(row["passed"] for row in rows), "total": len(rows),
            "latency_median_ms": statistics.median(times),
            "latency_p95_ms": times[math.ceil(.95 * len(times)) - 1],
            "limits": "Synthetic text cases; no ASR, identity, camera, flight or Pi load qualification."}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--port", type=int, default=8081)
    parser.add_argument("--timeout", type=float, default=30)
    parser.add_argument("--corpus", type=Path,
                        default=Path("tests/vision/fixtures/conversation-eval.json"))
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    cases = json.loads(args.corpus.read_text(encoding="utf-8"))
    result = evaluate(LocalSemanticInterpreter(args.port, args.timeout), cases)
    result["corpus"] = str(args.corpus)
    result["timeout_seconds"] = args.timeout
    result["prompt_sha256"] = hashlib.sha256(SYSTEM_PROMPT.encode()).hexdigest()
    result["corpus_sha256"] = hashlib.sha256(args.corpus.read_bytes()).hexdigest()
    result["seed"] = 42
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({key: value for key, value in result.items() if key != "cases"}), flush=True)
    return 0 if result["passed"] == result["total"] else 1


if __name__ == "__main__":
    raise SystemExit(main())
