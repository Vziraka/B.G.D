# Onboard compute & camera path

Type: research
Status: resolved

## Question

Which onboard companion computer path should later milestones assume — Raspberry Pi 5, Jetson (Orin Nano), or alternatives — and what payload headroom must the milestone-1 frame/motors reserve so the build doesn't dead-end?

- Realistic CPU/GPU needs for onboard face verification + body tracking at useful frame rates; cite benchmarks or first-party model docs, not vibes.
- Weight + power draw of each candidate (board, camera, wiring, regulator) → payload gram budget the milestone-1 BOM must carry.
- Camera path: CSI vs USB, IR-capable options later for low light/liveness.
- Budget reality: Jetson + depth camera likely busts the total budget — name the cheap-but-viable path and what it gives up.

Findings: [Shared research report](../../../docs/research/onboard-compute.md), originally from branch `research/onboard-compute` (commit `831d32a`). Read its dated status note before applying the historical answer below.

## Answer

**Recommended path: Raspberry Pi 5 8GB + AI HAT+ (Hailo-8 accelerator) + Camera Module 3 NoIR (CSI).** ~$185–210 total vs ~$310–340 for the Jetson Orin Nano path, which alone would eat over half the project budget.

**What milestone 1 must reserve (feeds ticket 09):**
- **250 g payload headroom** (the Pi stack is ~120–150 g; 250 g keeps the Jetson door open if ever needed).
- One **5 V / 5 A (25 W) BEC tap** — covers the Pi 5 spec and the Jetson envelope alike.
- Flat mounting space ~90×60 mm; vibration-isolated camera mount.

**Compute evidence (first-party):** Pi 5 CPU-only body tracking is marginal (~7–15 FPS with light YOLO models); the Hailo-8 accelerator (26 TOPS @ ~2.5 W) fills the gap; Jetson (~219 FPS) is overkill for a 15–30 FPS need. Face verification stays event-driven and CPU-feasible via InsightFace `buffalo_sc`.

**Tradeoff:** the Pi/Hailo path gives up CUDA freedom — models must compile to Hailo's format, face embeddings run on CPU, and depth/VIO-heavy ambitions would force buying the Jetson later (airframe reservation already covers its mass/power, so only compute gets rebought).

Unverified items (board weights, Hailo FPS tables, street prices) flagged in the findings doc.

## Comments

### 2026-08-30 — Shared research and current scope

The exact compute package and its original cost/payload assumptions are reopened. The older Pi 5 8GB/Hailo cost baseline is superseded for planning by the provisional lifetime-budget rebaseline, which does not establish a complete fit. See the [provisional budget rebaseline](../../../docs/research/lifetime-budget-rebaseline.md). Confirmed scope is recorded in [Lock the milestone ladder](10-milestone-ladder.md#comments).

The original question and answer are retained as history. The report is now available in the main checkout with source provenance; consolidation did not revalidate its external claims or change this research ticket's resolved status.
