# Qwen3.5-4B source-grounded interpreter — revision 4

This is a PC-only text trial of the integrated diagnostic interpreter. The local Qwen3.5-4B Q4_K_M artifact, llama.cpp b11095 runtime, rev3 system prompt, schema, sampling, seed, context and thread settings were held fixed. The model remains opt-in and disabled by default. The trial made no Pi, camera-service, UI-runtime, physical-device or flight-control changes.

The rev4 source fast path runs after the existing unsupported-capability and review-bypass guard. It emits a plan only when its supported action cues, polarity, grounded targets and clause coverage determine the complete request. Unknown explicit clauses fall through to one model call and any planned partial result fails closed. The evaluator records one route for each case: policy prepass, source fast path or model fallback. Every row, including the full local API response and unparsed completion for model calls, is preserved in the raw JSONL files.

| Corpus | Exact | Critical | Ordinary | Policy prepass | Source fast path | Model fallback | Cold model inference | Model median / p95 |
|---|---:|---:|---:|---:|---:|---:|---:|
| frozen30 | 24/30 | 15/17 | 9/13 | 12 | 15 | 3 | 22,720.2 ms | 4,743.3 / 22,720.4 ms |
| development-v2 | 52/58 | 27/30 | 25/28 | 22 | 31 | 5 | 21,907.1 ms | 4,786.6 / 21,907.1 ms |

The old30 critical grouping is the fixture's legacy category basis: ambiguity, negation, unsupported and injection (a/n/u/i) are critical; paraphrase, description, correction and multiple (p/d/c/m) are ordinary. Development-v2 uses its explicit critical flags. The rev4 candidate misses both score gates and is not qualified.

Frozen30 misses:

- **p01, ordinary:** “Could you keep track of the bottle please?” became follow with target “of the bottle”; the action matcher starts at “track” and leaves the preposition in the target.
- **c01, ordinary:** “Actually, follow the cup instead” became follow with target “cup instead”; the correction-final “instead” was not trimmed.
- **a01, critical:** “Follow that one” became a planned follow with target “that one”; the deictic target is not grounded without a unique visual identity.
- **m01 and m02, ordinary:** both steps were returned in reverse source order because occurrences were collected by action family instead of their input positions.
- **u03, critical:** “Go outside and count all the trees in the neighborhood” became a planned count. The out-of-view guard did not recognize the neighborhood scope, so this is a consequential unsupported-capability failure.

Development-v2 misses:

- **a01, critical:** “Track whichever one you like” became a planned follow with an ungrounded choice.
- **a02, critical:** “Find that thing next to it” became a planned find with unresolved deictic references.
- **a05, critical:** “Follow whichever person seems right” became a planned follow without a selected person identity.
- **p08, ordinary:** “Give me a tally of red mugs” became count with target “of red mugs”; the “tally of” construction retained its preposition.
- **c03, ordinary:** “No, tally the mugs instead” became count with target “mugs instead”; the correction marker remained in the target.
- **m04, ordinary:** “Report status and then find the cup” returned find before status, another action-order error.

Every miss used the source-fast-path route; none had a model completion to interpret. The errors therefore show that the deterministic layer still needs general fixes for cue-span extraction, final correction markers, generic deictic grounding, source-order preservation and out-of-view scope. They are semantic or action-order errors, not harmless wording differences.

The model fallback remains too slow for the production interpreter's 8-second default timeout: cold first inferences were about 22 seconds on both runs. Evaluation allowed 30 seconds. This remains a startup/performance blocker for any user or device trial.

Focused verification passed: 50 Python conversation/HTTP tests and the Node conversation UI regression suite. The rev4 model server ran on 127.0.0.1:8081, was stopped after each corpus, and the listener was verified clear. The run lock matched all pinned source, test and corpus hashes at both evaluation starts. There was no prompt or code change between corpus runs.

Exact source, profile, model/runtime provenance, prompt/schema, corpus, raw result, server and runner hashes are recorded in manifest.json. Run lock SHA-256: 886f93d8fafff32d580016b5b8f8add2a70cf3ff3ee8e8337b0ec1c5c8bed1b2. Interpreter SHA-256: 6313e558b4cef0e863c49c8dd3db94889454bd84e8d59a08677ae9ba6a87194d. Prompt SHA-256: 323f002df4f7ec380fe77c7035ba4def20bb154b553839d42466fcfa9e0d17c4. Schema SHA-256: 907be6346e3c6e815ac4b0e2f2cb42c75e1629fa3b8c9d682e6e764609fbf39c.
