# Pi conversation work handoff — 28 September 2026

> **Superseded on 30 September by [`pi-language-handoff-2026-09-30.md`](pi-language-handoff-2026-09-30.md).** Step 0 ran as this file required and refuted its central premise: the bare model scored 196/260 against the guard's 234/260 on identical completions, so *Target design*, *Two configuration defects to fix in Step 0* and *Resume in this order* below are **withdrawn**. The Rev1–Rev14 failure analysis and the owner's reduced scope still stand. Read the 30 September file for next actions.

**This handoff supersedes the resume order in [`pi-language-handoff-2026-09-27.md`](pi-language-handoff-2026-09-27.md).** That file remains accurate as a record of the Rev1–Rev14 stop state; its five-step resume plan is withdrawn by owner decision on 28 September. Read it for evidence provenance, not for next actions.

Start with [`CLAUDE.md`](../../CLAUDE.md), [`docs/CURRENT.md`](../CURRENT.md), and [Issue 12](../../.scratch/biometric-guard-drone/issues/12-phone-onboard-interaction.md). Issue 12 remains the live progress checkpoint.

**Nothing in this handoff authorizes a Pi deployment, a spoken owner session, a flight action, or enabling the local model by default.** The desk remains `SIMULATION_ONLY`; the model remains opt-in and off unless `language_port` is passed to the server. Preserve the existing dirty/untracked checkout and all unrelated hardware work.

## Owner decisions, 28 September 2026

The owner reviewed the Rev1–Rev14 evidence and made four decisions. They are authorization, not suggestions.

1. **Scope is reduced.** The requirement is the four mission intents — follow, find people, find objects, scout/count — plus read-only status and Stop, working reliably, with an honest request to rephrase when the system is unsure. Coverage of arbitrary or adversarial phrasing is a nice-to-have, **not** a requirement. The owner states he did not set the "at least 95% exact match on ordinary novel wording" bar; it was an agent-introduced standard.
2. **Response time is not a gate.** Correctness outranks speed. The 8-second client timeout versus the 22–25 s cold first request is a user-experience detail to engineer around, not an acceptance blocker.
3. **Replace the interpretation layer.** The ~1,000-line deterministic clause/target/reconciliation machinery is to be removed rather than revised again, accepting the loss of most of that code.
4. **Work continues in parallel with hardware.** The owner is executing the physical build himself. Language work does not wait for the hover, and must not request owner physical action or block on it.

Open item the owner has not settled: whether to commit `bgd_vision/` and `tests/vision/` to git before the replacement. See *Version-control risk* below and ask once.

## Why the previous approach is being abandoned

Do not re-derive this; it is settled and the evidence is preserved.

- **The deterministic layer, not the model, causes most failures.** Rev13's independent 38-case probe ([`root-open-probe-rev13/probe-results.json`](../../tmp/language-candidate-20260927/root-open-probe-rev13/probe-results.json)) routed 17 requests to the policy prepass, 8 to the source fast path, and only 13 to the model. Of its 13 misses: 5 policy, 3 source, 5 model-route. Root's own [review](../../tmp/language-candidate-20260927/root-open-probe-rev13/review.md) records that two of those five model-route misses (`o02`, `o18`) were *correct model plans discarded by reconciliation*. Genuine model-semantics failures: `o07`, `c06`, `c07` — three of thirteen. The deterministic layers own roughly 77% of misses.
- **It was overfitting and had stopped improving.** Development corpora scored 30/30 and 58/58 on essentially every revision. Independent sets: rev5 19/25; rev7 24/25 (passed) then sealed-v3 88/100 (failed); rev12 17/18 consequential and 10/20 ordinary; rev13 14/18 and 11/20 — worse than rev12 on ordinary language. Eight independent probes and two sealed sets were consumed, roughly one per revision.
- **The premise was wrong.** The guard re-derives sentence meaning with regular expressions in order to validate the model's meaning. That requires the guard to be a full natural-language understander, which ~60 regexes cannot be. The [boundary-redesign contract](../research/pi-interpretation-boundary-redesign-2026-09-27.md) warned against exactly this and Rev14 repeated it with one shared evidence helper added.
- **The safety justification does not hold.** The [acceptance record](../research/pi-conversation-acceptance-2026-09-26.md) states: *"the confirmation gate still prevents direct execution of the returned plans, but that is insufficient to accept the incorrect interpretation."* That judgment built the 1,695-line file. With the owner reading an exact action/target card and pressing a one-use confirm before anything runs, a misinterpretation costs one rephrase, not a safety incident. The narrow class that *is* dangerous — a silently dropped unavailable clause leaving a partial plan the owner confirms believing he was fully understood — is handled by one fail-closed refusal check that is allowed to over-refuse.

