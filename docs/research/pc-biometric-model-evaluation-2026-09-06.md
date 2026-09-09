# PC biometric model evaluation — 2026-09-06

Status: supporting research and proposed evaluation; no model adoption or acceptance-policy change. Requested after the owner reported that both captures completed but verification still rejected. That report does not identify which identity comparison failed or establish usable embedding quality.

Provenance: written in the main checkout on branch `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. The inspected Ticket03 implementation includes uncommitted work; the base commit alone is not its source. Primary web sources checked on 2026-09-06. No capture, model installation, profile access/change, threshold change, commit or push occurred for this research. The [Ticket03 boundary](../pc-biometric/verification-boundary.md) and [ticket comments](../../.scratch/pc-biometric-desk/issues/03-single-action-verification.md) control project scope.

## Finding and priority

**Measure the evidence supplied to each matcher before replacing either matcher.** The strongest concrete weakness is that the current voice path can recognize the whole phrase while selecting a speaker embedding from only its first eligible segment. A dedicated speaker model is a credible comparison candidate, but cannot repair incomplete audio supplied to it. Face capture quality and template construction also deserve evaluation before attributing failure to SFace.

The existing requirement remains both fresh channels passing, with the ten-second normal-success target and separate attack-hardening obligations. A higher owner success rate alone is insufficient evidence for adoption; impostor and attack behavior must remain part of evaluation. No proposal here authorizes lowering the current thresholds or repeatedly adjusting them against the same failed owner attempts.

## Voice: separate words, usable speech and speaker identity

The [current capture implementation](../../pc_biometric/capture.py) recreates `KaldiRecognizer` after each `AcceptWaveform()` endpoint, concatenates segment transcripts, then selects the first result containing a `spk` list. It never inspects `spk_frames`. Its 1.5-second qualifying-audio gate counts loud quarter-second blocks across the take, not the nonsilent feature frames that contributed to that selected vector. **Inference:** a long enough take and correct combined words can coexist with a short or unrepresentative speaker vector. This is a code-path concern, not a proven explanation for the owner's latest rejection.

The pinned Vosk 0.3.45 source sets `MIN_SPK_FEATS` to 50, builds features using recognizer-derived nonsilence indices and returns their count through `spk_frames`; below that count it omits the vector. This is an extraction minimum, not a validated speaker-quality threshold. Do not convert it into a reliable speech-duration requirement without verifying the model's frame settings. [Version-pinned recognizer source](https://github.com/alphacep/vosk-api/blob/v0.3.45/src/recognizer.cc).

Vosk's official example compares each result separately, reports `spk_frames`, and says utterances longer than four seconds produce better speaker vectors. It does not establish a universal four-second cutoff or recommend using the first vector as a whole-recording representation. [Official speaker example](https://github.com/alphacep/vosk-api/blob/master/python/example/test_speaker.py).

The official model catalog lists `vosk-model-small-en-us-0.15` as a 40 MB lightweight English ASR model and `vosk-model-spk-0.4` as a 13 MB speaker model whose accuracy entry is `TBD`. Their tasks differ: recognizing a number phrase does not validate speaker identity. Published ASR word-error results do not measure this application's exact-challenge failure rate, speaker matching, or spoof resistance. [Vosk model catalog](https://alphacephei.com/vosk/models).

Proposed comparison, before any replacement:

1. Make the contributing speaker segment observable in a bounded diagnostic result: segment count, selected segment, `spk_frames`, actual contributing duration and separate rejection stage. Raw audio/transcripts remain transient unless separately agreed for a specific experiment.
2. Compare current first-segment behavior with a deliberately specified whole-utterance speaker extraction path using the same speech. Do not select whichever segment scores highest against the owner. Test pauses, quiet lead-in, mixed speakers and wrong spoken challenges as well as genuine speech.
3. Measure genuine and nonowner score distributions across built-in microphone/headset and across sessions, using separate enrollment and evaluation material. Evaluate whether the four-number challenge supplies enough speech within the complete ten-second workflow. Longer speech is a candidate experiment, not an approved UI/policy change.

### Dedicated speaker candidate: SpeechBrain ECAPA-TDNN

`speechbrain/spkrec-ecapa-voxceleb` explicitly targets speaker verification and embedding extraction, uses 16 kHz single-channel recordings, and reports 0.80% equal-error rate on cleaned VoxCeleb1-test. Equal-error rate is the operating point where false accepts and false rejects balance; it is not this project's security acceptance rate. The model card disclaims performance guarantees on other datasets. **Inference:** this is a justified offline comparison candidate for speaker extraction, not evidence that short number phrases, this microphone or the owner will work better. Its embeddings require their own separately enrolled references and policy; existing Vosk vectors cannot be compared to them. [Model card](https://huggingface.co/speechbrain/spkrec-ecapa-voxceleb).

Keep the ASR challenge check independent during that comparison. A speaker-model improvement does not by itself improve exact-word recognition; changing both models simultaneously would obscure the cause of any improvement.

## Face: preserve a baseline, investigate capture and enrollment

OpenCV separates YuNet detection from SFace recognition and demonstrates aligning/cropping using detected landmarks before feature extraction. Its SFace tutorial gives different cosine thresholds for different benchmark datasets: 0.363 on LFW, 0.340 on CALFW and 0.275 on CPLFW, among others. Thus the current 0.363 example does not establish a transferable false-match operating point for this webcam or its averaged enrollment reference. No alternative tutorial threshold should be substituted to make a rejection pass. [OpenCV 4.13 tutorial](https://docs.opencv.org/4.13.0/d0/dd4/tutorial_dnn_face.html).

The model's own documentation identifies MobileFaceNet instances trained using the SFace loss and five-landmark warping. The audit should first establish that capture supplies well-exposed, sharp, sufficiently sized and consistently aligned faces. [SFace model documentation](https://github.com/opencv/opencv_zoo/blob/main/models/face_recognition_sface/README.md).

The local implementation averages eight raw enrollment features and normalizes the result, while verification uses one captured frame. It does not retain within-enrollment consistency measurements. **Inference:** stable detection is insufficient to show that the enrollment centroid represents the owner consistently, and averaging unnormalized features can give larger-norm samples greater influence. Evaluate normalization and aggregation using independent examples and impostor comparisons; do not choose an owner-score-maximizing frame or silently refresh the profile. Record actual negotiated camera resolution, face size, pose, exposure/sharpness and per-stage timing in a deliberately bounded diagnostic session. [Capture source](../../pc_biometric/capture.py), [verification policy](../pc-biometric/verification-boundary.md).

### Conditional face comparator: InsightFace `buffalo_l`

If good-quality SFace inputs still show inadequate genuine/impostor separation, one bounded comparator is the official `buffalo_l` pack: SCRFD-10GF detection plus ResNet50@WebFace600K recognition, with CPU ONNX Runtime supported. The official pack is 326 MB and includes modules beyond this task; no attributes or unrelated modules are required. Its code is MIT, but provided pretrained models are restricted to non-commercial research. It is therefore an evaluation candidate with a model-license constraint, not a production replacement. Current Windows/Python 3.13 packaging and performance have not been tested here. [Official InsightFace package and model documentation](https://github.com/deepinsight/insightface/tree/master/python-package).

## Runtime, offline behavior and license evidence

| Component | Code license | Published model terms | Adoption evidence still needed |
| --- | --- | --- | --- |
| Current OpenCV/YuNet/SFace | [OpenCV Apache-2.0](https://github.com/opencv/opencv/blob/4.13.0/LICENSE) | [YuNet directory MIT](https://github.com/opencv/opencv_zoo/blob/main/models/face_detection_yunet/README.md); [SFace directory Apache-2.0](https://github.com/opencv/opencv_zoo/blob/main/models/face_recognition_sface/README.md) | Preserve exact artifact hashes/notices and demonstrate local matching performance. |
| Current Vosk ASR/speaker | [Vosk Apache-2.0](https://github.com/alphacep/vosk-api/blob/v0.3.45/src/recognizer.cc) | Both selected models listed as Apache-2.0 in the [catalog](https://alphacephei.com/vosk/models) | Selected-vector adequacy, device/session generalization and challenge performance. |
| SpeechBrain ECAPA candidate | [SpeechBrain Apache-2.0](https://github.com/speechbrain/speechbrain/blob/develop/README.md) | [Model card Apache-2.0](https://huggingface.co/speechbrain/spkrec-ecapa-voxceleb) | Exact dependency/model pins, unelevated offline loading, memory/startup/inference measurements and independent verification/attack evidence. |
| InsightFace comparator | MIT | Provided weights: non-commercial research only | Resolve intended-use model permission separately from code permission; benchmark exact selected artifacts. [Official terms](https://github.com/deepinsight/insightface/tree/master/python-package). |

Python 3.13 is not by itself an established blocker for ECAPA: current PyTorch Windows documentation includes it, and the TorchAudio compatibility matrix includes compatible Python 3.13 combinations. This does not prove an exact SpeechBrain/Torch/TorchAudio/Hugging Face dependency bundle works here. Resolve and smoke-test an isolated pinned bundle before adoption, including import, tensor inference, cancellation and cold startup. [PyTorch Windows prerequisites](https://pytorch.org/get-started/locally/), [TorchAudio compatibility matrix](https://docs.pytorch.org/audio/stable/installation.html).

SpeechBrain supports local sources and network-disabled fetching; its default symlink strategy has Windows permission implications, with copy/no-link alternatives documented. A candidate should load an explicitly staged, hashed local model under the existing unelevated worker boundary. Demonstrate operation with network unavailable; do not rely on a first-use download or change system privileges to satisfy model loading. [SpeechBrain fetching API](https://speechbrain.readthedocs.io/en/latest/API/speechbrain.utils.fetching.html).

No commercial quote, total bundle footprint, CPU latency, RAM peak or integration effort estimate was obtained. Public downloadable weights are not evidence of zero integration or licensing cost for every intended use. The ten-second target includes prompts, capture, model startup and the final action, so inference-only benchmarks cannot close that requirement.

## Matching is separate from liveness and injection resistance

These recognizers compare identities or words; their cited benchmarks do not validate the presence of a live owner or trustworthy physical sensors. The ASVspoof organizers evaluate replay, synthetic/converted speech and deepfake countermeasures separately, and report generalization limits across real acoustic environments and datasets. Adding ECAPA does not supply those countermeasures. [ASVspoof 2021 analysis](https://arxiv.org/abs/2210.02437).

For this app, photo/video presentation, assembled or generated challenge speech, mixed-speaker takes and substituted/virtual-device inputs remain separate tests. Capture improvements and model comparisons must retain negative cases, the fail-closed combined decision, fresh request binding and the existing Ticket04/07 obligations. [Development boundary](../pc-biometric/verification-boundary.md).

## Decision gate

Proposed order: diagnose each stage and its contributing evidence; evaluate capture/enrollment consistency; then compare the current speaker extractor against ECAPA on independently consented material. Retain SFace as the face baseline unless evidence justifies the conditional comparator. Freeze an evaluation policy before held-out trials; report false rejects, nonowner false matches, wrong-challenge acceptance, attack outcomes, acquisition failures and complete elapsed timing separately. Existing owner trials cannot become a training target and then be counted again as independent acceptance.

Unresolved: exact latest rejection stage/scores; selected speaker segment duration; enrollment consistency; model-specific separation across devices/sessions; ten-second feasibility; and attack resistance. No empirical improvement or successful verification is claimed.

### Local source fingerprints at inspection

SHA-256, for uncommitted source provenance:

- `pc_biometric/capture.py`: `C2317F36BB8782695F8D709893717AC77520A2E04FDE13CCE1672F5A92982FBD`
- `pc_biometric/verification.py`: `97892ABC0A69BA1C1C3CAE21F52FCC33E4550C14965BD0836FEE83EDA408E0BA`
- `docs/pc-biometric/verification-boundary.md`: `94152A21DC8515A00D5B4E82C910AFB69642580358CC6A9825A8DE2FC2CC4359`
