# Phone/onboard interaction contract

Status: **current design amended by the September 10 product reset** in [Issue10](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md). The completed [v1 simulator](simulator.md) demonstrates the earlier owner-only, bounded-command slice; it does not implement or qualify the expanded requirements below. Native deployment and physical qualification remain pending. This document does not authorize device setup, biometric capture, motor output, fabrication or flight.

## September 10 product reset

Phone voice is the primary mission interface: accept natural wording and multi-step requests for following, finding people/objects, and scouting/counting. Resolve unclear targets before action and report inability or uncertain identification instead of inventing a result. A language interpretation proposes a mission; authenticated onboard execution checks actual supported actions and operating conditions. Orbit, watch and patrol are optional extensions when they reuse core work without substantial delay.

Desired operation includes outdoors with trees/buildings, large warehouse interiors, darkness and out-of-sight missions. These are requirements for engineering and staged qualification, not established capabilities. The initial working-distance target is 100 m from the user, not total travel or a permanent maximum; phone-link reach and navigation require separate evidence. Core mission execution, perception, flight response and recovery must work without internet; optional online language assistance may improve request interpretation without becoming a flight dependency.

Live aircraft video on the phone is required. Use digital zoom with the selected fixed-lens camera and reposition for more detail when route, separation, lighting and energy permit; optical zoom is not required. A guidance preview alone does not satisfy general live-view acceptance. The endurance target is 10 useful minutes excluding takeoff and landing. Battery monitoring must interrupt work early enough to reach a suitable landing spot and land; prediction of whole-mission completion is not required. The energy method must be engineered against the selected configuration, not copied from the old fixed-return reserve model. “Max speed” means the fastest task execution supported by tested sensing, flight and environmental limits. Cargo, recipient/release flows and separate guest roles/expiry/command permissions are retired.

## Scope and seam

One versioned session protocol is the interface shared by the phone, simulated aircraft, onboard computer and later flight-control adapter. Transport, UI, biometric model and flight-controller implementations stay behind that seam. The first implementation uses a simulated-aircraft adapter and a face-result test double; a later adapter may reach SITL only after the same state rules pass.

The protocol distinguishes three authorities:

- **Launch authority** permits one prepared aircraft to start one launch/approach attempt after ordinary flight-readiness checks. It comes from possession of a paired phone or the paired independent radio, not from a biometric result.
- **Enrolled-user command session** permits new spoken mission commands only after onboard enrolled-user face and liveness verification for the current flight session.
- **Independent manual authority** belongs to the paired radio and remains available for takeover and controlled landing without a new biometric check. It is not a reusable phone or autonomous-command permission.

No authority implies another. A launch request does not enable spoken commands; an enrolled-user command session does not bypass flight-controller safety checks; loss of either never commands an airborne motor shutdown.

## Current interaction requirements

Preserve the user experience the owner deliberately required, including prepared launch and approach before onboard face/liveness grants spoken-command access, trusted enrollment through the unlocked paired phone while landed/disarmed, and independent manual takeover. Delegated details and accepted engineering recommendations remain revisable when they preserve that experience, authenticated device ownership/recovery, request freshness, onboard identity/liveness and qualified airborne recovery. Acceptance of a recommendation does not by itself make its mechanism a product requirement; recover decision provenance when uncertain. The two-minute pairing window, fifteen-second launch challenge and thirty-second retry window below are current engineering baselines. Verify revised mechanisms and values against the behavior and failures they control, and update affected implementation and evidence.

### Pairing and recovery

- Pairing is local and owner-attended. The aircraft must be landed, disarmed, healthy and in an explicit bounded pairing window (current engineering baseline: two minutes) opened by a deliberate radio maintenance gesture. Remote or ordinary flight messages cannot open that window.
- The phone and aircraft create device keys and mutually authenticate. The owner confirms the same short fingerprint on the phone and with the radio before either identity is committed. A network password or possession of the phone alone is not pairing.
- Initial pairing creates a rotating recovery secret. The phone displays each generation once for offline storage; the aircraft stores only a verifier. Successful recovery commits a new generation and invalidates the used one. The secret grants no launch, command or motor authority.
- A replacement phone requires either approval from an existing paired phone or the recovery secret plus the physical radio maintenance gesture. Pairing replacement revokes the old phone atomically. Reset, partial state, mismatched identity or interrupted replacement leaves the aircraft command-locked and does not reopen first setup.
- The independent radio has its own binding and recovery process. Phone pairing cannot replace, disable or impersonate it.

