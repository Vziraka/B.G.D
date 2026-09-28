"""Record revision-8 provenance, open-corpus runs, cleanup, and evidence hashes."""

import hashlib
import json
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


def main():
    previous = json.loads(MODEL_MANIFEST.read_text(encoding="utf-8"))
    lock = json.loads((HERE / "run-lock.json").read_text(encoding="utf-8"))
    profile = json.loads((HERE / "profile.json").read_text(encoding="utf-8"))
    prompt = (HERE / "system-prompt.txt").read_bytes()
    schema = (HERE / "schema.json").read_bytes()
    names = ("frozen30", "development-v2", "open-development")
    results = {name: json.loads((HERE / f"{name}-results.json").read_text(encoding="utf-8"))
               for name in names}
    ready = {name: json.loads((HERE / f"{name}-server-ready.json").read_text(encoding="utf-8"))
             for name in names}
    stopped = {name: json.loads((HERE / f"{name}-server-stop.json").read_text(encoding="utf-8"))
               for name in names}

    input_paths = {
        ROOT / relative for relative in lock["files"]
    }
    input_paths.update({
        MODEL_MANIFEST,
        ROOT / "bgd_vision/conversation.py",
        ROOT / "bgd_vision/evaluate_language.py",
        ROOT / "tests/vision/fixtures/conversation-eval.json",
        ROOT / "tests/vision/fixtures/conversation-development-v2.json",
        HERE / "open-development.json",
    })
    input_paths.update(path for path in HERE.rglob("*")
                       if path.is_file() and path.name != "manifest.json")
    files = {str(path.relative_to(ROOT)).replace("\\", "/"): file_info(path)
             for path in sorted(input_paths) if path.is_file()}

    evaluation = {}
    for name, summary in results.items():
        server_state = stopped[name]
        evaluation[name] = {
            "result_file": f"{name}-results.json",
            "raw_file": f"{name}-raw.jsonl",
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
            "first_evaluated_case_latency_ms": summary["first_evaluated_case_latency_ms"],
            "cold_first_inference_ms": summary["cold_model_latency_ms"],
            "median_model_latency_ms": summary["model_latency_median_ms"],
            "p95_model_latency_ms": summary["model_latency_p95_ms"],
            "prompt_bytes": summary["system_prompt_bytes"],
            "completion_bytes": summary["model_completion_bytes"],
            "server": {
                "pid": ready[name]["pid"],
                "ready_ms": ready[name]["ready_ms"],
                "host": ready[name]["host"],
                "port": ready[name]["port"],
                "arguments": ready[name]["arguments"],
                "process_stopped": server_state["process_stopped"],
                "loopback_listener_remaining": server_state["loopback_listener_remaining"],
            },
        }

    manifest = {
        "trial_id": "qwen35-clause-accountable-rev8",
        "status": "complete; pending independent root review",
        "parent_model_provenance_manifest": str(MODEL_MANIFEST.relative_to(ROOT)).replace("\\", "/"),
        "parent_model_provenance_sha256": file_info(MODEL_MANIFEST)["sha256"],
        "model": previous["model"],
        "runtime": {
            **previous["runtime"],
            "process_id": {name: ready[name]["pid"] for name in names},
            "process_stopped": all(stopped[name]["process_stopped"] for name in names),
            "loopback_listener_remaining": any(
                stopped[name]["loopback_listener_remaining"] for name in names),
            "run_logs": {name: {
                "stdout": f"{name}-server.stdout.log",
                "stderr": f"{name}-server.stderr.log",
            } for name in names},
        },
        "profile": profile,
        "pinned_inputs": lock,
        "prompt_sha256": hashlib.sha256(prompt).hexdigest(),
        "prompt_bytes": len(prompt),
        "schema_sha256": hashlib.sha256(schema).hexdigest(),
        "schema_bytes": len(schema),
        "evaluation_source": {
            "production_conversation_sha256": files["bgd_vision/conversation.py"]["sha256"],
            "frozen_snapshot": "conversation-revision8.py",
            "snapshot_sha256": files[
                "tmp/language-candidate-20260927/clause-accountable-rev8/conversation-revision8.py"]["sha256"],
            "production_evaluator_sha256": files["bgd_vision/evaluate_language.py"]["sha256"],
            "runner_sha256": files[
                "tmp/language-candidate-20260927/clause-accountable-rev7/evaluate.py"]["sha256"],
        },
        "evaluation": evaluation,
        "performance_risk": {
            "production_default_interpreter_timeout_seconds": 8,
            "evaluation_timeout_seconds": 30,
            "cold_first_inference_ms": {
                name: results[name]["cold_model_latency_ms"] for name in names},
            "assessment": "Compare measured cold first inference with the 8-second production default before any user or Pi trial.",
        },
        "verification": {
            "full_vision_tests": "202 passed, 5 skipped",
            "node_conversation_ui": "passed",
            "node_preview_loop": "passed",
            "logs": ["full-vision-tests.log", "node-conversation-tests.log", "node-preview-tests.log"],
        },
        "scope": [
            "Windows PC text-only; pinned Qwen3.5-4B Q4_K_M and existing llama.cpp b11095.",
            "Only conversation-eval.json, conversation-development-v2.json, and the rev8 open-development fixture were evaluated, once each.",
            "No Pi, camera runtime, physical device, flight control, or speech testing was performed in the model trial.",
            "The production system prompt was unchanged; no prompt/code changes occurred between model runs.",
            "Loopback server was stopped and port 8081 verified clear after each corpus.",
        ],
        "review_file": "review.md",
        "files": files,
    }
    out = HERE / "manifest.json"
    out.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps({"manifest": str(out.relative_to(ROOT)),
                      "manifest_sha256": file_info(out)["sha256"],
                      "listed_files": len(files)}, indent=2))


if __name__ == "__main__":
    main()
