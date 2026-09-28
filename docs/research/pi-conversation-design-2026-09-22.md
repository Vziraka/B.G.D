# Pi conversation design and candidate evaluation — 22 September 2026

This report covers the current camera desk application, not aircraft control. The owner requested natural conversation, selected-target recovery, clearer testing UI and measured performance under concurrent load. The accepted design is local interpretation first, optional online **command text only** when enabled, exact interpreted-mission confirmation, immediate Stop, and consolidated physical tests. No paid service, online provider, biometric upload or actuator interface was enabled.

## Result and recommendation

Use a small local language model to **propose** a structured mission, followed by independent validation, honest capability checks, target grounding and one-use confirmation. Keep Stop independent of language-model inference. A growing phrase list is not a substitute for conversational interpretation.

No tested local model is **qualified for default use**. The 0.6B and1.7B candidates inverted negation or dropped unsupported parts of requests. Qwen3-4B Q4_K_M improved strict accuracy and handled all four negation cases, but still converted unresolved references into plans, invented a backpack from no context, silently dropped takeoff from a mixed request and accepted “skip the confirmation screen” as an ordinary follow plan. JSON constraints enforce structure, not semantic correctness. Confirmation prevents immediate execution but does not make these interpretation errors acceptable.

| Executed experiment | Strict semantic cases passed | Median response | p95 response | Meaning |
| --- | ---: | ---: | ---: | --- |
| Windows, Qwen3-0.6B Q8_0, original constraint-heavy prompt, 2 CPU threads | 10/30 | 3.908 s | 5.144 s | Often refused supported commands |
| Windows, same model, prompt 2 with positive examples, 2 CPU threads | 12/30 | 1.754 s | 2.811 s | Faster and more useful simple parsing, still incorrect on negation/unsupported requests |
| Pi 5, same model/prompt 2, 1 CPU thread, camera service active | 12/30 | 4.731 s | 7.723 s | Cold first response 14.143 s; no combined ASR/YOLOE qualification |
| Windows, Qwen3-1.7B Q8_0, same prompt 2, 2 CPU threads | 15/30 | 4.230 s | 5.414 s | First request hit the 30-second timeout; negation/unsupported handling still fails |
| Windows, Qwen3-4B Q4_K_M, same prompt 2, 2 CPU threads | 21/30 | 5.875 s | 7.907 s | Negation improved; unresolved references, dropped unsupported clauses and confirmation-bypass wording still fail |
| Windows, same4B and prompt, temperature0/presence penalty0 | 21/30 | 5.802 s | 7.269 s | Identical nine failed case IDs; lower-variance decoding did not repair semantics |
| Windows, same4B, low variance, rationale-first prompt/schema | 21/30 | 6.509 s | 8.747 s | Repaired some normalization/correction cases but regressed negation and still dropped unsupported/bypass clauses |

The baseline and low-variance4B runs failed the same IDs: `p05,p06,c03,a01,a02,a03,u01,u03,i03`. `p06` retained the apparent centered-object meaning with a longer target string, but the current executor would route that string differently, so it remains a strict failure rather than being relabeled. A rationale-first ablation changed which cases failed but still scored21/30: it repaired `p05,p06,c03,a02`, then timed out on cold `p01`, still planned unresolved `a01`, inverted `n01` into positive follow despite saying it was negated, dropped the unsupported clauses in `u01/u03`, honored the confirmation-bypass wording in `i03`, and produced invalid outputs for `a03,a04,i04`. Generating a rationale first therefore did not supply a reliable semantic gate. The corpus checks exact normalized action/target output; it is a development corpus, not a held-out estimate of general language accuracy. The4B file is the older hybrid Qwen3-4B release; its result must not be attributed to the distinct Qwen3-4B-Instruct-2507 model.

Evidence:

