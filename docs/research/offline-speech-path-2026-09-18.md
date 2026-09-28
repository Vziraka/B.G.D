# Offline speech-to-text path for the Pi desk and later iPhone controller

September 18, 2026. Primary-source comparison and recommendation only. This note does not add a microphone, install a package, create a native phone app, identify a speaker, authorize a command, or connect anything to flight control.

## Recommendation

Use **two speech front ends behind one unchanged text-command boundary**:

1. **Now, on the Pi desk:** prototype Vosk with `vosk-model-small-en-us-0.15`, in an isolated environment, from a short recorded WAV before adding live microphone capture. Its 40 MB English model, streaming API and reconfigurable vocabulary are the smallest established fit for the current bounded diagnostic commands. Installation on this exact Pi is a gate, not an assumption, because the application runs Python 3.13 while Vosk's official install page still documents Python 3.5–3.9.
2. **Later, in a native iPhone controller:** prefer Apple's `SpeechAnalyzer` / `SpeechTranscriber` when the owner's iPhone, OS and English locale report support and the model asset has been installed. It performs transcription on-device and avoids shipping a separate model in the app. Use legacy on-device `SFSpeechRecognizer` only as a checked older-device fallback.
3. Keep **whisper.cpp `tiny.en`** as the Pi fallback if Vosk does not install cleanly or if the bounded Vosk prototype exposes an unacceptable accuracy ceiling. It is also a credible non-Apple iPhone fallback, but it is more integration work than Apple's native framework.

The stable system boundary is:

`push-to-talk audio -> local speech-to-text -> transcript -> existing typed command parser -> DIAGNOSTIC_ONLY plan`

Typing remains available. Speech is only another way to produce text. There is no voice identity, speaker verification, biometric permission, mission execution, motor output or flight-controller connection in this phase. Essential command entry and interpretation must not require internet access.

## Why this is not one library everywhere

The Pi and iPhone have different best-supported runtimes. Vosk exposes a small Python/ARM64 path suited to a quick Pi test, while its official iOS installation is only available by contacting the vendor. Apple supplies and manages its own on-device transcription assets but only inside native Apple-platform software. whisper.cpp runs on both platforms, which is attractive architecturally, but sharing an engine is not worth additional C++/model integration before the speech-to-text requirement itself is measured.

Reusing the **transcript-to-command interface** gives the useful portability: the same parser, safety labels and tests remain in force no matter which local recognizer generated the text.

## Comparison

