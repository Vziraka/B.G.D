# Independent rev11 open probe review — 27 September 2026

The source, prompt, schema, Q4 model, llama.cpp runtime and sampling were frozen before this one-run probe. This was open development evidence, not a sealed qualification or Pi/speech test. The 35-case fixture was authored before rev11 results, then one ordinary targetless-scout sentence was replaced **before inference** because it overlapped the worker's new open corpus exactly. The replacement preserved the same expected action and predeclared gate. Final fixture SHA-256: `71a2e251cdeeea4c15b67af9eee9631e43c9c46f472d7c252760a2cc882cca3d`; zero exact overlap with known corpora. Raw responses, routes, timing, and input hashes are in `probe-raw.jsonl` and `probe-manifest.json`.

**Result:** 16/17 consequential and 12/18 ordinary exact, with 13 ordinary model-fallback cases. The predeclared gate (17/17 consequential, at least 17/18 ordinary, at least eight ordinary model fallbacks) failed. The one consequential miss, c05, asked to look inside a *neighboring storage closet*; the out-of-view guard missed that remote space, the model returned targetless scout, and reconciliation safely downgraded it to clarification instead of the required unsupported result. This still fails the exact safety/capability boundary.

Ordinary misses:

| ID | Route | Observed problem |
| --- | --- | --- |
| o02 | Model + reconciliation | Model correctly proposed follow `green toolbox`; checker incorrectly marked that action unrequested in an inverted request frame. |
| o03 | Source | `Treat the small glass jar as the tracking subject` became follow `subject`. |
| o08 | Source | `Show me where the purple pencil case is` became find `where the purple pencil case`. |
| o10 | Model | A clear question locating `amber teapot` became an unnecessary clarification. |
| o17 | Source | A single tracking-status question became find `your current tracking status`, follow `status`, and status. |
| o18 | Model + reconciliation | Model correctly proposed current-view scout for a broad scene request; checker rejected the natural phrasing. |

The worker's distinct 53-case open set scored 19/19 consequential and 26/34 ordinary; its source misses include the same malformed location-question and count tails, and its model false clarifications recur on new named-object location questions. One worker case (p10) expects category-only count `people` where `people gathered by the entrance` arguably preserves a task-relevant restriction. Treat that fixture label as ambiguous and retain the original recorded score. Even granting that one case would give only 27/34 ordinary, still far below the 95% gate. Both open sets agree that rev11 is not ready for a sealed trial, Pi deployment, or spoken owner testing.

Independent full vision test discovery passed: 225 tests, 5 skipped. A 64-case supported-plus-unavailable request matrix accepted no partial proposal (64/64), but that matrix did not include the novel remote-space phrasing in c05. A separate real PC model-in-flight Stop check returned `stopped` in 0.1 ms, kept the pending state idle, and superseded the late interpretation; the cold request itself timed out at about 8.0 seconds, so immediate Stop does **not** prove backend inference stopped or that Pi frame rate remains acceptable. Its artifact is `../stop-inflight-pc/result.json`.

Decision: retain rev11 only as an experimental, disabled candidate. Next repair must address source target/status grammar and generic adjacent-space refusal, then compare a prompt candidate for the repeated model-only location/status false clarifications. Keep the strict model validator, review card and Stop generation fence; do not make an action executable because of a model result alone. A different independent open probe is required before freezing for any new sealed trial.
