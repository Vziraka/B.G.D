# Research: Offline voice-verification + STT stack (ticket 06)

> **Consolidation note — 2026-08-30**
> Historical stack research; anti-replay work is part of the hardened desk-phase scope, not an automatically deferred feature.
> Source: `research/voice-stack`, commit `4cc3479c40a04f8a69f0b9c1a043faf777d0e027`, file `docs/research/voice-stack.md`.
> Original report text is retained below, with line endings normalized; this consolidation did not revalidate its external claims. Current decisions: [Lock the milestone ladder](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md).

Date: 2026-08-06. Method: primary sources only (official repos, docs, model cards); every claim cited. Unverified items are flagged in the last section.

## Recommendation (short version)

- **Speaker verification: SpeechBrain ECAPA-TDNN** (`speechbrain/spkrec-ecapa-voxceleb`). Still the mainstream, maintained, Apache-2.0 pick; nothing simpler beats it for a single-user desk phase.
- **STT: Vosk** with `vosk-model-small-en-us-0.15` (40 MB) and a **grammar restricted to the command list**. It is the only candidate that is streaming, tiny, and explicitly targeted at Raspberry Pi.
- Run them **sequentially on the same captured utterance** (verify voiceprint, then decode command). Both are CPU-only friendly; no simultaneous load needed.

---

## 1. Speaker verification

### SpeechBrain ECAPA-TDNN — the earlier pick, still current

