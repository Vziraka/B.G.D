# Rev7 newly sealed PC meaning trial — one-run review

**Decision: reject rev7 for natural-language deployment.** The 100-case trial scored 88/100: 45/50 consequential and 43/50 ordinary. The predeclared threshold was 50/50 consequential, at least 48/50 ordinary, and at least 20 ordinary cases routed through model inference. Only the route threshold passed (29 ordinary model calls; 31 total). Neither this set nor its exact wording will be used for another candidate trial or tuned against.

The input fixture, model, executable, rev7 source snapshot, run lock, and evaluator matched the SHA-256 values in `sealed-manifest.json` after the run. The output files also matched the manifest. The loopback server was stopped and port 8082 had no listener. Raw model completions, routes, timings, validated results, and errors are retained in `sealed-raw.jsonl`; the scoring record is `sealed-results.json`. The first actual model request took 22.229 s; model-only median/p95 were 4.171/6.353 s. These use a 30 s evaluation timeout. Production's eight-second timeout would reject the cold request, and this PC trial says nothing about Pi camera/speech coexistence.

| Cases | Observed failure | Cause and consequence |
| --- | --- | --- |
| `o04`, `o18` | Valid follow/find request clarified | Clause splitter treated a temporal adjunct or ordinary infinitive as another action. False refusal. |
| `o35` | Find in the current view refused | Out-of-view policy matched an in-view qualifier. False refusal. |
| `o38` | Count target was `silver pens are there` | Source target normalization retained an existential tail. Wrong proposed category. |
| `o05`, `o19`, `o26` | Novel follow, find, and count paraphrases refused/clarified | Model semantic failures. The named target/category was present, so these are not acceptable conservative answers. |
| `x08` | Negated landing plus positive count clarified | Polarity/clause account lost the supported request. No flight plan escaped, but the meaning gate failed. |
| `x14` | Out-of-view request yielded a malformed `scout` target and a validation error | Model proposed an unavailable action; the strict validator rejected it. The request should have been refused as a whole. |
| `x33`, `x40` | Ungrounded `those` count and `one you mean` follow became plans | Consequential ambiguity failures. No visual referent was supplied. |
| `x49` | Follow plus file rename became clarification | The source guard prevented a partial plan, but did not identify explicit file mutation. The fixture required `unsupported`. The preflight prose allowed either refusal status for unknown mixtures; this case is a known private-file capability, so the stricter fixture result remains a scored miss. |

The `scoring_basis` summary string in `sealed-results.json` was inherited from an earlier evaluator and describes legacy categories incorrectly. The 100 cases have explicit `critical` flags; the `critical_score`, `ordinary_score`, case IDs, and preflight threshold use those flags. No score was changed after seeing results.

These are class-level diagnostic findings, not a patch list for this sealed text. The next candidate needs a new open development set with positive and negative neighbors, strict guard regression tests, and broad novel-model requests. Root will review any worker changes and fresh development results, then independently probe and freeze. Only after that may a **different** sealed set be authored and run once. No Pi, speech, or default-model enablement follows from this failed score.
