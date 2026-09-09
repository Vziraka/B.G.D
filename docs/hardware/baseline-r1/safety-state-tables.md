# Baseline R1 — safety and state contract

Date: 2026-09-03. Status: **implementation-design contract; no implementation or qualification claimed**. Q75 freezes the conditional component architecture and closes issue 10 planning. Q74 remains a mandatory twenty-useful-minute acceptance requirement. This document neither authorizes procurement nor releases fabrication, firmware loading, bench operation or flight.

## Authority and scope

Controlling decisions: [issue 10](../../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md), especially Q5/Q8/Q13–Q18/Q26/Q55–Q59/Q65/Q71/Q73–Q75. Evidence and tests: [validation register](../../research/issue10-validation-register-2026-08-30.md), [buildability gate](../../research/final-buildability-gate-2026-09-03.md), [frozen conditional packet](../../research/final-hardware-optimization-2026-09-03.md). [Acceptance traceability](acceptance-traceability.csv) maps this contract to the original gates without claiming they passed.

M1 is manual learning, separately from PC biometrics. M2 adds the all-path owner biometric gate. M3 adds autonomous subject/navigation behaviors, M4 night operation, and M5 guest/cargo behavior. Disabled future functions are milestone activation holds, not deleted capabilities. PC timing, recovery, model selection and operating-system rules do not automatically transfer to the aircraft.

## Enforcement boundaries and present limitations

| ID | Required boundary | Evidence and consequence |
| --- | --- | --- |
| E01 | FC owns final arm permission, flight state and actuator permission; Pi proposes authenticated requests | A Pi-only check cannot stop radio, GCS, script or force-arm paths. The 4.7.1 source audit finds `arm(method,false)` skips auxiliary authorization, startup has zero registered auxiliary authorizers, and auxiliary PASS has no self-expiry. Therefore stock auxiliary authorization is insufficient: a mandatory FC-resident gate initialized DENY with one-use expiry/epoch binding is an implementation hold, not a hardware substitution. |
| E02 | Independent RP1→FC emergency control never traverses the Pi or phone | Loss of biometric/phone/companion services must not require new authentication to control an already airborne aircraft. This is independent control transport, not redundant battery, FC or RF immunity. |
| E03 | Cargo PWM7 requires an FC-owned bounded command lifetime | Pololu safe-start cannot recognize stale authorization while the FC continues a valid active pulse train. A script that writes PWM once and then crashes is insufficient. M5 activation is held until script/process/FC fault behavior is demonstrated. |
| E04 | Two switch channels are observations, not an independent safety controller | The R1 harness corrects safe-state sensing to positive mechanical actuation: NO-to-ground with external 3.3V pull-ups. An open cable/missing holder is unsafe; a short to ground or stuck-active contact can still look safe. A preflight open/close challenge reduces undetected faults but does not prove continuous short detection. Fault coverage and threat-model acceptance must be explicit before M5. |
| E05 | Grounded/disarmed is not automatically proven motor standstill | This baseline has no separately qualified shaft-speed sensor. Land state, disarm acknowledgment and a measured maximum coast-down interval, with direct visual confirmation in the attended first handoff, must be validated before a stopped predicate is asserted. That implementation method does not grant recipient arming rights. |
| E06 | Mechanical lock retains cargo without electrical power | Solenoid retracts the latch; it never carries cargo load. A MOSFET stuck on can retract it without software authorization. No independent electrical interlock is selected. Test the mechanical/security consequence; if it fails V35/V36, redesign only this affected subsystem. |
| E07 | Power rail health is only observable where hardware actually measures it | INA measures whole-pack current/voltage, not each regulated rail or servo current. Per-rail limits are commissioning measurements and conservative scheduling constraints, not invented real-time telemetry. |
| E08 | Signing protects message authenticity, not biometric policy | A trusted sender can still send unsafe or stale application commands. The selected source audit also finds unsigned USB/channel-0 acceptance. Provisioning, epochs, single-use authorization, command permissions and controlled maintenance access remain required. |

The legacy interface audit labels D18 `INCOMPATIBLE` because the safety output contract was absent. This is a missing enforcement artifact, not a demonstrated voltage/protocol mismatch. This contract defines the target behavior; it does **not** turn unimplemented D18 into VERIFIED. The affected behavior remains held for implementation and validation. Its old phrase “off at disarm” means cancel output on the transition to disarmed; it cannot prohibit every later disarmed-state pulse, since approved handoff expressly requires a separately authorized pulse after landing/disarming.

