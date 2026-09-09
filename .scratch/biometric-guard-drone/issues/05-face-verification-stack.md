# Face verification stack (desk phase)

Type: research
Status: resolved

## Question

Which open-source face verification stack should the $0 desk phase use on a Windows PC, CPU-only?

- Candidates: InsightFace (ArcFace models), and whatever else is current and maintained — judge by primary sources (repos, model cards), not blog posts.
- Enrollment→embedding→threshold verification flow; expected accuracy and threshold guidance for a single-user lock.
- CPU-only inference speed on a typical PC; Python API ergonomics for a beginner-readable codebase.
- Note (don't solve) the later concerns: liveness/anti-spoofing, IR cameras, porting to Pi/Jetson.

Findings: [Shared research report](../../../docs/research/face-stack.md), originally from branch `research/face-stack` (commit `dfb84fc`). Read its dated status note before applying the historical answer below.

## Answer

**InsightFace (`insightface` 1.0.1, `buffalo_l` model pack) on `onnxruntime`, CPU.**

- Actively maintained (1.0.1 May 2026); ArcFace ResNet50 at LFW 99.83%; light dependencies (numpy + onnxruntime); 1.0.x ships a wheel, so the old Windows build friction is gone.
- Same-API edge path for the drone phase: `buffalo_s` (MobileFaceNet) swaps in for Pi/Jetson later.
- Verification flow: enroll several owner embeddings → cosine similarity on `normed_embedding`. Fail-closed threshold: start ≥ 0.55–0.60 (vendor-tuned balance point is ~0.45), calibrate on own genuine/impostor samples. No face / multiple faces / any error → locked.
- Expected CPU perf: detector measured 28.3 ms @ 640×480; embedder est. ~2–5 fps with buffalo_l — ample for a lock check.
- **Catch:** InsightFace code is MIT but buffalo weights are non-commercial-research-only — fine for hobby use, flagged if this ever becomes a product.
- Fallback: DeepFace (easiest API, heavier TensorFlow stack). Ruled out: face_recognition/dlib (unmaintained, Windows-hostile).
- Unverified items are listed at the end of the findings doc.

## Comments

### 2026-08-30 — Shared research and current scope

The hardened desk phase includes liveness, encrypted biometric storage, polished enrollment, and replay resistance. The old $0/demo scope and deferred-security wording are superseded; model thresholds and acceptance criteria are not validated by this research answer. Confirmed scope is recorded in [Lock the milestone ladder](10-milestone-ladder.md#comments).

The original question and answer are retained as history. The report is now available in the main checkout with source provenance; consolidation did not revalidate its external claims or change this research ticket's resolved status.
