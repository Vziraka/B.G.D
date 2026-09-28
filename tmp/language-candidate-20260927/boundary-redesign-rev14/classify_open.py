"""Model-free route/label check. This module never creates an HTTP client."""

import hashlib
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))
from bgd_vision import conversation

CORPUS = Path(__file__).with_name("worker-open.json")
OUT = Path(__file__).with_name("pre-inference-route-review.json")


def main():
    cases = json.loads(CORPUS.read_text(encoding="utf-8"))
    routes = {"policy": 0, "source": 0, "model": 0}
    rows, deterministic_mismatches = [], []
    for case in cases:
        text = conversation.clean_text(case["text"])
        evidence = conversation._request_evidence(text)
        result = conversation._request_policy_result(text, evidence=evidence)
        route = "policy" if result is not None else "source"
        if result is None:
            result = conversation._source_grounded_plan(text, evidence=evidence)
            if result is None:
                route = "model"
        routes[route] += 1
        actual = None if result is None else {
            "status": result["status"], "steps": result["steps"]}
        expected = {"status": case["statuses"][0], "steps": case["steps"]}
        matches = actual == expected if route != "model" else None
        row = {"id": case["id"], "route": route, "actual": actual,
               "expected": expected, "deterministic_match": matches}
        rows.append(row)
        if matches is False:
            deterministic_mismatches.append(row)
    result = {
        "corpus_sha256": hashlib.sha256(CORPUS.read_bytes()).hexdigest(),
        "case_count": len(cases), "route_counts": routes,
        "model_fallback_case_ids": [row["id"] for row in rows if row["route"] == "model"],
        "deterministic_mismatch_case_ids": [row["id"] for row in deterministic_mismatches],
        "rows": rows,
        "model_inference_performed": False,
    }
    OUT.write_text(json.dumps(result, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps({key: result[key] for key in (
        "corpus_sha256", "case_count", "route_counts", "model_fallback_case_ids",
        "deterministic_mismatch_case_ids", "model_inference_performed")}, indent=2))
    if deterministic_mismatches:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
