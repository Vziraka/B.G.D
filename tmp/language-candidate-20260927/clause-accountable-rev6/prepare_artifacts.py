"""Freeze the reviewed revision-6 sources and pinned local-model profile."""

import hashlib
import json
from pathlib import Path
import shutil
import sys

ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))

from bgd_vision import conversation


MODEL_MANIFEST = ROOT / "tmp/language-candidate-20260926/qwen35-manifest.json"
MODEL_PATH = ROOT / "tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf"
SERVER_PATH = ROOT / "tmp/language-candidate-20260922/windows/llama-server.exe"


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main():
    previous = json.loads(MODEL_MANIFEST.read_text(encoding="utf-8"))
    model = previous["model"]
    runtime = previous["runtime"]
    if (sha256(MODEL_PATH) != model["sha256"] or MODEL_PATH.stat().st_size != model["bytes"]
            or sha256(SERVER_PATH) != runtime["executable_sha256"]):
        raise RuntimeError("Pinned model/runtime does not match its reviewed provenance")

    prompt_path = HERE / "system-prompt.txt"
    schema_path = HERE / "schema.json"
    prompt_path.write_bytes(conversation.SYSTEM_PROMPT.encode("utf-8"))
    schema_path.write_text(json.dumps(conversation.SEMANTIC_SCHEMA, indent=2) + "\n",
                           encoding="utf-8")
    shutil.copyfile(ROOT / "bgd_vision/conversation.py", HERE / "conversation-revision6.py")
    shutil.copyfile(ROOT / "bgd_vision/evaluate_language.py", HERE / "evaluate_language.py")
    for relative in ("tests/vision/test_conversation.py", "tests/vision/test_conversation_http.py",
                     "tests/vision/test_conversation_ui.cjs", "tests/vision/test_server.py"):
        shutil.copyfile(ROOT / relative, HERE / Path(relative).name)

    profile = {
        "profile_id": "qwen35-clause-accountable-rev6",
        "enabled_by_default": False,
        "model": model,
        "runtime": {
            "kind": runtime["kind"],
            "version": runtime["version"],
            "executable": runtime["executable"],
            "executable_sha256": runtime["executable_sha256"],
            "host": "127.0.0.1",
            "port": 8081,
            "threads": 2,
            "batch_threads": 2,
            "context": 2048,
            "parallel": 1,
            "jinja": True,
            "web_ui": False,
        },
        "request": {
            "temperature": 0.7,
            "top_p": 0.8,
            "top_k": 20,
            "min_p": 0,
            "presence_penalty": 1.5,
            "max_tokens": 300,
            "seed": 42,
            "stream": False,
            "chat_template_kwargs": {"enable_thinking": False},
            "response_format": "strict JSON schema",
            "production_interpreter_timeout_seconds": 8,
            "evaluation_timeout_seconds": 30,
        },
        "authority": "simulator-only; local PC text interpretation; no execution",
        "prompt_file": "system-prompt.txt",
        "schema_file": "schema.json",
        "prompt_bytes": len(conversation.SYSTEM_PROMPT.encode("utf-8")),
        "prompt_sha256": sha256(prompt_path),
        "schema_sha256": sha256(schema_path),
    }
    (HERE / "profile.json").write_text(json.dumps(profile, indent=2) + "\n",
                                        encoding="utf-8")

    vision_tests = sorted((ROOT / "tests/vision").glob("test_*.py"))
    node_tests = sorted((ROOT / "tests/vision").glob("test_*.cjs"))
    fixed_paths = [
        ROOT / "bgd_vision/conversation.py",
        ROOT / "bgd_vision/evaluate_language.py",
        ROOT / "bgd_vision/commands.py",
        ROOT / "bgd_vision/server.py",
        ROOT / "tests/vision/fixtures/conversation-eval.json",
        ROOT / "tests/vision/fixtures/conversation-development-v2.json",
        MODEL_PATH,
        SERVER_PATH,
        MODEL_MANIFEST,
        HERE / "evaluate.py",
        HERE / "start_server.py",
        HERE / "prepare_artifacts.py",
        HERE / "build_manifest.py",
        HERE / "score_results.py",
        HERE / "profile.json",
        HERE / "conversation-revision6.py",
        HERE / "evaluate_language.py",
        HERE / "test_conversation.py",
        HERE / "test_conversation_http.py",
        HERE / "test_conversation_ui.cjs",
        HERE / "test_server.py",
        HERE / "full-vision-tests.log",
        HERE / "node-conversation-tests.log",
        HERE / "node-preview-tests.log",
        prompt_path,
        schema_path,
    ] + vision_tests + node_tests

    lock = {
        "trial_id": "qwen35-clause-accountable-rev6",
        "source_revision": "revision-6 with purpose-boundary and scout-intention fixes; frozen before inference",
        "prompt_bytes": len(conversation.SYSTEM_PROMPT.encode("utf-8")),
        "files": {str(path.relative_to(ROOT)).replace("\\", "/"): {
            "sha256": sha256(path), "bytes": path.stat().st_size}
            for path in fixed_paths},
    }
    (HERE / "run-lock.json").write_text(json.dumps(lock, indent=2) + "\n",
                                         encoding="utf-8")
    print(json.dumps({
        "trial_id": profile["profile_id"],
        "prompt_bytes": profile["prompt_bytes"],
        "prompt_sha256": profile["prompt_sha256"],
        "schema_sha256": profile["schema_sha256"],
        "source_sha256": sha256(HERE / "conversation-revision6.py"),
        "model_sha256": model["sha256"],
        "runtime_sha256": runtime["executable_sha256"],
        "lock_files": len(lock["files"]),
    }, indent=2))


if __name__ == "__main__":
    main()