### Trusted enrollment

- One trusted-user group: every enrolled person has the same spoken mission-command abilities after onboard face/liveness verification. No separate guest role, per-command permission or expiry system is required.
- Add and remove people through the unlocked, authenticated paired phone while the aircraft is landed, disarmed and motor-inhibited. The owner controls access by deciding who receives that phone; routine enrollment does not need an additional administrator identity or radio gesture. Device pairing/replacement and recovery retain their separate authentication and recovery rules.
- Face enrollment uses the aircraft's actual camera and onboard model path. The phone supplies live framing/liveness guidance but cannot assert success. Store encrypted references with model/version metadata rather than an ordinary raw-photo archive. Commit a validated enrollment atomically; invalid or interrupted writes grant no new identity or command permission.
- Removal revokes the selected reference and associated permissions. All normal command sessions already end on landing/disarm; roster changes must also invalidate stale authorization state. Recovery may restore enrollment access but never grants launch, commands or arming. Missing, corrupt or rolled-back state fails closed.
- The earlier simulator's single-owner reference, radio-gated enrollment and reference-replacement rules are historical implementation coverage, not the target group-management design.

### Offline transport

- The aircraft hosts a private local Wi-Fi network as the existing candidate for command, status and video; transport selection and reach remain subject to engineering. Essential flight and mission operation must not require internet or a cloud service. Optional online assistance may interpret requests; loss of the phone link remains a separate recovery event.
- Enrollment and verification video uses a separate mutually authenticated, encrypted media channel. It is displayed only for the active guidance session, is not recorded by default on either endpoint and stops on completion, cancellation, disconnect, app termination or session expiry. Loss of video cannot be interpreted as biometric success.
- The protocol uses mutually authenticated encrypted sessions above the local network. Device keys, aircraft ID, configuration ID and boot epoch bind every connection. Bluetooth may later assist discovery but is never an authority path.
- Pairing credentials and biometric/recovery material are excluded from hosted builds, telemetry and source control. Actual iPhone networking, background behavior, range, coexistence and power remain device-validation gates.

### Launch request

- Either the paired phone or paired radio may request launch. Phone launch requires an intentional hold-to-confirm action; radio launch requires a deliberate configured control gesture. A retained or repeated input is not a new edge.
- A phone launch request answers a fresh aircraft-issued challenge that expires after a bounded interval measured on the aircraft's monotonic clock (current engineering baseline: **15 seconds**). It names the aircraft, configuration, boot epoch, flight session, challenge and request ID. A paired-radio launch uses a fresh deliberate control edge. Either path authorizes at most one launch/approach attempt and is consumed whether accepted or rejected.
- The flight controller independently checks configuration, site, radio, energy, navigation and ordinary pre-arm readiness. A valid request never bypasses those checks.
- Automatic launch is admitted only with a confirmed fixed return/landing point and a configured verification pose. No phone, script, mission or maintenance path may create an unbound launch.

### Verification pose and enrolled-user check

- The initial locating method is a fixed verification zone defined relative to the confirmed launch/return point. The phone tells the enrolled user where to stand; the aircraft approaches the configured pose rather than searching for or following an unverified person.
- While the aircraft is stably occupying the verification pose, the phone shows the live guidance preview with a face-framing target and non-authoritative alignment/liveness cues. The UI distinguishes camera connectivity, usable framing and onboard verification progress; it never depicts a phone-generated match as aircraft approval.
- Physical distance, altitude, camera angle, lighting, wind and exclusion limits remain disabled configuration until validated. Simulator defaults are illustrative and must be labelled as such.
- At the pose, the aircraft performs onboard face identity and liveness together. A client-supplied boolean, still photo, recorded video or stale prior result cannot satisfy the check.
- One explicit retry may be requested within a bounded interval (current engineering baseline: **30 seconds**) while the aircraft remains in a validated stable pose. A second failure, timeout, disconnect or invalid pose ends verification and grants no command session.

### Enrolled-user command session and speech input

