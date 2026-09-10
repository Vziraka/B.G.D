# Phone and onboard interaction: design direction

Status: product direction and the [v1 interaction contract](interaction-contract.md) are confirmed design baselines. No phone app or revised aircraft behavior is implemented by these documents. [Issue12](../../.scratch/biometric-guard-drone/issues/12-phone-onboard-interaction.md) owns the simulated slice; [Issue11](../../.scratch/biometric-guard-drone/issues/11-hardware-build-package.md) owns hardware feasibility and engineering.

## Confirmed product direction

- The phone and independent radio controller are the user interfaces. The standalone Windows biometric app, its source, tests, packaging and acceptance queue are dormant history rather than an active tool or workstream. The PC remains the host for the new simulator and engineering software.
- A deliberate phone/controller launch request precedes automatic takeoff/approach. The drone then verifies the enrolled owner's face and liveness at a validated separation before enabling spoken commands.
- Spoken commands enter through the phone/USB-C EarPods. Speaker-identity verification is removed. This does not make every voice near the microphone an authorized command.
- On verification failure, return to a designated landing point, subject to navigation/energy conditions and defined fallback behavior. Independent manual takeover remains available. Loss of biometric authorization does not shut down airborne motors.
- The fixed verification zone and approach position are the settled initial locating method. Their physical geometry, separation and operating limits are not yet qualified.
- Preserve offline operation and the existing iPhone 17 Pro direction. [Q72 build/signing research](../research/issue10-phone-build-options-2026-08-30.md) remains a dated evaluation path, not proof of an installed app. Existing account, deployment and spending boundaries remain.

## Proposed sequence

1. Define the smallest shared interface and settle its consequential ownership/security choices. Use it to build one simulated phone-to-drone interaction before expanding features.
2. Continue two coordinated tracks: phone/onboard software against a simulated drone, and hardware feasibility using actual component evidence, mass accounting and engineering models. Hardware feasibility does not wait for a finished phone app; phone development does not wait for the complete aircraft.
3. Integrate the same interface with flight-control simulation, then appropriate real components and staged physical tests. A simulated result does not qualify actual flight, radio, microphone, face recognition or liveness.

## Settled shared interface

The [v1 contract](interaction-contract.md) settles pairing, initial owner enrollment/recovery, the aircraft-hosted offline link, launch authority, fixed verification-zone approach, face/liveness result binding, deliberate speech windows, command-session lifetime and failure recovery. It keeps launch, owner command and independent manual authority distinct and binds every request to the current aircraft/configuration/boot/session.

First simulated slice: launch requested, request accepted/rejected, approach state, face result supplied by a test double, commands enabled/denied, and verification failure leading to a simulated return/landing. It must not pretend to perform real liveness or issue motor commands.

Still to validate rather than assume: actual iPhone signing/build behavior, locked/background EarPods control, local-link range/coexistence, physical verification geometry, real face/liveness security, onboard storage, flight-controller integration and safe recovery. Guest/recipient policies remain later-milestone design work.

The [September 9 product decision](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#2026-09-09-phone-and-onboard-direction-pc-product-retired) supersedes conflicting historical PC and biometric-before-arming requirements. Unrelated aircraft requirements, including payload and endurance/reserve, remain unchanged.