## State representation and deterministic rules

The FC is the single authority for `armed`, `landed`, `flight_epoch`, `arm_epoch`, `mode`, protection state and PWM7 permission. The Pi is authoritative only for its local identity result, switch observations, imaging health and receipt of phone requests. Each message binds aircraft ID, installed configuration ID, boot/session epoch, monotonically increasing sequence, request ID, action, and expiry. Authentication of the message and application identity authorization are separate checks.

All timers use monotonic time within their authority's current boot epoch. Reset, epoch mismatch, timestamp overflow, missing parameter, invalid sample, timeout, replay or contradiction means **UNKNOWN/INVALID**, never healthy. Restart never restores an unconsumed arm/release token or resumes a queued mission. Do not persist reusable biometric approval.

States: `BOOT_INHIBITED`, `GROUND_READY_M1`, `GROUND_LOCKED_M2`, `ARM_REQUEST_PENDING`, `ARMED_GROUND`, `AIRBORNE_MANUAL`, `AIRBORNE_TASK`, `PROTECTIVE_RECOVERY`, `LANDED_DISARMED`, `HANDOFF_LOCKED`, `RELEASING`, `COLLECTION_LOCKED`, `FAULT_GROUND`.

Priority is evaluated every control-policy cycle: (1) actual FC stabilization and already-validated immediate flight protections; (2) independent emergency pilot control consistent with those protections; (3) protected recovery; (4) ordinary authenticated mission; (5) imaging/cargo convenience. Authentication failure is not an airborne motor-stop command. A intentional emergency motor-stop action, if separately commissioned, must not be conflated with takeover or low-battery landing.

### A — arming truth table

Rows are evaluated top-down. `X` means any value. `P` = FC pre-arm checks, qualified configuration, correct operating profile, radio readiness, energy margin and site/session prerequisites all pass. `A` = fresh, unconsumed, owner face **and** voice result bound to this exact arm request/epoch. Existing airborne flight does not continually depend on `A`.

| ID | State/profile | P | A | Event | Required result |
| --- | --- | --- | --- | --- | --- |
| A01 | Boot, reset, unknown profile or ground fault | X | X | Any arm command | Reject; PWM7 off; discard pending requests. Require healthy explicit ground initialization. |
| A02 | M1 manual learning | False | X | Manual arm edge | Reject and report failed prerequisite. Never skip a pre-arm check to pass. |
| A03 | M1 manual learning | True | Not applicable | Deliberate configured manual arm edge | Permit normal FC arm transition only. No biometric claim; phone, autonomous and cargo arm paths remain disabled. |
| A04 | M2+ biometric enabled | X | False/unknown | Radio, GCS, phone, Pi, script, mission or other arm request | Reject. No guest/recipient/old-flight approval substitutes. |
| A05 | M2+ biometric enabled | False | True | Arm request | Reject; terminate request and discard its authorization; a new deliberate request requires new authorization. |
| A06 | M2+ biometric enabled | True | True | Matching explicit arm request | Atomically consume authorization and attempt one FC arm transition. Duplicate/racing callers cannot reuse it; rejection/failure requires a new request. |
| A07 | Any ground state | X | X | Force-arm, debug, parameter-write bypass, motor test or maintenance request | No operational bypass. Props-removed maintenance is a separate locally controlled session, not a flight arming exemption; document every exposed path and block unauthorized access. |
| A08 | Armed ground before takeoff | X | Expired/lost after consumption | Companion/auth service fails | Cancel pending takeoff/task; use validated landed disarm behavior. Do not reuse approval after disarming. |
| A09 | Airborne | X | Expired/lost | Biometric/phone/Pi service fails | Preserve flight stabilization; cancel dependent commands and use F table. No new biometric requirement for emergency control or landing. |
| A10 | Landed and disarmed | X | Previously consumed | Arm switch remains high, link returns or process restarts | Stay disarmed; require a new deliberate edge/request. M2+ requires new owner face+voice. |
| A11 | After delivery release or handoff attempt | X | X | Automatic return/takeoff command | Reject; `COLLECTION_LOCKED`, physically carry aircraft back. Any later separately designed rearm requires Q8/Q26 and is not this first delivery workflow. |
| A12 | M2+ profile | X | X | Gate crash/missing script/config mismatch | Fail closed for every new arm. Never silently fall back to M1. Explicit profile maintenance is not available over an ordinary flight command. |

