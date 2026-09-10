# Define and prototype the phone/onboard interaction

Type: task
Status: claimed

## Current checkpoint

The product/security decisions needed for the first slice are settled in the [v1 interaction contract](../../../docs/phone-drone/interaction-contract.md) and [authority ADR](../../../docs/adr/0001-phone-onboard-authority.md). The domain glossary, flight-stack pointer, firmware/safety contracts and V01–V19/V30 traceability now reflect the September 9 amendment. No phone implementation has started. Issue11 remains a parallel hardware workstream; prototype results cannot release hardware.

## Outcome

A small, explicit phone/drone interface and one runnable simulated interaction, preserving the owner's requested launch, face/liveness and phone/earbud-command flow. Retire the old Windows-product completion queue without treating its unresolved validation as passed.

## Next action

Implement the smallest demonstrable slice against protocol v1 with a clearly labelled simulated-aircraft adapter, simulated live guidance preview and face-result test double. Add deterministic checks for success, rejection, verification failure/retry exhaustion, stale/replayed/out-of-order results, preview loss, disconnect and restart. Then assess the iPhone development route before promising deployment.

## Acceptance for this slice

- Shared interface identifies aircraft/session/request and distinguishes requests, results and permission.
- Simulated success, rejection, verification failure and stale/disconnected-session handling are demonstrated.
- Enrollment and verification show a clearly labelled simulated live camera preview, framing guidance and preview-loss behavior; preview content and phone-side cues cannot assert biometric success.
- No simulated face result is presented as real biometric proof or sent to physical actuators.
- Remaining actual-device, real-camera preview, liveness, offline/background, transport and flight evidence is explicit.
- Current checkpoint includes the runnable entry point, relevant checks and next integration step.

Later guest, recipient and expanded-autonomy decisions remain open; they do not block this slice. This ticket does not authorize purchases, account/service setup, uploads, device installation, biometric capture or physical flight beyond existing explicit authorization.

## Comments

### 2026-09-10 — First-slice product and authority decisions settled

The owner authorized settling repository alignment, checkpointing and the minimum phone/onboard design. The v1 contract adopts local owner-attended pairing, onboard motor-inhibited enrollment, an aircraft-hosted encrypted local-Wi-Fi session, launch by either paired phone or paired radio, a fixed verification zone, onboard face+liveness before spoken commands, bounded deliberate speech windows and session expiry, conditional return/landing on failure, and independent radio takeover. These are design decisions, not implementation or physical evidence.

### 2026-09-10 — Live guidance preview added to the build contract

The phone must show a temporary, encrypted feed from the aircraft's actual camera during owner enrollment and verification, with framing guides and advisory alignment cues. The simulator must model and visibly label this preview before real-camera integration. Phone UI or preview availability never establishes identity/liveness success; only the onboard result does. Recording is off by default, and real-device latency, quality, privacy, lifecycle and network-capacity behavior remain validation gates.
