# Voice verification + offline speech-to-text stack (desk phase)

Type: research
Status: resolved

## Question

Which offline speaker-verification and speech-to-text stacks should the desk phase use on a Windows PC, CPU-only?

- Speaker verification: SpeechBrain ECAPA-TDNN (the Gemini doc's pick — verify it's current best practice) vs alternatives; enrollment/threshold flow for a single-user voiceprint.
- Offline STT for short commands: Vosk vs whisper.cpp / faster-whisper — latency and accuracy for a small fixed command vocabulary on CPU.
- Honest failure modes: background noise, mic quality, replay attacks — record them for the later liveness ticket, don't solve now.
- Feasibility of running verification + STT together live on CPU.

Findings: [Shared research report](../../../docs/research/voice-stack.md), originally from branch `research/voice-stack` (commit `4cc3479`). Read its dated status note before applying the historical answer below.

## Answer

**Speaker verification: SpeechBrain ECAPA-TDNN** (`spkrec-ecapa-voxceleb`) — still current best practice (actively maintained, Apache 2.0, 0.80% EER on VoxCeleb1). Flow: average 5–10 enrollment embeddings into one voiceprint, cosine similarity, calibrate threshold for zero false accepts, every error path rejects (fail-closed). Fallback if PyTorch is too heavy on the Pi later: WeSpeaker (ONNX).

**STT: Vosk** with the small English model (40 MB, officially targets Raspberry Pi) using its runtime **grammar restriction** — the recognizer is literally constrained to the command list plus `[unk]`, so output is either a valid command or a clean reject. Whisper variants rejected for this job: batch-oriented, no phrase restriction, too much RAM for the eventual Pi Zero 2 W handheld.

**Live CPU feasibility: yes** — pipeline is sequential (capture → verify → decode), the two models never run at once.

Recorded risks (not solved here): replay/voice-clone attacks defeat any stock ASV stack — needs its own anti-spoofing ticket before real flight; desk-mic thresholds won't transfer to the handheld mic — re-enroll on target hardware; ECAPA CPU latency has no published primary figure — measure in a spike.

## Comments

### 2026-08-30 — Shared research and current scope

Replay resistance belongs to the hardened desk phase. Earlier zero-false-accept wording is not a demonstrated guarantee; thresholds, threat model, and acceptance tests remain unresolved. Confirmed scope is recorded in [Lock the milestone ladder](10-milestone-ladder.md#comments).

The original question and answer are retained as history. The report is now available in the main checkout with source provenance; consolidation did not revalidate its external claims or change this research ticket's resolved status.
