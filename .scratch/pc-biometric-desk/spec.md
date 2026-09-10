# M1 PC biometric desk application

Continue new-product planning at the [phone/onboard entry point](../../docs/phone-drone/README.md). It separates the simulated phone slice from parallel aircraft feasibility.

## Current product scope: standalone PC app retired

The owner's later September 9 decision removes this Windows app from the finished product and supersedes the completion direction below. Existing implementation, tests and records remain development/reference material; unfinished PC-product tickets are no longer the delivery queue and are not declared accepted. The PC still supports simulation, engineering and testing. Preserve profiles and installed software; retirement is not deletion or uninstall authorization.

The replacement phone/controller and onboard face/liveness direction is recorded in [the controlling product decision](../biometric-guard-drone/issues/10-milestone-ladder.md#2026-09-09-phone-and-onboard-direction-pc-product-retired). Pairing, enrollment and the revised flight/command authorization contract remain under design. Sections below retain the former Windows-product specification and history.

## Approved completion direction — 2026-09-09

The owner requests completion of the PC application while hardware work is paused for a future change involving 3D printing. Preserve the existing owner-only, offline Windows scope and security requirements.

- Retain UI B and polish its workflows, feedback and accessibility.
- Permit evidence-led recognition-model or enrollment-recipe changes when evaluation justifies them. Preserve the existing profile until a tested, explicitly agreed migration or re-enrollment step; this is not capture or deletion consent.
- Finish implementation first, then run the real acceptance campaign. Implementation completion and empirical acceptance are separate milestones; the five-day usability and required security/state evidence below remain mandatory for final acceptance.
- Support both the PC microphone and headset/EarPods for everyday use, with explicit selection and qualification of each supported path. Device changes do not silently update enrollment.
- Include short, separately consented development capture checks when needed to diagnose recognition and validate changes; the later acceptance campaign remains separate. This planning choice is not consent for an immediate capture session.
- Include a protected local Windows helper service for recurring retry state and profile/recovery publication, subject to security testing. Administrator approval belongs to installation/update/removal; ordinary use stays unelevated. Start the helper when needed, expose no network endpoint and protect the installed verifier/runtime. An owner account identity or client-supplied success flag alone must not authorize a state transition.
- The owner authorizes a reviewed local Git checkpoint of current project work. This supersedes historical no-commit restrictions for that checkpoint; it does not authorize a push or change biometric-data handling.

The owner confirmed the assembled execution plan on September 9. The [review record](review.md#pc-completion-grilling--2026-09-09) records all six design decisions and the authorized implementation sequence. Formal acceptance remains a later phase.

## Approved Ticket 02 amendment — 2026-09-03

The user's completed grilling session supersedes conflicting enrollment UI details below.
Preserve UI B, the dependency graph, and the intact-host ownership protections.

- Recovery code: masked initially, eye reveal/hide button and Copy button. Successful
  clipboard copying is the required acknowledgement enabling Complete; no transcription
  challenge or automatic clipboard clearing. Explain clipboard/history exposure and that
  copying does not prove durable offline saving. Clear the app's code on exit/cancellation.
- Face: memory-only preview with subtle actual detector landmarks, no decorative scan or
  identity/liveness claim. Exactly one adequately sized, framed, sharp, lit, near-frontal
  face must remain stable for one second before automatic sampling. Failed quality checks
  reset sampling and show guidance; never bypass them. Landmarks disappear without a face.
- Voice: English only, three different displayed phrases in large persistent type, accepted
  only with matching words, usable speaker references and volume/clipping/noise checks.
  Measure background noise automatically, then enable a hold-to-record control for mouse or
  Spacebar; releasing stops the take. Show visualizer A (waveform, timer and concise status)
  from live transient audio rather than fabricated animation. After release, close the mic
  and offer memory-only playback, Submit or Record again. Submission must pause on a clear
  accepted/rejected result; a rejection retries only the current take and keeps earlier
  accepted takes. Discard the raw in-memory recording on submit, rerecord, cancel or close.
  Keep each recording within10 seconds, cancel a waiting screen after60 seconds of inactivity,
  and bound the complete enrollment session to five minutes. Do not silently learn during
  later logins.
- Test these changes at the existing public EnrollmentCapture.capture and DeskApp seams,
  using synthetic device/model/clock outputs and real local UI, without real capture.
  Thresholds are versioned development settings requiring later consented device calibration;
  quality acceptance does not establish identity, liveness or replay resistance.
- Preserve the current Windows boundaries; no speculative cross-platform refactor or iOS
  implementation. A future platform supplies its own ownership/storage/lifecycle semantics.
- Later verification must request a random displayed phrase and check words plus speaker
  evidence. Record this policy only: Ticket 03 implementation and attack validation remain
  outside this amendment. Drone live video remains M2.

Implementation approval covers docs, code, automated validation and review only. Stop before
new real camera/microphone/Windows/biometric validation. No commit or push is approved.

Status: ready-for-agent

Review status: **Approved — specification, test approach and eight-ticket breakdown explicitly accepted on 2026-08-30.** The user subsequently selects **B — Everyday workspace** as the current PC layout. Publication and UI selection are not passed acceptance tests or permission to collect biometrics or operate hardware.

Planning authority: Q69/Q70 in the [milestone-ladder decision record](../biometric-guard-drone/issues/10-milestone-ladder.md#comments), with the [accepted contract and remaining engineering obligations](../../docs/research/m1-acceptance-closure-review-2026-08-30.md). Prepared 2026-08-30. The user approved the narrow Git visibility exception, now applied to the specification, review sheet and issue Markdown. They are **eligible for Git tracking but uncommitted**; visibility is not a backup. Publication and UI/UX progress are recorded in the [review sheet](review.md).

## Problem Statement

The owner needs a usable offline Windows application that checks their face and voice before allowing one requested action, with defenses against the agreed impersonation, replay and substituted-input attacks. Recognition alone is insufficient: ownership, enrollment, stored references, recovery and interrupted operations must also obey the approved security rules.

The aircraft's complete cost, compatibility and endurance remain unresolved. Q70 authorizes independent PC software planning so these hardware decisions do not block this scope. This application must not imply that the full aircraft fits the $900 ceiling, is safe to fly, or has a validated onboard arming gate.

## Solution

Build one owner-only native-Windows desktop application. It guides deliberate first enrollment, performs a fresh face-and-voice check for a harmless desktop action, explains failures and temporary waits, and supports the approved profile-update and recovery paths. A successful normal request displays its own authorization result once; it never opens a reusable unlocked session or communicates with aircraft motors.

After installation of the selected application and models, normal operation is offline. Capture starts through a deliberate user workflow, not background surveillance. Normal raw images/audio are discarded after processing; encrypted faceprints/voiceprints and the minimum protected control state are retained. Separately consented security-test assets have a separate data plan.

The PC work is complete only when the accepted usability, security, storage and recovery evidence exists for an identified version/configuration. It is not complete merely because a face recognizer and a voice recognizer return matches. M1 as a whole still also requires its separately commissioned manual-flight/build acceptance.

## User Stories

1. As the owner, I want the application to run on my existing Windows PC, so that I can begin without assuming additional hardware purchases.
2. As the owner, I want installed operation to work offline, so that verification does not depend on a cloud service.
3. As the owner, I want readiness checks to identify missing models, unsupported devices or unavailable Windows verification, so that a problem is not mistaken for a secure working setup.
4. As the owner, I want explicit control over starting and stopping capture, so that the application does not record me incidentally.
5. As the owner, I want deliberate first enrollment protected by fresh Windows-account verification, so that the designated recovery account is bound intentionally.
6. As the owner, I want guided face and voice enrollment, so that I can establish both references without developer intervention during normal setup.
7. As the owner, I want normal first enrollment to finish within five minutes after installation, including saving my recovery code, so that setup has a clear usability target.
8. As the owner, I want incomplete enrollment to grant no action approval, so that partially collected evidence cannot establish working ownership.
9. As the owner, I want an offline recovery code and an explanation of losing it, so that I can preserve the recovery option knowingly.
10. As the owner, I want encrypted biometric references retained while ordinary raw images/audio are discarded, so that normal use does not create a recording archive.
11. As the owner, I want missing or damaged stored data to deny access rather than reopen new-owner setup, so that corruption cannot transfer ownership.
12. As the owner, I want every protected desktop action to require a fresh face and voice check, so that one successful request cannot authorize later requests.
13. As the owner, I want normal successful checks to complete within ten seconds including prompts, so that verification is practical.
14. As the owner, I want at least 95 of the initial 100 first attempts to succeed under the agreed ordinary conditions, so that acceptance reflects everyday use.
15. As the owner, I want failures and retries reported separately, so that eventual success cannot conceal poor first-attempt reliability.
16. As the owner, I want photographs and replayed video assessed as attacks rather than accepted as proof of a live face, so that facial similarity alone cannot authorize an action.
17. As the owner, I want recorded and generated/converted voice assessed as attacks, so that voice similarity alone cannot authorize an action.
18. As the owner, I want supported camera/microphone input-substitution routes tested, so that blocking physical replay is not mistaken for protecting every capture path.
19. As the owner, I want a temporary wait after repeated failures, so that retry controls preserve my profile rather than forcing enrollment again.
20. As the owner, I want reopening the application to preserve an active wait and failure streak, so that restart cannot bypass retry protection.
21. As the owner, I want a successful complete verification to reset the normal failure streak, so that the continuing-failure delay ends after success.
22. As the owner, I want an unfinished normal check to expire after sixty seconds, so that abandoned partial evidence cannot remain usable.
23. As the owner, I want cancellation, device loss and crashes to discard partial success while preserving enrollment, so that I can start a fresh check safely.
24. As the owner, I want duplicate requests, late results and account changes handled safely, so that concurrency cannot reuse someone else's or an obsolete approval.
25. As the owner, I want to update a biometric reference using my existing face, voice and fresh Windows verification, so that routine maintenance does not need the recovery code.
26. As the owner, I want a failed or interrupted update to preserve the last complete profile, so that an unfinished replacement does not destroy working enrollment.
27. As the owner, I want ordinary checks never to update my profile silently, so that enrollment changes remain deliberate.
28. As the owner, I want to replace a lost recovery code when both existing biometrics and fresh Windows verification succeed, so that I can restore recovery readiness without changing enrollment.
29. As the owner, I want lockout recovery to require my valid code plus fresh verification of the designated Windows account, so that neither alone is a recovery bypass.
30. As the owner, I want successful lockout recovery to replace the used code only when the new code is ready and saved, so that a preliminary failure does not consume my remaining recovery route.
31. As the owner, I want interrupted recovery to leave a consistent committed profile/code pair, so that a crash does not create ambiguous ownership or two usable generations.
32. As the owner, I want the application to explain that losing my code while either required biometric is unavailable leaves no recovery route in this version, so that I understand that consequence before setup.
33. As the owner, I want recovery and profile maintenance to grant no ordinary-action approval, so that changing credentials cannot double as authorization.
34. As a test participant, I want specific informed consent before any capture, recording or owner-targeted synthesis, so that planning approval is not treated as permission to collect my data.
35. As a test participant, I want retained test data, access and deletion dates disclosed separately, so that I can understand and withdraw from the planned use.
36. As the owner, I want evaluation results to distinguish development tests, real-device integration and actual attack testing, so that simulated successes are not security evidence.
37. As the owner, I want an unauthorized approval or missing required coverage to block sign-off, so that a favorable average cannot hide a security failure.
38. As the owner, I want a versioned local handoff with reproducible launch/test instructions and known limitations, so that I can use and maintain the accepted PC application.

## Implementation Decisions

### Scope and structure

- Use one desktop application and one authoritative workflow for enrollment, verification and identity maintenance. The UI must not independently decide authorization. Keep capture, Windows identity verification and protected storage as concrete integrations; introduce only boundaries needed to exercise their real failure modes.
- Use the selected **B — Everyday workspace** structure: persistent sidebar navigation, a central task surface and a small context/status panel. Keep diagnostics secondary. Guided enrollment and recovery occur within this direction; the A/B hybrid recommendation was not separately approved. The browser comparison remains throwaway, not the production application or an authorization implementation.
- No server, remote account system, plugin platform, general command bus, guest system or speculative drone transport is needed for this scope. Do not build an abstraction for future M2–M5 features.
- The checkout currently contains planning/research material and no application or test harness to reuse. The implementation language, UI toolkit, concrete model versions and storage mechanism are **not selected by the earlier approvals**. Select a minimal compatible stack during the readiness slice, documenting Windows integration, license/use terms, offline distribution and resource constraints before dependent implementation. Existing recognition research is a starting point, not proof of liveness or performance.
- Existing camera/IR/audio/GPU enumeration is only an inventory. Do not assume infrared access, trusted capture, acceleration or zero additional cost. Missing capability is an explicit feasibility result; no automatic purchase or cloud fallback.

### Protected action and normal requests

- Bind each normal request to exactly one harmless desktop result. Both fresh biometric results and the chosen anti-spoofing/input checks must satisfy the frozen policy before that result is authorized. Recheck the request and current state immediately before executing it.
- Approved scope simplification: execute the bound desktop result immediately on successful completion; retain no reusable completed-approval token. Cancellation, timeout, account change, state revision change or process restart invalidates pending results. A late callback cannot revive a request. This avoids inventing an additional user-facing authorization lifetime.
- Permit only one active verification or identity-changing operation at a time across application instances. Concurrent requests must not create free parallel guesses, mutate competing profiles or consume one recovery code twice. The actual coordination mechanism is an implementation detail to verify on Windows.
- A normal request expires sixty seconds after it starts; interaction does not extend the deadline. Normal success still has the separate ten-second acceptance limit. This timer does not govern enrollment or recovery.

### Retry controls

- Five consecutive failed complete requests trigger a thirty-second wait before each subsequent attempt until a complete successful normal check resets the streak. Reopening does not clear the wait or streak. No escalating delay, permanent-ban threshold or forced re-enrollment is adopted.
- Count a rejected full request, including one terminated after a failed channel, once—not each frame or utterance. The implementation must define the point at which a biometric comparison consumes an attempt and persist enough state to prevent cancellation/crash/restart from providing unlimited evaluations. Pre-capture device failure must remain distinguishable from a biometric rejection.
- Refusing a request during an existing wait must not itself perform identity comparisons or silently reset the deadline. Show a clear remaining wait without leaking biometric references or recovery secrets.
- Freeze and test counting, concurrent requests, sleep/restart, forward/backward clock changes, late results and damaged retry state before acceptance. Damaged state must not open authorization or unrestricted setup. A design that cannot preserve the fixed-delay and approved recovery behavior remains incomplete; it must not quietly add a permanent lockout or clear the protection.

### Ownership, storage and recovery

- Deliberate first setup requires successful fresh verification of the designated Windows account, not merely an unlocked desktop or a launched prompt. Bind later Windows-protected workflows to that same account and fail safely on cancellation, unavailability or account switching. Demonstrate this offline.
- Retain protected ownership/setup state distinct from the biometric payload so a missing/corrupt payload cannot be mistaken for first installation. Before the enrollment slice is accepted, demonstrate the actual trust/storage boundary and first-install versus damaged-state behavior. Do not promise protection against a compromised operating system or verifier.
- Retain encrypted references and integrity-protected state; use established platform/cryptographic facilities rather than custom cryptography. Keep secrets and biometric payloads out of source control, ordinary logs and result exports. Choose key handling, code generation/verifier storage and durable commits before accepting the affected slice.
- Routine profile update requires both existing biometrics and fresh owner Windows verification. Keep the last committed complete profile until the replacement has been validated and saved. Normal verification never adapts enrollment.
- Lost-code replacement requires both existing biometrics plus fresh owner Windows verification, leaves enrollment unchanged, and invalidates the old code on successful replacement, including across restart.
- Lockout recovery requires a valid offline code plus fresh designated-owner Windows verification. It does not require the failing drone biometrics, and never authorizes the ordinary desktop action. With no valid code and either required biometric unavailable, no recovery/Windows-only reset exists in this version.
- Successful lockout recovery commits a validated replacement profile, the new saved code's verifier and old-code invalidation together. Before this commit the old committed state remains authoritative; afterward only the new committed state is authoritative. Test interruption at each transition and concurrent reuse. Do not consume the old code on a preliminary attempt or create an indefinite old-code grace period.
- Recovery-code guessing requires separate bounded controls, chosen with code strength and the fresh-Windows prerequisite. Their mechanism is engineering work for the recovery slice; do not mistake the biometric cooldown for adequate protection or silently remove the approved recovery route. Material new user consequences require review.

### Data handling and evidence

- Ordinary raw captures are transient and discarded after processing. Encrypted enrolled references remain. Inspect the implemented temporary files, logs and crash behavior; do not claim forensic erasure of every operating-system or storage copy.
- No cloud upload, participant contact, capture, security recording or voice synthesis is authorized by this spec draft. Development may use non-biometric synthetic fixtures for control-flow tests; these do not validate recognition, liveness or injection resistance.
- Before real sessions, agree exact capture/attack tools, assets, participants, access and deletion dates, then obtain each affected person's consent. The research's thirty-day media and ninety-day detailed-metadata suggestions remain **unapproved** and must not become application defaults from this document.
- Record trial identifiers, relevant conditions, version/configuration identifiers, durations, outcomes and non-biometric failure notes. Do not record real names, raw media, templates or recovery secrets in the ordinary result ledger. Finalize its retention/export policy with the concrete evaluation plan.

## Testing Decisions

**Approved main test boundary:** exercise the application's public user workflows—enroll, request an action, cancel, update a profile, replace a code and recover—and assert visible results and committed state across restart. Test behavior rather than private functions or a chosen storage schema. No existing application tests are present.

Use deterministic control of external outcomes and time only to cover state transitions, unavailable devices, rejected Windows verification, concurrency and interruptions. Also run a small UI smoke path against the same workflow. Such tests cannot establish real biometric or Windows integration performance. Separate evidence must exercise the actual Windows account prompt, camera/microphone paths, selected models and storage on the target PC.

| Acceptance area | Required evidence |
| --- | --- |
| First enrollment | Complete guided normal setup within five minutes after installation, including Windows verification and saving the code; report failures, restarts and assistance separately |
| Owner usability | 100 fresh first attempts across five days, twenty per day in two sessions of ten; at least 95 authorizations; **every successful baseline trial within ten seconds** including prompts |
| Evaluation integrity | Freeze profile, versions, thresholds, prompts and ordinary indoor conditions before evaluation; no tuning on final trials or replacing failures with successful retries; show all exclusions and their predeclared reasons |
| Retry/timeout | Five-failure threshold, thirty seconds before each continuing retry, success reset, preserved protection across restart; sixty-second absolute unfinished-request expiry; no partial/replayed authorization |
| Identity lifecycle | Account binding, setup protection, ordinary update, lost-code replacement and lockout recovery; wrong/canceled/unavailable Windows verification, concurrent requests, missing/tampered state and interruption at commit boundaries |
| Confidentiality | Encrypted references, protected state and code verifiers; no ordinary raw-capture or secret history; temporary-file/log/crash checks within the intact-host claim |
| Live nonowners | The agreed three consenting adults, actual full-gate attempts and documented convenience-sample limitations; participation is not guest enrollment |
| Physical spoofs | Owner-targeted photographs/video and recorded/generated or converted voice, with meaningful varied sources and working positive controls |
| Substituted input | Actual supported camera-only, microphone-only and paired substitution paths; component-only file tests cannot replace application-path evidence |
| Channel isolation | Attack one channel while the owner supplies the other genuine channel, plus applicable combined attacks; report channel and full-gate outcomes distinctly |
| Acceptance stopping rule | Any unauthorized approval blocks sign-off until fixed and retested; missing required coverage, consent, tools or state evidence is incomplete, never a pass |
| Handoff | Versioned supported setup, reproducible offline launch/check instructions, evaluation record and visible limitations; no claim of aircraft approval |

A slow success remains a reliability success but fails timing. A fast rejection is not a success. Report rejection/timeout/retry durations separately. The accepted observed 95/100 does not prove a true future success probability of at least 95%; clustered sessions are not automatically independent. Zero unauthorized approvals in a finite matrix does not prove zero risk.

The earlier ninety-negative-attempt allocation remains an exploratory starting point. Review realistic coverage against the implemented challenges before final evaluation; do not use the quota as a security certificate. After a fix, retain regression evidence and use fresh held-out material/sessions for confirmation. A failed attack path or application rejecting everyone cannot count as protection.

## Out of Scope

- Aircraft communication, motor arming, flight control, commissioning and operational flight tests. The future biometric arming policy and independent emergency landing path remain unchanged.
- iPhone implementation, background voice sessions, onboard compute integration, follow/orbit/watch/patrol, avoidance, night equipment, guest access and delivery implementation. These remain required in their approved later milestones, including recipient verification.
- WSL/ROS installation, cloud-dependent operation, web accounts, telemetry services or an additional purchasing budget.
- Claims of operating-system/verifier compromise resistance, universal spoof detection, certification, guaranteed safe flight or proven whole-project affordability.
- Hardware shopping-list resolution or marking issue 10/M1 complete based on this PC effort.

## Further Notes

Q70 authorizes this planning scope independently of ticket 10. The complete $800–$900 budget range and $900 maximum still cover all initial M1–M5 requirements; no paid dependency, extra capture device, recurring fee or hidden integration cost is approved here. Surface costs and failed feasibility rather than weakening security silently.

The approved aircraft acceptance structure remains simulator preparation, separate build/commissioning, then three consecutive full qualifying runs across at least two sessions, with numerical criteria fixed before real evaluation. Those are tracked with the aircraft work, not tickets in this software effort.

The [review sheet](review.md) indexes the eight approved and published end-to-end tickets. Their dependencies and the narrow Git visibility change are approved. This specification does not claim that unresolved model, storage or operating-system mechanisms have already been chosen or validated.

The user identified the missing visual/interaction design after approving the functional specification. A throwaway UI comparison will explore the existing workflows before a production layout is selected. Its simulated data must not be mistaken for actual enrollment, Windows verification, camera/microphone access or security results. No PC layout choice adds or removes the later phone scope.
