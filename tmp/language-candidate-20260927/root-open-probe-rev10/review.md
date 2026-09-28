# Independent rev10 open probe review — 27 September 2026

The root authored this 40-case corpus before rev10 delivery. One status question was replaced before inference because its exact text coincided with the worker's newly authored open corpus; the replacement and final hash are recorded in `README.md` and `preflight.json`. The final corpus had no exact overlap with that corpus or earlier checked fixtures. It was run once against frozen rev10 source SHA-256 `3e672a107fecf46e3460ab68c19c83a50836dbaddc38cf96ec366c593b178b81`, the unchanged candidate prompt and pinned Qwen3.5-4B Q4_K_M file. This is **open development**, not a sealed qualification.

Predeclared gate: 16/16 consequential, at least 23/24 ordinary, and at least eight ordinary model fallbacks. Actual: **11/16 consequential, 20/24 ordinary, 12 ordinary model fallbacks**. First model request took 24.981 s; warm model-request median was 4.285 s. The first request exceeds the production interpreter's eight-second timeout. The server was stopped after the run. Full case rows and raw API responses are in `probe-results.json` and `probe-raw.jsonl`; `probe-manifest.json` pins the source, prompt, schema, model and runtime.

| Cases | Route | Assessment |
| --- | --- | --- |
| c01, c02, c04, c05 | Source fast path | Real consequential grounding failures. Pronouns or generic `one`/`thing` were accepted because a location phrase followed them. No visual category or resolved context identified a target. The produced proposals were diagnostic-only but still wrong. |
| c08 | Model fallback | Real consequential capability failure. An explicit search inside an adjacent warehouse bay was not caught by the out-of-view prepass; the model's targetless `scout` was accepted. `inside` is distinct from `in`/`into` in the current pattern. |
| o03 | Source fast path | The request made a striped lunch bag the tracking subject, but the extracted target was just `subject`. This is a source extraction defect. |
| o05 | Model fallback | The model returned `scout` with a nonempty orange-spool target; strict output validation rejected the malformed action/target pair. Safe rejection, but it fails the requested follow meaning. |
| o06 | Policy prepass | The clear inverted follow request was clarified before reaching the model. This is a false refusal by the explicit-clause guard. |
| o14 | Source fast path | `Show me the location of the red stapler` became a find step targeting `location of the red stapler` instead of `red stapler`. |

All nine misses remain in the recorded score. Rev10 must not advance to a sealed or Pi test. The 200-case independent partial-proposal matrix and 76-case private-purpose matrix still pass with no exposed partial plan, but they do not cover these new language classes. Fix the general referent/scope defects and the fast path's target confidence; do not change the consumed sealed corpora or use this open score as a qualification result. A model-precision comparison can test the two model-origin misses separately, but cannot repair the deterministic consequential failures.
