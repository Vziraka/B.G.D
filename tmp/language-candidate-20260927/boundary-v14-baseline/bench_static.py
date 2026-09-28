"""Measure only the model-free request boundary on fixed open corpora."""

import hashlib
import json
from pathlib import Path
import statistics
import sys
import time

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))
from bgd_vision import conversation

CORPORA = [
    ROOT / "tests/vision/fixtures/conversation-eval.json",
    ROOT / "tests/vision/fixtures/conversation-development-v2.json",
]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def classify(case):
    text = conversation.clean_text(case["text"])
    result = conversation._request_policy_result(text, case.get("context"))
    if result is not None:
        return "policy"
    result = conversation._source_grounded_plan(text, case.get("context"))
    return "source" if result is not None else "model"


def main():
    cases = [case for path in CORPORA for case in json.loads(path.read_text(encoding="utf-8"))]
    for case in cases:
        classify(case)
    times = []
    route_counts = {"policy": 0, "source": 0, "model": 0}
    for _ in range(100):
        for case in cases:
            started = time.perf_counter_ns()
            route = classify(case)
            times.append((time.perf_counter_ns() - started) / 1_000_000)
            route_counts[route] += 1
    times.sort()
    result = {
        "source_sha256": sha(ROOT / "bgd_vision/conversation.py"),
        "corpus_sha256": {str(path.relative_to(ROOT)): sha(path) for path in CORPORA},
        "rounds": 100,
        "case_count": len(cases),
        "call_count": len(times),
        "route_counts": route_counts,
        "median_ms": statistics.median(times),
        "p95_ms": times[int((len(times) - 1) * .95)],
        "p99_ms": times[int((len(times) - 1) * .99)],
    }
    print(json.dumps(result, indent=2))


if __name__ == "__main__":
    main()
