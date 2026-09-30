# Pi conversation work handoff — 30 September 2026

**This handoff supersedes [`pi-language-handoff-2026-09-28.md`](pi-language-handoff-2026-09-28.md), whose central premise was measured and refuted.** Read the 28 September file for the Rev1–Rev14 failure analysis and the owner's scope decision, which still stand. Its *Target design*, *Two configuration defects* and *Resume in this order* sections are withdrawn. The 27 September file remains evidence provenance only.

Start with [`CLAUDE.md`](../../CLAUDE.md), [`docs/CURRENT.md`](../CURRENT.md), and [Issue 12](../../.scratch/biometric-guard-drone/issues/12-phone-onboard-interaction.md).

**Nothing here authorizes a Pi deployment, a spoken owner session, a flight action, or enabling the local model by default.** The desk remains `SIMULATION_ONLY`; the model remains opt-in and off unless `language_port` is passed to the server. Do not run the sealed 52-case probe (see below).

## What Step 0 measured

The 28 September handoff required a bare-model measurement before any rewrite, with an explicit instruction to stop if the bare model was not clearly better. It was run on 30 September — 548 bare inferences across five corpora with the unchanged prompt and schema — and the bare model was clearly **worse**. The agent correctly stopped. Evidence: [`measurement-summary.json`](../../tmp/language-candidate-20260928/measurement-summary.json) and the raw per-case files beside it, committed in `fbf1afb`.

On the 260 reduced-scope labels, with **identical model completions** on both sides so the comparison isolates the guard:

| | Bare model | Current Rev14 guard |
|---|---:|---:|
| Reduced scope (260) | 196 | 234 |
| Owner's own commands (23) | 22 | 20 |

The guard rescues **50** wrong model answers and destroys **12** correct ones. The aggregate hides a sign flip, and the decomposition is the whole finding:

| Route | Rows | Saves | Losses | Net |
|---|---:|---:|---:|---:|
| `policy_prepass` | 109 | 37 | 8 | +29 |
| `source_fast_path` | 86 | 12 | 1 | +11 |
| `model_fallback` | 65 | 1 | 3 | −2 |

**45 of the 50 saves are boundary behaviour, not mission comprehension:** negation 13, ambiguity/clarification 6, bypass and injection 7, unavailable capability 11, mixed unavailable-plus-valid 5, correction 2. Only 5 are ordinary comprehension. The single largest cluster is negation — the bare 4B model turns a negated request into a positive action thirteen times. That is a real safety failure and it is the main reason deleting the guard scores worse.

**All 12 losses are ordinary in-scope phrasings the deterministic layer grabbed and got wrong:** "Stay on the copper pot while it crosses this frame", "Please keep the silver flask selected while it moves", "Try to spot the green cap", "Describe everything in the frame, please", three status questions, and — illustrating the mechanism exactly — "Don't lose sight of the blue suitcase", where the same negation rule that earns 13 saves misfires because *don't lose sight of* means keep following.

Two corollaries, both measured:

- **Keep the current sampling settings.** Greedy decoding with zero presence penalty is worse everywhere: 229 guarded versus 233, and 18 versus 22 bare on the owner's commands, where it missed all three status requests. The 28 September handoff's reasoning about `presence_penalty: 1.5` was plausible and wrong. The two parameters moved together so their individual effects are not isolated; since the old settings win, do not spend time isolating them.
- **Rev14 is marginally better than Rev13** (234 versus 233, one fewer prepass loss). The unaccepted Rev14 draft is not a regression.

### The measurement's own limits

State these whenever citing the numbers; they are why the conclusion below is narrow rather than triumphant.

- The 260 labels were authored across fourteen revisions against this pipeline's own conventions, and scoring is strict exact match. That structurally favours the guard on target casing, article stripping and refusal wording. It does not explain the 13 negation saves, which are comprehension, not formatting.
- The owner's 23 commands are the only guard-independent set, and the guard *loses* there. But they are agent-seeded wording the owner approved with "its fine keep it", not his own independent or spoken phrasing, and they contain no adversarial rows at all — zero prepass hits. They cannot refute the 45 boundary saves.
- Both readings are needed. Neither set alone decides this.
- The single bare miss on the owner's commands is `"my backpack"` where the label says `"backpack"` — possessive serialization, not misunderstanding.

## The change to make

**Owner decision, 30 September: neither the full replacement nor a fifteenth regex revision. Narrow the deterministic layer so it decides boundaries, not plans.**

The layer keeps its **detectors** and loses its **plan builder**. Today, when the prepass or source fast path concludes a request is an ordinary in-scope follow / find / scout / status, it constructs the plan itself with regular expressions. That is where all 12 losses come from and where almost none of the value is. After the change, when no detector fires, the sentence goes to the model and the model's validated plan is returned **unedited**.

Governing rule for the whole task: **no deterministic check survives without a measured save count.** Every retained check below cites one. Any check you cannot attribute to saves in `measurement-summary.json` is deleted, and any check you want to add must be justified by a measured miss, not by a hypothetical.

