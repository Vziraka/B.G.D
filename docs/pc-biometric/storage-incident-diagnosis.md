# Ticket 02 storage diagnosis and interruption evidence — 2026-09-03

## Final incident disposition — closed, unreproduced after bounded investigation

The original post-publication local-index mismatch is closed for Ticket02 after repeated
synthetic workflows, a complete traced real enrollment and a healthy fresh-process public
load did not reproduce it. The historical failure remains recorded below. Its cause is
unknown and is not attributed to the distinct reproduced/fixed Windows reader-replacement
race. Any future authority/local-index/payload mismatch reopens this incident immediately.

## Fresh-process reopen and final cleanup — 2026-09-05

A separately approved unelevated app process reopened the committed state. The participant
confirmed Setup recognized the existing owner and kept first-time setup disabled; no capture
or Windows verification ran, and the process exited0. A following public-store load again
matched the protected authority/current account.

Final artifact inspection found one non-plain-JSON ciphertext payload, zero raw media, zero
pending files and no remaining secret-free diagnostic trace. Diagnostics are off, no B.G.D.
process or temporary firewall rule remains, and the 2027-01-01 deletion task is Ready. The
historical inconsistency did not recur during the instrumented complete enrollment or this
fresh-process reopen. Its closure is an evidence-based unreproduced disposition, not
attribution to the separately fixed Windows reader race.

## Complete traced offline enrollment passed — 2026-09-05

With immediate approval, the pinned application executable was temporarily blocked from
outbound network access across all Windows Firewall profiles. The unelevated app completed
Windows verification, real face/voice capture, recovery-code Copy/save acknowledgement and
protected publication in **222.144 seconds** of conservative launch-to-close wall time. The
temporary firewall rule was removed and verified absent afterward.

The committed authority belongs to the current account and agrees with the public-store
load. One non-plain-JSON ciphertext profile exists, with zero raw media and zero pending
artifacts. All14 trace records use the fixed allow-listed schema; reservation, payload write,
local index write, protected publication and final confirmation each have successful records,
while no failure record exists. Therefore the historical storage inconsistency did not reproduce.
This clean run supplies evidence but does not prove the unknown historical cause. The incident
was kept open through the separately approved fresh-process reopen and final trace cleanup.

## Approved reset/reprovision boundary — 2026-09-05

After the real capture and interruption checks, the user immediately approved destructive
production reset. The encrypted profile/recovery generation was permanently deleted. The
PowerShell registry provider was denied removing the protected key, so the committed authority
initially kept setup closed. Replacing only that operation with Python's native64-bit registry
API succeeded, and the explicit administrator installer created a new uncommitted authority.

Final read-only checks show no profile directory, a readable authority with empty profile and
digest, a Ready 2027-01-01 deletion task and an unelevated normal process. The one-time reset
script and secret-free step log were removed. This intentional reprovision is not a reproduction
of the historical post-publication inconsistency; that incident remains open for the next
traced enrollment/reopen boundary.

## Real microphone interruption cleanup — 2026-09-05

The participant closed a freshly consented voice-only validation while recording was active.
The microphone stage and live waveform were observed, the camera stage was absent, and no
take was accepted. The early result was the expected cancellation category rather than the
five-minute timeout. Child, wrapper and UI cleanup all passed; storage/authority remained
unchanged and no raw media was created. This evidence does not exercise publication and does
not close or explain the historical storage incident.

## Deletion-schedule evidence correction — 2026-09-05

Read-only inspection found no Windows scheduled task whose name or action references B.G.D.,
the profile or 2027-01-01; the verbose `schtasks` inventory, startup commands and local Codex
automations also contained no match. The profile is still present. The earlier ticket claim
that an active one-time deletion task existed lacked current system evidence and is withdrawn.
The user's 2027-01-01 deletion instruction remains authoritative.

After immediate approval, `BGD.PCBiometricDesk.DeleteEncryptedProfile` was registered as a
current-user, limited-privilege one-time task for local midnight on 2027-01-01. It has
StartWhenAvailable enabled and an independent date guard. Inspection confirms the action
targets only the absolute profile directory, not models or HKLM authority. A guarded pre-date
run returned0 and preserved both the current profile and model state. The task's next run is
2027-01-01 00:00 local; deleting user-writable profile state while retaining the protected
authority leaves enrollment closed.

