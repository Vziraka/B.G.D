# Object detection and tracking options for the Pi 5 camera workload

**Research date:** 2026-09-18  
**Project state reviewed:** `main` at `e760b7bdc83cf45f6089ea291b026856ad717557`; the working tree already contained extensive owner/agent changes. This report is a new uncommitted file and does not modify application code, install a package, download a model, or change the Pi service.

## Decision in one paragraph

Yes, established open-source components can replace the weak template-matching prototype. **OpenCV `TrackerVit` with the official OpenCV Zoo ViTTrack model is now the best immediate candidate:** the Pi's installed OpenCV 5 binding contains it, and a bounded probe performed during this research ran official Apache-2.0 weights at about **13 ms/update** with an approximately **0.83 score** on live bottle frames. That is compatibility evidence, not a motion/scale/occlusion pass. **OpenCV `TrackerNano` with NanoTrack ONNX is the comparison candidate.** Both track a user-selected, unnamed object and predict a changing box, so they address the reported near/far scale failure without requiring an object class. They are still *short-term single-object trackers*: a low score can tell B.G.D to stop drawing a trusted box, but neither is evidence of reliable re-identification after full occlusion or exit. Keep the existing YOLO26n NCNN detector for people and the 80 fixed COCO categories while directly benchmarking **YOLOE-26n**, YOLO-World-S/V2 and other viable open-vocabulary/visual-prompt candidates on the Pi. Measure continuous and event-driven configurations rather than assuming either operating mode. Do not replace the tracker with Ultralytics/BoxMOT association: those systems associate detector boxes and cannot follow an unknown target that the detector never outputs.

## Four different problems that should not be conflated

| Capability | Input | What it returns | Relevant B.G.D example |
|---|---|---|---|
| Fixed-category detection | A frame; a trained label set | New boxes and class scores in that frame | Existing YOLO26n finds a COCO `bottle` or `person` |
| Open-vocabulary detection | A frame plus text or a visual example | Boxes matching a requested concept/example | “Find a black toolbox,” if the model generalizes to it |
| Multi-object tracking-by-detection | A stream of detector boxes | IDs associated across frames | ByteTrack, BoT-SORT, Deep OC-SORT, TrackTrack |
| Single-object visual tracking (SOT) | First frame plus the selected box | That same target's estimated box in later frames | “Track this,” even when the object has no name/class |

The owner's failed bottle test is the fourth problem. The deployed half-resolution matcher searches only nearby, tests three scales around its *original* template, and lightly overwrites that template. That makes drift, accumulated scale error, rotation failure and occlusion failure expected. A category detector may help reacquire a bottle, but it cannot make arbitrary-object tracking general.

## Candidate comparison

### A. User-selected, unnamed-object tracking