| Candidate | Offline and Pi 5 / ARM64 | Later iPhone path | Licence / assets | Size and compute implications | Streaming and command latency | Integration implication |
| --- | --- | --- | --- | --- | --- | --- |
| **Vosk** | The project describes Vosk as offline, streaming and scalable to Raspberry Pi. Its install page lists Linux ARM64 and Raspbian on Pi 3/4. [Official project](https://github.com/alphacep/vosk-api), [official installation](https://alphacephei.com/vosk/install) | Vosk advertises iOS, but its current installation page says the iOS build is available only on request. This is not the preferred phone route. [Official installation](https://alphacephei.com/vosk/install) | API code is Apache-2.0. The selected English model is also listed as Apache-2.0. [API repository](https://github.com/alphacep/vosk-api), [model catalog](https://alphacephei.com/vosk/models) | Small models are typically about 50 MB and require about 300 MB runtime memory. `vosk-model-small-en-us-0.15` is 40 MB and specifically labeled for Android and Raspberry Pi. The 1.8 GB general English model is unnecessary for this prototype. [Model catalog](https://alphacephei.com/vosk/models) | Vosk provides partial/final streaming results and runtime grammar configuration. The project calls this zero-latency response, but it publishes no applicable end-to-end Pi 5 command timing; measure time to first partial and final result locally. [Project README](https://github.com/alphacep/vosk-api), [recognizer API](https://github.com/alphacep/vosk-api/blob/master/src/vosk_api.h) | Lowest-code Pi route if the wheel imports. The official microphone example is Python, and the recognizer accepts a JSON phrase grammar. A temporary phrase restriction is appropriate for a diagnostic test but must not be mistaken for the eventual natural-language interface. [Python microphone example](https://github.com/alphacep/vosk-api/blob/master/python/example/test_microphone.py), [recognizer API](https://github.com/alphacep/vosk-api/blob/master/src/vosk_api.h) |
| **whisper.cpp** | Officially supports CPU inference, Linux and Raspberry Pi. The command example specifically recommends `tiny` or `base` plus reduced audio context on Raspberry Pi. [Official repository](https://github.com/ggml-org/whisper.cpp), [command example](https://github.com/ggml-org/whisper.cpp/tree/master/examples/command) | Official iOS Objective-C and SwiftUI examples run models locally; the project shows fully offline transcription on an iPhone. [Official repository](https://github.com/ggml-org/whisper.cpp), [SwiftUI example](https://github.com/ggml-org/whisper.cpp/tree/master/examples/whisper.swiftui) | whisper.cpp is MIT. OpenAI releases the original Whisper code and model weights under MIT. [whisper.cpp licence/repository](https://github.com/ggml-org/whisper.cpp), [OpenAI Whisper](https://github.com/openai/whisper) | Official figures: `tiny` 75 MiB disk / about 273 MB memory; `base` 142 MiB / about 388 MB; `small` 466 MiB / about 852 MB. Quantization can reduce disk and memory. Only `tiny.en` should enter the first Pi comparison. [Memory table and quantization](https://github.com/ggml-org/whisper.cpp#memory-usage) | Includes real-time microphone and guided-command examples; the stream example samples audio every 0.5 seconds. That interval is not a latency guarantee, and inference time depends on hardware/model/context. Measure final-command latency under the running camera service. [Examples](https://github.com/ggml-org/whisper.cpp#examples) | More work than the Vosk Python path: build with CMake, add SDL2 for the microphone example, then choose process or native bindings. It offers better open-vocabulary headroom and one engine across Pi/iPhone if later measurements justify the complexity. |
| **Apple SpeechAnalyzer / SpeechTranscriber** | No Raspberry Pi path; this is an Apple-platform framework. | Best later native-iPhone candidate when available. Apple introduced it in iOS 26 as on-device, low-latency live transcription. It supplies volatile and finalized results through asynchronous APIs. [Apple WWDC25](https://developer.apple.com/videos/play/wwdc2025/277/), [SpeechAnalyzer](https://developer.apple.com/documentation/speech/speechanalyzer) | The model is a system-managed Apple asset rather than a model bundled by B.G.D. `AssetInventory` downloads it, stores it outside the app and manages updates. It is an Apple SDK path, not a portable open-source dependency. [Apple WWDC25](https://developer.apple.com/videos/play/wwdc2025/277/) | Apple does not publish a downloadable model size in these sources. It says the asset does not increase app download/storage or runtime memory size because it is retained in system storage and operates outside the app's memory space. Hardware and locale availability must be checked. [Apple WWDC25](https://developer.apple.com/videos/play/wwdc2025/277/), [SpeechTranscriber](https://developer.apple.com/documentation/speech/speechtranscriber) | `progressiveLiveTranscription` is intended for immediate live results, followed by finalized text. Apple describes the model as low latency but provides no B.G.D.-specific timing; measure stop-to-final-text latency on the actual phone. [Apple WWDC25](https://developer.apple.com/videos/play/wwdc2025/277/) | Smallest native iPhone integration, but it requires a Swift app, speech/microphone permission handling, asset preflight and an explicit unavailable-model state. It cannot be dropped into the current Pi-hosted browser page. |
| **Legacy SFSpeechRecognizer** | No Raspberry Pi path. | Viable checked fallback on an older supported Apple device. `supportsOnDeviceRecognition` must be true, and the request must set `requiresOnDeviceRecognition = true`; otherwise recognition may require a network. [Capability](https://developer.apple.com/documentation/speech/sfspeechrecognizer/supportsondevicerecognition), [request requirement](https://developer.apple.com/documentation/speech/sfspeechrecognitionrequest/requiresondevicerecognition) | Apple system API; no B.G.D. model bundle. | Device- and locale-dependent. Apple warns that the legacy on-device request may be less accurate. [Request requirement](https://developer.apple.com/documentation/speech/sfspeechrecognitionrequest/requiresondevicerecognition) | Can report partial results and accept contextual strings, but availability must be tested on the actual phone. [Speech request](https://developer.apple.com/documentation/speech/sfspeechrecognitionrequest) | Use only with both capability and on-device flags checked. Never silently fall back to network recognition when offline operation is required. |

## Compatibility risk that changes the first test

The current camera application records Python 3.13.5 on 64-bit ARM in [`bgd_vision/README.md`](../../bgd_vision/README.md). Vosk's current PyPI release is 0.3.45 from December 2022 and includes a generic Python 3 Linux ARM64 wheel, while its official installation page explicitly names Python 3.5–3.9. These primary sources do not establish Python 3.13 compatibility. [PyPI release and ARM64 wheel](https://pypi.org/project/vosk/), [Vosk installation](https://alphacephei.com/vosk/install)

Therefore, do not install Vosk directly into the working camera environment and do not alter that environment to make it fit. First create an isolated disposable environment and prove only:

- the pinned wheel installs and imports on this Pi;
- the 40 MB model loads;
- one known 16 kHz, 16-bit, mono WAV produces finite partial/final output; and
- the process exits cleanly without disturbing the running camera service.

If that compatibility check fails, stop rather than building Vosk/Kaldi from source; the vendor says source compilation is not straightforward. Move the same WAV test to whisper.cpp `tiny.en`. [Vosk installation](https://alphacephei.com/vosk/install)

## Smallest prototype to run now

### Stage 1 — package and file transcription, no UI

Use one short, locally recorded command WAV and the small Vosk model in an isolated directory. Feed the finalized transcript into the existing command interpreter exactly as typed input is fed today. Return both layers separately:

- `transcript`: what the recognizer heard;
- `interpretation`: the parser's existing `planned`, `clarification_required` or `unsupported` result;
- `mode`: `DIAGNOSTIC_ONLY`;
- `executable`: `false`.

This stage answers whether the engine can run on the exact Pi without mixing microphone permissions, browser behavior or UI work into the compatibility question.

### Stage 2 — bounded push-to-talk

Only after Stage 1 passes, add push-to-talk capture. Do not continuously listen. Compare unrestricted small-model decoding with a temporary grammar containing the six current command families (`follow`, `find`, `count`, `scout`, `status`, `stop`) plus common connector words. The grammar is a test aid; the parser remains the authority and must still clarify or reject unsupported text.

Measure rather than assume:

- time from button press to recording state;
- time from button release to finalized transcript and interpreted result;
- exact transcript and correct parser outcome for supported, ambiguous and unsupported phrases;
- CPU, resident memory, temperature, power flags and camera update rate while recognition runs;
- behavior with internet disconnected; and
- missing model, missing microphone permission, silence, noise and recognizer failure.

The acceptance boundary for this prototype is transcription plus a correct non-executable diagnostic plan. It is not voice authentication, liveness, anti-replay, mission execution or flight readiness.

## Decision gates after the prototype

- Keep Vosk for the Pi desk only if its pinned package works on Python 3.13, command latency is usable under the live camera workload and the bounded phrase set does not create unsafe substitutions.
- Compare whisper.cpp `tiny.en` on the same recorded corpus only if Vosk fails packaging/accuracy/latency; do not install both into the production camera environment merely to create a broad benchmark.
- When native phone work is authorized, test `SpeechTranscriber.isAvailable`, supported/installed English locales and the model-download flow on the actual iPhone. Downloading assets is a setup requirement; normal command transcription must then pass with internet disabled.
- Treat a transcript as untrusted text. The existing parser and later capability/safety checks remain mandatory regardless of speech confidence.

## Provenance and limits

Primary sources were reviewed on September 18, 2026. Library documentation and platform availability can change; pin exact versions and hashes before implementation. No cited source publishes an end-to-end latency or accuracy result for B.G.D.'s Pi 5 running its current camera, tracking, face and liveness workload. Those values remain physical measurements, not research conclusions.
