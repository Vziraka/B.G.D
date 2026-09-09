# Biometric Guard Drone: project map

Label: wayfinder:map

## Destination

Build the approved self-built, manually flown, payload-ready 7-inch quad and hardened face-and-voice PC desk phase, then the agreed later milestones. [Issue10](issues/10-milestone-ladder.md) is resolved: Q75 accepts the conditional hardware planning baseline. Engineering and empirical acceptance remain distinct unfinished work.

## Start here

| Workstream | Current state | Next action and records |
|---|---|---|
| Hardware | [Issue11](issues/11-hardware-build-package.md) remains claimed and unreleased; owner paused hardware on September 9 for a future change involving 3D printing. | Preserve current engineering. Resolve the future manufacturing/design scope before resuming. Existing [robust-design bounds](../../cad/robust-aio-review.md), [electrical handoff](../../electronics/engineering-handoff.md) and [build holds](../../docs/hardware/baseline-r1/README.md) remain evidence, not approval of a printed redesign. |
| PC biometrics | Tickets01/02 resolved; [Ticket03](../pc-biometric-desk/issues/03-single-action-verification.md) remains unresolved with a real speaker mismatch. Owner requests completion of the PC application and a grilling session on the plan/design. | Settle consequential design changes against the approved PC scope, then complete the remaining tickets and required evidence. The three-sample study is implemented; real study results remain pending. [PC entry point](../../docs/pc-biometric/README.md) has launch/check instructions. |
| Learning | The owner is learning hardware and software through the project. | [Learning entry point](../../docs/learning/README.md) supports explanations and requested lessons. Routine engineering continues without requiring the owner to review code or pass a quiz. |

## Notes

- Tickets hold current checkpoints, decisions and their reasons. Consult relevant evidence and latest comments before consequential work. The [shared workflow](../../docs/agents/workflow.md) explains context recovery and coordination; the main agent owns follow-through.
- Hardware and PC are separate workstreams with their own authorization. Historical “no PC implementation in this task” notes do not prohibit independently authorized PC work.
- The September 9 hardware pause supersedes the earlier direction to continue digital engineering. The TBS inquiry remains withdrawn. The documented bottom-plate conflict remains 2.0–2.5 mm; a 45 mm adapter study has a planar bound only. The [received-frame inspection gate](../../cad/received-frame-inspection-gate.md) and unfinished joint/service engineering still apply to the preserved baseline.
- Hardware has no fixed maximum budget. Minimize fully itemized cost while preserving approved requirements; the former $600/$800/$900 ceilings are historical. Spending remains unauthorized.
- Preserve Q71's 250 g initial cargo target with a separate holder allocation and Q74's fully equipped 20 useful flight minutes plus independent reserve. Model predictions and CAD clearances do not establish flight or fabrication readiness. Full acceptance definitions remain in Issue10 and the [validation register](../../docs/research/issue10-validation-register-2026-08-30.md).
- Preserve the approved PC spec, security/privacy requirements and UI B. Ticket02 evidence and its accepted second-Windows-account limitation are recorded in [its answer](../pc-biometric-desk/issues/02-owner-enrollment-storage.md#answer). Ticket03's real mismatch is unresolved; its diagnostics do not silently update enrollment or weaken thresholds.

## Decisions so far

Current detail and later amendments are in [Issue10](issues/10-milestone-ladder.md). Earlier research decisions remain traceable below; they are not evidence of a qualified complete system.

- [01: Flight stack](issues/01-flight-stack-px4-vs-ardupilot.md): ArduPilot direction; all-path arming enforcement still needs implementation and validation.
- [02: Windows environment](issues/02-windows-dev-environment.md): native Windows desk phase; WSL2/ROS deferred.
- [03: Radio and command link](issues/03-radio-and-command-link.md): ELRS/EdgeTX direction; integration remains to be qualified.
- [04: Onboard compute](issues/04-onboard-compute-path.md): research history; current hardware is governed by Q75 and documented affected-subsystem corrections.
- [05: Face verification](issues/05-face-verification-stack.md), [06: Voice and speech](issues/06-voice-verification-and-stt-stack.md): research origins; current PC implementation/evidence is in its tickets.
- [07: Regulations](issues/07-regulations-checklist.md): country-agnostic checklist; owner applies jurisdiction privately.
- [08: Practice](issues/08-simulator-and-radio-choice.md): RadioMaster Pocket ELRS and FPV Freerider direction; purchases unapproved.
- [09: Original BOM](issues/09-milestone-1-bom.md): historical component/cost baseline.
- [10: Milestones and Q75](issues/10-milestone-ladder.md#answer): conditional planning baseline accepted; Issue11 completes engineering.

## Not yet specified

Remaining M1 engineering and acceptance inputs are tracked in the active tickets. Later M2–M5 designs follow the approved order and capabilities; unresolved details are not permission to drop a feature. Use the [research index](../../docs/research/README.md) for evidence and the [preserved map history](map-history-2026-09-09.md) to recover older context without rereading it on every task.

## Out of scope

This index grants no purchases, fabrication, physical operation, firmware upload, biometric capture or later software implementation beyond the relevant task's authorization. Offline operation remains a product requirement. Engineering can continue through independent work while genuine physical evidence is pending.