## Complete real voice-control validation — 2026-09-05

A freshly consented voice-only run passed every harness gate: microphone stage entered,
camera stage absent, waveform observed and confirmed, playback used and confirmed, one
submitted rejection with persistent `too_quiet` guidance, and three prompted/accepted
English takes. Child, wrapper and UI cleanup all passed. Protected/profile/diagnostic state
was unchanged and no raw media was created. Because this harness intentionally does not
publish an enrollment, the result neither reproduces nor explains the historical storage
inconsistency; that incident remains open pending the complete traced enrollment/reopen
boundary.

## Result and limits before final real validation

At this earlier investigation boundary, the original post-publication stale-index incident
was **not explained or closed**.
Investigation reproduced and fixed a separate pre-publication Windows file-reader
race. These two failures must not be conflated. The existing real enrollment was
not reset, repaired again, replaced or re-enrolled during this investigation.

Read-only checks returned `production_profile_readable=True` before the tests and
`production_state_unchanged=True` afterward. The latter compares an in-memory
snapshot of the encrypted production files and protected authority. No biometric
values, recovery secrets or account identifiers were exported in this record.
No camera/microphone capture, firewall change, UAC setup, Ticket 03 work, commit or
push occurred. The existing 2027-01-01 deletion instruction was not changed.

## Original incident: historical open state

Historical evidence records a committed protected generation and matching encrypted
payload, but the local ownership index retained its empty reservation. Public load
failed closed with `User state does not match the committed ownership authority.`
The earlier one-time exact reconciliation restored loading; it did not establish
the triggering cause. The recorded index timestamp preceded the payload timestamp.

The reproduction loop uses public enrollment start/cancel/complete/status, actual
isolated HKCU authority and DPAPI files, seeded cancelled attempts, delayed
publication, concurrent status reads and a fresh-process reopen. A temporary
negative control deliberately suppressed the candidate local-index replacement;
the loop detected the exact committed-authority/local-index mismatch. This proves
sensitivity to that state, **not a naturally reproduced cause**. The suppression
hook and all tagged diagnostic probes were removed.

Historical execution/source records, repeated public workflows and process-crash
regressions did not reproduce the original post-publication mismatch naturally.
Under the diagnosing-bugs skill, no root-cause claim or speculative repair follows.
The user subsequently approved temporary metadata-only checkpoint tracing of
local-index replacement and authority publication; its ready state is recorded
below. It does not bypass the protected owner or reproduce enrollment by itself.

## Separate reproduced defect and tested fix

Command used for the failing feedback loop, from the repository root:

```powershell
.\.scratch\pc-biometric-desk\.venv\Scripts\python.exe -m unittest discover -s tests -p test_storage_reproduction.py -v
```

Before the fix, concurrent public status reads caused completion to return
`unavailable`, with `authority_committed=False` and `public_profile_readable=False`.
A targeted probe recorded WinError 5 replacing `ownership.bin` while its reader
was open. Removing cancelled starts and the publication delay still reproduced
within the first two iterations; removing the reader passed 100 iterations.
Unlike the original incident, this failure precedes authority publication.

Three ranked, falsifiable hypotheses were presented before probing:

1. A reader blocks Windows file replacement: removing the reader removes the
   failure, and replacement reports a sharing/access error.
2. Status overwrites the reservation: an extra empty-index write would appear.
3. Publication fails independently: removing readers would leave the failure.

The first prediction held. A native delete-sharing reader experiment still returned
WinError 5 while open and succeeded after closing. Consequently the attempted
shared-reader helper was removed. Microsoft's [CreateFileW documentation](https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-createfilew)
describes handle sharing; the actual replacement result here was established by
the local probe, not inferred from that flag alone.

`atomic_write` now retries Windows errors 5/32/33 at 10 ms intervals for at most
approximately one second. Other errors and persistent contention still propagate;
temporary ciphertext cleanup and all authority/digest checks remain intact.
No fallback changes identity state or reopens first enrollment.

Regression coverage uses the public workflow and real open file handles:

- A briefly held reader delays completion, then enrollment and loading succeed.
- A persistent reader fails closed within two seconds, without publishing the
  authority or leaving a pending temporary file.
- Cancelled starts, delayed publication and concurrent status reads complete and
  every committed fixture reopens in a separate process.

