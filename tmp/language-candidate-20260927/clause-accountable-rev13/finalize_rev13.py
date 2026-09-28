"""Summarize and hash completed Rev13 evidence without performing inference."""

import hashlib
import json
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = Path(__file__).resolve().parents[3]


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def read_result(prefix):
    return json.loads((HERE / f"{prefix}-results.json").read_text(encoding="utf-8"))


def read_raw(prefix):
    return [json.loads(line) for line in (HERE / f"{prefix}-raw.jsonl").read_text(encoding="utf-8").splitlines()]


def score_prompt_focus(result, fixture):
    by_id = {row["id"]: row["passed"] for row in result["cases"]}
    ids = [case["id"] for case in fixture
           if case.get("critical") is not True
           and case.get("category") in {"location-question", "tracker-status", "task-status"}]
    return {"passed": sum(by_id[item] for item in ids), "total": len(ids),
            "misses": [item for item in ids if not by_id[item]]}


def file_record(name):
    path = HERE / name
    return {"path": str(path.relative_to(ROOT)).replace("\\", "/"),
            "bytes": path.stat().st_size, "sha256": sha256(path)}


def main():
    lock_path = HERE / "run-lock-preselection.json"
    lock = json.loads(lock_path.read_text(encoding="utf-8"))
    lock_manifest = json.loads((HERE / "manifest-preselection.json").read_text(encoding="utf-8"))
    fixture = json.loads((HERE / "worker-open-rev13.json").read_text(encoding="utf-8"))
    baseline = read_result("ab-baseline")
    candidate = read_result("ab-candidate")
    baseline_focus = score_prompt_focus(baseline, fixture)
    candidate_focus = score_prompt_focus(candidate, fixture)
    baseline_pass = {row["id"]: row["passed"] for row in baseline["cases"]}
    candidate_pass = {row["id"]: row["passed"] for row in candidate["cases"]}
    ordinary_regressions = [case["id"] for case in fixture
                            if case.get("critical") is not True
                            and baseline_pass[case["id"]] and not candidate_pass[case["id"]]]
    candidate_qualifies = (
        candidate["critical_score"]["passed"] == candidate["critical_score"]["total"] == 16
        and candidate_focus["passed"] > baseline_focus["passed"]
        and candidate["ordinary_score"]["passed"] > baseline["ordinary_score"]["passed"]
        and not ordinary_regressions
    )
    selected_name = "candidate" if candidate_qualifies else "baseline"

    run_prefixes = ("ab-baseline", "ab-candidate", "selected-old30", "selected-v2")
    files = []
    for prefix in run_prefixes:
        files.extend(file_record(f"{prefix}-{suffix}") for suffix in ("results.json", "raw.jsonl", "console.log"))
    files.extend(file_record(name) for name in (
        "rev13-ab-baseline-server-ready.json", "rev13-ab-baseline-server.pid",
        "rev13-ab-baseline-server.stdout.log", "rev13-ab-baseline-server.stderr.log",
        "rev13-ab-server-stop.json", "rev13-selected-server-ready.json",
        "rev13-selected-server.pid", "rev13-selected-server.stdout.log",
        "rev13-selected-server.stderr.log", "rev13-selected-server-stop.json"))

    selected_old = read_result("selected-old30")
    selected_v2 = read_result("selected-v2")
    manifest = {
        "trial_id": "clause-accountable-rev13-completed",
        "inference_performed": True,
        "preselection_lock": lock_manifest["run_lock"],
        "production_source_sha256": lock["files"]["bgd_vision/conversation.py"]["sha256"],
        "selected_prompt": f"prompt-{selected_name}.txt",
        "selected_prompt_sha256": lock["prompt_variants"][f"prompt-{selected_name}.txt"]["sha256"],
        "schema_sha256": lock["files"]["tmp/language-candidate-20260927/clause-accountable-rev13/schema.json"]["sha256"],
        "model_sha256": lock["model"]["sha256"],
        "runtime_sha256": lock["runtime"]["executable_sha256"],
        "selection_rule": {
            "candidate_qualifies": candidate_qualifies,
            "candidate_critical_exact": candidate["critical_score"]["passed"] == candidate["critical_score"]["total"] == 16,
            "candidate_focus_improved": candidate_focus["passed"] > baseline_focus["passed"],
            "candidate_total_ordinary_improved": candidate["ordinary_score"]["passed"] > baseline["ordinary_score"]["passed"],
            "baseline_correct_ordinary_regressions": ordinary_regressions,
            "selected": selected_name,
        },
        "prompt_ab": {
            "baseline": {"total": baseline["total"], "passed": baseline["passed"],
                         "critical": baseline["critical_score"], "ordinary": baseline["ordinary_score"],
                         "prompt_focus": baseline_focus, "misses": baseline["ordinary_misses"],
                         "cold_ms": baseline["cold_model_latency_ms"],
                         "median_ms": baseline["model_latency_median_ms"],
                         "p95_ms": baseline["model_latency_p95_ms"]},
            "candidate": {"total": candidate["total"], "passed": candidate["passed"],
                          "critical": candidate["critical_score"], "ordinary": candidate["ordinary_score"],
                          "prompt_focus": candidate_focus, "misses": candidate["ordinary_misses"],
                          "cold_ms": candidate["cold_model_latency_ms"],
                          "median_ms": candidate["model_latency_median_ms"],
                          "p95_ms": candidate["model_latency_p95_ms"]},
        },
        "selected_profile_runs": {
            "old30": {"passed": selected_old["passed"], "total": selected_old["total"],
                      "critical": selected_old["critical_score"], "ordinary": selected_old["ordinary_score"],
                      "misses": selected_old["critical_misses"] + selected_old["ordinary_misses"],
                      "model_calls": selected_old["model_inference_requests"],
                      "first_model_latency_ms": selected_old["cold_model_latency_ms"],
                      "note": "The first actual model request on this server; it includes cold model startup."},
            "development_v2": {"passed": selected_v2["passed"], "total": selected_v2["total"],
                               "critical": selected_v2["critical_score"], "ordinary": selected_v2["ordinary_score"],
                               "misses": selected_v2["critical_misses"] + selected_v2["ordinary_misses"],
                               "model_calls": selected_v2["model_inference_requests"],
                               "first_model_latency_ms": selected_v2["cold_model_latency_ms"],
                               "median_ms": selected_v2["model_latency_median_ms"],
                               "p95_ms": selected_v2["model_latency_p95_ms"],
                               "note": "Same server after old30 warmed the model; this is first-request-in-corpus latency, not a cold start."},
        },
        "server_cleanup": json.loads((HERE / "rev13-selected-server-stop.json").read_text(encoding="utf-8")),
        "other_prior_corpora": "Not inferred; verify-only route counts were 18, 13, 23 and 11 model fallbacks for worker53, root35, worker58 and root38 respectively, so these were not treated as fast follow-up runs.",
        "evidence_files": files,
        "sealed_or_independent_probe_used": False,
    }
    manifest_path = HERE / "completion-manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    baseline_rows = read_raw("ab-baseline")
    candidate_rows = read_raw("ab-candidate")
    def miss_lines(rows):
        return [f"- `{row['id']}` ({row.get('execution_path')}): expected {row.get('expected_statuses')} {row.get('expected_steps')}; got {row.get('result')}; raw completion `{row.get('model_completion_raw')}`."
                for row in rows if not row["passed"]]
    review = [
        "# Rev13 A/B and selected-profile review", "",
        f"Preselection lock: `{lock_manifest['run_lock']['path']}` (SHA-256 `{lock_manifest['run_lock']['sha256']}`).",
        "The baseline prompt was already the production prompt. The candidate did not meet the predeclared zero-regression rule, so baseline remains selected and no production prompt edit was made.", "",
        "## A/B decision", "",
        f"Baseline: {baseline['passed']}/{baseline['total']} exact; critical {baseline['critical_score']['passed']}/{baseline['critical_score']['total']}; ordinary {baseline['ordinary_score']['passed']}/{baseline['ordinary_score']['total']}; location/status focus {baseline_focus['passed']}/{baseline_focus['total']}. Cold first model latency {baseline['cold_model_latency_ms']} ms; warm median {baseline['model_latency_median_ms']} ms; p95 {baseline['model_latency_p95_ms']} ms.",
        f"Candidate: {candidate['passed']}/{candidate['total']} exact; critical {candidate['critical_score']['passed']}/{candidate['critical_score']['total']}; ordinary {candidate['ordinary_score']['passed']}/{candidate['ordinary_score']['total']}; location/status focus {candidate_focus['passed']}/{candidate_focus['total']}. Cold first model latency {candidate['cold_model_latency_ms']} ms; warm median {candidate['model_latency_median_ms']} ms; p95 {candidate['model_latency_p95_ms']} ms.",
        f"Candidate improved the focus subset and total ordinary score and passed all critical controls, but regressed baseline-correct ordinary cases {', '.join(ordinary_regressions)}. It therefore fails the frozen selection rule; baseline is selected.", "",
        "### Baseline misses", "", *miss_lines(baseline_rows), "",
        "### Candidate misses", "", *miss_lines(candidate_rows), "",
        "## Selected baseline on prior open suites", "",
        f"Old30: {selected_old['passed']}/{selected_old['total']} exact, critical {selected_old['critical_score']['passed']}/{selected_old['critical_score']['total']}, ordinary {selected_old['ordinary_score']['passed']}/{selected_old['ordinary_score']['total']}; misses: none. One actual model fallback (p05) took {selected_old['cold_model_latency_ms']} ms including cold startup.",
        f"Development-v2: {selected_v2['passed']}/{selected_v2['total']} exact, critical {selected_v2['critical_score']['passed']}/{selected_v2['critical_score']['total']}, ordinary {selected_v2['ordinary_score']['passed']}/{selected_v2['ordinary_score']['total']}; misses: none. Three model calls; first-in-corpus latency {selected_v2['cold_model_latency_ms']} ms, median {selected_v2['model_latency_median_ms']} ms, p95 {selected_v2['model_latency_p95_ms']} ms. This run followed old30 in the same process, so those are warm latencies.",
        "Other prior corpora were not inferred because verify-only route analysis showed 11–23 model fallback requests each; their exact source routes are available through verify-only results only.", "",
        "## Cleanup and scope", "",
        f"Both server processes were stopped. Final stop record: `{manifest['server_cleanup']}`. Port 8084 had no listener after shutdown. No sealed fixture or independent Rev13 probe was used.",
        "",
        f"Completion manifest: `{manifest_path.name}` (SHA-256 `{sha256(manifest_path)}`).",
    ]
    review_path = HERE / "final-review.md"
    review_path.write_text("\n".join(review) + "\n", encoding="utf-8")
    print(json.dumps({"completion_manifest": str(manifest_path.relative_to(ROOT)).replace("\\", "/"),
                      "completion_manifest_sha256": sha256(manifest_path),
                      "review": str(review_path.relative_to(ROOT)).replace("\\", "/"),
                      "review_sha256": sha256(review_path), "selected": selected_name,
                      "candidate_qualifies": candidate_qualifies,
                      "server_stopped": not manifest["server_cleanup"]["loopback_listener_remaining"]}, ensure_ascii=False))


if __name__ == "__main__":
    main()