- [Original Windows run](../../bgd_vision/evidence/language-qwen3-06b-windows-2026-09-22.json).
- [Windows prompt-2 run](../../bgd_vision/evidence/language-qwen3-06b-windows-prompt2-2026-09-22.json).
- [Actual Pi prompt-2 run](../../bgd_vision/evidence/language-qwen3-06b-pi-2026-09-22.json).
- [Larger Windows candidate](../../bgd_vision/evidence/language-qwen3-17b-windows-prompt2-2026-09-22.json).
- [4B Windows baseline](../../bgd_vision/evidence/language-qwen3-4b-windows-prompt2-2026-09-22.json), SHA-256 `208937b2a65e03782f9d03cb0e9730bcace8cd5904004bb29b7062f2ba994e91`.
- [4B low-variance ablation](../../bgd_vision/evidence/language-qwen3-4b-windows-low-variance-2026-09-22.json), SHA-256 `b4d8b8f65888c042c3cb00987ad2c476e8d09e73e846667c7c17cac0ac46e2ad`. Its canonical sampling-settings hash is `ec71469082921e54427e4062e1ccf64394e074353ef2f29e832a60181fe7a66e`.
- [4B rationale-first ablation](../../bgd_vision/evidence/language-qwen3-4b-windows-rationale-first-2026-09-22.json), SHA-256 `2bec8add1cc1fd53617c059bcb104dba825d4a61d159c1986f8643bb6a6809f5`; prompt/schema/settings hashes `682207718e0bbba6fbe783d4d2901e09d2f1cc1812786c77dd4dbb960b2dbb24` / `97ed8e7717499f7ab4860a103d51ca1df30231ee4e7d25874a79c1ac4ec43487` / `ec71469082921e54427e4062e1ccf64394e074353ef2f29e832a60181fe7a66e`.
- [30-case corpus](../../tests/vision/fixtures/conversation-eval.json) and [runner](../../bgd_vision/evaluate_language.py).

## Current-source findings

The source examined before this change had a regex interpreter limited to four short explicit clauses and 240 characters. Both `/mission/run` and speech transcription directly called the desk executor. The speech prototype allowed at most ten seconds. Multi-step text was diagnosed, not sequenced as an actual mission. These observations come from local source, not third-party documentation.

The [interaction contract](../phone-drone/interaction-contract.md) requires natural wording, explicit acceptance of the exact interpreted mission, offline essentials, separate biometric/liveness authorization and no invented capabilities. The fixed-camera desk remains `SIMULATION_ONLY`, with `actuator_output:false`. Its local browser session token is not qualified aircraft pairing or face/liveness-backed command authority.

Implemented integration:

- [conversation.py](../../bgd_vision/conversation.py) keeps one pending proposal in RAM, expires it after a tunable 45-second engineering baseline, and consumes its opaque ID once. A correction immediately retires the old proposal. Stop invalidates pending and in-flight interpretation. Plain “yes” does not authorize an unrelated or newer proposal.
- The optional local model client sends only the current text and pending structured steps to `127.0.0.1` on a configured port. It has no tools, arbitrary endpoint, API credential, proxy support or cloud fallback. JSON output is validated independently against allowed fields/actions. The server is separately installed and remains disabled by default until qualification.
- Authenticated `/conversation` and `/conversation/confirm` share the same path for typing and speech. `/mission/run` now enters the proposal gate. Spoken confirmation names the proposal shown when recording began. An ASR result returning after Stop or a newer request is discarded.
- `/conversation/cancel` discards a proposal while keeping established tracking. Red Stop clears both trackers. A generation check prevents late language, detection, face association or tracker-initialization results from starting a target after Stop. Slow tracker initialization happens outside the live state lock; only its commit is guarded.
- Proposal IDs and text stay in authenticated responses and RAM; they are omitted from public frame/status metadata and persisted telemetry. Current language mode is a non-sensitive status field. The application remains one shared owner-attended desk session.
- The executor still supports current-view count/find and one grounded follow target. Multi-step execution, general person-description grounding and area scouting remain unfinished capabilities; the conversational gate states those limits rather than executing an incomplete interpretation.

Final verification:147 vision tests ran locally with5 expected platform/model skips and on the Pi with3; all remaining tests passed, along with35 simulator tests and both Node UI suites. Regressions include exact confirmation, replay/correction rejection, privacy, Cancel retaining tracking, Stop during slow language interpretation/ASR/detection/tracker initialization, pause-separated Vosk segments, manual target replacement, stale visual-result rejection and browser microphone abort. The deployed source/UI hashes match, and the restarted live service reports `limited_commands`, `experimental:false`, `online_enabled:false` and `actuator_output:false`. These checks establish software behavior, not camera identity accuracy or flight safety.