The test preceded the fix and failed before it. After the fix, the extended loop
passed **1,000 iterations in 56.105 seconds** using `BGD_DIAG_ITERATIONS=1000`.
The final full suite passed **75/75 tests in 28.541 seconds**, no skips or expected
failures. Strict mypy 2.3.1 passed all 12 application modules. Standards and Spec
reviewers each reported zero actionable findings and independently reran the
three new tests. This is regression evidence for the reader race, not biometric
or original-incident acceptance. A concurrent-reader regression at the public
workflow boundary would have detected this separate defect earlier.

## Actual Windows interruption check

The user authorized interruption checks before any reset. The explicit
`tests/session_lock_validation.py` runner uses a unique HKCU authority, temporary
files, synthetic references and a real `SessionGuard` notification. It runs
unelevated and opens no camera, microphone or account-verification dialog. A Start
button lets the operator choose when Windows locks; unlocking is handled by Windows.

The first window timed out without an accepted lock request. Its result was
`passed=False lock_requested=False interrupted=False cancelled=True
fixture_profile_committed=False cleanup_ok=True`; this is not a passing lock test.
The reopened window was raised briefly to make it visible. That run returned exit 0:

```text
passed=True lock_requested=True interrupted=True cancelled=True fixture_profile_committed=False cleanup_ok=True
```

This proves real workstation locking interrupted the synthetic pending-capture
workflow, cancellation prevented fixture commitment and cleanup succeeded. It does
not prove real biometric-worker cleanup, fast user switching, sign-out or every
durable-commit interruption. Automated cancellation/account-change/process-crash
checks also pass; actual account switching remains untested.

## Ticket boundary — historical pre-validation state (superseded)

This section records the 2026-09-03 boundary and is superseded by the final disposition above.

Ticket 02 remains `ready-for-human` and incomplete. Outstanding evidence includes
the original storage incident, actual account switching, amended real-device
quality/capture behavior and reliable five-minute enrollment timing. Existing
enrollment stays intact. No reset or recovery implementation is authorized by
this diagnosis, and Ticket 03 must not start.

## Temporary storage-step tracing ready — 2026-09-04

`pc_biometric.storage` now has an opt-in JSON-lines trace around reservation,
encrypted payload write, final local-index write, protected publication and
post-publication confirmation. Each step records `started`, `succeeded` or `failed`
with UTC and monotonic timestamps and a process ID. A failed step adds only its
exception class plus numeric Windows/OS error codes. The schema has no field for
paths, account identifiers, installation/profile generations, digests, payloads,
references, images, landmarks, audio, recovery codes or exception messages.

Tracing is off unless `BGD_STORAGE_DIAGNOSTICS=1` is present. When enabled, its fixed
output is `%LOCALAPPDATA%\BGD\PCBiometricDesk\diagnostics\storage.jsonl`; callers
cannot redirect it onto an enrollment file. Use these commands only for the approved
attempt, in the same unelevated PowerShell window used to launch B.G.D:

```powershell
$env:BGD_STORAGE_DIAGNOSTICS = '1' # enable before launching
Remove-Item Env:\BGD_STORAGE_DIAGNOSTICS # disable before the next launch
```

After the trace has been inspected and its evidence recorded, remove the temporary
artifact without touching the sibling `profile` directory:

```powershell
Remove-Item -LiteralPath "$env:LOCALAPPDATA\BGD\PCBiometricDesk\diagnostics\storage.jsonl"
```

Trace creation/write errors are swallowed so diagnostics cannot
change the storage outcome. The implementation is confined to two private helpers
and calls around existing transitions, making it straightforward to remove after
the incident is resolved. It is not enabled for normal operation or by any launcher.

Six focused tests prove: disabled mode creates no diagnostic artifact; enabled and
disabled public workflows produce identical durable state under deterministic test
cryptography and both real-DPAPI workflows commit/reopen consistently; the schema is
allow-listed and representative secrets/identifiers are absent; failed publication
stays closed and logs no exception message; and an unwritable diagnostic destination
or failed timestamp construction does not change successful enrollment. Red tests
first observed the absent trace and the timestamp failure changing the result; both
now pass.

