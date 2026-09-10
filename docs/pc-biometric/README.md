# PC Biometric Desk — development build 0.1.0

Continue new-product planning at the [phone/onboard entry point](../phone-drone/README.md). It separates the simulated phone slice from parallel aircraft feasibility.

**Current product status, September 9:** the owner has retired the standalone Windows app from the finished product, superseding the earlier completion direction below. Preserve this implementation, its tests and evidence for development/reference use. Its unfinished product acceptance is not a delivery requirement or a claimed pass. PC simulation and engineering continue to have a role. See the [latest product decision](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#2026-09-09-phone-and-onboard-direction-pc-product-retired). The remaining content records the former app and its development history.

Offline Windows desktop development app for owner enrollment and fresh face-and-voice verification of one harmless desktop action. UI B is selected. It does not authorize an aircraft.

**Current — September 9:** Tickets01/02 are complete for their stated boundaries. The owner approved completion of the PC implementation with hardware paused, UI B retained, PC/headset microphone support and a protected Windows helper. Retry/generation state, native service transport, Account/Recovery workflows, microphone selection and offline packaging are implemented in the working tree and undergoing integration. See the [installed boundary](installed-boundary.md) for evidence and unfinished checks. This is not yet an implementation-complete or security-accepted release.

**Recognition:** [Ticket03](../../.scratch/pc-biometric-desk/issues/03-single-action-verification.md#current-checkpoint) remains unresolved: a prior real take passed face, audio quality and words but failed speaker identity. The owner authorized a short development study on September 9; results are being collected. Checks preserve the profile. [Spoof-defense qualification](security-matrix.md) is separate from identity matching and final attack acceptance. The formal five-day usability and attack campaign are deferred until after implementation, not waived.

The approved [spec](../../.scratch/pc-biometric-desk/spec.md) and [ticket graph](../../.scratch/pc-biometric-desk/review.md#published-tickets) define requirements and dependencies. [Enrollment evidence](enrollment-boundary.md) and [verification evidence](verification-boundary.md) hold the detailed results.

## Launch and checks

Run from the repository root on native Windows 11 x64 with CPython 3.13.12 and
its Tcl/Tk 8.6.15 installation (observed on this PC). No pip installation, models,
network connection, server, administrator elevation or camera/microphone access
is needed for the readiness application:

```powershell
python -m pc_biometric
python -m pc_biometric --check
```

Use [Development checks](testing.md) for targeted checks, the full suite and optional storage stress runs.

`--check` exercises the same workflow without Tk. Exit 1 means missing/failed
prerequisites, not a process crash; exit 0 would mean only no such blockers were
found, **never authorization or passed integration**.
Normal launch returns exit 2 if elevated. Installation/setup is separate; do not
run the desktop application as administrator to work around missing setup.

Models default to `%LOCALAPPDATA%\BGD\PCBiometricDesk\models`. An explicit
`--models C:\absolute\local\models` overrides the directory. Readiness does not
create that directory, write profiles or download anything. Keep model bundles
and all future biometric/state data outside this checkout and cloud-synced folders.
For offline inspection use a local disk, not a network/UNC directory.

## Enrollment behavior and development policy

The approved UX amendment adds masked recovery-code display with eye reveal/hide,
Copy and copy-gated completion. Clipboard data is deliberately not cleared automatically;
copying does not prove offline saving. App-held display state clears on cancellation,
interruption and completion. Copy cannot re-enable completion during publication.

Face enrollment automatically collects eight samples after one second of continuous
quality/stability, with real detector dots drawn only on the display copy. Voice
enrollment accepts three different displayed English phrases and shows visualizer A
(live amplitude waveform with guidance). Failed takes retry at most three times per
phrase. No raw preview/audio/waveform files or automatic profile learning are added.

### Development quality policy — not biometric acceptance

These engineering settings in `capture.py` require later consented calibration on the
actual owner/devices. Synthetic checks do not establish recognition, usability, liveness
or spoof resistance. Do not tune against final acceptance trials.

| Check | Current development settings |
| --- | --- |
| Face framing | Exactly one finite detection, whole box in frame; width ≥96px and ≥25% frame width, height ≥35% frame height; width ≤85%, height ≤95% |
| Approximate frontal pose | Eye spacing ≥20% box width; eye-line vertical offset ≤20% eye spacing; horizontal nose offset ≤25%; nose below eyes by20–80% eye spacing; mouth below nose by20–90%; all five landmarks in box |
| Lighting/sharpness |128×128 grayscale ROI; mean45–210; ≤20% pixels below15/above245; Laplacian variance ≥60 |
| Stability | Box coordinates stay within4% of frame dimensions from initial anchor for ≥1s, then8 samples ≥0.3s apart; failed quality/movement resets samples;30s face limit |
| Voice |16kHz mono signed16-bit; unrestricted English ASR must match normalized displayed words;3 distinct phrases from6 bundled phrases; large persistent prompt |
| Noise/volume |0.5s quiet baseline each attempt, normalized RMS ≤0.02; speech ≥0.015 RMS and ≥10dB above baseline (noise floor0.001); ≥1.5s qualifying speech; ≤0.5% samples above0.98 amplitude; overflow rejects take |
| Controls | Automatic room measurement enables Hold to record; hold mouse or Spacebar, release to stop; then Play back, Submit or Record again; accepted/rejected results wait for Continue/Try again |
| Bounds |10s per voice recording,3 submitted attempts per phrase,60s inactivity per waiting screen,5min complete-enrollment/disposable-worker budget;48 bounded RMS bins per0.25s chunk for waveform |
| References | Normalized mean of8 SFace vectors; normalized mean of3 normalized Vosk speaker vectors; existing bounded binary format, no raw takes |

The existing Windows module boundaries remain; no iOS code or broad interface refactor.
Random-phrase verification is now implemented under the separate
[Ticket03 development policy](verification-boundary.md); it does not change enrollment.
The ignored [audio prototype](../../.scratch/pc-biometric-desk/audio-visualizer-prototype.html)
is design evidence only (A selected), not production code. It remains local because no
prototype commit or wider tracking is authorized. The real desktop UI is native Tk.

## Ticket02 evidence and storage diagnostics

Ticket02's final baseline is **96/96 automated tests**, strict typing across12 modules,
successful compilation/scoped whitespace checks and zero actionable Standards/Spec findings.
Native evidence includes protected HKLM deletion/rollback rejection, actual UAC publication,
successful/cancelled Windows verification and workstation-lock cancellation. Consented real
evidence includes face preview/landmarks/automatic capture, three deliberate voice takes,
real microphone interruption cleanup, a **222.144-second** offline enrollment and a healthy
fresh-process reopen. The profile remains encrypted and readable; no raw-media, pending or
diagnostic artifact remains. See the [current evidence](enrollment-boundary.md).

The earlier post-publication stale-index incident is closed as unreproduced after bounded
investigation. Its cause remains unknown and is not attributed to the separately fixed Windows
reader/replacement race; recurrence reopens it. Actual switching to a different Windows account
was unavailable and explicitly accepted as an unvalidated limitation. None of this establishes
biometric accuracy, liveness, replay/substituted-input resistance or later-ticket verification.
The approved [spec](../../.scratch/pc-biometric-desk/spec.md) and
[ticket graph](../../.scratch/pc-biometric-desk/review.md#published-tickets) remain authoritative.

Temporary storage tracing is disabled by default. For
an explicitly approved validation attempt only, set `BGD_STORAGE_DIAGNOSTICS=1` in
the launch environment. It writes secret-free step records to
`%LOCALAPPDATA%\BGD\PCBiometricDesk\diagnostics\storage.jsonl`. Remove that environment
variable to disable it. See the [diagnosis record](storage-incident-diagnosis.md#temporary-storage-step-tracing-ready--2026-09-04)
for the exact schema, tests and limits. Do not publish or infer biometric/security
acceptance from this trace.

## Initial stack selection (2026-08-30)

The spec delegates these engineering choices to ticket 01. The earlier
InsightFace/SpeechBrain recommendations were research, not selected requirements.
Use a CPU baseline without CUDA/PyTorch/ONNX Runtime or cloud accounts:

| Component | Exact initial selection | License/use and integration boundary |
| --- | --- | --- |
| Application | CPython 3.13.12; Tcl/Tk 8.6.15; stdlib unittest | Existing local runtime; PSF and Tcl/Tk licenses. Native desktop UI B, no browser prototype code |
| Face inference / RGB capture | opencv-python 4.13.0.92 | Apache-2.0 package; preserve bundled third-party notices. Consented DirectShow capture passed on this PC; portability and biometric security remain unvalidated |
| Face detection | YuNet `face_detection_yunet_2023mar.onnx` | MIT model-directory license |
| Face recognition | SFace `face_recognition_sface_2021dec.onnx` | Apache-2.0 model-directory license; selected for local development, no commercial redistribution claim |
| Speech and speaker inference | vosk 0.3.45 | Apache-2.0; explicitly load local paths, never automatic model discovery/download |
| Spoken challenge recognition | `vosk-model-small-en-us-0.15` | Apache-2.0, English small model; three English enrollment prompts and exact-word acceptance are implemented/tested, while identity/security calibration remains separate |
| Voice reference | `vosk-model-spk-0.4` | Apache-2.0 speaker model; recognition is not liveness |
| Microphone capture | sounddevice 0.5.6 / bundled PortAudio | MIT package; consented16kHz mono capture, waveform, playback, rejection and three accepted takes passed on this PC; backend/device portability remains limited |
| Windows verification | winrt-runtime 3.2.1 and winrt-Windows.Security.Credentials.UI 3.2.1; Windows desktop `IUserConsentVerifierInterop` | MIT projections plus Windows platform. Desktop HWND interop is required; ordinary UWP `RequestVerificationAsync` is not a valid substitute |

Package pins and resolved transitive dependencies are in
[requirements-models.in](../../pc_biometric/requirements-models.in) and its
[hash-pinned lock](../../pc_biometric/requirements-models.lock). Windows x64 /
Python 3.13 dependency resolution succeeded. Ticket02 subsequently loaded the pinned artifacts
and exercised real face/microphone inference, Windows-account verification, offline enrollment
and fresh-process profile loading on this PC. Those bounded integration results do not establish
biometric identity accuracy, liveness, replay resistance or portability to another machine.

Sources checked: [OpenCV package](https://pypi.org/project/opencv-python/4.13.0.92/),
[Vosk package](https://pypi.org/project/vosk/0.3.45/),
[sounddevice](https://pypi.org/project/sounddevice/0.5.6/),
[PyWinRT package](https://pypi.org/project/winrt-Windows.Security.Credentials.UI/),
[Microsoft desktop verification guidance](https://learn.microsoft.com/en-us/uwp/api/windows.security.credentials.ui.userconsentverifier).

The target inventory does not establish acceleration, infrared access or input
authenticity. Selected face weights total about 39 MB; the Vosk source lists
approximately 40 MB speech and 13 MB speaker archives. Extracted storage, peak RAM,
DLL compatibility, accuracy and end-to-end latency remain unmeasured. No ten-second
check or five-minute enrollment claim follows from these sizes. No paid dependency,
extra hardware, driver installation or online inference fallback is selected.

## Offline installation approach for dependent implementation

This readiness build needs only the existing Python/Tk runtime. Do not install
models just to remove its missing indicators. Before a consented integration
session, prepare a local bundle on an online Windows x64 / CPython 3.13 machine:

1. Download the dependency artifacts in `requirements-models.lock` using pip's
   `download --require-hashes -r` into an external bundle directory. Preserve
   license/NOTICE files. Vosk's `srt==3.5.3` dependency has no upstream wheel:
   prepare its pure-Python wheel in the build environment, record its resulting
   SHA-256 and a wheel-only installation manifest. Do not reuse the source hash
   as if it were the wheel hash. Build tooling is not required on the offline PC.
2. Copy the source tree, CPython offline installer if needed, wheel bundle,
   license files and pinned model artifacts to the offline PC. Create a dedicated
   virtual environment outside this checkout; install with `pip install
   --no-index --find-links <bundle> --require-hashes -r <wheel-manifest>`.
3. Place model files/directories in the local model directory above. Verify the
   two face-model hashes and both Vosk archive hashes below. Readiness verifies
   the exact extracted Vosk trees, including absence of unexpected extra files.
4. Launch from the repository root using that environment's Python. Inspection
   is still offline and capture stays off. Test native loading, actual supported
   paths and Windows verification separately before accepting ticket 02.

Ticket 01 used dependency metadata resolution only. During ticket 02 preparation,
the pinned packages were installed into an ignored CPython 3.13.12 development
environment. On 2026-09-03 the four pinned model artifacts were acquired into
ignored scratch storage, verified and loaded without opening capture devices.
A distributable offline biometric package remains part of the dependent
integration/handoff work. See the [current enrollment boundary](enrollment-boundary.md).

### Model sources and provenance

Face artifacts are pinned to OpenCV Zoo commit
`47534e27c9851bb1128ccc0102f1145e27f23f98`. SHA-256 and byte sizes below come
from that commit's Git LFS pointers, not downloaded weights:

| File | Bytes | SHA-256 |
| --- | --- | --- |
| face_detection_yunet_2023mar.onnx | 232589 | `8f2383e4dd3cfbb4553ea8718107fc0423210dc964f9f4280604804ed2552fa4` |
| face_recognition_sface_2021dec.onnx | 38696353 | `0ba9fbfa01b5270c96627c4ef784da859931e02f04419c829e83484087c34e79` |

[YuNet source/license](https://github.com/opencv/opencv_zoo/tree/47534e27c9851bb1128ccc0102f1145e27f23f98/models/face_detection_yunet),
[SFace source/license](https://github.com/opencv/opencv_zoo/tree/47534e27c9851bb1128ccc0102f1145e27f23f98/models/face_recognition_sface).
Download actual LFS payloads, not text pointer files.
[Vosk publisher model catalog/licenses](https://alphacephei.com/vosk/models):
[English 0.15 archive](https://alphacephei.com/vosk/models/vosk-model-small-en-us-0.15.zip),
[speaker 0.4 archive](https://alphacephei.com/vosk/models/vosk-model-spk-0.4.zip).

Acquired Vosk archive evidence:

| Archive | Bytes | SHA-256 | Exact extracted-tree SHA-256 |
| --- | ---: | --- | --- |
| `vosk-model-small-en-us-0.15.zip` | 41,205,931 | `30f26242c4eb449f948e42cb302dd7a686cb29a3423a8367f99ff41780942498` | `e1bc6b77e048181fce1c9532847a55687fc4f132077c52906696b777a7a2fcbd` |
| `vosk-model-spk-0.4.zip` | 13,869,103 | `a74d8f51144484813e16af689bb0f916b7a111e2347f467c4933c1166097b5a7` | `8a06591113a4ddad5fd1ca8d53f53c1d3f37acc651b372fbdf48771e36316afd` |

The publisher does not provide signed checksums; these archive hashes record the
bytes acquired from its HTTPS links on 2026-09-03. The extracted-tree digest hashes
each sorted relative path, file length and file SHA-256. Runtime readiness enforces
the approved OpenCV file hashes and these Vosk tree hashes. All four models loaded
successfully in the pinned environment without camera or microphone access. A
successful load is compatibility evidence only; it proves no biometric quality,
liveness, offline operation or authorization behavior.

## Readiness and privacy boundaries

Camera inspection runs local `Get-PnpDevice -PresentOnly` in a hidden, profile-free
Windows PowerShell process with a timeout. Microphone inspection calls WinMM's
`waveInGetNumDevs`; neither opens a capture stream. Counts include interfaces that
may be unusable, virtual or different from the later selected capture backend.
Windows verification is explicitly unverified; no credential dialog opens.

The UI runs inspection off the Tk thread; refresh cannot start concurrent scans.
Errors show fixed actionable text, not raw exception contents, device identifiers,
account names, secrets or logs. Readiness and the default session-blocked launcher
create no recordings, templates, codes, result ledger or ownership state. Once an
explicitly agreed session is configured, setup can retain encrypted face/voice
references and protected ownership state. During face capture, bounded preview
frames cross the child IPC boundary into a Tk image in memory and are cleared when
that stage ends or is cancelled. A voice recording remains in the disposable capture
process only until Submit, Record again, cancellation or close; playback occurs with
the microphone closed. Ordinary raw frames and audio are never written by the capture
adapter. Python may create ordinary bytecode caches; these
are ignored and contain application code only.

Keyboard navigation and native window rendering receive smoke checks. Tk's
Windows UI Automation tree may expose generic panes rather than labelled controls;
screen-reader usability is **not validated**, and must be resolved before claiming
production accessibility. No prototype simulation controls or success bypass exists.

## Ticket 02 result and next dependency

Ticket02 is resolved for first-owner enrollment and protected storage. The production authority
is committed, a fresh process loads the matching encrypted profile, and the 2027-01-01 limited
scheduled task targets only the user profile while preserving HKLM authority. Deleting or
rolling back user-writable state cannot reopen enrollment. The evidence record documents the
accepted lack of an actual second-account switch; synthetic account-change/session cases pass,
but this is not reported as a real switch result.

Ticket03 implementation is ready for real-device validation;06 remains unstarted;
04/05 require03;07 requires04;
08 requires 05/06/07 and actual five-day/attack evidence. They cannot be marked
complete based on readiness or synthetic fixtures. PC acceptance cannot close the
aircraft issue, authorize motors, complete M1 alone or establish hardware affordability.
