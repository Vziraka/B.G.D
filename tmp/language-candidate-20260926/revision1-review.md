# Revision1 frozen30 review — Qwen3-4B-Instruct-2507 Q4_K_M

This was one bounded candidate-profile revision on the same PC, model file, llama.cpp b11095 runtime, 2048-token context, two CPU threads, JSON schema, sampling settings, and frozen30 corpus. The temporary script replaced only the system prompt and removed the old `/no_think` suffix plus `chat_template_kwargs.enable_thinking=false`. No further prompt edits or model requests were made.

The run scored **20/30**, with no request timeouts. Cold first inference was 22.998 s; median was 7.204 s and p95 was 10.681 s. The profile correctly rejected all five unsupported requests and all four injection cases, and it handled the three negation-only/mixed cases `n01`–`n03`. It nevertheless regressed the overall score from 23/30 and was substantially slower than the baseline.

The ten strict misses:

- `p01`: “keep track of the bottle” returned clarification instead of the supported follow proposal. The prompt was overly literal about an explicitly supported paraphrase.
- `p02`: “follow me” returned clarification because it claimed the target was missing, despite the prompt's explicit speaker-to-`me` mapping.
- `p05`: a mission-status question returned `unsupported` because no mission data was available, instead of proposing the supported `status` action.
- `p06`: the expected centered-object target `this object` became the generic target `object`, losing the grounding cue.
- `d01`: one relational target (“white bottle beside the book”) was split into separate bottle and book searches, with an extra `scout` step. This changes the target semantics and invents an action.
- `d02`: a supported descriptive person target (“person wearing blue”) returned clarification as if the description lacked an identity or location.
- `c01`: a clear correction from pending bottle to cup returned clarification because cup was described as a new, ungrounded target.
- `c02`: the clear correction from following people to counting them returned clarification, despite the pending target grounding “them” as people.
- `c03`: a clear target correction from pending cup to bottle returned clarification because “that” was treated as ungrounded.
- `n04`: it missed the affirmative “report your status” clause after “I don't want you to land,” returning clarification. It did not invert the negation into a landing action, but it failed to preserve the supported affirmative clause.

The strongest remaining semantic failures are `p06` target-grounding loss and `d01` target-relation loss plus an invented extra action. Several corrections and supported paraphrases are also refused. The profile fixed the baseline's tested unsupported-clause and confirmation-bypass misses, but it does **not** meet the acceptance gate. Per the bounded assignment, stop here; do not tune this prompt again.
