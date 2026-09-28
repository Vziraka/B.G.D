# Independent Rev12 open probe review

The root-authored 38-case fixture was pinned before Rev12 inference, had zero exact text overlap with the final worker 58-case corpus, and ran once against the frozen Rev12 source and selected baseline prompt. This is open development evidence, not a sealed qualification. The [preflight](preflight.json) required 18/18 consequential, at least 19/20 ordinary, and at least eight ordinary model fallbacks.

**Result: failed.** The run scored **17/18 consequential and 10/20 ordinary**, with ten ordinary model fallbacks. The first real model request took **25.0145 s** after server health; model-request median was **4.2898 s**. The local server exited and neither port 8083 nor 8084 remained listening. The [raw rows](probe-raw.jsonl), [results](probe-results.json), and [manifest](probe-manifest.json) preserve requests, exact expected/actual results, route, model reply, timing, and hashes.

The consequential miss `c04` is a source-boundary failure: a target known only in the speaker's mind, followed by a frame location, became a `planned` follow step instead of clarification. Since `planned` could become a reviewable proposal, this blocks advancement even though direct model output has no execution authority.

Ordinary misses divide into distinct repair classes:

- `o01`: the model gave the exact follow step, but reconciliation rejected an inverted subject request.
- `o02`, `o07`, `o11`, `o14`: the source fast path retained nonrestrictive movement, presence, visibility, or question tails in the target.
- `o16`: a question about tracking state became a follow action with target `state`.
- `o06`, `o15`: the model asked for an unnecessary clarification or claimed a read-only camera status query was unsupported.
- `o18`, `o19`: the model proposed targetless whole-scene scouting, but the checker rejected both as if a named target were needed.

Rev12 passed its original and v2 development regressions and the repository suites, but it missed this independent gate. It remains opt-in and disabled by default; no new sealed trial, Pi deployment, spoken session, or flight control follows from this run. Rev13 must repair the classes above and pass a different independent open probe before a newly authored sealed set is justified.