Final automated results: **81/81 tests pass** in 22.694 seconds; strict mypy 2.3.1
passes all 12 application modules; compilation and scoped whitespace checks pass.
The separate Windows reader-race suite passes **1,000 iterations** (three tests in
89.342 seconds), preserving its bounded retry and fail-closed behavior. The trace
was exercised only against unique HKCU/DPAPI fixtures under temporary directories.
The production trace remains disabled and no production diagnostic file was created.
Independent Standards and Spec rechecks each report zero actionable findings after
record-construction containment, differential state coverage and operating/removal
instructions were corrected.

Read-only production checks before and after this work confirm the current profile
is readable and its encrypted files/protected authority are byte-for-byte/state
unchanged. No interactive action ran. The original post-publication mismatch remains
open until a natural failing trace or sufficient real validation evidence exists.

## Remaining real-device validation — historical checklist (completed or waived)

This was the execution checklist before the 2026-09-05 sessions. Items2–8 completed; item1
could not run without a second accessible account and the user explicitly accepted that
unvalidated limitation. It is not a current instruction to reset or reopen devices.

1. Perform an actual Windows account switch while an isolated, synthetic-reference
   Ticket02 setup is pending. Confirm the session notification cancels it, the test
   authority remains uncommitted and cleanup succeeds. This requires an accessible
   existing second Windows account; do not create or modify one implicitly.
2. With new explicit capture consent, exercise the real camera preview, detector
   landmarks, automatic sampling and representative framing/blur/lighting/pose
   rejection guidance without changing the current enrollment.
3. With new explicit capture consent, exercise the real microphone waveform, all
   three English prompted phrases, accepted takes and representative silence/noise/
   clipping/wrong-phrase rejection without changing the current enrollment.
4. Exercise any cancellation/session interruption paths still missing evidence with
   the actual disposable capture worker. The real synthetic-capture workstation-lock
   result already passes; it does not prove real device cleanup.
5. Run one complete offline enrollment from deliberate start through Windows
   verification, face/voice capture, offline-code save acknowledgement and protected
   commit while measuring the five-minute target. Because a protected owner already
   exists, this step needs a separately reviewed and explicitly approved reset/
   reprovisioning procedure or a stated acceptance limit for an isolated authority.
6. Reopen normally, confirm the owner remains enrolled and load the committed profile
   through the public path.
7. Inspect encrypted storage, temporary files and the diagnostic log; confirm no raw
   media, partial enrollment artifacts or secret-bearing trace fields remain.
8. Determine whether the original mismatch reproduced. If it did, analyze checkpoint
   order and sanitized failure data before changing code. If it did not, record the
   clean run as evidence without claiming the historic cause is known.

The recommended first action is item 1: an actual fast-user-switch interruption on
an isolated synthetic pending setup. It does not require camera/microphone capture or
resetting the existing owner, but still requires immediate user approval before the
interactive switch.

### Account-switch harness prepared — 2026-09-04

The existing explicit lock runner now has a separately selected `switch` mode. It
uses a unique HKCU test authority, temporary directory, controlled Windows-verification
success and synthetic references. It stays unelevated and does not open capture
devices, touch the production authority/profile, change networking or print session/
account identifiers.

The operator must choose Ctrl+Alt+Delete → **Switch user** directly, sign into another
existing enabled account, then switch back. For causal evidence, the validation-only
guard ignores an earlier lock notification and requires the production
`SessionGuard` handler for `WTS_CONSOLE_DISCONNECT` to change cancellation from unset
to set. Passing also requires a valid different active-console session, a cancelled
enrollment result, no committed fixture profile and successful cleanup. Signed and
unsigned unavailable-session sentinels cannot count as a switch.

A red/green noninteractive regression covers unavailable, same and different console
session values. The full automated suite passes **82/82** in 26.125 seconds; strict
mypy still passes 12 application modules; compilation and safe invalid-mode behavior
pass. Independent Standards and Spec rechecks each report zero actionable findings.
No lock or account switch was initiated during preparation. Read-only status still
shows the production profile readable and no production diagnostic trace file.

### Account-switch validation unavailable; face check prepared — 2026-09-04

The first attached switch attempt lost the Codex terminal connection and produced no
result. A detached retry was prepared with atomic fail-safe evidence, but the user
reported no accessible second Windows account and asked to move on. Signing out was
not substituted because it cannot prove a different active account session. The
switch check remains unvalidated, not failed or waived.

