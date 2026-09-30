"""Summarize completed frozen trials without changing labels or sources."""

import json
from collections import Counter
from pathlib import Path

import measure_bare as trial

HERE = Path(__file__).resolve().parent


def summarize_rows(rows, version):
    guarded = lambda row: row[version]["passed"]
    return {
        "total": len(rows),
        "bare_exact": sum(row["passed"] for row in rows),
        "guarded_exact": sum(guarded(row) for row in rows),
        "guard_saved_wrong_bare_answer": sum(not row["passed"] and guarded(row) for row in rows),
        "guard_lost_correct_bare_answer": sum(row["passed"] and not guarded(row) for row in rows),
        "correct_model_discarded_by_reconciliation": sum(row["passed"] and not guarded(row)
            and row[version]["route"] == "model_fallback" for row in rows),
        "correct_model_replaced_by_prepass": sum(row["passed"] and not guarded(row)
            and row[version]["route"] != "model_fallback" for row in rows),
        "routes": dict(Counter(row[version]["route"] for row in rows)),
        "errors": dict(Counter(row["error"]["message"] for row in rows if row["error"])),
        "valid_completion_nonexact": sum(not row["passed"] and row["error"] is None for row in rows),
    }


def groups(rows, version):
    required = [row for row in rows if row["in_reduced_scope"]]
    # Pure label subsets, applied uniformly; they are descriptive, not pass gates.
    plans = [row for row in required if "planned" in row["expected_statuses"] and row["expected_steps"]]
    other = [row for row in required if row not in plans]
    return {"overall": summarize_rows(rows, version),
            "reduced_domain": summarize_rows(required, version),
            "required_plan_labels": summarize_rows(plans, version),
            "required_clarification_and_refusal_labels": summarize_rows(other, version),
            "secondary_only": summarize_rows([row for row in rows if not row["in_reduced_scope"]], version)}


def main():
    main_dir, owner_dir = HERE / "step0-20260930", HERE / "owner-text-20260930"
    frozen = json.loads((main_dir / "manifest-final.json").read_text(encoding="utf-8"))
    owner = json.loads((owner_dir / "manifest-final.json").read_text(encoding="utf-8"))
    if not frozen["inputs_unchanged"] or not owner["inputs_unchanged"]:
        raise RuntimeError("A trial input changed")
    result = {
        "purpose": "Complete descriptive measurement summary; no numeric qualification gate or source/prompt tuning.",
        "sources": {str(path): trial.sha(path) for path in [main_dir / "manifest-final.json", owner_dir / "manifest-final.json",
            HERE / "corpus-audit/scope.json", HERE / "owner-approved-commands-20260930.json",
            owner_dir / "lifecycle-checks.log", Path(__file__)]},
        "historical": frozen["historical"],
        "profile_parameters": frozen["profiles"],
        "input_hashes_verified": True,
        "profiles": {}, "owner": {}, "stop_bypass": owner["stop_bypass"],
        "lifecycle_checks": "4 passed; 17 subtests passed; 93 deselected, from unchanged conversation tests",
        "limitations": [
            "Consumed diagnostic examples and strict compatibility labels, not a new sealed qualification or acceptance bar.",
            "Reduced-domain rubric was frozen before inference and includes clarification and mixed-request refusal cases. No wider row is omitted from overall reporting.",
            "Required-plan versus clarification/refusal label subsets are uniform supplemental descriptive analysis, not a replacement scope or a new gate.",
            "Owner approved agent-seeded wording, not independent or spoken samples. Target serialization differences count as strict label misses and need qualitative interpretation.",
            "Historical sealed-v3 used Rev7; new guard replay uses frozen Rev13/current Rev14 with the same new completion as the bare model.",
            "Greedy and zero presence penalty changed together; their individual effects were not isolated.",
            "Small owner-text trial overlapped part of the old-settings PC pass. Timings are recorded durations, not a controlled latency comparison.",
            "The full vision suite, Node checks and static replacement latency replay belong to implementation verification if Step0 justifies replacement; they are not claimed by these measurements.",
        ],
    }
    for profile in trial.PROFILES:
        all_rows = []
        result["profiles"][profile] = {"corpora": {}}
        for name in trial.CORPORA:
            rows = [json.loads(line) for line in (main_dir / f"{profile}-{name}-raw.jsonl").read_text(encoding="utf-8").splitlines()]
            if len(rows) != len(json.loads((trial.ROOT / trial.CORPORA[name][0]).read_text(encoding="utf-8"))):
                raise RuntimeError("Incomplete corpus results")
            all_rows.extend(rows)
            result["profiles"][profile]["corpora"][name] = {
                version: groups(rows, version) for version in ("rev13_counterfactual", "rev14_counterfactual")}
        result["profiles"][profile]["combined"] = {
            version: groups(all_rows, version) for version in ("rev13_counterfactual", "rev14_counterfactual")}
        owner_rows = [json.loads(line) for line in (owner_dir / f"{profile}-raw.jsonl").read_text(encoding="utf-8").splitlines()]
        result["owner"][profile] = {
            version: groups(owner_rows, version) for version in ("rev13_counterfactual", "rev14_counterfactual")}
        result["owner"][profile]["mismatches"] = [
            {key: row[key] for key in ("id", "text", "expected_steps", "result", "error", "rev13_counterfactual", "rev14_counterfactual")}
            for row in owner_rows if not row["passed"] or not row["rev14_counterfactual"]["passed"]]
    trial.write(HERE / "measurement-summary.json", result)
    print(json.dumps({profile: result["profiles"][profile]["combined"]["rev14_counterfactual"]["reduced_domain"]
                      for profile in trial.PROFILES}))


if __name__ == "__main__":
    main()
