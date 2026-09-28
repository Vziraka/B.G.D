"""Hash rev9 evidence and summarize the frozen baseline/candidate comparison."""

import hashlib
import json
import math
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
MODEL_MANIFEST = ROOT / "tmp/language-candidate-20260926/qwen35-manifest.json"


def file_info(path):
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return {"sha256": digest.hexdigest(), "bytes": path.stat().st_size}


def read_json(path):
    return json.loads(path.read_text(encoding="utf-8-sig"))


def run_summary(profile, name):
    path = HERE / profile / f"{name}-results.json"
    return read_json(path)


def misses_for(profile):
    results = read_json(HERE / profile / "open-development-results.json")
    rows = [json.loads(line) for line in
            (HERE / profile / "open-development-raw.jsonl").read_text(encoding="utf-8").splitlines()]
    by_id = {row["id"]: row for row in rows}
    corpus = read_json(HERE / "open-development.json")
    expected = {case["id"]: case for case in corpus}
    misses = []
    for case_id in results["ordinary_misses"] + results["critical_misses"]:
        row = by_id[case_id]
        case = expected[case_id]
        misses.append({
            "id": case_id,
            "input": case["text"],
            "critical": case.get("critical") is True,
            "expected_statuses": case["statuses"],
            "expected_steps": case.get("steps"),
            "actual_result": row["validated_result"],
            "error": row["error"],
            "execution_path": row["execution_path"],
            "model_completion_raw": row.get("model_completion_raw"),
        })
    return misses