## Never measured, measure before building

**Step 0 is mandatory and comes first.** The model has never once been evaluated without the policy prepass, source fast path, and reconciliation in front of it, on any set. Run it bare against the existing labeled corpora and report the number.

These corpora are consumed for *tuning*. A route counterfactual is not tuning: no code or prompt is changed in response to individual cases, and the corpora are not being used to claim qualification. Record that distinction in the result file. Use at minimum the original 30, [`conversation-development-v2.json`](../../tests/vision/fixtures/conversation-development-v2.json), the Rev13 root probe (38), the Rev13 worker set (48), and sealed-v3 (100).

Report, for each corpus, side by side:

- guarded pipeline exact match (already known for most) versus bare-model exact match;
- the same two numbers restricted to the **four required intents plus status and Stop**, which is the only scope that now matters;
- how many cases the guard answered before the model saw them;
- how many correct model answers reconciliation discarded.

If the bare model is not clearly better on the reduced scope, stop and report before writing the replacement — the plan below assumes it is, and that assumption is cheap to test and expensive to get wrong.

## Two configuration defects to fix in Step 0

Both are in [`bgd_vision/conversation.py`](../../bgd_vision/conversation.py) `LocalSemanticInterpreter.interpret_with_evidence`. Measure the bare model **with these corrected**, and also report one bare run with the old settings so the effect is attributable.

- **`presence_penalty: 1.5` on a schema-constrained JSON task.** A presence penalty punishes tokens already produced. JSON keys repeat by construction, and target nouns recur across steps. This is a plausible direct cause of the dropped target modifiers and spurious clarifications throughout the Rev9–Rev13 logs. Set it to 0.
- **`temperature: 0.7, top_p: 0.8, top_k: 20` with `seed: 42`.** [`pi-language-model-improvement-options-2026-09-27.md`](../research/pi-language-model-improvement-options-2026-09-27.md) declined to test sampling because these match the Qwen card's non-thinking recommendation. That recommendation is for open-ended chat, not for constrained extraction into a fixed schema, where greedy decoding is standard. Use greedy (`temperature: 0`). This also makes tests reproducible instead of seed-dependent.

Keep the existing `response_format` strict `json_schema` grammar. That lever is already correctly taken.

## Target design

The model does all the interpretation. The deterministic code checks **authority, not meaning**. Aim for roughly 300–400 lines in place of ~1,400.

### Keep, close to verbatim

Line numbers are against the current `bgd_vision/conversation.py` (1,695 lines, SHA-256 `b19406d279243da723ca83fd78c74a8caff3abc251a483963dd39a8da5dd23a8`).

- **Lines 31–195, the unavailable-capability vocabulary.** `_FLIGHT_ACTION`, `_MEDIA_ACTION`, `_PRIVATE_ACCESS_ACTION`, `_STORED_MEDIA_DISCLOSURE_ACTION`, `_PURCHASE_ACTION`, `_IDENTITY_CHANGE_ACTION`, `_CAMERA_MOVEMENT_ACTION`, `_REMOTE_SPACE`, `_OUT_OF_VIEW_ACTION`, `_REVIEW_BYPASS_ACTION`, `_REVIEW_BYPASS_WITHOUT`, `_REVIEW_BYPASS_HIDDEN`, `_UNAVAILABLE_ACTIONS`. This vocabulary was accumulated from fourteen revisions of observed failures and is the highest-value artifact in the file. Do not rewrite it from scratch.
- Lines 14–29 Stop recognition (`STOP_COMMANDS`, `_NATURAL_STOP`, `_LEADING_STOP`) and `is_stop_command`. Stop must keep bypassing the model entirely; the measured 0.1 ms path is a requirement, not an optimisation.
- `SEMANTIC_SCHEMA`, `ACTIONS`, `TARGET_ACTIONS`, `CONFIRM_COMMANDS`, `MANUAL_PERSON_MESSAGE`, `clean_text`, `is_described_human_target`, `_clarification`, `_unsupported`, `validate_semantic_result`.
- `LocalSemanticInterpreter`'s transport: loopback-only connection, the single-flight `busy` lock, size-bounded reads, `last_diagnostic` raw-completion capture. Remove only its calls into the deleted machinery.
- The whole `Conversation` class: 45-second expiry, one-use confirmation, the generation counter that lets Stop supersede a late answer, and `snapshot`.

