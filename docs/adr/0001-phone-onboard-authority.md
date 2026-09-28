# 0001: Separate launch, owner command and manual authority

Date: 2026-09-10

Status: accepted with September 10 product-reset amendment; the owner-only command/enrollment scope is superseded by the [current interaction contract](../phone-drone/interaction-contract.md).

## September 10 amendment

Retain the separation of launch, face/liveness-backed command and independent manual authority. Command authority now applies equally to every trusted person enrolled through the unlocked paired phone while landed/disarmed; separate guest permissions and administrator roles are not required. Device pairing, revocation/recovery, request binding and airborne recovery remain necessary. Natural phone requests may contain multiple supported mission actions, with essential operation offline and optional online interpretation. The completed simulator below covers the earlier owner-only slice, not these extensions. Historical references to an “owner command session” mean that older scope; use “enrolled-user command session” for new work.

## Context

The September 9 product change removed the Windows app and speaker identity, and deliberately moved owner face/liveness verification after launch and approach. The former rule—owner face and voice before every arming path—cannot describe that flow. Treating device possession, biometric verification and manual recovery as one permission would also make phone or biometric loss unsafe while airborne.

## Decision

Use three non-interchangeable authorities:

1. A paired phone or paired radio may issue one short-lived, request-bound launch authorization after ordinary flight-readiness checks.
2. Onboard owner face/liveness verification creates a flight-session-bound permission for new spoken mission commands.
3. The independent radio retains manual takeover and controlled-landing authority without another biometric check.

All phone/aircraft interaction crosses one versioned session-protocol seam. The simulator, onboard implementation and later flight-control integration are adapters behind that interface. Pairing/enrollment use a separate motor-inhibited maintenance interface.

## Consequences

- The aircraft may launch before owner biometrics, as explicitly requested, so possession and pairing security plus strict launch preparation are safety-critical.
- A stolen paired device may request launch within the admitted physical envelope but cannot gain an owner command session without onboard face/liveness. Device revocation and recovery therefore remain required.
- Authentication loss denies new mission commands but never becomes an airborne motor-stop command.
- Historical PC acceptance and face-plus-voice all-arming requirements remain evidence only and must not be copied into current firmware or tests.
- The first simulator can exercise the original bounded slice of the product state contract without an iPhone build, biometric model or actuator output.
