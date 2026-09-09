# Research: Face verification stack for the desk phase (ticket 05)

> **Consolidation note — 2026-08-30**
> Historical recognition-stack research, not a validated security gate. Thresholds, liveness, replay resistance, and enrollment acceptance still need validation.
> Source: `research/face-stack`, commit `dfb84fc821c213a2897ed156deb20d75dd5ec24e`, file `docs/research/face-stack.md`.
> Original report text is retained below, with line endings normalized; this consolidation did not revalidate its external claims. Current decisions: [Lock the milestone ladder](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md).

Date: 2026-08-06. Method: primary sources only (GitHub repos, PyPI, in-repo docs/source). Each claim cited. Unverified items flagged at the end.

## Recommendation

**InsightFace (`insightface` pip package, `buffalo_l` model pack) + `onnxruntime` for CPU inference.** Fallback/alternative: DeepFace. Rule out `face_recognition`/dlib.

Why:
- Actively maintained: InsightFace 1.0 released 2026-05-23, latest PyPI release 1.0.1 (2026-05-23); repo news entries as recent as 2026-07-27 ([repo](https://github.com/deepinsight/insightface), [PyPI](https://pypi.org/project/insightface/)).
- State-of-the-art accuracy for free: `buffalo_l` (SCRFD-10GF detector + ArcFace ResNet50 trained on WebFace600K) scores LFW 99.83%, CFP-FP 99.33%, AgeDB-30 98.23%, IJB-C(E4) 97.25% ([python-package README](https://github.com/deepinsight/insightface/tree/master/python-package)).
- Light dependency chain for a beginner: numpy + onnxruntime, no TensorFlow/PyTorch at inference time. "Starting from insightface>=0.2, we use onnxruntime as inference backend"; plain `onnxruntime` is the CPU path, `onnxruntime-gpu` only if you have a GPU ([PyPI](https://pypi.org/project/insightface/)).
- Windows friction resolved in 1.0.x: the default install "no longer builds the optional C++/Cython `face3d` extension, reducing local compiler requirements" — historically the main Windows pain point (needing MSVC build tools) ([repo README](https://github.com/deepinsight/insightface), [PyPI 1.0.1 notes](https://pypi.org/project/insightface/)).
- Edge path exists for the drone phase: `buffalo_s` pack swaps in SCRFD-500MF + MobileFaceNet (450M FLOPs, 13MB model) — same API, same embedding workflow, sized for Pi/Jetson ([python-package README](https://github.com/deepinsight/insightface/tree/master/python-package), [model_zoo](https://github.com/deepinsight/insightface/tree/master/model_zoo)).

## Candidates compared

| Stack | Maintenance | Accuracy (LFW) | Deps | Windows | Verdict |
|---|---|---|---|---|---|
| InsightFace `buffalo_l` | 1.0.1, 2026-05-23; active | 99.83% | numpy, onnxruntime | wheel, no compiler (1.0.x) | **Recommended** |
| DeepFace | 0.0.100, 2026-05-09; active | wraps many models incl. ArcFace and Buffalo_L | TensorFlow-based framework stack (heavier) | `pip install deepface` | Good fallback; easiest API |
| face_recognition (dlib) | last release 1.3.0, **2020-02-20** | 99.38% | dlib (C++ build) | "Windows not officially supported, but might work" | Ruled out |

Sources: [DeepFace repo](https://github.com/serengil/deepface), [DeepFace PyPI](https://pypi.org/project/deepface/), [face_recognition repo](https://github.com/ageitgey/face_recognition), [face-recognition PyPI](https://pypi.org/project/face-recognition/).

Notes:
- DeepFace's `verify()` is a genuine one-liner with pre-tuned thresholds and cosine as default metric, and it now wraps Buffalo_L itself — useful as a cross-check harness even if we build on insightface directly ([repo](https://github.com/serengil/deepface)).
- face_recognition: six years without a release, dlib compilation on Windows, and lower accuracy. No reason to pick it in 2026.

## Verification flow (enroll → embed → cosine threshold)

```python
from insightface.app import FaceAnalysis
import numpy as np

app = FaceAnalysis(name="buffalo_l", providers=["CPUExecutionProvider"])
app.prepare(ctx_id=-1)                      # -1 / CPU provider = CPU-only

faces = app.get(frame)                      # detect + align + embed in one call
emb = faces[0].normed_embedding             # L2-normalized 512-d vector

similarity = float(np.dot(enrolled_emb, emb))   # cosine similarity, since both normalized
unlocked = similarity >= THRESHOLD
```

API shape confirmed by the official example (`FaceAnalysis(...)`, `app.prepare(ctx_id=...)`, `app.get(img)`) in the [python-package README](https://github.com/deepinsight/insightface/tree/master/python-package).

- **Enrollment:** capture several frames of the owner (different angles/lighting), store the embeddings; at verify time compare against all of them (or their mean, re-normalized). One stored `.npy` file is enough — no database.
- **Fail closed:** no face detected, more than one face, or similarity below threshold → stay locked. Every error path returns "locked".

## Threshold guidance (single-user lock, fail closed)

DeepFace ships empirically pre-tuned per-model thresholds in [`deepface/config/threshold.py`](https://github.com/serengil/deepface/blob/master/deepface/config/threshold.py); its distance is cosine **distance** = 1 − similarity ([verification.py](https://github.com/serengil/deepface/blob/master/deepface/modules/verification.py)):

- Buffalo_L: cosine distance ≤ 0.55 → i.e. accept at **similarity ≥ 0.45** (balanced accept/reject point)
- ArcFace (DeepFace's own ArcFace build): cosine distance ≤ 0.68

For a fail-closed lock, false accepts cost more than false rejects, so tighten past the balanced point: start at **similarity ≥ 0.55–0.60** for buffalo_l and calibrate on your own face — measure your genuine-match similarity distribution over a few sessions and a handful of impostor photos, then place the threshold between the two clusters. There is no vendor-published FAR/threshold table for buffalo_l cosine similarity (see unverified items); local calibration is the honest method anyway, since lighting and camera dominate.

## CPU speed expectations

- Detection: SCRFD-0.5GF measured at **28.3 ms** at 640x480 (11.4 ms at 320x240) on an AMD Ryzen 9 3950X, single-thread PyTorch CPU, per the [SCRFD README](https://github.com/deepinsight/insightface/tree/master/detection/scrfd). buffalo_l's SCRFD-10GF is ~20x the FLOPs (9.98G vs 0.508G), so expect a few hundred ms/frame single-threaded, less with onnxruntime multi-threading.
- Recognition: no official CPU latency published for the ResNet50 embedder (flagged below). MobileFaceNet (buffalo_s) is 450M FLOPs / 13MB ([model_zoo](https://github.com/deepinsight/insightface/tree/master/model_zoo)) — comfortably real-time on CPU.
- Practical expectation on a typical desktop CPU: **~2–5 fps with buffalo_l, ~10+ fps with buffalo_s** (estimate, not vendor-published). Either is fine — a lock check needs one good frame, not a video rate. If buffalo_l feels sluggish, drop to buffalo_s and re-calibrate the threshold.

## Licensing catch

- InsightFace **code** is MIT, but the **model weights** (incl. buffalo_l) are "available for non-commercial research purposes only"; commercial use requires contacting contact@insightface.ai ([repo README](https://github.com/deepinsight/insightface)). Fine for this hobby project; revisit if it ever ships commercially.
- DeepFace itself is MIT, but wrapped model weights carry their own licenses ([repo](https://github.com/serengil/deepface)).

## Out of scope (noted, not solved)

- **Liveness/anti-spoofing:** a printed photo of the owner will pass cosine verification. DeepFace has an `anti_spoofing` flag worth evaluating later ([repo](https://github.com/serengil/deepface)).
- **IR cameras:** RGB-trained embeddings on IR imagery is an open question for the drone phase.
- **Edge porting:** buffalo_s + onnxruntime on ARM is the intended path; benchmark on real hardware then.

## Could not verify

- Official CPU latency for the buffalo_l ResNet50 recognition model — no number in model_zoo or python-package docs; the fps figures above are estimates from FLOPs and the SCRFD CPU measurement.
- A vendor-published cosine-similarity threshold/FAR table for buffalo_l — InsightFace publishes benchmark accuracy but not deployment thresholds; the 0.55 cosine-distance figure is DeepFace's tuning, not InsightFace's.
- Exact minimum Python version for insightface 1.0.1 (PyPI wheel says "Python 3" only).
