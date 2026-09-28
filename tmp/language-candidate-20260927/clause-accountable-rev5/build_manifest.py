"""Seal revision-5 provenance, run summaries, and evidence hashes."""

import hashlib
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
PARENT_MANIFEST = ROOT / "tmp/language-candidate-20260927/clause-accountable-rev4/manifest.json"


def info(path):
    return {"sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
            "bytes": path.stat().st_size}


def main():
    previous = json.loads(PARENT_MANIFEST.read_text(encoding="utf-8"))
    lock = json.loads((HERE / "run-lock.json").read_text(encoding="utf-8"))
    prompt = (HERE / "system-prompt.txt").read_bytes()
    schema = (HERE / "schema.json").read_bytes()
    results = {name: json.loads((HERE / f"{name}-results.json").read_text(encoding="utf-8"))
               for name in ("frozen30", "development-v2")}
    ready = {name: json.loads((HERE / f"{name}-server-ready.json").read_text(encoding="utf-8"))
             for name in results}

    relative_paths = {
        "bgd_vision/conversation.py",
        "bgd_vision/evaluate_language.py",
        "tests/vision/test_conversation.py",
        "tests/vision/test_conversation_http.py",
        "tests/vision/test_conversation_ui.cjs",
        "tests/vision/fixtures/conversation-eval.json",
        "tests/vision/fixtures/conversation-development-v2.json",
        "tmp/language-candidate-20260922/windows/llama-server.exe",
        "tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf",
    }
    relative_paths.update(
        str(path.relative_to(ROOT)).replace("\\", "/")
        for path in HERE.iterdir() if path.is_file() and path.name != "manifest.json")
    files = {path: info(ROOT / path) for path in sorted(relative_paths) if (ROOT / path).is_file()}

    manifest = {
        "trial_id": "qwen35-source-grounded-rev5",
        "status": "completed; pending root review of critical and ordinary results",
        "parent_trial_manifest_sha256": hashlib.sha256(PARENT_MANIFEST.read_bytes()).hexdigest(),
        "model": previous["model"],
        "runtime": previous["runtime"],
        "profile": json.loads((HERE / "profile.json").read_text(encoding="utf-8")),
        "pinned_inputs": lock,
        "prompt_sha256": hashlib.sha256(prompt).hexdigest(),
        "prompt_bytes": len(prompt),
        "schema_sha256": hashlib.sha256(schema).hexdigest(),
        "schema_bytes": len(schema),
        "evaluation_source": {
            "production_conversation_sha256": files["bgd_vision/conversation.py"]["sha256"],
            "frozen_snapshot": "conversation-revision5.py",
            "snapshot_sha256": files["tmp/language-candidate-20260927/clause-accountable-rev5/conversation-revision5.py"]["sha256"],
            "production_evaluator_sha256": files["bgd_vision/evaluate_language.py"]["sha256"],
            "runner_sha256": files["tmp/language-candidate-20260927/clause-accountable-rev5/evaluate.py"]["sha256"],
        },
        "evaluation": {
            name: {
                "result_file": f"{name}-results.json",
                "raw_file": f"{name}-raw.jsonl",
                "corpus": summary["corpus"].replace("\\", "/"),
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
                "cold_first_inference_ms": summary["cold_model_latency_ms"],
                "median_model_latency_ms": summary["model_latency_median_ms"],
                "p95_model_latency_ms": summary["model_latency_p95_ms"],
                "completion_bytes": summary["model_completion_bytes"],
                "server": {
                    "pid": ready[name]["pid"],
                    "ready_ms": ready[name]["ready_ms"],
                    "host": ready[name]["host"],
                    "port": ready[name]["port"],
                    "arguments": ready[name]["arguments"],
                    "process_stopped": True,
                    "loopback_listener_remaining": False,
                },
            }
            for name, summary in results.items()
        },
        "performance_risk": {
            "production_default_interpreter_timeout_seconds": 8,
            "evaluation_timeout_seconds": 30,
            "cold_first_inference_ms": {name: summary["cold_model_latency_ms"]
                                         for name, summary in results.items()},
            "assessment": "Production's default timeout is shorter than both cold first inferences; assess measured warmup or timeout behavior before any user or Pi trial.",
        },
        "verification": {
            "python": "41 conversation and 13 authenticated HTTP tests passed",
            "node": "conversation UI regression suite passed",
            "python_log": "focused-python-tests.log",
            "node_log": "focused-node-tests.log",
        },
        "scope": [
            "PC text-only; fixed Qwen3.5-4B Q4_K_M and llama.cpp b11095.",
            "Only conversation-eval.json and conversation-development-v2.json were evaluated.",
            "No Pi, camera service, UI runtime, physical device, flight controls, or heldout corpus was used.",
            "No prompt/code tuning occurred between the two model runs.",
            "Loopback model server stopped after each run; no listener remains on 127.0.0.1:8081.",
        ],
        "review_file": "review.md",
        "files": files,
    }
    out = HERE / "manifest.json"
    out.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps({"manifest": str(out.relative_to(ROOT)),
                      "manifest_sha256": hashlib.sha256(out.read_bytes()).hexdigest(),
                      "listed_files": len(files)}, indent=2))


if __name__ == "__main__":
    main()
