# Biometric Guard Drone: project map

Label: wayfinder:map

## Destination

Build the approved self-built 7-inch quad with a phone/controller interface and onboard owner face/liveness verification. The standalone PC app is removed from the finished product by the [September 9 direction](issues/10-milestone-ladder.md#2026-09-09-phone-and-onboard-direction-pc-product-retired) and has no active development, validation, packaging or evidence-refresh work. The v1 phone/onboard design is approved but its simulator is not implemented; Q75 is historical planning closure, not qualification of this revision.

## Start here

| Workstream | Current state | Next action and records |
|---|---|---|
| Hardware | [Issue11](issues/11-hardware-build-package.md) claimed and unreleased. Repository authority alignment is complete; printed design scope remains open. | Resume source-backed mass, propulsion, endurance and integration assessment. Preserve [existing engineering](../../docs/hardware/baseline-r1/README.md); revise manufacturing-dependent work once its scope is settled. |
| Phone/onboard interaction | Standalone PC product retired. [Issue12](issues/12-phone-onboard-interaction.md) is claimed; the [v1 interface](../../docs/phone-drone/interaction-contract.md) settles the first-slice decisions. | Implement the actuator-free simulated slice and assess the iPhone route. Hardware feasibility continues in parallel. No phone implementation or flight qualification is claimed. |
| Learning | The owner is learning hardware and software through the project. | [Learning entry point](../../docs/learning/README.md) supports explanations and requested lessons. Routine engineering continues without requiring the owner to review code or pass a quiz. |

## Notes

- Tickets hold current checkpoints, decisions and their reasons. Consult relevant evidence and latest comments before consequential work. The [shared workflow](../../docs/agents/workflow.md) explains context recovery and coordination; the main agent owns follow-through.
- The [latest product decision](issues/10-milestone-ladder.md#2026-09-09-phone-and-onboard-direction-pc-product-retired) supersedes Windows-product completion and both-biometrics-before-arming policy. The [v1 interaction contract](../../docs/phone-drone/interaction-contract.md) now controls launch, verification and command-session semantics.
- The later September 9 instruction puts repository alignment before the agreed feasibility assessment. Detailed printed redesign remains unselected. The old frame thickness/assembly conflict and [inspection gate](../../cad/received-frame-inspection-gate.md) remain evidence for that baseline; the TBS inquiry stays withdrawn.
- Hardware has no fixed maximum budget. Minimize fully itemized cost while preserving approved requirements; the former $600/$800/$900 ceilings are historical. Spending remains unauthorized.
- Preserve Q71's 250 g initial cargo target with a separate holder allocation and Q74's fully equipped 20 useful flight minutes plus independent reserve. Model predictions and CAD clearances do not establish flight or fabrication readiness. Full acceptance definitions remain in Issue10 and the [validation register](../../docs/research/issue10-validation-register-2026-08-30.md).
- The former [PC spec](../pc-biometric-desk/spec.md), source, tests and results are dormant historical material, not reference tooling to finish. They supply no current task, dependency or acceptance evidence. The Windows machine remains the host for new simulation and engineering work; existing biometric data remains protected unless the owner separately directs its removal.

## Decisions so far

Current detail and later amendments are in [Issue10](issues/10-milestone-ladder.md). Earlier research decisions remain traceable below; they are not evidence of a qualified complete system.

- [01: Flight stack](issues/01-flight-stack-px4-vs-ardupilot.md): ArduPilot direction; the revised launch/verification/command contract still needs implementation and validation.
- [02: Windows environment](issues/02-windows-dev-environment.md): native Windows desk phase; WSL2/ROS deferred.
- [03: Radio and command link](issues/03-radio-and-command-link.md): ELRS/EdgeTX direction; integration remains to be qualified.
- [04: Onboard compute](issues/04-onboard-compute-path.md): research history; current hardware is governed by Q75 and documented affected-subsystem corrections.
- [05: Face verification](issues/05-face-verification-stack.md), [06: Voice and speech](issues/06-voice-verification-and-stt-stack.md): research origins only; current product behavior is controlled by Issue12 and the phone/onboard contract.
- [07: Regulations](issues/07-regulations-checklist.md): country-agnostic checklist; owner applies jurisdiction privately.
- [08: Practice](issues/08-simulator-and-radio-choice.md): RadioMaster Pocket ELRS and FPV Freerider direction; purchases unapproved.
- [09: Original BOM](issues/09-milestone-1-bom.md): historical component/cost baseline.
- [10: Milestones and Q75](issues/10-milestone-ladder.md#answer): conditional planning baseline accepted; Issue11 completes engineering.

## Not yet specified

Remaining M1 engineering and acceptance inputs are tracked in the active tickets. Later M2–M5 designs follow the approved order and capabilities; unresolved details are not permission to drop a feature. Use the [research index](../../docs/research/README.md) for evidence and the [preserved map history](map-history-2026-09-09.md) to recover older context without rereading it on every task.

## Out of scope

This index grants no purchases, fabrication, physical operation, firmware upload, biometric capture or later software implementation beyond the relevant task's authorization. Offline operation remains a product requirement. Engineering can continue through independent work while genuine physical evidence is pending.
