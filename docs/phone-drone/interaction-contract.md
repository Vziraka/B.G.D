# Phone/onboard interaction contract v1

Status: **approved design baseline for Issue12's simulated slice; not implemented or physically qualified**. This contract replaces the retired Windows-product and face-plus-voice-before-every-arm policies. It does not authorize device setup, biometric capture, motor output, fabrication or flight.

## Scope and seam

One versioned session protocol is the interface shared by the phone, simulated aircraft, onboard computer and later flight-control adapter. Transport, UI, biometric model and flight-controller implementations stay behind that seam. The first implementation uses a simulated-aircraft adapter and a face-result test double; a later adapter may reach SITL only after the same state rules pass.

The protocol distinguishes three authorities:

- **Launch authority** permits one prepared aircraft to start one launch/approach attempt after ordinary flight-readiness checks. It comes from possession of a paired phone or the paired independent radio, not from a biometric result.
- **Owner command session** permits new spoken mission commands only after onboard owner face and liveness verification for the current flight session.
- **Independent manual authority** belongs to the paired radio and remains available for takeover and controlled landing without a new biometric check. It is not a reusable phone or autonomous-command permission.

No authority implies another. A launch request does not enable spoken commands; an owner command session does not bypass flight-controller safety checks; loss of either never commands an airborne motor shutdown.

## Settled product decisions

### Pairing and recovery

- Pairing is local and owner-attended. The aircraft must be landed, disarmed, healthy and in an explicit two-minute pairing window opened by a deliberate radio maintenance gesture. Remote or ordinary flight messages cannot open that window.
- The phone and aircraft create device keys and mutually authenticate. The owner confirms the same short fingerprint on the phone and with the radio before either identity is committed. A network password or possession of the phone alone is not pairing.
- Initial pairing creates a rotating recovery secret. The phone displays each generation once for offline storage; the aircraft stores only a verifier. Successful recovery commits a new generation and invalidates the used one. The secret grants no launch, command or motor authority.
- A replacement phone requires either approval from an existing paired phone or the recovery secret plus the physical radio maintenance gesture. Pairing replacement revokes the old phone atomically. Reset, partial state, mismatched identity or interrupted replacement leaves the aircraft command-locked and does not reopen first setup.
- The independent radio has its own binding and recovery process. Phone pairing cannot replace, disable or impersonate it.

### Owner enrollment

- Owner face enrollment occurs in a dedicated, landed, disarmed, motor-inhibited service session using the aircraft's actual camera and onboard model path. The phone guides the session but never supplies a client-asserted success result.
- Enrollment begins only from an authenticated paired phone after the physical radio maintenance gesture. It records an encrypted face reference and model/version metadata, not an ordinary raw-photo archive.
- Updating the face reference requires a fresh successful check against the current reference or the recovery secret plus the radio maintenance gesture. The old reference remains active until the replacement is fully validated and committed.
- Recovery can authorize re-enrollment but never launch, commands, arming or cargo release. Missing, corrupt, rolled-back or incomplete ownership state fails closed.

### Offline transport

- The aircraft hosts a private local Wi-Fi network for command, status and later video. Flight operation must not require internet or a cloud service.
- The protocol uses mutually authenticated encrypted sessions above the local network. Device keys, aircraft ID, configuration ID and boot epoch bind every connection. Bluetooth may later assist discovery but is never an authority path.
- Pairing credentials and biometric/recovery material are excluded from hosted builds, telemetry and source control. Actual iPhone networking, background behavior, range, coexistence and power remain device-validation gates.

### Launch request

- Either the paired phone or paired radio may request launch. Phone launch requires an intentional hold-to-confirm action; radio launch requires a deliberate configured control gesture. A retained or repeated input is not a new edge.
- A phone launch request answers a fresh aircraft-issued challenge that expires after **15 seconds on the aircraft's monotonic clock**. It names the aircraft, configuration, boot epoch, flight session, challenge and request ID. A paired-radio launch uses a fresh deliberate control edge. Either path authorizes at most one launch/approach attempt and is consumed whether accepted or rejected.
- The flight controller independently checks configuration, site, radio, energy, navigation and ordinary pre-arm readiness. A valid request never bypasses those checks.
- Automatic launch is admitted only with a confirmed fixed return/landing point and a configured verification pose. No phone, script, mission or maintenance path may create an unbound launch.

### Verification pose and owner check

