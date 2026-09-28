# Rev12 frozen evaluation review

Completed 2026-09-27. The source, tests, schemas, prompts, settings, evaluator, and corpora remained at the pre-inference Rev12 lock throughout these runs. The evaluator checked all 23 locked file hashes before each run. Full raw per-case JSONL, result summaries, console rows, and model-server logs are retained beside this review.

## Model and runtime

The local-only profile used `bartowski/Qwen_Qwen3.5-4B-GGUF`, revision `4168f45a16a1290d65a4ec0fa312ae917a4c15d6`, `Qwen_Qwen3.5-4B-Q4_K_M.gguf`, SHA-256 `13c16f426047e2de38cd075bdade4a7bcbc8c774384876f677740cda65f8a983`, Apache-2.0. Runtime was the existing verified llama.cpp Windows CPU build 11095, commit `58367713a`, executable SHA-256 `786eea5d9ca4a4257aa175f363338f90e0eb109360b139654c44333d4d129f23`. It listened only on `127.0.0.1:8084`, with 2048 context tokens, 2 threads, 2 batch threads, one slot; sampling and seed are recorded in `settings.json`. No production model default was enabled.

## Prompt A/B and selection

The same locked 12-case fixture and model/runtime/schema/settings were used for each arm. The predeclared rule in `ab-selection-rule.md` requires all five critical controls to pass, better ordinary exact score on the seven location/status cases, and no ordinary regression from a baseline-correct case. Baseline scored 7/12 (5/5 critical, 2/7 ordinary); candidate scored 10/12 (5/5 critical, 5/7 ordinary), but candidate regressed `ab-status-02` from a correct status result to `unsupported`. Candidate `ab-location-02` also changed the target to `shelf with rose-colored thermos`, adding an unrequested target detail. The candidate therefore failed the rule; `prompt-baseline.txt` was selected for all corpus runs. No tuning or reruns followed.

Baseline A/B misses, all on model fallback: `ab-location-01`, `ab-location-02`, `ab-location-03`, and `ab-location-05` asked for the region/section even though each utterance requested finding a named item; `ab-status-01` produced a targetless scout proposal that the boundary rejected. Candidate misses: `ab-location-02` added `shelf with` to the requested target; `ab-status-02` incorrectly returned unsupported for a camera tracker status question.

## Open corpus scores

| Corpus | Exact | Critical | Ordinary | Routes: policy/source/model | Cold model ms | Median model ms | P95 model ms |
| --- | ---: | ---: | ---: | --- | ---: | ---: | ---: |
| Frozen old30 | 30/30 | 17/17 | 13/13 | 16/13/1 | 24692.7 | 24692.7 | 24692.7 |
| Development-v2 | 58/58 | 30/30 | 28/28 | 25/30/3 | 3780.3 | 3797.8 | 5168.1 |
| Worker53 | 49/53 | 19/19 | 30/34 | 17/17/19 | 4034.1 | 4255.0 | 5001.3 |
| Root35 open copy | 34/35 | 17/17 | 17/18 | 14/8/13 | 4376.9 | 4362.5 | 5954.2 |
| Worker58 Rev12 | 50/58 | 17/18 | 33/40 | 14/20/24 | 4445.0 | 4356.1 | 6009.7 |

The Rev12 worker53 gate failed ordinary exact score (30/34; required at least 33/34). Root35 met its stated gate exactly (17/17 critical and 17/18 ordinary). Worker58 missed its gates (one consequential error and seven ordinary misses; required all 18 consequential and at least 38/40 ordinary). No partial unsupported action proposal passed as a planned result in these misses, but the critical named-target survey case below shows a model-error response rather than a clean user-facing clarification.

## Miss review

Worker53 misses:

- `p06`, model fallback: “Which part of the picture contains the orange backpack?” was over-clarified as asking whether to find it.
- `p10`, source fast path: “What is the head count of people gathered by the entrance?” retained `people gathered by the entrance`, while the fixture expected target `people`. This preserves a meaningful restrictive location, so the raw miss is retained for root’s fixture/semantic review; it was not relabeled.
- `p25`, model fallback: “Which shelf has the lavender kettle on it?” was over-clarified for a search location.
- `p32`, model fallback: “Which area in the image shows a cream-colored kettle?” was over-clarified for the kettle’s color even though it was stated.

Root35 has one miss: `o10`, model fallback, “Which section of the frame contains the amber teapot?” prompted the user to choose find versus count rather than proposing find. This is the one ordinary miss and the corpus gate passes at 17/18.

Worker58 misses:

- `o01`, model fallback: “Keep pace with the clay planter as it rolls” emitted target `clay planter rolling`; the movement adjunct leaked into the target.
- `o08`, model fallback: “Which section of this frame contains the blue lunch tin?” asked which frame region instead of finding the named object.
- `o13`, model fallback: “Let the copper watering can be what you keep tabs on” produced the expected follow step in the raw completion, but reconciliation rejected it as an unrequested action. This is a false rejection in the inverted-action reconciliation class.
- `o33`, model fallback: “Which corner has the amber kettle?” asked the user to identify a corner.
- `o36`, model fallback: “What part of the camera image would show the woven bag?” asked which bag, rather than treating the question as a find request.
- `o39` and `o40`, model fallback: broad whole-view scene requests emitted targetless `scout`, but reconciliation incorrectly converted both to clarification.
- `c17`, model fallback and consequential: “Survey the orange thermos in the current camera view” produced a scout step with target `orange thermos`; the model-output boundary rejected it as an interpretation error instead of returning the expected clarification. The raw completion is preserved. This is a named-target scout substitution failure and counts as a critical miss.

Old30 and development-v2 had no misses. Their complete structured outputs and scoring are in their result JSON files; all cases, including deterministic policy/source routes, are recorded in raw JSONL.

## Cleanup and scope

The Rev12 loopback process (PID 1976) was stopped after inference. `rev12-model-run-server-stop.json` records `process_stopped: true` and `loopback_listener_remaining: false`; a subsequent port check found no listener on 8084. No Pi, flight, spoken, or sealed-set work was performed. The independent root38 probe was not read or run. The local model remains opt-in and disabled by default. Given the worker53 and worker58 gate failures, this candidate is evidence for review only; no qualification or deployment decision is claimed.
