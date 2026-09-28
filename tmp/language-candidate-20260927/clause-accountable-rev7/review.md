# Qwen3.5 clause-accountable revision 7

This is the bounded PC text-only revision 7 trial. Production changes are limited to `bgd_vision/conversation.py` and `tests/vision/test_conversation.py`. The profile remains opt-in and disabled by default; the model, prompt, schema, sampling, seed, context, and runtime are unchanged from rev6.

## Revision

The unavailable-capability guard now treats retrieval or disclosure of saved, stored, recorded, captured, archived, private, or personal media as unsupported. It also recognizes `return` and `hand` for private artifact requests. `find` remains outside that rule, preserving visual image search. The infinitive boundary now preserves clear negative-intent frames such as “No need to …” and correction frames such as “Change that to following …”. `following` is accepted as a follow action only in that explicit correction frame, so a location modifier such as “person following the stairs” remains one find request.

Root independently verified the previously failing stored-media/private-artifact cases, the six purpose/plus partial-plan probes, and the 200-case unknown-clause matrix. Its 76-case stored-media/purpose matrix passed 76/76, and its 200-case unknown-clause matrix passed 200/200 conservatively.

## Frozen inputs

- Production interpreter SHA-256: `f471605b09b2af77476db890de5dce6311deb589946c64310aec47610b5fb297`.
- Conversation test SHA-256: `bcf722633af84406d62209aee435e10cd7ab502f3256135e695c56f65f1304de`.
- System prompt: 2,487 UTF-8 bytes, SHA-256 `323f002df4f7ec380fe77c7035ba4def20bb154b553839d42466fcfa9e0d17c4`.
- Strict schema SHA-256: `907be6346e3c6e815ac4b0e2f2cb42c75e1629fa3b8c9d682e6e764609fbf39c`.
- Original development fixture SHA-256: `f734fc1ab630a236a14b50f8b7e4031b0e92e0fa717130171589bcf28cc95a1b`.
- Development-v2 fixture SHA-256: `24bdbc4d4a1fd40bb17de28082a1c45fc2c9bbfd1fee840389d44fc6c269b299`.
- Pinned GGUF: `bartowski/Qwen_Qwen3.5-4B-GGUF`, revision `4168f45a16a1290d65a4ec0fa312ae917a4c15d6`, Q4_K_M, Apache-2.0, SHA-256 `13c16f426047e2de38cd075bdade4a7bcbc8c774384876f677740cda65f8a983`.
- Upstream model: `Qwen/Qwen3.5-4B`, revision `851bf6e806efd8d0a36b00ddf55e13ccb7b8cd0a`, Apache-2.0.
- Existing llama.cpp Windows CPU server build 11095, executable SHA-256 `786eea5d9ca4a4257aa175f363338f90e0eb109360b139654c44333d4d129f23`.
- Run-lock SHA-256: `3d3a613c0833be14a83db9faff0066fb7ee17698d895e2ee911c44338baceeed`.

## Open development results

`conversation-eval.json` matched 30/30 exactly: critical 17/17 and ordinary 13/13, with no errors or misses. Route counts were 16 policy-prepass, 13 source-fast-path, and one model fallback (`p05`). Its cold model latency was 21,679.1 ms; model median and p95 were both 21,679.2 ms. The raw model completion was 75 bytes and produced the expected status result.

`conversation-development-v2.json` matched 58/58 exactly: critical 30/30 and ordinary 28/28, with no errors or misses. Route counts were 25 policy-prepass, 30 source-fast-path, and three model fallbacks (`p10`, `p11`, `a04`). Cold model latency was 22,217.3 ms; median was 4,069.1 ms and p95 was 22,217.4 ms. Model completion lengths had a 75-byte median and 106-byte p95. The three completions returned the expected status, status, and clarification results.

Every case has a raw JSONL row with request route, latency, validated result, and error field. Actual API request/response bodies and unparsed completions are captured for each of the four model calls. There were no model or validation errors. The score summaries and all per-case records are in `frozen30-results.json`, `frozen30-raw.jsonl`, `development-v2-results.json`, and `development-v2-raw.jsonl`.

## Verification and cleanup

The full vision suite ran 202 tests with five skipped; it passed. `test_conversation_ui.cjs` and `test_preview_loop.cjs` passed. The pinned evaluator verified the lock and corpus hashes before inference. Each open corpus was evaluated once; no prompt or source changes occurred between runs.

The loopback server ran only on `127.0.0.1:8081`. PIDs 46120 and 30692 were stopped after the respective runs. Both stop records report `process_stopped: true` and `loopback_listener_remaining: false`.

Cold first inference remains about 22 seconds, above the opt-in production interpreter's 8-second timeout. This is a startup/performance risk to review before any user-facing or Pi trial. These results cover synthetic PC text interpretation only, not speech, camera input, hardware, flight control, or deployment qualification.
