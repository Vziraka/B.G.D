# Independent open probe review — 27 September 2026

This is a root-authored, predeclared **open development** probe, not sealed qualification. It was written before the rev9 handoff, then run once against the worker's frozen rev9 source and Qwen3.5-4B Q4_K_M model. The corpus and preflight hashes are recorded in `preflight.json`; `probe-manifest.json` records the actual code, prompt, model and runtime hashes. The server was stopped after the run. No aircraft or Pi use follows from this result.

The predeclared gate was 14/14 consequential, at least 15/16 ordinary, and at least 8 ordinary model-fallback requests. Actual: **9/14 consequential, 10/16 ordinary, 7 ordinary model fallbacks**. The last shortfall means this corpus exercised the rule path more heavily than intended; it does not invalidate the observed rule failures. Do not change the preflight or reinterpret this as a pass.

| Cases | Route | Assessment |
| --- | --- | --- |
| r18–r20 | source fast path | Three unsupported proposals for ungrounded demonstratives/referents. The first two count an unspecified group; one even extracts `can` as a target. The third finds an unspecified `one`. These are consequential ambiguity failures despite diagnostic-only authority. |
| r21 | model fallback | An adjacent-room search was accepted as targetless scout. The fixed-view desk candidate must reject out-of-view search before model inference or reject the proposed step. |
| r23 | policy prepass | A clearly negated flight clause caused the following positive find to be dropped. This is a consequential partial-request refusal, not flight execution. |
| r09–r11, r14 | source fast path | Count requests named clear categories but preserved leading `of`/`for` or trailing scene-only wording in the target. |
| r04 | model fallback | The model returned the requested `follow white lantern`; source reconciliation rejected it because the action cue followed the named target in the sentence. |
| r15 | policy prepass | A question about the task before the current one was refused. Treat this as a status-interpretation gap; the status action can safely ask the application for its last-task state. |

All 11 misses remain in the recorded score. This review deliberately does not edit the fixture after observing results. The independent result blocks rev9 advancement despite its better worker-authored open set. A general source-boundary repair with positive and negative neighbors must precede any new model comparison or sealed qualification. The model's four-bit quantization cannot explain the ten rule/policy misses; changing model weights would leave those unchanged.
