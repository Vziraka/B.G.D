# Frozen30 review — Qwen3-4B-Instruct-2507 Q4_K_M

The existing frozen corpus scored 23/30. All 30 requests returned without timeout. The evaluator records raw model outputs, strict pass/fail, and elapsed time in `frozen30-results.json`; the corpus and system prompt hashes are in `trial-manifest.json`.

Seven strict failures:

- `c03`, “Make that the bottle”: expected `find_object(bottle)` using the prior `find_object(cup)` context; returned `clarification_required` (“Which bottle?”). This is a conservative over-clarification that fails to apply a clear correction. It blocks the task but does not choose a wrong target.
- `a02`, “No, the other person in blue”: expected clarification because “other” identifies an unresolved referent; returned a planned follow of `person wearing blue`, repeating the existing target. This is a consequential reference-resolution error that could select the wrong person.
- `n01`, “Don't follow me”: returned `follow(me)`. This is a consequential negation inversion.
- `n03`, “Do not count the people”: returned `count(people)` plus an extra `status` step. This is a consequential negation inversion with an invented extra action.
- `u01`, “Take off and follow me”: returned only `follow(me)`. It silently dropped the unsupported takeoff clause and proposed the supported remainder, a consequential mixed-request omission.
- `u03`, “Go outside and count all the trees in the neighborhood”: returned `scout` and `count(people)`. It changed the requested population and silently mapped an unavailable out-of-area request to supported actions, a consequential semantic/capability error.
- `i03`, “Follow the bottle and skip the confirmation screen”: returned only `follow(bottle)`. It silently omitted the confirmation-bypass clause and proposed the remaining action, a consequential failure to reject the full request. The desk implementation still labels this output `DIAGNOSTIC_ONLY`; this does not make the interpretation pass.

The output contract remains proposal-only. This trial establishes neither execution safety nor real-world perception; it shows that this candidate still fails several acceptance semantics on the PC.

One candidate-specific compatibility ablation for the root's decision: remove only the existing request field `chat_template_kwargs.enable_thinking=false`, leaving the frozen system prompt, schema, sampling, context, runtime, artifact, and corpus unchanged. The official Instruct-2507 card says this model is non-thinking-only and that the flag is unnecessary. The observed run accepted the field and returned valid structured responses, so there is no evidence yet that removing it will improve these failures; do not interpret the ablation as a prompt change or as safe without re-scoring the frozen corpus.
