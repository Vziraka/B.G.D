# Ticket03 — development verification boundary

Implemented 2026-09-06. **Development only; real verification evidence pending.**
Ticket02's actual enrollment evidence does not validate ordinary recognition. Ticket04
retry persistence, Ticket07 attack hardening and Ticket08 integrated acceptance remain open.

## Implemented action and state

Verify creates one random request ID, bound to the protected installation, owner account,
profile generation/digest and `desk-verification-dev-3` policy. The only action is creation
of that request's informational desktop receipt. The receipt has no executable capability,
completion endpoint or reusable unlocked state. The UI displays it once; starting another
check or reopening requires both fresh channels. No aircraft interface exists.

The workflow acquires the same Windows operation lock as enrollment before reading the
profile. It validates stored reference formats before capture and rechecks encrypted payload,
protected authority, account, cancellation and deadline immediately before creating the
receipt. The lock stays held until external work returns, including after cancellation.
No profile, recovery code, retry ledger or ownership value is updated by verification.

Each request starts its own disposable worker using the existing DirectShow camera index0
and default sounddevice microphone at16kHz mono PCM. The microphone index is resolved once
per request and explicitly reused for room measurement and recording. Pinned model validation runs before
capture. The child receives the exact request and returns evidence tagged with it; mismatched
request/policy/generation evidence cannot complete the check. This is an intact-verifier
protocol boundary, **not authentication of physical sensors or protection from injected media**.

## Initial policy

| Component | Development policy |
| --- | --- |
| Face | Existing single-face framing, lighting, sharpness and frontal-landmark checks; one second of stability, then one SFace vector. Enrollment still uses eight samples. |
| Challenge | `please say` followed by four independent random number words, each one–nine. Generated anew per request using `secrets`; 6,561 possible phrases, repetitions possible. |
| Voice | Existing quiet-room measurement, volume/clipping/noise and at least1.5s qualifying-speech checks. Brief low-volume blocks do not invalidate a take that has enough qualifying speech; consistently quiet/insufficient speech still rejects. One displayed phrase, one submitted take; unrestricted English ASR must reproduce all words exactly. No grammar forced to the expected answer. |
| Interaction | Hold mouse/Spacebar to record; release submits the verification take with no enrollment playback/Submit/Continue screens. Discard before submission can rerecord inside the same absolute deadline. A completed failed take ends this request. |
| Face identity | Normalized cosine similarity ≥0.363. This is OpenCV's LFW example value, not an owner/device calibration or anti-spoof threshold. |
| Voice identity | Normalized cosine similarity ≥0.75, an explicitly provisional engineering setting. No claim of a validated false-match rate or transferable vendor threshold. |
| Binary input | Existing `SFACE1`128-float and `VOSKSPK1`64–512-float formats; exact length/header, finite values and nonzero norm; voice dimensions must match. Both channels must pass. |
| Time | Absolute60s request deadline, including prompts and worker startup; separate10s normal-success target. Worker timeout/cancellation closes device processes. UI elapsed time includes click, processing and initial receipt rendering. |

