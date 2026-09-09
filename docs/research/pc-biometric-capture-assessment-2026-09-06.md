# PC face and voice capture assessment

Date:2026-09-06. Status: **evaluation and proposed next work, not an approved redesign or
passed validation**. Main checkout, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`;
the inspected application is uncommitted and is not contained in that commit. Policy:
`desk-verification-dev-2`. No new capture, model installation, threshold adjustment,
enrollment replacement or application-code change was performed for this assessment.

Inspected uncommitted source SHA-256:

- `pc_biometric/capture.py`: `c2317f36bb8782695f8d709893717ac77520a2e04fde13cce1672f5a92982fbd`
- `pc_biometric/verification.py`: `97892abc0a69ba1c1c3cae21f52fcc33e4550c14965bd0836fee83eda408e0ba`
- `pc_biometric/requirements-models.lock`: `ec16177ac30c317defb8fecf93015c63e258c2ab0860ce374dd42530d7eb4bba`

## Recommendation

Pause repeated pass/fail trials. First make capture conditions and the two independent
identity comparisons measurable. Then evaluate the weakest measured stage with a separate
development protocol before freezing any new configuration for acceptance. Keep both required
biometrics, the ten-second target, privacy/ownership protections and pending attack coverage.
Making one owner attempt pass is not an optimization objective.

The user reports that both capture stages now complete but the full check rejects. There
are no retained per-channel scores, timing records or raw captures from that attempt.
We cannot name the failing identity channel or establish that the enrollment is representative.
Completing capture is not a face or speaker match. The current generic combined rejection
also covers a mismatched evidence request; state/storage faults have other result paths.
See [the workflow](../../pc_biometric/verification.py) and the
[Ticket03 record](../../.scratch/pc-biometric-desk/issues/03-single-action-verification.md).

## What the implementation actually does

These are source-code findings, not measurements of the user's biometric performance.

| Area | Current behavior | Consequence to evaluate |
| --- | --- | --- |
| Camera | DirectShow camera index0; no explicit resolution selection or record of negotiated camera properties. | We have not established which RGB mode, effective resolution, exposure or focus the verifier receives. More pixels alone do not guarantee better aligned face features. |
| Face quality | Framing, five-landmark approximate pose, brightness, sharpness and box stability checks. | These help select a visible face but are not a calibrated recognition-quality or liveness model. Record quality alongside matching results to establish whether these gates predict useful captures. |
| Face reference | Eight closely spaced features averaged, then normalized; no per-sample consistency test. | A mean hides disagreement and weights raw vectors by their magnitude. We cannot recover enrollment dispersion from the saved mean. Compare aggregation/consistency approaches on new consented development material before proposing replacement. |
| Face verification | One quality-qualified frame after a stable second. | Compare one frame against a small, fixed burst from the same request for repeatability, capture loss and latency. Do not select whichever frame gives the highest owner-match score. |
| Microphone | Default PortAudio input, separate room-noise and speech streams,16kHz mono requested. | Display and bind the intended device and backend for the whole request. Evaluate built-in and headset paths as distinct conditions; their successful enumeration does not prove equivalent signal quality. |
| Speech quality | Signal-level/clipping/background tests; sufficient loud blocks counted across the take. | Loudness is not speech detection. Verify actual speech duration, mic gain/processing and signal-to-noise behavior; distinguish true low signal from endpoint or channel effects. |
| Speaker evidence | Vosk resets at endpoints, joins recognized text across segments, but takes the first result containing a speaker vector. `spk_frames` is unused. | The words and quality duration can describe more audio than the selected identity vector. Evaluate complete-utterance speaker extraction and consistency, rather than assuming that a valid vector uses the whole phrase. |
| Voice reference | Three normalized per-take vectors averaged and normalized; no identity-consistency test between takes. | Three accepted word/quality takes do not prove a stable speaker reference across days or microphones. Reference construction needs its own development validation. |
| Match decision | Face cosine≥0.363 and speaker cosine≥0.75 are combined into one Boolean. | No local score distributions or error tradeoff justify these values for the current devices, enrollment recipe and short phrases. Do not adjust either solely because an owner was rejected. |
| Timing | Models load and are validated in each disposable capture worker; UI reports only the full elapsed time. | Measure setup, acquisition, inference and rendering separately before optimizing. Any later model-loading change must preserve cancellation, isolation and raw-media disposal. |

Source: [capture implementation](../../pc_biometric/capture.py),
[verification implementation](../../pc_biometric/verification.py),
[current enrollment policy](../pc-biometric/README.md), and
[verification policy](../pc-biometric/verification-boundary.md).

Sounddevice supports inspecting selected devices/backends and checking supported input
settings; unspecified device selection uses defaults. Its default sample-rate listing does
not by itself prove a stream requested at16kHz is misconfigured. Confirm the opened stream
and actual signal rather than inferring a failure from the44.1/48kHz device default.
[Hardware API](https://python-sounddevice.readthedocs.io/en/0.5.6/api/checking-hardware.html),
[stream API](https://python-sounddevice.readthedocs.io/en/0.5.6/api/streams.html).

## Proposed evaluation order

1. **Separate outcomes without changing decisions.** In a deliberately enabled local
   development mode, report face quality, voice quality, spoken-word agreement, face
   similarity, speaker similarity, policy/device identifiers and stage timings separately.
   Do not expose a reusable authorization token or leak these diagnostics through the ordinary
   production UI. Agree access, retention and deletion before retaining any derived biometric
   scores. A memory-only session is sufficient for initial inspection; recordings are not
   the default. Calibration records and final acceptance evidence must be distinguishable.
2. **Control capture conditions.** Identify the actual camera and microphone, confirm the
   negotiated format, and keep each request on its selected device. Compare ordinary indoor
   lighting, clear glasses if worn, normal speech and mild room noise. Test headset and
   built-in microphone separately if both are intended supported paths. Do not compensate
   by requiring shouting or silently narrowing the approved ordinary-use baseline.
3. **Evaluate sampling and reference consistency.** For face, compare a predetermined
   quality-based burst/aggregation rule and per-sample normalization/consistency against the
   current single-frame path. For voice, evaluate complete-utterance speaker evidence and
   sufficient speech support, with word checking performed independently on the same take.
   Any required new reference collection is an explicitly approved identity-maintenance or
   isolated-development operation, never a silent profile update or enrollment reset.
4. **Compare models only on an identified weakness.** Keep YuNet/SFace as the initial face
   control; assess a dedicated speaker verifier if stable whole-utterance Vosk evidence is
   inadequate. Freeze preprocessing, capture conditions and thresholds for each comparison.
   Compare errors and latency, not just the number of accepted owner attempts. Consult the
   [primary-source model assessment](pc-biometric-model-evaluation-2026-09-06.md).
5. **Calibrate independently, then freeze.** Use separate, consented development sessions
   containing representative genuine variation and consenting nonowner examples. Choose
   operating points against a documented false-match/false-rejection tradeoff; owner-only
   successes cannot establish discrimination. A finite set with zero false accepts is not
   proof of safety. If the required separation or timing cannot be achieved, record a
   feasibility failure rather than weakening the gate. Use fresh held-out trials afterward.

Recommended first implementation scope, **pending user direction**: the read-only diagnostic
mode and explicit device visibility/binding in steps1–2. Whole-utterance voice extraction is
the first candidate algorithm study because the current first-segment mismatch is visible in
code. No model replacement is selected by this report. Do not bundle threshold changes,
reenrollment, VAD dependency installation or camera purchases into that scope.

## Acceptance remains separate

The initial100-owner-attempt/five-day requirement, at least95 first-attempt successes and
every successful baseline check within10 seconds remain controlling. Existing ad hoc attempts
are developmental troubleshooting, not a passed or restarted acceptance series. Preserve
known failures rather than replacing them with retries. The agreed consenting-nonowner,
photo/video, recorded/generated voice and actual substituted-device tests remain required;
identity recognition and speech detection alone do not establish liveness or input integrity.
[Approved specification](../../.scratch/pc-biometric-desk/spec.md),
[Ticket07](../../.scratch/pc-biometric-desk/issues/07-spoof-input-hardening.md),
[Ticket08](../../.scratch/pc-biometric-desk/issues/08-acceptance-handoff.md).

## Open evidence

The failed attempt's exact channel scores, actual active camera mode, microphone used for
enrollment, selected speaker segment length, within-enrollment dispersion, representative
error distributions and stage timings remain unknown. No source can supply these local
measurements. The live validation app was closed normally with exit0 at the user's direction
to pause trials. Ticket03 remains unresolved while capture/model evaluation is underway.