- Model: [`speechbrain/spkrec-ecapa-voxceleb`](https://huggingface.co/speechbrain/spkrec-ecapa-voxceleb). ECAPA-TDNN trained on VoxCeleb 1+2; reported **0.80% EER** on VoxCeleb1-test (cleaned). License Apache 2.0. Input must be **16 kHz mono** ("The system is trained with recordings sampled at 16kHz (single channel)").
- SpeechBrain itself is actively maintained (SpeechBrain 1.0 announced Jan 2024, 2024 journal paper, `pip install speechbrain`, Apache 2.0), and ECAPA-TDNN speaker verification is a highlighted capability: [github.com/speechbrain/speechbrain](https://github.com/speechbrain/speechbrain).
- Verification API (from the model card):

  ```python
  from speechbrain.inference.speaker import SpeakerRecognition
  verification = SpeakerRecognition.from_hparams(
      source="speechbrain/spkrec-ecapa-voxceleb",
      savedir="pretrained_models/spkrec-ecapa-voxceleb")
  score, prediction = verification.verify_files("file1.wav", "file2.wav")
  ```

- How the decision works (from [`speechbrain/inference/speaker.py`](https://github.com/speechbrain/speechbrain/blob/develop/speechbrain/inference/speaker.py) source): similarity is **cosine** (`torch.nn.CosineSimilarity(dim=-1, eps=1e-6)`), and `verify_batch(..., threshold=0.25)` returns `prediction = score > threshold`. So the library default threshold is **0.25 cosine similarity** — a starting point, not a calibrated value for our mic/user.
- Offline: the model downloads once from Hugging Face into `savedir`; after that, inference is local. First run needs internet — do it during setup, then the desk phase is fully offline.

### Enrollment / threshold flow (single user, fail-closed)

1. **Enroll:** record ~5–10 short utterances of the owner at 16 kHz mono, `encode_batch()` each, average the embeddings into one voiceprint vector, save to disk (e.g. `voiceprint.npy`).
2. **Verify:** for every incoming command utterance, compute its embedding, cosine-compare against the stored voiceprint.
3. **Threshold:** start at the library default 0.25, then calibrate on the desk: record ~20 owner utterances and ~20 impostor utterances (other people / TV audio), pick a threshold with **zero false accepts** even at the cost of some false rejects.
4. **Fail closed:** any error path — no voiceprint file, audio too short, score below threshold, exception during embedding — must result in *reject*, never *accept*. The drone ignores the command and (optionally) beeps.

### Alternatives considered

| Option | Verdict | Why |
|---|---|---|
| [WeSpeaker](https://github.com/wenet-e2e/wespeaker) | Viable alternative, not needed now | "Research and Production Oriented Speaker Verification... Toolkit"; pretrained ECAPA-TDNN/ResNet/CAM++ models, CLI (`wespeaker --task similarity ...`), ONNX/runtime deployment, ResNet34 **0.723% EER** on VoxCeleb1-O. Marginally better EER than SpeechBrain's 0.80%, but a heavier toolchain and no advantage for one user on a desk. Keep as the porting fallback if SpeechBrain/PyTorch is too heavy on the Pi. |
| [Resemblyzer](https://github.com/resemble-ai/Resemblyzer) | Rejected | GE2E d-vector encoder, 256-dim embeddings, explicitly supports "create a voice profile... from a few seconds of speech (5s–30s)". Simple and CPU-fast, but older architecture (GE2E predates ECAPA) and low commit activity (~50 commits total); accuracy is a generation behind. |
| pyannote embedding models | Rejected | Hugging Face access is gated behind accepting user conditions with an account token, which fights the "fully offline, $0, no accounts" constraint. (Not fetched — see unverified list.) |

**Verdict: the earlier AI doc's ECAPA-TDNN pick stands.** WeSpeaker's ResNet34 edges it on benchmark EER, but for one enrolled speaker on a desk mic the difference is noise; SpeechBrain is the simplest maintained Python path.

## 2. Offline STT for short fixed commands

### Vosk (recommended)

- "Vosk is a speech recognition toolkit" that "works offline, even on lightweight devices — Raspberry Pi, Android, iOS"; "portable per-language models are only 50Mb"; "provides streaming API"; "allows quick reconfiguration of vocabulary for best accuracy"; `pip3 install vosk`. Source: [alphacephei.com/vosk](https://alphacephei.com/vosk/).
- Model for us: [`vosk-model-small-en-us-0.15`](https://alphacephei.com/vosk/models) — **40 MB**, "Lightweight wideband model for Android and RPi", WER 9.85 (librispeech test-clean), Apache 2.0. (The 1.8 GB `vosk-model-en-us-0.22` hits 5.69 WER but is irrelevant for a 10-phrase vocabulary.)
- The killer feature for a fixed command set — **runtime grammar restriction**: "Vosk-API supports online modification of the vocabulary" (small/dynamic-graph models only; [adaptation docs](https://alphacephei.com/vosk/adaptation)). Official example [`test_words.py`](https://github.com/alphacep/vosk-api/blob/master/python/example/test_words.py):

  ```python
  rec = KaldiRecognizer(model, wf.getframerate(),
      '["oh one two three", "four five six", "seven eight nine zero", "[unk]"]')
  ```

  We pass exactly `'["take off", "land now", "follow me", ..., "[unk]"]'`. The recognizer can then only output our commands or `[unk]` — general-vocabulary WER stops mattering, and `[unk]` gives a clean reject path (fail closed again: unknown ≠ nearest command).

### whisper.cpp / faster-whisper (rejected for commands, noted for later)

- [faster-whisper](https://github.com/SYSTRAN/faster-whisper): CTranslate2 reimplementation, "up to 4x faster" than openai/whisper at similar accuracy. CPU benchmark (i7-12700K, 8 threads, 13 min audio): small model INT8 ≈ 51 s–1m42s, ~1.5–2.3 GB RAM. Fine on the desk PC, but batch-oriented (transcribe a finished clip), no true streaming, and its accuracy advantage is on open vocabulary — wasted on 10 fixed phrases. Whisper also has no supported way to hard-restrict output to a phrase list.
- [whisper.cpp](https://github.com/ggml-org/whisper.cpp): C/C++, no dependencies, CPU-only inference, integer quantization, real-time `stream` example that "samples the audio every half a second"; Raspberry Pi explicitly listed as a supported platform. Memory table: tiny = 75 MiB disk / **~273 MB RAM**, base = 142 MiB / ~388 MB, small = 466 MiB / ~852 MB.
- **Pi Zero 2 W fit** ([official spec](https://www.raspberrypi.com/products/raspberry-pi-zero-2-w/): 1 GHz quad-core Cortex-A53, **512 MB SDRAM**): Vosk small (40 MB model, built for "Android and RPi") fits comfortably. whisper.cpp tiny (~273 MB RAM) is borderline on 512 MB alongside the OS and would compete with the verifier for memory; base and up do not fit. faster-whisper (Python + CTranslate2 + ~1.5 GB RAM for small) is out for the Pi.

**Verdict: Vosk small + grammar.** Streaming, 40 MB, phrase-restricted output with a built-in unknown token, and the same stack ports to the Pi unchanged.

## 3. Honest failure modes (record now, anti-spoofing ticket later)

- **Replay / recording attack:** anyone who records the owner saying "take off" and plays it back passes both verification and STT. This is the canonical weakness of automatic speaker verification — the [ASVspoof challenge](https://www.asvspoof.org/) exists to detect exactly this class of attack (TTS, voice conversion, deepfakes), and [ASVspoof 2021](https://www.asvspoof.org/index2021.html) ran "a physical access sub-challenge... with recordings made in real physical environments" (replayed audio). Our stack has **zero** countermeasures. Acceptable for a desk toy; must be a dedicated ticket before anything flies near people.
- **TTS / voice cloning:** a cloned voice from a few seconds of the owner's audio defeats cosine-similarity verification the same way; also ASVspoof territory.
- **Background noise:** ECAPA is trained on VoxCeleb (celebrity interview audio) and Vosk small has ~10% WER in clean read speech; both degrade in noise, and verification scores drop toward the reject region (fail-closed at least fails safe, but usability suffers). Mitigation later: push-to-talk gating, simple VAD, closer mic.
- **Mic quality / channel mismatch:** enrolling on the desk mic and verifying on the Pi handheld's mic shifts cosine scores; the threshold calibrated on the PC will not transfer. Re-enroll and re-calibrate on the target hardware.
- **Sample-rate mismatch:** both stacks assume 16 kHz mono; feeding 44.1 kHz without resampling silently wrecks accuracy.
- **Sick/tired voice, shouting:** intra-speaker variation lowers scores; with a zero-false-accept threshold expect occasional false rejects of the real owner. That is the chosen trade.

## 4. Feasibility: verification + STT together, live, CPU-only

Yes, with a sequential design:

1. Push-to-talk (or VAD) captures one utterance (~1–3 s, 16 kHz mono).
2. ECAPA embedding + cosine check (one forward pass over ~2 s of audio).
3. If accepted, feed the same buffer to the grammar-restricted Vosk recognizer (Vosk can even stream during capture, so its result is ready roughly when the speaker stops).

The two models never run concurrently, so peak load is one small model at a time. Combined footprint (ECAPA weights + 40 MB Vosk model) is trivial for a desktop; whisper-class models are the only memory risk and we're not using them.

## 5. What I could not verify (primary sources)

- **CPU latency of ECAPA-TDNN inference:** neither the model card nor the SpeechBrain README publishes CPU inference timings. Expected to be well under a second for a 2 s utterance on a desktop, but this must be measured in a spike, not assumed — especially before the Pi port.
- **Parameter count / RAM of the ECAPA model on the Pi Zero 2 W:** not stated on the model card; PyTorch itself may be the heavier problem on 512 MB. Porting may require WeSpeaker's ONNX runtime path instead — flagged above.
- **pyannote gating details:** asserted from general knowledge of HF gated models; the model page was not fetched. Does not affect the recommendation.
- **Vosk latency numbers:** the site claims a streaming API but publishes no millisecond figures.
- **ASVspoof task definitions:** the website gives only one-line task blurbs; detailed attack taxonomies live in evaluation-plan PDFs not fetched here. Sufficient for "record the risk", which is all this ticket needs.
