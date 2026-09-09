# Ticket 02 — implementation evidence

## Fresh-process reopen and final cleanup passed — 2026-09-05

After separate approval, a new unelevated process opened the normal app with diagnostics off.
The participant confirmed that Setup recognized the enrolled state and `Set up owner` was
disabled. No camera, microphone or Windows prompt ran. The app closed normally with exit0.
The disabled Verify action remains the explicit Ticket03 boundary.

The final public-store check still loads the complete encrypted profile and confirms the
protected owner matches the current account. Exactly one ciphertext payload remains and is
not plain JSON; raw-media and pending-artifact counts are zero. The temporary trace was removed,
diagnostics are disabled, no B.G.D. process or validation firewall rule remains, and the
2027-01-01 deletion task is Ready. This completes the requested enrollment/reopen/storage
evidence without claiming biometric security, liveness, replay defense or Ticket03 behavior.

## Complete timed offline enrollment passed — 2026-09-05

After immediate consent, a temporary outbound Windows Firewall block was created for only
the pinned B.G.D. Python executable and verified enabled for every profile. The normal app
remained unelevated and enabled the temporary secret-free storage trace. Fresh Windows
verification, real face and voice capture, recovery-code Copy/save acknowledgement and
protected commit all completed. Process wall time from launch through close was **222.144
seconds**, a conservative upper bound below five minutes. The firewall rule was removed
immediately and verified absent.

The resulting protected authority is committed to the current Windows account and matches
a profile readable through `ProfileStore.load()`. One encrypted payload and its encrypted
ownership index exist and are not plain JSON. No raw-media file or pending artifact exists,
and no B.G.D. process remains. The14 diagnostic records conform to the allow-listed schema,
show all required reservation/publication steps succeeded and contain zero failures. The
historical post-publication inconsistency did not reproduce in this run. A normal-app reopen
and final trace removal remain separately consented boundaries.

## Approved production reset completed — 2026-09-05

The user gave immediate approval for destructive reset after the independent capture checks.
The encrypted production profile and its recovery generation were permanently removed. An
initial all-PowerShell path was fail-closed: one attempt changed nothing; the next removed the
profile but the registry provider was denied deleting the protected key, leaving the committed
authority in place and setup closed. The retry replaced only that failing step with Python's
native64-bit `winreg.DeleteKeyEx`, the same API path exercised by the administrator tests.

The old authority was removed and the explicit administrator installer created a fresh
protected uncommitted authority. Unelevated verification reports the profile directory absent,
authority readable with empty profile/digest and the 2027-01-01 deletion task still Ready.
The temporary reset script and its sanitized step log were deleted after verification. No
device, network or firewall action occurred. The next boundary is a newly consented complete
offline enrollment; the reset itself is not evidence that enrollment succeeds.

## Real microphone interruption cleanup — 2026-09-05

With fresh consent, the participant closed the voice-only validation window while recording
was active. The harness had entered the microphone stage, never entered the camera stage and
had observed live waveform data. It returned the expected cancellation category before any
take was accepted. The disposable capture child, wrapper thread and Tk UI all terminated;
protected/profile/diagnostic state was unchanged and no raw-media file appeared. This closes
the missing real-device worker-cleanup boundary for microphone cancellation.

## Complete real voice-control validation — 2026-09-05

The freshly consented voice-only validation passed. The production voice routine entered
the microphone stage without entering the camera stage, the live waveform responded, and
memory-only playback was used and heard. One deliberately unusable submission produced
persistent `too_quiet` guidance; retry then preserved progress and all three displayed
English phrases were prompted and accepted. Both participant confirmations were recorded.

Child, wrapper and UI cleanup passed. Before/after hashes and protected-authority reads
were identical, and no raw-media file appeared. This closes the real voice-control/quality
evidence gap only; it does not establish biometric identity, liveness or replay resistance.
It also does not replace the complete timed offline enrollment, post-enrollment reopen and
final storage inspection. The historical storage incident remains open and unreproduced.

## Latest boundary — temporary diagnosis instrumentation ready, 2026-09-04

