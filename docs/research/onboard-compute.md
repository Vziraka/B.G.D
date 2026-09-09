# Research 04: Onboard companion compute path

> **Consolidation note — 2026-08-30**
> Superseded compute/cost baseline. Memory size, accelerator, and final payload requirements remain subject to the reopened hardware and lifetime-budget decisions.
> Source: `research/onboard-compute`, commit `831d32a54315d218d02246f980a246515e88d44a`, file `docs/research/onboard-compute.md`.
> Original report text is retained below, with line endings normalized; this consolidation did not revalidate its external claims. Current decisions: [Lock the milestone ladder](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md).
> Newer budget evidence: [lifetime budget rebaseline](lifetime-budget-rebaseline.md).

**Question:** Which companion-computer path should later milestones assume — Raspberry Pi 5, Jetson Orin Nano, or alternatives — and what payload gram budget must milestone 1 reserve?

**Date:** 2026-08-06. Primary sources only; each claim cites its URL. Unverifiable items are listed at the end.

## Recommendation

**Assume: Raspberry Pi 5 (8GB) + AI HAT+ (Hailo, 26 TOPS) + Camera Module 3 NoIR (CSI).**
**Milestone 1 must reserve: 250 g payload and one clean 5 V / 5 A (25 W) tap off the flight battery.**

The Jetson Orin Nano Super dev kit ($249 board alone, before camera/carrier/power) plus a camera pushes the compute line item past ~$300 of a $500–600 total budget and roughly doubles the flying mass. The Pi path lands at ~$185–210 for board + accelerator + camera and fits inside a 150 g typical build-out; the 250 g reserve covers the Jetson path too, so milestone 1's frame/motor choice keeps both doors open.

## 1. Compute requirements vs. measured throughput

Target workload: continuous person/body detection + tracking at a usable rate (≥15 FPS detection; tracking-by-detection tolerates gaps), plus face verification on demand (1–5 Hz is enough — you verify a face once, then track the body).

First-party benchmarks (Ultralytics, 640 px input):

