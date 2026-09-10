# 02 — Safe owner enrollment and protected storage

**Controlling disposition: retired and dormant.** The standalone PC app and voice-identity check are removed from the finished product by the [scope clarification](../spec.md#controlling-disposition-retired-and-dormant). All content below is dated history. It creates no implementation, testing, validation, packaging, evidence-refresh or reporting task. Repository files, installed software and profiles remain untouched pending any separate removal decision.

Status: resolved
Implementation: protected enrollment/storage complete; 96 tests, strict typing and final reviews pass; real face/voice, interruption, 222.144-second offline enrollment, fresh-process reopen and cleanup pass; actual second-account switching was explicitly waived and remains unvalidated
Blocked by: 01

**Specification:** [M1 PC biometric desk application](../spec.md)

**What to build:** Deliberate first setup with fresh designated-owner Windows verification, guided face-and-voice enrollment, encrypted references and an offline recovery code saved before setup completes.

- [x] Bind setup to the designated Windows account using successful fresh verification; canceled, failed, unavailable or changed-account verification cannot complete enrollment. Demonstrate offline integration when the real session is authorized.
- [x] Collect both references only under the applicable capture consent. Normal raw inputs are transient; encrypted references and protected ownership/control state persist.
- [x] Generate/protect the recovery code using reviewed established cryptographic facilities, guide offline saving and explain the approved combined-loss consequence.
- [x] Demonstrate first-install versus missing/corrupt-profile behavior; deleting or damaging the biometric payload must not reopen unrestricted owner setup.
- [x] Coordinate identity-state writes and test interruption/account-switch cases. Partial setup grants no ordinary protected action and cannot leave competing committed identities.
- [x] Keep raw media, templates and recovery secrets out of ordinary logs, source files and result exports; inspect actual storage and temporary-file behavior.
- [x] Instrument the full normal setup workflow for the five-minute acceptance target after installation, without treating download/troubleshooting time as silently successful enrollment.

Account-change and session-disconnect behavior is covered automatically, actual workstation
locking passed, and real microphone cancellation cleanup passed. Switching to a genuinely
different active Windows account was not run because no second accessible account exists;
sign-out was correctly rejected as equivalent, and the user explicitly accepted this as a
Ticket02 closure limitation. It is not reported as passing evidence.

Real capture requires the separate consent/session prerequisites. Synthetic fixtures validate control flow only, not biometric enrollment quality or Windows integration.

## Comments

### 2026-08-30 — Implementation begins after ticket 01

Ticket 01 is resolved. Proceed with the real enrollment/storage workflow and non-biometric synthetic tests at the approved public boundary. Separate consent blocks actual owner capture and account-prompt demonstrations, not reversible implementation or non-capture storage validation. Keep this ticket incomplete until the required real Windows/capture/storage evidence exists; do not advance tickets 03/06 on fixture results alone.

### 2026-08-30 — Development implementation and demonstrated storage blocker

Implemented the public enrollment start/save/cancel/status seam with actual user-scoped Windows DPAPI, encrypted code verifier/references, separate encrypted ownership record, atomic generation selection, Windows file locking, account/cancellation checks and setup timing. Controlled fixtures supply Windows outcomes and non-biometric references; this code is not connected to real capture, a Windows prompt or the production UI. Full evidence and missing integration are recorded in [the enrollment boundary](../../../docs/pc-biometric/enrollment-boundary.md).

The full suite has **18 passing development tests and two expected failing security requirements**, not an acceptance pass. Strict typing passes six application modules. Two-axis review found and regression-tested cancellation/commit races, late-result resurrection and capture-after-cancellation; these were fixed. Individual missing/corrupt files close setup, and a subprocess crash preserves the account reservation while releasing its lock. These results do not validate a real Windows account, biometric quality, the five-minute target or complete data protection.

**Blocking finding:** deleting all user-owned state or restoring an older complete reservation reopens setup. DPAPI alone supplies neither independent installation history nor rollback-resistant ownership state. Do not silently exclude same-Windows-account tampering from the intact-host claim. A protected external authority may require an administrator-installed component; that installation/maintenance consequence was not approved. Obtain a decision on that concrete consequence before adding a privileged component. The linked record contains the exact question and demonstrated failures, not replacement requirements.

All acceptance boxes remain open because this end-to-end slice is incomplete. Production enrollment remains disabled; no fresh-Windows/capture implementation is advertised as working, no real session occurred, and tickets 03/06 remain blocked. No commits or pushes.

### 2026-08-30 — Final review recheck

Standards reviewer: zero remaining findings in the scoped fixes; independently reran all twelve enrollment regression tests. Spec reviewer: last cancellation defect fixed; no additional defect in that scoped recheck. **Spec acceptance remains blocked** by the two ownership-security failures and missing real integrations. Full suite: twenty tests, eighteen passes and two expected failures. Strict typecheck passes six application modules. Expected failures remain explicitly reported, not waived. Test-created temporary encrypted reservations from red cycles were removed; no real biometric or Windows credential state exists.

### 2026-08-30 — Resume ticket 02 only; stop before later tickets

Latest user scope: finish ticket 02, then stop. Added the native desktop Windows verification bridge and process-token SID reader, a shared cancellation event, and sanitized account-unavailable status handling. Red/green tests cover the public enrollment workflow with controlled native COM results, including rejection of cancelled/failed/unknown results and success arriving after window destruction. A read-only real Windows probe acquired the required interfaces and returned Available; it did not authenticate anyone.

Current suite: 26 passing development tests and the same two expected failing ownership-security requirements. Strict mypy passes seven modules. The production launcher still cannot enroll; real prompt/session interruption, capture/models, guided setup and the five-minute measurement are not demonstrated. See the appended [implementation evidence](../../../docs/pc-biometric/enrollment-boundary.md#resumed-ticket-02-only-work--2026-08-30).

The privileged-installation decision was requested while independent work continued. No reply approving that consequence or consented real session is assumed from the general finish instruction. All acceptance boxes remain open. Tickets 03–08 were not touched; no hardware work, Windows permissions, capture, commits or pushes.

Required review recheck: Standards has zero findings. Spec found and regression-tested a shared-session-cancellation bypass while saving the code; guards now discard pending setup before commit, including after the final account callback. Both reviewers independently reran all 15 enrollment regressions and found no further scoped defect. Spec acceptance remains blocked; neither review waives missing storage/integration evidence.

### 2026-08-31 — Privileged setup approved; non-biometric work only

The user explicitly authorizes administrator privileges during installation/setup where necessary for a protected ownership authority. Normal operation must stay unelevated, the privileged surface must be minimal, and a service is not assumed. Implement and automatically validate deletion/rollback protection, then stop and ask before any real camera, microphone, Windows-verification or biometric-enrollment validation. Do not start ticket 03. This resolves the installation-permission question above, not the real-session consent or acceptance evidence.

Implementation direction: a 64-bit HKLM registry authority, writable only by administrators/SYSTEM, with normal read-only access. Only installation/setup writes require privilege; no persistent service or network listener. The encrypted user payload is subordinate to the machine authority. Reinstallation must preserve an existing authority, and absent/damaged authority must close enrollment rather than infer first installation. Concrete implementation and validation evidence will follow here.

### 2026-08-31 — Authority implementation and non-biometric review; UAC action required

Implemented the separate HKLM authority, idempotent installer, exact ownership/ACL checks, serialized initial publication, installation revision checks and a metadata-only one-shot Windows system PowerShell publisher. Normal launch rejects elevation; Python/capture/user data paths are not elevated by the publisher. A parent/helper event-handle protocol prevents timed-out or orphaned publication from overlapping a fresh setup. The original deletion/rollback requirements now pass against isolated HKCU authority fixtures, without weakening their expected outcomes.

Final available validation: **44 passing tests, zero skips/expected failures; strict mypy passes 11 modules**. Tests exercise real DPAPI/storage/Windows handles and process death, with synthetic references and controlled verification/UAC outcomes. Required Standards review reports zero remaining findings; Spec confirms the helper-lifetime fix and finds no further actionable defect in its focused recheck. Scope/evidence details are in the [current implementation record](../../../docs/pc-biometric/enrollment-boundary.md#current-boundary--2026-08-31).

**Blocked action:** the administrator test launch was canceled by Windows/UAC, so the three prepared HKLM/linked-token/publisher integration tests did not run. No production authority was installed. HKCU success is not machine-security validation. The [reviewable runner](../../../tests/run_machine_validation.ps1) requires an administrator shell but neither requests elevation itself nor performs any camera, microphone or Windows-verification operation. `ready-for-human` records this OS-consent action; it does not mean ticket acceptance or that all implementation is finished.

Guided UI B enrollment, capture/reference-model adapters, Windows session-interruption wiring and real setup/storage/timing evidence remain incomplete. The current setup helper expects elevation as the designated account and refuses a different administrator account; a standard-only designated-account route is not demonstrated. Production enrollment stays disabled, every acceptance box stays open, and the separate consent boundary must be reached before any real validation. No ticket 03 or later ticket, aircraft/hardware work, commit or push.

### 2026-08-31 — Approved UAC retry; native authority and publication validation pass

The user approved retrying the canceled non-biometric UAC validation. This supersedes the canceled-launch blocker and earlier runner instructions above; it does not authorize real Windows verification or biometric capture.

The first approved run exposed fixture errors: the linked token produced invalid impersonation-level errors, and elevated fixture creation denied normal data access. Tests now use the live normal coordinator's verified same-account, unelevated primary token and create its data under that token. Application permissions were not weakened. The runner starts from normal PowerShell and explicitly requests UAC for its isolated test host.

**Three native machine tests pass**: normal authority reads, denied modification/deletion/ACL takeover, metadata publication, installation replacement rejection, preservation across reinstall, and closed enrollment after user-state deletion/rollback. **One additional native UAC handoff test passes** from a genuinely unelevated process through the actual application publisher, with synthetic references and controlled Windows-verification success. It asserts the caller remains unelevated, deletion/replay cannot reopen setup, the temporary administrator fixture exits, and its unique HKLM key is removed. See [evidence and repeatable runners](../../../docs/pc-biometric/enrollment-boundary.md#current-boundary--2026-08-31).

Final ordinary checks: **44/44 tests pass, no skips or expected failures; strict mypy passes 11 modules**. Required Standards and Spec reviewers each report zero new actionable findings after the fixture correction and native handoff addition. These are authority/publication results, not biometric, full storage-retention, timing or end-to-end acceptance evidence.

Ticket 02 remains incomplete and `ready-for-human` at the requested separate real-validation consent boundary. Guided UI B, capture/model adapters and session-interruption integration remain unfinished; every acceptance box stays open. No real camera, microphone, Windows verification or biometric enrollment ran. No production authority was installed, no production permissions changed, and no service remains. Ticket 03 and hardware work were not started; no staging, commit or push.

### 2026-08-31 — Consented native Windows account-verification test

The user explicitly approved the Windows account-verification test only. An explicit Tk test window calls the existing native adapter using its top-level HWND and an unelevated worker. No B.G.D capture or enrollment adapter is called, credentials stay in Windows, and no production authority/profile is created.

Observed results: the first requested-cancel attempt returned Verified in 4.666 seconds, so it did not test cancellation. After adding a deliberate Start button, the second attempt returned False in 2.020 seconds. A separate success attempt returned Verified in 5.879 seconds. In all three attempts the process account was unchanged and the process remained unelevated. The operator was asked whether they chose Cancel in the second dialog; confirmation remains pending. False alone cannot distinguish cancellation from other non-success outcomes, and the evidence does not claim a native Canceled enum.

The required reviewers identified that reporting ambiguity plus a timeout/reporting race in the harness. Both are fixed; Standards and Spec report zero remaining findings on focused recheck. The application adapter was unchanged. Full automated suite: **44/44 passes**, no skips/expected failures; strict mypy: **11 modules pass**. See the [detailed record](../../../docs/pc-biometric/enrollment-boundary.md#consented-windows-verification-test--2026-08-31) and [explicit harness](../../../tests/windows_verification_validation.py).

Ticket 02 remains incomplete: offline verification, session interruption/switching, guided UI B, capture/models and full setup/storage/timing acceptance are not established. Windows-test consent does not authorize B.G.D camera/microphone capture or enrollment. No later ticket, hardware work, staging, commit or push.

### 2026-08-31 — Requested cancellation retry

The user reported being pretty sure they had selected Cancel and explicitly requested another attempt. The unchanged explicit harness returned **False in 1.620 seconds**, with unchanged process account, unelevated operation and exit 0 for the expected Boolean. This confirms another non-verification result; the native cancellation reason is still not exposed. The user's qualified recollection and the measured result remain separate evidence. No further confirmation loop or additional authentication attempt was started. No B.G.D capture, enrollment, application-code changes, later-ticket work, commit or push; ticket acceptance remains incomplete.

### 2026-09-03 — Additional requested cancellation retry

At the user's request, the unchanged explicit harness ran again and returned **False in 4.847 seconds**, with unchanged process account, unelevated operation and exit 0 for the expected Boolean. This is another observed non-verification result; the Boolean adapter still does not expose the native cancellation reason. No B.G.D capture, enrollment, production-state change, later-ticket work, commit or push. Ticket 02 remains incomplete.

The user requested one further run, selected **Cancel** in the opened Windows dialog and explicitly confirmed doing so. The adapter returned **False in 8.013 seconds**, with unchanged account and unelevated operation. The operator-confirmed action plus the measured result demonstrate safe cancellation rejection; the Boolean API output alone still does not expose a native reason. No capture, enrollment or production-state change occurred.

### 2026-09-03 — Ticket 02 non-capture production integration continued

The user confirmed there is no remaining Windows-verification blocker and instructed continuation of Ticket 02. UI B now drives the authoritative enrollment workflow through explicit consent, Windows verification, guided face/voice stages, one-time recovery-code display, saved-code confirmation and protected completion. Navigation cannot hide a pending recovery code behind a misleading setup surface. Windows lock, sign-out, console/remote disconnect and end-session notifications invalidate pending setup and clear a displayed code.

The concrete capture adapter lazily opens the selected OpenCV/Vosk/sounddevice path only after the workflow permits capture, produces bounded SFace and Vosk speaker references, writes no raw media, and releases the camera despite cancellation or status-display failure. Automated tests use synthetic device/model outputs only. The official pinned model artifacts were acquired into ignored scratch storage, hashes frozen, exact Vosk tree integrity enforced, and all four models loaded without device access.

Current evidence at this pre-session boundary: **62/62 automated tests pass**, no skips/expected failures; strict mypy passes **12 modules**. Pinned-environment readiness verified exact packages/models and enumerated two camera interfaces and one microphone interface with capture off. Capture now uses a disposable unelevated worker, device indicators are acknowledged before activation, and a bounded memory-only face preview crosses IPC into Tk and is cleared when face capture ends or is cancelled; no raw media file is written. Repeated session notifications cancel newly armed operations, and stale UI results cannot redisplay a recovery code or stale active-device status after interruption. Manual cancel and window close signal cancellation synchronously before asynchronous cleanup. The default launcher blocks setup while readiness has Missing/Failed prerequisites and blocks capture until session-specific participant/access/retention/deletion terms are supplied. Focused Standards and Spec rechecks report zero actionable findings. No successful real B.G.D camera/microphone capture or biometric enrollment, offline end-to-end completion, workstation-lock test or five-minute setup measurement had run yet. The production authority was installed for the current Windows owner but remained uncommitted after the incomplete first attempt. Ticket 03 and hardware work remained untouched; no commit or push.

### 2026-09-03 — Specifically consented real owner enrollment

The user authorized real camera/microphone enrollment and retention through
2027-01-01. The pinned B.G.D runtime was blocked by a verified temporary outbound
firewall rule while the real Windows verification, live-preview face capture,
voice capture, offline-code acknowledgement and protected publication ran. The
normal app stayed unelevated; the explicit authority installation and temporary
firewall setup/cleanup used UAC. The firewall rule was removed afterward.

One protected authority generation and one matching encrypted payload committed.
Immediate public loading found the redundant local ownership index still at its
earlier empty reservation, so loading failed closed. A two-process probe confirmed
the operation lock excludes a second holder. A one-time unelevated reconciliation
verified the protected owner/current account, exact payload digest and encrypted
profile structure, then rewrote only that local index to the already committed
generation. Public loading now succeeds; authority/local metadata match; both
references are nonempty/bounded; no raw image/audio or pending file remains. The
incident is retained as failed first-pass consistency evidence, not reported as a
clean pass.

Automated validation remains **62/62** with strict mypy across 12 modules and zero
focused Standards/Spec findings. The agreed deletion date is 2027-01-01; a later
read-only recheck found no Windows task/startup entry or Codex automation implementing
it, so the earlier active-task claim was withdrawn. With immediate approval, the
current-user limited task `BGD.PCBiometricDesk.DeleteEncryptedProfile` was registered for
local midnight on that date with StartWhenAvailable. A guarded pre-date run returned0 and
preserved the profile/models; its inspected action targets only the profile directory and
preserves HKLM authority, so deletion cannot reopen enrollment.
The five-minute target and real workstation lock/account-switch interruption remain
unvalidated, so Ticket 02 stays `ready-for-human`; Ticket 03 was not started and no
commit or push occurred.

### 2026-09-03 — Approved enrollment UX and quality amendment implemented

User approved the completed grilling agreement: masked/eye/copy recovery code with
successful Copy enabling Complete, no clipboard timeout/transcription; automatic
quality-gated face sampling with actual landmark dots; three different English voice
phrases with quality checks and visualizer A. No automatic learning or iOS refactor.
The spec is amended in place. Later random-phrase verification is recorded only;
Ticket03 was not started. The ignored prototype remains a local design reference.

Implemented and tested at the existing public capture and UI seams. Red/green evidence
includes missing clipboard gating, absent face-quality feedback, absent three-phrase
voice enrollment/waveform, incomplete vertical face-pose rejection and a duplicate
completion race during protected publication. Subsequent regressions cover framing,
lighting, blur, unstable/multiple faces, actual landmark disappearance, silence,
clipping, noise, wrong phrases, retry, cancellation and stale waveform suppression.

Final automated suite: **72/72 pass**, no skips/expected failures. Strict mypy2.3.1:
**12 modules pass**. Compile and scoped whitespace checks pass. Repository-wide
whitespace check still reports the pre-existing unrelated Project Idea.md EOF blank;
it was not edited. Independent Standards and Spec reviewers have **zero remaining
actionable amendment findings** after the two fixes and README state correction.

See [documented development settings](../../../docs/pc-biometric/README.md#development-quality-policy--not-biometric-acceptance).
These are uncalibrated real-device thresholds, not biometric/security acceptance.
No real camera/microphone, Windows prompt, firewall modification or production-profile
mutation occurred in this amendment. Existing enrollment is preserved; no deletion or
bypass for re-enrollment is allowed. The earlier index incident, reliable five-minute
timing and actual session-interruption evidence remain open. The prior explicit lock
runner's cleanup/result-binding findings were fixed: whole-resource try/finally,
cancel/join, independent cleanup, immediate setup failure and accepted lock request
required for passing. Both reviewers cleared the runner. Compilation only; no actual
lock was performed, so this is not new real-session evidence.
Ticket02 stays incomplete/ready-for-human; stop for separate real-validation consent.
No staging, commit or push.

### 2026-09-03 — Diagnosis before reset; actual workstation lock passes

User explicitly requested storage diagnosis and interruption checks while preserving
the existing enrollment. The [diagnosis record](../../../docs/pc-biometric/storage-incident-diagnosis.md)
documents a separate reproduced pre-publication reader/replacement race, its failing
public-workflow test and bounded retry fix. It does not explain or close the original
post-publication stale-index incident. No speculative reconciliation/reset was added.

Final suite: **75/75 pass**, no skips/expected failures; strict mypy passes 12 modules;
1,000 stress iterations pass. Independent Standards/Spec reviews: zero actionable
findings. The actual Windows lock runner first timed out without a lock request;
the reopened run passed with an accepted lock, actual interruption, cancelled
synthetic capture, no committed fixture profile and successful cleanup.

Production profile was readable before testing; encrypted files and authority were
unchanged afterward. No new biometric capture, firewall mutation, reset, UAC setup,
Ticket03 work, staging, commit or push. The original incident needs a failing trace
or separately approved metadata-only checkpoint instrumentation; the diagnosing-bugs
skill prohibits claiming its cause without a natural reproduction. Actual account
switching, real-device amendment validation and timing remain open. Acceptance boxes
stay open and status remains ready-for-human/incomplete.

### 2026-09-04 — Temporary diagnostic tracing ready; stop before real devices

User approved temporary, minimal storage/publication checkpoint tracing for the next
validation attempt. The private opt-in trace records only transition names,
UTC/monotonic timestamps, process ID, result and sanitized exception type/numeric
codes. It has no fields for identities, paths, generations/digests, biometric data,
recovery codes, payload metadata or exception messages. It is disabled unless
`BGD_STORAGE_DIAGNOSTICS=1`; its fixed output is outside the profile directory, and
trace write/construction failures cannot alter storage results. Exact enable,
disable and post-inspection deletion commands are in the [diagnosis record](../../../docs/pc-biometric/storage-incident-diagnosis.md#temporary-storage-step-tracing-ready--2026-09-04).

Six focused regressions prove enabled/disabled equivalent durable state, no artifact
when disabled, allow-listed secret-free records, sanitized fail-closed publication
errors and unchanged success when trace construction or its destination fails. Final
suite: **81/81 pass**; strict mypy passes 12 modules; compilation/scoped whitespace
pass. The separate reader-race suite passes 1,000 iterations, so its bounded retry
remains. Initial independent review found incomplete operating/removal instructions,
insufficient differential state evidence and record construction outside its failure
boundary; all three were corrected and rechecked before sign-off.

Independent Standards and Spec rechecks each report zero actionable findings. The
reviewers independently passed the six diagnostic tests and three reader-race tests;
Standards also passed strict mypy across all 12 application modules.

Read-only production checks show the current profile readable before work and the
encrypted files/protected authority unchanged afterward. Production tracing remains
disabled and no production trace file was created. No reset, capture, account switch,
network/firewall action, UAC setup, Ticket03, staging, commit or push. The original
incident remains open pending a natural failing trace or enough real validation
evidence. Stop here before interactive validation as requested.

### 2026-09-04 — Actual account-switch check prepared; immediate approval boundary

The reviewed explicit session runner now supports `switch` mode using only an
unelevated unique HKCU fixture, temporary files, controlled verification and synthetic
references. Passing requires a genuine different active-console session and requires
the production console-disconnect handler itself to cause cancellation; a preceding
lock notification is ignored in this validation-only mode and cannot satisfy the
check. The fixture must remain uncommitted and cleanup must succeed. Output contains
only Boolean results, not session/account identifiers.

Read-only checks report at least two enabled local accounts without printing names.
A new red/green regression rejects signed/unsigned no-active-session sentinels and the
same session, accepting only a valid different session. Full suite: **82/82 pass**;
strict mypy: 12 modules; compilation and safe invalid-mode behavior pass. Standards
and Spec rechecks: zero actionable findings.

The interactive mode was not launched. Current enrollment remains readable; no
production trace exists. No account switch, capture, reset, firewall/network change,
Ticket03, staging, commit or push occurred. Stop for immediate user approval before
launching the account-switch window.

### 2026-09-04 — Account switching unavailable; real face boundary prepared

The first switch attempt lost its terminal connection and provided no result. The
detached retry was made fail-safe against stale evidence, but the user has no
accessible second account and chose to move on. Sign-out is not equivalent, so actual
account switching remains missing evidence. At the user's direction the waiting
process was terminated; its HKCU key and incomplete result were removed. Two isolated
synthetic reservation directories remain under Windows Temp because host policy
blocked deletion; their paths and limited contents are recorded in the diagnosis.
They contain no biometric reference/raw media and cannot affect production ownership.

A consented real face-only run completed through the production isolated capture path.
The result recorded preview, representative rejection guidance, landmark-overlay frames,
automatic completion of eight samples, no microphone-stage acknowledgement, unchanged
production state and no raw-media artifact. The participant separately confirmed the
dots tracked their face.

The run's combined cleanup flag was false. A later component trace and code inspection
proved the normal-close branch destroyed the already-closed Tk root a second time.
Both harnesses now avoid that deterministic UI cleanup error. Their worker wait was
also raised from five to fifteen seconds to cover the readiness probe's twelve-second
bound. No device process remained, and the capture evidence does not require a camera
rerun.

Post-change suite: **83/83 pass**; strict mypy: 12 modules. The production profile is
readable and committed, diagnostics remain disabled, and profile/diagnostics contain
zero raw media. The original storage incident stays open. Stop for new explicit consent
before real microphone/voice validation; no reset, network/firewall action, Ticket03,
commit or push.

The voice-only validation harness is now prepared without device access. It invokes
the production voice routine in a disposable child without entering the face path.
Passing requires microphone-stage entry, no camera stage, live waveform plus operator
confirmation, three English prompted/accepted takes, one deliberate quality rejection,
unchanged protected/profile/diagnostic state, no new raw media and complete cleanup.
The derived voice reference is discarded. Process setup is inside its cleanup boundary,
and worker waits cover the production timeouts. Invalid-model and child-process smoke
checks pass without microphone access; full suite remains **83/83** and strict mypy
passes 12 modules. Stop for immediate participant consent before launching it.

The first consented voice-only attempt entered the microphone stage, never entered the
camera stage, displayed waveform data and produced at least one rejection. It did not
record all three prompt/acceptance stages or the final participant confirmation. The
original result cannot safely distinguish child capture exhaustion, early closure or
another suppressed child failure, so the cause remains open. Storage was unchanged,
no raw media or production trace exists, the enrolled profile remains readable and no
validation process remains. Safe follow-up output now reports only prompt/acceptance
counts, a fixed failure category and separate cleanup Booleans. A new microphone run
requires fresh consent.

The approved retry recorded microphone and waveform activity, no camera stage, one
prompt take, zero accepted takes and rejection behavior before a generic child error.
The microphone child and wrapper both stopped. Its separate UI cleanup failure exposed
the double-destroy defect, now fixed in both harnesses. The child now reports only
allow-listed categories for known capture exhaustion/timeouts/model/display failures,
with unknown capture or device/runtime failures kept generic and no exception text or
biometric content transmitted. Automated suite: **83/83 pass**; strict mypy: 12 modules;
missing-model child smoke confirms categorized failure and termination without opening
a device. Three accepted voice takes remain unvalidated; another run needs new consent.

### 2026-09-05 — Deliberate voice controls ready for validation

The latest consented automatic-flow run accepted take one and reached take two, then
ended with bounded `attempts_exhausted` after `background_noise` and `phrase_mismatch`
guidance. It recorded microphone and waveform activity with no camera stage; child,
wrapper and UI cleanup passed, storage/authority were unchanged and no raw media appeared.
This is partial pipeline evidence, not the required three accepted takes.

At the participant's direction, voice enrollment now uses a large persistent English
phrase, automatic room measurement, and a mouse/Spacebar Hold to record control that stops
on release. With the mic closed, Play back, Submit and Record again are deliberate choices.
Accepted/rejected states wait for Continue/Try again, preserve a specific reason, and retry
only the current take. Raw recording bytes stay in the disposable process and are wiped on
submit/rerecord; cancellation or close terminates the process. Quality and attempt bounds
remain; waiting screens now cancel after60 seconds of inactivity and full enrollment is
bounded to five minutes.

The voice-only harness instructions and evidence gate now require one deliberately unusable
submission yielding a persistent allow-listed quality reason, three prompted and accepted takes, waveform
and playback confirmation, unchanged storage, no raw media and complete cleanup. Ticket02
remains incomplete/ready-for-human, the original
storage incident remains open, and fresh microphone consent is required before validation.

Device-free result: **93/93 tests pass**; strict mypy2.3.1 passes12 modules; compilation
and scoped whitespace checks pass. A read-only production check reports committed authority,
a readable profile, tracing disabled, no trace file and zero raw-media files. No reset,
device access, Ticket03 work, commit or push occurred.
Final independent Standards and Spec reviews each report zero actionable findings.

The first consented run of the deliberate controls reached take two and accepted one take
before the90-second voice budget expired. The waveform was confirmed; rejection reasons
were `background_noise` and `too_quiet`; camera access stayed off. Storage/authority were
unchanged, no raw media appeared, and child/wrapper/UI cleanup all passed. Requiring the
single category `insufficient_speech` for a deliberate unusable take was narrower than the
ticket's acceptance/rejection requirement and unreliable with real room noise. The harness
now accepts a persistent allow-listed quality rejection while still requiring three accepted
takes. This run remains incomplete, the storage incident remains open, and a retry requires
fresh microphone consent.

The second consented deliberate-control run also reached take two with one accepted take
before the former90-second limit. It proved submitted rejection with persistent `too_quiet`
guidance, waveform and playback behavior, both participant confirmations, camera off,
unchanged storage, no raw media and complete cleanup. At the user's direction, the rushed
voice deadline is replaced by60-second waiting-state inactivity cancellation and the
five-minute full-enrollment limit;10-second recordings and three attempts remain. New
device-free regressions cover the enrollment deadline, code clearing and capture-worker
bound. The full suite is **96/96** with strict mypy across12 modules. Final independent
Standards and Spec reviews each report zero actionable findings. Three real accepted takes
still require a fresh consented retry.

### 2026-09-05 — Complete real voice-control validation

The next freshly consented voice-only run passed: microphone stage entered, camera stage
absent, live waveform and memory-only playback observed and participant-confirmed, a
deliberately unusable submitted take rejected with persistent `too_quiet` guidance, and all
three displayed English takes prompted and accepted. Child, wrapper and UI cleanup passed;
protected/profile/diagnostic state was unchanged and no raw media was created. This closes
the Ticket02 real voice-control/quality evidence gap, not biometric security acceptance.
Complete timed offline enrollment, reopen/storage inspection and the unresolved historical
storage incident remain open. No Ticket03 work, commit or push occurred.

### 2026-09-05 — Real microphone interruption cleanup

With separate immediate consent, the participant closed the voice-only harness while the
microphone was actively recording and waveform data was present. No camera stage ran and no
take was accepted. The harness returned its expected cancellation category before timeout;
the child, wrapper and UI all stopped, production state was unchanged and no raw media was
created. This closes the remaining real disposable-worker cancellation evidence gap. It does
not exercise publication or explain the historical storage incident.

### 2026-09-05 — Approved production reset completed

The user gave immediate approval to permanently reset the enrolled profile/recovery generation
and reprovision the protected authority. The encrypted profile was removed. PowerShell's
registry provider was denied deleting the protected key and safely left enrollment closed;
the retry used Python's native64-bit registry API already covered by administrator tests,
removed the old authority and installed a fresh protected uncommitted authority. Read-only
verification reports no profile, empty authority profile/digest, a Ready deletion task and an
unelevated normal process. The one-shot script and sanitized log were removed. No device,
network, firewall, Ticket03, commit or push action occurred. Full traced offline enrollment
still requires separate immediate approval.

### 2026-09-05 — Complete timed offline enrollment passed

With immediate approval, a temporary exact-program outbound firewall block isolated the
pinned B.G.D. Python runtime. The normal app stayed unelevated and completed fresh Windows
verification, real face/voice capture, recovery-code Copy/save acknowledgement and protected
publication in **222.144 seconds** of launch-to-close wall time. The firewall rule was then
removed and verified absent.

The authority is committed to the current account and matches one public-loadable encrypted
profile. There are zero raw-media and zero pending artifacts, no B.G.D. process remains, and
the14-record secret-free trace contains every required success transition with zero failures.
The historical storage inconsistency did not reproduce; its unknown cause is not inferred from
this clean run. Normal-app reopen and final trace cleanup remain separate boundaries.

### 2026-09-05 — Fresh-process reopen and final cleanup passed

With separate approval, the normal app reopened unelevated with diagnostics disabled. The
participant confirmed Setup recognized the existing owner and kept `Set up owner` disabled;
no camera, microphone or Windows verification ran, and the app exited0. The disabled Verify
action remains Ticket03 scope.

Final checks load the encrypted profile, match protected authority to the current account and
find one non-plain-JSON ciphertext payload, zero raw media, zero pending artifacts and no trace.
Diagnostics are off, no B.G.D. process or validation firewall rule remains, and the 2027-01-01
deletion task is Ready. The historical mismatch did not reproduce in the complete traced run
or fresh-process reopen; its cause remains unknown. Final disposition is recorded below.

## Answer

Ticket02 is resolved as safe first-owner enrollment and protected encrypted storage. The
final baseline is **96/96 automated tests**, strict mypy2.3.1 across12 source modules,
successful compilation/scoped whitespace checks and zero actionable Standards/Spec findings.
Consented real evidence covers Windows verification, face preview/landmarks/automatic quality
capture, deliberate three-take voice controls, real microphone interruption cleanup, a
**222.144-second** complete offline enrollment, protected publication, fresh-process reopen
and final raw/pending/log cleanup.

The original post-publication local-index mismatch is closed as **unreproduced after bounded
investigation**. Its cause remains unknown and is not attributed to the separately reproduced
and fixed Windows reader/replacement race. Reopen the incident if any authority/local-index/
payload mismatch recurs. Actual fast user switching to a second account remains explicitly
unvalidated under the accepted limitation above. Biometric identity accuracy, liveness,
replay/substituted-input resistance, ordinary verification and recovery remain later-ticket
work. The encrypted profile is scheduled for deletion on 2027-01-01 while protected authority
remains, so deletion cannot reopen enrollment. Ticket03 is now unblocked but was not started;
no hardware work, commit or push occurred.
