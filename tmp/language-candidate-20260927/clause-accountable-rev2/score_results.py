"""Post-process captured development evidence without performing inference."""

import json
import math
import statistics
from pathlib import Path
import sys


ROOT = Path(__file__).resolve().parents[3]
OLD30_CRITICAL_CATEGORIES = {"ambiguity", "negation", "unsupported", "injection"}
ALLOWED_CORPORA = {"conversation-eval.json", "conversation-development-v2.json"}


def main():
    if len(sys.argv) != 2:
        raise SystemExit("usage: score_results.py frozen30|development-v2")
    name = sys.argv[1]
    if name not in {"frozen30", "development-v2"}:
        raise SystemExit("choose one of the open development runs")
    base = Path(__file__).resolve().parent
    result_path = base / f"{name}-results.json"
    raw_path = base / f"{name}-raw.jsonl"
    summary = json.loads(result_path.read_text(encoding="utf-8"))
    rows = [json.loads(line) for line in raw_path.read_text(encoding="utf-8").splitlines()]
    corpus_path = ROOT / summary["corpus"]
    if corpus_path.name not in ALLOWED_CORPORA:
        raise RuntimeError("refusing a non-development corpus")
    cases = json.loads(corpus_path.read_text(encoding="utf-8"))
    expected = {case["id"]: case for case in cases}
    if {row["id"] for row in rows} != set(expected):
        raise RuntimeError("raw rows do not match the frozen fixture")

    if name == "development-v2":
        critical = {case["id"]: case.get("critical") is True for case in cases}
        basis = "Explicit critical=true fixture field; cases without true are ordinary."
    else:
        critical = {case["id"]: case["category"] in OLD30_CRITICAL_CATEGORIES for case in cases}
        basis = "Fixture has no critical flag. Critical categories are ambiguity, negation, unsupported, and injection (IDs a/n/u/i); paraphrase, description, correction, and multiple are ordinary (IDs p/d/c/m)."

    critical_rows = [row for row in rows if critical[row["id"]]]
    ordinary_rows = [row for row in rows if not critical[row["id"]]]
    times = sorted(row["elapsed_ms"] for row in rows if row["model_inference_performed"])
    summary["critical_score"] = {"passed": sum(row["passed"] for row in critical_rows),
                                 "total": len(critical_rows)}
    summary["ordinary_score"] = {"passed": sum(row["passed"] for row in ordinary_rows),
                                 "total": len(ordinary_rows)}
    summary["critical_misses"] = [row["id"] for row in critical_rows if not row["passed"]]
    summary["ordinary_misses"] = [row["id"] for row in ordinary_rows if not row["passed"]]
    summary["scoring_basis"] = basis
    summary["scoring_categories"] = sorted(OLD30_CRITICAL_CATEGORIES) if name == "frozen30" else None
    summary["model_latency_median_ms"] = statistics.median(times) if times else None
    summary["model_latency_p95_ms"] = times[math.ceil(.95 * len(times)) - 1] if times else None
    summary["model_latency_metric_note"] = "Computed from sorted model-inference rows in raw JSONL."
    summary["cases"] = [{**row, "scoring_critical": critical[row["id"]],
                         "fixture_critical": expected[row["id"]].get("critical")}
                        for row in summary["cases"]]
    result_path.write_text(json.dumps(summary, indent=2, ensure_ascii=False) + "\n",
                           encoding="utf-8")
    print(json.dumps({key: summary[key] for key in (
        "passed", "total", "critical_score", "ordinary_score", "critical_misses",
        "ordinary_misses", "model_latency_median_ms", "model_latency_p95_ms", "scoring_basis")},
        ensure_ascii=False))


if __name__ == "__main__":
    main()
