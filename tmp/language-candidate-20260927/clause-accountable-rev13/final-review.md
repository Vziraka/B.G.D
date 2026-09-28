# Rev13 A/B and selected-profile review

Preselection lock: `tmp/language-candidate-20260927/clause-accountable-rev13/run-lock-preselection.json` (SHA-256 `42de3e66629ca34c5e40661be0fbc94dd4887bdedb98743eeb36e0cd49aa43f4`).
The baseline prompt was already the production prompt. The candidate did not meet the predeclared zero-regression rule, so baseline remains selected and no production prompt edit was made.

## A/B decision

Baseline: 38/48 exact; critical 16/16; ordinary 22/32; location/status focus 10/18. Cold first model latency 25106.2 ms; warm median 4267.25 ms; p95 5149.2 ms.
Candidate: 39/48 exact; critical 16/16; ordinary 23/32; location/status focus 11/18. Cold first model latency 25403.5 ms; warm median 4278.35 ms; p95 4671.2 ms.
Candidate improved the focus subset and total ordinary score and passed all critical controls, but regressed baseline-correct ordinary cases ord-11, ord-12, ord-13, ord-14, ord-15. It therefore fails the frozen selection rule; baseline is selected.

### Baseline misses

- `ord-01` (model_fallback): expected ['planned'] [{'action': 'find_object', 'target': 'cobalt watering can'}]; got {'status': 'clarification_required', 'message': 'Do you mean a specific region or the entire current view?', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"clarification_required","message":"Do you mean a specific region or the entire current view?","steps":[]}`.
- `ord-02` (model_fallback): expected ['planned'] [{'action': 'find_object', 'target': 'brass lantern'}]; got {'status': 'clarification_required', 'message': 'Do you need the location or bounding box coordinates of the brass lantern?', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"clarification_required","message":"Do you need the location or bounding box coordinates of the brass lantern?","steps":[]}`.
- `ord-05` (model_fallback): expected ['planned'] [{'action': 'find_object', 'target': 'tiny green bowl'}]; got {'status': 'clarification_required', 'message': 'Please specify the name of the region or provide a visual description to identify it.', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"clarification_required","message":"Please specify the name of the region or provide a visual description to identify it.","steps":[]}`.
- `ord-06` (model_fallback): expected ['planned'] [{'action': 'find_object', 'target': 'silver candle'}]; got {'status': 'planned', 'message': '', 'steps': [{'action': 'find_object', 'target': 'silver candle in corner'}], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"planned","message":"","steps":[{"action":"find_object","target":"silver candle in corner"}]}`.
- `ord-08` (model_fallback): expected ['planned'] [{'action': 'find_object', 'target': 'violet basket'}]; got {'status': 'clarification_required', 'message': 'Do you need me to find the violet basket or just identify its location?', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"clarification_required","message":"Do you need me to find the violet basket or just identify its location?","steps":[]}`.
- `ord-10` (model_fallback): expected ['planned'] [{'action': 'find_object', 'target': 'wooden coaster'}]; got {'status': 'clarification_required', 'message': 'Please name the visible target to find or follow.', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"planned","message":"","steps":[{"action":"scout","target":""}]}`.
- `ord-16` (model_fallback): expected ['planned'] [{'action': 'status'}]; got {'status': 'clarification_required', 'message': 'What specific visual request are you asking about?', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"clarification_required","message":"What specific visual request are you asking about?","steps":[]}`.
- `ord-18` (model_fallback): expected ['planned'] [{'action': 'status'}]; got {'status': 'unsupported', 'message': 'Camera status requests are not supported for past interactions or mission history.', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"unsupported","message":"Camera status requests are not supported for past interactions or mission history.","steps":[]}`.
- `ord-25` (model_fallback): expected ['planned'] [{'action': 'scout'}]; got {'status': 'clarification_required', 'message': 'Please name the visible target to find or follow.', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"planned","message":"","steps":[{"action":"scout","target":""}]}`.
- `ord-26` (model_fallback): expected ['planned'] [{'action': 'scout'}]; got {'status': 'unsupported', 'message': 'Summarization of visual input is not supported by this camera system.', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"unsupported","message":"Summarization of visual input is not supported by this camera system.","steps":[]}`.

### Candidate misses

- `ord-08` (model_fallback): expected ['planned'] [{'action': 'find_object', 'target': 'violet basket'}]; got {'status': 'clarification_required', 'message': 'Please specify which visible person or object you are referring to.', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"clarification_required","message":"Please specify which visible person or object you are referring to.","steps":[]}`.
- `ord-11` (model_fallback): expected ['planned'] [{'action': 'status'}]; got {'status': 'clarification_required', 'message': 'What would you like me to do?', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"planned","message":"","steps":[]}`.
- `ord-12` (model_fallback): expected ['planned'] [{'action': 'status'}]; got {'status': 'clarification_required', 'message': 'What would you like me to do?', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"planned","message":"","steps":[]}`.
- `ord-13` (model_fallback): expected ['planned'] [{'action': 'status'}]; got {'status': 'clarification_required', 'message': 'What would you like me to do?', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"planned","message":"","steps":[]}`.
- `ord-14` (model_fallback): expected ['planned'] [{'action': 'status'}]; got {'status': 'clarification_required', 'message': 'What would you like me to do?', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"planned","message":"","steps":[]}`.
- `ord-15` (model_fallback): expected ['planned'] [{'action': 'status'}]; got {'status': 'clarification_required', 'message': 'What would you like me to do?', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"planned","message":"","steps":[]}`.
- `ord-16` (model_fallback): expected ['planned'] [{'action': 'status'}]; got {'status': 'clarification_required', 'message': 'What would you like me to do?', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"planned","message":"","steps":[]}`.
- `ord-25` (model_fallback): expected ['planned'] [{'action': 'scout'}]; got {'status': 'clarification_required', 'message': 'Please name the visible target to find or follow.', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"planned","message":"","steps":[{"action":"scout","target":""}]}`.
- `ord-26` (model_fallback): expected ['planned'] [{'action': 'scout'}]; got {'status': 'clarification_required', 'message': 'Please name the visible target to find or follow.', 'steps': [], 'executable': False, 'authority': 'DIAGNOSTIC_ONLY'}; raw completion `{"status":"planned","message":"","steps":[{"action":"scout","target":""}]}`.

## Selected baseline on prior open suites

Old30: 30/30 exact, critical 17/17, ordinary 13/13; misses: none. One actual model fallback (p05) took 23788.0 ms including cold startup.
Development-v2: 58/58 exact, critical 30/30, ordinary 28/28; misses: none. Three model calls; first-in-corpus latency 3710.3 ms, median 3710.3 ms, p95 5092.5 ms. This run followed old30 in the same process, so those are warm latencies.
Other prior corpora were not inferred because verify-only route analysis showed 11–23 model fallback requests each; their exact source routes are available through verify-only results only.

## Cleanup and scope

Both server processes were stopped. Final stop record: `{'pid': 23628, 'process_stopped': True, 'loopback_listener_remaining': False, 'remaining_listener_addresses': []}`. Port 8084 had no listener after shutdown. No sealed fixture or independent Rev13 probe was used.

Completion manifest: `completion-manifest.json` (SHA-256 `a1a35c821dbf2d1bd1cb33dcf6b9a7b19712eb32c7b17ea52ba4c7cf3038c3fb`).
