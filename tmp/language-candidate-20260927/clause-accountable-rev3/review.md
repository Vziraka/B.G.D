# Qwen3.5 clause-accountable revision 3

This record covers one PC-only run each on the open frozen-30 and development-v2 text fixtures. Revision 3 was frozen before either run; there was no tuning between them. Raw JSONL rows preserve each request payload, full API response, unparsed model completion, validated result or error, and per-case latency.

## Results

| Corpus | Exact | Critical | Ordinary | Model requests | Cold first inference | Median | p95 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Frozen development 30 | 30/30 | 17/17 | 13/13 | 18 | 22,515 ms | 4,281 ms | 22,515 ms |
| Development v2 | 51/58 | 28/30 | 23/28 | 36 | 22,426 ms | 4,392 ms | 6,430 ms |

Frozen-30 scoring uses fixture categories because it has no `critical` field: ambiguity, negation, unsupported, and injection (IDs `a/n/u/i`) are critical; paraphrase, description, correction, and multiple (IDs `p/d/c/m`) are ordinary. Development-v2 uses the explicit `critical` boolean on each fixture row. Latency p95 is the nearest-rank 95th percentile over sorted interpreter times for actual model requests only; each run began with a fresh server process, so its first model request is cold.

The exact system prompt was 2,487 UTF-8 bytes, SHA-256 `323f002df4f7ec380fe77c7035ba4def20bb154b553839d42466fcfa9e0d17c4`. The schema SHA-256 was `907be6346e3c6e815ac4b0e2f2cb42c75e1629fa3b8c9d682e6e764609fbf39c`. Completion sizes had median/p95 86/136 bytes on frozen-30 and 97/172 bytes on development-v2. Full per-case measurements and raw completions are in the JSONL files.

## Development-v2 misses

Critical misses:

- `n04`, “Do not follow me; find the book”: the model emitted `follow me` despite the negation along with the requested `find_object book`. Polarity reconciliation rejected the whole result rather than proposing a plan with a negated action; the safe clarification still missed the expected affirmative find.
- `n05`, “Avoid the red basket and follow the green basket”: the model returned a clarification asking the user to restate the avoid clause instead of retaining the affirmative follow. No proposal was produced.

Ordinary misses:

- `p01`, “Watch the orange thermos for me”: the model mapped the requested follow to `find_object orange thermos`; target/action reconciliation clarified.
- `p03`, “Keep tabs on the green plant in this frame”: model returned `follow green plant in this frame`; this preserves identity but adds a redundant current-view qualifier, so exact target comparison failed.
- `p07`, “How many lamps are visible?”: model changed the named count category to `people`; target reconciliation clarified.
- `p14`, “Track the child standing near the window”: model added an unrequested `find_person` prerequisite before follow; extra-step reconciliation clarified.
- `c01`, pending follow target “metal bottle,” correction “Switch to the ceramic bowl”: model labeled the change as unsupported camera-mode switching instead of carrying the pending follow action to the new target.

Frozen-30 had no misses. Ambiguity cases `a02` and `a03` now clarify before making a model call; an explicitly distinguished target is allowed when its identity differs from the pending target. All unsupported and bypass cases matched. Development-v2 `n03` treated a visible folder as an object; `p17` mapped “Keep the striped basket in view” to follow without a find or scout prerequisite; the status questions and clear corrections `c02`–`c04` also passed.

## Runtime and limits

The pinned model was `bartowski/Qwen_Qwen3.5-4B-GGUF` revision `4168f45a16a1290d65a4ec0fa312ae917a4c15d6`, file `Qwen_Qwen3.5-4B-Q4_K_M.gguf`, 3,013,027,808 bytes, SHA-256 `13c16f426047e2de38cd075bdade4a7bcbc8c774384876f677740cda65f8a983`, Apache-2.0. Upstream lineage is `Qwen/Qwen3.5-4B` revision `851bf6e806efd8d0a36b00ddf55e13ccb7b8cd0a`, Apache-2.0. The existing llama.cpp b11095 Windows binary has SHA-256 `786eea5d9ca4a4257aa175f363338f90e0eb109360b139654c44333d4d129f23`. Both runs used the same loopback server settings, schema, seed, and sampling profile.

Each run used a hidden server on `127.0.0.1:8081`; the process was stopped afterward and no listener remained. Frozen-30 PID 36312 became ready in 4,083.3 ms; development-v2 PID 23168 became ready in 4,115.8 ms. Readiness and server logs are preserved by run.

The evaluator timeout was 30 seconds, while the opt-in production interpreter default is 8 seconds. The measured cold first inference was 22.4–22.5 seconds, so a real first request can time out with the production default. Measure warmup or timeout behavior before any user or Pi trial.

Focused checks passed: 45 Python conversation/HTTP tests and the Node conversation UI suite. These are desk text checks only; no Pi, camera service, UI runtime, physical device, flight controls, or heldout set was used. The local model remains opt-in and disabled by default.