The detached process was terminated at the user's direction. Its unique HKCU test
key and incomplete scratch result were removed; the production profile remained
readable. Two verified recent Windows temporary directories from the interrupted
attempts contain only an encrypted synthetic ownership reservation and empty operation
lock. Host filesystem policy rejected their automated deletion, so they remain named
for later ordinary cleanup: `%TEMP%\tmp8obic0qs` and `%TEMP%\tmpghxwdjkd`. They
contain no face/voice reference or raw media and cannot change production authority.

The face-only run completed with explicit participant consent. Its recorded evidence
shows the memory-only preview, representative rejection guidance, automatic completion
of all eight samples and landmark-overlay frames. The participant separately confirmed
that the dots visibly tracked their facial features. The harness cancelled before
acknowledging the voice stage, so microphone capture did not begin. Before/after state
comparison reports unchanged production profile, diagnostics and protected authority,
with no raw-media artifact.

The run's combined cleanup flag was false even though face capture had completed and
no validation or device-inventory process remained afterward. A later component-level
voice result and code inspection identified the harness defect: after `app.close()`
destroyed Tk, the normal-close `finally` branch attempted `root.destroy()` a second
time. That deterministic second destroy raised the UI cleanup error. Both harnesses
now destroy a root directly only when no `DeskApp` was constructed. Review also found
the prior five-second worker wait shorter than the readiness probe's twelve-second
bound; it is now fifteen seconds as an independent shutdown-safety correction. Neither
harness issue changes the successful face observations, and no camera rerun is needed.

After the correction, the full automated suite passes **83/83** and strict mypy passes
12 application modules. A read-only post-check reports the production profile readable
and committed, no production diagnostic trace and zero raw-media files in profile or
diagnostics. The original storage incident remains open. The next real-device boundary
is voice capture and requires fresh microphone consent.

### Voice-only validation prepared — 2026-09-04

The next explicit harness invokes the production voice routine in a disposable child
process without entering the face path. Passing requires a real microphone stage and
no camera stage, waveform data plus participant confirmation, prompts for takes one
through three, three accepted takes and at least one deliberate quality rejection. It
discards the generated reference and compares the protected authority plus in-memory
profile/diagnostic hashes before and after; any new raw-media suffix or incomplete
worker/UI cleanup fails the result. Output contains only sanitized Booleans.

Process creation and every initialized pipe/process resource are inside the cleanup
boundary. Worker waits exceed both child termination/kill bounds and the readiness
probe timeout. The invalid-model path and a disposable missing-model child-process
smoke check complete without device access. Full automated suite: **83/83 pass**;
strict mypy: 12 modules; compilation and whitespace checks pass. Independent Standards
and Spec reviews report zero remaining findings. No microphone or camera has been
opened by this preparation, and immediate participant consent remains required before
microphone use.

### First voice-only attempt incomplete — 2026-09-05

With explicit consent, the harness entered the real microphone stage and never entered
the camera stage. It observed waveform data and at least one rejection. It did not
record all three prompt stages or three accepted takes, and the participant confirmation
was not recorded before the window closed. The original Boolean-only result cannot
distinguish capture exhaustion, early closure or another sanitized child failure, so no
cause is claimed.

The run reported unchanged protected/profile/diagnostic state and no raw media. A
read-only post-check confirmed the production profile readable and committed, tracing
disabled, zero raw-media files and no remaining validation/device-inventory process.
The combined cleanup flag was false but did not identify its component. For the next
approved attempt, stdout now adds only safe counts, a fixed failure category and child,
wrapper and UI cleanup Booleans; it still contains no phrases, audio, references,
identity, paths or exception messages. The microphone will not be reopened without
fresh consent.

### Second voice-only attempt incomplete; cleanup cause isolated — 2026-09-05

The approved retry again entered the microphone stage, never entered the camera stage
and produced waveform plus rejection evidence. It reached only prompt take one and
accepted zero takes before the child returned its then-generic error. Both the child
and wrapper were confirmed stopped. The participant confirmation was unavailable
because capture did not complete.

The component trace reported `ui_cleanup_ok=False` and `cleanup_error=True`. Inspection
proved the normal-close branch then destroyed the already-destroyed Tk root, explaining
the cleanup failure without implicating the microphone child. That double-destroy is
fixed in both real-device harnesses. The child protocol now maps only fixed production
`CaptureError` values to safe categories such as `attempts_exhausted`, `capture_timeout`
or `models_unavailable`; unknown capture and device/runtime failures remain generic.
It never transmits exception text, prompts, audio or reference data.