### Delete

Lines 437–1433, the clause segmenter, polarity analysis, source fast path, target normalisation, ambiguity heuristics, and `_reconcile_model_plan`. Roughly 1,000 lines. `_request_policy_result` (line 1307) is replaced by the single check below.

### The one remaining guard

Deterministic, fail-closed, and **deliberately over-refusing**. If the request text matches any `_UNAVAILABLE_ACTIONS` pattern or `_FLIGHT_ACTION`, refuse the entire request with a specific message naming what cannot be done — regardless of what the model would have said, and without attempting to analyse negation or clause structure.

Over-refusal is the intended behaviour at this scope: it costs the owner one rephrase, and the owner has accepted honest refusal. Under-refusal is the actual hazard, because it produces a partial plan the owner may confirm believing he was fully understood. Do not add polarity handling to recover cases like "don't fly, just count the cups"; record them as known accepted limitations instead.

Do not reintroduce a source fast path, clause accounting, or any check that compares the model's plan against separately parsed evidence. If a failure seems to need one, report it rather than adding it.

### Prompt

Replace the current `SYSTEM_PROMPT` (2,813 bytes, roughly 400 words of prose prohibitions plus four examples). Its clarification instructions demonstrably cause plain requests to be refused: in Rev13's A/B, "find the cobalt watering can" returned *"Do you mean a specific region or the entire current view?"* for six separate ordinary find requests (`ord-01`, `ord-02`, `ord-05`, `ord-06`, `ord-08`, `ord-10`).

Write roughly twelve worked examples covering the four intents, status, a clarification, and a refusal, with the minimum prose needed. Small instruction-tuned models follow demonstrations far better than dense negative rules. Keep it under the 2,048-token context already configured.

### Readiness

Keep the llama.cpp server resident and fire one warmup inference at service start so the first owner request is warm. `/health` returning 200 is not sufficient — the acceptance record notes a real first structured request still took 22.229 s after health passed, because the system-prompt prefill dominates at two threads. Investigate prompt-prefix KV cache reuse. Raise the client timeout from 8 s toward the 30 s ceiling and surface a visible "thinking" state in the UI. None of this is a gate; it is the engineering that makes decision 2 true in practice.

## Do not run the locked probe

[`root-open-probe-boundary-v14/`](../../tmp/language-candidate-20260927/root-open-probe-boundary-v14/) holds 52 sealed cases (`cases.json`, SHA-256 `1af4de2ba9050025485987cbcfbab6c12b7f40dfaf877d5bff8549658e4bded6`) with a predeclared gate of 22/22 consequential and at least 29/30 ordinary. `integration-lock.json` does not exist, so `run_probe.py` cannot run. **Leave it that way.**

Its gate measures the open-vocabulary standard the owner has now withdrawn. Rev13 scored 14/18 and 11/20 against it. Spending the last clean fixture to confirm a probable failure against a retired bar is waste.

**Re-designate those 52 cases as labeled development data** for the new design, and record that re-designation in Issue 12 so nobody later mistakes a score on them for a sealed result. Same for the other corpora: roughly a dozen labeled case files across the original 30, development-v2, sealed-v3, and eight probes — several hundred reviewed requests — are the durable asset from the Rev1–Rev14 work and become the regression suite. They survive deleting the code.

## Acceptance at the reduced scope

The old gates are withdrawn along with the standard they served. Propose replacements in Issue 12 before claiming a pass; do not invent a numeric bar and then grade against it.

