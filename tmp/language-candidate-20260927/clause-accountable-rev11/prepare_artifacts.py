"""Pin the rev11 source, profile, model/runtime provenance, and open corpora."""

import hashlib
import json
from pathlib import Path
import shutil
import sys

ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
PROFILE = HERE / "candidate"
MODEL_MANIFEST = ROOT / "tmp/language-candidate-20260926/qwen35-manifest.json"
MODEL_PATH = ROOT / "tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf"
SERVER_PATH = ROOT / "tmp/language-candidate-20260922/windows/llama-server.exe"


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def info(path):
    return {"sha256": sha256(path), "bytes": path.stat().st_size}


def main():
    sys.path.insert(0, str(ROOT))
    from bgd_vision import conversation

    model_manifest = json.loads(MODEL_MANIFEST.read_text(encoding="utf-8"))
    model = model_manifest["model"]
    runtime = model_manifest["runtime"]
    model_manifest_info = info(MODEL_MANIFEST)
    model_info = info(MODEL_PATH)
    runtime_info = info(SERVER_PATH)
    if model_info["sha256"] != model["sha256"] or model_info["bytes"] != model["bytes"]:
        raise RuntimeError("Pinned Qwen3.5 GGUF does not match its provenance manifest")
    if runtime_info["sha256"] != runtime["executable_sha256"]:
        raise RuntimeError("Pinned llama.cpp executable does not match its provenance manifest")

    source_snapshot = HERE / "conversation-revision11.py"
    evaluator_snapshot = HERE / "evaluate-language-revision11.py"
    test_snapshot = HERE / "test-conversation-revision11.py"
    shutil.copyfile(ROOT / "bgd_vision/conversation.py", source_snapshot)
    shutil.copyfile(ROOT / "bgd_vision/evaluate_language.py", evaluator_snapshot)
    shutil.copyfile(ROOT / "tests/vision/test_conversation.py", test_snapshot)

    prompt_bytes = conversation.SYSTEM_PROMPT.encode("utf-8")
    prompt_path = PROFILE / "system-prompt.txt"
    prompt_path.write_bytes(prompt_bytes)
    schema_bytes = (json.dumps(conversation.SEMANTIC_SCHEMA, indent=2) + "\n").encode("utf-8")
    schema_path = PROFILE / "schema.json"
    schema_path.write_bytes(schema_bytes)
    profile = {
        "profile_id": "qwen35-clause-accountable-rev11-current-prompt",
        "enabled_by_default": False,
        "model": model,
        "runtime": {
            "kind": runtime["kind"], "version": runtime["version"],
            "executable": runtime["executable"],
            "executable_sha256": runtime["executable_sha256"],
            "host": "127.0.0.1", "port": 8084,
            "threads": 2, "batch_threads": 2, "context": 2048,
            "parallel": 1, "jinja": True, "web_ui": False,
        },
        "request": {
            "temperature": 0.7, "top_p": 0.8, "top_k": 20, "min_p": 0,
            "presence_penalty": 1.5, "max_tokens": 300, "seed": 42,
            "stream": False, "chat_template_kwargs": {"enable_thinking": False},
            "response_format": "strict JSON schema",
            "production_interpreter_timeout_seconds": 8,
            "evaluation_timeout_seconds": 30,
        },
        "authority": "simulator-only; local PC text interpretation; no execution",
        "prompt_file": "system-prompt.txt", "prompt_bytes": len(prompt_bytes),
        "prompt_sha256": hashlib.sha256(prompt_bytes).hexdigest(),
        "schema_file": "schema.json", "schema_sha256": hashlib.sha256(schema_bytes).hexdigest(),
    }
    profile_path = PROFILE / "profile.json"
    profile_path.write_text(json.dumps(profile, indent=2, ensure_ascii=False) + "\n",
                            encoding="utf-8")

    corpora = [
        ROOT / "tests/vision/fixtures/conversation-eval.json",
        ROOT / "tests/vision/fixtures/conversation-development-v2.json",
        HERE / "open-development-rev11.json",
    ]
    locked_paths = [
        ROOT / "bgd_vision/conversation.py", ROOT / "bgd_vision/evaluate_language.py",
        ROOT / "bgd_vision/commands.py", ROOT / "bgd_vision/server.py",
        ROOT / "tests/vision/test_conversation.py", ROOT / "tests/vision/test_conversation_http.py",
        ROOT / "tests/vision/test_server.py", *corpora,
        MODEL_PATH, MODEL_MANIFEST, SERVER_PATH,
        HERE / "evaluate.py", HERE / "start_server.py", HERE / "stop_server.ps1",
        HERE / "prepare_artifacts.py", source_snapshot, evaluator_snapshot, test_snapshot,
        prompt_path, schema_path, profile_path,
    ]
    metadata_cache = {
        MODEL_PATH: model_info,
        MODEL_MANIFEST: model_manifest_info,
        SERVER_PATH: runtime_info,
    }
    files = {}
    for path in locked_paths:
        if path not in metadata_cache:
            metadata_cache[path] = info(path)
        files[str(path.relative_to(ROOT)).replace("\\", "/")] = metadata_cache[path]
    lock = {
        "trial_id": profile["profile_id"],
        "source_revision": "rev11 referent-relation/survey guard fixes; current prompt retained unchanged",
        "active_prompt_sha256": profile["prompt_sha256"],
        "schema_sha256": profile["schema_sha256"],
        "files": files,
    }
    lock_path = PROFILE / "run-lock.json"
    lock_path.write_text(json.dumps(lock, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    manifest = {
        "trial_id": profile["profile_id"],
        "status": "frozen before inference",
        "profile": profile,
        "model_manifest_sha256": model_manifest_info["sha256"],
        "production_source_sha256": files["bgd_vision/conversation.py"]["sha256"],
        "tests_sha256": files["tests/vision/test_conversation.py"]["sha256"],
        "prompt_sha256": profile["prompt_sha256"],
        "schema_sha256": profile["schema_sha256"],
        "corpora": [{"path": str(path.relative_to(ROOT)).replace("\\", "/"),
                     **files[str(path.relative_to(ROOT)).replace("\\", "/")],
                     "case_count": len(json.loads(path.read_text(encoding="utf-8")))}
                    for path in corpora],
        "model_server": {"host": "127.0.0.1", "port": 8084,
                         "background_window": "hidden", "loopback_only": True},
        "run_lock_sha256": sha256(lock_path),
        "files": files,
    }
    manifest_path = HERE / "manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n",
                             encoding="utf-8")
    print(json.dumps({
        "trial_id": profile["profile_id"],
        "source_sha256": manifest["production_source_sha256"],
        "test_sha256": manifest["tests_sha256"],
        "prompt_sha256": manifest["prompt_sha256"],
        "schema_sha256": manifest["schema_sha256"],
        "model_sha256": model_info["sha256"],
        "runtime_sha256": runtime_info["sha256"],
        "corpora": manifest["corpora"],
        "run_lock_sha256": manifest["run_lock_sha256"],
        "locked_file_count": len(files),
    }, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
