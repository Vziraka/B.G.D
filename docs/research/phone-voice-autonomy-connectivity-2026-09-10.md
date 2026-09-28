# Phone voice and autonomy connectivity assessment

Date: 2026-09-10. Research recommendation only; no hardware selection, implementation, flight qualification, or requirements amendment.

## Recommendation

Use phone-based voice input, local aircraft mission execution, and optional online assistance for language interpretation. Keep flight control, immediate obstacle response, battery management, and recovery independent of internet access. Prefer local speech transcription on the existing iPhone direction. Keep cloud language assistance an optional extension rather than a prerequisite for the initial operational command set.

This is an engineering judgment from the sources below, not a demonstrated B.G.D. capability. Flexible phrasing and composition of supported actions are a realistic design target; “any command” is not a verifiable promise. Language interpretation must produce a checked mission that the aircraft actually supports, rather than directly issuing unrestricted motor commands.

## Evidence and implications

| Area | Verified fact | Implication for B.G.D. |
|---|---|---|
| Phone speech | Apple's SpeechAnalyzer/SpeechTranscriber supports on-device transcription with downloaded model assets and hardware/language constraints. Older SFSpeechRecognizer exposes a capability check for offline recognition. [Apple WWDC25](https://developer.apple.com/videos/play/wwdc2025/277/), [Apple capability API](https://developer.apple.com/documentation/speech/sfspeechrecognizer/supportsondevicerecognition) | Start with native local transcription after checking the actual iPhone, OS, language and installed assets. Recognition turns speech into text; it does not itself plan a mission. |
| Aircraft computing | ArduPilot supports companion computers communicating with the flight controller through MAVLink and processing telemetry and additional sensors. [ArduPilot companion computers](https://ardupilot.org/dev/docs/companion-computers.html) | Put aircraft perception and mission execution onboard, with the flight controller responsible for flight stabilization. |
| Local language models | NVIDIA documents local LLM and vision-language workloads on edge computers. [NVIDIA edge AI overview](https://developer.nvidia.com/blog/getting-started-with-edge-ai-on-nvidia-jetson-llms-vlms-and-foundation-models-for-robotics/) | Internet is not intrinsically required for flexible language. This does not establish that the current B.G.D. computer can run all required workloads within power, memory, cooling and latency limits. Benchmark before choosing hardware or claiming full offline capability. |
| Lost command link | ArduPilot's ground-station failsafe monitors MAVLink heartbeats and supports configured recovery behaviors. A restored heartbeat does not automatically restore the previous flight mode. [ArduPilot GCS failsafe](https://ardupilot.org/copter/docs/gcs-failsafe.html) | Distinguish phone-session loss, companion-computer failure and internet loss. A companion heartbeat must not mask the loss of the owner session. Recovery needs integration tests and environment-specific validation. |
| Warehouses | ArduPilot supports non-GPS position sources; low-cost inertial sensors alone drift too quickly for position estimation. [ArduPilot non-GPS navigation](https://ardupilot.org/copter/docs/common-non-gps-navigation-landing-page.html) | Warehouse missions need a validated alternative positioning system. A language model or internet connection does not replace it. |
| Obstacles | ArduPilot avoidance support depends on sensors and flight modes; simple avoidance and autonomous route avoidance have different support. [ArduPilot simple avoidance](https://ardupilot.org/copter/docs/common-simple-object-avoidance.html) | Do not infer general warehouse navigation or detection of every obstacle from an “obstacle avoidance” feature checkbox. |

## Internet is different from the phone-to-aircraft connection

Internet access reaches online services. The command link carries the owner's requests and aircraft status. Offline operation can still use a private wireless command link. Conversely, internet-assisted language does not prove that commands will reach the aircraft through buildings, trees, or across the intended area.

The current [interaction contract](../phone-drone/interaction-contract.md) specifies aircraft-hosted private Wi-Fi and no internet/cloud requirement. Phone disconnection ends the owner session; finite accepted work may complete only under the contract's conditions, and open-ended activity enters validated recovery. Wi-Fi range and coexistence remain unvalidated. The owner's desired out-of-sight missions therefore require a separate communications and session-policy assessment; this recommendation does not silently authorize continuing open-ended missions after disconnection or claim sufficient Wi-Fi range.

Optional cloud interpretation is a proposed extension, not a reason to replace the offline contract. If local interpretation cannot understand a request, the initial product should explain that limitation instead of silently becoming internet-dependent. An indoor recovery action also cannot simply assume outdoor return-to-home behavior is appropriate.

## Next engineering step

After the owner-facing requirements review, assess one end-to-end example using phone speech, a checked mission description and simulated onboard execution. Compare local and optional online interpretation on the owner's example commands. Include ambiguous requests, unavailable capabilities, loss of internet, loss of command link, and unavailable position estimates. Use measured latency, task success and compute load to choose deployment details. This note does not authorize that implementation or physical operation.

## Provenance

- Official web sources accessed 2026-09-10; documentation is mutable and requires rechecking against selected software versions before integration.
- Main checkout base commit: `e760b7bdc83cf45f6089ea291b026856ad717557`.
- Local contract had uncommitted changes when inspected; SHA-256: `E13425F531BE3281DA9C2A480F8B548ED7FE389E3C80BADEA814339ECA04A6E5`.
- Owner conversation supplies the revised goals: phone voice, natural-language missions, outdoor areas with buildings/trees and large indoor spaces, out-of-sight intent, and no cargo. The recommendation concerns connectivity only; goals have not been propagated into the authoritative requirements by this note.
- This report is saved in the shared checkout and is uncommitted. No other files were changed by this research subtask.