The full suite remains **83/83** and strict mypy passes 12 modules. A missing-model
child smoke check reports its fixed category and confirmed child termination without
opening a device. The two real runs do not yet validate three accepted voice takes.
Fresh microphone consent is required for any further attempt.

### Later voice evidence and deliberate-control correction — 2026-09-05

One approved window was closed before Start: it opened no microphone and its UI cleanup
passed. A later real automatic-flow run entered the microphone stage, showed waveform and
rejection guidance, accepted zero takes and ended with `attempts_exhausted`; sanitized
reasons were `background_noise` and `phrase_mismatch`. The next approved automatic-flow
run accepted take one and reached take two before the same bounded exhaustion. In that
latest run the child, wrapper and UI all stopped cleanly, production storage and protected
authority were unchanged, and no raw media appeared. These observations do not reproduce
or explain the historical post-publication storage inconsistency.

The participant reported that the small, fast automatic prompts were not usable and
approved a deliberate replacement. The native UI now keeps the phrase large and visible,
measures room noise before enabling recording, records only while the mouse button or
Spacebar is held, and stops on release. With the microphone closed it offers memory-only
Play back, Submit and Record again. Accepted/rejected results pause for Continue/Try again;
the specific rejection reason stays visible, and only the current take is retried.

Device-free tests cover mouse and Spacebar control, playback with the microphone closed,
rerecording the same take, specific rejection persistence, focus/grab failure, cancellation,
attempt bounds,60-second waiting-state inactivity cancellation and the five-minute full
enrollment/capture-worker limit. The validation harness now requires
one deliberately unusable submission with a persistent allow-listed quality reason, plus
three accepted takes and participant-confirmed waveform and playback behavior. No device has been opened with the new
flow. The original storage incident remains open, production diagnostics remain disabled,
and another microphone run requires immediate consent.

Final device-free validation after review corrections: **93/93 tests pass**, strict
mypy2.3.1 passes12 modules, compilation and scoped whitespace checks pass. Read-only
production inspection reports committed authority, a readable profile, tracing disabled,
no trace file and zero raw-media files in the profile/diagnostics trees.
Final independent Standards and Spec reviews each report zero actionable findings.

After replacing the former90-second voice deadline, final device-free validation is
**96/96 tests** with strict mypy2.3.1 across12 application modules, successful compilation
and scoped whitespace checks. Independent Standards and Spec rechecks each report zero
actionable findings. This timeout change did not open a device or touch production storage;
the original storage incident remains open and unreproduced.

### First deliberate-control voice run incomplete — 2026-09-05

With fresh consent, the voice-only window opened the microphone and never entered the
camera stage. The operator confirmed live waveform response. One take was accepted and
the flow reached take two before the90-second voice budget expired. Persistent rejection
categories were `background_noise` and `too_quiet`; the earlier validation gate incorrectly
required the single exact category `insufficient_speech`. A real microphone can correctly
classify a deliberately unusable take under any of those fixed quality categories, so the
gate and instructions now require a deliberate rejection with a persistent allow-listed
reason rather than one implementation-specific category.

The run did not satisfy three accepted takes and is not a pass. Protected authority/profile/
diagnostic state remained unchanged, no raw media was created, and child, wrapper and UI
cleanup all passed. The existing enrollment remained committed and readable. The historical
storage incident did not reproduce and remains open. No further microphone run is authorized
without fresh consent.

### Second deliberate-control run and timeout correction — 2026-09-05

The second consented run again accepted take one and reached take two before the former
90-second voice deadline expired. It additionally proved a submitted rejection with a
persistent `too_quiet` reason, live waveform, memory-only playback and both participant
confirmations. Camera access stayed off; storage and authority remained unchanged; no raw
media appeared; child, wrapper and UI cleanup all passed. Only the three-accepted-take gate
remained unmet.

The two repeat results isolate the90-second total as incompatible with the participant's
approved deliberate review flow. With user approval, waiting screens now cancel after60
seconds of inactivity, each recording remains limited to10 seconds, and the full enrollment
plus disposable capture worker is bounded to five minutes. The enrollment timer starts at
Start, cancels Windows/capture/code waiting, clears a displayed recovery code, and stops
before protected publication becomes indivisible. Device-free timeout regressions pass.
No microphone retry is authorized by this change.