An arm request is not a takeoff command. `ARMED_GROUND` remains motor-hazardous. A disarm acknowledgment does not by itself permit approach or cargo release.

### F — loss, protection and recovery table

`R` = fresh valid independent radio. `N` = validated navigation for the proposed action. `D` = currently suitable, confirmed, reachable protected destination. `E` = trusted usable-energy estimate. `RECOVERY_POLICY` is the reviewed version-specific FC action/mode table, not an unconditional promise that RTL/Land/hover is safe everywhere.

| ID | Condition | Ground behavior | Airborne behavior and recovery condition |
| --- | --- | --- | --- |
| F01 | Phone disconnect, stopped voice session, app killed or signing expiry | No new phone request accepted; arming conditions unchanged | Invalidate pending phone commands and stale video/status. Independent radio remains. A running M3 activity follows reviewed V23 policy; no automatic command replay on reconnect. |
| F02 | Pi crash, overload, heartbeat expiry or UART loss | M2+ arm/release denied; M1 may operate only its separately qualified manual profile | FC cancels companion-dependent motion; R permits independent takeover. Without R, execute `RECOVERY_POLICY` using only remaining healthy sensors; no waiting for Pi reboot. |
| F03 | RP1 link loss or receiver failure | Inhibit arm; armed-landed FC behavior must be explicitly verified | Execute commissioned RC failsafe; never hold last commands or continue an ordinary mission merely because link is absent. Reconnection requires deliberate pilot mode selection, not automatic mission resume. |
| F04 | Pi and radio both unavailable | Deny arm/release | FC-owned protection only. M2/M3 cannot activate until this path works without the Pi. Phone reconnection is not the safety strategy. |
| F05 | INA missing/stale, impossible current, failed calibration or energy accumulator reset | Deny energy-dependent flight readiness | Declare E unknown; stop ordinary mission and initiate conservative recovery promptly. AIO voltage/propulsion-current readings are diagnostics, not a transparent replacement for all-branch Wh monitoring. Never reset consumed energy to zero in flight. |
| F06 | GNSS/compass/position health invalid | Inhibit modes requiring that estimate | Stop navigation-dependent tasks. With R use commissioned pilot fallback; without R choose the qualified navigation-degraded recovery branch. Do not attempt blind return to stale coordinates. |
| F07 | D500 or TFmini stale, implausible or occluded | Inhibit dependent avoidance/height/landing function | Stop motion relying on failed coverage; choose available validated recovery. One sensor cannot silently inherit another's field or guarantee. |
| F08 | Target lost, ambiguous or changed | Reject subject task | Stop subject pursuit; never silently choose another person/object. Use bounded stop/recovery per V23; recovery timers cannot consume reserve. |
| F09 | Protected reserve boundary reached; user ignores warning | Inhibit another mission | Enter protected recovery automatically; no acknowledgment required; ordinary requests cannot defer it. Landing can finish after the useful-flight timer stops. |
| F10 | Destination update proposed | Keep previous valid protection | Replace D only atomically after confirmation, suitability, reachability and reserve checks. Reject update without spending home-return reserve. |
| F11 | D invalid/unreachable and protection needed | Deny flight plan admission | Do not blindly return or hover indefinitely. Use explicit V23/V25 fallback for the actual remaining sensors/site; automatic new-near-user-site selection remains a separately held expansion. |
| F12 | Critical voltage/temperature/current or fast power anomaly | Ground and isolate using approved bench procedure | Use the qualified immediate protective action; no reliance on delayed software current limiting to repair an undersized power path. Never delay recovery for twenty-minute evidence. |
| F13 | FC reset or total battery loss | Boot inhibited; no restored arm/release token | Stabilization may be lost; the baseline has no redundant FC/power system. Reset recovery is not claimed to save flight. Investigate and ground until corrected; never automatic rearm. |
| F14 | Authorization revoked/expired during ordinary airborne task | Reject subsequent access | Do not shut down motors. Reject new/queued commands; currently executing guest behavior remains the explicit later V32 decision, with safety/manual priority preserved. |
| F15 | Required night illumination/perception invalid | Night arming/task denied | Exit affected night task via validated recovery before relying on unavailable perception. Do not silently claim daytime sensing suffices. |

