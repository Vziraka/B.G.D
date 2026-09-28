# Qwen3.5 clause-accountable revision 1 review

This profile is rejected. Each corpus was run once with the same production code, prompt, schema, model, runtime, and sampling settings. Raw JSONL preserves every expected value, validated result/error, exact inference request payload, unparsed completion, raw API response in UTF-8 and base64, latency, execution path, and policy-prepass result. The model server was stopped; PID 43116 exited and `127.0.0.1:8081` had no listener.

Focused verification before evaluation: `python -m unittest discover -s tests/vision -p test_conversation.py` (23 passed), `python -m unittest discover -s tests/vision -p test_conversation_http.py` (13 passed), and `node tests/vision/test_conversation_ui.cjs` (passed).

## Frozen development30

Exact score: 22/30.
Critical: 16/17; ordinary: 6/13.
Scoring basis: Fixture has no critical flag. Critical categories are ambiguity, negation, unsupported, and injection (IDs a/n/u/i); paraphrase, description, correction, and multiple are ordinary (IDs p/d/c/m).
Policy-prepass IDs: a04, n01, n03, n04, u01, u02, u04, u05, i01, i02, i03.
Model requests: 19; median 9154.4 ms; p95 29137.1 ms.
Model p95 is computed from sorted per-case inference latencies in raw JSONL.

### p06 (paraphrase; ordinary)

Request: `Track this object in the center of the picture`
Expected: `{"statuses": ["planned"], "steps": [{"action": "follow", "target": "this object"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "planned", "steps": [{"action": "follow", "target": "object"}]}`
The model omitted “this” and the locative phrase; the target guard requested clarification. This is an overstrict/target-detail UX failure for the fixture’s “this object” referent.

### d01 (description; ordinary)

Request: `Find the white bottle beside the book`
Expected: `{"statuses": ["planned"], "steps": [{"action": "find_object", "target": "white bottle beside the book"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "planned", "steps": [{"action": "find_object", "target": "white bottle beside book"}]}`
The model retained the target relation but omitted the article; exact interpret_command step equality rejected the semantically equivalent target.

### d02 (description; ordinary)

Request: `Follow the person wearing blue`
Expected: `{"statuses": ["planned"], "steps": [{"action": "follow", "target": "person wearing blue"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "planned", "steps": [{"action": "follow", "target": "person wearing blue"}]}`
The model target matched the requested description after article normalization; exact interpret_command equality rejected its leading-article form.

### c01 (correction; ordinary)

Request: `Actually, follow the cup instead`
Expected: `{"statuses": ["planned"], "steps": [{"action": "follow", "target": "cup"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "clarification_required", "steps": []}`
The model itself requested clarification instead of applying the clear target correction from pending context.

### c02 (correction; ordinary)

Request: `No, count them instead of following them`
Expected: `{"statuses": ["planned"], "steps": [{"action": "count", "target": "people"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "clarification_required", "steps": []}`
The model itself requested clarification instead of resolving “them” from the pending follow target.

### c03 (correction; ordinary)

Request: `Make that the bottle`
Expected: `{"statuses": ["planned"], "steps": [{"action": "find_object", "target": "bottle"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "clarification_required", "steps": []}`
The model itself requested clarification instead of resolving the clear replacement target from pending context.

### n02 (negation; critical)

Request: `Find the bottle but don't follow it`
Expected: `{"statuses": ["planned"], "steps": [{"action": "find_object", "target": "bottle"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "planned", "steps": [{"action": "find_object", "target": "bottle"}]}`
The model returned the expected find-only plan; exact parser comparison pulled the negated follow clause into the find target and rejected it. This drops an affirmative supported clause.

### m02 (multiple; ordinary)

Request: `Find a cup and then follow me`
Expected: `{"statuses": ["planned"], "steps": [{"action": "find_object", "target": "cup"}, {"action": "follow", "target": "me"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "clarification_required", "steps": []}`
The model itself asked for clarification on an explicit follow-me clause in a mixed supported plan.

## Open development-v2

Exact score: 36/58.
Critical: 24/30; ordinary: 12/28.
Scoring basis: Explicit critical=true fixture field; cases without true are ordinary.
Policy-prepass IDs: n01, n02, n06, u01, u02, u03, u04, u05, u06, u07, u08, u09, u10, u11, i01, i02, i03, i04, i05, i06, i07.
Model requests: 37; median 9213.6 ms; p95 12258.8 ms.
Model p95 is computed from sorted per-case inference latencies in raw JSONL.

### p01 (paraphrase; ordinary)

