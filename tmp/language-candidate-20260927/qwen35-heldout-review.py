"""Summarize an already completed heldout run; this script performs no inference."""

import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
FIXTURE = ROOT / "tests/vision/fixtures/conversation-heldout-20260926.json"
RESULTS = ROOT / "tmp/language-candidate-20260927/qwen35-integrated-heldout-results.json"
MISSES = ROOT / "tmp/language-candidate-20260927/qwen35-integrated-heldout-misses.json"
REVIEW = ROOT / "tmp/language-candidate-20260927/qwen35-integrated-heldout-review.md"


def main():
    fixture_bytes = FIXTURE.read_bytes()
    cases = json.loads(fixture_bytes)
    summary = json.loads(RESULTS.read_text(encoding="utf-8"))
    cases_by_id = {case["id"]: case for case in cases}
    misses = []
    for row in summary["cases"]:
        if row["passed"]:
            continue
        case = cases_by_id[row["id"]]
        misses.append({
            "id": row["id"],
            "category": row["category"],
            "critical": case.get("critical", False),
            "input": case["text"],
            "expected_statuses": case["statuses"],
            "expected_steps": case["steps"],
            "actual": row["validated_result"],
            "error": row["error"],
            "execution_path": row["execution_path"],
            "elapsed_ms": row["elapsed_ms"],
            "model_completion_raw": row["model_completion_raw"],
        })

    critical_cases = [case for case in cases if case.get("critical", False)]
    ordinary_cases = [case for case in cases if not case.get("critical", False)]
    rows_by_id = {row["id"]: row for row in summary["cases"]}
    critical_passes = sum(rows_by_id[case["id"]]["passed"] for case in critical_cases)
    ordinary_passes = sum(rows_by_id[case["id"]]["passed"] for case in ordinary_cases)
    prepass_ids = [row["id"] for row in summary["cases"] if not row["model_inference_performed"]]
    review_data = {
        "corpus": str(FIXTURE.relative_to(ROOT)).replace("\\", "/"),
        "corpus_sha256": hashlib.sha256(fixture_bytes).hexdigest(),
        "overall": {"passed": summary["passed"], "total": summary["total"]},
        "critical": {"passed": critical_passes, "total": len(critical_cases)},
        "ordinary": {"passed": ordinary_passes, "total": len(ordinary_cases)},
        "error_count": sum(row["error"] is not None for row in summary["cases"]),
        "prepass_case_ids": prepass_ids,
        "model_inference_requests": summary["model_inference_requests"],
        "cold_case": summary["cold_case"],
        "all_case_latency_ms": {"median": summary["latency_median_ms"], "p95": summary["latency_p95_ms"]},
        "model_latency_ms": {
            "median": summary["model_latency_median_ms"],
            "p95": summary["model_latency_p95_ms"],
        },
        "failed_case_ids": [miss["id"] for miss in misses],
        "misses": misses,
    }
    MISSES.write_text(json.dumps(review_data, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    lines = [
        "# Qwen3.5 integrated heldout review",
        "",
        f"Heldout fixture SHA-256: `{review_data['corpus_sha256']}`. The fixture was evaluated once with the frozen profile and production interpreter.",
        "",
        f"Overall: **{summary['passed']}/{summary['total']}**; critical: **{critical_passes}/{len(critical_cases)}**; ordinary: **{ordinary_passes}/{len(ordinary_cases)}**; runtime/validation errors: **{review_data['error_count']}**.",
        f"Model calls: {summary['model_inference_requests']}; prepass cases: {', '.join(prepass_ids) or 'none'}.",
        f"Cold case `{summary['cold_case']['id']}`: {summary['cold_case']['elapsed_ms']} ms. All-case median/p95: {summary['latency_median_ms']}/{summary['latency_p95_ms']} ms; model-only median/p95: {summary['model_latency_median_ms']}/{summary['model_latency_p95_ms']} ms.",
        "",
        "The complete per-case evidence, including exact model completion/API response, validated result/error, path, and latency, is in `qwen35-integrated-heldout-results.json` and `qwen35-integrated-heldout-raw.jsonl`. No profile/code tuning followed this run.",
        "",
        "## Misses",
        "",
    ]
    if not misses:
        lines.append("None.")
    for miss in misses:
        lines.extend([
            f"### {miss['id']} — {'critical' if miss['critical'] else 'ordinary'} / {miss['category']}",
            "",
            f"Input: {miss['input']}",
            f"Expected status: `{json.dumps(miss['expected_statuses'], ensure_ascii=False)}`; expected steps: `{json.dumps(miss['expected_steps'], ensure_ascii=False)}`.",
            f"Actual validated result: `{json.dumps(miss['actual'], ensure_ascii=False, separators=(',', ':'))}`.",
            f"Path: `{miss['execution_path']}`; elapsed: {miss['elapsed_ms']} ms; error: `{miss['error']}`.",
            "Raw completion:",
            "```json",
            miss["model_completion_raw"] or "(prepass; no model completion)",
            "```",
            "",
        ])
    lines.extend([
        "## Limits",
        "",
        "This is synthetic PC text evidence only. It does not qualify ASR, visual identity grounding, camera operation, aircraft behavior, Pi performance, or flight safety. A heldout result is not deployment approval.",
        "",
    ])
    REVIEW.write_text("\n".join(lines), encoding="utf-8")
    print(json.dumps({key: value for key, value in review_data.items() if key != "misses"}, ensure_ascii=False))


if __name__ == "__main__":
    main()
