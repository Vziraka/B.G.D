# Static corpus audit for the September 28 language handoff

Read-only inventory prepared September 30 before new bare inference. No model request, locked probe, live application edit, test edit, or documentation edit was performed. The only new files are in this corpus-audit directory.

## Frozen scope

`scope.json` is the runner-facing manifest. Its SHA-256 is `a9fd3d695f4b40134a2d7db2a1e172d4b9d4177e92004a919ee62c93596db6db`. It fixes every minimum-corpus inclusion decision before new inference. All 274 requests remain in overall reports; 260 are in the reduced-domain subtotal. No score is an acceptance pass, and no new numeric gate is proposed.

The reduced-domain subtotal includes required-action plans, ordinary clarification/negation/correction cases, and mixed core requests containing unavailable/unknown/review-bypass content. Novel wording alone never permits exclusion. The 14 secondary-only requests ask only for unavailable capabilities or explicit instruction attacks without a core intention. All 14 remain visible in overall and refusal-boundary reports. The manifest records each reason.

The schema has no Stop action. None of the 19 inventoried case files contains a clear Stop command. Stop bypass, latency, proposal expiry/one-use confirmation, and late-answer cancellation require separate lifecycle coverage rather than pretending the model should produce an off-schema Stop plan.

## Minimum historical scores

| Corpus | Guarded all | Guarded reduced domain | Policy / source / model | Correct raw answers discarded |
|---|---:|---:|---:|---|
| original30 | 30/30 | 24/24 | 16 / 13 / 1 | None observed |
| development-v2 | 58/58 | 55/55 | 25 / 30 / 3 | None observed |
| rev13-root38 | 25/38 | 25/38 | 17 / 8 / 13 | o02, o18 |
| rev13-worker48 | 38/48 | 38/48 | 14 / 8 / 26 | ord-25 |
| sealed-v3 | 88/100 | 83/95 | 43 / 26 / 31 | None observed |

The original30/development58/worker48 baseline use the selected Rev13 prompt (`baaa4ec9c5228fc98b16a2c70a59b972f8ac3dc5c10c2c720095d52b20ba4117`). Worker48's baseline is `ab-baseline-results.json` (38/48), not the rejected prompt candidate `ab-candidate-results.json` (39/48). The independent Rev13 root corpus is `root-open-probe-rev13/cases.json` (hash `641bde...`); `clause-accountable-rev13/root38-open.json` is a different Rev12 corpus (hash `c65412...`).

Sealed-v3's recorded 88/100 is a Rev7 historical result with prompt `323f002df4f7ec380fe77c7035ba4def20bb154b553839d42466fcfa9e0d17c4`; it is not Rev13 and cannot be represented as a current baseline run. Subsequent replay uses consumed development inputs and is never a new sealed qualification.

These five old runs contain 200 pre-model answers and only 74 observed model completions. Three recorded correct model plans were discarded (root `o02`, `o18`, worker `ord-25`). That count cannot estimate unseen answers on pre-model rows. A new same-completion guard replay must label its own discarded/saved answers separately from these historical counts.

## Normalization and comparison

Use `statuses` and `steps` on corpus rows, `expected_statuses` and `expected_steps` on captured rows. Preserve all allowed status alternatives. Parse actual JSON and run unchanged `validate_semantic_result`. Canonicalize only missing versus empty target for scout/status, as the validator itself removes empty target fields. Keep target text, case, modifiers, number and step order exact; do not use linguistic normalization, reconciliation or message-prose equality while scoring. Malformed/off-schema answers are misses. Preserve raw text and validation failures.

Keep original labels where the deliberately over-refusing replacement would refuse a negated unavailable request whose old expected label is planned. Report such accepted over-refusal limitations separately; do not rewrite the compatibility labels to inflate scores.

Report historical guarded scores, fresh old-sampling bare results, fresh greedy bare results, and frozen-Rev13/current-Rev14 same-completion guard replays as separate columns. A same-completion replay answers the guard-route counterfactual; it does not reproduce the historical sampled run. Keep all-case scores, reduced-domain scores, ordinary clarification/boundary scores, and unavailable/bypass partial-plan counts visible. The owner-language acceptance set is absent, so these measures cannot establish the owner's real requirements.

## All labeled JSON corpora

The inventory found 19 unique byte hashes across 25 paths, totaling 897 case occurrences after byte-identical corpus copies are removed. There are 890 distinct text/context/allowed-status/ordered-step signatures. `inventory.json` preserves every byte-identical alias and known result-file hash. This is a case-file inventory, not a claim that incidental test parametrizations are independent language corpora.

