# M1 flight acceptance proposal after Q59

> **Q62 decision update — 2026-08-30:** The user approves three consecutive successful complete takeoff/hover/movement/landing exercises across at least two practice sessions, alongside separate build, commissioning and safety checks. Historical references below to that count being unapproved are superseded; the remaining detailed protocol is not thereby approved. This is a repeatability requirement, not demonstrated readiness, safety certification or permission to fly. See [ticket 10](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

Date checked: **2026-08-30**. Status: **unapproved acceptance proposal**, not a flight procedure, readiness finding or permission to fly. Authored directly in the main checkout on `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`; new uncommitted research, not contained in that commit. No software installation, configuration, purchase, powered test or flight occurred.

## Decision baseline

Q42 requires simulator-first, repeatable radio-controlled takeoff, steady hover, controlled movement and landing while watching the aircraft directly; stabilization is allowed. Q43 establishes a solo novice with no approved experienced-helper prerequisite. Q44 keeps an aircraft with an unresolved safety problem grounded while independent work continues. Q59's latest user reply approves the proposed M1–M5 order; it does not validate hardware or acceptance protocols. [Ticket 10](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments)

M1's separate hardened PC biometric acceptance remains necessary. This flight proposal does not bring onboard biometrics, phone control, autonomous tasks, delivery or the later full-equipment twenty-useful-minute endurance demonstration into basic manual-flight acceptance. Complete-build affordability still includes later features under the $600 goal and conditional $800 maximum.

## What official evidence supports

- ArduPilot separates physical installation and initial configuration/calibration from first-flight commissioning. Successful simulator practice therefore cannot demonstrate that the real aircraft was assembled correctly; that distinction is our inference. [First Time Setup](https://ardupilot.org/copter/docs/initial-setup.html)
- Initial commissioning can reveal unstable control and unexpected power. ArduPilot recommends prior simulator or training-aircraft practice and evaluates basic controllability before later tuning. It does not supply a universal repetition count certifying novice competence. [Initial Tuning Flight](https://ardupilot.org/copter/docs/initial-tuning-flight.html)
- Pre-arm checks detect several configuration, calibration and sensor problems, and the documentation warns against bypassing failed checks for flight. Their success is one input, not a comprehensive physical or operational safety assessment. [Pre-Arm Safety Checks](https://ardupilot.org/copter/docs/common-prearm-safety-checks.html)
- Motor-order/direction verification has explicit propeller-removal precautions. The summary preflight page uses loose wording about spinning propellers: do not copy that page into an executable powered-test checklist without reconciling it with the detailed safety guidance and actual hardware. [Connect ESCs and Motors](https://ardupilot.org/copter/docs/connect-escs-and-motors.html), [Pre-Flight Checklist](https://ardupilot.org/copter/docs/checklist.html)
- Radio failsafe behavior depends on configuration, and official documentation describes ground verification. This does not justify deliberately provoking an airborne failure. [Radio Failsafe](https://ardupilot.org/copter/docs/radio-failsafe.html)
- Onboard DataFlash logs and ground-station telemetry logs provide different evidence; an onboard log need not depend on an uninterrupted telemetry connection. Such logs can support post-flight review, but they do not themselves prove visual contact or safe separation. [Downloading and Analyzing Data Logs](https://ardupilot.org/copter/docs/common-downloading-and-analyzing-data-logs-in-mission-planner.html)

## Proposed acceptance structure

The following is engineering synthesis, not an ArduPilot certification scheme. Actual equipment, firmware, pilot ability and the privately assessed operating site must determine the eventual detailed protocol.

| Gate | Evidence to retain | What blocks progression |
| --- | --- | --- |
| Simulator preparation | Real-radio setup identified; repeated successful basic maneuvers and demonstrated understanding of selected control modes and recovery choices | Unresolved control confusion or inability to perform basic maneuvers consistently |
| Completed-build review | Actual component/configuration inventory and documented inspection; applicable assembly, calibration, propulsion-order, radio and battery checks | Unexplained behavior, incomplete or failed safety checks, incompatible installation |
| Flight commissioning | A separately validated commissioning plan; configuration-specific failsafe and warning verification; post-commissioning observations/log review establishing suitability for basic practice | Instability, unexpected control response, unresolved warnings or damage |
| Basic-flight repeatability | Consecutive recorded qualifying runs after commissioning, using a fixed acceptance definition | Missed skill criteria; safety events; missing evidence |
| Closure | Safety faults investigated and cleared, affected checks repeated, all required records and separate PC acceptance assessed | Any unresolved safety fault or required criterion still unverified |

Experienced physical review remains a risk-reduction recommendation, not a newly imposed prerequisite. Nothing here establishes solo readiness. AI cannot physically inspect the build, monitor the site or supervise a flight. If readiness cannot be established, the aircraft stays grounded; the simulator and PC work can continue.

## Proposed repeatability measurement

**Candidate for later approval: three consecutive qualifying complete runs spread across at least two separately prepared practice sessions.** This modest sample distinguishes one lucky run from repeated performance and includes another setup/preflight opportunity. The count and session requirement are proposed project bookkeeping choices, not published safety thresholds or statistical reliability claims. They must remain suitable for the actual vehicle and validated training plan; do not prolong flying, fly fatigued or finish a quota against conditions.

A qualifying run must demonstrate all four approved skills:

1. Controlled takeoff into the predeclared practice area without an unintended excursion or unexplained response.
2. Hover within a predeclared position/height region for a predeclared observation period while maintaining orientation and visual contact.
3. Deliberate movement and stopping within the predeclared area, showing purposeful control rather than drifting through it.
4. Controlled landing in the predeclared landing area, followed by the approved safe end-of-flight state, without collision, tip-over or damage.

Select numerical hover duration, tolerances, area, weather envelope, flight mode and reserve criteria **before acceptance attempts**, after the actual aircraft and operating constraints are known. These quantities are engineering work; no arbitrary distance, battery cutoff or flight height is adopted here. Do not widen criteria retrospectively to convert a failed run into a pass. Later configuration changes require reviewing which prior evidence remains applicable.

Record every attempt as **pass**, **skill criterion missed**, **safety stop**, or **not assessable**. An interrupted run is not a pass. A prudent early stop for changed conditions is not necessarily a skill failure, but its reason remains recorded. A skill miss breaks the proposed consecutive-pass sequence; a safety problem invokes Q44 and blocks further flight until investigated and cleared, with the needed rechecks. Do not deliberately induce link loss, low-energy emergencies or motor shutdown in flight to satisfy this checklist.

## Minimal record

For each session retain date/session ID, aircraft/configuration revision, simulator or aircraft designation, applicable preflight/commissioning evidence, conditions, selected mode and preset acceptance criteria. For each run retain outcome per maneuver, warnings/unexpected behavior, any abort reason, post-flight condition and relevant log reference. Note measurement uncertainty; apparent precision unsupported by the chosen observations is not evidence. The pilot must not divide flight attention to complete paperwork; observations are recorded afterward, with logging used where available.

Locations may be represented by private IDs. Before operational use, the user privately verifies applicable aviation/airspace, site-access, radio, privacy and other local requirements using current authoritative sources. This country-agnostic report establishes no legal permission and asks for no personal or location details. Any required fees/equipment must stay visible in the project cost assessment.

## Remaining human choices versus engineering work

- **Possible compact human decision:** whether the proposed three-run/two-session demonstration is an acceptable project completion standard, once its practical protocol is supportable. Q59 alone does not approve this count. Do not re-ask already settled solo-working, simulator-first or grounding decisions.
- **Engineering work, not preference questions:** finalize the selected-aircraft commissioning protocol; define measurable tolerances; establish suitable readiness evidence for this novice; verify warning/failsafe behavior safely; determine recording and post-flight-review methods; integrate the checklist with the separate PC acceptance and budget feasibility work.
- **Private operational validation:** legal and site suitability before flying. A checklist pass cannot grant permission or establish general safety outside the tested configuration and conditions.

## Local provenance

Read against the main-checkout map, workflow and ticket 10, including Q42–Q44 and Q58–Q59, plus the latest user approval supplied in this task. Prior report consulted: [Milestone-1 flight readiness](milestone-1-flight-readiness.md), SHA-256 `A8244D1E154B9C29859E90BFFFC5DF212E6089A7F5903E2E5083CA88A7015673` when read. Its historic helper proposal and old budget wording do not supersede subsequent user decisions. All external sources above were checked on 2026-08-30; recheck version-dependent guidance before implementation or operation. No source worktree or copied unpublished external report was used.
