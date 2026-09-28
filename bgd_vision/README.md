# Pi camera desk application

**September 22 workspace:** open the existing camera URL and use Conversation to request a task, review the interpreted action/target, then confirm that exact proposal. Type or speak a correction to replace it. Cancel discards the proposal; the persistent Stop clears both trackers and pending work. Face setup and Test tools contain the diagnostics. Spoken replies use a local installed browser voice when available. See the [design/verification handoff](../docs/phone-drone/pi-workspace-design-2026-09-22.md) and [editable Figma design](https://www.figma.com/design/y6naEaCOp7cpkXOsdn6Ga6?node-id=2-129). The page labels basic commands; broader local-language candidates remain disabled after consequential semantic failures. This is a private camera desk application with no aircraft output.

**Current automated evidence:** 147 vision tests ran locally/on Pi, with5/3 skips and all remaining tests passing;35 simulator tests and both browser suites pass. The [606.49-second sustained run](evidence/pi-thread-budget-2026-09-22.md) passed every fixed gate, though minimum display rate15.050fps was only0.050fps above the floor; [person recovery evidence](evidence/person-bounded-search-2026-09-22.md) distinguishes state-machine tests from physical identity accuracy. Historical scope/results below remain dated evidence.

**September 20 current scope:** this application now includes temporary face enrollment/verification and liveness experiments, Vosk speech and typed commands, simulation-only target missions, object tracking/multi-view recovery, numeric range guides and a separate read-only MAVLink monitor. The older initial-slice descriptions below are dated history. Fresh host verification passes 107 vision tests (4 skips) and 35 simulator tests; live Pi status is healthy at 30 capture/vision fps. The existing-hardware desk agenda is sufficient to proceed to aircraft affordability/compatibility review, not a declaration that all product software is finished. Heavy-workload frame-rate misses and physical/flight limits remain in Issue12.

**Latest September 17 status: owner-observed crossings, ordinary movement and brief solo-pose recovery passed. The revised ten-minute sampled runtime check passed:26.7–30.2displayedfps,21.5–30.3visionupdates/sec,no power flags or application errors. Current configuration is the working desk baseline; measured identity accuracy, physical latency and flight remain unqualified. Aircraft purchase stays held pending affordability/compatibility review.**


The original fixed-camera person-tracking slice uses Picamera2 full-field 960x540 at30fps, YOLO26n NCNN person detection at320input, OSNet x0.25 person-trained appearance features, and BoxMOT25 Deep OC-SORT associations. A separate selected-target gate checks whether an association is supported. Capture/display and inference independently use the latest frame. Later dated sections extend this baseline; no aircraft actuator interface exists.

### Face-recognition evaluation probe — September 17

The Pi now has an isolated, non-authorizing OpenCV face probe in `face.py`. It uses the official YuNet detector and SFace recognizer through the already installed OpenCV5.0.0 APIs. It does not alter the person tracker, save camera images, enroll anyone, grant permission, or claim liveness.

The reproducible blank-input check passed on the Pi while the tracker remained running: YuNet/SFace loaded in137.0ms, YuNet returned no face for a blank320x320 image, SFace returned a finite128-value feature, and identical features compared at1.0 cosine similarity. An earlier ten-sample blank-frame timing measured19.9ms median and20.4ms p95 for YuNet. OpenCV reports that its optional ONNX Runtime engine was not compiled in; its built-in graph-engine fallback executed both models successfully, so no additional runtime was installed.

Models are outside the source checkout under `/home/bgd-pi/bgd-vision/models/opencv_face/`:

- `yunet.onnx`, official `face_detection_yunet_2026may.onnx`, SHA256 `ebafce4e3c118d6554634be5c27ab333b4c047a9a8c3faf1d7cf93101c22f0f0`; directory license MIT.
- `sface.onnx`, official `face_recognition_sface_2021dec.onnx`, SHA256 `0ba9fbfa01b5270c96627c4ef784da859931e02f04419c829e83484087c34e79`; directory license Apache-2.0. The exact pretrained weight's training-data/commercial provenance remains under public clarification, so treat it as an evaluation model rather than a settled distributable-product dependency.

The first live, non-recorded check then read one current JPEG from the existing loopback preview into memory. Exactly one face was detected in the960x540 frame:232x344 pixels at0.926 detector confidence. Detection, alignment and feature extraction took189.1ms while the tracker continued running; SFace produced a finite1x128 feature. The script printed no feature values and discarded both JPEG bytes and feature before exit. This passes live feature extraction only, not repeat identity matching, accuracy, liveness or authorization.

Next evidence is a predeclared in-memory repeat-matching test. Face matching and liveness remain separate gates.

### Guided in-memory enrollment

The private browser now has an explicit guided enrollment mode before matching. It reuses YuNet's five landmarks; no new package was added. The service analyzes at a deliberately low rate while enrollment is active so the working person tracker keeps priority. The guide requires exactly one face, detector confidence at least0.90, face height30–75% of the frame, center within20% of the image center, and two consecutive acceptable observations for each stage. It captures straight, screen-left, screen-right, slightly-up and slightly-down features relative to the initial straight pose.

Five SFace features remain only in application memory. Cancel, an enrollment error or service exit discards them. HTTP/browser status exposes stage, prompt and progress but never feature values or pose measurements. Completion grants no command permission and establishes neither identity accuracy nor liveness. The first physical run must verify that the landmark-direction signs and thresholds match the actual Camera Module3 view; passing synthetic state tests alone does not calibrate face geometry.

Deployed checks:56 vision tests,35 simulator tests and the actual-app preview-loop regression pass. The restarted service reported fresh camera/tracker output, no application error,59.8C,5.04376V and0x0 power/throttle flags before physical enrollment began.

The owner then completed the physical guided sequence and reported that straight, left, right, up and down prompts appeared and progress advanced after each corresponding movement. This qualitatively validates the first-run prompt/direction mapping, not repeatability or biometric accuracy.

A one-shot **Check current face** diagnostic is now deployed. It compares one fresh query feature against all five temporary pose features and reports only minimum/median/maximum cosine scores. The published SFace demo threshold0.363 is a provisional evaluation baseline; every enrolled-pose comparison must meet it for the displayed baseline pass. The endpoint never exposes feature vectors, writes images/templates, tests liveness or grants permission. Deploying it restarted the service and therefore intentionally discarded the first temporary set; guided enrollment must be repeated once before the first match check.57 vision tests pass after this addition.

The repeated guided enrollment completed and the first genuine-user one-shot check passed the provisional baseline: five comparison scores ranged0.560–0.698, median0.606, all above0.363. Enrollment remained complete with five in-memory features. At observation the combined service reported22.9visionupdates/sec,22.8displayedfps,61.5C,0x0 power flags and no application error. This single same-session result does not establish a final threshold,95% accuracy, other-person rejection, replay resistance or liveness.

A different consenting person was then placed alone in view while the same five-feature enrollment remained in memory. The acceptance rule was declared before measurement: the maximum comparison score must stay below0.363. The result ranged-0.079–0.030, median0.018, so the endpoint returned no match and the rejection check passed. This single impostor attempt does not establish a false-acceptance rate, production threshold, general accuracy, spoof resistance or liveness.

The browser now presents the check as three large, separate status cards: Face match, Liveness and Combined result. Verify face visibly transitions through Checking to Passed or Not a match. Liveness remains Not tested because no liveness detector exists yet, and the combined card remains Verification incomplete or Waiting for liveness even after a face match. This is presentation of existing evidence, not a new authorization state. The change required no dependency or service restart;58 vision tests,35 simulator tests and preview-loop regression pass.

Liveness baseline: with the enrolled person absent, a clear frontal photo of that person displayed on a phone screen produced face similarities0.435–0.566, median0.503, and passed the provisional0.363 face threshold. This demonstrates that SFace identity matching alone accepts this presentation attack. It does not evaluate a liveness detector; the UI must continue to show Liveness Not tested and combined verification incomplete until a separate anti-spoof check exists and passes.

The isolated Minivision Silent-Face-Anti-Spoofing candidate is pinned on the Pi at commit `b6d5f04ad78778917853b25c778acef6d5626d15`; its Apache-2.0 code and two official MiniFASNet weights remain outside the checkout under `candidates/`. `liveness.py` reuses YuNet because OpenCV5 removed the candidate's bundled Caffe importer. Its preprocessing intentionally preserves the upstream byte-scale0–255 tensor: an initial divide-by255 adapter error made the known-real fixture fail and invalidated the first physical attempt. After correction, upstream fixtures classify as expected: known-real label1/probability0.9999; two known-fake fixtures label2/probabilities0.2286 and0.0026. The `--expect-label` fixture assertion protects this seam. This is model/runtime compatibility evidence, not local-camera accuracy or authorization.

The fixed five-frame smoke cases then passed: the live enrolled person produced5/5 real labels with0.9983–1.0000 real probability, while the same phone-screen photo that fooled face matching produced0/5 real labels with0.0002–0.0004 real probability. The deployed `/liveness/check` repeats that five-distinct-frame rule after enrollment and reports only counts and probability summaries. The browser keeps Face match and Liveness independent and shows combined diagnostic success only after both pass in the current page. No image is written and no command permission is created. This limited smoke evidence does not cover different people, lighting, displays, printed photos, masks, video replay or deepfakes and does not select a production threshold.

## Use

With the provisioned Pi powered and on the same reachable network, run from the repository:

```powershell
.\bgd_vision\start.ps1
```

The page is `http://127.0.0.1:8765/`. Both ends bind only to loopback; SSH encrypts the laptop/Pi connection. Select while both people are clearly visible and separated; Clear selection stops tracking. Overlap, missing-ID occlusion or suspicious appearance enters **Temporarily hidden**, with no green box. The owner approved up to3seconds for this state, replacing the original subsecond terminal-loss rule for ambiguous blockage/hidden exit.

Crossing recovery requires both people visible/separated, a nearby candidate with cosine similarity>=0.90 to the selected reference, a>=0.08 advantage over current competitors and over stored other-person references, plus at least3 strong matches spanning>=150ms within a500ms evidence window. One borderline appearance observation can interrupt that sequence only if every other check still passes; it never counts toward or completes recovery. A second weak observation or a contradictory match resets confirmation. Stored references freeze during uncertainty. The spatial check predicts limited movement from recent clear observations, rather than expecting the person to stay at the pre-blockage position. A tracker ID may change only after these independent checks; the number itself is not identity. Thresholds are provisional. Similar clothing or mixed crops can still defeat matching; this is not biometric identity evidence.

A separate solo-pose exception applies only when the same selected person has remained the sole detected person since selection, with continuous spatial overlap and no missing detection. A brief appearance change may recover on the same strong appearance/stability checks without requiring a second person. Any other observed person (even without a valid appearance descriptor), changed ID, missing detection or broken spatial continuity revokes that exception. The reference remains frozen while uncertain. Holding a poorly matched pose beyond three seconds still causes Lost; this change does not establish pose-invariant recognition.

Timeout, stale inference beyond750ms, or clear disappearance outside a checking interval causes latched **Lost**; returning then requires manual reselection. The3second choice does not extend stale-data allowance. Clear/reselection resets reference memory. While Tracking, clear matching observations adapt the selected reference slowly; similarity below0.80 or similarity to a remembered other person removes green tracking.

The startup command does not run at boot. Stop the remote process with SIGTERM; it closes the camera. Keep the laptop awake while it powers the Pi. Files are deployed under `/home/bgd-pi/bgd-vision`; runtime logs are in its `logs` directory. Recording is off: `metrics.jsonl` contains performance/status data, while opt-in live face-range requests append timestamp, quality, approximate metres, face pixel size, detector confidence and match scores to `face-range.jsonl`. Neither log stores images, face boxes or biometric features. Viewing live imagery is local to this page. Close the page to stop browser traffic; the Pi service continues until stopped.

## Accepted test card - September 17, amended by owner

Configuration: fixed Camera Module3, Pi5 8GB/cooler, full-field960x540video,320detectorinput. Record lighting, near/far distances, camera position, participants and actual power connection before timed acceptance.

| Check | Acceptance |
| --- | --- |
| Display | At least15displayedfps; at least95% observations below500ms end-to-end |
| Detection/tracking | At least5freshupdates/sec |
| Scripted left/right, near/far and turning | Correct selected target for at least95% of clearly visible time |
| Ambiguous blockage or hidden exit | No green target while uncertain; up to3seconds for confident recovery, then latched Lost (owner-approved amendment) |
| Clear exit without overlap | Immediate loss on disappearance; manual reselection afterward |
| Five crossings | No silent target switch; report successful recoveries separately from conservative Lost |
| Combined ten-minute revised workload | No restart, application failure, power/throttle flags or growing delay |

The3second amendment was approved explicitly after the original1second policy was found too short for ordinary crossings. Other thresholds are unchanged. Prior workload results do not qualify the new configuration.

Unperformed cases stay untested. Vision quality/crossing/target-loss timing need human observation, not synthetic tests or an empty room. First select the owner's box, then perform the scripted motions; after loss explicitly select again. Do not infer physical qualification from unit tests.

The UI reports rolling displayed fps and a conservative estimate of capture-to-browser-presentation delay: camera first-row SensorTimestamp age when the server snapshots the frame, plus the complete browser fetch/decode/draw/next-animation-frame duration. Including the entire request duration overcounts some transit/server time. It uses one Pi clock domain, requires fresh frames, and does not synchronize laptop/Pi wall clocks. This is an estimated upper bound, not an instrumented photon-to-photon measurement; camera exposure/readout and browser/compositor behavior limit interpretation. A physical visible-timer check is still needed for strict end-to-end acceptance. The video can update faster than detection; vision-frame age is shown separately. Five-second browser telemetry is only meaningful while its page is visible.

## Verification

```powershell
python -m unittest discover -s tests/vision -v
python -m unittest discover -s tests/phone_drone_sim -v
```

Selection tests cover disappeared/returned IDs, crossings, stale inference and explicit reselection. HTTP tests cover rebinding/session/origin rejection, stale frames, malformed control requests and invalid metrics. These establish software behavior, not real tracking accuracy.

### Voice-to-Target Desk Mission v1

`POST /mission/run` is the single authenticated seam for typed commands; `/speech/transcribe` sends the Vosk transcript through that same path. Responses are always `SIMULATION_ONLY` and `actuator_output:false`. Supported desk behavior is current-view find/count, unique-target follow, enrolled-owner face-to-body selection, standalone Stop, and voice-guided centered visual prompting for an unnamed object. The fixed camera cannot scout an area.

The loaded YOLO26n detector remains the first choice. Targets outside that vocabulary lazily use the local YOLOE-26n model and the measured saved prompt profile at640-pixel input. “Follow this object” first displays a20-second center guide; repeating the phrase grounds exactly one overlapping visual-prompt result and starts ViTTrack. This is deliberate dialogue, not implicit guessing. Fixed categories use the faster class detector for correction/recovery; open-vocabulary and unnamed targets use the visual-memory path below.

Target-memory v2 adds visual recovery without persisting imagery. An unnamed or visually prompted selection keeps up to four diverse trusted crops in RAM and runs periodic YOLOE visual re-detection on a worker separate from the full-rate ViTTrack loop. Loss hides the box, searches near the last/predicted location for1.5seconds, then permits full-frame candidates until the bounded10-second deadline. Weak, multiple, implausibly sized or geometrically unsafe candidates are rejected; recovery and material visual corrections require two consistent detections. Clear, reselection and restart discard the views. This remains fixed-camera experimental behavior, not general object identity or flight guidance.

“Follow me” requires completed temporary enrollment, one matching visible face and exactly one person box containing that face center. The person tracker then follows the body; the face need not remain visible every frame. This identifies the enrolled subject for a desk simulation only. Liveness and command authorization remain separate and no biometric result produces flight authority.

## Sources and licenses

- [Picamera2](https://github.com/raspberrypi/picamera2): BSD-2-Clause; use the OS camera package through the isolated environment's system-site-packages.
- [Ultralytics Pi guide](https://docs.ultralytics.com/guides/raspberry-pi): YOLO26 NCNN deployment. Published benchmarks exclude parts of our combined pipeline and do not establish our performance.
- [Ultralytics tracking](https://docs.ultralytics.com/modes/track): explicitly select ByteTrack; do not rely on changing defaults.
- [Ultralytics licensing](https://www.ultralytics.com/license): code and model weights use AGPL-3.0 by default; no enterprise license has been purchased. This local experiment does not resolve obligations for later distribution or network deployment. No repository-wide relicensing is performed.
- [NCNN](https://github.com/Tencent/ncnn): BSD-3-Clause; [OpenCV](https://github.com/opencv/opencv/blob/4.x/LICENSE): Apache-2.0.

Installed versions and model hashes are retained with deployment evidence. Model replacement must preserve the approved behaviors; a desk pass does not establish face identity, liveness, arbitrary described-object search, area counting, navigation, darkness, range, or flight readiness.

### Provisioned runtime

September 17: Python 3.13.5 / aarch64 Raspberry Pi OS; isolated `.venv` created with `--system-site-packages` for Picamera2 0.3.37 and OS camera bindings. Ultralytics 8.4.154, NCNN 1.0.20260526, torch 2.14.0+cpu, torchvision 0.29.0+cpu, lap 0.5.13, OpenCV 5.0.0.93, inherited NumPy 2.2.4. `requirements-resolved.txt` records local venv packages; it is an inventory, not a cross-platform lockfile. CPU torch/torchvision came from `https://download.pytorch.org/whl/cpu`; remaining packages came from PyPI. Using generic ARM torch packages pulled irrelevant CUDA dependencies in resolution, so provisioning switched to CPU wheels before installation.

The official `yolo26n.pt` source model SHA256 is `9b09cc8bf347f0fc8a5f7657480587f25db09b34bf33b0652110fb03a8ad4fef`. The Pi exported it using `YOLO('yolo26n.pt').export(format='ncnn', imgsz=320)` into `models/yolo26n_ncnn_model` (FP32, about 9.3 MB). Models and virtual environments are outside the source checkout. Runtime automatic package installation is disabled; changes are explicit maintenance actions.


### September 17 framing correction

The owner reported successful sideways tracking after backing up (informal observation, not the timed acceptance run), then requested a larger/wider live view. A metadata probe reproduced two crops: default 640x480 output with 1536x864 sensor mode used ScalerCrop (1152,432,2304,1728); changing only output to960x540 expanded to (768,432,3072,1728), still cropped. Explicit 2304x1296 sensor mode with960x540 output returned (0,0,4608,2592), the full sensor area. This removes software sensor cropping; it does not change lens optics. Preview now spans page width, with controls below, and Expand video/Return to controls (or Escape) preserves the whole aspect ratio. Click mapping uses canvas dimensions. Brief post-change browser observation:27.4 displayed fps,29.8 vision updates/sec,106ms estimated p95 upper-bound delay, no throttle flags. The accepted thresholds remain unchanged; full physical acceptance is pending.

### Experimental short-occlusion appearance descriptor

`appearance.py` adds ephemeral 256-value normalized appearance descriptors to person boxes. This is an ImageNet classification backbone, **not a person-ReID-trained model**: clothing/background similarity is an experimental continuity cue, not identity evidence. Similar clothing, partial views, merged boxes and changed lighting can defeat it. Never update a trusted appearance template from an overlapping/ambiguous crop. Matching thresholds need actual crossing observations; synthetic timings establish no accuracy. Descriptors stay in memory and must be excluded from browser JSON and logs.

The separate `/home/bgd-pi/bgd-vision/models/yolo26n-appearance_ncnn_model` was exported September 17 using Ultralytics 8.4.154 from its official `yolo26n-cls.pt` download (AGPL-3.0, SHA256 `0dd6f8dbc448870ac98a3cbb7156f923f7ce21fed3755d4019169ffffd279e81`). Following the [official embedding-head recipe](https://docs.ultralytics.com/modes/track), replace the last classification head with `nn.Sequential(nn.AdaptiveAvgPool2d((1,1)), nn.Flatten(start_dim=1))`, copy the old head's `.f` and `.i`, set `model.model.pt_path` to the distinct `yolo26n-appearance.pt` basename, then `model.export(format='ncnn', imgsz=224, device='cpu')`. Exported weights SHA256: `5a53bb941d0ae5616d6abf2056a26ab90e11971d88600c30f2e7b92237516439`; size about 4.6 MB. The active detector remains unchanged.

Runtime uses native NCNN with one CPU thread and OpenCV resize/BGR-to-RGB normalization to [0,1]. Installed stock ReID preprocessing reverses crop channels twice; its default NCNN threading also competed heavily with the active detector. The explicit path avoids both. Boxes are clipped to the image, tiny/invalid crops produce no descriptor, and only finite nonzero outputs are normalized.

On the Pi with the live detector active, 20 timed synthetic random-image runs after five warmups measured median/p95 **8.3/9.0 ms for one crop, 16.7/18.4 ms for two, 33.3/36.9 ms for four**. These are descriptor costs, not total pipeline speed or real-person accuracy. Reproduce crop/normalization checks on the provisioned Pi:

```sh
~/bgd-vision/.venv/bin/python -m bgd_vision.appearance ~/bgd-vision/models/yolo26n-appearance_ncnn_model
```

Installed BoT-SORT takes the minimum of appearance and spatial costs; a bad appearance match is not a hard rejection of a spatial match. Any selected-target recovery therefore needs its own joint appearance-and-position gate, an ambiguity margin, short timeout and a latched Lost state after exit/stale input. This addition does not establish biometric identity or long-term reacquisition.

### Crossing revision test card - September 17

Keep the accepted performance and no-silent-switch criteria above. First perform one brief crossing after selecting the intended person with both people separately visible. Success for the new behavior: Checking target removes the green box, then Tracking returns to the originally selected person after separation without a click. Lost is a safe rejection but does not demonstrate recovery. A green box on the other person is a failure. If the first crossing succeeds, complete the existing five-crossing check; include similar clothing and an exit/return to verify uncertainty stays Lost. Record outcomes, not just visible detection boxes. The 900 ms limit deliberately excludes long obstruction recovery. Ordinary movement and sustained new-workload acceptance remain to be measured; prior workload observations do not qualify this revised configuration.

### Missing-ID crossing correction

A selected ID may disappear before simultaneous overlapping boxes are reported. With a valid appearance reference, a nearby person overlapping the last selected box (IoU>=0.1 plus existing geometry limits) now starts the same900ms checking interval. This only permits an attempt; unchanged appearance/margin/stability gates decide recovery. Without nearby overlap, disappearance still immediately latches Lost. Recovery diagnostics in status/metric logs retain trigger, rejection gate, scalar similarity/margin, elapsed time, visible-person count and outcome; no descriptors, boxes or IDs are added to logs. Timeout displays its last rejection reason.26 vision tests cover the new path and existing behavior; physical recovery is pending.

### Person-trained replacement after the observed identity swap

The preceding ImageNet descriptor experiment is superseded: the owner observed a wrong-person switch. `appearance.py` now requires the **OSNet x0.25 MSMT17 combineall** person-ReID model, not the pooled YOLO classifier. This established [Torchreid architecture](https://github.com/KaiyangZhou/deep-person-reid) is trained for person matching; it still does not guarantee identity, replace face verification or make threshold tuning unnecessary. Clothing changes, lookalikes, occlusion and domain differences remain failure cases.

Provisioned separately at `/home/bgd-pi/bgd-vision/models/osnet_x0_25_msmt17`. The [author's model repository](https://huggingface.co/kaiyangzhou/osnet) explicitly identifies the person-ReID weights and labels them MIT; upstream source is MIT, with its LICENSE retained beside the model. Exact source file is `torchreid/models/osnet.py` from the author repository. Exact weight filename is `osnet_x0_25_msmt17_combineall_256x128_amsgrad_ep150_stp60_lr0.0015_b64_fb10_softmax_labelsmooth_flip_jitter.pth`. Downloaded through the author's Hugging Face `resolve/main` URL, then loaded with `torch.load(..., weights_only=True)` and `load_state_dict(..., strict=True)`—all trained parameters matched.

Export reproduction: instantiate upstream `osnet_x0_25(num_classes=state['classifier.weight'].shape[0], pretrained=False)`, strictly load the checkpoint, call `.eval()`, trace using `torch.jit.trace(model, torch.randn(1,3,256,128))`, save `model.pt`, and call `pnnx.convert('model.pt', inputs=example_tensor, fp16=False)`. In evaluation mode the original architecture directly returns its trained 512-value feature vector. No new head or network changes are made.

Runtime matches [upstream FeatureExtractor](https://github.com/KaiyangZhou/deep-person-reid/blob/master/torchreid/utils/feature_extractor.py): convert BGR crop to RGB, PIL bilinear resize to width128/height256, divide by255, then channel means `[0.485,0.456,0.406]` and standard deviations `[0.229,0.224,0.225]`. NCNN runs on one CPU thread with half storage/packing/arithmetic disabled. The earlier Ultralytics generic ReID wrapper square-resizes without this normalization and must not be used unchanged for OSNet.

Parity checked on three seeded synthetic tensors against the original PyTorch network: cosine similarity >0.9999998, maximum absolute feature error <0.00009. Synthetic crop timing (20 calls after five warmups, current Pi): median/p95 **11.1/11.7ms for one, 22.4/26.7ms for two, 44.6/48.6ms for four**. Crop bounds, invalid input, feature normalization and deterministic repetition checks pass. These establish conversion and runtime correctness, not real crossing accuracy. Existing live tracker was not changed during provisioning. The physical crossing test remains required.

SHA256 inventory:

- Original weights: `cf55163d78fc44c62c82f85ab62d39f10438679b5abe8c698ae08cfa84aa6e18`
- Upstream architecture file: `c7c1c29187d6330f859c91da229271531920464c7011aec13842a086b2263cae`
- Exported NCNN weights: `4cda2fac43a58e0ddbd7a51de258ab10b624658d59832f5146ed78d457020a84`

Run the retained encoder selfcheck using the new model directory:

```sh
~/bgd-vision/.venv/bin/python -m bgd_vision.appearance ~/bgd-vision/models/osnet_x0_25_msmt17
```

### Historical first candidate — superseded by BoxMOT below

The candidate pipeline is YOLO26n detection -> OSNet x0.25 person embeddings -> installed Ultralytics8.4.154 Deep OC-SORT -> selected-target validation. `tracking.py` uses the direct class API with precomputed embeddings, advances on empty frames and aligns returned tracks to detection embeddings using the library's original detection index. `deepocsort.yaml` is for this direct adapter, not `YOLO.track()` (whose auto encoder would fall back to the old classifier).

The experimental selector no longer reassigns selection to a newly numbered track. Recovery requires the original tracker ID, both people separately visible, the retained positive reference and pre-crossing competitor references, spatial support and stable observations. Competitor references also veto a suspicious same-ID continuation. These are conservative engineering checks, not validated person identity. Automatic recovery remains disabled by default; no threshold from the old descriptor is claimed calibrated for OSNet. The accepted loss deadline and manual reset after terminal Lost are unchanged.

[Primary-source comparison and validation plan](tracking-research-2026-09-17.md) records alternatives, exact APIs, licensing and the small public CAVIAR crossing fixture. Dataset media stays outside this repository. Public replay, synthetic association, conversion parity and physical camera tests are distinct evidence.

### Approved three-second recovery policy

The owner explicitly approved up to3seconds of **Temporarily hidden**, with no green target, for brief blockage. This supersedes the original one-second terminal-loss rule for ambiguous blockage or hidden exit. Camera/inference freshness stays750ms; terminal Lost still requires manual reselection. A clear exit without another nearby person still loses immediately. No target is claimed visible while hidden.

The candidate now uses BoxMOT25.0.0 Deep OC-SORT with external OSNet embeddings. Packages are isolated under `/home/bgd-pi/bgd-vision/candidates/boxmot25` (BoxMOT25.0.0, SciPy1.18.1); `start.ps1` sets that directory on this service's PYTHONPATH. Base virtual environment packages were not upgraded. BoxMOT is AGPL-3.0, consistent with the already used Ultralytics license; OSNet source/model are MIT. This records licenses, not a distribution-compliance determination.

A reused or changed tracker number is never sufficient for selection. The candidate supports changed-ID recovery only when both people separate and the selected reference, remembered competitor references, current competing candidates, geometry and stability checks agree. The old one-visible-person shortcut stays rejected. These thresholds are still provisional pending replay and physical validation; no guarantee of identity is implied.


Live startup observation (seven samples over30seconds, not sustained acceptance):19.2–23.8visionupdates/sec,23.2–26.1displayedfps,114.8–121.8ms rolling estimated delayp95 upper bounds,62.0–62.6C,0x0 power/throttle flags, no application errors. See `evidence/live-osnet-boxmot-startup-2026-09-17.json`. No physical crossing was inferred from these metrics.


### Preview scheduling regression

Run `node tests/vision/test_preview_loop.cjs` from the repo root. It executes the actual app.js with deterministic30Hz presentation and20ms delivery: the previous two blocking presentation waits limited throughput to15.2fps; the revised asynchronous post-draw measurement permits30fps. It also checks stale boxes and a deferred callback after connection failure. No concurrent request queue is introduced. The post-draw measurement still contributes to estimated presentation delay, but no longer delays the next request. Hidden pages and connection interruptions invalidate pending measurements. Live A/B spot checks were already near30fps, so this is a reproduced scheduling fix, not evidence all historical low-fps causes are solved. See evidence/preview-scheduling-2026-09-17.json.

### Diagnostic command interpreter

`commands.py` is a standard-library, fail-closed first pass for typed desk commands. It recognizes bounded follow, explicitly typed person/object find, count, scout, status and standalone Stop clauses. It returns clarification for ambiguous find targets and rejection for unsupported input. Every result is `DIAGNOSTIC_ONLY` and `executable: false`; there is no command session, actuator, mission or flight-controller adapter. This tests interpretation and user feedback only, before selecting a phone speech-recognition path.

The deployed read-only command diagnostic attaches observations without executing a plan. A `count people` step reports only the number of fresh person tracks currently visible in the fixed camera. A `scout` step always reports unavailable because the desk camera cannot move or survey an area; when both appear, the displayed count is explicitly the current view rather than a scouted-area result. Stale vision, non-person count targets and actions requiring movement/search return unavailable or not evaluated. The response remains `executable:false` and `DIAGNOSTIC_ONLY`.

Initial live scenes: nobody detected reported0 currently visible people; the owner alone produced exact spoken transcript `count people` in1357ms and count1; the owner plus consenting helper, clearly separated, produced the same exact transcript in1153ms and count2. Two-person UI metrics were29.5displayedfps,30.0vision/sec,95ms delay p95,60.9°C, no power warning and about611.7MB process RSS. The first0/1/2 fixed-camera set passes once per scene. It is not measured count accuracy, crowd/occlusion performance or area-coverage evidence; do not repeat unchanged scenes.

### Bounded current-camera object check — September 18

The installed YOLO26n NCNN metadata lists the standard80 COCO categories. They are already part of one loaded model, not separate downloads or eighty resident models. The desk interface exposes the79 non-person categories on demand; person remains on the separate person-tracking path. `find object <category>` copies one fresh frame and runs a single class-filtered inference through the already-loaded detector. A lock prevents the on-demand inference and continuous person inference from using the NCNN model simultaneously. It reports only the current-view count; no image or object box is retained or returned. Phone/mobile-phone wording maps to cell phone. Unsupported targets point to the installed-category list, stale frames fail closed, and the result remains non-executable/`DIAGNOSTIC_ONLY`.

The first deployed empty-scene probe `find object bottle` returned `Currently visible:0bottles`. The owner then placed a bottle in view and reported the positive result, passing the first physical present-object scene. The endpoint now returns transient box coordinates and confidence from the same inference; it does not retain them. The browser draws a blue four-pixel box labeled with category, confidence and `snapshot`, clears it after3seconds, and clears immediately if the camera connection is interrupted. Live verification displayed `bottle45% · snapshot`, then removed it on schedule. A same-model, same-frame Pi benchmark measured31.61ms average for bottle-class-filtered prediction and31.96ms for all-category output (1.011x), so category breadth is not a meaningful compute or RAM multiplier here. The expanded live interface listed all79 non-person categories and `find object bicycle` returned a valid zero-result observation. This remains fixed-current-view category detection, not unrestricted described-object recognition, spatial search, navigation or measured accuracy.

### Generic selected-object tracking prototype — September 18

The Track panel can now enter a draw mode for mouse or touch. Drag a snug rectangle around any visually textured object; it does not need a model category or name. The protected selection endpoint validates a fresh frame and a region at least20pixels wide/high. The server tracks at a bounded5updates/sec for at most30seconds; the browser renders a purple `Selected object · prototype` box. Clear discards the tracker. Backend failure, insufficient match, leaving the usable view, timeout and connection interruption remove the box and expose an explicit state. This is a manually initialized visual-region tracker, not pointing-gesture recognition.

The Pi's available OpenCV MIL tracker averaged about72ms per synthetic update but performed much worse beside the real workload: person inference fell from about30/sec to14.3/sec and display to17.5fps. That backend is rejected. The first replacement used nearby half-resolution template matching. The owner found that slight forward/back movement lost the object; a deterministic15% enlargement regression reproduced that exact fixed-scale failure. A three-scale patch made the regression pass but remained a narrow custom tracker, so it is retained only as a fallback.

The deployed backend is OpenCV5 `TrackerVit` with the official OpenCV Zoo ViTTrack ONNX model (Apache-2.0), isolated at `/home/bgd-pi/bgd-vision/candidates/opencv-vittrack`. SHA256 is `2990f0b7cd44d92afa48cd97db6de7be113fc1d9594fddb74e2725c10478e91d`. It averages about13ms per direct Pi update and passed scale-change probes. The owner passed slow up/down/left/right bottle motion held by another person, but faster motion immediately lost. A deterministic150-pixel comparison reproduced the mechanism: one jump at the former5Hz schedule lost at0.079 confidence, while two/three/six intermediate updates retained at0.516/0.671/0.817. The server now feeds every fresh camera frame to an active tracker instead of discarding five of six frames. Full-rate active tracking held29.6–30.1 displayed/vision fps,105ms estimated delay,62C,476–477MB RSS,0x0 throttle state and about169% CPU across the Pi's four cores.69 local vision tests pass with4 Pi-only skips; all7 generic-object tests pass on the Pi;35 simulator tests, JavaScript syntax and preview-loop regression pass. Next physical acceptance: repeat the same motion while gradually increasing speed, then remove the bottle fully. Record the new loss boundary rather than claiming unlimited speed.

The full-rate physical repeat improved speed handling but remained imperfect. When the bottle was moved against the holder's chest, ViTTrack expanded the box across almost the entire display; the supplied screenshot showed70% tracker confidence, so confidence alone cannot validate geometry. The first single-frame2x growth guard did not help because the expansion accumulated gradually. A deterministic regression reproduced a40x30 selection growing through60x45,90x67 and135x90 while every individual jump remained under2x. The deployed guard now rejects any single-frame2x width/height growth, cumulative4x growth from the original selection, or box area above60% of the camera frame, then latches Lost. It does not claim to recognize the bottle through visual merging; it prevents false position data from reaching later layers. Gradual15% scale and fast intermediate-frame tests remain green.70 local vision tests pass with4 Pi-only skips and all8 generic-object tests pass on the Pi. Next physical check is the bottle-to-chest case once: continued bottle tracking or Lost passes; a whole-frame box fails.

The owner repeated the bottle-to-chest case with the cumulative guard and reported it passed: the whole-frame purple box did not recur. This physically confirms the fail-closed geometry invariant once. It does not establish continued bottle identity through occlusion or automatic recovery. The next software layer is bounded detector-assisted reacquisition for a selected known category, beginning with bottle; prediction and aircraft guidance remain later.

Bottle-assisted reacquisition is now deployed as a bounded first category. Selection is associated with `bottle` only when exactly one current detector box overlaps at least50% of the smaller selected/detected region. The live bottle scored32.3–41.8% over repeated frames, so association and recovery use a30% floor, above the ordinary25% diagnostic floor. If ViTTrack loses or rejects the known bottle, the trusted purple box disappears for at most2seconds. Recovery requires exactly one nearby detection between half and twice the previous size and two spatially consistent confirmations; ambiguity, weak/far detections and timeout remain Lost. Unknown selections still do not auto-recover. Live verification visibly showed `Selected bottle` at29.5displayedfps,29.7vision/sec,108ms delay,59.3C and no power warning.73 local vision tests pass with4 Pi-only skips and14 subtests; all10 generic-object tests pass on the Pi;35 simulator tests, JavaScript syntax, preview-loop regression and deployed hashes pass. Physical cover/reveal recovery is still pending and is not a prediction, guidance or flight claim.

The first physical recovery run found and repaired a decimal-box integration failure: YOLO detector coordinates are floats, while OpenCV `TrackerVit.init` requires an integer restart rectangle. The exception had killed the generic-object worker and made later boxes appear frozen. Reacquisition now derives all four restart values from the rounded detection box and fails safely if initialization still raises. A decimal-coordinate regression fails on the previous code and passes now; the deployed source hash is `c176711230b00e47e06a13484ff74f44732901e7d9c87009e1dd19bcb75d39a5`. The owner then moved the selected bottle out of frame and back and reported one automatic reselection, passing the first bounded known-bottle recovery. Fast hand motion and body overlap remained flaky and later ended Lost. The live worker stayed active with no traceback at30vision/sec and no power warning. Next work is detector/tracker fusion plus short bounded motion prediction, not aircraft guidance.

Detector/tracker fusion and short bounded motion prediction are now deployed for known bottles. Every0.2seconds, one class-filtered detection may correct meaningful tracker drift only if confidence, uniqueness, distance, size, original-growth and60%-frame-area gates all pass. At least60% smaller-box overlap is treated as harmless jitter and does not restart ViTTrack. Recent visual-tracker center velocity predicts the expected recovery position for at most0.5seconds and at most three target widths/heights; recovery still requires two consistent detections. Weak, multiple, far, oversized and whole-frame candidates remain rejected.75 local vision tests pass with4 Pi-only skips and14 subtests; all12 generic-object tests pass on the Pi. Live fused tracking across eight samples held29.8–30.5vision/sec,28.3–29.2displayedfps,120.1–125.4ms delay,62.0C,492.0–492.5MB,0x0 throttle flags and no traceback. Deployed hashes: server `28044b58832dbb906dc8e853ea6561597a6f487dcc2d67d7725810ba7184ee19`; generic tracker `11e572058a4c7e0c80e840bfe5059839d565512393a0e337840c097cebad43a7`. Physical fast-motion/body-overlap validation remains pending.

Physical fusion result: slow and somewhat quick movement passed, improving the earlier speed boundary. A clear disposable bottle disappeared against the holder's torso and did not recover after separation; the service ended safe Lost while remaining healthy at30vision/sec with no traceback. ViTTrack is category-agnostic, so this does not mean it labeled the bottle as a person. The transparent/low-contrast target can merge visually with the hand/shirt, and YOLO may stop returning one distinct bottle for the guarded recovery. The next comparison is one opaque or strongly labeled bottle confirmed as `Selected bottle`; an arbitrary non-bottle would not exercise this bottle-only fusion path.

The opaque fish-oil bottle was correctly tagged `Selected bottle` and later detected at80.9%, but out-and-return initially stayed Lost. Diagnosis found that motion prediction had replaced the original last-safe-position reference. A fast diagonal exit can predict farther out of frame and reject a valid return near the last visible box. Recovery now uses the nearer of the last safe box and bounded0.5-second prediction; the continuing-fast-path and returning-edge regressions both pass. The no-trusted-box recovery window is3seconds, while one-bottle, confidence, size/distance, two-confirmation and whole-frame gates remain.77 local vision tests pass with4 Pi-only skips and14 subtests; all14 generic-object tests pass on the Pi. Deployed generic tracker SHA256 is `a3e3b91920ee7e2633084d7d955ab3912aca6cefe85e478adae7803e153ac3cb`.

The owner passed the follow-up fish-oil-bottle out-and-return. Live status independently recorded `Reacquired the selected bottle after two detector confirmations.` with category `bottle` and83.5% score. Five post-test samples returned29.9–30.0vision updates/sec,30.0capture fps,59.8–60.9C,0x0 throttle flags and no error or traceback. This accepts the fixed-camera known-bottle recovery slice once, not repeated reliability, arbitrary-category recovery, severe occlusion, fast-ball motion, moving/vibrating cameras, guidance, following or flight. Do not repeat the unchanged bottle test; the next engineering slice is guarded category generalization.

Guarded category generalization is deployed using the same loaded detector. Manual selection runs one all-category inference, excludes person, and associates a category only when exactly one detection at or above30% overlaps at least half of the smaller selected/detected box. Ambiguous or unrecognized selections keep the `Selected object` manual-tracking behavior. Associated selections use the unchanged class-filtered correction/recovery loop; no continuous all-category detector pass was added.82 local vision tests pass with4 skips;17 server and14 generic-object tests pass on Pi. Deployed server SHA256 is `50046a88919b5b6b99201239a2808ebef6e4c48a15bf11922ac5d200bd7d108e`. Live operation returned30.0capture/vision fps,56.5C,0x0 throttle flags and no error. Physical non-bottle recovery is pending.

The first non-bottle scene mixed a black cell phone and then a black glasses case near a black shirt and performed poorly. The final live state was `Selected object` followed by safe Lost for implausible box expansion at39.1% ViTTrack score. Glasses case is not an installed category, so it cannot use detector-assisted recovery; black-on-black presentation also gives the visual tracker weak object/background separation. The phone's earlier label was overwritten and is not recoverable from status. The next test isolates initial phone association against a light contrasting background before any movement or recovery claim.

Contrasting white square-box and white-book tests then tracked better while visible, but the final selection remained `Selected object` and ended Lost at17% score. Thus the category-recovery path did not run. Square box is unsupported; book is supported but did not establish association in this scene. Possible gates are detector confidence, selection/detection overlap and ambiguity. A later zero-book diagnostic cannot distinguish them because continued book visibility was not confirmed. The next test is a stationary `find object book` snapshot before selection.

Voice-command detection subsequently found a lotion bottle but completely missed a phone and book in their presented scenes. The80-class metadata is a vocabulary, not a reliability guarantee. Current-frame fixed-category detection cannot ground an absent `book` box, understand arbitrary descriptions, count unsupported coins, or deduplicate objects across a surveyed area. Open-vocabulary, visual-prompt and small-object alternatives remain unmeasured on this Pi. Benchmark continuous and event-driven configurations under the complete concurrent workload before selecting a hybrid, continuous or task-specific architecture; do not infer a compute limit from model size, desktop results or missing Pi documentation alone.

YOLOE-26n now has direct Pi compatibility/coexistence measurements. Prompt-free sustained2.45fps at320 and0.94fps at640; an eight-class targeted text profile sustained2.83fps at320 and1.32fps at640 with about442MB peak benchmark RSS. Observed camera display remained at least26.29fps/22.3fps for targeted320/640 samples, with no throttle/error and return to30capture/vision fps. A saved prompt profile reduces later setup to about2ms. Prompt-free emitted implausible labels in an unannotated room and is not accepted on quality; targeted object and visual-prompt quality remain pending. See `evidence/yoloe26-pi-benchmark-2026-09-19.json` for exact hashes/configuration/results.

In the first physical white-book scene, an eight-class profile emitted book intermittently at320/640. A book-only profile emitted book in10/10frames at640 around11.1% best confidence but0/10 at320. This proves a continuous640 candidate exists for that scene, not that its box is correctly localized or safe to use. Visual-prompt box verification is next; thresholds remain unchanged.

The stationary visual-prompt check then passed once: a snug owner-drawn book box produced YOLOE detections in10/10fresh640-pixel frames,96.9% best confidence and0.828 median box overlap. Sustained rate was1.23fps with480.1MB peak benchmark RSS; the camera service remained healthy. No images were retained. This is selected-book grounding evidence for one stationary scene, not motion/reacquisition/distractor/camera-motion qualification.

### Offline speech prototype — September 18

The first Pi speech candidate is Vosk0.3.45 with `vosk-model-small-en-us-0.15`, both Apache-2.0. It is installed only under the Pi candidate directory, not in the camera application's base environment. The official model zip SHA256 is `30f26242c4eb449f948e42cb302dd7a686cb29a3423a8367f99ff41780942498`. Primary-source comparison and the later native-iPhone recommendation are in `docs/research/offline-speech-path-2026-09-18.md`.

The Python3.13/ARM64 import and official8.308-second WAV passed. Isolated inference took1.731seconds after0.546seconds model load (0.208 realtime factor) while the camera service's vision rate remained about30/sec. The deployed authenticated endpoint accepts at most2MB and10seconds of WAV, WebM, Ogg or MP4 audio, converts it to16kHz mono PCM using the already-installed `ffmpeg`, transcribes locally, and sends the transcript through the unchanged command interpreter. Temporary audio is deleted at request completion. Browser push-to-talk stops after8seconds; hiding the page discards an active recording. It is not continuous listening.

The first live endpoint request, including conversion and lazy model load, took3063.9ms for the official fixture; vision changed30.0→29.9/sec, process RSS455.3→549.2MB, temperature was61.5°C, throttle flags stayed0x0 and no application error appeared. The fixture's numeric transcript was correctly rejected as unsupported and remained `DIAGNOSTIC_ONLY`/non-executable. The first real browser-microphone utterance, “scout the area and count the amount of people,” was transcribed exactly in1737ms after recording stopped and produced the correct `scout` then `count people` diagnostic plan. Live silence and deterministic low noise returned No speech recognized; an over-ten-second WAV was rejected; a missing model fails startup validation. A separate recognizer run inside a Linux network namespace with no network interface produced the expected official-fixture transcript using only local files. Vision remained29.9–30.0/sec with no error or power flag through these probes.62 vision tests,35 simulator tests and preview-loop regression pass. This is limited compatibility/integration evidence, not broad real-room accuracy, iPhone behavior, offline-flight qualification, speaker identity or authorization.
## Read-only MAVLink monitor

`mavlink_monitor.py` is an isolated pre-hardware interface check. It receives ArduPilot telemetry, emits one fixed ground-station heartbeat per second after discovering a system, and makes fixed message-interval requests for `SYS_STATUS`, `ATTITUDE` and `GLOBAL_POSITION_INT`. It exposes no generic command, arming, mode, parameter-write, motion-target or actuator API.

Install its pinned dependency separately from the camera environment:

```bash
python3 -m venv .venv-mavlink
.venv-mavlink/bin/python -m pip install -r bgd_vision/requirements-mavlink.txt
```

Listen for a simulator or later flight controller:

```bash
.venv-mavlink/bin/python -m bgd_vision.mavlink_monitor \
  --endpoint udpin:0.0.0.0:14551 --duration 30 --stale-after 5
```

Every JSON state includes `authority: READ_ONLY` and `actuator_output: false`. Loss of the expected flight-controller heartbeat becomes `link_lost` after the configured threshold. The 20 September Pi/SITL result is retained in `evidence/mavlink-read-only-sitl-2026-09-20.json`; it does not replace the later props-off physical serial/USB gate.
