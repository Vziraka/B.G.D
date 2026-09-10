# 03 — Fresh verification for one desktop action

**Controlling disposition: retired and dormant.** The standalone PC app and voice-identity check are removed from the finished product by the [scope clarification](../spec.md#controlling-disposition-retired-and-dormant). All content below is dated history. It creates no implementation, testing, validation, packaging, evidence-refresh or reporting task. Repository files, installed software and profiles remain untouched pending any separate removal decision.

Status: wontfix
Blocked by: 02

## Historical checkpoint

**September 9 direction:** the owner requests full PC implementation first and real acceptance later, retains UI B with polish, and permits evidence-led model/reference changes while preserving the existing profile until a tested, agreed migration. A completion-plan grilling session is in progress; the [spec amendment](../spec.md#approved-completion-direction--2026-09-09) records the settled scope. Historical model-change restrictions below are superseded only by this bounded direction; capture and deletion remain session-specific.

**Ready-for-human and unresolved.** Fresh development verification, opt-in diagnostics and the recording-readiness fix are implemented. A real take passed face identity, audio quality and words but failed speaker identity; neither its cause nor recognition improvement is established.

**Next evidence:** the [three-sample voice consistency study](../../../docs/pc-biometric/verification-boundary.md#recording-readiness-and-voice-consistency-study--2026-09-06), using separate fresh consented requests and one explicit microphone. It measures consistency without authorizing an action, updating enrollment or saving raw captures/score files. Real interruption/privacy/timing evidence and later security defenses still gate acceptance.

Continue authorized diagnosis and fixes without weakening requirements. This checkpoint adds no capture-session, model/threshold-change, production-profile or hardware authorization. The [latest implementation record](#2026-09-06--recording-readiness-correction-and-voice-consistency-study) preserves the evidence and exact boundaries.

**Specification:** [M1 PC biometric desk application](../spec.md)

**What to build:** A fresh face-and-voice workflow for one harmless desktop action, with a result bound to that request and no reusable unlocked session.

- [x] Use fresh inputs from both actual supported capture paths and integrate the initially selected verification/challenge policy; no single-channel match authorizes the action.
- [x] Bind the result to its request and current identity state, then execute the harmless desktop result immediately after a final state check.
- [x] Reject missing, failed, obsolete, canceled or replayed evidence/results; a completed result cannot authorize a later request or survive restart as permission.
- [x] Measure request-to-authorization duration including prompts, preserving the ten-second normal-success target and clear success/failure outcomes.
- [x] Keep ordinary raw captures transient, do not silently adapt enrollment and expose no aircraft action.
- [x] Cover positive/negative workflow outcomes with deterministic tests and separately document real-device evidence when authorized.
- [x] Mark this as developmental until retry protection, attack hardening and integrated acceptance are complete; recognition-only success is not a hardened release.

Implementation boxes above do not claim actual-device verification success. Resolution gate:
- [ ] Separately consented real verification, interruption/reopen/privacy and timing evidence.

Tickets 04 and 07 complete mandatory defenses before the final acceptance ticket can pass. This slice must not advertise their pending work as validated protection.

## Comments

### 2026-09-06 — Implementation claimed

User requested repository/context review followed by Ticket03 implementation. Ticket02
is resolved. Scope is code, synthetic validation and documentation; no new biometric
capture session, production profile mutation, hardware work, commit or push. Reuse the
existing disposable capture worker, protected authority and operation lock. Real-device
verification evidence remains pending separate session consent.

### 2026-09-06 — Development implementation ready for device validation

[Boundary, policy and reproducible checks](../../../docs/pc-biometric/verification-boundary.md)
record the implementation and outstanding evidence. New `verification.py` owns the one-request
receipt and final profile/account checks; capture reuses the existing quality/device paths
with one stable face and one four-number random spoken challenge. Both identity comparisons
must pass. UI B has deliberate consent, preview/voice controls, cancellation and full elapsed
timing. Default launch keeps actual capture blocked. No production enrollment was read or
changed, and no real camera/microphone/Windows validation ran.

Ticket03 remains unresolved/ready-for-human until the named device evidence is collected.
Tickets04/07 retain persistent retry and attack-hardening obligations; no biometric or M1
acceptance is claimed. No commit or push.

Final validation: **108/108 automated tests pass**, strict mypy2.3.1 passes13 source
modules, compilation and scoped whitespace checks pass. Twelve new tests exercise the
public workflow, request-tagged child protocol and real Tk controls with synthetic device/
model outputs. The inherited enrollment/storage checks remain passing. No independent
agent review or actual-device verification is claimed.

### 2026-09-06 — Initial real validation rejected; reporting defect corrected

The user authorized starting validation and used the consent-gated normal app. Preflight
confirmed an unelevated process, readable owner-bound profile and pinned models. The user
reported progressing through face capture but repeated voice failure, then supplied the
message “Spoken challenge did not pass. No action authorized; start a fresh check.” Exact
attempt count and elapsed timings were not recorded. This message identifies a pre-speaker-
comparison challenge rejection; reaching voice is not evidence of a successful face identity
comparison. The underlying real rejection cause is still unknown.

Synthetic regressions reproduced a separate reporting defect: specific capture guidance was
discarded by the capture exception, child response and final workflow message. Those handoffs
now preserve only allow-listed fixed quality/word/signature guidance. Arbitrary error text,
transcripts and references are not forwarded. No threshold, phrase policy, model or enrollment
change was made. Final suite:109/109 tests pass; strict typing passes13 modules; compilation
passes. The old app closed with exit0 before relaunching the diagnostic build. A further
deliberate in-app-consented request is needed to identify the actual failing voice condition.

### 2026-09-06 — Too-quiet failure reproduced with usable speech

The user reported “Voice is too quiet” with and without a headset; exact attempt counts
and timings remain unavailable. PortAudio's current input was EarPods when inspected
without opening a stream. Synthetic capture reproduced the same rejection from a single
soft0.25s block despite1.75s of qualifying speech, exact recognized words and a valid
speaker vector. The early/middle/late-block cases all failed before the correction.

The shared capture routine no longer treats that brief dip as a permanent failed take.
It still requires1.5s of speech above the unchanged volume/SNR thresholds, retains clipping/
interruption/noise failures, and rejects consistently quiet recordings. Enrollment and
verification use the same correction; no profile is adapted. Policy is now
`desk-verification-dev-2` to distinguish this behavior from the earlier real attempts.
This reproduces a code defect consistent with the symptom, not proof that it explains
every real failure. A new deliberate owner check remains necessary; Ticket03 stays open.

Validation after correction:111/111 automated tests pass; strict mypy passes13 application
modules; compilation passes. The prior app closed normally with exit0 before restart.

### 2026-09-06 — User pauses pass/fail trials for capture/model evaluation

The user reports both capture stages completed but the overall check still rejected, and
explicitly requests evaluation of face/voice capture and detection rather than engineering
a forced pass. No per-channel scores or exact elapsed time were retained; neither identity
channel is established as passing. The running validation app was closed normally with exit0.

The [capture and evaluation assessment](../../../docs/research/pc-biometric-capture-assessment-2026-09-06.md)
audits device selection, quality gates, reference consistency, one-frame face verification,
first-segment speaker extraction and uncalibrated match thresholds. It proposes read-only
diagnostics/device binding first, followed by controlled capture/model studies and separate
calibration/held-out acceptance. The [primary-source model review](../../../docs/research/pc-biometric-model-evaluation-2026-09-06.md)
supports candidate selection without treating benchmark results as local acceptance.

This evaluation changed documents only. No new capture, threshold/model change, profile reset
or adaptation, dependency installation, purchase, commit or push occurred. Live trials remain
paused and Ticket03 unresolved; subsequent implementation and concrete capture/data sessions
need their own agreed scope. Approved usability, security and later-ticket obligations remain.

### 2026-09-06 — Diagnostic evaluation implementation authorized

User says “Ok then Start it” after the proposed separate-channel diagnostics and capture/
reference-consistency evaluation. Begin the bounded first slice: opt-in memory-only score,
capture-quality, selected-device and segment/timing diagnostics, plus consistent microphone
binding within a request. Keep all match/challenge thresholds, models and reference recipes
unchanged; do not reset/adapt the profile. Synthetic validation precedes a new deliberate
in-app-consented diagnostic session. No retained recordings or score files are authorized.

### 2026-09-06 — Diagnostic first slice validated

Implemented opt-in per-channel identity scores, final face-quality measurements, selected
camera/microphone details, audio quality and speaker-segment support, plus stage/result
timing. The verification request pins room measurement and recording to the same microphone.
Reports remain in memory and clear on new check/navigation/interruption/close; stale or
cancelled evidence cannot expose scores. No transcript, raw-media or score file is written.
The existing first speaker vector, model/reference recipes and dev-2 thresholds are unchanged.

Validation: **115/115 tests pass**, including separate mismatch diagnostics, default-off and
cancelled/stale suppression, worker request binding, changing-default device binding,
segmented speaker metadata and the real Tk report/cleanup flow using synthetic devices.
Strict mypy2.3.1 passes13 modules; compilation and scoped whitespace/conflict checks pass.
Read-only preflight confirms unelevated operation, valid models, readable encrypted profile,
owner agreement and identical profile/diagnostic file hashes and protected-authority digest
to the pre-validation snapshot. No new real capture was performed by these checks.

The diagnostic-enabled application is prepared for a deliberate in-app-consented check.
Real per-channel scores, recognition consistency and the previous rejection's cause remain
unknown. Ticket03 stays ready-for-human and unresolved. No model swap, profile adaptation,
threshold relaxation, hardware action, commit or push occurred.

### 2026-09-06 — Recording readiness correction and voice consistency study

The user reports three further attempts spanning quiet-audio, wrong-phrase and combined
matching failures. Their pasted diagnostic report establishes that the latest attempt passed
face identity, audio quality and exact words, but failed speaker identity. A single speaker
segment covered the complete recording, so first-segment truncation does not explain that
attempt. No numerical biometric report is copied into this ticket or saved to a score file.

The user authorizes fixing the issue without weakening project/test integrity. A deterministic
public-capture test reproduced an independent timing defect: the recording control was
announced before the microphone stream opened. The UI now says opening/wait, and announces
Recording only after stream startup. The capture timer starts after startup. This removes
misleading readiness; its effect on the reported recognition failures remains unmeasured.
Policy is `desk-verification-dev-3`; identity/quality/word thresholds and reference/model
recipes are unchanged.

Added an explicitly enabled three-sample voice consistency study through the current UI and
capture boundary. It uses one explicit microphone and separate fresh, consented requests.
Only completed quality/word-qualified samples enter pairwise voice comparisons against each
other and enrollment. It returns measurements even for identity mismatches and NEVER returns
authorization, including when both identities match. Raw captures still end with each request;
up to three temporary derived voice vectors remain in memory for comparison until completion,
cancellation, navigation, Windows interruption, app close or five minutes from the first
sample. Nothing is saved to the enrolled profile or a diagnostic file. Fresh study consent
discloses this longer temporary-vector lifetime. Each request retains its sixty-second expiry;
the study is development evidence, not relaxed ordinary verification or acceptance testing.

The current speaker mismatch cannot yet be attributed to enrollment, microphone variation or
the model. Real study measurements are the next required evidence; no automatic adaptation,
model replacement or threshold adjustment has been made. Ticket03 remains unresolved.

Validation: **120/120 tests pass**, strict typing passes13 source modules, compilation and
scoped whitespace/conflict checks pass. The previous diagnostic app closed with exit0.
Read-only comparison confirms the production encrypted profile/diagnostic files and protected
authority are unchanged. The new study app launched unelevated with capture waiting for
in-app consent, bound to the enumerated EarPods input1. No new real capture was initiated
by the agent; study results and actual recognition improvement remain pending.
