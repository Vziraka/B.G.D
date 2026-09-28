"""Create the root probe's pre-inference integration lock after final code review."""

import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(ROOT))
from bgd_vision import conversation

FILES = [
    "bgd_vision/conversation.py",
    "bgd_vision/commands.py",
    "bgd_vision/evaluate_language.py",
    "tests/vision/test_conversation.py",
    "tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf",
    "tmp/language-candidate-20260922/windows/llama-server.exe",
    "tmp/language-candidate-20260927/root-open-probe-boundary-v14/cases.json",
    "tmp/language-candidate-20260927/root-open-probe-boundary-v14/preflight.json",
    "tmp/language-candidate-20260927/root-open-probe-boundary-v14/run_probe.py",
]


def sha(path):
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main():
    destination = HERE / "integration-lock.json"
    if destination.exists():
        raise FileExistsError("Refusing to replace a frozen integration lock")
    if any((HERE / name).exists() for name in ("probe-results.json", "probe-raw.jsonl")):
        raise FileExistsError("Root probe evidence already exists")
    preflight = json.loads((HERE / "preflight.json").read_text(encoding="utf-8"))
    if sha(HERE / "cases.json") != preflight["fixture_sha256"]:
        raise RuntimeError("Independent fixture changed")
    cases = json.loads((HERE / "cases.json").read_text(encoding="utf-8"))
    if len(cases) != preflight["case_count"] or sum(case["critical"] for case in cases) != preflight["critical_count"]:
        raise RuntimeError("Independent fixture counts changed")
    lock = {
        "trial_id": "boundary-v14-independent-open",
        "created_utc": datetime.now(timezone.utc).isoformat(),
        "inference_performed": False,
        "files": {relative: sha(ROOT / relative) for relative in FILES},
        "prompt_sha256": hashlib.sha256(conversation.SYSTEM_PROMPT.encode("utf-8")).hexdigest(),
        "schema_sha256": hashlib.sha256(json.dumps(conversation.SEMANTIC_SCHEMA, sort_keys=True).encode("utf-8")).hexdigest(),
        "gate": {
            "critical": preflight["minimum_critical_correct"],
            "ordinary": preflight["minimum_ordinary_correct"],
            "ordinary_model_fallback": preflight["minimum_ordinary_model_fallback"],
        },
    }
    destination.write_text(json.dumps(lock, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"lock_sha256": sha(destination), "source_sha256": lock["files"]["bgd_vision/conversation.py"], "files": len(FILES), "inference_performed": False}))


if __name__ == "__main__":
    main()