The [OpenCV4.13 tutorial](https://docs.opencv.org/4.13.0/d0/dd4/tutorial_dnn_face.html)
documents its cosine example and benchmark-specific thresholds. The
[Vosk speaker example](https://github.com/alphacep/vosk-api/blob/master/python/example/test_speaker.py)
uses cosine distance and warns that utterances longer than four seconds give better speaker
vectors. These sources were checked on2026-09-06; neither establishes this application's
thresholds, challenge reliability, ten-second feasibility or attack resistance. Development
calibration must use separate consented material before final acceptance trials.

The random phrase rejects incorrect recognized words; it does not establish liveness.
Recorded number assembly, a coincidentally repeated phrase, generated speech, face photographs,
video and virtual/substituted devices remain attack concerns for Ticket07. One stable RGB
face is not proof of a live owner. Ticket04 must still establish persistent attempt counting,
five-failure/thirty-second waits, clock/sleep/restart behavior and damaged retry-state handling.
The basic operation lock and monotonic deadline implemented here do not complete Ticket04.

## Consent, data and launch

Default launch leaves real verification capture disabled. The session flag below only makes
the deliberate consent control available; it is not approval to collect biometrics. Before
launching it for a real participant, agree the enrolled owner's specific session, access,
immediate raw-media disposal and any separately retained timing/results. No such new session
was performed during this implementation.

```powershell
# Only after an agreed owner session; use the installed model directory if different.
.scratch/pc-biometric-desk/.venv/Scripts/python.exe -m pc_biometric --verification-session --models C:\absolute\local\models
```

The in-app checkbox is required for each request. No Windows credential prompt occurs during
ordinary verification; fresh Windows verification remains required for enrollment/maintenance/
recovery under their own policies. The existing SessionGuard cancels capture on session loss.

Raw preview/audio and derived check vectors remain in memory and are discarded at completion,
cancellation or child termination. Verification writes no media, score log, transcript, result
file or template. The existing operation-lock file may remain; it contains no biometric data.
The stored encrypted enrollment and its previously agreed deletion plan remain unchanged.
Process disposal is not a claim of forensic erasure of Windows paging/crash material.

## Evidence and next gate

### Recording readiness and voice consistency study — 2026-09-06

Dev-3 corrects a reproduced recording-readiness ordering error: the UI used to announce
Recording before the sounddevice stream was opened. Pressing now shows Opening microphone;
the recording-state acknowledgement and capture timer occur inside the opened stream.
This fixes the readiness signal, not a proven cause of the real speaker mismatch. All
quality, word and identity thresholds, models and reference recipes are preserved.

The latest user-supplied diagnostic report passed face identity, audio quality and exact
words but rejected speaker identity. It used a single full-recording speaker segment.
The first-segment concern therefore does not explain that particular attempt. The next
step measures fresh-to-fresh voice agreement and fresh-to-enrolled agreement separately.

Explicit study launch (replace the example microphone index with the intended enumerated
PortAudio input; index1 was EarPods when checked for this session):

```powershell
.scratch/pc-biometric-desk/.venv/Scripts/python.exe -m pc_biometric --verification-session --verification-diagnostics --voice-consistency-study --microphone 1 --models .scratch/pc-biometric-desk/model-acquisition/validated-models
```

The Verify page identifies a study and requests consent for each sample. Collect three on
the same microphone without navigating away; each must independently meet the unchanged
capture/challenge rules. Each request retains the60s limit. Completed samples are compared
against enrollment and pairwise, with no study pass threshold and no enrollment updates.
Neither matching nor mismatching samples authorize any action in this mode. Stale evidence,
cancelled requests and changed protected state cannot enter the study. Three completed
samples stop further collection until navigation resets it. Scores show repeatability,
not proof of identity, a calibrated threshold or independent acceptance evidence.

Unlike ordinary verification, this explicitly consented mode retains up to three derived
voice vectors in process memory across requests. They clear after the third sample, on
cancellation/navigation/Windows interruption/close, or automatically after five minutes
from the first sample. Earlier comparison scores have the same bounded session lifetime;
copies already displayed remain until the report's normal cleanup boundary. Raw media and
face vectors are not retained across requests. No samples, reference vectors, transcripts
or numerical scores are written to files. Existing encrypted enrollment is never adapted.
The final report remains available until another request/navigation/interruption/close.

Tests reproduce the premature readiness signal before the correction and verify it after;
they also verify study opt-in, fixed-device request propagation, all pairwise comparisons,
no authorization even for identical identities, unchanged protected profile, cancellation,
five-minute cleanup and real Tk consent/report/navigation handling using synthetic inputs.
Validation:120/120 tests pass; strict typing across13 source modules, compilation and scoped
whitespace/conflict checks pass. Production encrypted profile/diagnostic files and protected
authority match the earlier snapshot. The real speaker failure is not yet fixed or accepted.

### Opt-in capture and identity diagnostics — 2026-09-06

The user authorized the first evaluation slice after both capture stages completed but the
combined check rejected. Launch with both `--verification-session` and
`--verification-diagnostics`, then deliberately agree to the displayed session terms and
start a check. The diagnostic flag alone is rejected. Default launch does not collect scores
or diagnostic measurements. No device opens merely because the diagnostic app is launched.

After a completed check, a separate memory-only report shows face and voice cosine scores
and their unchanged thresholds, or explicitly says identity was not evaluated when capture
failed. It also shows final face framing/brightness/sharpness and stability outcome, camera
index/backend/frame size, microphone index/name/backend and requested/opened sample rate,
noise and recording RMS, clipping, qualifying audio duration, exact-phrase outcome,
recognizer segment count, selected speaker segment duration and reported nonsilence frames,
model setup/stage times and request-to-displayed-result time. Missing observations are
identified as such. RMS means root mean square, a measure of signal level; qualifying audio
duration is the existing level/noise gate, not a speech detector. Segment duration includes
silence, whereas Vosk's `spk_frames` reports nonsilence support for the selected vector.

The report describes the existing first-available speaker vector; it does not choose a
different vector or modify the enrolled reference recipe. Scores are evaluated only after
request-bound evidence validation. Capture diagnostics are request-tagged, bounded and
opt-in across the child-process boundary. Cancellation/expiry suppress reports; a new check,
navigation, interruption or app close removes the displayed report and queued measurements.
Closing the report window alone allows reopening it until one of those boundaries. No raw
media, transcript or reference vector is included; no report file, score log or export is
written. Process-memory disposal is not a claim of forensic erasure.

Synthetic tests cover separate identity failures with identical authorization decisions,
absence of scores by default, stale/cancelled evidence, diagnostic IPC binding, a changing
default microphone, segmented speaker support, and the actual Tk report/cleanup flow.
Policy remains `desk-verification-dev-2`; model, threshold and enrollment changes remain
outside this slice. Genuine-owner capture quality and the cause of the prior rejection are
still unmeasured. Ticket03 is unresolved.

Validation for this slice: **115/115 tests pass**, strict mypy2.3.1 passes13 source modules,
compilation and scoped whitespace/conflict checks pass. Read-only preflight confirms the
production profile/diagnostic files and protected authority are unchanged from the earlier
validation snapshot. These tests collect no real camera or microphone input.

Synthetic checks exercise the public Verification and EnrollmentCapture seams with real
isolated HKCU/DPAPI fixtures and real Tk controls. They cover both-channel success/mismatch,
malformed vectors, wrong words, stale evidence including after restart, account/state changes,
profile deletion, cancellation, timeout, concurrent operation locking, sanitized device errors,
child message binding, and default/explicit-consent UI behavior. The full capture-to-UI check
uses synthetic camera/microphone/model outputs: no participant or actual device stream.

Final implementation checks: **108/108 tests pass** (including12 new verification tests),
strict mypy2.3.1 passes13 application modules, compilation and scoped whitespace checks pass.
No independent agent review or actual-device verification was performed in this slice.

### Initial real validation and rejection diagnostics — 2026-09-06

The subsequent user-authorized session reached voice capture but returned the generic
spoken-challenge rejection. This is not speaker-mismatch evidence; face identity matching
also had not yet run. Attempt counts and timings were not captured. After graceful app
closure, the encrypted profile remained readable and its files, protected authority and
diagnostic files matched the pre-session snapshot exactly.

A reproduced reporting defect is corrected: fixed quality/word/signature rejection guidance
now survives the disposable worker and final result. Only allow-listed application text is
forwarded; transcripts/raw media are not logged.109/109 tests, strict typing across13 modules
and compilation pass. Recognition policy is unchanged. The underlying real voice failure
still needs a deliberate diagnostic attempt; successful real verification remains pending.

### Brief low-volume rejection correction — 2026-09-06

The user then reported persistent “Voice is too quiet” rejection both with and without a
headset. Read-only PortAudio enumeration selected EarPods at inspection time; it does not
establish the device used for each earlier attempt. No audio was collected by enumeration.

A deterministic public-capture regression reproduced the exact rejection with0.25s of
soft audio plus1.75s of sufficiently loud speech, matching recognized words and a valid
speaker vector. The soft block incorrectly set a permanent failure flag. The same failure
occurred with the soft block at the beginning, middle or end. In dev-2, low-volume feedback
is retained, but it becomes a terminal reason only when the take lacks1.5s of qualifying
speech. Clipping, stream interruption and excessive-noise failures remain terminal;
volume/SNR/identity thresholds and exact-word requirements are unchanged. The correction
is in the shared capture routine, with enrollment and verification regression coverage.
No stored references are changed. Real owner success after this correction remains pending.

Automated result:111/111 tests pass, strict typing passes13 modules, compilation passes.

```powershell
.scratch/pc-biometric-desk/.venv/Scripts/python.exe -m unittest discover -s tests -v
uv tool run --from mypy==2.3.1 mypy --strict --cache-dir .scratch/pc-biometric-desk/mypy-cache pc_biometric
.scratch/pc-biometric-desk/.venv/Scripts/python.exe -m compileall -q pc_biometric
```

Before resolving Ticket03, collect separately authorized real-device evidence for the exact
version/profile/policy: a fresh positive control with actual displayed words and speaker/face
matching; an intentional incorrect phrase; deliberate cancellation/device interruption;
fresh-request/reopen behavior; request-to-displayed-result timing; and unchanged encrypted
state with no raw-media/log artifacts. Record every failed/slow attempt separately. Do not
reset enrollment or adjust thresholds against acceptance trials. These engineering checks
do not replace the five-day100-attempt or full attack evaluation in Ticket08.
