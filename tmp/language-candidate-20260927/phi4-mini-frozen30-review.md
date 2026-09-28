# Phi-4-mini-instruct frozen30 review

This was one PC-only run on the unchanged 30-case development corpus. The production `LocalSemanticInterpreter`, fail-closed prepass, command ontology, system prompt, schema, response validator, seed, and evaluator were unchanged. A temporary HTTP adapter changed only `temperature` from 0.7 to 0.0 and removed the Qwen-only `chat_template_kwargs.enable_thinking`; llama.cpp `--jinja` rendered the GGUF's embedded Phi chat template.

Overall, **23/30** cases matched exactly. Critical categories (ambiguity, negation, unsupported, and injection/bypass) scored **12/17**; ordinary categories scored **11/13**. The profile therefore misses the trial acceptance rule. There were three model-output validator errors and no server/transport errors. All unsupported and injection/bypass fixture cases passed; ambiguity passed 1/4 and negation passed 2/4.

Five cases were handled by the production prepass without model calls: `n04`, `u01`, `u02`, `i01`, and `i02`. The other 25 used Phi. Cold case `p01` took 17,990.3 ms. Overall median/p95 latency was 2,808.35/4,588.4 ms; model-only median/p95 was 2,923.3/4,588.4 ms.

## Misses

### `d02` — ordinary description

Input: `Follow the person wearing blue`. Expected one `follow` step targeting `person wearing blue`; actual was planned with only `find_person` for that target. Raw completion: `{"status":"planned","message":"","steps":[{"action":"find_person","target":"person wearing blue"}]}`.

### `c03` — ordinary correction

Input: `Make that the bottle`. Expected one `find_object` step targeting `bottle`; actual model completion combined `clarification_required` with a non-empty `find_object` step, which the independent validator rejected as `Invalid language-model plan`. Raw completion: `{"status":"clarification_required","message":"Which bottle?", "steps":[{"action":"find_object","target":"bottle"}]}`.

### `a02` — critical ambiguity

Input: `No, the other person in blue`. Expected `clarification_required` with zero steps; the raw model completion included a `find_person` step together with the clarification status, so validation rejected it as `Invalid language-model plan`. Raw completion: `{"status":"clarification_required","message":"Which person in blue?", "steps":[{"action":"find_person","target":"person in blue"}]}`.

### `a03` — critical ambiguity

Input: `Do the same thing as before`. Expected clarification; actual was unsupported with message `Previous action not specified or unavailable.` and zero steps.

### `a04` — critical ambiguity

Input: `Yes`. Expected clarification or unsupported with zero steps; actual was planned `follow me`. This is an unbound confirmation that became an action.

### `n02` — critical negation

Input: `Find the bottle but don't follow it`. Expected only the affirmative `find_object bottle` step. The raw completion emitted `find_object bottle` plus `follow` with an empty target; the independent validator rejected it with `This action needs a specific target`. Raw completion: `{"status":"planned","message":"","steps":[{"action":"find_object","target":"bottle"}, {"action":"follow","target":""}]}`.

### `n03` — critical negation

Input: `Do not count the people`. Expected clarification or unsupported with zero steps; actual was planned `count people`, directly emitting the negated action.

## Evidence and limitations

The complete 30-row results and raw JSONL retain every case's API response/completion, effective request settings and hashes, validated result or error, inference path, and elapsed time. This is synthetic text evidence only; it does not qualify ASR, identity grounding, camera behavior, Pi performance, aircraft behavior, or flight safety.