## Primary-source candidate comparison

| Candidate | Documented facts | Proposed role and unmeasured limits |
| --- | --- | --- |
| Qwen3-0.6B Q8_0 | Official Apache-2.0 GGUF, 0.6B parameters, 639,446,688-byte artifact; supports disabling thinking. [Official model](https://huggingface.co/Qwen/Qwen3-0.6B-GGUF) | Actual candidate above. Small enough to test alongside vision; rejected for semantic failures, not assumed too heavy. File size is not total runtime RAM. |
| Qwen3-1.7B Q8_0 | Official Apache-2.0 GGUF, 1,834,426,016-byte artifact. [Official model](https://huggingface.co/Qwen/Qwen3-1.7B-GGUF) | Larger comparison using the same corpus. More parameters are not evidence of better project performance. Test first on development host, then Pi if semantics justify it. |
| Qwen3-4B Q4_K_M | Official Qwen3-4B GGUF at revision `bc640142c66e1fdd12af0bd68f40445458f3869b`; 2,497,280,256-byte artifact. [Official model](https://huggingface.co/Qwen/Qwen3-4B-GGUF) | Three Windows configurations above all failed qualification. This older hybrid model is distinct from Qwen3-4B-Instruct-2507. |
| Qwen3.5-0.8B / 2B | Official Apache-2.0 models with vision encoder and hybrid architecture. The small model cards describe prototyping/task-specific research use. The 0.8B card warns about thinking loops and says Qwen3 soft thinking switches are unsupported. [0.8B card](https://huggingface.co/Qwen/Qwen3.5-0.8B), [2B card](https://huggingface.co/Qwen/Qwen3.5-2B) | Current alternatives worth evaluating; do not call Qwen3 the newest family. Need verified GGUF conversion, correct template and text-only runtime compatibility first. No images are needed for intent parsing. No Pi accuracy/speed claim made. |
| SmolLM2-360M-Instruct | Official Apache-2.0 English instruction model and GGUF distribution. [Official GGUF](https://huggingface.co/HuggingFaceTB/SmolLM2-360M-Instruct-GGUF) | Lower-resource comparison if language-model CPU/RAM is limiting; not assumed capable of all required corrections or negation. |
| Vosk model refresh / whisper.cpp | Existing small English Vosk model is listed for RPi; the 128 MB `en-us-0.22-lgraph` is another official English option. whisper.cpp lists Raspberry Pi support and quantized inference. [Vosk models](https://alphacephei.com/vosk/models), [whisper.cpp](https://github.com/ggml-org/whisper.cpp) | Compare ASR separately from interpretation using the same human utterances. Vendor benchmark word-error rates do not measure this owner's microphone, room or propeller noise. Do not change ASR and language model together and attribute improvements to either. |

llama.cpp provides schema-constrained generation, separate generation/prompt CPU-thread limits, bounded context and concurrent-slot settings, and chat-template arguments such as `enable_thinking:false`. Its grammar documentation explicitly distinguishes a schema constraint from explaining the schema/task to the model. This supports a small standalone local process rather than another agent framework or model inside the camera loop. [Official server documentation](https://github.com/ggml-org/llama.cpp/blob/master/tools/server/README.md), [grammar documentation](https://github.com/ggml-org/llama.cpp/blob/master/grammars/README.md).

## Reproduction and acceptance

Assets were downloaded from first-party repositories and verified against published hashes. They stay in ignored/uncommitted `tmp/language-candidate-20260922/`, separate from the camera runtime. No installation into the running camera environment was performed by this research work.

| Asset | Pinned identity | Verified SHA-256 |
| --- | --- | --- |
| Qwen3-0.6B-Q8_0.gguf | HF revision `23749fefcc72300e3a2ad315e1317431b06b590a` | `9465e63a22add5354d9bb4b99e90117043c7124007664907259bd16d043bb031` |
| Qwen3-1.7B-Q8_0.gguf | HF revision `90862c4b9d2787eaed51d12237eafdfe7c5f6077` | `061b54daade076b5d3362dac252678d17da8c68f07560be70818cace6590cb1a` |
| Qwen3-4B-Q4_K_M.gguf | HF revision `bc640142c66e1fdd12af0bd68f40445458f3869b` | `7485fe6f11af29433bc51cab58009521f205840f5b4ae3a32fa7f92e8534fdf5` |
| llama.cpp Ubuntu ARM64 archive | Official release `b11095` | `0bd59277d32712cb335b8e385a49d6809cf12985c64c0619b50124d6bc421720` |
| llama.cpp Windows CPU x64 archive | Official release `b11095` | `170b23e0a52c4bee7afc26912472c9b64c891382fd0d78fd9a8fafe310d571f8` |

The actual Pi loaded the ARM64 build successfully after dependency/version checks. Representative isolated launch (substitute the pinned local model path):

```sh
./llama-server -m /path/Qwen3-0.6B-Q8_0.gguf --host 127.0.0.1 --port 8081 -t 1 -tb 1 -c 2048 -np 1 --jinja --no-webui
python -m bgd_vision.evaluate_language --timeout 30 --corpus tests/vision/fixtures/conversation-eval.json --output bgd_vision/evidence/language-candidate.json
```

Prompt-2 SHA-256 is `ace48a1afd4dbadec78b8f43dc2d54b25ddb18267d33bdc87fd30b437664da3f`; corpus SHA-256 is `f734fc1ab630a236a14b50f8b7e4031b0e92e0fa717130171589bcf28cc95a1b`. Sampling seed is 42, thinking is disabled, output capped at 300 tokens, and temperature/top-p/top-k/min-p/presence penalty are 0.7/0.8/20/0/1.5. Those are test settings, not a promise of deterministic cross-platform floating-point output. The original Windows prompt used a different constraint-heavy prompt without a seed; its artifact records exploratory findings, not the canonical reproduction configuration.

Proposed qualification sequence:

1. Score exact semantic intent and preserved target/conditions on paraphrases, corrections, references, multi-step requests, negation and unsupported actions. Review alternatives that are semantically equivalent separately; never relabel a changed intent as a pass.
2. Add a held-out corpus after choosing the prompt; do not tune directly to the acceptance set. Unsafe action inversion, silently omitted clauses and invented target references block default enablement even if aggregate accuracy improves.
3. On Pi, measure cold/warm proposal latency and cancellation plus whole-system CPU/RSS/temperature/power and camera frame age. Compare one and two language threads only when the vision owner schedules the experiment. Preserve the existing 15 fps vision/display floor; do not weaken it to make a model pass.
4. Repeat with active target tracking, visual re-detection and ASR, then the consolidated physical speech/camera test. A camera looking at a wall is compute contention evidence, not tracking correctness. The Pi language run here lacked a representative moving target and independent isolated display conditions.
5. Online text assistance remains optional and disabled pending a real provider configuration and spending authorization if required. If added, transmit only consciously submitted command text and the minimum text context; never frames, audio, face features, credentials or unrestricted logs. Both local and online outputs must pass identical confirmation and execution gates.

## Remaining integration and evidence gaps

The local model is experimentally callable but not qualified to replace the explicit-command baseline. General conversation, robust multi-step mission execution, open-ended descriptions with spatial relations, cross-turn reference to actual scene identities and broad natural voice correction remain required and unfinished. Current fallback messages must make that limitation clear. The model cannot make a detector understand a relation that its visual pipeline does not implement.

One Astra agent owned planning, consequential decisions and final review; one Sol medium worker owned the bounded implementation, testing, deployment and model experiments. This prevented simultaneous uncontrolled Pi workloads. Real microphone acceptance, native phone work and aircraft actuation remain outside this desk change.

Source provenance: checkout `main`, base commit `e760b7bdc83cf45f6089ea291b026856ad717557`; the working tree contains extensive pre-existing uncommitted changes, and `bgd_vision/` was untracked when inspected. Initial SHA-256 values: `commands.py` `bedd6977d40c33582c50c6dfbbec32f386d9690e70e6532b8fdb647003ecdfb1`; `server.py` `1a1ced3384c53e6be43177ca56676c63c2a32243e74fcf65a23b0167b4191980`; `speech_prototype.py` `ab3d90924ac6c22420bf4ce5f57c98c24232ab0805f2d851ffd0707f3838a5a3`; interaction contract `d1a0fa932771a1dfa43a26138fea7707b2c09b96eabe60282e1965c199c08230`. This report and implementation are unsaved to Git; no commit or push was performed.
