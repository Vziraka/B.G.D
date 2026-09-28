# Qwen3.5-4B source-grounded interpreter — revision 5

This PC-only text trial keeps the rev3 Qwen3.5-4B Q4_K_M artifact, llama.cpp b11095 runtime, system prompt, JSON schema, sampling, seed, context and server settings fixed. The model remains opt-in and disabled by default. Revision 5 changes only the local conversation interpreter and focused regression tests. It adds whole-span “keep track of” / “tally of” cues, source-order sorting, trailing “instead” normalization, fail-closed generic deictic/choice handling, a conservative guard for unknown coordinated tails, and broader fixed-camera movement/out-of-view scope detection.

The frozen evaluator captured a route and complete raw model API response for every inference row. Non-inference rows retain the policy/source result. Both fixtures were run once with the same code and profile, each on a fresh loopback-only server; no prompt or source changes occurred between runs.

| Corpus | Exact | Critical | Ordinary | Policy prepass | Source fast path | Model fallback | Cold model inference | Model median / p95 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| frozen30 | 30/30 | 17/17 | 13/13 | 14 | 13 | 3 | 21,806.3 ms | 4,527.3 / 21,806.5 ms |
| development-v2 | 57/58 | 30/30 | 27/28 | 26 | 27 | 5 | 22,096.7 ms | 4,861.2 / 22,096.8 ms |

Frozen30 critical cases use the fixture’s documented legacy grouping: ambiguity, negation, unsupported and injection (a/n/u/i); ordinary cases are paraphrase, description, correction and multiple (p/d/c/m). Development-v2 uses its explicit `critical` field. The expected decision boundaries pass: all consequential development-v2 cases pass, and its ordinary score is 27/28. There is one ordinary miss:

- **m02, ordinary:** “Count shoes and report current status” expected count shoes followed by status. The raw model completion contains those exact ordered steps, but reconciliation returned clarification because the coordinated-tail guard does not recognize “report current status” as a complete status cue at the conjunction. This is a conservative false refusal, not an unsafe partial proposal. The complete raw response, validated result and route are in `development-v2-raw.jsonl`.

Source-order cases, named count categories, the new cue spans, generic deictic/choice requests and the specified movement/out-of-view examples passed the focused regression checks. The narrow modifier conjunction “black and white mug” still falls back to the model and is accepted only when the complete phrase is retained. Unknown coordinated tails such as “archive footage”, “shred records” and “paint walls” cannot be laundered into a supported target when a model proposes only the first action.

Focused verification passed: 41 conversation tests, 13 authenticated HTTP tests, and the Node UI regression script. The old frozen30 model fallback used p05, a03 and i04; development-v2 used p10, p11, c04, m02 and a04. First model inference was about 22 seconds on both runs, longer than the production interpreter’s 8-second default timeout. Measure a startup or timeout strategy before any user-facing or device trial.

The two llama-server processes ran only on `127.0.0.1:8081`, with `--no-webui`, and were stopped after each corpus. Final verification found no `llama-server.exe` process and no listener on port 8081. No Pi, camera service, UI runtime, physical device or flight controls were used. No held-out corpus was accessed.

Run-lock SHA-256: `f2df5654feefd6daf55231f8d562d970716e7badad9b8f8c91d4b91ea516387c`. Interpreter SHA-256: `246859d9560658d3355b61c6b25b483dd8734e808a72a2124ea5655267e9fbd2`. Prompt SHA-256: `323f002df4f7ec380fe77c7035ba4def20bb154b553839d42466fcfa9e0d17c4`. Schema SHA-256: `907be6346e3c6e815ac4b0e2f2cb42c75e1629fa3b8c9d682e6e764609fbf39c`. Frozen30 corpus SHA-256: `f734fc1ab630a236a14b50f8b7e4031b0e92e0fa717130171589bcf28cc95a1b`. Development-v2 corpus SHA-256: `24bdbc4d4a1fd40bb17de28082a1c45fc2c9bbfd1fee840389d44fc6c269b299`.