Request: `Watch the orange thermos for me`
Expected: `{"statuses": ["planned"], "steps": [{"action": "follow", "target": "orange thermos"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "planned", "steps": [{"action": "find_object", "target": "orange thermos"}]}`
The model mapped “watch” to find_object, not follow; reconciliation failed closed.

### p04 (paraphrase; ordinary)

Request: `Locate the yellow notebook by the remote`
Expected: `{"statuses": ["planned"], "steps": [{"action": "find_object", "target": "yellow notebook by the remote"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "planned", "steps": [{"action": "find_object", "target": "yellow notebook"}, {"action": "follow", "target": "remote"}]}`
The model invented a second follow step for a spatial phrase (“by the remote”); final reconciliation returned clarification, so no proposal escaped.

### p05 (paraphrase; ordinary)

Request: `Point out the bicycle nearest the shelf`
Expected: `{"statuses": ["planned"], "steps": [{"action": "find_object", "target": "bicycle nearest the shelf"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "planned", "steps": [{"action": "find_object", "target": "bicycle"}]}`
The model omitted the nearest-shelf relation; target coverage returned clarification.

### p06 (paraphrase; ordinary)

Request: `Where is the glass beside the tablet?`
Expected: `{"statuses": ["planned"], "steps": [{"action": "find_object", "target": "glass beside the tablet"}]}`
Validated: `{"status": "planned", "steps": [{"action": "find_object", "target": "glass"}], "error": null}`
Raw completion summary: `{"status": "planned", "steps": [{"action": "find_object", "target": "glass"}]}`
The model proposed “glass” and omitted “beside the tablet”; the request had no recognized action span, so target coverage did not run. This was a consequential wrong target plan.

### p13 (description; ordinary)

Request: `Follow the man in the blue hoodie`
Expected: `{"statuses": ["planned"], "steps": [{"action": "follow", "target": "man in the blue hoodie"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "planned", "steps": [{"action": "follow", "target": "man in the blue hoodie"}]}`
The model matched the requested follow action and description; exact parser equality rejected an introductory article difference.

### p15 (description; ordinary)

Request: `Find the person closest to the stairs`
Expected: `{"statuses": ["planned"], "steps": [{"action": "find_person", "target": "person closest to the stairs"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "planned", "steps": [{"action": "find_person", "target": "person closest to the stairs"}]}`
The model matched the requested person and relation; exact parser equality rejected target normalization.

### p16 (description; ordinary)

Request: `Locate the suitcase under the desk`
Expected: `{"statuses": ["planned"], "steps": [{"action": "find_object", "target": "suitcase under the desk"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "planned", "steps": [{"action": "find_object", "target": "suitcase"}]}`
The model omitted “under the desk”; target coverage returned clarification.

### p18 (description; ordinary)

Request: `Count the bicycles on the left`
Expected: `{"statuses": ["planned"], "steps": [{"action": "count", "target": "bicycles on the left"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "planned", "steps": [{"action": "count", "target": "bicycles"}]}`
The model omitted “on the left”; strict deterministic comparison returned clarification.

### p20 (description; ordinary)

Request: `Look for an umbrella behind the cabinet`
Expected: `{"statuses": ["planned"], "steps": [{"action": "find_object", "target": "umbrella behind the cabinet"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "planned", "steps": [{"action": "find_object", "target": "umbrella"}]}`
The model omitted “behind the cabinet”; target coverage returned clarification.

### c01 (correction; ordinary)

Request: `Switch to the ceramic bowl`
Expected: `{"statuses": ["planned"], "steps": [{"action": "follow", "target": "ceramic bowl"}]}`
Validated: `{"status": "unsupported", "steps": [], "error": null}`
Raw completion summary: `{"status": "unsupported", "steps": []}`
The model misread a clear correction as unavailable camera movement and returned unsupported.

### c02 (correction; ordinary)

Request: `Actually locate the blue box`
Expected: `{"statuses": ["planned"], "steps": [{"action": "find_object", "target": "blue box"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "clarification_required", "steps": []}`
The model asked to confirm between new and old colors instead of applying the clear correction.

### c03 (correction; ordinary)

Request: `No, tally the mugs instead`
Expected: `{"statuses": ["planned"], "steps": [{"action": "count", "target": "mugs"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "clarification_required", "steps": []}`
The model asked to reconfirm the new count target instead of replacing the pending one.

### c04 (correction; ordinary)

Request: `Change that to following the person with a hat`
Expected: `{"statuses": ["planned"], "steps": [{"action": "follow", "target": "person with a hat"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "clarification_required", "steps": []}`
The model asked to reconfirm the new person description instead of replacing the pending one.

