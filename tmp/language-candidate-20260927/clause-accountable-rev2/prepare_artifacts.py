"""Freeze the exact revision-2 sources and local-model request profile."""

import hashlib
import json
from pathlib import Path
import shutil
import sys

ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))

from bgd_vision import conversation


def sha256(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    prompt_path = HERE / "system-prompt.txt"
    schema_path = HERE / "schema.json"
    prompt_path.write_bytes(conversation.SYSTEM_PROMPT.encode("utf-8"))
    schema_path.write_text(json.dumps(conversation.SEMANTIC_SCHEMA, indent=2) + "\n",
                           encoding="utf-8")
    shutil.copyfile(ROOT / "bgd_vision/conversation.py", HERE / "conversation-revision2.py")
    shutil.copyfile(ROOT / "bgd_vision/evaluate_language.py", HERE / "evaluate_language.py")
    shutil.copyfile(ROOT / "tests/vision/test_conversation.py", HERE / "test_conversation.py")
    shutil.copyfile(ROOT / "tests/vision/test_conversation_http.py", HERE / "test_conversation_http.py")

    profile = {
        "profile_id": "qwen35-clause-accountable-v2",
        "enabled_by_default": False,
        "model_file": "tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf",
        "server": {"host": "127.0.0.1", "port": 8081, "threads": 2,
                   "batch_threads": 2, "context": 2048, "parallel": 1,
                   "jinja": True, "web_ui": False},
        "request": {"temperature": 0.7, "top_p": 0.8, "top_k": 20,
                    "min_p": 0, "presence_penalty": 1.5, "max_tokens": 300,
                    "seed": 42, "stream": False,
                    "chat_template_kwargs": {"enable_thinking": False},
                    "response_format": "strict JSON schema"},
        "authority": "simulator-only; local text interpretation only",
        "prompt_file": "system-prompt.txt",
        "schema_file": "schema.json",
        "prompt_bytes": len(conversation.SYSTEM_PROMPT.encode("utf-8")),
        "prompt_sha256": sha256(prompt_path),
        "schema_sha256": sha256(schema_path),
    }
    (HERE / "profile.json").write_text(json.dumps(profile, indent=2) + "\n",
                                        encoding="utf-8")
    input_paths = [
        ROOT / "bgd_vision/conversation.py",
        ROOT / "bgd_vision/evaluate_language.py",
        ROOT / "tests/vision/test_conversation.py",
        ROOT / "tests/vision/test_conversation_http.py",
        ROOT / "tests/vision/fixtures/conversation-eval.json",
        ROOT / "tests/vision/fixtures/conversation-development-v2.json",
        ROOT / "tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf",
        ROOT / "tmp/language-candidate-20260922/windows/llama-server.exe",
        HERE / "evaluate.py",
        HERE / "start_server.py",
        HERE / "prepare_artifacts.py",
        HERE / "score_results.py",
        HERE / "profile.json",
        HERE / "conversation-revision2.py",
        HERE / "evaluate_language.py",
        HERE / "test_conversation.py",
        HERE / "test_conversation_http.py",
        prompt_path,
        schema_path,
    ]
    lock = {
        "trial_id": "qwen35-clause-accountable-v2",
        "source_revision": "revision-2; frozen before model evaluation",
        "prompt_bytes": len(conversation.SYSTEM_PROMPT.encode("utf-8")),
        "files": {str(path.relative_to(ROOT)).replace("\\", "/"): {
            "sha256": sha256(path), "bytes": path.stat().st_size}
            for path in input_paths},
    }
    (HERE / "run-lock.json").write_text(json.dumps(lock, indent=2) + "\n",
                                         encoding="utf-8")
    print(json.dumps({"prompt_bytes": profile["prompt_bytes"],
                      "prompt_sha256": profile["prompt_sha256"],
                      "schema_sha256": profile["schema_sha256"],
                      "source_sha256": sha256(HERE / "conversation-revision2.py"),
                      "lock_files": len(lock["files"])}, indent=2))


if __name__ == "__main__":
    main()
