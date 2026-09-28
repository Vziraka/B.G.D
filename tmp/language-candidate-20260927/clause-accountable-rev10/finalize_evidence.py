"""Add post-run results, timing, cleanup, and evidence hashes to manifest.json."""

import hashlib
import json
import math
from pathlib import Path
import statistics

ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def file_info(path):
    return {"sha256": sha256(path), "bytes": path.stat().st_size}


def load_results(label):
    results_path = HERE / f"{label}-results.json"
    raw_path = HERE / f"{label}-raw.jsonl"
    results = json.loads(results_path.read_text(encoding="utf-8"))
    raw = [json.loads(line) for line in raw_path.read_text(encoding="utf-8").splitlines()]
    if len(raw) != results["total"]:
        raise RuntimeError(f"{label}: raw case count does not match results")
    return results, raw


def main():
    labels = ("frozen30", "development-v2", "open-development-rev10")
    runs = {}
    raw_by_label = {}
    for label in labels:
        runs[label], raw_by_label[label] = load_results(label)

    cold_rows = [row for row in raw_by_label["frozen30"]
                 if row["model_inference_performed"]]
    if not cold_rows:
        raise RuntimeError("No model inference was captured in frozen30")
    cold_ms = cold_rows[0]["interpreter_elapsed_ms"]
    warm_rows = [row for label in labels[1:] for row in raw_by_label[label]
                 if row["model_inference_performed"]]
    warm_times = sorted(row["interpreter_elapsed_ms"] for row in warm_rows)
    warm_p95 = warm_times[math.ceil(.95 * len(warm_times)) - 1] if warm_times else None

    artifacts = [
        "candidate/profile.json", "candidate/system-prompt.txt", "candidate/schema.json",
        "candidate/run-lock.json", "conversation-revision10.py",
        "evaluate-language-revision10.py", "test-conversation-revision10.py",
        "open-development-rev10.json", "frozen30-results.json", "frozen30-raw.jsonl",
        "frozen30-console.log", "development-v2-results.json", "development-v2-raw.jsonl",
        "development-v2-console.log", "open-development-rev10-results.json",
        "open-development-rev10-raw.jsonl", "open-development-rev10-console.log",
        "candidate-frozen30-server.pid", "candidate-frozen30-server-ready.json",
        "candidate-frozen30-server-stop.json", "candidate-frozen30-server.stdout.log",
        "candidate-frozen30-server.stderr.log", "listener-check.json", "review.md",
        "evaluate.py", "start_server.py", "stop_server.ps1", "prepare_artifacts.py",
        "finalize_evidence.py",
    ]
    evidence_files = {relative: file_info(HERE / relative) for relative in artifacts}

    manifest_path = HERE / "manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    listener_check = json.loads((HERE / "listener-check.json").read_text(encoding="utf-8-sig"))
    stop_result = json.loads((HERE / "candidate-frozen30-server-stop.json").read_text(encoding="utf-8-sig"))
    if (listener_check["listener_count"] != 0 or listener_check["process_running"]
            or stop_result["loopback_listener_remaining"] or not stop_result["process_stopped"]):
        raise RuntimeError("The loopback model server is not confirmed stopped")

    summaries = {}
    for label, result in runs.items():
        summaries[label] = {
            "corpus": result["corpus"], "corpus_sha256": result["corpus_sha256"],
            "passed": result["passed"], "total": result["total"],
            "critical_score": result["critical_score"],
            "ordinary_score": result["ordinary_score"],
            "critical_misses": result["critical_misses"],
            "ordinary_misses": result["ordinary_misses"],
            "policy_prepass_cases": result["policy_prepass_cases"],
            "source_fast_path_cases": result["source_fast_path_cases"],
            "model_fallback_cases": result["model_fallback_cases"],
            "model_inference_requests": result["model_inference_requests"],
            "first_model_inference_case": result["first_model_inference_case"],
            "per_run_first_inference_ms": result["cold_model_latency_ms"],
            "per_run_model_median_ms": result["model_latency_median_ms"],
            "per_run_model_p95_ms": result["model_latency_p95_ms"],
        }
    manifest.update({
        "status": "open development evidence complete; awaiting root review; not qualified",
        "evaluations": summaries,
        "timing": {
            "global_cold_first_model_request_ms": cold_ms,
            "warm_request_count": len(warm_times),
            "warm_model_request_median_ms": statistics.median(warm_times) if warm_times else None,
            "warm_model_request_p95_ms": warm_p95,
            "warm_sample_definition": "All model requests in development-v2 and rev10 open; server had already served the cold frozen30 request.",
            "production_timeout_seconds": 8,
            "evaluation_timeout_seconds": 30,
        },
        "verification": {
            "python_command": "python -m unittest discover -s tests/vision -v",
            "python_passed": 219, "python_skipped": 5,
            "preview_node_command": "node --test tests/vision/test_preview_loop.cjs",
            "preview_node_passed": True,
            "conversation_ui_node_command": "node --test tests/vision/test_conversation_ui.cjs",
            "conversation_ui_node_passed": True,
        },
        "review_notes": [
            "All 16 consequential cases in the worker-owned open fixture passed; ordinary score 31/33 is below the 95% gate.",
            "Open ordinary misses: fallback-find-03 clarified a named bowl location instead of finding it; fallback-find-06 returned targetless scout for a named envelope direction request.",
            "Root flagged crit-deix-01 as a potentially debatable clarification label and ordinary-status-03 as possibly requesting information beyond available desk status; preserve raw outcomes for adjudication.",
            "The first cold request at 24.34 seconds exceeds the production interpreter's 8-second timeout; no timeout behavior was changed in this trial.",
        ],
        "server_cleanup": {
            "host": "127.0.0.1", "port": 8084, "pid": 50804,
            "process_stopped": True, "listener_count": 0,
            "stop_record": "candidate-frozen30-server-stop.json",
            "independent_listener_check": "listener-check.json",
        },
        "evidence_files": evidence_files,
    })
    manifest_path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n",
                             encoding="utf-8")
    print(json.dumps({
        "manifest_sha256": sha256(manifest_path),
        "manifest_bytes": manifest_path.stat().st_size,
        "evidence_file_count": len(evidence_files),
        "timing": manifest["timing"],
        "open_score": summaries["open-development-rev10"]["passed"],
    }, indent=2))


if __name__ == "__main__":
    main()