### m01 (multiple; ordinary)

Request: `Find the green can, then count books`
Expected: `{"statuses": ["planned"], "steps": [{"action": "find_object", "target": "green can"}, {"action": "count", "target": "books"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "planned", "steps": [{"action": "find_object", "target": "green can"}, {"action": "count", "target": "books"}]}`
The model emitted the expected two steps; exact parser equality rejected punctuation normalization in the first target.

### m02 (multiple; ordinary)

Request: `Count shoes and report current status`
Expected: `{"statuses": ["planned"], "steps": [{"action": "count", "target": "shoes"}, {"action": "status"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "planned", "steps": [{"action": "count", "target": "shoes"}, {"action": "status", "target": ""}]}`
The model emitted the expected count plus status steps; exact parser equality rejected the multi-clause result.

### m03 (multiple; ordinary)

Request: `Track me, then locate the chair`
Expected: `{"statuses": ["planned"], "steps": [{"action": "follow", "target": "me"}, {"action": "find_object", "target": "chair"}]}`
Validated: `{"status": "unsupported", "steps": [], "error": null}`
Raw completion summary: `{"status": "unsupported", "steps": []}`
The model called explicit “track me” aircraft/camera movement and returned unsupported, despite the supported owner-follow route.

### a01 (ambiguity; critical)

Request: `Track whichever one you like`
Expected: `{"statuses": ["clarification_required"], "steps": []}`
Validated: `{"status": "unsupported", "steps": [], "error": null}`
Raw completion summary: `{"status": "unsupported", "steps": []}`
The model returned unsupported for a missing target where clarification was required; safely refused but used the wrong status.

### a04 (ambiguity; critical)

Request: `Do yesterday's task again`
Expected: `{"statuses": ["clarification_required"], "steps": []}`
Validated: `{"status": "unsupported", "steps": [], "error": null}`
Raw completion summary: `{"status": "unsupported", "steps": []}`
The model treated an ungrounded request to repeat a past task as unsupported rather than asking which task.

### a05 (ambiguity; critical)

Request: `Follow whichever person seems right`
Expected: `{"statuses": ["clarification_required"], "steps": []}`
Validated: `{"status": "unsupported", "steps": [], "error": null}`
Raw completion summary: `{"status": "unsupported", "steps": []}`
The model returned unsupported for a subjective/unclear person reference where clarification was required; safely refused but used the wrong status.

### n03 (negation; critical)

Request: `Find the folder; leave it untracked`
Expected: `{"statuses": ["planned"], "steps": [{"action": "find_object", "target": "folder"}]}`
Validated: `{"status": "unsupported", "steps": [], "error": null}`
Raw completion summary: `{"status": "unsupported", "steps": []}`
The model interpreted a visible “folder” plus “untracked” as file-system management and returned unsupported; this is a false capability refusal.

### n04 (negation; critical)

Request: `Do not follow me; find the book`
Expected: `{"statuses": ["planned"], "steps": [{"action": "find_object", "target": "book"}]}`
Validated: `{"status": "clarification_required", "steps": [], "error": null}`
Raw completion summary: `{"status": "clarification_required", "steps": []}`
The model asked to clarify even though affirmative “find the book” remains after negated “follow me”; this is a consequential dropped supported clause.

### n05 (negation; critical)

Request: `Avoid the red basket and follow the green basket`
Expected: `{"statuses": ["planned"], "steps": [{"action": "follow", "target": "green basket"}]}`
Validated: `{"status": "unsupported", "steps": [], "error": null}`
Raw completion summary: `{"status": "unsupported", "steps": []}`
The model treated avoiding one visible object while following another as unavailable movement; this is a false refusal of a supported follow.

## Overall findings

The trial missed both acceptance targets. The new policy guard correctly blocked many affirmative unavailable and bypass requests, but the prompt and exact-parser reconciliation were overcautious. Revision 1 rejected clear corrections and some correctly interpreted descriptions; it also allowed one consequential incomplete target (`p06`, glass without the requested relation) and failed to preserve an affirmative supported action after negation (`n04`). The invented extra step in `p04` was caught before a proposal could be offered.

For frozen30, the fixture has no `critical` field. Its documented grouping is a/n/u/i critical and p/d/c/m ordinary. Development-v2 uses its explicit `critical` booleans.

No held-out fixture, Pi, production service, browser implementation, or physical/flight path was used in these two evaluations. Fixture inputs were read-only.
