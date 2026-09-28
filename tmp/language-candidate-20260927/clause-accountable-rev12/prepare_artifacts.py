"""Freeze Rev12 inputs and verify model/runtime provenance without loading GGUF into memory."""

import hashlib
import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
sys.path.insert(0, str(ROOT))

from bgd_vision import conversation


def sha256_file(path):
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main():
    model_manifest_path = ROOT / "tmp/language-candidate-20260926/qwen35-manifest.json"
    prior = json.loads(model_manifest_path.read_text(encoding="utf-8"))
    model_path = ROOT / prior["model"]["local_file"]
    runtime_path = ROOT / prior["runtime"]["executable"]
    if not model_path.is_file() or not runtime_path.is_file():
        raise SystemExit("Pinned model or runtime is missing")
    if model_path.stat().st_size != prior["model"]["bytes"]:
        raise SystemExit("Pinned model size differs from prior provenance")
    if sha256_file(model_path) != prior["model"]["sha256"]:
        raise SystemExit("Pinned model hash differs from prior provenance")
    if runtime_path.stat().st_size != prior["runtime"]["executable_bytes"]:
        raise SystemExit("Pinned runtime size differs from prior provenance")
    if sha256_file(runtime_path) != prior["runtime"]["executable_sha256"]:
        raise SystemExit("Pinned runtime hash differs from prior provenance")

    prompt_baseline = (HERE / "prompt-baseline.txt").read_text(encoding="utf-8")
    if prompt_baseline != conversation.SYSTEM_PROMPT:
        raise SystemExit("Baseline prompt copy does not exactly match production SYSTEM_PROMPT")
    schema_path = HERE / "schema.json"
    if json.loads(schema_path.read_text(encoding="utf-8")) != conversation.SEMANTIC_SCHEMA:
        raise SystemExit("Saved schema differs from the production schema")

    corpus_paths = [
        ROOT / "tests/vision/fixtures/conversation-eval.json",
        ROOT / "tests/vision/fixtures/conversation-development-v2.json",
        HERE / "worker53-open.json",
        HERE / "root35-open.json",
        HERE / "open-development-rev12.json",
        HERE / "prompt-ab-rev12.json",
    ]
    corpora = [json.loads(path.read_text(encoding="utf-8")) for path in corpus_paths]
    known_texts = set()
    for path, cases in zip(corpus_paths[:4], corpora[:4], strict=True):
        texts = {case["text"].casefold() for case in cases}
        if len(texts) != len(cases):
            raise SystemExit(f"Duplicate utterance within consumed open corpus: {path}")
        known_texts.update(texts)

    open_cases = corpora[4]
    open_texts = {case["text"].casefold() for case in open_cases}
    if len(open_cases) != 58 or len(open_texts) != len(open_cases):
        raise SystemExit("Rev12 open fixture must contain 58 unique utterances")
    if open_texts & known_texts:
        raise SystemExit("Rev12 open fixture has exact overlap with a known open corpus")
    if sum(case.get("critical") is True for case in open_cases) != 18:
        raise SystemExit("Rev12 open fixture must contain 18 consequential cases")

    route_counts = {"policy_prepass": 0, "source_fast_path": 0, "model_fallback": 0}
    for case in open_cases:
        text = conversation.clean_text(case["text"])
        prepass = conversation._request_policy_result(text, case.get("context"))
        source = None if prepass is not None else conversation._source_grounded_plan(text, case.get("context"))
        route = ("policy_prepass" if prepass is not None else
                 "source_fast_path" if source is not None else "model_fallback")
        route_counts[route] += 1
        result = prepass if prepass is not None else source
        if result is not None and (result["status"] not in case["statuses"]
                                   or ("steps" in case and result["steps"] != case["steps"])):
            raise SystemExit(f"Static path disagrees with Rev12 expected row {case['id']}: {result}")
    fallback_ordinary = sum(
        1 for case in open_cases
        if case.get("critical") is not True
        and conversation._request_policy_result(conversation.clean_text(case["text"]),
                                                case.get("context")) is None
        and conversation._source_grounded_plan(conversation.clean_text(case["text"]),
                                               case.get("context")) is None)
    if fallback_ordinary < 20:
        raise SystemExit("Rev12 open corpus has fewer than 20 ordinary model-fallback cases")

    ab_cases = corpora[5]
    if len(ab_cases) != 12:
        raise SystemExit("Prompt A/B must retain the 7 semantic probes and 5 critical controls")
    ordinary_ab = [case for case in ab_cases if case.get("critical") is not True]
    critical_ab = [case for case in ab_cases if case.get("critical") is True]
    if len(ordinary_ab) != 7 or len(critical_ab) != 5:
        raise SystemExit("Prompt A/B case grouping changed unexpectedly")
    for case in ordinary_ab:
        text = conversation.clean_text(case["text"])
        if (conversation._request_policy_result(text, case.get("context")) is not None
                or conversation._source_grounded_plan(text, case.get("context")) is not None):
            raise SystemExit(f"A/B semantic row must exercise model fallback: {case['id']}")
    for case in critical_ab:
        text = conversation.clean_text(case["text"])
        result = conversation._request_policy_result(text, case.get("context"))
        if result is None:
            result = conversation._source_grounded_plan(text, case.get("context"))
        if (result is None or result["status"] not in case["statuses"]
                or result["steps"] != case["steps"]):
            raise SystemExit(f"Critical A/B control is not covered before inference: {case['id']}")

    relative_files = [
        "bgd_vision/conversation.py",
        "bgd_vision/commands.py",
        "bgd_vision/evaluate_language.py",
        "tests/vision/test_conversation.py",
        "tests/vision/fixtures/conversation-eval.json",
        "tests/vision/fixtures/conversation-development-v2.json",
        "tmp/language-candidate-20260926/qwen35-manifest.json",
        prior["model"]["local_file"],
        prior["runtime"]["executable"],
        "tmp/language-candidate-20260927/clause-accountable-rev12/evaluate.py",
        "tmp/language-candidate-20260927/clause-accountable-rev12/make_prompt_candidate.py",
        "tmp/language-candidate-20260927/clause-accountable-rev12/prepare_artifacts.py",
        "tmp/language-candidate-20260927/clause-accountable-rev12/start_server.py",
        "tmp/language-candidate-20260927/clause-accountable-rev12/stop_server.ps1",
        "tmp/language-candidate-20260927/clause-accountable-rev12/prompt-baseline.txt",
        "tmp/language-candidate-20260927/clause-accountable-rev12/prompt-candidate.txt",
        "tmp/language-candidate-20260927/clause-accountable-rev12/schema.json",
        "tmp/language-candidate-20260927/clause-accountable-rev12/settings.json",
        "tmp/language-candidate-20260927/clause-accountable-rev12/ab-selection-rule.md",
        "tmp/language-candidate-20260927/clause-accountable-rev12/prompt-ab-rev12.json",
        "tmp/language-candidate-20260927/clause-accountable-rev12/worker53-open.json",
        "tmp/language-candidate-20260927/clause-accountable-rev12/root35-open.json",
        "tmp/language-candidate-20260927/clause-accountable-rev12/open-development-rev12.json",
    ]
    files = {}
    for relative in relative_files:
        path = ROOT / relative
        if not path.is_file():
            raise SystemExit(f"Frozen input is missing: {relative}")
        files[relative] = {"bytes": path.stat().st_size, "sha256": sha256_file(path)}

    prompt_variants = {
        name: {"sha256": files[f"tmp/language-candidate-20260927/clause-accountable-rev12/{name}"]["sha256"],
               "bytes": files[f"tmp/language-candidate-20260927/clause-accountable-rev12/{name}"]["bytes"]}
        for name in ("prompt-baseline.txt", "prompt-candidate.txt")
    }
    lock = {
        "trial_id": "clause-accountable-rev12",
        "trial_date": "2026-09-27",
        "files": files,
        "prompt_variants": prompt_variants,
        "model": prior["model"],
        "runtime": {
            **prior["runtime"],
            "host": "127.0.0.1",
            "port": 8084,
            "threads": 2,
            "threads_batch": 2,
            "context_tokens": 2048,
            "parallel_slots": 1,
            "flags": ["--jinja", "--no-webui"],
        },
        "sampling": json.loads((HERE / "settings.json").read_text(encoding="utf-8"))["sampling"],
        "corpora": {
            path.name: {"sha256": sha256_file(path), "cases": len(cases)}
            for path, cases in zip(corpus_paths, corpora, strict=True)
        },
        "open_route_counts": route_counts,
        "open_ordinary_model_fallback_cases": fallback_ordinary,
        "selection_rule": "ab-selection-rule.md",
    }
    lock_path = HERE / "run-lock.json"
    if lock_path.exists():
        raise SystemExit("Refusing to overwrite an existing Rev12 lock")
    lock_path.write_text(json.dumps(lock, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    manifest = {
        "trial_id": lock["trial_id"],
        "status": "frozen-before-inference",
        "inference_performed": False,
        "run_lock": {"path": str(lock_path.relative_to(ROOT)).replace("\\", "/"),
                     "bytes": lock_path.stat().st_size, "sha256": sha256_file(lock_path)},
        "files": files,
        "model_sha256_verified": prior["model"]["sha256"],
        "runtime_sha256_verified": prior["runtime"]["executable_sha256"],
        "baseline_prompt_sha256": prompt_variants["prompt-baseline.txt"]["sha256"],
        "candidate_prompt_sha256": prompt_variants["prompt-candidate.txt"]["sha256"],
        "schema_sha256": files["tmp/language-candidate-20260927/clause-accountable-rev12/schema.json"]["sha256"],
        "open_fixture_sha256": files["tmp/language-candidate-20260927/clause-accountable-rev12/open-development-rev12.json"]["sha256"],
        "prompt_ab_fixture_sha256": files["tmp/language-candidate-20260927/clause-accountable-rev12/prompt-ab-rev12.json"]["sha256"],
        "open_route_counts": route_counts,
        "open_ordinary_model_fallback_cases": fallback_ordinary,
        "selection_rule": "ab-selection-rule.md",
        "next_action": "Root independently checks Rev12 open fixture overlap before model server starts.",
    }
    manifest_path = HERE / "manifest.json"
    manifest_path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps({"run_lock": str(lock_path), "manifest": str(manifest_path),
                      "locked_files": len(files), "route_counts": route_counts,
                      "open_cases": len(open_cases), "open_fallback_ordinary": fallback_ordinary,
                      "model_sha256": prior["model"]["sha256"],
                      "runtime_sha256": prior["runtime"]["executable_sha256"],
                      "prompt_baseline_sha256": prompt_variants["prompt-baseline.txt"]["sha256"],
                      "prompt_candidate_sha256": prompt_variants["prompt-candidate.txt"]["sha256"],
                      "schema_sha256": files["tmp/language-candidate-20260927/clause-accountable-rev12/schema.json"]["sha256"],
                      "open_sha256": files["tmp/language-candidate-20260927/clause-accountable-rev12/open-development-rev12.json"]["sha256"],
                      "run_lock_sha256": manifest["run_lock"]["sha256"]}, ensure_ascii=False))


if __name__ == "__main__":
    main()
