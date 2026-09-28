"""Freeze Rev13 prompts, open corpora, pinned model/runtime and verifier inputs."""

import hashlib
import json
import re
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


def norm(text):
    return " ".join(re.findall(r"[a-z0-9]+", text.casefold()))


def route_and_static_result(case):
    text = conversation.clean_text(case["text"])
    result = conversation._request_policy_result(text, case.get("context"))
    route = "policy_prepass" if result is not None else None
    if result is None:
        result = conversation._source_grounded_plan(text, case.get("context"))
        route = "source_fast_path" if result is not None else "model_fallback"
    return route, result


def main():
    prior_path = ROOT / "tmp/language-candidate-20260926/qwen35-manifest.json"
    prior = json.loads(prior_path.read_text(encoding="utf-8"))
    model_path = ROOT / prior["model"]["local_file"]
    runtime_path = ROOT / prior["runtime"]["executable"]
    for path, size, digest, label in (
        (model_path, prior["model"]["bytes"], prior["model"]["sha256"], "model"),
        (runtime_path, prior["runtime"]["executable_bytes"], prior["runtime"]["executable_sha256"], "runtime"),
    ):
        if not path.is_file() or path.stat().st_size != size or sha256_file(path) != digest:
            raise SystemExit(f"Pinned {label} file does not match prior verified provenance")

    baseline_path = HERE / "prompt-baseline.txt"
    candidate_path = HERE / "prompt-candidate.txt"
    baseline = baseline_path.read_text(encoding="utf-8")
    candidate = candidate_path.read_text(encoding="utf-8")
    if baseline != conversation.SYSTEM_PROMPT:
        raise SystemExit("Baseline prompt is not byte-for-byte current production SYSTEM_PROMPT")
    anchor = "\nExamples:\n"
    insertion = (
        "\nAt interpretation time the request is text-only; no camera image is supplied, and that is normal. "
        "Do not ask for an image before interpreting or claim to have observed the scene. A question asking where a named visible person or object is, which part of this view contains it, or where it appears requests a find step for that named target; do not answer its unseen location. "
        "A read-only question about current tracker health/state or the status, result, or history of a prior camera task/request maps to status. Do not claim information absent from the available status context. A tracker-status question is not an instruction to follow or track.\n"
    )
    if baseline.count(anchor) != 1 or candidate != baseline.replace(anchor, insertion + anchor):
        raise SystemExit("Candidate prompt is not exactly baseline plus its declared insertion")
    schema_path = HERE / "schema.json"
    if json.loads(schema_path.read_text(encoding="utf-8")) != conversation.SEMANTIC_SCHEMA:
        raise SystemExit("Saved schema differs from current production schema")

    corpus_paths = [
        ROOT / "tests/vision/fixtures/conversation-eval.json",
        ROOT / "tests/vision/fixtures/conversation-development-v2.json",
        HERE / "worker53-open.json",
        HERE / "root35-open.json",
        HERE / "open-development-rev12.json",
        HERE / "root38-open.json",
        HERE / "worker-open-rev13.json",
    ]
    corpora = [json.loads(path.read_text(encoding="utf-8")) for path in corpus_paths]
    known_texts = set()
    for path, cases in zip(corpus_paths[:-1], corpora[:-1], strict=True):
        texts = [norm(case["text"]) for case in cases]
        if len(texts) != len(set(texts)):
            raise SystemExit(f"Duplicate request inside open corpus: {path}")
        known_texts.update(texts)

    worker_cases = corpora[-1]
    worker_texts = [norm(case["text"]) for case in worker_cases]
    if len(worker_cases) != 48 or len(worker_texts) != len(set(worker_texts)):
        raise SystemExit("Worker Rev13 A/B fixture must contain 48 unique cases")
    overlaps = sorted(set(worker_texts) & known_texts)
    if overlaps:
        raise SystemExit("Worker Rev13 A/B fixture overlaps prior open corpora: " + repr(overlaps))
    critical_count = sum(case.get("critical") is True for case in worker_cases)
    focus_count = sum(case.get("category") in {"location-question", "tracker-status", "task-status"}
                      for case in worker_cases
                      if case.get("critical") is not True)
    if critical_count != 16 or len(worker_cases) - critical_count != 32 or focus_count != 18:
        raise SystemExit("Worker Rev13 A/B fixture grouping changed unexpectedly")

    route_counts = {"policy_prepass": 0, "source_fast_path": 0, "model_fallback": 0}
    fallback_ordinary = 0
    static_routes = {}
    for case in worker_cases:
        route, result = route_and_static_result(case)
        route_counts[route] += 1
        if route == "model_fallback" and case.get("critical") is not True:
            fallback_ordinary += 1
        static_routes[case["id"]] = route
        if result is not None:
            if result["status"] not in case["statuses"]:
                raise SystemExit(f"Static path status disagrees with {case['id']}: {result}")
            if result["status"] == "planned" and result["steps"] != case.get("steps", []):
                raise SystemExit(f"Static path steps disagree with {case['id']}: {result}")
    if fallback_ordinary < 20:
        raise SystemExit("Worker Rev13 fixture must have at least 20 ordinary model fallbacks")

    relative_files = [
        "bgd_vision/conversation.py", "bgd_vision/commands.py", "bgd_vision/evaluate_language.py",
        "tests/vision/test_conversation.py", "tests/vision/fixtures/conversation-eval.json",
        "tests/vision/fixtures/conversation-development-v2.json",
        "tmp/language-candidate-20260926/qwen35-manifest.json",
        prior["model"]["local_file"], prior["runtime"]["executable"],
        "tmp/language-candidate-20260927/clause-accountable-rev13/evaluate_rev13.py",
        "tmp/language-candidate-20260927/clause-accountable-rev13/prepare_rev13.py",
        "tmp/language-candidate-20260927/clause-accountable-rev13/start_server.py",
        "tmp/language-candidate-20260927/clause-accountable-rev13/stop_server.ps1",
        "tmp/language-candidate-20260927/clause-accountable-rev13/prompt-baseline.txt",
        "tmp/language-candidate-20260927/clause-accountable-rev13/prompt-candidate.txt",
        "tmp/language-candidate-20260927/clause-accountable-rev13/prompt-delta.md",
        "tmp/language-candidate-20260927/clause-accountable-rev13/schema.json",
        "tmp/language-candidate-20260927/clause-accountable-rev13/settings.json",
        "tmp/language-candidate-20260927/clause-accountable-rev13/ab-selection-rule.md",
        "tmp/language-candidate-20260927/clause-accountable-rev13/worker53-open.json",
        "tmp/language-candidate-20260927/clause-accountable-rev13/root35-open.json",
        "tmp/language-candidate-20260927/clause-accountable-rev13/open-development-rev12.json",
        "tmp/language-candidate-20260927/clause-accountable-rev13/root38-open.json",
        "tmp/language-candidate-20260927/clause-accountable-rev13/worker-open-rev13.json",
    ]
    files = {}
    for relative in relative_files:
        path = ROOT / relative
        if not path.is_file():
            raise SystemExit(f"Frozen input missing: {relative}")
        files[relative] = {"bytes": path.stat().st_size, "sha256": sha256_file(path)}

    prompt_variants = {
        path.name: {"bytes": path.stat().st_size, "sha256": sha256_file(path)}
        for path in (baseline_path, candidate_path)
    }
    sampling = json.loads((HERE / "settings.json").read_text(encoding="utf-8"))["sampling"]
    lock = {
        "trial_id": "clause-accountable-rev13-preselection",
        "trial_date": "2026-09-27",
        "status": "frozen-before-inference",
        "inference_performed": False,
        "files": files,
        "prompt_variants": prompt_variants,
        "model": prior["model"],
        "runtime": {**prior["runtime"], "host": "127.0.0.1", "port": 8084,
                    "threads": 2, "threads_batch": 2, "context_tokens": 2048,
                    "parallel_slots": 1, "flags": ["--jinja", "--no-webui"]},
        "sampling": sampling,
        "ab_fixture": {"path": str(corpus_paths[-1].relative_to(ROOT)).replace("\\", "/"),
                       "sha256": sha256_file(corpus_paths[-1]), "cases": 48,
                       "critical": critical_count, "ordinary": 32, "prompt_focus_location_status": focus_count,
                       "exact_overlap_with_prior_open_corpora": overlaps,
                       "static_route_counts": route_counts,
                       "ordinary_model_fallback_cases": fallback_ordinary,
                       "static_routes_by_case": static_routes},
        "corpora": {str(path.relative_to(ROOT)).replace("\\", "/"):
                    {"sha256": sha256_file(path), "cases": len(cases)}
                    for path, cases in zip(corpus_paths, corpora, strict=True)},
        "selection_rule": "tmp/language-candidate-20260927/clause-accountable-rev13/ab-selection-rule.md",
    }
    lock_path = HERE / "run-lock-preselection.json"
    if lock_path.exists():
        raise SystemExit("Refusing to overwrite an existing Rev13 lock")
    lock_path.write_text(json.dumps(lock, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    manifest = {
        "trial_id": lock["trial_id"], "inference_performed": False,
        "run_lock": {"path": str(lock_path.relative_to(ROOT)).replace("\\", "/"),
                     "bytes": lock_path.stat().st_size, "sha256": sha256_file(lock_path)},
        "files": files, "prompt_variants": prompt_variants,
        "model_sha256": prior["model"]["sha256"],
        "runtime_sha256": prior["runtime"]["executable_sha256"],
        "schema_sha256": files["tmp/language-candidate-20260927/clause-accountable-rev13/schema.json"]["sha256"],
        "ab_fixture": lock["ab_fixture"],
        "next_action": "Parent independently reviews this lock; no inference before explicit approval.",
    }
    manifest_path = HERE / "manifest-preselection.json"
    manifest_path.write_text(json.dumps(manifest, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    print(json.dumps({"run_lock": str(lock_path.relative_to(ROOT)).replace("\\", "/"),
                      "manifest": str(manifest_path.relative_to(ROOT)).replace("\\", "/"),
                      "run_lock_sha256": manifest["run_lock"]["sha256"],
                      "worker_sha256": files[relative_files[-1]]["sha256"],
                      "baseline_prompt_sha256": prompt_variants["prompt-baseline.txt"]["sha256"],
                      "candidate_prompt_sha256": prompt_variants["prompt-candidate.txt"]["sha256"],
                      "schema_sha256": manifest["schema_sha256"],
                      "source_sha256": files["bgd_vision/conversation.py"]["sha256"],
                      "test_sha256": files["tests/vision/test_conversation.py"]["sha256"],
                      "route_counts": route_counts, "ordinary_fallbacks": fallback_ordinary,
                      "case_count": len(worker_cases), "exact_overlaps": overlaps}, ensure_ascii=False))


if __name__ == "__main__":
    main()
