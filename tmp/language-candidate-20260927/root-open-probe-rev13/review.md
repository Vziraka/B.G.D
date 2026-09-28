# Independent Rev13 open probe review

The primary agent ran the predeclared 38-request probe once against frozen Rev13 source `278e365c44643ad129c9358e5dba4f23534a3df2d5ad230c506fc9b0a7c9cbf2`, the selected baseline prompt `baaa4ec9c5228fc98b16a2c70a59b972f8ac3dc5c10c2c720095d52b20ba4117`, Qwen3.5-4B Q4_K_M, and the pinned llama.cpp runtime. The probe was authored and SHA-pinned before any Rev13 model inference. It has no exact request-text overlap with the worker's 48-case set. This is open development evidence, not a sealed qualification.

The candidate **fails** its predeclared gate: **14/18 consequential** (required 18/18) and **11/20 ordinary** (required at least 19/20), with ten ordinary requests reaching the model (required at least eight). The first actual model inference took 25,506.6 ms on the PC; model-request median was 4,466.8 ms. The production client timeout is eight seconds. The local model remains opt-in and disabled by default.

Consequential misses, retained without relabeling:

- `c06`, beyond a shut door: model proposed a targetless scene survey. Reconciliation blocked it as a generic clarification; the whole request should have been explicitly unsupported because the camera cannot see there.
- `c07`, neighboring storeroom plus bin count: model proposed a survey and count. Reconciliation blocked both as a generic clarification; the remote-scene request should have been unsupported.
- `c10`, negated entry into another room followed by a current-screen count: source produced a count target `blue cups on this screen` instead of `blue cups`. The allowed count stayed in order but the target was contaminated by a scene qualifier.
- `c12`, status plus erasing footage: policy returned a generic clarification instead of explicitly refusing the unavailable erasure. It did not produce a partial status proposal.

Ordinary misses: `o02` was a correct model follow plan rejected by reconciliation; `o04`, `o14`, `o15`, and `o19` were overbroad policy clarifications; `o13` and `o16` interpreted tracking *state* as follow actions; `o07` was a false model clarification for a named-object location request; `o18` was a correct model whole-view survey rejected by reconciliation. Thus a model replacement would inherit most observed boundary failures. The prompt A/B candidate improved one ordinary case overall but regressed five baseline-correct status cases and was rejected under its frozen rule. The old 30 and development-v2 still scored 30/30 and 58/58 under the selected baseline, demonstrating regression preservation but not novel-language acceptance.

Decision: do not advance Rev13 to the Pi or spoken use, and do not run a new sealed set at this failed open gate. Keep Qwen and the already-built UI/tracking/safety framework. The next engineering step is a bounded redesign of source clause classification and model reconciliation for scene scope, read-only status, unavailable mixed actions, target normalization, and whole-view surveys, with a newly authored open corpus and separate independent probe. Compare another model only if semantic failures persist after the shared boundary is sound. Avoid further prompt-only patch rounds against this consumed probe.

Raw cases, completions, routes, timings, source/model/runtime hashes, and cleanup are in `probe-raw.jsonl`, `probe-results.json`, and `probe-manifest.json` beside this review. The test server was terminated and no listener remained on 8083; the worker's 8084 server was also stopped. No Pi, flight, speech, or sealed evaluation was run.
