# Actuator-free phone/onboard simulator

Implemented September 10, 2026 against the [approved v1 interaction contract](interaction-contract.md) and [authority ADR](../adr/0001-phone-onboard-authority.md). This is an offline Python standard-library state model and an interactive playback of its traces. **Every camera frame, face/liveness result, pairing identity, flight state and command is SIMULATED.** No actual biometric or flight evidence is produced.

From the repository root, run:

```powershell
python -m phone_drone_sim
python -m unittest discover -s tests/phone_drone_sim -v
```

Open [simulator-demo.html](simulator-demo.html) in a browser. Select a scenario and use **Next step**, **Previous**, or **Play scenario**. The animated synthetic face is visible only during active guidance; a blank preview explicitly shows completion/loss. The same scenarios can be printed without opening a browser:

```powershell
python -m phone_drone_sim --text
```

`--demo path/to/demo.html` writes the playback to another location. There is no server, installation, account, internet dependency, camera/microphone permission, device discovery or external script. The demo is generated from the Python state machine; JavaScript only selects and displays recorded synthetic steps. Playback is a guided demonstration, not a phone app or an interactive aircraft control surface.

## Implemented and checked

The new [model](../../phone_drone_sim/model.py) and [35-test suite](../../tests/phone_drone_sim/test_contract.py) are isolated from the dormant PC biometric product. Tests run in deterministic simulated time; generated traces are repeatable. Random session IDs are not exported into trace snapshots. Tested with Python 3.13.12 on the Windows development host. Independent review added regressions for resequenced status replay, unsafe continuation of finite work, caller-mutated payloads and malformed results consuming request correlation; all four were repaired and the full suite passes.

Reuse choice: the repository had no active implementation of this phone/onboard contract. The retired PC modules are neither imported nor revived. Python's standard library supplies data records, IDs, argument parsing, JSON, files and tests; native HTML/SVG supplies the playback. No new dependency or copied third-party code is included, so no third-party license claim is made. The existing ArduPilot/SITL direction remains the later flight-control adapter; this slice does not build custom flight physics.

| Behavior | Implemented simulation and verification |
| --- | --- |
| Enrollment service | Authenticated-pairing fixture, explicit radio maintenance fixture, healthy landed/disarmed/motor-inhibited guards, bounded temporary synthetic preview, separate onboard result injection. Failure/cancel/loss/restart retains the prior synthetic reference generation. Replacement requires a current-reference-check or recovery-authorization fixture. These flags cannot arrive through ordinary protocol messages. |
| Launch | Intentional phone-hold fixture answers an aircraft-local 15-second one-use challenge; radio uses an independently paired fresh control edge. Accepted and rejected attempts consume authority. Configuration/site/radio/energy/navigation/prearm/return-point/pose readiness remains additive. Pending launch cannot execute after challenge expiry. |
| Protocol | Version, aircraft/configuration/boot/session, sequence, request ID and SIMULATED origin checked at both modeled endpoints. Strict malformed-input, wrong identity/version/epoch, duplicate/decreasing sequence, reused request ID and stale result rejection. Launch/command results acknowledge the exact pending request. Flight/verification/command-session status messages also cross the versioned seam. Verification results correlate to the pending test-double operation. |
| Guidance and face/liveness | Enrollment and fixed-zone verification show clearly labelled animated synthetic preview and advisory framing cues. Only a fresh onboard test-double result with both face match and liveness passes; client booleans, preview availability and framing cannot grant permission. Face and liveness failures are tested separately. |
| Failure and retry | One explicit retry within 30 seconds; second failure, timeout, invalid pose, preview loss or disconnect ends verification and denies command permission. Exact deadline equality is expired. Successful retry and exhausted retry are both demonstrated. |
| Speech | At most one command per deliberate window, at most 10 seconds, including delayed onboard acceptance. Unknown/ambiguous commands fail closed. Inline-control and screen-hold behavior are input fixtures. Calls, route/headset changes, lock/background/focus loss, release and timeout discard the window and queued unaccepted speech; resume requires a new deliberate input. |
| Session lifecycle | Five minutes since last accepted command expires permission. Stop, landing/disarm, disconnect, app termination, configuration change, restart and safety fault revoke it. New flights and boots receive fresh bindings. Reconnect restores no pending work or permission; phone disconnect clears displayed state and refuses old status. |
| Recovery/manual authority | Authentication loss never changes an airborne `armed` flag to false. Healthy/reachable/reserve-protected return selects a simulated return branch. Otherwise a separately qualified degraded-policy fixture or an explicit unqualified-recovery hold is reported. No blind return, indefinite-hover solution or new-site choice is invented. Independent radio takeover needs no biometric check and remains authoritative through further phone loss. |
| Accepted work | A synthetic finite accepted task may remain after phone-session loss while safe; open-ended activity stops. Unaccepted requests are canceled. Restart clears active work and grants no automatic mission resume. |

