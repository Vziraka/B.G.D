# Pi conversation boundary redesign — 27 September 2026

## Decision

Keep the existing Qwen3.5-4B Q4_K_M profile and production baseline prompt as the comparator. Rev13's independent open check failed 14/18 consequential and 11/20 ordinary requests. Most misses arose in the shared policy, source parser, or model reconciliation; replacing the model would inherit those defects. The model's out-of-view mistakes were blocked from proposals, but the resulting generic clarifications were not the required explicit refusal. The local model stays disabled by default. The consumed Rev13 probe is diagnostic evidence and must not be rerun or used as a tuning set.

## Boundary contract

Keep the UI's exact-proposal review and one-use confirmation, immediate Stop, and the fixed-camera `SIMULATION_ONLY` scope. Interpretation never executes a camera or aircraft action. A single interpretation path should decide, in order:

1. Whether any *affirmative* clause asks for an unavailable capability or an area outside the live camera view. Refuse the whole mixed request; never emit only its supported subset. A clearly negated unavailable clause may be set aside while a separate supported clause is interpreted.
2. Which supported clauses request read-only status, whole-view survey, named-target follow/find/count, or an unknown intent. Treat nominal tracker *state/health* as status, not a verb to follow. Survey has no object target and is valid only for the whole live view. Unknown explicit clauses require clarification rather than a partial plan.
3. What target description each supported clause actually names. Remove view-only framing such as “on this screen” while retaining identifying restrictions such as a person's clothing or an object's relation to another object. A private/deictic target remains unclear even if a location is supplied.
4. Whether a model completion matches the source evidence and polarity. Accept a supported action when its named target is grounded by the request, even when the wording is an inverted natural-language frame; reject added actions, dropped identifying modifiers, named-target surveys, negated actions, remote scope, or an unavailable mixed clause. The policy decision must apply before and after model inference.

Use one coherent clause/evidence representation or shared helpers for these decisions. Avoid a series of literal-phrase special cases that pass a single fixture but disagree across policy, source and reconciliation. A source path should propose only when the entire request is accounted for; the model remains a fallback for novel language. Preserve the existing validated result schema and diagnostic-only authority.

## Acceptance before another model run

- Worker authors new open positive/negative pairs for these classes, with no verbatim reuse of consumed independent requests. Root checks labels, overlap, and a frozen source/test/corpus lock before any model inference. The Rev13 independent corpus is never run again.
- The full relevant vision suite and both UI interaction checks pass. A mix of supported and unavailable clauses yields no partial proposal; positive and negated forms are both covered. A static source-path latency replay is measured against the frozen Rev13 baseline to catch substantial new overhead.
- Root reviews the actual diff and test evidence and writes a *different* independent open probe before model results. All consequential requests must pass, ordinary requests must clear a predeclared high threshold, and enough ordinary requests must use the model fallback to measure natural conversation. A pass would justify a new sealed meaning trial, then a separate Pi camera/tracking/ASR coexistence and cold/warm response test. A code-test pass alone does not authorize Pi or speech.
- If the redesigned boundary still leaves model-origin consequential mistakes, compare a distinct local model on the same frozen boundary and open cases; retain Qwen as the baseline. Fine-tuning is a later option only with a labeled training set and independent qualification. Neither option resets the existing UI, tracking, review gate, tests, or hardware work.