| Platform | Model / format | Latency | FPS | Source |
|---|---|---|---|---|
| Raspberry Pi 5 (CPU only) | YOLO11n ONNX | ~147 ms | 6.79 | [Ultralytics Pi guide](https://docs.ultralytics.com/guides/raspberry-pi/) ("Compared to YOLO11n, YOLO26n achieves a ~15% increase in FPS (6.79 → 7.79) … ONNX-exported models on the Raspberry Pi 5") |
| Raspberry Pi 5 (CPU only) | YOLO26n NCNN (fastest format) | 67.03 ms | 14.9 | [Ultralytics Pi guide](https://docs.ultralytics.com/guides/raspberry-pi/) |
| Jetson Orin Nano Super (JP6.1) | YOLO11n TensorRT FP16 | 4.57 ms | ~219 | [Ultralytics Jetson guide](https://docs.ultralytics.com/guides/nvidia-jetson/) |
| Jetson Orin Nano Super (JP6.1) | YOLO11n TensorRT INT8 | 3.80 ms | ~263 | [Ultralytics Jetson guide](https://docs.ultralytics.com/guides/nvidia-jetson/) |

Reading:

- **Pi 5 CPU alone is marginal.** ~15 FPS best-case for a nano detector at 640, before tracking, face pipeline, video encode, or flight-control I/O share the same four cores. It would work at reduced resolution/rate, but with no headroom.
- **Jetson Orin Nano is overkill for this workload** — 200+ FPS on a nano detector when the requirement is ~15–30.
- **Pi 5 + Hailo accelerator is the middle path.** The AI HAT+ carries a Hailo-8 at "26 TOPS" ([raspberrypi.com AI HAT+ product page](https://www.raspberrypi.com/products/ai-hat/)); Hailo states "typical power consumption of 2.5W" for the Hailo-8 ([hailo.ai Hailo-8 page](https://hailo.ai/products/ai-accelerators/hailo-8-ai-accelerator/)). Raspberry Pi states the HAT is "fully integrated into Raspberry Pi's camera software stack" and handles object detection/segmentation/pose ([product page](https://www.raspberrypi.com/products/ai-hat/)). No first-party FPS table exists for YOLO-on-Hailo (see unverified list), but 26 INT8 TOPS against a detector that a 4-core CPU already runs at 15 FPS gives ample margin for real-time detection at camera frame rate.

**Face verification:** InsightFace's `buffalo_sc` pack is the lightweight option: SCRFD-500MF detection + MobileFaceNet (MBF@WebFace600K) recognition, 16 MB total ([InsightFace python-package model zoo](https://github.com/deepinsight/insightface/tree/master/python-package)). Recognition runs on a 112×112 crop of an already-detected face, so it is a per-event cost, not a per-frame cost; on-demand verification at a few Hz is CPU-feasible on the Pi 5 even with detection offloaded to the Hailo. InsightFace publishes no Pi/Jetson benchmarks (see unverified list) — this is an inference from model size/class, to be validated in the milestone that integrates it.

## 2. Weight and power per candidate

Officially published figures are thin on weight; unpublished items carry estimates and are flagged.

### Path A — Pi 5 + AI HAT+ (recommended)

| Item | Weight | Power | Cost | Source |
|---|---|---|---|---|
| Raspberry Pi 5 8GB | ~45–50 g (est.; not officially published) | 5 V/5 A (25 W) supply spec; 5 V/3 A workable with 600 mA USB peripheral cap | ~$80 (8GB street; only $305/16GB shown on product page) | [Pi 5 product page](https://www.raspberrypi.com/products/raspberry-pi-5/), [Pi power docs](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html) |
| AI HAT+ (Hailo-8, 26 TOPS) | ~25 g (est.; 66 × 56.5 mm board, weight not published) | 2.5 W typical (Hailo-8) | from $70 | [AI HAT+ product page](https://www.raspberrypi.com/products/ai-hat/), [AI HAT+ docs](https://www.raspberrypi.com/documentation/accessories/ai-hat-plus.html), [hailo.ai](https://hailo.ai/products/ai-accelerators/hailo-8-ai-accelerator/) |
| Camera Module 3 NoIR | 4 g (official) | negligible (CSI) | ~$35 | [Pi camera docs](https://www.raspberrypi.com/documentation/accessories/camera.html) |
| 5 V/5 A BEC (e.g. 2–6S in) | ~10–15 g (est.) | converts pack V → 5 V, ≥25 W | ~$15 | vendor-specific, not primary-verified |
| Mount, standoffs, wiring, active cooler | ~35–55 g (est.) | — | ~$10 | estimate |
| **Total** | **~120–150 g** | **budget 25 W at 5 V** | **~$185–210** | |

### Path B — Jetson Orin Nano Super dev kit

| Item | Weight | Power | Cost | Source |
|---|---|---|---|---|
| Dev kit (module + carrier + heatsink) | ~175 g (est.; NVIDIA does not publish kit weight on cited pages) | "7W–25W" configurable | $249 ("The price is now $249, down from $499") | [NVIDIA dev kit page](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetson-orin/nano-super-developer-kit/), [NVIDIA blog](https://blogs.nvidia.com/blog/jetson-generative-ai-supercomputer/) |
| Camera (22-pin CSI, 2- or 4-lane) | ~5–10 g | negligible | ~$30–60 | [dev kit user guide, hardware layout](https://docs.nvidia.com/jetson/orin-nano-devkit/user-guide/latest/hardware_layout.html) ("two 22-position flex connectors for CSI camera modules"; CAM0 2-lane, CAM1 2- or 4-lane) |
| DC regulator (pack → barrel jack, 5.5 × 2.5 mm) | ~20–30 g (est.) | must deliver 25 W + margin | ~$20 | jack size from [hardware layout](https://docs.nvidia.com/jetson/orin-nano-devkit/user-guide/latest/hardware_layout.html); input V/A range not in cited excerpt |
| Mount + wiring | ~30 g (est.) | — | ~$10 | estimate |
| **Total** | **~230–280 g** | **budget 25 W + regulator losses** | **~$310–340** | |

### Path C — Pi 5 alone (fallback, $0 extra over Path A minus HAT)

Same as Path A without the HAT: ~95–125 g, ~$115–140. Ships ~10–15 FPS nano detection at 640 CPU-only ([Ultralytics Pi guide](https://docs.ultralytics.com/guides/raspberry-pi/)) with zero headroom. Viable only if tracking targets drop to ~5–10 FPS at reduced resolution. Keep as degraded mode, not the plan.

## 3. Camera path

- **CSI over USB.** Pi 5 has "2 × 4-lane MIPI camera/display transceivers" ([Pi 5 product page](https://www.raspberrypi.com/products/raspberry-pi-5/)); CSI cameras are lighter (4 g), lower latency, and don't contend for USB bandwidth/power (relevant under the 600 mA USB cap on a 3 A supply, [Pi power docs](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html)). USB webcams are 50–100 g+ with housings and add nothing here.
- **IR / low light / liveness:** Camera Module 3 **NoIR** variants "don't have an infrared filter; they capture both visible light and infrared light" ([Pi camera docs](https://www.raspberrypi.com/documentation/accessories/camera.html)) — pair with an IR illuminator later for low-light operation. Same 4 g, same connector, so choosing NoIR now costs nothing.
- **Motion blur option:** the Raspberry Pi Global Shutter Camera "captures the light from every pixel in the scene at once," eliminating rolling-shutter distortion on fast motion ([Pi camera docs](https://www.raspberrypi.com/documentation/accessories/camera.html)) — a drop-in swap if prop vibration/rolling shutter ruins detection, at lower resolution.
- Jetson uses 22-pin CSI connectors (different ribbon/ecosystem than Pi's 15-pin standard cable) — a camera bought for one does not trivially move to the other; one more reason to commit to a path now.

## 4. What must milestone 1 reserve

- **Payload: 250 g** above the bare flying weight, at hover throttle ≤ 50–60% when loaded. Covers Path A (~150 g) with margin, and keeps Path B physically possible. This is the number the motor/prop/frame ticket must satisfy.
- **Power: 25 W continuous at 5 V** (i.e., a 5 A-capable 5 V BEC or the pad space/pack capacity to add one). Pi 5's specified supply is 5 V/5 A ([Pi power docs](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html)); Jetson's envelope is 7–25 W ([NVIDIA](https://www.nvidia.com/en-us/autonomous-machines/embedded-systems/jetson-orin/nano-super-developer-kit/)). Both fit the same 25 W budget. At a 4S nominal 14.8 V pack, 25 W ≈ 1.7 A pack-side — noticeable but small next to propulsion draw; the real cost is the payload's effect on flight time.
- **Mounting:** flat real estate for a ~90 × 60 mm stack (Pi + HAT + cooler) or 103 × 90 mm (Jetson kit), soft-mounted (camera needs vibration isolation for usable frames).

## 5. What the cheap path gives up vs. Jetson

- **Raw throughput and model freedom.** Orin Nano runs YOLO11n at ~219 FPS FP16 via TensorRT ([Ultralytics](https://docs.ultralytics.com/guides/nvidia-jetson/)) and runs arbitrary PyTorch/ONNX models via CUDA. The Hailo path requires compiling models to Hailo's format; anything not in Hailo's supported-ops set falls back to the Pi's CPU.
- **InsightFace GPU acceleration.** InsightFace supports CUDAExecutionProvider ([InsightFace repo](https://github.com/deepinsight/insightface/tree/master/python-package)) — on Jetson the whole face pipeline is GPU-native. On the Pi path, plan on Hailo for detection + CPU for the MobileFaceNet embedding (small, event-driven — believed fine, but unbenchmarked, see below).
- **Headroom for scope creep** — depth models, VIO, larger detectors would need the Jetson. If a later milestone genuinely needs them, the 250 g / 25 W reservation means only the compute stack gets rebought, not the airframe.

## 6. Could not verify (primary sources checked, figure absent)

- **Pi 5 board weight** — not on the product page; the official product-brief PDF could not be text-extracted in this environment. ~45–50 g is a community-measured figure.
- **AI HAT+ weight and power draw** — Raspberry Pi publishes dimensions (66 × 56.5 mm) but no weight or wattage ([docs](https://www.raspberrypi.com/documentation/accessories/ai-hat-plus.html)); only the Hailo-8 chip's 2.5 W typical is first-party ([hailo.ai](https://hailo.ai/products/ai-accelerators/hailo-8-ai-accelerator/)).
- **Jetson Orin Nano dev kit weight and DC-jack V/A rating** — not in the user-guide pages fetched; NVIDIA defers to the carrier-board specification PDF. ~175 g is a community figure.
- **First-party YOLO/SCRFD FPS on the Hailo-8 HAT** — no Ultralytics or Raspberry Pi benchmark table found; the throughput claim rests on the 26 TOPS spec vs. measured CPU baseline.
- **InsightFace inference speed on Pi 5 or Jetson** — InsightFace publishes model sizes and accuracy (buffalo_sc = SCRFD-500MF + MBF, 16 MB) but no embedded-hardware benchmarks.
- **Pi 5 8GB and Camera Module 3 street prices** — product pages fetched showed $305 (16GB Pi 5) and "from $70" (AI HAT+); the ~$80 / ~$35 figures are widely listed retail prices, not confirmed on the fetched pages.
- **Ultralytics' Pi 5 table now benchmarks YOLO26, not YOLO11** — the YOLO11n Pi 5 figure (6.79 FPS ONNX) comes from a comparison sentence in that guide, not a full table.
