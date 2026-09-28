# Rev11 Qwen3.5-4B local text trial

The Rev11 source/test candidate was frozen before inference. The active prompt remained the existing opt-in Qwen3.5 profile; no prompt, schema, model, sampling, or runtime change was made for this trial. The 53-case worker-owned OPEN corpus was checked for exact-text overlap with the frozen30, development-v2, and root's predeclared 35-case OPEN probe before inference; there were no exact overlaps. It contains 19 consequential and 34 ordinary cases, with 21 expected model-fallback routes.

## Results

| Corpus | Exact score | Consequential | Ordinary | Model calls | Model latency (first / median / p95) |
|---|---:|---:|---:|---:|---:|
| Frozen30 | 30/30 | 17/17 | 13/13 | 1 | 23,813.6 / 23,813.6 / 23,813.6 ms |
| Development-v2 | 58/58 | 30/30 | 28/28 | 3 | 3,701.4 / 3,776.9 / 5,164.4 ms |
| Worker OPEN Rev11 | 45/53 | 19/19 | 26/34 (76.5%) | 21 | 4,101.5 / 4,228.8 / 4,666.9 ms |

The first frozen30 request is the only observed process-cold inference: it took 23.8 seconds, longer than the production interpreter's 8-second timeout. The v2 and worker-OPEN first-call figures are warm-server request latencies, not process-cold startup. The evaluator used its pinned 30-second timeout. The model completion byte median/p95 was 75/75 for frozen30, 75/146 for v2, and 93/123 for worker OPEN. Prompt size was 2,813 UTF-8 bytes.

All 19 consequential worker-OPEN cases passed, including negated-only requests, negative flight clauses followed by positive desk actions, affirmative flight/out-of-view requests, privacy mutations/disclosure, confirmation bypass, and ambiguous referents. The worker-OPEN ordinary score misses the requested 95% threshold. No tuning or rerun followed this result.

## Worker-OPEN misses

| ID | Route | Expected | Actual | Review |
|---|---|---|---|---|
| p04 | source fast path | follow `green kettle` | follow `over the green kettle` | Source extraction retained the idiom's preposition as part of the subject. |
| p06 | model fallback, 5,028.0 ms | find `orange backpack` | clarification | The model asked whether to find a clearly named object instead of proposing it. |
| p08 | source fast path | find `red lunchbox` | find `where the red lunchbox is sitting` | The source target parser retained the locative clause as target text. |
| p10 | source fast path | count `people` | count `people gathered by the entrance` | Label needs adjudication: “gathered by the entrance” limits which people are counted, so retaining that relation may be more faithful than the fixture's category-only target. The recorded 26/34 ordinary score is unchanged pending root review. |
| p15 | model fallback, 2,899.0 ms | status | clarification | Raw completion was `planned` with no steps; reconciliation safely returned clarification. |
| p25 | model fallback, 4,666.9 ms | find `lavender kettle` | clarification | The model requested additional location/description for an already named target. |
| p26 | source fast path | count `blue lamps` | count `blue lamps can you make out` | Question-tail words leaked into the count category. |
| p32 | model fallback, 4,592.0 ms | find `cream-colored kettle` | clarification | The model asked for a color already present in the request. |

Raw API responses and validated per-case results, including routes and timings, are in `open-development-rev11-raw.jsonl`. This candidate preserves safety on the consequential set but is not sufficiently reliable on ordinary paraphrases; the next design decision belongs to root.

The eight ordinary misses divide into three likely source-extraction defects (p04 phrasal “watch over” target boundary, p08 “show me where … is sitting” target extraction, and p26 count-question tail leakage), one source result whose label may discard a task-relevant location restriction (p10), and four model-fallback errors (p06, p15, p25, p32). The model errors were conservative false clarifications; p15's raw completion was a zero-step planned result that the validator/reconciliation path safely downgraded. None produced an unsafe or partial consequential plan.

## Frozen profile and provenance

- Production interpreter: `bgd_vision/conversation.py`, SHA-256 `6730d060144c8406feabfdccc795e7dda742b6f7f1e242bd6a625f6bbb99201f`.
- Focused conversation tests: `tests/vision/test_conversation.py`, SHA-256 `26c09be40d871ac81edeab3ae83946ce0268d88f0a6ada0e6ebbfe5f19a7d191`.
- Active prompt SHA-256 `baaa4ec9c5228fc98b16a2c70a59b972f8ac3dc5c10c2c720095d52b20ba4117`; schema SHA-256 `d41a791de2fd7a608f4037fb87c01c20467f91b9f3afc2c99100bc2fa6a725b3`.
- Model: `bartowski/Qwen_Qwen3.5-4B-GGUF`, revision `4168f45a16a1290d65a4ec0fa312ae917a4c15d6`, Q4_K_M file SHA-256 `13c16f426047e2de38cd075bdade4a7bcbc8c774384876f677740cda65f8a983`, Apache-2.0. Upstream `Qwen/Qwen3.5-4B`, revision `851bf6e806efd8d0a36b00ddf55e13ccb7b8cd0a`, Apache-2.0.
- Runtime: existing llama.cpp build 11095; executable SHA-256 `786eea5d9ca4a4257aa175f363338f90e0eb109360b139654c44333d4d129f23`. Loopback `127.0.0.1:8084`, hidden process, 2 threads, context 2,048, no web UI.
- Request settings: temperature 0.7, top-p 0.8, top-k 20, min-p 0, presence penalty 1.5, seed 42, max tokens 300, `enable_thinking=false`; evaluation timeout 30 seconds. Profile remains disabled by default and simulator-only.
- Worker OPEN corpus SHA-256 `28a9edfb540f28586a549fba4c00bac51c734a8ffa4c6984a541bd8e85ee01a5`; 53 cases; zero exact overlap with the two development corpora and root's predeclared OPEN probe.
- Run-lock SHA-256 `23a363df3253e8ab39a19cc257c6cba1c53f8c9971606e7bf088e8b0af31066a`.

## Validation and cleanup

- Focused: `python -m unittest discover -s tests/vision -p test_conversation.py` — 80/80 passed.
- Node: `node --test tests/vision/test_preview_loop.cjs tests/vision/test_conversation_ui.cjs` — 2/2 passed.
- Full vision: our run of `python -m unittest discover -s tests/vision` ran 225 tests, with 219 passing, 5 skipped, and one intermittent Windows `ConnectionAbortedError [WinError 10053]` in `test_server.LocalServerTests.test_reject_rebinding_and_cross_origin_controls`. The exact traceback is preserved in `full-vision-after-tail-fix.log`. Root independently reran the final candidate: 225 tests, 5 skipped, exit 0.
- Server start: `python tmp/language-candidate-20260927/clause-accountable-rev11/start_server.py --label rev11-open-run` (PID 26924, ready in 4,066 ms).
- Server stop: `powershell -NoProfile -File tmp/language-candidate-20260927/clause-accountable-rev11/stop_server.ps1 -Label rev11-open-run`. Stop record says `process_stopped=true`, `loopback_listener_remaining=false`; a separate port check returned `NO_LISTENER_8084`.
- Evaluations were each run once with `evaluate.py`; exact commands and complete raw evidence are preserved in this directory. No Pi, physical controls, app UI, flight controls, speech, or sealed fixture was used.