The exact absent-navigation/no-radio fallback, timing of command continuation after link loss, and guest current-activity revocation are later policy interfaces. They remain **activation holds**, not invented approvals. For M1, the firmware manifest must supply a complete tested manual/RC/battery/navigation loss table before first flight. No generic warning banner satisfies that hold.

### R — protected energy contract

`E_remaining_lower` is a conservative lower bound on energy usable **before the validated control/voltage/thermal endpoint**, not nominal pack Wh. `E_recovery_upper(D)` includes the reachable route, landing and configuration/weather uncertainty. `R_required = max(20 Wh, 1.5 × E_recovery_upper)` is the initial Q74 protection basis; measurement can increase protection, never reduce it to manufacture a pass. The initial modeled recovery is 120 seconds; it is not permission to use a fixed 120-second timer regardless of route/load.

| ID | Predicate | Decision |
| --- | --- | --- |
| R01 | Invalid E, D, recovery model, pack ID, temperature or configuration | No ordinary mission admission; if airborne follow F05/F11/F12. |
| R02 | `E_remaining_lower <= R_required + E_detection_and_transition_upper` | Trigger recovery now. Include the worst-case energy spent detecting/transitioning; threshold equality triggers protection. |
| R03 | D changes | Keep old protection until new D and its reserve commit atomically. No decrement or accumulator reset from destination switching. |
| R04 | Twenty-minute checkpoint reached | Pass only if approved active workload is complete and full independently validated reserve remains; then recover safely. |
| R05 | Recovery occurs before twenty minutes or reserve is insufficient at checkpoint | Record failed Q74 endurance result, even if landing is safe. Do not omit equipment, shorten workload or lower reserve. |
| R06 | New pack, battery aging, different mass/props/lighting/holder, repair or software load | Recalculate impact and repeat affected qualification. Loaded delivery has its own earlier endpoint/reserve and no approved twenty-minute requirement. |

Wh model values and 19.6V reference-curve state from research are **not** raw `BATT_LOW_VOLT`/`BATT_CRT_VOLT` settings. Voltage under load depends on sag and current; calibrated thresholds and their time filters must be frozen before powered commissioning. Stock mAh/voltage failsafes alone do not establish the route-aware Wh contract.

### C — cargo switches and release transaction

Component allocation is unchanged: Pololu #1402 ×2 on Pi GPIO23/GPIO24; FC PWM7→Pololu #2802→5V solenoid. The earlier NC-contact instruction is corrected in the R1 drawing/harness: each COM goes to ground, each NO goes to its GPIO with an external 3.3V pull-up. Only positive safe mechanical actuation closes NO and produces logic low. Logical `C` = aircraft-mounted switch A reached by the lid tongue only with holder fully seated and lid closed; `L` = switch B actuated only by full bolt extension through its strike. The NC terminals are unused/insulated. Missing holder must make C unsafe. This resolves a genuine ambiguous/inverted contact specification using the already selected SPDT parts, without changing approved behavior.

| C | L | Interpretation before release | Permission |
| --- | --- | --- | --- |
| 1 | 1 | Closed/latched observations valid after independent open/close challenge | Necessary but insufficient for release or loaded flight |
| 1 | 0 | Closed but latch not secured, or open circuit | No loaded arm; no release start; inspect |
| 0 | 1 | Contradictory/open holder with indicated engaged latch | Fault; no loaded arm/release |
| 0 | 0 | Open/unlatched, detached, wiring break or unknown | No loaded arm/release; no assertion that cargo is absent |
| Unknown | X | Stale/bouncing/uninitialized observation | No release; no loaded arm |
| X | Unknown | Stale/bouncing/uninitialized observation | No release; no loaded arm |

Normal no-holder flights are a declared no-delivery configuration; two open channels do not automatically select it. A short-to-ground remains indistinguishable from continuity with two-wire wiring. Neither switch proves recipient identity, cargo mass, safe site, motionless rotors or completed retrieval.