The eleven demo scenarios cover success, launch rejection, face failure/retry success, liveness failure/retry exhaustion, verification timeout, preview loss, disconnect/reconnect, restart, replay rejection, interrupted speech and unavailable-return/manual takeover. The suite adds negative paths and one-tick-before/exactly-at/one-tick-after challenge, retry, attempt, speech and inactivity boundaries.

The only command names are synthetic examples: `status`, `inspect_once` and `observe_until_stopped`. They set trace state only. They are not a selected M3 mission vocabulary or implementations of tracking/navigation. Cargo release and forced-arm commands are rejected; no cargo or actuator adapter exists.

## Deliberate simulation limits

`Simulator.receive()` is the modeled ordinary phone-message boundary. `Phone.receive_result()` and `Phone.receive_status()` are the modeled phone receive boundaries. Maintenance, radio edges, flight observations, readiness, clocks and `inject_*_result()` methods are **trusted test-harness injections**, not remotely callable endpoints. Calling Python methods directly is not a sandbox, an authenticated connection or production authorization. The model runs as a single-threaded event loop; real concurrent/transport inputs must eventually be serialized and authenticated at a reviewed boundary.

Pairing is a pre-established fixture identity. The simulator does not generate device keys, authenticate fingerprints, encrypt transport, implement phone replacement/recovery-secret rotation, persist encrypted references or prove rollback resistance. Enrollment keeps only a synthetic integer reference version. No face image, real reference, voice sample, key, secret or real recovery material is stored or logged. Maintenance approval fixtures show the service guards without presenting mock cryptography as evidence. Actual V14 pairing/recovery/storage work remains pending.

The approved timers are 15-second launch challenges, 30-second retry admission, 10-second speech windows and five-minute command inactivity. A **30-second initial/second verification attempt timeout** and **120-second enrollment duration** are conservative illustrative simulator choices, not validated physical timing. The two-minute radio maintenance window is modeled. Each endpoint advances its own local monotonic clock; cross-device timestamps are never compared. Advancing the model clock explicitly represents watchdog ticks; no real-time watchdog latency is established.

All physical pose/distance/altitude/environment settings remain disabled. `land_and_disarm()` injects a trusted synthetic observation; it does not send a disarm or landing command. Restart invalidates authority without claiming stabilization survives a flight-controller reset or battery loss. The recovery branches have no trajectory, autopilot, dynamics or hardware output, and do not qualify the real safety policy.

## Next integration gates

The simulator supplies software evidence for parts of V12/V13/V16/V17 and maintenance guard examples for V14. It does **not** pass those operational gates. Follow the [validation register](../research/issue10-validation-register-2026-08-30.md), [firmware manifest](../hardware/baseline-r1/firmware-manifest.md) and [safety contract](../hardware/baseline-r1/safety-state-tables.md).

The [iPhone route assessment](../research/iphone-route-recheck-2026-09-10.md) is complete as documentary research: remote Mac access is the expected build direction, with no provider selected or purchased. Next, use these fixtures for authenticated local transport, onboard ownership/recovery/storage and native UI integration. Carry the negative tests into an explicitly scoped flight-control simulation adapter before operational integration. Actual build/signing, offline/EarPods lifecycle, camera/liveness, media encryption/latency/privacy, Wi-Fi range/coexistence, physical pose and recovery, FC path enforcement, watchdogs, mass/power/thermal effects and endurance need separate evidence. No account setup, signing/deployment, capture, purchase, installation, hardware operation or PC-product work is authorized by running this demo.