- Successful onboard face/liveness verification creates one command session bound to the enrolled identity, aircraft, configuration, boot epoch and flight session. It ends on landing/disarm, phone disconnect, app termination, explicit Stop, configuration/epoch change or a safety fault. The existing five-minute inactivity timeout is a simulator baseline, not an immutable product requirement; select and test session timing during implementation.
- Voice enters deliberately through the phone. On-screen speech input is sufficient; EarPods remain an optional adapter, not mandatory hardware. Speech recognition identifies intent, not speaker identity. Authorization comes from the current face/liveness-backed session and deliberate input.
- Natural phrasing can express multiple supported actions in one request. The old ten-second/one-bounded-command simulator window does not cap the revised product. Engineer cancellation, ambiguity handling, timing, replay rejection and explicit acceptance for the exact interpreted mission before execution; no promise to execute arbitrary unsupported instructions is implied.
- Calls, audio-route changes, lock/background suspension, lost focus or interrupted capture close the active input safely and never replay queued audio. Actual device behavior needs validation. Internet loss must not be mistaken for phone disconnection or revoke locally available essential capability.
- Accepted activity may continue only under its validated execution and link-loss policy. New commands require an active session; independent radio takeover always has priority. Authentication loss never becomes an airborne motor-stop command.

### Verification failure and recovery

- Verification failure, timeout or session loss never shuts down airborne motors. It denies new spoken commands and cancels any unaccepted request.
- If the confirmed return/landing point remains healthy and reachable with sufficient recovery and landing energy, the aircraft enters the validated return-and-land behavior.
- If return is unavailable, the flight controller uses only a separately validated degraded-navigation recovery branch. It must not blindly fly to stale coordinates, hover indefinitely or choose a new landing site without qualification. The independent radio remains the primary owner recovery path.
- Reconnection does not resume verification, launch or commands. A new request is required from a safe state.

## Historical implemented protocol v1

The following describes the completed earlier slice, retained for compatibility and regression evidence. Expanded mission and group-enrollment adapters must reconcile this seam explicitly; these rows do not claim their implementation.

Every message carries `protocol_version`, `aircraft_id`, `configuration_id`, `boot_epoch`, `session_id`, `sequence`, `request_id` and `kind`. Phone launch also carries an aircraft-issued `challenge_id`. Each authority measures its own deadlines on its local monotonic clock; cross-device monotonic timestamps are never compared. Receivers reject unknown versions, identity/epoch mismatches, duplicate or decreasing sequences, duplicate request IDs, expired or previously consumed challenges, and results for a request that is not currently pending.

The external message kinds are deliberately small:

| Kind | Purpose |
| --- | --- |
| `launch_challenge` / `launch_request` / `launch_result` | Issue a locally timed challenge, then request and accept/reject one launch/approach attempt |
| `flight_status` | Report simulator/real origin, readiness, armed/airborne/approach/landed state and relevant fault |
| `verification_status` | Report pending/pass/fail/timeout plus non-sensitive framing guidance without exposing biometric material |
| `command_session` | Report granted/denied/expired/revoked owner command permission |
| `command_request` / `command_result` | Request and acknowledge one bounded command |
| `cancel_request` | Cancel one still-pending request; cancellation is not a flight mode |

Pairing, enrollment and recovery use a separate maintenance interface and cannot be invoked through ordinary flight messages.

## Historical completed first-slice state machine

`DISCONNECTED -> GROUND_READY -> LAUNCH_PENDING -> APPROACHING -> VERIFYING -> COMMAND_READY`

Rejection returns to `GROUND_READY`. Verification failure, timeout or disconnect while airborne enters `PROTECTIVE_RECOVERY`, then `LANDED`. Cancellation affects only a named pending request. Restart creates a new boot epoch and invalidates every prior request and permission.

The simulator must demonstrate success, launch rejection, verification failure, retry exhaustion, stale/replayed result rejection, disconnect and restart. It must also demonstrate a clearly labelled simulated guidance preview, advisory alignment cues and preview loss without turning any of them into biometric success. It must expose no actuator adapter and must label every state, preview and face result `SIMULATED`.

## Deferred evidence and later decisions

The following remain explicit gates rather than assumed facts: actual iPhone build/signing; real-camera preview latency, quality, privacy and app lifecycle behavior; EarPods control delivery while locked/backgrounded; local-Wi-Fi range, video capacity and coexistence; verified physical approach geometry; real face/liveness accuracy and spoof resistance; onboard storage and rollback resistance; flight-controller integration; safe return/degraded recovery; power, thermal and endurance impact; trusted-group enrollment/removal and session revocation; natural-language multi-step mission interpretation/execution; general live video/digital zoom; and indoor, dark and out-of-sight perception/navigation. Cargo/recipient behavior is retired.