Release-start predicate is the conjunction of: M5 enabled/qualified; known delivery/holder ID; authenticated fresh designated-recipient face result bound to this delivery and request; current FC boot/flight epoch; landed true; disarmed true; standstill true; collection inhibit latched against rearming; C=1 and L=1 fresh/stable; no fault; validated rail budget; exclusive actuator lease; fresh explicit release request. Any false/unknown term rejects the start.

| ID | Transaction state/event | PWM7 and next state |
| --- | --- | --- |
| C01 | Boot, unqualified M5, no request, unknown state or reset | OFF; `HANDOFF_LOCKED` or ground fault. Clear tokens. |
| C02 | Valid start predicate | Atomically consume recipient authorization, latch collection/no-rearm state and start one bounded actuation lease; `RELEASING`. |
| C03 | Expected L changes 1→0 during valid actuation | This is successful latch retraction, not a new permission. Stop actuation when mechanical release is established or lease ends; remain collection locked. Do not immediately reject the expected transition merely because L is no longer 1. |
| C04 | Expected door/holder opens after release | OFF; `COLLECTION_LOCKED`. No automatic takeoff, return, rearm or second pulse. |
| C05 | Lease expires, recipient binding revoked, telemetry/switch freshness fails, disarm/land predicate lost or rail fault detected | OFF immediately within the specified deadline; fault/collection locked. Retry needs a new explicit reviewed recovery request; never automatic pulse loops. |
| C06 | Actuation ends without expected latch transition | OFF; latch fault. No “delivered” acknowledgment; remain disarmed. |
| C07 | Pi/script loss while PWM timer continues | FC-owned lease must terminate active output independently of the failed requester. If it does not, M5 fails qualification; Pololu safe-start does not cover this fault. |
| C08 | Whole power loss | Spring/mechanical lock must preserve protection where mechanically possible; if already open, electronics cannot re-lock it. Do not falsely claim cargo is secured after reset. |
| C09 | Power restored with old command or recipient result | OFF; no restored lease; inspect/establish current state and use explicit recovery policy. |
| C10 | Impostor, stale face, replay, wrong delivery or owner editing recipient | No release; owner identity is not a successful recipient check. Emergency/service recovery is separately defined in M5, not an undocumented bypass. |

Implementation signal specification: 50Hz servo PWM, OFF=1000µs, ON=2000µs, only after checking default non-inverted #2802 threshold. Startup and all held functions command OFF; no raw RC passthrough or unrestricted `DO_SET_SERVO` route to PWM7. Its pulse-loss safety is additional protection, not permission enforcement. The final coil pulse/cooldown and transition deadlines require measured solenoid/mechanism thermal and motion evidence before connecting an operational holder.

### L — pan/tilt, lighting and release coexistence

| ID | Condition | Required scheduling/power behavior |
| --- | --- | --- |
| L01 | Ordinary imaging | Pan/tilt stays inside calibrated travel/slew limits; visible lights stay within measured thermal/current envelope. No servo end-stop stall as a normal operating state. |
| L02 | Release pending | Finish needed recipient framing first. Admit release only after reserving worst-case load of stationary servos, lamps, driver and solenoid; do not assume a stationary servo draws zero. |
| L03 | During release lease | No new pan/tilt motion. Retain lighting required for safety/identity under the qualified combined envelope. Do not dim required lighting solely to disguise regulator inadequacy. |
| L04 | Load bound absent or measured worst-case exceeds regulator/wiring/voltage specification | Block affected actuation until corrected. Unknown stall current is a bench gate, not permission to use “2A assumed” as a release limit. |
| L05 | Pi reset while NeoPixels previously on | Treat last latched light state as possible until actual OFF transmission/power reset is verified; serial data loss does not guarantee darkness or shed load. |
| L06 | IR control | Existing IR wiring is powered from DFR1015/AIO12V. No separately selected software switch is assumed. Model continuously powered lamps unless a documented control path is added through affected-design review. |
| L07 | Regulated rail fault or full brownout | Ground state inhibits arm/release; airborne state follows F table. Do not promise automatic per-rail fault diagnosis without measurement hardware. |

Peripheral current contract is measured worst-case combined current below 5A continuous and within each load's tighter voltage/current/temperature limits. A regulator's peak claim is not continuous margin. Nominal 1.1A solenoid plus two 0.5A lamps leaves less than 2.9A for both servos and driver at a 5A ceiling; tolerances must also fit. AIO5V sensors are a separate rail in the controlling packet; earlier audit text grouping them on the peripheral BEC is superseded by the final harness. TFmini-S must see 4.9–5.1V at its connector throughout qualified operation.

