# Rev13 prompt A/B selection rule

Run the baseline and candidate prompts on the same frozen `worker-open-rev13.json` fixture, with the same production interpreter, Qwen3.5 Q4 model, llama.cpp runtime, schema, sampling, seed, and request order. The fixture has 16 consequential cases and 32 ordinary cases; 18 ordinary rows are tagged `location-question`, `tracker-status`, or `task-status` prompt-focus cases.

Select the candidate only if all 16 consequential cases match exactly, its exact-match count improves on the 18 location/status prompt-focus rows, its exact-match count also improves across all 32 ordinary cases, and it causes zero regressions among ordinary cases that the baseline got exactly right. Any unmet condition selects the baseline. This is a deterministic gate declared before inference; do not tune or rerun either arm based on these rows.