- The initial locating method is a fixed verification zone defined relative to the confirmed launch/return point. The phone tells the owner where to stand; the aircraft approaches the configured pose rather than searching for or following an unverified person.
- Physical distance, altitude, camera angle, lighting, wind and exclusion limits remain disabled configuration until validated. Simulator defaults are illustrative and must be labelled as such.
- At the pose, the aircraft performs onboard face identity and liveness together. A client-supplied boolean, still photo, recorded video or stale prior result cannot satisfy the check.
- One explicit retry may be requested within **30 seconds** while the aircraft remains in a validated stable pose. A second failure, timeout, disconnect or invalid pose ends verification and grants no command session.

### Owner command session and speech input

- Successful face/liveness verification creates one owner command session bound to the aircraft, configuration, boot epoch and flight session. It ends on landing and disarm, phone disconnect, app termination, explicit Stop, five minutes without an accepted command, a configuration/epoch change or a safety fault.
- Every spoken command requires a deliberate phone-generated speech window. The preferred adapter is press-and-hold on the EarPods inline control; an on-screen hold control is the fallback. Each window lasts at most **10 seconds** and accepts at most one command. Always-listening audio and wake-word-only authorization are out of scope for v1.
- Headset removal, calls, audio-route change, lock/background suspension, lost focus, timeout or ambiguous speech closes the current window and produces no command. Resume requires another deliberate input; it never replays captured or queued audio.
- Speech recognition identifies the requested action, not the speaker. Authorization comes from the current owner command session plus the deliberate speech window. Commands are acknowledged only after the aircraft accepts or rejects the exact request.
- Finite accepted commands may complete if the phone session later expires and the flight state remains safe. Open-ended autonomous activity stops accepting new updates and transitions through the validated loss/recovery policy. Independent radio takeover always has priority.

### Verification failure and recovery

- Verification failure, timeout or session loss never shuts down airborne motors. It denies new spoken commands and cancels any unaccepted request.
- If the confirmed return/landing point remains healthy, reachable and protected by the energy reserve, the aircraft enters the validated return-and-land behavior.
- If return is unavailable, the flight controller uses only a separately validated degraded-navigation recovery branch. It must not blindly fly to stale coordinates, hover indefinitely or choose a new landing site without qualification. The independent radio remains the primary owner recovery path.
- Reconnection does not resume verification, launch or commands. A new request is required from a safe state.

## Protocol v1

Every message carries `protocol_version`, `aircraft_id`, `configuration_id`, `boot_epoch`, `session_id`, `sequence`, `request_id` and `kind`. Phone launch also carries an aircraft-issued `challenge_id`. Each authority measures its own deadlines on its local monotonic clock; cross-device monotonic timestamps are never compared. Receivers reject unknown versions, identity/epoch mismatches, duplicate or decreasing sequences, duplicate request IDs, expired or previously consumed challenges, and results for a request that is not currently pending.

The external message kinds are deliberately small:

| Kind | Purpose |
| --- | --- |
| `launch_challenge` / `launch_request` / `launch_result` | Issue a locally timed challenge, then request and accept/reject one launch/approach attempt |
| `flight_status` | Report simulator/real origin, readiness, armed/airborne/approach/landed state and relevant fault |
| `verification_status` | Report pending/pass/fail/timeout without exposing biometric material |
| `command_session` | Report granted/denied/expired/revoked owner command permission |
| `command_request` / `command_result` | Request and acknowledge one bounded command |
| `cancel_request` | Cancel one still-pending request; cancellation is not a flight mode |

Pairing, enrollment and recovery use a separate maintenance interface and cannot be invoked through ordinary flight messages.

## First-slice state machine

`DISCONNECTED -> GROUND_READY -> LAUNCH_PENDING -> APPROACHING -> VERIFYING -> COMMAND_READY`

Rejection returns to `GROUND_READY`. Verification failure, timeout or disconnect while airborne enters `PROTECTIVE_RECOVERY`, then `LANDED`. Cancellation affects only a named pending request. Restart creates a new boot epoch and invalidates every prior request and permission.

The simulator must demonstrate success, launch rejection, verification failure, retry exhaustion, stale/replayed result rejection, disconnect and restart. It must expose no actuator adapter and must label every state and face result `SIMULATED`.

## Deferred evidence and later decisions

The following remain explicit gates rather than assumed facts: actual iPhone build/signing; EarPods control delivery while locked/backgrounded; local-Wi-Fi range and coexistence; verified physical approach geometry; real face/liveness accuracy and spoof resistance; onboard storage and rollback resistance; flight-controller integration; safe return/degraded recovery; power, thermal and endurance impact; guest command policy; and recipient enrollment/release behavior.