## Parameters that must be frozen before the affected function is enabled

These are explicit design/measurement inputs, not silent default choices. A blank value means **capability disabled**. They can be completed by the implementation agent from approved policy and evidence; only genuinely new user-facing tradeoffs need further user decisions.

| Parameter group | Required values/evidence | Activation hold |
| --- | --- | --- |
| M1 flight response | Exact FC firmware hash/parameters; RC timeout and every mode/throttle/landed/AirMode branch; battery thresholds/filter; navigation fallback and motor-stop distinction | No first powered propulsion/flight stage until its relevant matrix is reviewed/tested |
| M2 authorization | Arm-request lifetime; face/voice binding/liveness; trust keys/provisioning; permitted sender/transport; command whitelist; consumed-token atomicity; rejected-request behavior; configuration tamper/rollback bounds | No biometric-enabled arm |
| M2/M3 freshness | FC/companion/phone/sensor heartbeat/sample deadlines; clock basis; worst-case detection/transition time; no-radio/no-navigation fallback, command recovery and site validity | No dependent command/autonomy |
| M3 reserve | Pack/configuration IDs; usable-energy lower bound; recovery upper bound; sampling uncertainty; transition energy; low/critical thresholds and recovery modes | No Q74 claim or autonomous recovery reliance |
| M5 release | Recipient policy/TTL; debounce; switch sample TTL; landed stable interval; disarm+coast-down proof; release pulse limit/cooldown; lease/watchdog deadlines; recovery/no-show policy; ordinary-removal fault matrix | No cargo release or secure delivery |
| Imaging and rails | Servo pulse/slew limits; measured stall/coincidence current; lighting duty/heat; required dark-scene illumination; Pi workload and health limits | No affected actuation/night workload |

## Commissioning and acceptance matrix

All injections are first simulated, then performed on reviewed props-removed/staged hardware. This is test design, not authorization to energize or intentionally fail airborne hardware. Logs record configuration/firmware hashes, timestamp/epoch, input injection, expected/actual state, observed physical output, measurement uncertainty and disposition. No raw biometric data is required in the safety ledger.