| Canonical path | Cases | SHA-256 | Recorded runs |
|---|---:|---|---:|
| `tests/vision/fixtures/conversation-development-v2.json` | 58 | `24bdbc4d4a1fd40bb17de28082a1c45fc2c9bbfd1fee840389d44fc6c269b299` | 13 |
| `tests/vision/fixtures/conversation-eval.json` | 30 | `f734fc1ab630a236a14b50f8b7e4031b0e92e0fa717130171589bcf28cc95a1b` | 21 |
| `tests/vision/fixtures/conversation-heldout-20260926.json` | 100 | `aebcad0f5b653d9ed68285937b3d5ada3288280bfeb74203829df94eab71b0c0` | 1 |
| `tests/vision/fixtures/conversation-heldout-20260927-v3.json` | 100 | `02befce4589624c66d5fcead0fae5aa53c1a07fb84ffcf4c7ed76fb2fe9c6574` | 1 |
| `tests/vision/fixtures/conversation-open-probe-20260927.json` | 25 | `b741f7038cb9de1dcfd73375576eb928ea6d76b89753f2d88154d04938992e9c` | 2 |
| `tmp/language-candidate-20260927/boundary-redesign-rev14/worker-open.json` | 38 | `3bfd94400c5277bf60496f3bbb33dd6ce55e1288f850cf3f4bc626fc4c89a014` | 0 |
| `tmp/language-candidate-20260927/clause-accountable-rev10/open-development-rev10.json` | 49 | `3523bda4417a6c9b70042c0fd1770f32b0f930ff680272520bd11e63e73ef222` | 1 |
| `tmp/language-candidate-20260927/clause-accountable-rev11/open-development-rev11.json` | 53 | `28a9edfb540f28586a549fba4c00bac51c734a8ffa4c6984a541bd8e85ee01a5` | 2 |
| `tmp/language-candidate-20260927/clause-accountable-rev12/open-development-rev12.json` | 58 | `2787d20b6381cfa79dd122567863be84d6c3f1753f94f5171cdfe4730d5fc504` | 1 |
| `tmp/language-candidate-20260927/clause-accountable-rev12/prompt-ab-rev12.json` | 12 | `8b4e171abd52c2d9afc6030e90a5c1a4dcc9321463a1bbbd028b3993f0cbfd84` | 2 |
| `tmp/language-candidate-20260927/clause-accountable-rev12/root35-open.json` | 35 | `71a2e251cdeeea4c15b67af9eee9631e43c9c46f472d7c252760a2cc882cca3d` | 2 |
| `tmp/language-candidate-20260927/clause-accountable-rev13/root38-open.json` | 38 | `c65412c1a277817e06f120f773283384ba40be5ede601a3affa74f3fc481acdb` | 1 |
| `tmp/language-candidate-20260927/clause-accountable-rev13/worker-open-rev13.json` | 48 | `fea6b3d659bc333e3d0391bd83b79641135c78715b1f2648642cf190e8a16fc2` | 2 |
| `tmp/language-candidate-20260927/clause-accountable-rev8/open-development.json` | 44 | `ad3fd11a50a11796c6af2dcb4743acff3f8443a2b7ea3fad49f73fe2a8e45280` | 1 |
| `tmp/language-candidate-20260927/clause-accountable-rev9/open-development.json` | 49 | `3a3b0adb41ced8384f82c8c28bb8d3ba3875869e5bb5a3573ce28e23e2e7b598` | 2 |
| `tmp/language-candidate-20260927/root-open-probe-boundary-v14/cases.json` | 52 | `1af4de2ba9050025485987cbcfbab6c12b7f40dfaf877d5bff8549658e4bded6` | 0 |
| `tmp/language-candidate-20260927/root-open-probe-rev10/cases.json` | 40 | `ab39951ed8161ac8e70cc74a77c2982661b6d97df87a0086c39289f821d406d3` | 1 |
| `tmp/language-candidate-20260927/root-open-probe-rev13/cases.json` | 38 | `641bde7b91bfd85baf25e58a1c91808360999239240202924f29f0f9215a47d8` | 1 |
| `tmp/language-candidate-20260927/root-open-probe-rev8/cases.json` | 30 | `5a633921da37220274591697c377257e69e8569afdd722c5198d345c69c803be` | 1 |

The Rev14 root 52 and worker38 have no recorded guarded-model evaluation. Read access inventories their labeled development data; their locked runner was never executed. The retired Rev14 predeclared gate is not applicable. Other historical corpus runs are listed in `inventory.json`; source/prompt/configuration distinctions must be retained when selecting comparators. Scope annotations in `scope.json` cover the five minimum corpora only. If additional corpora are scored in the reduced-domain subtotal, freeze their per-case annotations before inspecting new completions.
