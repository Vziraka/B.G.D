"""Write the post-inference Rev12 evidence index without changing frozen inputs."""

from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def load_json(relative):
    return json.loads((ROOT / relative).read_text(encoding="utf-8"))


def describe_run(name, corpus, results, raw, console):
    result_path = ROOT / results
    raw_path = ROOT / raw
    summary = json.loads(result_path.read_text(encoding="utf-8"))
    with raw_path.open("r", encoding="utf-8") as source:
        rows = [json.loads(line) for line in source if line.strip()]
    misses = []
    for row in rows:
        if row["passed"]:
            continue
        misses.append({key: row.get(key) for key in (
            "id", "input_text", "context", "expected_statuses", "expected_steps",
            "validated_result", "error", "execution_path", "model_completion_raw",
            "interpreter_elapsed_ms",
        )})
    return {
        "name": name,
        "corpus": corpus,
        "corpus_sha256": sha256(ROOT / corpus),
        "cases": len(rows),
        "score": {"passed": summary["passed"], "total": summary["total"]},
        "critical": summary["critical_score"],
        "ordinary": summary["ordinary_score"],
        "critical_misses": summary["critical_misses"],
        "ordinary_misses": summary["ordinary_misses"],
        "routes": {
            "policy_prepass": summary["policy_prepass_cases"],
            "source_fast_path": summary["source_fast_path_cases"],
            "model_fallback": summary["model_fallback_cases"],
        },
        "model_latency_ms": {
            "cold": summary["cold_model_latency_ms"],
            "median": summary["model_latency_median_ms"],
            "p95": summary["model_latency_p95_ms"],
        },
        "system_prompt_bytes": summary["system_prompt_bytes"],
        "model_completion_bytes": summary["model_completion_bytes"],
        "miss_details": misses,
        "evidence": {path: {"bytes": (ROOT / path).stat().st_size,
                             "sha256": sha256(ROOT / path)}
                     for path in (results, raw, console)},
    }


lock_path = HERE / "run-lock.json"
freeze_manifest_path = HERE / "manifest.json"
settings_path = HERE / "settings.json"
selection = load_json(str((HERE / "prompt-ab-decision.json").relative_to(ROOT)))

run_specs = [
    ("prompt_ab_baseline", "tmp/language-candidate-20260927/clause-accountable-rev12/prompt-ab-rev12.json",
     "prompt-ab-baseline-results.json", "prompt-ab-baseline-raw.jsonl",
     "prompt-ab-baseline-console.log"),
    ("prompt_ab_candidate", "tmp/language-candidate-20260927/clause-accountable-rev12/prompt-ab-rev12.json",
     "prompt-ab-candidate-results.json", "prompt-ab-candidate-raw.jsonl",
     "prompt-ab-candidate-console.log"),
    ("old30", "tests/vision/fixtures/conversation-eval.json",
     "frozen30-results.json", "frozen30-raw.jsonl", "frozen30-console.log"),
    ("development_v2", "tests/vision/fixtures/conversation-development-v2.json",
     "development-v2-results.json", "development-v2-raw.jsonl",
     "development-v2-console.log"),
    ("worker53", "tmp/language-candidate-20260927/clause-accountable-rev12/worker53-open.json",
     "worker53-results.json", "worker53-raw.jsonl", "worker53-console.log"),
    ("root35_open_copy", "tmp/language-candidate-20260927/clause-accountable-rev12/root35-open.json",
     "root35-results.json", "root35-raw.jsonl", "root35-console.log"),
    ("worker58_rev12", "tmp/language-candidate-20260927/clause-accountable-rev12/open-development-rev12.json",
     "worker58-results.json", "worker58-raw.jsonl", "worker58-console.log"),
]

for _, _, _, _, console in run_specs:
    path = HERE / console
    if not path.exists():
        path.write_text("Console row output is preserved in the raw JSONL and result summary.\n",
                        encoding="utf-8")