The user approved minimal temporary storage-step tracing before further real-device
validation. It is opt-in via `BGD_STORAGE_DIAGNOSTICS=1`, writes a fixed JSON-lines
file outside the profile directory and records only transition names, timestamps,
process ID, result and sanitized numeric/type failure data. Diagnostic write failure
cannot change enrollment behavior. No secrets, identifiers, paths, payload metadata
or exception messages are included. See the full [diagnosis record](storage-incident-diagnosis.md#temporary-storage-step-tracing-ready--2026-09-04).

Automated validation after preparing the face-only harness: **83/83 pass**;
strict mypy passes 12 modules; the separate
reader-race suite passes 1,000 iterations. Independent Standards and Spec rechecks
each report zero actionable findings. The trace is disabled in production, no
production trace file exists, and read-only before/after checks confirm the current
encrypted enrollment and authority remain unchanged. The original incident stays
open. No account switching, biometric capture, reset, network/firewall action,
Ticket03 work, commit or push occurred.

The first remaining real boundary is prepared but not run: actual Windows Switch user
against an isolated synthetic pending setup. Pass requires console disconnect to
cause cancellation and observation of a genuinely different active console session;
a lock alone cannot pass. Both review axes report zero findings. Immediate approval
is still required before launching this interactive check.

The account-switch check was not completed because the user has no accessible second
account; sign-out was not accepted as equivalent. The consented real camera-only check
then completed: preview, rejection guidance, eight automatic samples and overlay frames
were recorded, and the participant confirmed the landmark dots tracked their face.
The microphone stage was not acknowledged. Production state remained readable and
unchanged, with no diagnostic trace or raw-media artifact. A false combined cleanup
flag was later traced to the normal-close `finally` branch destroying an already closed
Tk root. Both harnesses now avoid that second destroy. The worker wait was independently
raised from five to fifteen seconds to cover the readiness probe's twelve-second bound.
Automated validation remains **83/83** plus strict mypy across 12 modules. Fresh consent
is required before the next boundary, real microphone/voice validation.

The voice-only validation harness is prepared without opening a device. It runs the
production voice routine in a disposable process, never enters the camera path and
requires live waveform evidence, participant confirmation, three English prompt/take
acceptances and at least one deliberate quality rejection. The resulting reference is
discarded; unchanged production storage/authority, no new raw media and complete
cleanup are mandatory. Its missing-model and child-process smoke paths pass without
device access. Immediate microphone consent is still required before launch.

Two consented voice-only attempts entered the microphone stage, showed waveform and
rejection behavior, and never entered the camera path, but neither completed Take 1:
the structured retry recorded one prompt take and zero accepted takes before a generic
child error. Its child and wrapper stopped; the separate UI cleanup error proved the
double-destroy harness defect described above. The child now returns only allow-listed,
secret-free failure categories so a further approved attempt can distinguish exhausted
quality attempts from timeout or device/runtime failure. Three accepted voice takes
remain unvalidated.

## Latest boundary — storage diagnosis and real lock check, 2026-09-03

The [diagnosis record](storage-incident-diagnosis.md) distinguishes the unexplained
original post-publication index incident from a reproduced and fixed pre-publication
reader/replacement race. Final suite: **75/75 pass**, strict mypy across 12 modules,
1,000 stress iterations pass; both required reviews report zero actionable findings.
The authorized actual workstation-lock check passed with synthetic references,
cancelled capture, no fixture profile committed and successful cleanup. Actual
account switching and biometric-worker interruption remain unvalidated.
Read-only before/after checks confirm the production state stayed unchanged.
No reset, capture, firewall change, later ticket, commit or push. Ticket 02 remains
incomplete; the original incident, real-device amendment validation and timing are
still open. Earlier sections below retain their historical validation counts.

## Latest boundary — approved UX amendment, 2026-09-03

The completed grilling agreement is implemented in the existing Ticket02: masked/eye/
copy code and copy-gated completion, automatic face quality/stability checks with real
landmark dots, three English voice phrases, waveform A and audio-quality rejection.
Existing ownership/storage and Windows integration are retained. No Ticket03 code or
iOS refactor. [Development thresholds](README.md#development-quality-policy--not-biometric-acceptance)
are explicitly uncalibrated on actual people/devices.

**72/72 automated tests pass**, no skips/expected failures; strict mypy2.3.1 passes12
application modules; compilation and scoped whitespace checks pass. Standards and
Spec reviews each have zero remaining actionable amendment findings. Two review
regressions (vertical face geometry and Copy re-enabling Complete while saving) were
observed failing and fixed. Public capture/UI tests use synthetic device/model/clock
inputs, not consented biometric data. The actual pinned face/voice models are unchanged.

No real device, Windows prompt, firewall or production-state action occurred during
this amendment. Existing owner/profile remain. New real validation needs separately
agreed consent and must not delete/bypass the protected owner. The earlier real-session
index inconsistency remains open; timing and actual lock/account-switch evidence are
still missing. The explicit lock harness cleanup/result-binding findings were fixed
and both reviewers cleared it; it was compiled, not run. It supplies no new real-lock
evidence. Ticket02 stays ready-for-human/incomplete.
No commit/push. Earlier dated sections below remain historical evidence.

## Current boundary — 2026-08-31

**Ticket 02 is incomplete; real enrollment remains session-gated.** Administrator
installation/setup is now explicitly approved. Normal operation must remain
unelevated. The implementation uses a machine registry authority and a one-shot
setup publisher, not a service. No later ticket or hardware work is included.
The 2026-08-30 sections below are preserved history; their unapproved-installation
question and expected-failure counts are superseded by this section.

### Continued non-capture implementation — 2026-09-03

After confirming that the Windows cancellation path safely returned non-verification,
the user instructed continuation of Ticket 02. Production UI B now drives the same
`Enrollment` state machine exercised by storage tests: explicit session consent,
fresh Windows verification, guided face then voice reference collection, one-time
recovery-code display, offline-save acknowledgement and protected completion. The
UI does not decide enrollment success. Setup navigation stays locked while the code
is displayed so the only shown copy cannot be accidentally hidden behind a false
fresh-setup surface. Completion/cancellation clears it from the widget.

`capture.py` is the concrete local enrollment adapter. It runs OpenCV, Vosk and
sounddevice in a disposable unelevated child process only after consent and
Windows success. Cancellation or the outer deadline terminates that child, so a
blocked device call cannot retain the enrollment operation. It requires the exact
pinned model set, collects eight normalized SFace observations from one visible
face, then a bounded Vosk speaker vector from 16 kHz mono input. It writes no raw
image/audio file and returns only bounded reference bytes to encrypted storage.
Camera release is guaranteed after its capture loop. The worker waits for the UI
to acknowledge each active indicator before opening that device; a display failure
prevents activation. Bounded PNG preview frames cross child IPC into a memory-only
Tk image during face capture and are cleared at idle, cancellation or result; no
raw preview or audio file is written. Device and model behavior is controlled in automated
tests; no real device stream was opened in this implementation phase.

The normal launcher now supplies its actual top-level HWND, process-token SID,
Windows verifier, capture adapter and profile directory to one enrollment workflow.
`SessionGuard` subscribes the application window to Windows session notifications.
Lock, sign-out, console/remote disconnect and system end-session messages set the
shared cancellation event on every newly armed operation. UI result epochs prevent
a queued recovery code from reappearing after interruption; tests verify pending
setup is cancelled and a shown code is cleared. Actual workstation lock/fast-switch behavior has not yet
been performed as a disruptive integration test.

The two selected Vosk archives were acquired from the official publisher on
2026-09-03. Archive SHA-256 values and deterministic extracted-tree digests are
frozen in the [installation record](README.md#model-sources-and-provenance).
Readiness rejects incomplete, modified or extra model-tree content. Both OpenCV
models and both Vosk models loaded successfully from ignored scratch storage in the
pinned environment, without device access. This establishes artifact compatibility,
not biometric performance. The scratch model copy is not a committed distribution.

Current automated validation: **62/62 tests pass** with no skips or expected
failures; strict mypy passes all **12 application modules**. A readiness run in the
pinned environment verified all model bytes, exact package versions, two enumerated
camera interfaces and one microphone interface while capture stayed off. No real
B.G.D capture/enrollment, production authority installation, offline-disconnection
test or five-minute setup measurement occurred. Ticket 02 remains incomplete and
Required Standards and Spec rechecks report zero actionable findings. At this
pre-session boundary, real enrollment was blocked in the default launcher pending separately agreed
participant/access/retention/deletion terms. Ticket 03 remains untouched; no commit
or push was performed.

### Real owner enrollment — 2026-09-03

The user specifically authorized one real face/voice enrollment with encrypted
biometric data agreed for deletion on **2027-01-01**. The disclosure limits
access to the current Windows account and local administrators, describes the
memory-only face preview and audio processing, and promises no raw-media files.
The production HKLM authority was installed through the explicit administrator
setup entry point. The B.G.D desktop process itself stayed unelevated.

A read-only recheck on 2026-09-05 found no matching Windows scheduled task, startup
command or Codex automation. The earlier ticket note claiming an active deletion task
was therefore unsupported and is corrected below. After immediate approval, a current-user
limited task named `BGD.PCBiometricDesk.DeleteEncryptedProfile` was registered for local
midnight on 2027-01-01 with StartWhenAvailable. Its inline action contains an independent
date guard and deletes only the profile directory. A guarded pre-date execution returned0;
the encrypted profile and models remained present. The protected HKLM authority is not a
target, so scheduled deletion leaves enrollment closed.

The dedicated pinned Python executable was blocked from outbound network access
by a temporary Windows Firewall rule for the enrollment run. The rule was verified
active before launch and removed successfully afterward; no rule remains. Windows
verification, real camera capture with the bounded live preview, real microphone
capture, offline-code acknowledgement and protected publication completed. Exactly
one authority generation and one encrypted profile payload were committed. No
recovery code, account identifier, biometric bytes or verifier was printed or
exported by validation.

The first post-run public load exposed a fail-closed consistency incident: the
HKLM authority and its exact-digest encrypted payload agreed, while the redundant
DPAPI local ownership index still contained the earlier empty reservation. No
second owner or profile existed. A real two-process probe confirmed the operation
file lock excludes a second holder. A one-time unelevated repair verified the
protected owner, payload digest, encrypted structure and current account, then
rewrote only the local index to the already committed protected generation. It did
not alter the authority, profile payload, biometric references or recovery verifier.
The public load now succeeds and authority/local metadata agree.

Post-run inspection reports bounded nonempty face and voice references, zero raw
image/audio files, zero pending files and only the operation lock plus the two
expected encrypted state files. The preview implementation and exact session-term
gate have **62/62 automated tests** and strict mypy passes all 12 modules; focused
Standards and Spec rechecks report zero findings. The unexplained stale-index event
prevents describing this as a clean first-pass storage result. Reliable launch-to-
completion timing and an actual workstation lock/account-switch interruption were
not captured, so those acceptance items remain open. No Ticket 03 work began.

### Consented Windows verification test — 2026-08-31

The user subsequently approved the **Windows account-verification test only**.
This supersedes the earlier no-real-Windows-test statements for that narrow test;
it does not authorize B.G.D camera/microphone capture or biometric enrollment.
The explicit [test harness](../../tests/windows_verification_validation.py) calls
the existing desktop HWND adapter on a worker thread from a normal, unelevated
process. Credentials stay in the real Windows dialog. The test window explains
that its enrollment-related Windows message does not initiate enrollment.

Observed native results (seconds measured from adapter invocation):

| Attempt | Requested action | Adapter Boolean | Same process account | Unelevated | Seconds | Interpretation |
| --- | --- | --- | --- | --- | --- | --- |
| 1 | Cancel | True | Yes | Yes | 4.666 | Windows returned Verified; cancellation was not exercised |
| 2 | Cancel, after adding an explicit Start button | False | Yes | Yes | 2.020 | Non-verification observed; native cancellation reason is not exposed |
| 3 | Complete Windows verification | True | Yes | Yes | 5.879 | Positive native adapter integration passed |
| 4 | User-requested cancellation retry | False | Yes | Yes | 1.620 | Expected non-verification observed again; native reason remains unexposed |

The operator reported being pretty sure they selected Cancel in attempt 2 and
requested another cancellation test. Attempt 4 returned the expected False result
and exited 0; no application or harness change was needed. This records the
operator's qualified recollection separately from the observed API result rather
than requesting repeated confirmation. The Boolean adapter collapses cancellation, refusal,
unavailability and other non-success outcomes, so False alone is not evidence of
the native Canceled enum. The initial harness's `expected_outcome_observed` label
was too broad; review changed it to `expected_boolean_observed` and explicitly
marks the native cancellation reason as unavailable. Review also found and fixed
a timeout/reporting race by cancelling the timer after a completed result and
ensuring timeout exits with failure. These harness-only fixes did not change the
application adapter or require another authentication attempt.

The harness records only result/status, elapsed seconds, account equality and
elevation booleans. No account SID, username, PIN, Windows credentials, raw media,
biometric reference, recovery code or profile was recorded by this test. No
production authority was installed or changed. The Windows sign-in method was
not inspected; Windows may use its configured Hello camera. This is distinct
from B.G.D capture, which remained off. Windows-managed security records are
outside the harness's data handling.

No network configuration was changed or disconnected, so **offline Windows
verification is not yet demonstrated**. Unchanged process account before/after a
prompt does not validate session switching, session-lock interruption or binding
the full enrollment workflow to the installed designated owner. Guided UI B,
capture/model adapters, session integration and end-to-end setup acceptance remain
unfinished. No five-minute setup or biometric/security acceptance is claimed.

Final checks: **44/44 automated tests pass in 5.905 seconds**, with no skips or
expected failures; strict mypy passes all **11 application modules**; the explicit
harness compiles. Standards and Spec each report **zero remaining findings** in
the focused recheck. The real dialog attempts are separate manual integration
evidence, not additional unattended unit-test passes. Ticket 02 remains incomplete
and production enrollment disabled. No Ticket 03, hardware work, commit or push.

To repeat only after explicit Windows-test consent, from a normal shell:

```powershell
python tests/windows_verification_validation.py cancel
python tests/windows_verification_validation.py verify
```

Each invocation has its own Start button. For the cancel attempt, record the
operator's action separately; exit 0 confirms the expected Boolean only. Closing
before a result or timing out is not a pass. No B.G.D enrollment or capture is
called by either command.

On 2026-09-03, at the user's request, the unchanged cancellation harness was run
again. It returned **False in 4.847 seconds**, with the process account unchanged,
the process unelevated and exit 0 for the expected Boolean. This is another
observed non-verification result; the adapter still does not expose the native
cancellation reason. No B.G.D capture, enrollment or production state was used.
The user then requested another run, selected **Cancel** in the opened Windows
dialog and explicitly confirmed that action. The adapter returned **False in
8.013 seconds**, with unchanged process account and unelevated operation. Together,
the operator-confirmed action and the measured non-verification result demonstrate
that this cancellation was rejected safely. The program still cannot distinguish
the native reason from its Boolean alone; no stronger enum-level claim is made.

### Protected ownership implementation

- `authority.py` separates the 64-bit `HKLM\SOFTWARE\BGD.PCBiometricDesk` record
  from all user-writable files. Its intended owner/group is Builtin Administrators;
  its protected DACL grants SYSTEM/Administrators full access and Users read access.
  Reads and writes verify that exact descriptor. **Actual HKLM enforcement passed
  isolated machine integration tests on this PC.** HKCU injection exists only for isolated
  automated fixtures; no launcher option selects it.
- Explicit administrator setup creates a random installation identifier and pins
  the designated account SID. Repeating installation preserves existing committed
  ownership; a different owner, absent authority during normal operation or damaged
  authority cannot trigger an implicit reset. `setup_authority.py` is the explicit
  installer entry point, not a startup task or a Windows authentication substitute.
- The native registry writer serializes installation/publication with an
  administrator-owned named mutex. Registry case aliases share that mutex.
  A complete record is written with `SetValueEx` and flushed before success.
  A read-only transacted-registry experiment returned `ERROR_RM_NOT_ACTIVE` (6801)
  on this PC; no Windows repair was attempted and the implementation does not
  depend on registry transactions. Process-crash tests are not power-loss proof.
- Actual user DPAPI still protects references, code verifier and local control
  data. Local files are candidates until the machine record commits their exact
  generation/digest. Enrollment preserves the original installation identifier
  throughout code saving and rejects a replaced installation. Completion rereads
  the exact authority record and decrypts/checks the payload before reporting
  enrollment; an alleged helper success alone is insufficient.
- `publication.py` runs only a fixed, inline metadata writer in Windows system
  PowerShell during explicit setup completion. It does not elevate Python, load a
  user script file, open a supplied data path, capture, prompt for Windows identity
  verification, install a service or override execution policy. Profiles/modules
  from user search paths are excluded. Only installation ID, designated SID,
  generation, ciphertext digest and operation-marker names cross this boundary;
  no reference, raw input, code or code verifier does. Normal app launch refuses
  elevation. UAC authorizes this administrator write; it is **not** fresh owner
  authentication and does not replace the enrollment workflow's Windows check.
- `coordination.py` shares two Windows event handles with the publisher: a fixed
  busy marker for the installation and a unique marker for that attempt. The
  helper opens fixed then unique without creating either. If it survives the
  parent or a wait failure, its handles keep new setup blocked. If the parent dies
  before handoff, the old unique marker is absent and delayed publication fails.
  The markers coordinate work; the HKLM record remains the ownership authority.
  A stuck helper yields `busy`, never an ownership reset. The STA wait pumps COM
  and window messages rather than assuming that closing a process handle kills it.

This code currently expects setup elevation under the same designated Windows
account; an alternate administrator account is refused rather than silently
rebinding ownership. A standard-only account using another administrator's
credentials is not a demonstrated supported setup path. Installation/bootstrap
requires reviewed, trusted source. The inline writer also relies on the approved
intact-verifier/OS assumption; it does not attest an arbitrary caller or resist an
administrator deliberately rewriting the machine authority.

### Automated evidence and required next action

On 2026-08-31, `python -m unittest discover -s tests -v` passed **44 tests**, with
**no expected failures or skips**. Strict mypy 2.3.1 passed all **11 application
modules**. The original all-user-state deletion and pre-enrollment rollback tests
now pass with a separate real HKCU fixture authority; their required outcomes were
not weakened. Other regressions cover malformed/missing authority, reinstallation,
concurrent publication, installation replacement, cancellation, actual subprocess
death at write boundaries, and parent death before/after a separate helper handoff.
Tests use actual DPAPI, filesystem operations and Windows locks/event handles.
Windows verification, capture and UAC success are controlled external outcomes.
An actual unelevated PowerShell run exercised wrong-account rejection only.

After the user approved retrying the canceled UAC launch, **three explicit machine
tests passed in 2.149 seconds**. They create unique
`BGD.PCBiometricDesk.Validation.*` HKLM keys with the application descriptor and
use the actual unelevated coordinator's primary token for access checks/storage.
They verify normal reads, denial of authority modification/deletion/ACL takeover,
metadata publication, replaced-installation rejection, and fail-closed enrollment
after deleting or rolling back all user-writable state. Reinstallation preserves
committed ownership. Ordinary test discovery intentionally excludes this suite.

The first approved run failed because the fixture's linked token produced invalid
impersonation-level errors and its administrator-created data directory denied
normal access. The corrected fixture verifies a same-account, unelevated primary
token from the live normal coordinator and creates user data under that token.
**No application ACL was relaxed.** An unavailable or unsuitable token fails the
test rather than skipping it. Successful runner output is retained in
[the machine-validation log](../../.scratch/pc-biometric-desk/machine-validation.1aa59d4f242c459290185b7dfaaf0ac3.log);
its matching `.exit` file contains `0`.

Run the reviewed runner from a **normal PowerShell shell** at the repository root;
it requests UAC for the isolated test host and keeps the normal coordinator alive:

```powershell
.\tests\run_machine_validation.ps1 -PythonPath 'C:\Users\zvent\AppData\Local\Programs\Python\Python313\python.exe'
```

The runner uses system Windows PowerShell without changing execution policy.
Launching the machine test directly from an administrator shell is insufficient:
the fixture needs the normal coordinator token, not an assumed linked token.

An additional explicit test, `python tests/uac_handoff_validation.py`, passed
**one test in 10.851 seconds** from a genuinely unelevated Python process. It uses
the application's actual ShellExecuteEx/UAC/PowerShell/COM-wait publication path
against a unique HKLM fixture, verifies committed enrollment with synthetic
references, confirms the caller remains unelevated, and rejects deletion/replay of
user state. This closes the gap between thread impersonation and the real process
handoff. A temporary administrator fixture installs/removes only that test key;
its clean exit and key removal are asserted. Its privileged Python bootstrap is
test infrastructure, not the application's metadata-only publisher.

All **four native tests passed**, with real DPAPI, registry permissions and UAC but
controlled Windows-verification success and non-biometric reference bytes. No
camera, microphone or Windows identity-verification prompt was invoked. The
production authority was not installed and its permissions were not changed.
These checks establish the tested authority behavior on this PC, not biometric
quality, resistance to a malicious administrator, power-loss safety or full ticket
acceptance. The explicit production installer remains unexecuted here.

Required independent review: Standards and Spec each report **zero new actionable
findings** after reviewing the fixture correction and actual UAC handoff test.
Earlier lifecycle/cancellation findings remain fixed. Final ordinary validation
was rerun: **44/44 tests pass; strict mypy passes all 11 application modules**.
Both reviewers keep ticket acceptance incomplete; neither review substitutes for
real enrollment evidence.

With the machine boundary tested, ticket 02 still needs guided UI B enrollment,
real capture/model/reference adapters, Windows session-interruption wiring and
their tests. No completed camera/microphone pipeline or five-minute setup result
is claimed. **Ask before any real camera, microphone, Windows-verification or
biometric-enrollment validation**, with the exact devices/tools, participants,
access and deletion dates agreed. No real session occurred in this continuation.
Tickets 03–08 remain untouched, and no commit or push was performed.

Platform references:
[registry access/security](https://learn.microsoft.com/en-us/windows/win32/sysinfo/registry-key-security-and-access-rights),
[registry flushing](https://learn.microsoft.com/en-us/windows/win32/api/winreg/nf-winreg-regflushkey),
[system mutex security](https://learn.microsoft.com/en-us/dotnet/api/system.security.accesscontrol.mutexsecurity),
[COM wait flags](https://learn.microsoft.com/en-us/windows/win32/api/combaseapi/ne-combaseapi-cowait_flags),
[process creation while impersonating](https://learn.microsoft.com/en-us/windows/win32/secauthz/impersonation-levels).

## Historical implementation — 2026-08-30

Date: 2026-08-30. **Incomplete; not accepted; production enrollment disabled.**
This supplements [ticket 02](../../.scratch/pc-biometric-desk/issues/02-owner-enrollment-storage.md),
not a replacement specification, ticket or approved decision.

## Implemented development workflow

`Enrollment.start`, `complete`, `cancel` and `status` are tested through the
approved public boundary with **non-biometric synthetic references** and controlled
account/Windows outcomes. No real Windows prompt or capture adapter is wired in.
The desktop UI continues to expose only readiness and disabled protected actions.

Implemented behavior:

- Specific-session consent is required before the development workflow calls the
  supplied Windows-verification or capture boundary. A Boolean in fixture code is
  not itself a real participant-consent protocol.
- Fresh successful Windows verification precedes capture. The account is checked
  before/after verification, after capture and before saving. Tests cover account
  switching and failed/unavailable verification, not an actual Windows identity.
- Both nonempty reference payloads and acknowledgement of saving the recovery
  code are required before committing. Actual model/reference quality remains
  unimplemented; nonempty synthetic bytes prove no biometric property.
- A code generated from 32 random bytes using Python `secrets` is shown once in the
  returned result. Only its SHA-256 verifier is stored inside the encrypted profile.
  This is a high-entropy code, not a human password; guessing controls still belong
  to ticket 06. Result/reference representations omit secrets. Nothing copies the
  code to the clipboard, writes it to a log or pretends to verify physical saving.
- Actual Windows user-scoped DPAPI encrypts and integrity-protects the payload and
  separate ownership record. Native DPAPI buffers are cleared before freeing them;
  this does not promise erasure of Python/OS memory copies, swap or crash dumps.
- Encrypted payloads are written and flushed before the encrypted ownership
  record atomically selects their digest/generation. The ownership replacement is
  the commit point. No raw capture or plaintext template is written by this code.
- Interrupted initial setup retains a reservation bound to the same account;
  another account cannot take it over. Individual missing/corrupted ownership or
  committed payload files close setup. A process crash releases the Windows file
  lock but does not erase that reservation.
- Windows file locking excludes competing application instances. An in-process
  transition lock also serializes completion/cancellation. Once saving begins,
  cancellation waits for its outcome and does not report a completed save as
  undone. Before saving, cancelled and late results cannot publish a usable pending
  enrollment. Real stream interruption still requires a cooperative device adapter.
- Elapsed time is measured for completed development setup. There has been no
  measurement of the five-minute owner enrollment requirement.

The store is a development implementation, not an accepted security boundary.
It creates no ordinary-action authorization and implements no later-ticket flow.

## Demonstrated blocking failures

`tests/test_enrollment_security.py` retains two **expected failing acceptance
assertions**, using temporary directories and synthetic data:

1. Commit enrollment, delete **all** application-owned state, then reopen. The
   development store reports `not-enrolled` instead of remembering that setup
   must stay closed.
2. Commit enrollment, restore the earlier encrypted pre-enrollment reservation
   and remove newer payloads, then reopen. Setup also reopens.

These tests are marked `unittest.expectedFailure` so the known gaps are explicit
in the development test report. **An `OK (expected failures=2)` test-run summary
is not a security pass or permission to resolve this ticket.** Do not remove these
tests, change their required outcomes or waive them to advance the dependency graph.

DPAPI establishes confidentiality/integrity relative to a Windows account. It does
not create an independent record that the application was previously enrolled,
nor an independent monotonically advancing generation. Another process controlling
the same account can manipulate the files, and moving them to another user-writable
folder or HKCU registry value alone does not establish a new authority.
[Microsoft DPAPI documentation](https://learn.microsoft.com/en-us/windows/win32/api/dpapi/nf-dpapi-cryptprotectdata)
describes its account-based scope and integrity protection; it does not promise
this application's anti-deletion or anti-rollback policy.

The approved spec requires demonstrating the actual ownership/storage boundary
and forbids missing/damaged state from reopening unrestricted setup. It assumes an
intact OS/verifier, but does **not** explicitly exclude all same-account state
tampering. We have not invented that exclusion.

## Concrete decision required before extending this implementation

May PC installation require administrator privileges to establish a **separate
protected ownership authority**, potentially a small Windows service, while normal
use stays unelevated?

That option adds installation, updates, permissions and maintenance consequences
which were not selected in the approved PC plan. It is a candidate, **not a claim
that adding a service alone solves rollback**. Its privileged state, IPC access,
generation protocol, crash consistency and first-install behavior would still need
implementation/review/tests. No service, scheduled task, elevation request, ACL
change, persistent Windows credential or machine registry installation was made.

The alternative cannot be silently weakening the approved requirement. If a
privileged installation is not acceptable, an adequately protected native-platform
authority must be demonstrated before enrollment is enabled; inability to do so
is a feasibility blocker, not a successful implementation.

## Validation and next boundary

The full development suite currently has **18 passes and two known expected
security failures**. Strict mypy 2.3.1 passes all six application modules. Tests use
actual DPAPI, local atomic file replacement and Windows process file locking;
account/capture decisions are synthetic. One subprocess exits without cleanup to
exercise crash/restart behavior. Files inspected in the normal synthetic commit
contain neither plaintext fixture references nor the generated code.

Two independent review axes identified and fixed: inaccurate readiness platform
reporting; cancellation releasing the lock during commit; a late account callback
resurrecting cancelled setup; and capture starting after an already completed
cancellation callback. Regression tests cover these cases. The independent
ownership-authority failures remain open. Physical power-loss behavior, complete
transition fault injection, actual cross-account DPAPI/ACL isolation, installed
Windows prompt behavior and raw-capture/crash cleanup remain unvalidated.

For non-capture integration preparation, the 18 pinned model/runtime packages
were installed into `.scratch/pc-biometric-desk/.venv` using CPython **3.13.12**.
OpenCV, Vosk, sounddevice and the WinRT credentials namespace imported successfully
without opening capture or authentication. No model weights were downloaded and
no biometric data was collected. This ignored environment is disposable tooling,
not a committed artifact or reproducible offline distribution bundle.

After the ownership authority is resolved, complete the actual Windows desktop
HWND verification bridge, capture/model/reference validation and UI enrollment
integration. Before real sessions, agree the precise local tools/device paths,
affected people, access and deletion dates and obtain specific consent. None of
the historical retention suggestions become defaults. Real session consent is
separate from permission to implement the software.

Ticket 02 stays incomplete. Tickets 03 and 06 remain blocked by it; therefore no
other implementation branch is unblocked. Tickets 03–08 have not been started.
No aircraft issue, hardware plan or future milestone was changed by this work.

## Resumed ticket-02-only work — 2026-08-30

The user instructed completion of ticket 02 followed by a stop. No later ticket
was started. This instruction does not supply the separate real-session consent
or explicitly select the privileged installation described above. That decision
was requested again while continuing independent, non-privileged implementation.

`pc_biometric/windows.py` now implements the Windows desktop HWND bridge using
the platform's `IUserConsentVerifierInterop`, without an extra dependency or
collecting Windows credentials. It reads the process token's SID rather than
trusting an account display name or environment variable. The requested window
must belong to this process before the request and still exist when the result
returns. Only completed `UserConsentVerificationResult.Verified` is accepted;
request initiation, cancellation, error and unknown results are not success.
The bridge and enrollment can share a cancellation event so late Windows success
cannot resume cancelled setup. Account-provider failures in `status()` now produce
a sanitized unavailable result while preserving existing enrollment.

New tests exercise **the public enrollment workflow**, replacing the Windows COM
service at its native system boundary. They do not mock the application verifier
or claim actual user authentication. The native process-SID reader, Tk window
handles and DPAPI remain real. Tests cover every documented Windows result,
unknown results/statuses, cancellation and window destruction. No test sends a
real verification request or captures a person. These tests cannot prove the
prompt's account binding, offline behavior or Windows Hello freshness.

A separate **read-only native probe** successfully acquired both the Windows
availability interface and desktop interop interface. `CheckAvailabilityAsync`
completed with enum `0` (Available), including real async-interface querying,
result retrieval and release. It did **not** call
`RequestVerificationForWindowAsync`. Availability is not successful authentication.

The adapter remains disconnected from the production launcher. Before connection,
the real UI must supply its top-level HWND, run verification off the Tk thread,
and invalidate the shared event on window close and Windows session interruption.
The SID alone does not detect workstation locking or fast user switching:
Windows session notifications are still required. Real capture/model/reference
validation and guided enrollment UI remain incomplete behind the storage gate.

Current validation: **26 development tests pass; two known ownership-security
requirements remain expected failures**. Strict mypy passes seven modules.
The earlier 18-pass count describes the preceding work, not this resumed run.
No privileged component, permission change, actual Windows prompt, model download,
biometric session, commit or push was performed. Ticket 02 is still incomplete.

The continuation's required two-axis review found one additional cancellation
defect: setting the shared event while the recovery code was displayed did not
prevent completion. It is fixed, with red/green regressions for that interruption
and for interruption during the final account check. Both reviewers rechecked the
fix; Standards reported zero findings and Spec no additional defect in the scoped
recheck. Spec acceptance remains blocked by the ownership-security failures and
missing real integrations. Once the actual storage commit begins, cancellation
does not promise to undo it; the committed state remains the source of truth.

Platform sources for the implemented ABI:
[desktop HWND verification](https://learn.microsoft.com/en-us/windows/win32/api/userconsentverifierinterop/nf-userconsentverifierinterop-iuserconsentverifierinterop-requestverificationforwindowasync),
[Microsoft interop header](https://github.com/microsoft/win32metadata/blob/main/generation/WinSDK/RecompiledIdlHeaders/um/UserConsentVerifierInterop.h),
[async interface header](https://github.com/microsoft/win32metadata/blob/main/generation/WinSDK/RecompiledIdlHeaders/winrt/asyncinfo.h),
[WinRT parameterized interfaces](https://learn.microsoft.com/en-us/uwp/winrt-cref/winrt-type-system).

## Deliberate voice-enrollment amendment — 2026-09-05

The approved UI B voice step now waits for automatic room measurement, then shows the
English phrase in large persistent type and enables Hold to record. Mouse or Spacebar press
starts capture and release stops it. The microphone closes before memory-only Play back,
Submit or Record again. Accepted/rejected results wait for Continue/Try again; a clear
rejection reason remains visible, only the current take is retried, and earlier accepted
takes remain. Raw recording bytes are wiped on submit/rerecord and process termination
clears them on cancellation/close. The10-second recording and three attempts per phrase
remain fail closed; waiting screens cancel after60 seconds of inactivity and the complete
enrollment session is bounded to five minutes.

Real automatic-flow evidence before this correction accepted take one and reached take two,
then exhausted attempts with background-noise and phrase-mismatch guidance. Cleanup passed,
storage remained unchanged and no raw media was created. Passing real evidence
still requires a deliberately unusable submission with a persistent allow-listed reason, three
accepted takes, observed live waveform and playback behavior, unchanged protected storage, no raw media
and complete cleanup. Fresh participant consent is required immediately before that run.

After correcting Spacebar release, mixed-quality reason persistence and the parent/UI
deadline edge, **93/93 device-free tests pass**. Strict mypy2.3.1 passes12 modules;
compilation and scoped whitespace checks pass. Read-only production inspection reports a
committed, readable profile with diagnostics disabled, no trace and zero raw-media files.
Final independent Standards and Spec reviews each report zero actionable findings.

The first real run of these controls confirmed waveform response, accepted one take and
reached take two before the90-second budget expired. It displayed persistent
`background_noise` and `too_quiet` rejection categories; storage remained unchanged, no raw
media appeared, and all cleanup passed. Because real ambient input can make intentional
silence correctly produce several fixed quality categories, validation now requires a
deliberate rejection with any persistent allow-listed reason instead of only
`insufficient_speech`. Three accepted takes remain required and unvalidated.

A second manual-flow run again accepted one take and reached take two before the former
90-second deadline. It also proved submitted rejection with persistent `too_quiet` guidance,
waveform, memory-only playback, both participant confirmations, camera off, unchanged state,
no raw media and complete cleanup. The user approved replacing that deadline with60-second
waiting-state inactivity cancellation and the five-minute complete-enrollment limit. The
five-minute timer covers Windows verification, capture and recovery-code waiting, clears an
expired displayed code, and stops before protected publication begins. Recording and attempt
bounds remain10 seconds and three attempts per phrase.

Current device-free validation after the timeout change is **96/96 tests**, strict mypy2.3.1
across12 modules, and successful compilation/scoped whitespace checks.
