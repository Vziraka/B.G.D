# PC biometric software — specification and ticket review

Continue new-product planning at the [phone/onboard entry point](../../docs/phone-drone/README.md). It separates the simulated phone slice from parallel aircraft feasibility.

**Current product status, September 9:** the owner has retired the standalone Windows app from the finished product, superseding the earlier completion direction below. Preserve this implementation, its tests and evidence for development/reference use. Its unfinished product acceptance is not a delivery requirement or a claimed pass. PC simulation and engineering continue to have a role. See the [latest product decision](../biometric-guard-drone/issues/10-milestone-ladder.md#2026-09-09-phone-and-onboard-direction-pc-product-retired). The remaining content records the former app and its development history.

## Voice failure follow-up — 2026-09-06

The latest pasted diagnostic report isolates speaker matching as the failed stage: face,
audio quality and exact words passed, and the speaker vector covered the complete take.
Dev-3 corrects a separately reproduced early Recording indication and adds a bounded,
explicitly consented, memory-only three-sample consistency study. The study cannot authorize
actions or update enrollment; ordinary thresholds and models remain unchanged. See the
[current boundary](../../docs/pc-biometric/verification-boundary.md#recording-readiness-and-voice-consistency-study--2026-09-06).
Real study measurements and a demonstrated speaker-recognition fix remain pending.

## Diagnostic evaluation implementation — 2026-09-06

The user's “Ok then Start it” authorizes the first slice of the proposed evaluation.
Opt-in, memory-only diagnostics now separate face/voice identity scores from capture
quality, device selection, speaker-segment support and timing. Verification resolves the
default microphone once and binds both room measurement and recording to that endpoint.
Model/threshold/reference recipes remain unchanged; no profile reset or adaptation occurs.
See the [diagnostic boundary](../../docs/pc-biometric/verification-boundary.md#opt-in-capture-and-identity-diagnostics--2026-09-06).
Real-device diagnostics still require a deliberate in-app-consented check. Ticket03 remains
unresolved; no successful real verification or improved recognition rate is claimed.

## Capture/model evaluation requested — 2026-09-06

After the dev-2 quality correction, the user reports completing both capture stages but
still receiving an overall rejection. Per-channel identity results are unknown. The user
directs evaluation of capture/detection quality rather than forcing a pass. Live trials
are paused and the app closed normally. The [capture assessment](../../docs/research/pc-biometric-capture-assessment-2026-09-06.md)
and [primary-source model review](../../docs/research/pc-biometric-model-evaluation-2026-09-06.md)
are proposed next work, not authorization to swap models, adjust thresholds or reenroll.
Ticket03 remains unresolved; approved timing, reliability and attack requirements remain.

## Ticket03 development verification ready — 2026-09-06

[Ticket03](issues/03-single-action-verification.md) now implements one fresh face and random
spoken-challenge check bound to one desktop receipt and the current protected identity state.
UI B exposes deliberate consent, capture controls, cancellation and elapsed timing. The
[boundary and development policy](../../docs/pc-biometric/verification-boundary.md) distinguish
implementation from pending real-device and attack evidence. Default launch blocks capture.

Validation: **108/108 automated tests**, strict mypy2.3.1 across13 source modules,
successful compilation and scoped whitespace inspection, including untracked changed files.
Twelve new tests include synthetic capture through actual Tk controls and isolated HKCU/DPAPI
fixtures. No real biometric capture, production-profile read/change, hardware action, commit
or push occurred. Ticket03 is ready-for-human and unresolved pending a separately consented
device session; Tickets04/07 retain retry and spoof/input defenses.

## Fresh-process reopen and final cleanup passed — 2026-09-05

With separate immediate approval, the normal application reopened unelevated with diagnostics
disabled. The participant confirmed the Setup surface recognized an existing owner and kept
`Set up owner` disabled; camera, microphone and Windows verification remained inactive. The
app closed normally with exit0. The disabled Verify action is the expected Ticket03 boundary,
not a Ticket02 verification implementation.

Final read-only inspection again loads the encrypted profile and confirms protected authority/
current-account agreement, one non-plain-JSON ciphertext payload, zero raw-media and pending
artifacts, no diagnostic trace, no active B.G.D. process and no validation firewall rule. The
2027-01-01 deletion task remains Ready. The successful traced enrollment plus fresh-process
reopen did not reproduce the historical inconsistency. Final Standards/Spec review supports
closing it as unreproduced after bounded investigation without asserting a historical root
cause; recurrence reopens it. Ticket02 is resolved. Actual switching to a different Windows
account remains an explicitly accepted unvalidated limitation, never a passing claim.

## Complete timed offline enrollment passed — 2026-09-05

With immediate approval, an exact outbound block was applied only to the pinned B.G.D.
Python executable and verified across all firewall profiles. The normal application ran
unelevated with temporary secret-free storage tracing enabled. Windows verification, real
face capture, real voice capture, recovery-code Copy/save acknowledgement and protected
publication completed. Conservative process wall time including launch and close was
**222.144 seconds**, below the five-minute enrollment limit. The temporary firewall rule
was removed and verified absent immediately afterward.

Read-only checks show the authority committed to the current Windows account and a matching
encrypted profile loads through the public store. Exactly one ciphertext profile exists and
is not plain JSON; there are zero raw-media and zero pending artifacts. The14-record trace
uses only the fixed secret-free schema, includes every required successful reservation and
publication transition and contains zero failure records. The historical storage inconsistency
did not reproduce. Actual normal-app reopen and final diagnostic cleanup remain separate.

## Approved production reset completed — 2026-09-05

Immediately before the destructive action, the user approved permanent removal of the
current encrypted profile and recovery generation plus replacement of the committed HKLM
authority with a fresh uncommitted authority. The first elevated attempt changed nothing.
The second removed the profile, then PowerShell's registry provider was denied deleting the
protected key; the committed authority kept setup closed. A reviewed retry used Python's
native64-bit registry API already exercised by the machine tests, removed the old authority
and installed a new protected uncommitted authority.

Final read-only verification reports the profile absent, authority readable with empty
profile/digest, deletion task Ready and the normal process unelevated. The one-time reset
script and sanitized transition log were removed after verification. No camera, microphone,
network or firewall change occurred during reset.

## Real microphone interruption cleanup — 2026-09-05

A separately consented voice-only run was closed while recording was active. The harness
observed microphone-stage entry and a responsive waveform with no camera-stage entry, then
returned the expected `cancelled_or_timeout` category well before its timeout. No prompt was
accepted. The capture child, wrapper and UI stopped cleanly; protected/profile/diagnostic
state was unchanged and no raw-media file was created. This supplies real disposable-worker
cleanup evidence without changing the enrolled owner.

Read-only Windows inventory then found no scheduled task, startup command or Codex automation
implementing the agreed 2027-01-01 encrypted-profile deletion. The earlier active-task claim
is corrected in the evidence record. With immediate approval, the current-user limited task
`BGD.PCBiometricDesk.DeleteEncryptedProfile` was then registered for midnight on 2027-01-01
with StartWhenAvailable. A guarded pre-date run returned success while preserving the profile
and models; inspection confirms its action targets only the profile directory. HKLM authority
is outside that target, so scheduled deletion cannot reopen enrollment.

## Complete real voice-control evidence — 2026-09-05

With fresh participant consent, the voice-only harness passed under the revised timing
policy. It entered the microphone stage and never entered the camera stage, displayed a
responsive waveform, provided memory-only playback, and collected all three prompted and
accepted English takes. A deliberately unusable submitted take was rejected with persistent
`too_quiet` guidance. The participant confirmed both waveform response and playback.

The child, wrapper and UI all stopped cleanly. Protected authority/profile/diagnostic state
was unchanged and no raw-media file was created. The voice-only run completed before the
five-minute bound; it is not the still-required complete timed enrollment. The original
storage incident remains open and unreproduced.

## Deliberate voice controls and latest real evidence — 2026-09-05

The user approved replacing the automatic voice-take pacing with a large persistent
phrase and deliberate hold-to-record flow. Automatic background measurement must finish
before mouse/Spacebar recording is available. Release stops the take; the microphone is
closed while Play back, Submit and Record again are offered. Accepted and rejected states
wait for Continue or Try again, and a clear rejection reason remains visible. Raw recorded
audio stays in the disposable process and is wiped on submit/rerecord; cancellation or
closure terminates that process. The existing three-English-phrase, quality, exact-word,
three-attempt and10-second-recording bounds remain authoritative. Waiting screens cancel
after60 seconds of inactivity and the complete enrollment session is bounded to five minutes.

Two real runs of the revised controls each accepted take one and reached take two before
the former90-second voice deadline expired. The second proved a submitted rejection with
persistent `too_quiet` guidance, live waveform, memory-only playback and both participant
confirmations. Camera access stayed off; storage remained unchanged; no raw media appeared;
child, wrapper and UI cleanup passed. Three accepted takes remain unvalidated.

The user approved replacing that rushed voice deadline with the existing five-minute full
enrollment limit,60-second inactivity cancellation at each waiting screen,10 seconds per
recording and three attempts per phrase. The five-minute timer begins at enrollment Start,
cancels Windows/capture/code waiting fail closed, clears a displayed recovery code, and
stops before the indivisible protected publication begins.

Current device-free validation: **96/96 automated tests pass**; strict mypy2.3.1
passes all12 source modules; compilation and scoped whitespace checks pass. A read-only
production check reports committed authority, a readable profile, tracing disabled,
no trace file and zero raw-media files in the profile/diagnostics trees.
Final independent Standards and Spec reviews each report zero actionable findings.

## Temporary storage diagnosis instrumentation — 2026-09-04

Ticket02 now has disabled-by-default, secret-free JSON-lines checkpoints for the next
approved validation attempt. Focused tests prove behavior neutrality, fixed schema,
sanitized failure and fail-closed behavior. After the account-switch harness was
prepared and then superseded by the face-only harness, full suite83/83 and strict
typing12 modules pass;
the separate reader-race suite passes1,000 iterations. Production trace remains off
and the existing enrollment/authority remain unchanged. The original index incident
stays open. Independent Standards and Spec rechecks each report zero actionable
findings. No interactive validation, reset, Ticket03, commit or push occurred.

## Latest diagnosis evidence — 2026-09-03

Ticket02 remains incomplete. [Storage diagnosis](../../docs/pc-biometric/storage-incident-diagnosis.md)
fixed a separately reproduced pre-publication reader/replacement race; it does not
explain the original post-publication index incident. Both required review axes
report zero actionable findings. Final suite75/75, strict typing12 modules and
1,000 stress iterations pass. Actual workstation-lock cancellation with synthetic
capture passed, without a committed fixture and with successful cleanup. Production
state stayed unchanged. Account switching, amended real-device capture and timing
remain open; no reset, new biometrics, firewall change, Ticket03, commit or push.

## Latest approved amendment — 2026-09-03

The user approved the completed enrollment UX grilling agreement in the existing
[spec amendment](spec.md#approved-ticket-02-amendment--2026-09-03) and Ticket02.
Selected audio visualizer A (waveform/status) within UI B; actual landmark dots;
automatic face quality gating; three English prompted takes; masked/eye/copy recovery
code with successful copying required for completion and no clipboard auto-clear.
Preserve Windows boundaries without an iOS refactor. Later random-phrase verification
is specification-only; Ticket03 is not started. Real-validation consent remains separate.
The ignored audio prototype remains a local primary source; no commit is authorized.
Earlier progress entries below are historical, not current acceptance claims.

Amendment result:72/72 automated tests, strict mypy across12 modules, compilation
and scoped whitespace checks pass. Standards:0 remaining findings. Spec:0 remaining
findings. Real calibration/validation and the prior index incident remain open;
Ticket02 stays ready-for-human. No real devices, firewall changes, profile mutation,
Ticket03 implementation, staging, commit or push occurred in this amendment.

Prepared 2026-08-30 after Q69/Q70 approval. **The specification, test approach, ticket sizes/dependencies and exact Git visibility exception are now explicitly approved.** Eight individual implementation tickets are published below; their acceptance checkboxes are not completed. The [specification](spec.md) is the approved functional scope. The [aircraft decision issue](../biometric-guard-drone/issues/10-milestone-ladder.md#comments) stays claimed for hardware/full-budget feasibility.

The user also identified the missing UI/UX discussion and asked whether the phone feature remains. UI layout/interaction proposals are the next activity; the phone remains an approved later M2 capability, not part of these PC tickets. No capture, device installation, purchase, staging or commit has occurred.

## Published tickets

| Ticket | Blocked by |
| --- | --- |
| [01 — Offline app launch and readiness](issues/01-offline-launch-readiness.md) | None |
| [02 — Safe owner enrollment and protected storage](issues/02-owner-enrollment-storage.md) | 01 |
| [03 — Fresh verification for one desktop action](issues/03-single-action-verification.md) | 02 |
| [04 — Retry, cancellation and restart protection](issues/04-retry-interruption-protection.md) | 03 |
| [05 — Profile maintenance and lost-code replacement](issues/05-profile-maintenance.md) | 03 |
| [06 — Lockout recovery and durable code rotation](issues/06-lockout-recovery.md) | 02 |
| [07 — Replay and substituted-input hardening](issues/07-spoof-input-hardening.md) | 04 |
| [08 — Acceptance evaluation and local handoff](issues/08-acceptance-handoff.md) | 05, 06, 07 |

## Approved test boundary

Test the app through the same public workflows the owner uses, checking authorization results and saved state across restarts. Use controlled time/device/Windows outcomes for repeatable failure tests, then separately validate the real Windows prompt, camera, microphone and biometric attack paths. Simulated checks never count as biometric security evidence. Keep the UI thin; avoid a separate policy implementation inside the UI.

Use immediate execution of one bound harmless desktop result on full success; do not build a reusable approval-token service or drone connection for this phase. The application remains an unaccepted development build until all PC acceptance gates pass.

## Approved implementation breakdown

These are end-to-end slices: each includes its visible workflow, required state/integrations and meaningful verification. They are not separate UI/database/model layers. The numbering is local to this new effort, not a continuation of the ten aircraft planning issues. The individual files above are the published work items; this explanation preserves the reviewed breakdown.

1. **Offline app launch and readiness**
   - **Blocked by:** none within the approved software effort.
   - **Delivers:** a runnable Windows app showing whether required local models, device interfaces and Windows verification support are ready, missing or unverified, without starting capture automatically.
   - **Completion:** select and record the minimal implementation stack and exact initial model/license assumptions; document offline installation/launch; prove missing dependencies cannot display a ready or authorized result. No paid dependency or extra hardware is assumed. This is readiness, not successful biometric validation.

2. **Safe owner enrollment and protected storage**
   - **Blocked by:** 1.
   - **Delivers:** deliberate first setup with fresh designated-owner Windows verification, consented face/voice enrollment, encrypted references and an offline recovery code saved before completion.
   - **Completion:** first-setup versus damaged-state handling, account switching, interrupted setup, coordinated identity-state writes and secret/log hygiene are exercised. Partial setup grants no ordinary action. Demonstrate the ownership/storage trust boundary rather than assuming a deleted profile means new installation. Real capture waits for consent; fixtures only test state behavior.

3. **Fresh face-and-voice verification for one desktop action**
   - **Blocked by:** 2.
   - **Delivers:** one requested harmless action evaluated using fresh inputs from both channels; full success produces only that request's result, without an unlocked session.
   - **Completion:** integrate the initial selected verification/challenge path and real capture interfaces, request binding and immediate result execution; reject missing/failed/obsolete evidence and replayed results. Record the security limitations of this development slice; the full anti-spoofing and acceptance work below remains mandatory.

4. **Retry, cancellation and restart protection**
   - **Blocked by:** 3.
   - **Delivers:** the approved five-failure/thirty-second continuing-retry behavior and sixty-second unfinished-check expiry, with understandable waiting/cancellation/device-loss outcomes.
   - **Completion:** evaluate exact counting, active-operation coordination, late results, sleep, clocks, restart and damaged state. Neither concurrency nor a crash permits unlimited comparisons. Enrollment survives ordinary interrupted verification; no new permanent-ban or re-enrollment rule appears.

5. **Profile maintenance and lost-code replacement**
   - **Blocked by:** 3.
   - **Delivers:** guided reference updates and lost-code replacement using existing face, voice and fresh owner Windows verification.
   - **Completion:** failed/interrupted updates preserve the last committed complete profile; ordinary checks never learn silently. Lost-code replacement leaves enrollment unchanged and invalidates the old code durably. Neither maintenance flow authorizes an ordinary action.

6. **Lockout recovery and durable code rotation**
   - **Blocked by:** 2.
   - **Delivers:** guided recovery with valid code plus fresh designated-owner Windows verification, replacing enrollment and the used code only on successful completion with the new code saved.
   - **Completion:** implement reviewed code-generation/storage/guessing controls and consistent profile/code commits; cover interruptions, concurrent reuse, invalid codes and wrong/unavailable Windows verification. Preserve the approved combined-loss limitation; no direct action or Windows-only reset. This can be developed independently of normal verification once enrollment/storage exists.

7. **Replay and substituted-input hardening**
   - **Blocked by:** 4.
   - **Delivers:** the ordinary verification workflow hardened against the agreed face-photo/video, recorded/generated voice and actual capture-substitution threats.
   - **Completion:** integrate and challenge the selected defenses through real supported input paths, with positive controls, isolated-channel and combined attacks. Use only consented local material under an agreed data plan. Missing tools/coverage or an unauthorized approval block this slice; recognition-only success or rejecting all users does not satisfy it.

8. **Acceptance evaluation and local handoff**
   - **Blocked by:** 5, 6 and 7; their dependencies include the earlier slices.
   - **Delivers:** a versioned integrated PC build, frozen evaluation protocol, consented real-device usability/security/state results, and reproducible local usage/maintenance instructions.
   - **Completion:** meet Q69's observed 95/100, every-success-within-ten-seconds and separate enrollment target; verify all identity/retry/recovery/storage paths and required attack coverage on the integrated version. Failure means fix/retest or incomplete, not waived acceptance. Do not label incomplete development artifacts accepted. PC sign-off does not close the aircraft issue or M1 as a whole.

Tickets 5 and 6 need not wait for attack hardening; ticket 6 needs enrollment/storage but not the normal face/voice path. The final evaluation integrates all branches, including interaction between maintenance, recovery and retry controls. This is a dependency graph, not a promise of concurrent staffing or a schedule. Each slice must be small enough for a fresh implementation context; split a discovered oversized slice for review rather than silently increasing scope.

## Applied narrow Git visibility exception

The user explicitly approved the following exact addition under the [tracker rule](../../docs/agents/issue-tracker.md), and it has been applied. It exposes only this specification, this review sheet and individual issue Markdown; every other file under this effort remains ignored, including the throwaway UI prototype:

```gitignore
!/.scratch/pc-biometric-desk/
/.scratch/pc-biometric-desk/*
!/.scratch/pc-biometric-desk/spec.md
!/.scratch/pc-biometric-desk/review.md
!/.scratch/pc-biometric-desk/issues/
/.scratch/pc-biometric-desk/issues/*
!/.scratch/pc-biometric-desk/issues/*.md
```

This does not stage or commit anything. Biometric media, templates, secrets and runtime state must never be saved in these planning Markdown files. Keeping them out of these paths is an implementation requirement, not a guarantee that an ignore rule can recognize sensitive content.

## Original review request — approved

Approve the proposed test boundary and eight-slice breakdown, or identify a specific slice to merge/split or dependency to change. Also approve the exact narrow visibility addition above if these planning files should be eligible for Git tracking. The `to-spec` workflow requires the test-boundary review; `to-tickets` requires approval of granularity and blockers before publishing tickets; the tracker separately requires this visibility approval. These are reviews of new artifacts, not repeat permission for Q69/Q70.

After approval, apply only the approved visibility change, finalize the specification and publish one implementation issue per approved slice with explicit blocking edges. No commit, capture, participant contact, purchase, aircraft operation or M1 completion is part of this review.

## Approval and publication record — 2026-08-30

The user approves the specification and explicitly states: **"Yes, I approve the test approach, ticket breakdown, sizes and dependencies, and the narrow Git-tracking exception. Continue to the next step."** That approval has been executed: the specification is `ready-for-agent`, the eight separate issue files have the approved blocking edges, and the exact visibility exception above is applied. No files have been staged or committed. No implementation ticket is marked complete.

The user's accompanying observation that UI/UX had not been discussed is treated as steering the next design activity, not revoking the functional specification. The UI comparison below is a concrete proposal; it neither adds implementation tickets nor changes the approved dependencies. No UI direction is inferred to be approved yet.

## UI/UX design review

**Question:** Which structure should the Windows PC app use for its everyday verification and occasional setup/recovery workflows?

[Open the local interactive comparison](http://127.0.0.1:8765/ui-prototype.html?variant=B), or open the [standalone prototype file](ui-prototype.html). A localhost server is running for review; if it stops, the single HTML file can also be opened directly. To restart the preview from the repository root: `python -m http.server 8765 --bind 127.0.0.1 --directory .scratch/pc-biometric-desk`. The server is bound to loopback, not published publicly.

| Direction | Structure | Tradeoff |
| --- | --- | --- |
| A — Guided focus | Centered task, small horizontal navigation, one clear next step | Least visual distraction; less readiness/context information alongside the task |
| B — Everyday workspace | Persistent sidebar, central task, small context/status panel | Easy return to account/recovery and visible system context; more screen space devoted to navigation |
| C — Instrument panel | Operation chooser, workflow column and visible diagnostic state | Useful development visibility; denser and less approachable for routine use |

**Selection — 2026-08-30:** the user says **"its fine for now lets do B"**. Use **B — Everyday workspace** as the current PC UI direction: persistent sidebar, central task and a small context/status panel. The user selected B, not an explicitly approved A/B hybrid. Guided enrollment/recovery remain required workflows, but do not silently substitute A's separate layout. "For now" leaves later visual refinement possible without reopening the accepted functional scope.

The floating bar and `?variant=A|B|C` select layouts; left/right arrows cycle when not editing a field. Setup, Verify, Account and Recovery navigate **fictional example states**. The success, rejection, wait, device-loss and timeout controls preview copy/state appearance, not a functioning verifier or accurate timing model. The thirty-second wait is intentionally frozen, not an actual throttle. Reload/reset clears all in-memory preview state.

### Workflow and accessibility treatment to carry into implementation

- First launch should distinguish missing prerequisites, deliberate first enrollment and an existing owner profile. The prototype exposes every screen for comparison; production navigation must never reopen new-owner setup merely because profile data is missing or corrupt.
- Explain camera/microphone use before starting it, show when a real request is active, and provide a clear cancellation path. An idle preview must not imply that capture has already started.
- Use the real Windows account-verification surface when integrated; do not build a look-alike Windows credential form. This prototype opens no Windows prompt and accepts no credential text.
- Show a successful result as authorization of that one request. Do not use an ambiguous permanent "unlocked" state, and do not show unvalidated biometric confidence or security scores.
- Explain waits and errors in plain language: whether the profile is preserved, why another attempt cannot start, and what the owner can do next. Unavailable-device, failed-verification and expired-request states are different outcomes.
- Keep routine profile changes, lost-code replacement and code-assisted lockout recovery distinct. Explain irreversible code invalidation and the combined-loss limitation before real completion.
- Preserve keyboard operation, visible focus, text labels and readable contrast; do not convey success/failure through colour alone. The prototype is not a full accessibility audit; production focus management and screen-reader behavior need implementation checks.
- Keep diagnostic detail secondary in the everyday view. No secrets, raw biometrics or identifying debug history belong in that panel.

### Prototype verification and preservation

Browser checks covered all three layouts, simulated verification start/success, setup progression to code saving/completion, recovery's unavailable-prerequisite explanation, account navigation and the disabled retry/waiting state. These checks verify a clickable visual proposal only; they do not pass any biometric, Windows-integration, timing or aircraft acceptance test. No new test framework was installed.

The prototype is one self-contained HTML file with inline CSS/JavaScript, no third-party assets, no capture APIs and no storage or backend. It remains **Git-ignored** under the exact approved exception; SHA-256 at review: `73CCCDFE09454FC31F74E019D98697AF9DE90F88FA9284AC4E70E2F34939F5BD`. B is now selected. No prototype code has been promoted into production and no throwaway-branch commit has been made. Preserve the original comparison as a local primary source; the shared workflow requires separate commit authorization, so do not discard it or broaden tracking. Production implementation must use real readiness states, not the prototype's simulated authorization controls.

## Phone scope clarification

**Still planned:** M2 retains the existing iPhone direction, offline voice commands, deliberately activated locked/pocketed voice sessions, and live inspection/framing video plus battery/status. The phone does not replace onboard face verification/computation or the independent emergency radio. First live video is not a manual-piloting display. No new confirmation is needed merely to keep these already approved features.

**Still needs later design/feasibility:** native versus offline-capable web implementation; exact activation/stopping and interruption behavior; command confirmation/authorization feedback; phone screen/navigation; local communication/video performance; build/signing workflow without an available Mac; and complete integration/recurring costs. Those are unresolved M2 details, not reasons to remove the phone or add it to the current PC tickets. Requirements and costs remain inside the full-project planning scope; the $900 hardware/full-build fit is still not established.

This answer follows the existing Q45–Q52/Q59 decisions indexed in the [project map](../biometric-guard-drone/map.md) and [phone feasibility report](../../docs/research/iphone-handheld-feasibility.md). No fresh claim of working iPhone background capture, phone installation or paid platform selection is made here.

## Current implementation status — 2026-09-05

This table supersedes the earlier dated implementation status statements; the approved
specification, UI B selection, eight scopes and dependency graph are unchanged.

| Ticket | Current result |
| --- | --- |
| 01 | **Resolved:** native Windows UI B readiness, exact initial stack/source pins, offline launch, six initial workflow/UI checks and independent review. No capture or authorization |
| 02 | **Resolved:** 96/96 tests and strict typing pass; protected deletion/rollback boundary, real face/voice/interruption, 222.144-second offline enrollment, fresh-process reopen and cleanup validated. Actual second-account switching is an accepted unvalidated limitation; biometric security remains later scope. See [evidence](../../docs/pc-biometric/enrollment-boundary.md) |
| 03, 06 | Not started; unblocked by resolved 02 |
| 04, 05 | Not started; blocked by 03 |
| 07 | Not started; blocked by 04 |
| 08 | Not started; blocked by 05/06/07; no usability/security acceptance sessions |

Launch with `python -m pc_biometric` from the repository root. [Usage/stack](../../docs/pc-biometric/README.md)
describes local prerequisites and limitations. The prototype is unchanged and unused
by production. Ticket03 has not started; no ordinary verification capability is claimed.

### Historical 2026-08-30 validation record (superseded)

At that earlier boundary, validation had18 passing development checks and two explicitly expected failing security
assertions; strict mypy passes six modules. Native UI B and keyboard smoke checks
passed, with screen-reader accessibility unvalidated. The earlier global whitespace
check exposed an existing unrelated `Project Idea.md` warning; scoped new-file
`git diff --no-index --check` checks pass. No existing unrelated file was reformatted.

Required review ran independent Standards and Spec agents against the task-start
commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`, including scoped new untracked
files using `git diff --no-index -- NUL <file>`. No commit-range diff exists because
the shared workflow requires separate commit authorization. Findings and fixes are
recorded in each ticket and the enrollment evidence. The storage-authority gap was an
acceptance blocker at that boundary; the current resolution above supersedes it.

Work remains uncommitted. Changes to the hardware map, hardware issue 10, research
index and glossary observed during this run belong to concurrent work and were
not edited or reverted here. No hardware planning, aircraft operation, cleanup of
other worktrees, staging, commit or push was performed.

### Ticket-02-only continuation — 2026-08-30

User scope is now **finish 02, then stop**, regardless of later dependency readiness.
Ticket 02 gained a desktop HWND verification bridge and native SID reader, tested
through enrollment with controlled Windows COM outcomes, plus account-unavailable
handling. A read-only Windows availability/interface probe succeeded without
authentication. Current checks: 26 passes, the same two expected ownership-security
failures, and strict typing across seven modules. Earlier counts are historical.
The installation-authority decision and actual integration/session evidence are
still missing, so ticket 02 remains incomplete and production enrollment disabled.
See [updated evidence](../../docs/pc-biometric/enrollment-boundary.md#resumed-ticket-02-only-work--2026-08-30).

Continuation review: Standards has zero findings after recheck. Spec identified
a shared-event cancellation bypass at code saving, now fixed with two additional
regressions; no further scoped defect on recheck. Acceptance remains blocked by
the ownership authority and real integration evidence. No approval to change
Windows permissions, collect biometrics, commit or advance later tickets is inferred.

### Protected authority continuation — 2026-08-31

This entry supersedes the historical ticket-02 status/counts above. The user now
explicitly permits administrator installation/setup for protected ownership,
requires normal unelevated use and limits work to ticket 02. A service is not
required by the implemented design. The authority, one-shot metadata publisher,
installation checks and helper-lifetime coordination are implemented and reviewed.

**44 non-biometric development tests pass**, with no expected failures/skips;
strict mypy passes 11 modules. The original deletion/rollback tests pass with a
separate HKCU fixture authority. Both review axes found no remaining actionable
defect in their final focused rechecks; Standards independently ran the full suite.
Successful production HKLM permissions/publication remain **unvalidated**: UAC
canceled the attempted administrator launch. The three explicit machine tests
and a reviewable runner are prepared, not passed.

Ticket 02 is `ready-for-human` for that OS-consent action and remains incomplete.
Guided capture/model/session/UI integration and real Windows/biometric/timing
evidence are still missing; real validation requires a separate user go-ahead.
See [current evidence](../../docs/pc-biometric/enrollment-boundary.md#current-boundary--2026-08-31).
Production enrollment remains disabled. Tickets 03–08, hardware issue 10 and
other agents' work are untouched. No commit or push.

### Approved non-biometric UAC validation — 2026-08-31

This entry supersedes the canceled-UAC blocker above. On the user's approved
retry, fixture failures were diagnosed and corrected without relaxing application
permissions: use the live normal coordinator's primary token and create user data
under it, rather than assuming a linked token is usable for impersonation.

**Three native machine tests passed**, covering protected HKLM access, publication,
installation replacement, reinstall preservation and deletion/rollback rejection.
**One additional actual UAC handoff test passed** from an unelevated process using
the application's publisher, synthetic references and controlled verification.
It asserts the caller stays unelevated and removes its unique test authority after
the temporary administrator fixture exits. Final normal suite: **44/44 passes**;
strict mypy: **11 modules pass**. Standards and Spec each report **zero new
actionable findings** on the corrections and added native test.

Ticket 02 remains incomplete, production enrollment disabled and `ready-for-human`
at the separately requested real-validation consent boundary. Guided UI B,
capture/model adapters and session interruption remain unfinished; full acceptance
is not claimed. No real authentication or biometric capture occurred, no production
authority was installed and no production permission changed. The
[current evidence](../../docs/pc-biometric/enrollment-boundary.md#current-boundary--2026-08-31)
records commands, observed results and limits. No Ticket 03, hardware work, staging,
commit or push.

### Consented Windows dialog integration — 2026-08-31

The user separately approved the real Windows account-verification test. The
existing native adapter returned Verified in **5.879 seconds** during the success
attempt, with unchanged process account and unelevated operation. A negative
attempt returned False in **2.020 seconds**; operator confirmation of selecting
Cancel is pending, and the Boolean result cannot establish the native reason.
An earlier requested-cancel attempt returned Verified and is explicitly not
counted as cancellation evidence.

The explicit harness invokes no B.G.D capture/enrollment and records no credentials
or identifiers. Review corrected an overly broad outcome label and timeout race;
both Standards and Spec report zero remaining findings on recheck. All **44**
automated tests and strict typing of **11** modules pass. See
[evidence and limits](../../docs/pc-biometric/enrollment-boundary.md#consented-windows-verification-test--2026-08-31).

Ticket 02 remains incomplete: offline Windows behavior, session integration,
guided UI B, capture/model adapters and actual enrollment acceptance remain
unvalidated or unfinished. Production enrollment is disabled. Windows-test
consent does not extend to B.G.D biometric capture. No Ticket 03, hardware changes,
staging, commit or push.

Cancellation retry: the user reported being pretty sure they had selected Cancel
and requested another test. The unchanged harness returned False in **1.620 seconds**,
with unchanged account, unelevated operation and exit 0. This is another observed
non-verification result, not a newly exposed native cancellation reason. No B.G.D
capture or enrollment occurred; no code changed and ticket acceptance remains open.

## PC completion grilling — 2026-09-09

The owner authorizes a reviewed local Git checkpoint and requests completion of the PC application while hardware is paused for a future 3D-printing change. Current source/evidence was assessed before planning: 120 automated tests and strict typing across 13 modules pass; real speaker mismatch remains unresolved.

Confirmed round 1:
- Q1: keep UI B and polish it.
- Q2: allow evidence-led model/enrollment-recipe replacement, preserving the current profile until a tested migration/re-enrollment step with appropriate session agreement.
- Q3: implementation first; real acceptance trials later. The five-day usability and mandatory attack/state criteria remain final acceptance requirements.

Confirmed round 2:
- Q4: support both the PC microphone and headset/EarPods, with explicit selection and qualification of each path.
- Q5: include short, separately consented development checks before the later acceptance campaign. This is willingness to participate, not immediate capture consent.

Confirmed round 3:
- Q6: include the protected local helper service. Administrator approval is used for installation/update/removal; ordinary use remains unelevated. The helper starts when needed and exposes no network endpoint. Its installed verifier/runtime and operation channel must be protected; a same-account client cannot simply claim a successful check.

### Proposed execution plan for shared-understanding confirmation

Preserve the existing eight-ticket graph. Implementation and actual acceptance remain distinct. Hardware work stays paused; 3D-printing design is a later effort and does not alter current PC requirements.

1. **Establish the protected application/state boundary.** Design the minimal installed helper and protected verifier/runtime, local process-bound protocol, durable attempt reservation, cooldown/reboot policy and conditional profile-generation publication. Test forged same-account clients, stale/concurrent results, interruption, state deletion/rollback and unavailable-helper failure before depending on the boundary. No generic privileged write or command endpoint; no camera, microphone or network processing in the state helper. The proposed division must be revised if its trusted-result path cannot be demonstrated.
2. **Resolve recognition and qualify both microphone paths.** Use the existing three-sample study in a separately agreed development session. Compare fresh-to-fresh and fresh-to-enrolled evidence; evaluate capture/reference/model alternatives when justified. Preserve the current encrypted profile until a tested, agreed transition. Freeze development settings separately from later acceptance material; do not lower thresholds merely to obtain a pass.
3. **Implement the remaining lifecycle workflows.** Complete Ticket04 retry/interruption behavior, Ticket05 reference updates and lost-code replacement, and Ticket06 code-plus-Windows recovery. Recovery can advance independently of normal verification once the protected generation writer exists. Preserve complete old/new profile-code pairs across crash/restart; maintenance/recovery grant no ordinary-action authorization. Do not mark Ticket03 resolved without its named real-device evidence or bypass ticket acceptance dependencies.
4. **Develop spoof/substitution defenses early and integrate Ticket07.** Map every required attack route to an implemented defense and test. Use synthetic/fault checks during development and separately consented live checks when needed. Full nonowner/attack acceptance remains later; absence of that evidence cannot be reported as passed security. Investigate feasibility alongside the state/recognition foundations rather than after UI polish.
5. **Finish UI B and offline installation/handoff.** Complete Account/Recovery screens, explicit device selection, cooldown and failure guidance, keyboard/accessibility work, privacy cleanup and the protected app/helper installation/update/removal lifecycle. Provide an offline bundle and reproducible launch/check instructions. Code signing, new dependencies or paid services are not silently assumed.
6. **Verify and hand off the implementation.** Run meaningful integrated tests, strict typing and fresh regression checks; document known limitations and frozen version/configuration. Hand off as implementation-complete only when its stated checks pass. Keep Ticket08's five-day/100-attempt, timing, nonowner, attack and remaining state evidence visibly pending until separately performed.

The user confirmed the assembled execution plan with "yes" on September 9. Implementation is authorized across the approved PC scope. Begin protected recurring-state handling, device selection and early security/recognition feasibility work. Real capture and retained test assets still require concrete session consent; the formal acceptance campaign remains later. Hardware stays paused.