### Retained detectors, with the saves that earn them

- **Unavailable capability and bypass — 23 saves** (unavailable 11, bypass and injection 7, mixed unavailable-plus-valid 5). Keep lines 31–195 of [`bgd_vision/conversation.py`](../../bgd_vision/conversation.py) close to verbatim: `_FLIGHT_ACTION`, `_MEDIA_ACTION`, `_PRIVATE_ACCESS_ACTION`, `_STORED_MEDIA_DISCLOSURE_ACTION`, `_PURCHASE_ACTION`, `_IDENTITY_CHANGE_ACTION`, `_CAMERA_MOVEMENT_ACTION`, `_REMOTE_SPACE`, `_OUT_OF_VIEW_ACTION`, `_REVIEW_BYPASS_ACTION`, `_REVIEW_BYPASS_WITHOUT`, `_REVIEW_BYPASS_HIDDEN`, `_UNAVAILABLE_ACTIONS`. This vocabulary is fourteen revisions of observed failures and is the highest-value artifact in the file. When it fires, refuse the whole request fail-closed and over-refusing, naming what cannot be done. Do not build a partial plan.
- **Negation — 13 saves, 1 loss.** This is the one place a deterministic check on the model's *output* is earned by measurement. Narrow it to exactly this: if the input negates an action and the model's plan contains that action as positive, downgrade to clarification. Fix the known misfire class where `don't` plus a losing or stopping verb is a positive instruction — *don't lose sight of*, *don't stop following*, *never let X out of view*. Nothing beyond that.
- **Ambiguity — 6 saves.** Keep the ungrounded-reference check that asks which of several people or objects is meant. It must produce a clarification question, never a guessed plan.
- **Correction — 2 saves.** Keep resolving a clear correction against pending steps.
- **Stop — required, not scored.** Lines 14–29 `STOP_COMMANDS`, `_NATURAL_STOP`, `_LEADING_STOP` and `is_stop_command`. Stop keeps bypassing the model entirely. Step 0 re-measured it at 0.0012 ms and 0.0019 ms median over 2,000 calls; that path is a requirement.

### Delete

From lines 437–1433: the clause segmenter's plan construction, target normalisation, the source fast path's plan building, the scout/status/count routing heuristics, and `_reconcile_model_plan`'s meaning comparison. Reconciliation discarded 3 correct model plans and contributed 3 of the 12 losses; the only part of it that survives is the narrow negation downgrade above.

Keep `SEMANTIC_SCHEMA`, `ACTIONS`, `TARGET_ACTIONS`, `CONFIRM_COMMANDS`, `MANUAL_PERSON_MESSAGE`, `clean_text`, `is_described_human_target`, `_clarification`, `_unsupported`, `validate_semantic_result`. Keep `LocalSemanticInterpreter`'s transport — loopback-only connection, single-flight `busy` lock, size-bounded reads, `last_diagnostic` raw-completion capture — removing only its calls into deleted code. Keep the whole `Conversation` class: 45-second expiry, one-use confirmation, the generation counter that lets Stop supersede a late answer, and `snapshot`.

Do not reintroduce a source fast path or general clause accounting. If a failure seems to need one, report it rather than adding it.

### What this should score, and why that number is not a forecast

Every one of the 12 losses is by construction a row where the bare model already matched the label. A design that forwards those rows to the model and does not post-edit its plan therefore scores all 12 correct **on this data**, giving roughly 246/260 against today's 234 and the bare model's 196, and restoring 22/23 on the owner's commands.

That is an upper bound computed from the same rows that motivated the change, not a prediction. Report it as such. The residual 14 misses are the 13 `model_fallback` rows where neither the model nor the guard succeeded, plus 1 in the fast path — those are genuine model-semantics failures and are the only place prompt work pays.

### Prompt

Lower priority than the change above, and the reason is measured: the current prompt's weaknesses are concentrated in negation and refusals, which the retained detectors already handle correctly. The real target is the 13 rows where both the model and the guard failed.

When you do reach it, the specific defect is that the clarification instructions cause plain requests to be refused — in Rev13's A/B, "find the cobalt watering can" and five other ordinary find requests returned *"Do you mean a specific region or the entire current view?"*. Replace the 2,813-byte prose-prohibition prompt with roughly twelve worked examples covering the four intents, status, a clarification and a refusal, with minimum prose. Small instruction-tuned models follow demonstrations better than dense negative rules. Stay inside the configured 2,048-token context, and measure against the 13 known both-wrong rows rather than re-scoring the whole corpus.

### Readiness

Keep the llama.cpp server resident and fire one warmup inference at service start. `/health` returning 200 is not sufficient — a real first structured request took 22.229 s after health passed, because system-prompt prefill dominates at two threads. Investigate prompt-prefix KV cache reuse. Raise the client timeout from 8 s toward the 30 s ceiling and surface a visible "thinking" state. None of this is a gate; it is the engineering that makes the owner's latency decision true in practice.