def main():
    parent = read_json(MODEL_MANIFEST)
    baseline_lock = read_json(HERE / "baseline/run-lock.json")
    candidate_lock = read_json(HERE / "candidate/run-lock.json")
    baseline_profile = read_json(HERE / "baseline/profile.json")
    candidate_profile = read_json(HERE / "candidate/profile.json")
    old30 = run_summary("candidate", "frozen30")
    dev2 = run_summary("candidate", "development-v2")
    baseline = run_summary("baseline", "open-development")
    candidate = run_summary("candidate", "open-development")
    verification = read_json(HERE / "verification.json")
    corpus = read_json(HERE / "open-development.json")

    labels = ("baseline-open", "candidate-open", "candidate-frozen30", "candidate-development-v2")
    ready = {label: read_json(HERE / f"{label}-server-ready.json") for label in labels}
    stopped = {label: read_json(HERE / f"{label}-server-stop.json") for label in labels}
    if not all(value["process_stopped"] and not value["loopback_listener_remaining"]
               for value in stopped.values()):
        raise RuntimeError("A rev9 local-model process or listener remains")

    baseline_misses = set(baseline["ordinary_misses"] + baseline["critical_misses"])
    candidate_misses = set(candidate["ordinary_misses"] + candidate["critical_misses"])
    threshold = math.ceil(0.95 * candidate["ordinary_score"]["total"])

    root_inputs = [
        ROOT / "bgd_vision/conversation.py",
        ROOT / "bgd_vision/evaluate_language.py",
        ROOT / "bgd_vision/commands.py",
        ROOT / "bgd_vision/server.py",
        ROOT / "tests/vision/test_conversation.py",
        ROOT / "tests/vision/test_conversation_http.py",
        ROOT / "tests/vision/test_server.py",
        ROOT / "tests/vision/fixtures/conversation-eval.json",
        ROOT / "tests/vision/fixtures/conversation-development-v2.json",
    ]
    root_files = {str(path.relative_to(ROOT)).replace("\\", "/"): file_info(path)
                  for path in root_inputs}
    evidence_files = {}
    for path in sorted(HERE.rglob("*")):
        if not path.is_file() or path.name == "manifest.json" or "__pycache__" in path.parts:
            continue
        evidence_files[str(path.relative_to(ROOT)).replace("\\", "/")] = file_info(path)

    def evaluate_entry(name, profile, summary):
        label = {
            ("baseline", "open-development"): "baseline-open",
            ("candidate", "open-development"): "candidate-open",
            ("candidate", "frozen30"): "candidate-frozen30",
            ("candidate", "development-v2"): "candidate-development-v2",
        }[(profile, name)]
        return {
            "profile": profile,
            "result_file": f"{profile}/{name}-results.json",
            "raw_file": f"{profile}/{name}-raw.jsonl",
            "log_file": f"{profile}/{name}-run.log",
            "corpus": summary["corpus"],
            "corpus_sha256": summary["corpus_sha256"],
            "cases": summary["total"],
            "passed": summary["passed"],
            "critical_score": summary["critical_score"],
            "ordinary_score": summary["ordinary_score"],
            "critical_misses": summary["critical_misses"],
            "ordinary_misses": summary["ordinary_misses"],
            "scoring_basis": summary["scoring_basis"],
            "model_inference_requests": summary["model_inference_requests"],
            "policy_prepass_cases": summary["policy_prepass_cases"],
            "source_fast_path_cases": summary["source_fast_path_cases"],
            "model_fallback_cases": summary["model_fallback_cases"],
            "first_inference_ms": summary["cold_model_latency_ms"],
            "median_model_latency_ms": summary["model_latency_median_ms"],
            "p95_model_latency_ms": summary["model_latency_p95_ms"],
            "prompt_bytes": summary["system_prompt_bytes"],
            "completion_bytes": summary["model_completion_bytes"],
            "run_lock_sha256": summary["run_lock_sha256"],
            "server": {
                "pid": ready[label]["pid"],
                "ready_ms": ready[label]["ready_ms"],
                "host": ready[label]["host"],
                "port": ready[label]["port"],
                "arguments": ready[label]["arguments"],
                "process_stopped": stopped[label]["process_stopped"],
                "loopback_listener_remaining": stopped[label]["loopback_listener_remaining"],
            },
        }

    manifest = {
        "trial_id": "qwen35-clause-accountable-rev9",
        "status": "candidate passes original30 and development-v2; new open ordinary gate missed; awaiting root review",
        "scope": [
            "Windows PC text-only, local pinned Qwen3.5-4B Q4_K_M, existing llama.cpp b11095.",
            "Prompt comparison changed only the system prompt; source, schema, runtime and request settings were identical between baseline and candidate open runs.",
            "Baseline prompt is the saved rev8 prompt. Candidate prompt adds compact general action semantics for follow/find/count and targetless scout.",
            "Only the original 30, development-v2, and the new rev9 open-development fixture were run. No consumed sealed set or independent root probe was read or run.",
            "No Pi, camera, physical, flight-control, or spoken trial was performed.",
        ],
        "source": {
            "production_path": "bgd_vision/conversation.py",
            "production_sha256": root_files["bgd_vision/conversation.py"]["sha256"],
            "frozen_snapshot": "conversation-revision9.py",
            "snapshot_sha256": evidence_files[
                "tmp/language-candidate-20260927/clause-accountable-rev9/conversation-revision9.py"]["sha256"],
            "test_path": "tests/vision/test_conversation.py",
            "test_sha256": root_files["tests/vision/test_conversation.py"]["sha256"],
            "changes_since_rev8": [
                "Narrowed generic deictic ambiguity so bare demonstratives remain unclear while described demonstrative targets are accepted.",
                "Normalized descriptive demonstratives consistently before named modifiers, including `of these`/`from among those` count phrasing.",
                "Kept plain current-room find requests available and explicit next/beyond/outside room scope unsupported.",
                "Moved diagnostic reset behind the interpreter busy lock so a rejected concurrent call does not overwrite the active request record.",
                "Added the candidate prompt's general action mapping; local model profile remains disabled by default.",
            ],
        },
        "prompts": {
            "baseline": {"file": "baseline/system-prompt.txt", "sha256": baseline_profile["prompt_sha256"], "bytes": baseline_profile["prompt_bytes"]},
            "candidate": {"file": "candidate/system-prompt.txt", "sha256": candidate_profile["prompt_sha256"], "bytes": candidate_profile["prompt_bytes"]},
            "candidate_change": "Maintaining observation of a named subject means follow; locating a named subject within this view means find; a visible quantity or total for a named category means count that category. Scout is a targetless survey of this view; never use it for a named target. Do not infer arithmetic over labels or values.",
        },
        "schema": {"sha256": candidate_profile["schema_sha256"], "bytes": (HERE / "candidate/schema.json").stat().st_size},
        "model": {
            **parent["model"],
            "artifact_sha256": candidate_lock["files"]["tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf"]["sha256"],
            "bytes": candidate_lock["files"]["tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf"]["bytes"],
            "parent_manifest": str(MODEL_MANIFEST.relative_to(ROOT)).replace("\\", "/"),
            "parent_manifest_sha256": file_info(MODEL_MANIFEST)["sha256"],
        },
        "runtime": {
            **parent["runtime"],
            "executable_sha256": candidate_lock["files"]["tmp/language-candidate-20260922/windows/llama-server.exe"]["sha256"],
            "host": "127.0.0.1",
            "port": 8081,
            "threads": 2,
            "batch_threads": 2,
            "context": 2048,
            "parallel": 1,
            "jinja": True,
            "web_ui": False,
            "all_runs_stopped": True,
            "final_port_check": "Get-NetTCPConnection -State Listen -LocalPort 8081 returned no rows after candidate-development-v2 cleanup.",
        },
        "request_settings": candidate_profile["request"],
        "profiles": {
            "baseline": {"profile": baseline_profile, "run_lock_sha256": file_info(HERE / "baseline/run-lock.json")["sha256"]},
            "candidate": {"profile": candidate_profile, "run_lock_sha256": file_info(HERE / "candidate/run-lock.json")["sha256"]},
        },
        "fixture": {
            "path": "tmp/language-candidate-20260927/clause-accountable-rev9/open-development.json",
            "sha256": file_info(HERE / "open-development.json")["sha256"],
            "cases": len(corpus),
            "critical": sum(case.get("critical") is True for case in corpus),
            "ordinary": sum(case.get("critical") is not True for case in corpus),
            "required_model_fallback_minimum": 20,
        },
        "evaluation": {
            "baseline_open": evaluate_entry("open-development", "baseline", baseline),
            "candidate_open": evaluate_entry("open-development", "candidate", candidate),
            "candidate_original30": evaluate_entry("frozen30", "candidate", old30),
            "candidate_development_v2": evaluate_entry("development-v2", "candidate", dev2),
            "open_comparison": {
                "baseline_to_candidate_recovered_ids": sorted(baseline_misses - candidate_misses),
                "new_candidate_miss_ids": sorted(candidate_misses - baseline_misses),
                "remaining_shared_miss_ids": sorted(baseline_misses & candidate_misses),
                "ordinary_gate_required": threshold,
                "ordinary_gate_passed": candidate["ordinary_score"]["passed"] >= threshold,
                "all_critical_cases_passed": candidate["critical_score"]["passed"] == candidate["critical_score"]["total"],
                "miss_review": {"baseline": misses_for("baseline"), "candidate": misses_for("candidate")},
            },
        },
        "performance_risk": {
            "production_default_timeout_seconds": candidate_profile["request"]["production_interpreter_timeout_seconds"],
            "evaluation_timeout_seconds": candidate_profile["request"]["evaluation_timeout_seconds"],
            "first_inference_ms_by_run": {
                "baseline_open": baseline["cold_model_latency_ms"],
                "candidate_open": candidate["cold_model_latency_ms"],
                "candidate_original30": old30["cold_model_latency_ms"],
                "candidate_development_v2": dev2["cold_model_latency_ms"],
            },
            "risk": "Every measured cold inference exceeded the production 8-second interpreter timeout; no timeout behavior was changed in this task.",
        },
        "verification": verification,
        "artifacts": {
            "source_diff": "source-rev8-to-rev9.diff",
            "test_diff": "tests-rev8-to-rev9.diff",
            "prompt_diff": "prompt-rev8-to-rev9.diff",
            "review": "review.md",
        },
        "root_inputs": root_files,
        "evidence_files": evidence_files,
    }
    out = HERE / "manifest.json"
    out.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps({
        "manifest": str(out.relative_to(ROOT)).replace("\\", "/"),
        "manifest_sha256": file_info(out)["sha256"],
        "source_sha256": manifest["source"]["production_sha256"],
        "baseline_prompt_sha256": manifest["prompts"]["baseline"]["sha256"],
        "candidate_prompt_sha256": manifest["prompts"]["candidate"]["sha256"],
        "open_fixture_sha256": manifest["fixture"]["sha256"],
        "evidence_files": len(evidence_files),
        "open_ordinary_gate_passed": manifest["evaluation"]["open_comparison"]["ordinary_gate_passed"],
    }, indent=2))


if __name__ == "__main__":
    main()