| Gate | Measurable pass criteria | Failure consequence |
| --- | --- | --- |
| S01 — arm paths | Enumerate RC switch/stick, normal/force MAVLink, scripting, mission, reboot, USB maintenance and motor-test paths. Include absent script at startup and `arm(method,false)`. For each, test absent/one-factor/wrong-owner/expired/replayed/canceled/epoch-mismatched authorization; zero unauthorized arm transitions. Concurrent duplicate valid requests produce at most one arm attempt. | Hold M2; mandatory FC gate implementation, not disable checks. |
| S02 — freshness boundaries | At each configured deadline test one scheduler tick before, exactly at, and one tick after; expired at equality. Repeat with delayed/out-of-order/duplicated messages and restart. No stale command/lease accepted. | Hold affected function; adjust design and retest. |
| S03 — emergency priority | In every released airborne mode simulate Pi/phone/biometric loss, then independent takeover; measured transition within declared `T_takeover_max`, no authentication prompt or auth-triggered motor stop. Repeat paired fault cases including RC loss. | Hold onboard/autonomous activation; complete FC-owned protection. |
| S04 — M1 failsafes | Exercise the exact configured RC/GCS/battery/EKF branches including armed-ground, airborne low-throttle and simultaneous loss. Expected and observed FC states match for every row; no cargo output or unintended mission continuation. | No first flight/repeatability qualification. |
| S05 — release electrical faults | Scope PWM7 and coil voltage/current for boot, reset, power order, truncated pulses, Pi kill, script stop, UART loss and held-active timer. No unauthorized activation; active lease terminates by measured required deadline; OFF waveform never crosses ON threshold. | Hold M5; affected watchdog/interlock redesign if required. |
| S06 — switches/security | Independently challenge each switch open/closed; disconnect each lead; inject short-to-ground/stuck state and contradictions; attempt ordinary holder/door removal. Unknown/failed input cannot start release. Document undetectable failures honestly; no security pass if approved fault/threat matrix is violated. | Hold loaded/secure delivery; affected mechanical/sensing redesign. |
| S07 — standstill/handoff | Measure worst-case prop coast-down after normal and fault disarm across configuration; validate stopped predicate and attended approach protocol. Release never starts before landed/disarmed/stopped, and no rearm occurs through release, reset or collection. | Hold handoff; no recipient approach under uncertain rotor state. |
| S08 — rails/thermal | At maximum qualified camera/compute/video and illumination load plus commanded servo cases/release, measure all rails at load connectors, branch current, hot spots and Pi undervoltage/throttling. TFmini 4.9–5.1V; all other actual datasheet limits; no reset or unintended output. Use instrumentation sufficient for transients, not only a handheld meter. | Ground affected configuration; load/path correction and repeat. |
| S09 — energy monitor | Calibrate whole-pack V/I/Wh at representative loads against traceable reference; fix uncertainty and missing-sample threshold before testing reserve; every branch accounted; inject monitor loss and accumulator/reset faults. Protection triggers at/before R02. | No endurance/recovery claim or affected flight. |
| S10 — Q73 | Three simulator rehearsals; bench evidence; separate commissioning; three consecutive qualifying real manual exercises across at least two sessions under Q73's unchanged measured envelope. | M1 aircraft acceptance incomplete; independent PC work unaffected. |
| S11 — Q74 | Twenty useful minutes with 12 follow/6 hover/2 transition mix, all required equipment active, independent full reserve; at least three successful evaluations across two days and qualifying evidence per released pack; every attempt logged. | Hard requirement fails; redesign affected propulsion/energy/installation and revalidate, never waive. |
| S12 — payload | Validate 250g cargo plus actual holder mass/CG/retention/clearance/control/energy, release security and collection in declared loaded envelope. No inference of 20-minute loaded endurance. | No delivery outside measured positive envelope. |
| S13 — privacy | Implemented capture/storage/restart/deletion tests match separately approved onboard consent/retention policies; unauthorized persistence/access absent. | Hold affected capture/storage feature, not claim physical fit failure. |
| S14 — configuration control | Every firmware, wiring, mechanical, pack, model or policy change has affected V-gate list, measured ledger update and rerun evidence. No silent re-use of earlier results. | Affected capability unqualified until rerun. |

## Primary evidence checked for this contract

- [ArduPilot arm/disarm command interface](https://ardupilot.org/dev/docs/mavlink-arming-and-disarming.html): ordinary and force command paths exist; enumerate both in E01/S01 rather than assuming a Pi UI gate covers them.
- [Selected ArduPilot arming source](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/AP_Arming/AP_Arming.cpp): source-audit basis for the distinction between optional auxiliary checks and mandatory arm checks. The firmware manifest records the exact selected artifact and enforcement gap; no patch is implemented by this document.
- [ArduPilot pre-arm checks](https://ardupilot.org/copter/docs/common-prearm-safety-checks.html): errors must be corrected; auxiliary authorization and script-health checks are available mechanisms, not proof of this project's all-path policy.
- [ArduPilot radio failsafe](https://ardupilot.org/copter/docs/radio-failsafe.html): behavior varies by configured mode, landed/throttle state and options; link restoration does not itself restore the previous mode. Audit `FS_OPTIONS`, including the gripper-release option: release-on-failsafe is forbidden here. Do not blindly import a parameter recipe.
- [ArduPilot scripting](https://ardupilot.org/copter/docs/common-lua-scripts.html): scripting is supported, but its availability alone does not prove continuous safety enforcement or watchdog behavior.
- [Pololu #2802](https://www.pololu.com/product/2802) and [RC switch guide](https://www.pololu.com/docs/0J60/all): 5V logic supports the selected load and includes flyback protection. The default threshold is 1696µs with ±64µs hysteresis. No-signal recognition is nominally 130ms; safe-start follows 500ms of bad input. Safe-start needs an OFF pulse before activation. Continuous valid ON pulses are therefore not an authorization timeout. GOOD/OUT are VCC-level outputs, not direct 3.3V Pi inputs; this baseline does not use them as qualified latch sensors.

Where this contract sets a required behavior, it is an engineering requirement derived from approved decisions, not a claim the cited manufacturer implements it. Any genuine failure reopens only the affected subsystem under Q75 while preserving the remaining requirements and minimizing cost.