## Do not run the locked probe

[`root-open-probe-boundary-v14/`](../../tmp/language-candidate-20260927/root-open-probe-boundary-v14/) holds 52 sealed cases (`cases.json`, SHA-256 `1af4de2ba9050025485987cbcfbab6c12b7f40dfaf877d5bff8549658e4bded6`) with a predeclared gate of 22/22 consequential and at least 29/30 ordinary. `integration-lock.json` does not exist, so `run_probe.py` cannot run. **Leave it that way.** Its gate measures the open-vocabulary standard the owner withdrew on 28 September.

Re-designate those 52 cases as labeled development data and record the re-designation in Issue 12 so nobody later mistakes a score on them for a sealed result. The same holds for the other corpora: the [static corpus audit](../../tmp/language-candidate-20260928/corpus-audit/audit-notes.md) inventories 19 unique case files totalling 897 case occurrences, and that labeled data is the durable asset from Rev1–Rev14. It survives deleting the code.

## Acceptance at the reduced scope

The old numeric gates are withdrawn with the standard they served. Propose replacements in Issue 12 before claiming a pass; do not invent a bar and then grade against it.

- Focused tests for: Stop bypasses the model; a proposal expires and can be confirmed only once; a late model answer cannot supersede a Stop; every result carries `executable: false` and `DIAGNOSTIC_ONLY`; each `_UNAVAILABLE_ACTIONS` family refuses the whole request; a negated action never becomes a positive plan; malformed or off-schema model output never becomes a proposal.
- **A no-regression check on the 50 saves.** This is the new central test. Each retained detector must still convert its measured saves. A change that improves the 12 losses while giving back negation or bypass saves is a failure, not a tradeoff.
- The full relevant vision suite and both Node UI checks pass. Rev13's baseline was 238 passed with five expected skips; two intermittent Windows socket-abort attempts are a known flake.
- A static latency replay against the frozen Rev13 baseline in [`boundary-v14-baseline/`](../../tmp/language-candidate-20260927/boundary-v14-baseline/) (8,800 calls: median 0.181 ms, p95 0.966 ms, p99 1.180 ms). Deleting code should improve this; confirm it does not regress.
- The regression corpora scored **only on the four required intents plus status and Stop**, reported separately from any wider-phrasing number, and always alongside the measurement limits listed above.
- **The real acceptance set is still the owner's own words.** The 25 agent-seeded commands in [`owner-approved-commands-20260930.json`](../../tmp/language-candidate-20260928/owner-approved-commands-20260930.json) were approved, not authored, by him. Ask once, without blocking, for twenty to thirty commands in his own phrasing. Until that exists, no score in this repo represents the requirement.

Pi camera/tracking/speech coexistence, cold and warm on-device timing, and an owner-attended spoken session remain separate later gates. The existing ten-minute combined-workload run already dipped to 14.2 fps vision and 14.5 fps display against a 15 fps floor **without** a language model running; adding one to the same four cores is an open risk, not a solved problem.

## Version control — resolved

The 28 September handoff's untracked-code risk is closed. `bgd_vision/` and `tests/vision/` are tracked as of `995cd45`, Step 0 evidence is committed as `fbf1afb`, and the repository is pushed to the private remote. Land the change as a reviewable diff against `995cd45`; no scratch copy is needed. Current hashes, unchanged since the 27 September stop: `conversation.py` `b19406d279243da723ca83fd78c74a8caff3abc251a483963dd39a8da5dd23a8` (1,695 lines); `tests/vision/test_conversation.py` `5a72f95306ba43fa22a00a810bc54a35b8b120efa71083dec6e999abbd384a3c` (2,094 lines).

Do not push to `main` without explicit per-instance owner authorization.

## Resume in this order

1. Read `measurement-summary.json` and the route decomposition above. Do not re-run Step 0; it is done and committed.
2. Narrow the deterministic layer per *The change to make*: retained detectors intact, plan builder and meaning reconciliation deleted, in-scope requests forwarded to the model unedited, current sampling settings kept.
3. Rewrite `tests/vision/test_conversation.py` to the behaviours in *Acceptance*, including the no-regression check on the 50 saves. Delete tests that pin literal-phrase behaviour of the removed plan builder; preserve lifecycle, Stop, confirmation, schema, negation and refusal coverage.
4. Re-score the five Step 0 corpora with the new layer against the same committed completions where possible, and report saves and losses by route in the same format, so the change is directly comparable.
5. Run the focused tests, the full vision suite, both Node UI checks, and the static latency replay. Preserve outputs and hashes.
6. Record the outcome, the honest upper-bound caveat, and the 52-case re-designation in Issue 12 and `docs/CURRENT.md`.
7. Only then consider the prompt work, scoped to the 13 both-wrong rows.
8. Stop there. Pi deployment, spoken testing, and enabling the model by default each need separate owner authorization.

Report what fails. A partial honest result at the reduced scope is worth more than a fifteenth revision that scores well on its own examples.
