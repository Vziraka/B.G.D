# Qwen3.5 rev9 open comparison

Status: the one prompt revision improved the open-development result, but missed its ordinary-case gate. This is evidence for root review, not model qualification.

Both prompt profiles used the same rev9 production source, schema, Qwen3.5-4B Q4_K_M artifact, llama.cpp b11095 runtime, loopback settings, sampling, seed, timeout, and 49-case open fixture. The baseline profile temporarily supplied the unchanged rev8 prompt. The candidate profile supplied the compact action-mapping addition in `candidate/system-prompt.txt`. Each open run used 31 actual model fallbacks; the other 18 cases used the shared policy prepass or source-grounded path.

| Run | Exact | Critical | Ordinary | Policy / source / model | Cold / median / p95 model latency |
|---|---:|---:|---:|---:|---:|
| Rev9 baseline prompt | 43/49 | 19/19 | 24/30 | 11 / 7 / 31 | 23.954 / 4.220 / 8.743 s |
| Rev9 candidate prompt | 47/49 | 19/19 | 28/30 | 11 / 7 / 31 | 23.918 / 4.140 / 9.875 s |

The ordinary gate requires at least 29/30. Candidate scored 28/30 (93.3%), so it fails by one case. It improved four baseline misses without introducing any consequential miss: f01 and f04 now map a named subject to follow, c04 now counts the named pail category, and d06 now maps a named location request to find instead of scout. The two remaining candidate misses are ordinary false clarifications:

- d03, “What place contains the red umbrella” asks for the visible location of a named object. The model asks the user to specify a visible area.
- d05, “Which spot holds the purple thermos” asks where a named object is. The model asks whether “spot” means a location or an object.

The baseline had those same d03 and d05 false clarifications. Its other four misses were f01, where it emitted both scout and follow and gave scout a forbidden target; f04, where it emitted scout with a nonempty target; d06, where it emitted targetless scout for a named location; and c04, where it asked for more location detail instead of counting the named category. f01/f04 were rejected by strict validation and failed closed. All 19 consequential cases passed under both prompts, including negation, unsupported mixed clauses, remote scope, deictic ambiguity, and the negative-flight/positive-count case.

The updated candidate also passed the frozen original 30-case set exactly (17/17 critical, 13/13 ordinary) and development-v2 exactly (30/30 critical, 28/28 ordinary). Those runs had one and three model fallbacks, respectively. The new open fixture had 31 model fallbacks, exceeding the requested minimum of 20.

For the candidate profile, original30 used 16 policy-prepass cases, 13 source-fast-path cases, and one model fallback; its only inference took 24.070 seconds. Development-v2 used 25 policy-prepass cases, 30 source-fast-path cases, and three model fallbacks; cold/median/p95 inference latency was 23.778/5.054/23.778 seconds.

The prompt grew from 2,487 to 2,813 UTF-8 bytes. First model inference was about 23.9 seconds on each candidate-profile run, above the production interpreter’s 8-second timeout; evaluation used 30 seconds. Median and p95 values are reported from actual model-fallback requests only. This remains a startup/latency risk for any later user-facing trial.

Focused tests passed (66 tests). The full vision suite passed (211 tests, 5 skipped); both Node suites passed. The loopback server used 127.0.0.1:8081 and was stopped after every run; every stop record reports no remaining listener. No Pi, camera, physical, flight, or spoken trial was run. The consumed sealed fixture and the independent root probe were not opened or run.

All raw case rows preserve the API response, unparsed completion, validated result or error, route, and latency in the corresponding `*-raw.jsonl` files. In particular, the invalid baseline completions for f01 and f04 remain available there.
