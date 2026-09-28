"""Freeze rev9 source, prompts, profile, fixture and runner before inference."""

import hashlib
import json
from pathlib import Path
import shutil
import sys

ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
MODEL_MANIFEST = ROOT / "tmp/language-candidate-20260926/qwen35-manifest.json"
MODEL_PATH = ROOT / "tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf"
SERVER_PATH = ROOT / "tmp/language-candidate-20260922/windows/llama-server.exe"
REV8_PROMPT = ROOT / "tmp/language-candidate-20260927/clause-accountable-rev8/system-prompt.txt"


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

    previous = json.loads(MODEL_MANIFEST.read_text(encoding="utf-8"))
    model, runtime = previous["model"], previous["runtime"]
    metadata_cache = {}
    for path in (MODEL_PATH, SERVER_PATH, MODEL_MANIFEST):
        metadata_cache[path] = info(path)
    if (metadata_cache[MODEL_PATH]["sha256"] != model["sha256"]
            or metadata_cache[MODEL_PATH]["bytes"] != model["bytes"]
            or metadata_cache[SERVER_PATH]["sha256"] != runtime["executable_sha256"]):
        raise RuntimeError("Pinned model/runtime does not match the reviewed provenance")
    if metadata_cache[MODEL_MANIFEST]["sha256"] != "28bf71d9922d3803d44b368cf521cd8e56f1fa8cff926b572f2a24dd05931c33":
        raise RuntimeError("Parent model provenance manifest changed")

    source_snapshot = HERE / "conversation-revision9.py"
    evaluator_snapshot = HERE / "evaluate-language-revision9.py"
    test_snapshot = HERE / "test-conversation-revision9.py"
    shutil.copyfile(ROOT / "bgd_vision/conversation.py", source_snapshot)
    shutil.copyfile(ROOT / "bgd_vision/evaluate_language.py", evaluator_snapshot)
    shutil.copyfile(ROOT / "tests/vision/test_conversation.py", test_snapshot)

    current_prompt = conversation.SYSTEM_PROMPT.encode("utf-8")
    prompts = {
        "baseline": REV8_PROMPT.read_bytes(),
        "candidate": current_prompt,
    }
    schema_bytes = (json.dumps(conversation.SEMANTIC_SCHEMA, indent=2) + "\n").encode("utf-8")
    for name, prompt_bytes in prompts.items():
        profile_dir = HERE / name
        profile_dir.mkdir(exist_ok=True)
        (profile_dir / "system-prompt.txt").write_bytes(prompt_bytes)
        (profile_dir / "schema.json").write_bytes(schema_bytes)
        profile = {
            "profile_id": f"qwen35-clause-accountable-rev9-{name}",
            "enabled_by_default": False,
            "profile_role": ("old rev8 prompt under rev9 source/runtime" if name == "baseline"
                             else "compact general follow/find/count intent mapping"),
            "model": model,
            "runtime": {
                "kind": runtime["kind"], "version": runtime["version"],
                "executable": runtime["executable"],
                "executable_sha256": runtime["executable_sha256"],
                "host": "127.0.0.1", "port": 8081,
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
            "prompt_file": "system-prompt.txt", "schema_file": "schema.json",
            "prompt_bytes": len(prompt_bytes),
            "prompt_sha256": hashlib.sha256(prompt_bytes).hexdigest(),
            "schema_sha256": hashlib.sha256(schema_bytes).hexdigest(),
        "production_source_sha256": info(source_snapshot)["sha256"],
        }
        (profile_dir / "profile.json").write_text(
            json.dumps(profile, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

        allowed_paths = [
            ROOT / "bgd_vision/conversation.py",
            ROOT / "bgd_vision/evaluate_language.py",
            ROOT / "bgd_vision/commands.py",
            ROOT / "bgd_vision/server.py",
            ROOT / "tests/vision/test_conversation.py",
            ROOT / "tests/vision/test_conversation_http.py",
            ROOT / "tests/vision/test_server.py",
            HERE / "open-development.json",
            MODEL_PATH, SERVER_PATH, MODEL_MANIFEST,
            HERE / "evaluate.py", HERE / "start_server.py", HERE / "stop_server.ps1",
            HERE / "prepare_artifacts.py", source_snapshot, evaluator_snapshot, test_snapshot,
            profile_dir / "system-prompt.txt", profile_dir / "schema.json", profile_dir / "profile.json",
        ]
        if name == "candidate":
            allowed_paths.extend([
                ROOT / "tests/vision/fixtures/conversation-eval.json",
                ROOT / "tests/vision/fixtures/conversation-development-v2.json",
            ])
        files = {}
        for path in allowed_paths:
            if path not in metadata_cache:
                metadata_cache[path] = info(path)
            files[str(path.relative_to(ROOT)).replace("\\", "/")] = metadata_cache[path]
        lock = {
            "trial_id": profile["profile_id"],
            "source_revision": "rev9 source-neighbor corrections; prompt-only baseline/candidate comparison",
            "active_prompt_sha256": profile["prompt_sha256"],
            "prompt_bytes": profile["prompt_bytes"],
            "files": files,
        }
        lock_path = profile_dir / "run-lock.json"
        lock_path.write_text(json.dumps(lock, indent=2, ensure_ascii=False) + "\n",
                             encoding="utf-8")
        print(json.dumps({
            "profile": profile["profile_id"],
            "source_sha256": metadata_cache[source_snapshot]["sha256"],
            "prompt_sha256": profile["prompt_sha256"],
            "schema_sha256": profile["schema_sha256"],
            "open_fixture_sha256": files["tmp/language-candidate-20260927/clause-accountable-rev9/open-development.json"]["sha256"],
            "run_lock_sha256": info(lock_path)["sha256"],
            "locked_files": len(files),
        }, indent=2))


if __name__ == "__main__":
    main()