- Focused tests for: Stop bypasses the model; a proposal expires and can be confirmed only once; a late model answer cannot supersede a Stop; every result carries `executable: false` and `DIAGNOSTIC_ONLY`; each `_UNAVAILABLE_ACTIONS` family refuses the whole request; malformed or off-schema model output never becomes a proposal.
- The full relevant vision suite and both Node UI checks pass. Rev13's baseline was 238 passed with five expected skips; two intermittent Windows socket-abort attempts were observed and are a known flake, not a regression.
- A static latency replay against the frozen Rev13 baseline in [`boundary-v14-baseline/`](../../tmp/language-candidate-20260927/boundary-v14-baseline/) (8,800 calls: median 0.181 ms, p95 0.966 ms, p99 1.180 ms). Deleting ~1,000 lines should improve this; confirm it does not regress.
- The regression suite above, scored **only on the four required intents plus status and Stop**, reported separately from any wider-phrasing number.
- **The real acceptance set is the owner's own words.** Ask him, once and without blocking on the answer, for twenty to thirty commands phrased the way he would actually speak them. Seed a draft from the existing corpora for him to correct rather than asking him to write it cold. Until that exists, no score in this repo represents the requirement.

Pi camera/tracking/speech coexistence, cold and warm on-device timing, and an owner-attended spoken session remain separate later gates. The [acceptance record](../research/pi-conversation-acceptance-2026-09-26.md) holds the 15 fps, 300 ms display-delay and thermal limits. Note that the existing ten-minute combined-workload run already dipped to 14.2 fps vision and 14.5 fps display against a 15 fps floor **without** a language model running; adding one to the same four cores is an open risk, not a solved problem.

## Version-control risk — unresolved

`bgd_vision/` and `tests/vision/` have **zero files tracked in git**. `git ls-files bgd_vision tests/vision` returns nothing, and they are not covered by `.gitignore` or `.cursorignore` — they were simply never committed. The entire Pi application (conversation, YOLOE tracking, face recognition, range guides, MAVLink monitor, speech) exists only in the working tree, and the Rev1–Rev14 history is manual folder copies under `tmp/language-candidate-20260927/`.

The owner deferred this once and was re-asked on 28 September; he has not decided. Ask once, plainly, then proceed either way:

- **If authorized:** commit the working application and tests as one commit before touching anything, then land the replacement as a second commit. The old code is then permanently recoverable, the replacement is a reviewable diff, and no scratch copy is needed.
- **If not authorized:** copy `bgd_vision/conversation.py` and `tests/vision/test_conversation.py` into `tmp/language-candidate-20260927/boundary-redesign-rev14/` beside the existing Rev14 evidence, verify both SHA-256 hashes against the values below, and only then edit the live files.

Current hashes: `conversation.py` `b19406d279243da723ca83fd78c74a8caff3abc251a483963dd39a8da5dd23a8` (1,695 lines); `tests/vision/test_conversation.py` `5a72f95306ba43fa22a00a810bc54a35b8b120efa71083dec6e999abbd384a3c` (2,094 lines). These match the 27 September handoff, so the checkout is unmodified since that stop.

Do not commit, push, or clean anything else without asking. There are 124 untracked paths and a large set of staged-looking deletions from the retired PC biometric workstream in the tree.

## Resume in this order

1. Ask the owner the single version-control question above, then take the matching branch. Do not wait on the answer to start Step 0.
2. Run Step 0: the bare-model measurement, with corrected sampling and with old sampling, reported side by side and scored both overall and on the reduced scope. Preserve raw completions, routes, timings, and all input hashes under a new `tmp/language-candidate-20260928/` directory. Report the number before writing the replacement.
3. Write the replacement per *Target design*: keep list intact, delete lines 437–1433, one fail-closed refusal check, ~12-example prompt, greedy sampling, resident server with warmup.
4. Rewrite `tests/vision/test_conversation.py` to the behaviours in *Acceptance*. Delete tests that pin literal-phrase behaviour of the removed machinery; preserve lifecycle, Stop, confirmation, schema, and refusal coverage.
5. Run the focused tests, the full vision suite, both Node UI checks, and the static latency replay. Preserve outputs and hashes.
6. Score the regression corpora, report honestly against the reduced scope, and record the outcome plus the 52-case re-designation in Issue 12 and `docs/CURRENT.md`.
7. Stop there. Pi deployment, spoken testing, and enabling the model by default each need separate owner authorization.

Report what fails. A partial honest result at the reduced scope is worth more than a fifteenth revision that scores well on its own examples.
