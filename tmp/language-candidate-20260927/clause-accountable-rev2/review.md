# Qwen3.5 clause-accountable revision 2

This record covers the frozen PC-only text runs on the open `conversation-eval.json` and `conversation-development-v2.json` fixtures. The revision-2 prompt and policy guard were frozen before inference; there was no tuning between either run. Raw JSONL rows contain each request body, complete API response, unparsed completion, validated result or error, and per-case latency.

## Results

| Corpus | Exact | Critical | Ordinary | Model requests | Cold first inference | Median | p95 |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Frozen development 30 | 29/30 | 16/17 | 13/13 | 19 | 21,695 ms | 4,327 ms | 21,695 ms |
| Development v2 | 49/58 | 27/30 | 22/28 | 37 | 22,404 ms | 4,441 ms | 6,148 ms |

Frozen-30 critical scoring uses the fixture's categories because that fixture has no `critical` field: ambiguity, negation, unsupported, and injection (IDs `a/n/u/i`) are critical; paraphrase, description, correction, and multiple (IDs `p/d/c/m`) are ordinary. Development-v2 uses each fixture row's explicit `critical` boolean. Latency p95 is the nearest-rank 95th percentile over sorted interpreter times for actual model requests only; the cold first request is included.

The system prompt was 2,435 UTF-8 bytes, SHA-256 `d8dea525fd490d4f1a1b464720a405006273ca4bb9a94b47e995bbaf24e43e6e`. Frozen-30 completion sizes had median/p95 86/139 bytes; development-v2 had 92/125 bytes. Full per-case values are in the raw JSONL evidence.

## Misses

Frozen-30's sole miss was critical ambiguity case `a02`: “No, the other person in blue,” with pending target “person wearing blue,” was planned as `follow other person in blue`. The model treated “other” as grounded by pending text despite having no visual identity. This is a consequential grounding error.

Development-v2 critical misses were:

- `a03`, “Swap to someone else”: model planned `follow other person` instead of asking which person. This is the same ungrounded-relative-target failure as frozen-30 `a02`.
- `n04`, “Do not follow me; find the book”: model emitted both `follow me` and `find_object book`. The polarity reconciliation correctly rejected the negated action, but the resulting clarification did not match the requested affirmative find step. The model inverted the negation.
- `n05`, “Avoid the red basket and follow the green basket”: model emitted the valid follow plus an unrequested `scout` action. Extra-step reconciliation safely rejected the whole plan, leaving an exact-match miss.

Development-v2 ordinary misses were:

- `p03`: model returned `green plant in this frame` instead of `green plant`; this adds a redundant current-view qualifier but preserves the target identity.
- `p07` and `p09`: model changed the named count categories “lamps” and “dogs” to “people”; target reconciliation returned clarification. These are consequential interpretation failures.
- `p14`: model invented a `find_person` prerequisite before `follow`; extra-step reconciliation rejected the whole proposal.
- `p17`: model mapped “Keep the striped basket in view” to `scout` with a nonempty target. Strict validation returned “This action needs a specific target.”
- `c01`: with pending follow target “metal bottle,” model interpreted “Switch to the ceramic bowl” as `find_object ceramic bowl` rather than correcting the follow target.

All other recorded cases matched the fixture's exact expected status and steps. Development-v2 passed all unsupported and bypass cases; its negation misses were blocked from producing a proposal by reconciliation. `n03` (find a visible folder and leave it untracked), the status cases, and the explicit-description corrections `c02`–`c04` passed.

## Runtime and limits

The pinned model was `bartowski/Qwen_Qwen3.5-4B-GGUF` revision `4168f45a16a1290d65a4ec0fa312ae917a4c15d6`, file `Qwen_Qwen3.5-4B-Q4_K_M.gguf`, 3,013,027,808 bytes, SHA-256 `13c16f426047e2de38cd075bdade4a7bcbc8c774384876f677740cda65f8a983`, Apache-2.0. Upstream lineage is `Qwen/Qwen3.5-4B` revision `851bf6e806efd8d0a36b00ddf55e13ccb7b8cd0a`, Apache-2.0. The runtime was the existing llama.cpp b11095 Windows binary, SHA-256 `786eea5d9ca4a4257aa175f363338f90e0eb109360b139654c44333d4d129f23`. Server settings were loopback `127.0.0.1:8081`, two threads/batch threads, context 2048, one parallel slot, Jinja on, Web UI off. Sampling, seed, schema, and model stayed fixed across both runs.

Each run started a hidden server process and ended with it stopped and no listener on port 8081. Frozen-30 server PID 32136 started in 4,582.6 ms; development-v2 PID 45852 started in 4,119.9 ms. Per-run readiness and server logs are preserved alongside the raw results.

The evaluator uses a 30-second timeout. The opt-in production interpreter's default is 8 seconds, while the first inference took 21.7–22.4 seconds. A real first request using the default timeout can therefore fail; do not trial this profile with users or on Pi until startup/warmup or timeout behavior is measured and addressed.

Focused verification passed: 41 Python conversation/HTTP tests and the Node conversation UI suite. These checks and the model runs are desk text evidence only; they do not qualify camera, identity, flight, Pi, or production use. The profile remains opt-in and disabled by default.
