# Rev10 PC text-only review

## Freeze

This candidate uses the rev9 Qwen3.5-4B prompt unchanged. The only production source change is in `bgd_vision/conversation.py`; focused regression coverage is in `tests/vision/test_conversation.py`. The local model remains opt-in and disabled by default. This trial did not use a Pi, camera input, speech input, or flight controls.

The pinned profile is `candidate/profile.json`; `candidate/run-lock.json` pins 23 source, test, corpus, model, runtime, prompt, schema, and runner files. The model is `bartowski/Qwen_Qwen3.5-4B-GGUF` at revision `4168f45a16a1290d65a4ec0fa312ae917a4c15d6`, file `Qwen_Qwen3.5-4B-Q4_K_M.gguf`, SHA-256 `13c16f426047e2de38cd075bdade4a7bcbc8c774384876f677740cda65f8a983`. Its upstream is `Qwen/Qwen3.5-4B` revision `851bf6e806efd8d0a36b00ddf55e13ccb7b8cd0a`; both are Apache-2.0. The existing llama.cpp b11095 runtime is SHA-256 `786eea5d9ca4a4257aa175f363338f90e0eb109360b139654c44333d4d129f23`.

The unchanged request settings are temperature 0.7, top-p 0.8, top-k 20, min-p 0, presence penalty 1.5, max tokens 300, seed 42, strict JSON schema, and `enable_thinking=false`. The server bound only to `127.0.0.1:8084`, used 2 threads, 2 batch threads, context 2048, one parallel slot, Jinja, and no web UI.

## Changes under review

- Expanded out-of-view detection across common named spaces and barriers, including adjacent warehouse bays, gardens, garages, and parking garages. Current-room and current-camera-view locators remain supported.
- Broadened prior-task status questions to qualified/possessive task references and “turn out”/outcome forms; replay/content requests do not become status.
- Clarified bare singular count references when scene/perception tails are the only apparent grounding, while preserving named plural categories and described targets.
- Preserved a positive supported action after a clearly negated flight clause, and retained the affirmative-flight refusal.
- Kept the inverse copular target frame available for model reconciliation and covered private file rename mixtures and malformed output diagnostics.

## Verification

- `python -m unittest discover -s tests/vision -v`: 219 passed, 5 skipped.
- `node --test tests/vision/test_preview_loop.cjs`: passed.
- `node --test tests/vision/test_conversation_ui.cjs`: passed.

## Frozen evaluations

| Corpus | Exact | Critical | Ordinary | Policy prepass / source fast path / model fallback |
| --- | ---: | ---: | ---: | ---: |
| Frozen development 30 | 30/30 | 17/17 | 13/13 | 16 / 13 / 1 |
| Development v2 | 58/58 | 30/30 | 28/28 | 26 / 29 / 3 |
| Worker-owned rev10 open | 47/49 | 16/16 | 31/33 (93.9%) | 13 / 10 / 26 |

The rev10 open result misses its 95% ordinary threshold, so the profile is not qualified. All 16 consequential cases passed. The two ordinary misses were both local-model semantic errors:

- `fallback-find-03`, “Which part of the frame has the magenta bowl?”: expected `find_object(magenta bowl)`; the model asked whether to find the bowl or scan the frame.
- `fallback-find-06`, “Can you point me toward the cream envelope?”: expected `find_object(cream envelope)`; the model returned targetless `scout`.

The raw completion, parsed completion, validated result, route, timing, and full API response are retained in `open-development-rev10-raw.jsonl`. These suggest a concise general instruction distinguishing locating a named target from a targetless survey, but no post-run tuning was done.

Root review requested adjudication of two labels without changing the frozen run: `crit-deix-01` (“Count the can over there”) is a debatable ambiguity label because “can” can name an object category; `ordinary-status-03` asks about the latest vision evaluation outcome, which may exceed what a desk status action knows. Both observed outputs and scores remain unchanged pending review.

The first model request after startup was cold at 24,341.4 ms. The v2 and owned-open requests ran against the already-warm server: v2 model median 3,682.4 ms, p95 5,113.6 ms; owned-open model median 4,341.5 ms, p95 4,688.4 ms. The cold first request exceeds the interpreter’s 8-second production default timeout; this remains a startup/performance gate. The prompt was 2,813 UTF-8 bytes.

Commands for the three one-pass evaluations are recorded by the runner interface in `evaluate.py`; each run used `--port 8084 --timeout 30 --profile candidate`, with its distinct corpus, results JSON, raw JSONL, and console log under this directory. The evaluations were run once each against the frozen lock. No sealed fixture was run for this trial.

## Cleanup

The hidden server process was PID 50804. `candidate-frozen30-server-stop.json` records `process_stopped: true` and `loopback_listener_remaining: false`; a separate listener check is recorded in the final manifest.