runs = []
for name, corpus, results, raw, console in run_specs:
    runs.append(describe_run(name, corpus, str(HERE / results), str(HERE / raw),
                             str(HERE / console)))

stop = json.loads((HERE / "rev12-model-run-server-stop.json").read_text(encoding="utf-8"))
ready = json.loads((HERE / "rev12-model-run-server-ready.json").read_text(encoding="utf-8"))
lock = json.loads(lock_path.read_text(encoding="utf-8"))

evidence_paths = [
    "tmp/language-candidate-20260927/clause-accountable-rev12/run-lock.json",
    "tmp/language-candidate-20260927/clause-accountable-rev12/manifest.json",
    "tmp/language-candidate-20260927/clause-accountable-rev12/acceptance-gates.json",
    "tmp/language-candidate-20260927/clause-accountable-rev12/finalize-manifest.py",
    "tmp/language-candidate-20260927/clause-accountable-rev12/settings.json",
    "tmp/language-candidate-20260927/clause-accountable-rev12/ab-selection-rule.md",
    "tmp/language-candidate-20260927/clause-accountable-rev12/prompt-ab-decision.json",
    "tmp/language-candidate-20260927/clause-accountable-rev12/full-vision.log",
    "tmp/language-candidate-20260927/clause-accountable-rev12/node-suites.log",
    "tmp/language-candidate-20260927/clause-accountable-rev12/rev12-model-run-server-ready.json",
    "tmp/language-candidate-20260927/clause-accountable-rev12/rev12-model-run-server-stop.json",
    "tmp/language-candidate-20260927/clause-accountable-rev12/rev12-model-run-server.stderr.log",
    "tmp/language-candidate-20260927/clause-accountable-rev12/rev12-model-run-server.stdout.log",
    "tmp/language-candidate-20260927/clause-accountable-rev12/final-review.md",
]
for _, _, results, raw, console in run_specs:
    evidence_paths.extend(str(HERE / item) for item in (results, raw, console))

evidence = {}
for relative in evidence_paths:
    path = ROOT / relative
    evidence[relative] = {"bytes": path.stat().st_size, "sha256": sha256(path)}

manifest = {
    "trial_id": lock["trial_id"],
    "status": "completed_for_root_review",
    "completed_at_utc": datetime.now(timezone.utc).isoformat(),
    "inference_performed": True,
    "frozen_run_lock": {
        "path": str(lock_path.relative_to(ROOT)).replace("\\", "/"),
        "bytes": lock_path.stat().st_size,
        "sha256": sha256(lock_path),
        "locked_file_count": len(lock["files"]),
        "locked_files": lock["files"],
    },
    "model_runtime_settings": json.loads(settings_path.read_text(encoding="utf-8")),
    "prompt_selection": selection,
    "runs": runs,
    "acceptance": {
        "old30": "pass: 30/30 exact",
        "development_v2": "pass: 30/30 critical and 28/28 ordinary",
        "worker53": "fail: 19/19 critical, 30/34 ordinary; required at least 33/34 ordinary",
        "root35_open_copy": "pass: 17/17 critical, 17/18 ordinary",
        "worker58_rev12": "fail: 17/18 critical, 33/40 ordinary; required 18/18 critical and at least 38/40 ordinary",
    },
    "server": {
        "ready": ready,
        "stop": stop,
        "loopback_only": True,
        "listener_verified_absent_after_stop": not stop["loopback_listener_remaining"],
    },
    "scope": {
        "root38_read_or_run": False,
        "sealed_data_read_or_run": False,
        "production_default_enabled": False,
        "pi_or_flight_or_speech_testing": False,
        "review": "See final-review.md. Rev12 failed open-development gates and is not qualified.",
    },
    "evidence_files": evidence,
}

output = HERE / "completion-manifest.json"
output.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n",
                  encoding="utf-8")
print(json.dumps({"path": str(output.relative_to(ROOT)).replace("\\", "/"),
                  "sha256": sha256(output), "bytes": output.stat().st_size,
                  "runs": len(runs), "evidence_files": len(evidence)}, ensure_ascii=False))