| Candidate | Scale/motion behavior | Occlusion/loss behavior | Pi/offline deployment and coexistence | License and maintenance | Verdict |
|---|---|---|---|---|---|
| **OpenCV TrackerNano + NanoTrack V2 ONNX** | A lightweight Siamese tracker: it compares a fixed target template with a larger search crop and regresses a new bounding box, so translation and moderate scale/aspect change are part of the model rather than three hard-coded resize guesses. OpenCV calls it a “super lightweight dnn-based general object tracker.” | Exposes `getTrackingScore()`, which permits a fail-closed Lost/hidden threshold. It searches locally and does not, by itself, prove recovery after the target is fully occluded or leaves the search region. | Already implemented in current OpenCV's `video` module and uses two ONNX files through OpenCV DNN. The upstream NanoTrack project also supplies NCNN ARM-oriented C++ demos and a 2.2 MB model, but direct NCNN integration would add C++/binding work. Must be benchmarked concurrently with the loaded YOLO26n NCNN detector because both consume CPU. | OpenCV 5 and NanoTrack are Apache-2.0. OpenCV was actively pushed on 2026-09-18; the tiny NanoTrack author's repository last pushed 2023-06-08, but the maintained OpenCV API remains current. [OpenCV API](https://docs.opencv.org/4.12.0/d8/d69/classcv_1_1TrackerNano.html), [NanoTrack source, weights, NCNN demos and results](https://github.com/HonglinChu/NanoTrack), [OpenCV repository metadata](https://api.github.com/repos/opencv/opencv) | **Rank 2: measured comparison.** Strong architecture/size fit, but ViTTrack already cleared the first Pi compatibility probe. |
| **OpenCV TrackerVit / OpenCV Zoo ViTTrack ONNX** | OpenCV describes a general DNN tracker with a roughly 767 KB model. It jointly evaluates template and search features and regresses the box. The official demo accepts any initial ROI. | Exposes a score and official demo treats score `<0.3` as Lost. This is still local SOT, not a global detector. An open OpenCV issue reports sensitivity to visually similar targets. A prior lost-target growth/OOM bug was fixed for OpenCV 4.11.0, so the installed 5.0.0 should contain that fix, but B.G.D must still reject invalid/low-score boxes. | One ONNX model through the existing OpenCV DNN engine; the model file is only 698 KB in Git LFS. The actual Pi probe found the installed binding and observed about 13 ms/update and score about 0.83 on live bottle frames. It did not yet run fast motion, scale, occlusion or the full sustained concurrent gate. | OpenCV/OpenCV Zoo are Apache-2.0 and active; Zoo moved model hosting toward Hugging Face but retains the model/demo. [TrackerVit API](https://docs.opencv.org/4.12.0/javadoc/org/opencv/video/TrackerVit.html), [official demo/model directory](https://github.com/opencv/opencv_zoo/tree/main/models/object_tracking_vittrack), [similar-target limitation](https://github.com/opencv/opencv/issues/24650), [lost-target fix](https://github.com/opencv/opencv/issues/25760) | **Rank 1: integrate behind the existing bounded interface and test.** It is the only candidate with direct Pi timing in this review. |
| **Direct NanoTrack NCNN** | Same model family as above, run in NCNN rather than OpenCV DNN. Upstream reports a 2.2 MB MobileNetV3 model and provides macOS ARM64 and Android NCNN demos. | Same local-search and confidence limitations as TrackerNano. The application must implement loss policy and any reacquisition. | Architecturally compatible with ARM64 and with the already installed NCNN runtime. It might minimize runtime overhead, but the supplied demos are C++ for macOS/Android, not a supported Python Pi package; measure OpenCV first before writing/maintaining a native extension. | Apache-2.0; upstream last code push in 2023. [Upstream repository](https://github.com/HonglinChu/NanoTrack), [ncnn](https://github.com/Tencent/ncnn) | **Rank 3 implementation path, not a third algorithm.** Use only if TrackerNano quality passes but OpenCV-DNN performance does not. |
| **OpenCV TrackerDaSiamRPN** | Siamese RPN predicts location and box shape and was designed to resist semantic distractors. The research includes a local-to-global long-term extension. | OpenCV exposes a tracking score, but its API/sample does not establish that the paper's full long-term reacquisition policy is present. Treat the shipped tracker as confidence-gated SOT until tested. | Official OpenCV API accepts three ONNX networks, so it can run offline on ARM64 through OpenCV DNN. Its AlexNet-era model is materially older/larger than NanoTrack/ViTTrack and is a poor first choice beside continuous YOLO inference. | OpenCV implementation is current Apache-2.0; original code/model project is MIT but last pushed in 2020. [OpenCV API](https://docs.opencv.org/4.12.0/de/d93/classcv_1_1TrackerDaSiamRPN.html), [OpenCV sample](https://github.com/opencv/opencv/blob/4.x/samples/dnn/dasiamrpn_tracker.cpp), [authors' code and license](https://github.com/foolwood/DaSiamRPN), [paper](https://arxiv.org/abs/1808.06048) | **Fallback only.** Useful benchmark if both tiny trackers fail distractor/occlusion cases and CPU headroom remains. |
| **OpenCV CSRT / KCF / MIL** | CSRT includes a dedicated scale-estimation implementation and spatial/channel reliability; KCF is a fast correlation-filter tracker; MIL learns a foreground/background classifier online. | These classical trackers can drift under occlusion and do not provide semantic/global re-identification. A boolean failure is not proof that a returned box is the right object. | No model files and offline CPU operation. Availability depends on how OpenCV was built. In B.G.D's real workload MIL already cut person inference from about 30/s to 14.3/s, so it is rejected. CSRT and KCF remain inexpensive controls, not assumed improvements. | Current OpenCV 4.12/5 APIs; Apache-2.0. [CSRT](https://docs.opencv.org/4.12.0/d2/da2/classcv_1_1TrackerCSRT.html), [KCF](https://docs.opencv.org/4.12.0/d2/dff/classcv_1_1TrackerKCF.html), [MIL](https://docs.opencv.org/4.12.0/d0/d26/classcv_1_1TrackerMIL.html) | **Controls only.** Do not spend another owner test on MIL. |

None of these lightweight SOT choices should silently claim robust full-occlusion recovery. The safe state machine is: high score → Tracking; short low-score interval with no box authority → Temporarily hidden; timeout/exit/ambiguity → latched Lost. Reacquisition is a separate detector/matcher decision with a competitor margin, not “keep updating until a box appears.”

### B. Detection and detector-associated tracking

| Tool | What it actually solves | Deployment/licensing consequence | B.G.D decision |
|---|---|---|---|
| **Existing YOLO26n NCNN** | Fixed-category detection. The installed model contains 80 COCO categories; it does not recognize every object or distinguish a specific instance merely because the user selected it. | Ultralytics measured 67.03 ms/model inference on a Pi 5 at 640 FP32 NCNN, excluding pre/post-processing. B.G.D already exports/runs at 320 and has measured its complete concurrent workload. Ultralytics code and official weights are AGPL-3.0 or require a separate enterprise license. [Pi guide and benchmark](https://docs.ultralytics.com/guides/raspberry-pi), [Ultralytics licensing](https://github.com/ultralytics/ultralytics/blob/main/docs/en/index.md) | **Keep it.** It is already integrated and measured; replacing it does not fix arbitrary-object tracking. Run known-category detection only at acquisition/reacquisition intervals when useful. |
| **Ultralytics track mode / BoxMOT algorithms** | Associates *detections* across frames. Current Ultralytics includes ByteTrack, BoT-SORT, OC-SORT, Deep OC-SORT, FastTracker and TrackTrack; ReID and lost-track buffers can improve same-category ID continuity. No detection means no unknown target to associate. | The current package is active (official source reported 8.4.155 during this review) and AGPL-3.0. More trackers or ReID also cost CPU. The present B.G.D person path already uses Deep OC-SORT plus an independent selected-person guard. [current tracker registry/default](https://github.com/ultralytics/ultralytics/blob/main/ultralytics/cfg/default.yaml), [tracking implementation](https://github.com/ultralytics/ultralytics/tree/main/ultralytics/trackers), [repository metadata](https://api.github.com/repos/ultralytics/ultralytics) | **Do not substitute this for SOT.** Retain it for people/multiple detector-supported objects. |
| **NanoDet-Plus / OpenCV Zoo NanoDet** | A very small fixed-category detector. Upstream supplies ONNX→NCNN and NCNN/MNN/OpenVINO demos and reports 980 KB INT8 / 1.8 MB FP16. | Apache-2.0, but upstream last pushed in 2024. It would introduce a second detector and duplicate capability already working in YOLO26n. Reported mobile results are not Pi/application results. [NanoDet source and deployment](https://github.com/RangiLyu/nanodet), [OpenCV Zoo](https://github.com/opencv/opencv_zoo) | **No current reason to adopt.** Keep as a permissively licensed fixed-detector fallback if Ultralytics licensing or load becomes unacceptable. |

### C. Open-vocabulary or visual-prompt acquisition

| Candidate | Capability | Pi/offline reality | License/maintenance | Verdict |
|---|---|---|---|---|
| **YOLOE-26n** | Current Ultralytics model accepts text prompts, a selected example box (visual prompt), or a built-in 4,585-name prompt-free vocabulary. A visual prompt is especially relevant to “this unknown object.” Prompted classes can feed the same tracking-by-detection mode. | First text prompting downloads a roughly 254 MB MobileCLIP2 text encoder, but prompts can be baked into a static export so the encoder is not needed at inference. Official docs list static ONNX/OpenVINO/TensorRT/CoreML/LiteRT/RKNN routes and show detection-only prompt profiles; they do **not** publish a Pi 5 measurement or explicitly demonstrate NCNN for YOLOE. Continuous and event-driven Pi performance are unknown until directly measured. | Ultralytics integration and THU-MIG source are AGPL-3.0; Ultralytics is active in September 2026, while the original THU-MIG repository last pushed 2025-06-26. [Ultralytics YOLOE docs](https://docs.ultralytics.com/models/yoloe), [authors' repository](https://github.com/THU-MIG/yoloe), [paper](https://openaccess.thecvf.com/content/ICCV2025/papers/Wang_YOLOE_Real-Time_Seeing_Anything_ICCV_2025_paper.pdf) | **First open-vocabulary/visual-prompt probe.** Benchmark continuous and event-driven configurations on the Pi before choosing its role. |
| **YOLO-World-S/V2** | Text-prompt open-vocabulary detector with an offline prompt vocabulary. The V2 models support export; re-parameterized S is 13M parameters in the authors' paper. It detects concepts, not necessarily a particular physical instance. | Authors provide ONNX export with prompts baked in. Ultralytics explicitly disables YOLO-World NCNN benchmarking/export support, so ONNX/OpenCV DNN or another runtime would need a measured Pi probe. No primary-source Pi result was found. | Original source/weights are GPL-3.0; Ultralytics migration is AGPL-3.0/enterprise. Original repo last pushed 2025-02-26; Ultralytics wrapper is current. [official source/model card](https://github.com/AILab-CVC/YOLO-World), [official deployment](https://github.com/AILab-CVC/YOLO-World/blob/master/docs/deploy.md), [Ultralytics model/export matrix](https://docs.ultralytics.com/models/yolo-world), [NCNN exclusion in current source](https://github.com/ultralytics/ultralytics/blob/main/ultralytics/utils/benchmarks.py) | **Second open-vocabulary choice.** Credible and established, but less useful than YOLOE's visual prompt for a specific unnamed instance. |
| **Grounding DINO / OWLv2** | Strong text-conditioned open-vocabulary detectors. Grounding DINO is Apache-2.0; OWLv2 is a transformer text-conditioned detector. | OpenCV 5's desktop CPU table reports multi-second inference for both model classes on Apple systems, and Grounding DINO's official repository centers PyTorch/CUDA with fragile ONNX export history. These facts lower test priority but do not measure Pi performance or prove continuous operation impossible. [OpenCV 5 DNN benchmarks](https://github.com/opencv/opencv/wiki/OpenCV-5-DNN-Benchmarks), [Grounding DINO](https://github.com/IDEA-Research/GroundingDINO), [OWLv2 documentation](https://huggingface.co/docs/transformers/model_doc/owlv2) | **Measured comparison if deployable.** Benchmark a representative optimized configuration on the Pi before accepting or excluding continuous/event-driven use. |

Open vocabulary does not mean infallible vocabulary. Phrasing, viewpoint, tiny objects, blur, lighting, and domain shift can all cause misses. A text detector may find “bottle” while failing “my translucent scratched bottle,” and a visual-prompt model can still confuse similar objects. All acquisition must expose confidence and alternatives; it must not silently authorize motion.

## Recommended architecture

1. **Acquisition:** the owner draws/taps a box. For a supported known class, YOLO26n may also supply the initial box. Benchmark YOLOE visual/text prompting in continuous and event-driven configurations before selecting its role.
2. **Fast local tracking:** run NanoTrack or ViTTrack on selected frames, predicting translation and box size. Preserve an immutable initial template/reference plus only high-confidence recent references; do not learn from low-confidence/occluded frames.
3. **Loss gate:** use tracker score, box geometry, view boundaries and abrupt-motion checks. Remove the trusted overlay immediately on low confidence. Allow only a bounded Temporarily hidden state; otherwise latch Lost.
4. **Reacquisition:** when a detector-supported category exists, query the already-loaded YOLO26n at low duty cycle and require appearance/spatial/competitor checks. For a truly unknown instance, visual-prompt YOLOE is a future experiment, not an assumed capability. Never call the next closest similar object “recovered” without a strong margin.
5. **Flight authority remains separate:** a tracking box is an observation, not permission to move the aircraft. The current desk UI remains diagnostic-only.

This hybrid is why person tracking appears stronger: people have a trained detector on every inference, motion association, person-trained ReID, and an independent selected-person guard. The generic prototype has only a mutable grayscale patch and a nearby correlation maximum.

## Measured evaluation plan

Do not ask the owner to repeat the unchanged template-matcher test. First build an isolated adapter/probe for NanoTrack and ViTTrack, then run the same recorded/public sequence through all candidates before deploying one changed candidate.

### Stage 0 — compatibility and provenance

- The Pi probe already confirmed OpenCV 5 `TrackerVit`, the official ONNX load and a live update. Next enumerate/confirm `TrackerNano_create`; preserve OpenCV build information and do not install another OpenCV over the working 5.0.0 runtime.
- Download models only from the official linked projects, record URL, commit/tag, SHA-256, exact model license and size outside the source checkout.
- Execute one synthetic/non-recording initialization and update while the working camera service stays untouched. Fail the candidate if its binding/model cannot load cleanly.

### Stage 1 — offline tracking quality

Use the same annotated sequences for the current matcher, NanoTrack and ViTTrack. Include:

- horizontal/vertical translation at slow and brisk speeds;
- near/far scale changes covering approximately 0.5× to 2× selected-box size;
- ±45° and 90° rotation;
- illumination change and motion blur;
- partial occlusion for 0.25, 0.5 and 1 second;
- full occlusion/exit followed by return at the prior location and elsewhere;
- a similar-looking distractor crossing or replacing the target;
- camera pan/tilt simulation, because the eventual drone camera moves.

Score per sampled frame: intersection-over-union (IoU), center error normalized by target size, target present/absent truth, reported confidence, correct/lost/wrong-object state, loss latency and any recovery latency. A useful desk candidate should achieve **IoU ≥0.5 on at least 95% of clearly visible scripted frames**, never silently switch in the distractor trials, and report Lost rather than a confident background box after complete exit. Full-occlusion return is recorded separately; failing automatic reacquisition does not disqualify a safe short-term tracker, but a wrong-object recovery does.

### Stage 2 — actual simultaneous Pi workload

Run each surviving tracker at 5, 10 and 15 updates/s beside the unchanged 960×540 camera/browser and continuous YOLO26n NCNN person path. Record complete-application displayed FPS, fresh vision updates/s, frame-age/estimated-delay p50/p95, process RSS/private memory if available, CPU utilization, temperature, `vcgencmd get_throttled`, power flags, errors, tracker update latency and tracking quality. Preserve the current gates: at least 15 displayed FPS, at least 5 fresh vision updates/s, at least 95% observations below 500 ms, no restart/error/power warning, no growing delay, and no material regression of the already measured person path. Use one thread initially and serialize heavyweight inference if shared CPU contention appears.

### Stage 3 — changed physical candidate

Only after offline and concurrent gates pass, deploy the single winner behind the existing draw-box UI. Repeat the owner's bottle near/far and left/right scenario, then rotation, brief partial occlusion and full exit. Display Tracking only above the calibrated score; show Temporarily hidden without a trusted box during the bounded grace interval; show Lost on timeout/exit. The owner should not be asked to tune thresholds by eye. Store aggregate timings/outcomes, not camera imagery, unless separate recording consent and retention rules are established.

### Stage 4 — open-vocabulary acquisition/reacquisition benchmark

Benchmark YOLOE-26n and any viable comparison in continuous, periodic and one-shot configurations. Test text prompts and the initial selected box as a visual prompt against absent target, one target, two similar instances, background clutter and changed viewpoint. Measure prompt preparation, model memory, first/subsequent and sustained inference rate, end-to-end frame age, CPU, temperature/power flags, false reacquisition and impact on the live service. A prompt hit becomes only a candidate for guarded reseeding of the SOT tracker; the measured results, not an assumed compute ceiling, choose the operating mode.

## Ranked shortlist

1. **OpenCV TrackerVit with official OpenCV Zoo ONNX** — immediate implementation experiment; the Pi binding/model already produced the first ~13 ms live update result.
2. **OpenCV TrackerNano with official NanoTrack V2 ONNX** — measured comparison if available in the same OpenCV build.
3. **Direct NanoTrack NCNN** — optimization route only after the algorithm passes through OpenCV DNN.
4. **OpenCV DaSiamRPN** — heavier fallback benchmark if tiny trackers fail quality.
5. **YOLOE-26n** — open-vocabulary/visual-prompt candidate; continuous and event-driven roles remain unselected pending direct Pi measurement.

Keep YOLO26n NCNN and current person association unchanged during this comparison. Drop MIL from further testing; do not adopt NanoDet or another fixed detector merely to address a tracking failure; and do not claim arbitrary-object reacquisition until a visual-prompt/detector stage passes the similar-instance tests.

## Maintenance and license snapshot

Repository activity observed through first-party GitHub metadata on 2026-09-18: OpenCV and Ultralytics were actively pushed that day; OpenCV Zoo last pushed 2026-05-28; NanoTrack 2023-06-08; DaSiamRPN 2020-01-08; YOLO-World 2025-02-26; THU-MIG YOLOE 2025-06-26; NanoDet 2024-08-08; Grounding DINO 2024-08-12. “Not archived” or recent pushes do not prove long-term support, but they distinguish current host integrations from dormant author repositories. See first-party metadata for [OpenCV](https://api.github.com/repos/opencv/opencv), [OpenCV Zoo](https://api.github.com/repos/opencv/opencv_zoo), [NanoTrack](https://api.github.com/repos/HonglinChu/NanoTrack), [DaSiamRPN](https://api.github.com/repos/foolwood/DaSiamRPN), [Ultralytics](https://api.github.com/repos/ultralytics/ultralytics), [YOLO-World](https://api.github.com/repos/AILab-CVC/YOLO-World), [YOLOE](https://api.github.com/repos/THU-MIG/yoloe), [NanoDet](https://api.github.com/repos/RangiLyu/nanodet), and [Grounding DINO](https://api.github.com/repos/IDEA-Research/GroundingDINO).

License summary is engineering inventory, not legal advice: OpenCV/OpenCV Zoo/NanoTrack/NanoDet/Grounding DINO are Apache-2.0; DaSiamRPN is MIT; original YOLO-World is GPL-3.0; Ultralytics and THU-MIG YOLOE are AGPL-3.0 unless a separate commercial/enterprise license applies. Preserve model-specific notices and hashes; do not infer a weight's rights solely from the surrounding code license when a separate model card/license exists.

## 2026-09-19 addendum — direct Pi open-vocabulary benchmark preparation

This addendum prepares a direct Raspberry Pi 5 / ARM64 CPU comparison. It does **not** install packages, download weights, modify the camera service or predict which candidate will be fast enough. No official primary source located in this review reports an application-level Pi 5 measurement for YOLOE-26n, YOLO-World-S/V2, Grounding DINO-T or OWLv2. Desktop/GPU figures therefore do not decide the Pi architecture.

First-party repository heads observed on 2026-09-19 were Ultralytics `7e633f91ce2f1d0ab0d0076b93a48e9620e88747`, THU-MIG YOLOE `40cd606cabdbe2b566d6f14a6b162c89206e9a1b`, YOLO-World `4f70adbaacf5685bd9ec5bea85f1f91057f6fc0b`, Grounding DINO `856dde20aee659246248e20734ef9ba5214f5e44` and Transformers `c587bc884db2c2e31fc2b8102314656b17aa07b1`. A real trial must pin the chosen revision or released package version rather than silently following `main`.

### What can actually be deployed

| Candidate and exact starting artifact | Dynamic prompt path | Export/runtime path | Offline after preparation | License and Pi evidence |
|---|---|---|---|---|
| **YOLOE-26n** — `yoloe-26n-seg.pt`; optional prompt-free `yoloe-26n-seg-pf.pt` | Ultralytics `YOLOE` on PyTorch accepts text prompts and example-box visual prompts. Visual prompts need no text encoder. The first text prompt installs Ultralytics' CLIP component and obtains the roughly 254 MB YOLOE-26 text encoder unless prompt embeddings were prepared elsewhere. The official package declares Python `>=3.8`, PyTorch and torchvision among its dependencies. | Prompts can be saved as an NPZ profile and baked into ONNX, OpenVINO, TensorRT, CoreML, LiteRT or RKNN. For a detector-only comparison, construct `YOLOE("yoloe-26n.yaml").load("yoloe-26n-seg.pt")` before loading the prompt profile; this removes the mask branch. An exported graph cannot accept new text or visual prompts and must be re-exported to change classes. The official documentation does not list NCNN as a YOLOE export route. | **Yes**, after the `.pt` checkpoint, required Python wheels/source and any text encoder are cached; or after a static export and its runtime are staged. Prove this by running the warm benchmark with networking disabled. | Ultralytics and THU-MIG source are AGPL-3.0; a separate Ultralytics enterprise license is an alternative. No official Pi 5 result found. Sources: [YOLOE models, prompting, dependencies and exports](https://docs.ultralytics.com/models/yoloe), [THU-MIG install/prediction path](https://github.com/THU-MIG/yoloe), [THU-MIG license](https://github.com/THU-MIG/yoloe/blob/main/LICENSE). |
| **YOLO-World-S V2** — Ultralytics `yolov8s-worldv2.pt`; authors' model/config route from the YOLO-World model zoo | Ultralytics `YOLOWorld` on PyTorch accepts `set_classes([...])`. The official authors describe prompt-then-detect: the vocabulary embeddings are re-parameterized into model parameters for inference. Their reference repository was developed with PyTorch 1.11, MMYOLO 0.6 and MMDetection 3.0, whereas the Ultralytics route uses its current package dependencies; keep these environments separate. | Current Ultralytics exporter limits World V2 to TorchScript, ONNX, OpenVINO, TensorRT and CoreML; current source explicitly rejects NCNN. The authors' route exports ONNX with `deploy/export_onnx.py ... --custom-text ...`; use opset 12 if the graph retains `einsum`. `--without-nms` removes NMS, and `--without-bbox-decoder` is the authors' recommendation before ONNX quantization. ONNX Runtime is the authors' provided portable demo path. Export freezes the configured vocabulary. | **Yes**, once the `.pt` plus PyTorch/CLIP dependencies or the vocabulary-specific ONNX plus ONNX Runtime are staged. Re-run without networking to verify that no tokenizer/model fetch occurs. | Authors' repository is GPL-3.0 and says commercial use is supported subject to that license or a separate commercial license; Ultralytics packaging is AGPL-3.0/enterprise. No official Pi 5 result found. Sources: [authors' model zoo/install](https://github.com/AILab-CVC/YOLO-World), [authors' ONNX deployment](https://github.com/AILab-CVC/YOLO-World/blob/master/docs/deploy.md), [Ultralytics V2 model/export support](https://docs.ultralytics.com/models/yolo-world), [current exporter restrictions](https://docs.ultralytics.com/reference/engine/exporter). |
| **Grounding DINO-T** — `groundingdino_swint_ogc.pth` plus `groundingdino/config/GroundingDINO_SwinT_OGC.py` | Official PyTorch inference accepts arbitrary text each call. The repository states that installation compiles in CPU-only mode when CUDA is absent and the demo exposes `--cpu-only`. Its image transform resizes the short side to 800 with a 1333 maximum, which must remain recorded in comparisons. | The official repository's supported path is its PyTorch package; it does not document a supported production ONNX/NCNN export. Do not benchmark an unofficial conversion under the Grounding DINO label. | **Yes**, after cloning/pinning the repo and staging the checkpoint, Python dependencies and tokenizer/model files. Confirm under disabled networking. | Source is Apache-2.0; preserve the checkpoint release provenance and notices. No official Pi 5 result found. Sources: [official installation, CPU demo and checkpoint](https://github.com/IDEA-Research/GroundingDINO/blob/main/README.md), [official inference transform](https://github.com/IDEA-Research/GroundingDINO/blob/main/groundingdino/util/inference.py), [license](https://github.com/IDEA-Research/GroundingDINO/blob/main/LICENSE). |
| **OWLv2 base** — `google/owlv2-base-patch16-ensemble` (`model.safetensors`, about 620 MB, plus config/processor/tokenizer files) | Hugging Face Transformers provides `Owlv2Processor` and `Owlv2ForObjectDetection`/`AutoModelForZeroShotObjectDetection` on PyTorch for zero-shot text detection. OWLv2 also has image-guided one-shot detection in the official documentation. | The supported comparison path is the downloaded Transformers checkpoint on CPU. The official documentation does not establish an ONNX, OpenVINO or NCNN Pi deployment for this artifact, so any later conversion is a separate experiment rather than part of the first baseline. | **Yes**, use `from_pretrained(..., local_files_only=True)` after one complete `snapshot_download`; test with networking disabled. | Google model card and Scenic source are Apache-2.0. No official Pi 5 result found. Sources: [Transformers OWLv2 docs](https://huggingface.co/docs/transformers/model_doc/owlv2), [Google model card/files/license](https://huggingface.co/google/owlv2-base-patch16-ensemble), [Google Scenic source](https://github.com/google-research/scenic/tree/main/scenic/projects/owl_vit). |

### Fair, reproducible benchmark configuration

Use an isolated virtual environment and a new model-cache directory; do not install over `/home/bgd-pi/bgd-vision/.venv` or modify the systemd service. Record `uname -a`, `/etc/os-release`, `lscpu`, Python/package versions, repository commit, model URL, byte size and SHA-256 before inference. Keep one CPU thread setting fixed across candidates initially (`OMP_NUM_THREADS=4`, `OPENBLAS_NUM_THREADS=4`, `MKL_NUM_THREADS=4`, `torch.set_num_threads(4)`); a later thread sweep is valid, but mixing thread counts in the first comparison is not.

Use the same saved, consented test images for every model so camera timing does not contaminate detector timing. The minimum set is:

- lotion bottle, phone, book and glasses case individually;
- the same four against easy and similar-color backgrounds;
- target absent;
- target plus one similar distractor;
- a wide view with deliberately small examples, including a ball/bicycle analogue if available.

Use the same text concepts for all text-capable models: `bottle`, `cell phone`, `book`, `eyeglasses case`, `sports ball`, `bicycle`, `coin`. Also record two natural-language variants (`phone`, `glasses case`) rather than silently selecting the best wording. YOLOE visual prompting gets a separate trial using the owner's selected box; it must not be averaged into text-prompt results.

Run at **320, 480 and 640 pixels** where the official API permits `imgsz`; Grounding DINO's official 800/1333 transform and OWLv2's processor-native size remain separate rows because changing their preprocessing would no longer be the official baseline. Use `batch=1`, FP32 first, no frame skipping inside the detector, 10 warm-up inferences and 100 timed inferences per image size/prompt mode. Measure preprocessing, model inference, postprocessing and total wall time separately with `time.perf_counter_ns()`. Synchronization is not needed on CPU. Store every raw detection before applying the common evaluation threshold.

For quality, annotate the target boxes once and report per concept: present/absent accuracy, recall, false positives per image, best-box IoU, localization success at IoU 0.5 and the score of the best correct and best incorrect box. Do not compare raw confidence values as if calibrated across models. For operational load, capture process RSS, total CPU, per-core CPU, temperature, voltage/power flags and `vcgencmd get_throttled` before, during and after each run.

### Reproducible official-API smoke commands

These commands are benchmark preparation, not commands executed during this research. Install a recorded released version or commit in the isolated environment and stage all artifacts first. `test.jpg` must be the same local image in every smoke test.

YOLOE-26n dynamic text prompt:

```bash
python - <<'PY'
from ultralytics import YOLOE
m = YOLOE("yoloe-26n-seg.pt")
m.set_classes(["bottle", "cell phone", "book", "eyeglasses case", "sports ball", "bicycle", "coin"])
r = m.predict("test.jpg", imgsz=640, device="cpu", verbose=False)
print(r[0].boxes.xyxy, r[0].boxes.conf, r[0].boxes.cls)
PY
```

YOLOE-26n visual prompt and subsequent use of the learned visual prompt:

```bash
python - <<'PY'
import numpy as np
from ultralytics import YOLOE
from ultralytics.models.yolo.yoloe import YOLOEVPSegPredictor
m = YOLOE("yoloe-26n-seg.pt")
# Replace these four recorded pixels with the annotated target box in reference.jpg.
vp = {"bboxes": np.array([[100.0, 100.0, 300.0, 300.0]]), "cls": np.array([0])}
m.predict("test.jpg", refer_image="reference.jpg", visual_prompts=vp,
          predictor=YOLOEVPSegPredictor, imgsz=640, device="cpu")
r = m.predict("test.jpg", imgsz=640, device="cpu", verbose=False)
print(r[0].boxes.xyxy, r[0].boxes.conf)
PY
```

YOLOE static text-profile export (perform off-target if export dependencies are unavailable on ARM64, then copy the resulting artifact and verify its hash on the Pi):

```bash
python - <<'PY'
from ultralytics import YOLOE
names = ["bottle", "cell phone", "book", "eyeglasses case", "sports ball", "bicycle", "coin"]
m = YOLOE("yoloe-26n-seg.pt")
m.set_classes(names)
m.save_prompt_embeddings("bgd-prompts-yoloe26n.npz")
m = YOLOE("yoloe-26n.yaml").load("yoloe-26n-seg.pt")
m.load_prompt_embeddings("bgd-prompts-yoloe26n.npz")
m.export(format="onnx", imgsz=640, batch=1, device="cpu")
PY
```

YOLO-World-S V2 dynamic text prompt and static ONNX export:

```bash
python - <<'PY'
from ultralytics import YOLOWorld
m = YOLOWorld("yolov8s-worldv2.pt")
m.set_classes(["bottle", "cell phone", "book", "eyeglasses case", "sports ball", "bicycle", "coin"])
r = m.predict("test.jpg", imgsz=640, device="cpu", verbose=False)
print(r[0].boxes.xyxy, r[0].boxes.conf, r[0].boxes.cls)
m.export(format="onnx", imgsz=640, batch=1, device="cpu")
PY
```

Grounding DINO-T official CPU smoke test:

```bash
python demo/inference_on_a_image.py \
  -c groundingdino/config/GroundingDINO_SwinT_OGC.py \
  -p weights/groundingdino_swint_ogc.pth \
  -i test.jpg -o groundingdino-smoke \
  -t "bottle . cell phone . book . eyeglasses case . sports ball . bicycle . coin ." \
  --cpu-only
```

OWLv2 base official Transformers CPU smoke test after the model snapshot is local:

```bash
python - <<'PY'
from PIL import Image
from transformers import Owlv2ForObjectDetection, Owlv2Processor
path = "models/owlv2-base-patch16-ensemble"
p = Owlv2Processor.from_pretrained(path, local_files_only=True)
m = Owlv2ForObjectDetection.from_pretrained(path, local_files_only=True).eval()
image = Image.open("test.jpg").convert("RGB")
texts = [["a bottle", "a cell phone", "a book", "an eyeglasses case", "a sports ball", "a bicycle", "a coin"]]
inputs = p(text=texts, images=image, return_tensors="pt")
outputs = m(**inputs)
print(p.post_process_grounded_object_detection(outputs, target_sizes=[image.size[::-1]], threshold=0.0)[0])
PY
```

After every model has completed one connected cold run, repeat its exact warm command with network access disabled and `HF_HUB_OFFLINE=1`, `TRANSFORMERS_OFFLINE=1`. A failure is an artifact-preparation failure, not evidence about model speed.

### Decision gates after measurement

Do not select a model on inference FPS alone. A candidate advances only if it detects at least some of the currently missed owner targets without an unsafe false acquisition in the absent/distractor cases, completes the offline test, and can be run beside the unchanged camera/person pipeline without violating the existing displayed-FPS, frame-age, throttling and stability gates. Continuous, periodic and one-shot scheduling are three measured configurations of every surviving candidate; none is the default merely because of model size. If PyTorch dynamic prompting passes, it remains a legitimate continuous candidate. If a static export passes, record that its vocabulary is frozen and do not describe it as arbitrary prompt-at-runtime detection.

### First executed result — YOLOE-26n on Pi, 2026-09-19

The prompt-free and targeted-text PyTorch checkpoints both loaded on the live Pi while the existing camera/person service remained running. Prompt-free sustained2.45fps at320 and0.94fps at640. An eight-class text profile sustained2.83fps at320 and1.32fps at640; its saved15.6KB prompt profile loads in about2ms after one-time preparation. No throttle or application error appeared, and the camera service recovered to30capture/vision fps after contention. This directly disproves exclusion based solely on assumed compute load. The unannotated prompt-free room view produced several implausible labels, so quality is not accepted. Physical targeted-text and visual-prompt comparisons remain required. Exact artifacts, hashes, timing distributions, memory and coexistence samples are in [`bgd_vision/evidence/yoloe26-pi-benchmark-2026-09-19.json`](../../bgd_vision/evidence/yoloe26-pi-benchmark-2026-09-19.json).

In a first owner-present physical book scene, an eight-class profile was intermittent. A book-only profile at640 emitted `book` in10/10frames around11.1% best confidence, while320 emitted none. This is evidence that direct continuous text-prompted detection can produce a stable candidate on the Pi, but low confidence and absent localization ground truth prevent an accuracy or safety claim. Visual-prompt localization is the next comparison.

The owner then supplied a snug visual reference box around the stationary book. YOLOE visual prompting detected it in10/10fresh640-pixel frames with96.9% best confidence and0.828 median box overlap. It sustained1.23fps with480.1MB peak RSS while the existing service remained healthy. This passes one stationary visual-prompt localization scene and demonstrates a viable “this object” grounding path on the Pi. Motion, exit/return, distractors and camera motion remain separate tests.
