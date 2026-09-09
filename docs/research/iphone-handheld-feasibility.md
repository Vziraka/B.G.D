# iPhone 17 Pro as the offline handheld — feasibility evidence

## Approved complete-build budget after Q53 — 2026-08-30

The user now approves applying the **$600 goal and conditional $800 absolute maximum** to the complete planned project, including aircraft, radio, charger, tools, initial spares and all requested later capabilities. Future repairs and worn-out replacements are budgeted separately. This resolves the upkeep-boundary question in the earlier note below; it does not make upkeep free or permit moving unfinished features outside the build budget. Necessary development/build costs and recurring charges must remain visible; no fee or service is approved.

Any proposal above $600 still needs a specific, worthwhile tradeoff approved by the user; $800 is not the default spend. No complete fit, purchase-ready package or performance validation is established. Historical prices/findings below are retained, not revalidated by this decision. See the [latest ticket comments](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

## Budget clarification during Q53 — 2026-08-30

The user clarifies **$600 as the goal and $800 as the absolute maximum**, with spending above $600 considered only when specific benefits justify the additional cost and the user approves the tradeoff. The earlier $600-ceiling wording below is historical; $800 is not the default budget, a selected package or purchase permission. Prior full-project coverage includes tools and later capabilities; separating future upkeep remains an unanswered Q53 proposal. No capability is removed and no complete fit at either amount is established. Prices, availability and compatibility have not been rechecked by this decision update. See the [latest ticket comments](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

Q52 also now approves the first live view as an inspection/framing aid, with manual flight by watching the actual aircraft directly. This supersedes the earlier open purpose question, not the unresolved transport/performance evidence; no later FPV requirement is selected.

Checked **2026-08-30**. Scope: ticket 10, Q45–Q46. New, uncommitted decision-support report authored in the main checkout on branch `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`; that commit does not contain this report. No device access, installation, capture, account changes or implementation occurred.

## Decision status after Q51 — 2026-08-30

The user approves **offline live camera viewing on the phone alongside battery/status information as a later milestone**, not M1. Earlier passages calling live video unratified are superseded. Video transport, workload, power and cost still need feasibility checks within the unchanged $600 lifetime ceiling; command telemetry alone is not video validation. Native/web and service choices remain open.

Recording/retention, stream performance and whether the first feed is only an inspection/framing aid remain unselected. Q48's locked/pocketed voice use, the selected existing USB-C EarPods, biometric safeguards and independent emergency radio remain. No stream, capture, installation or hardware test has occurred; see the [latest ticket comments](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

## Decision status after Q50 — 2026-08-30

The user identifies their existing pair as **EarPods (USB-C)**, product `MYQY3AM/A`, and reports plugging them in. Apple explicitly lists **iPhone 17 Pro** compatibility, checked 2026-08-30. This resolves Q49's connector uncertainty; no new earbuds or headphone connector adapter is needed for the reported basic connection. [User-supplied Apple product page](https://www.apple.com/shop/product/myqy3am/a/earpods-usb-c)

This does not validate the project's microphone routing, outdoor audio, voice verification, anti-spoofing or locked-screen operation. Simultaneous charging or a wired radio interface would still need an appropriate connection design because the EarPods use the phone's USB-C port. No hub, adapter, radio interface, app platform or service is selected, and no new hardware cost, capture or test is approved by Q50. Earlier notes are preserved as history.

## Decision status after Q49 — 2026-08-30

The user owns **Apple EarPods** and now chooses that existing pair as the handheld microphone direction, subject to validation. Its connector and direct compatibility with the iPhone 17 Pro remain unknown; no adapter or replacement purchase is approved. This supersedes earlier accessory-selection uncertainty, not Q48's locked/pocketed-use requirement or any security checks.

Apple documents USB-C, Lightning and 3.5 mm EarPods variants, so "regular EarPods" does not identify the connection. Microphone routing, outdoor audio quality, voice verification and background operation still require validation; no capture or test occurred. [Apple wired-headphone guide](https://support.apple.com/en-euro/108042)

## Decision status after Q48 — 2026-08-30

The user now requires deliberately started voice-control sessions to remain usable with the phone **locked and in a pocket**, without all-day listening. Earlier passages treating that requirement as an unanswered choice are historical. This does not establish background reliability, remove command authorization, select an audio accessory or choose native versus web. The no-Mac constraint and all unapproved development costs remain; consult the [latest ticket comments](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments). No new technical validation occurred with this decision.

## Current status after Q47 — 2026-08-30

The user has **no Mac and cannot borrow one**. Earlier statements that Mac access is unknown are superseded by this answer. The Q47 supplement below investigates hosted iOS builds from Windows, their Apple signing costs and the distinction between online development and offline operation. Native versus web, service use and spending remain unapproved; the original Q45–Q46 research is retained beneath this note.

## Original Q45–Q46 findings

The user approved evaluating their existing **iPhone 17 Pro**, not a native-versus-web architecture. Installed iOS, speech-language assets, available storage, accessories and Mac access remain unknown. M1 stays Windows-first PC biometrics plus manual learning; onboard face verification/computation, independent emergency radio control and arming safeguards are unchanged.

## Conclusion

**The phone is a credible evaluation target, not a validated replacement handheld.** Apple lists an A19 Pro, microphones, Wi-Fi, Bluetooth and USB-C connectivity, which provide useful ingredients. They establish neither our complete offline workload nor outdoor audio quality, security or operating endurance. Face ID is not substituted for the approved drone face-and-voice policy. Reuse may avoid purchasing another computer, but can add model-porting, development-access, signing, audio and radio-interface work. No zero-cost or $600-fit conclusion follows. [Apple specifications](https://www.apple.com/iphone-17-pro/specs/)

## Offline transcription is not speaker verification

Apple's iOS 26 SpeechAnalyzer/SpeechTranscriber provides on-device transcription after the relevant model assets are present; language and hardware support must be checked. Initial asset acquisition can require a download. This distinguishes **offline operation** from assuming every model is already installed. [Apple SpeechAnalyzer presentation](https://developer.apple.com/videos/play/wwdc2025/277/)

The older Speech API also exposes an on-device request option, but Apple says it is honored only when the recognizer reports on-device support. Setting a flag alone is insufficient evidence. **Design obligation:** validate device/locale/assets, reject unavailable operation and prevent cloud fallback; no API has been selected. [Apple on-device request condition](https://developer.apple.com/documentation/speech/sfspeechrecognitionrequest/requiresondevicerecognition)

Core ML supports local model execution using Apple compute resources and conversion from other ML formats. That does not mean the existing Python SpeechBrain/Vosk/anti-spoof pipeline runs unchanged, or that all model operations convert correctly. Speaker identity, replay/synthetic-voice detection, challenge handling, enrollment protection and command authorization remain separate required functions. Their accuracy, latency, memory and power on this phone are unmeasured. [Apple Core ML](https://developer.apple.com/documentation/coreml)

## Foreground, background and locked screen

Native iOS audio APIs support continued recording when an appropriately configured recording app enters the background, including screen lock, with user permission. Phone calls, alarms and competing audio sessions can interrupt recording. This is a supported capability, not an always-listening guarantee or proof that the full recognition/network pipeline survives interruptions. [Apple recording category](https://developer.apple.com/documentation/avfaudio/avaudiosession/category-swift.struct/record)

**Recommended evaluation distinction:** test foreground commands separately from screen-locked/background operation, headset changes, calls, app termination and recovery. An interruption must not manufacture authorization, reuse stale speech or interfere with independent emergency radio control. The first phone version's desired operating behavior remains a user decision; requiring the screen to stay open must not be silently imposed as a final capability reduction.

For a browser/PWA, this review has **not established reliable locked-screen capture, continuous inference or background radio communication** on the installed iOS. Native background-audio documentation is not evidence that adding a website to the Home Screen grants equivalent behavior. Treat continuity as a gating test, not a categorical claim that all browser background audio is impossible.

## Native app versus offline-capable web app

WebKit's original Safari speech-recognition announcement describes a Siri-based engine. That historical announcement is not an offline guarantee for today's browser and does not expose the native application's on-device-request contract. Safari recognition must not be silently treated as local just because native Speech supports local processing. [WebKit speech API announcement](https://webkit.org/blog/11648/new-webkit-features-in-safari-14-1/)

A different web route is to ship and retain compatible models for local JavaScript/WebAssembly/WebGPU inference. WebKit documents WebGPU and relevant inference-library support in Safari 26.0. This makes browser-side computation worth evaluating, but does not establish a port of our speaker-verification/anti-spoof stack, secure persistent storage, offline asset availability, or acceptable performance. HTML/JavaScript deployment is not simply the native Swift Speech/Core ML code running in a browser. [WebKit Safari 26.0](https://webkit.org/blog/17333/webkit-features-in-safari-26-0/)

A web front end can be developed on Windows without native iOS signing, but its microphone permissions, secure origin, asset caching, lifecycle and local bridge must still work on the actual phone. A native wrapper would reintroduce native build/signing requirements. Neither route is approved or shown easier overall.

## Connections: phone interfaces do not equal an ELRS radio

- **Wi-Fi:** ExpressLRS documents a transmitter-Backpack Wi-Fi/UDP bridge for MAVLink. This is a plausible external connection path, not built-in ELRS capability in the phone. Compatible radio firmware, a client, secure command handling and offline routing still need integration. Do not assume browser code can consume that raw UDP interface; a browser-compatible gateway may add work/hardware. [ExpressLRS bridge](https://www.expresslrs.org/software/mavlink/)
- **Bluetooth:** native Core Bluetooth provides communication with supported Bluetooth peripherals. A suitable peripheral protocol and bridge are still needed; Bluetooth support does not transform the phone into the drone's ELRS transmitter. This review did not verify an iPhone-browser Web Bluetooth path. [Apple Core Bluetooth](https://developer.apple.com/documentation/corebluetooth)
- **USB-C:** Apple supports compatible microphones, Ethernet adapters and other accessory classes. That is not evidence that any USB serial/radio adapter exposes an application-accessible interface. Cables, accessory protocol support, power, simultaneous microphone/charging needs and native-versus-browser access remain compatibility checks. [Apple USB-C accessory support](https://support.apple.com/en-gb/105099)

The physical emergency radio remains. Live video is not included merely because command telemetry works; its requirement and transport remain unresolved.

## Windows development catch and cost boundary

Apple's Xcode releases require compatible **macOS** hosts. The Windows PC can support planning, portable code and web development, but is not itself the documented Xcode/iOS build environment. Existing access to a suitable Mac is unknown; no purchase, rental or cloud-build service is assumed. A compatible Xcode/SDK must also support the phone's actual iOS. [Apple Xcode requirements](https://developer.apple.com/xcode/system-requirements)

Apple permits personal-device testing with a free Apple Account/Personal Team. It lists seven-day provisioning expiry, potentially requiring rebuilding/reinstallation, plus App ID/device limits. Paid membership is **99 USD per membership year** or local equivalent and adds distribution/capability options; it is **not mandatory for every personal test**. Neither path guarantees unattended long-term availability, every entitlement, or zero ongoing maintenance. Mac access, any membership chosen, accessories and integration costs belong in the unchanged lifetime budget. [Apple membership comparison](https://developer.apple.com/support/compare-memberships/)

**Most useful next question:** Do you already have access to a Mac that could be used for iPhone app development? This asks about an existing resource, not permission to buy one or approval of native architecture. Installed iOS and background-use expectations remain subsequent inputs.

## Q47 supplement — Windows development without a Mac

Checked **2026-08-30**. Q47 confirms **no owned or borrowable Mac**; this supersedes that resource uncertainty above, not the original evidence. This appendix is uncommitted decision support under the main-branch/base provenance recorded at the start. Neither Expo nor another development route is selected; no account, upload, signing, installation or device test occurred.

### A cloud build is a genuine alternative, with distinct costs

Expo documents editing JavaScript/TypeScript locally and triggering **EAS cloud iOS builds from Windows**, without installing Apple's native build tools locally. Its documented cloud development builds for a **physical iPhone require a paid Apple Developer account**. Simulator builds are a separate artifact that cannot be installed on the phone; producing one without paid device signing is not a free physical-device test. The documented local iOS Simulator uses macOS. These distinctions apply to this concrete Expo route, not every conceivable distribution arrangement. [Expo development-build paths](https://docs.expo.dev/develop/development-builds/introduction/)

Apple's **99 USD per membership year** is separate from Expo's charges. Free Personal Team testing through Xcode remains real, with seven-day provisioning limits, but the missing Mac means it is not an established usable route here. This review does not select membership, a renewal horizon or distribution method. [Apple membership comparison](https://developer.apple.com/support/compare-memberships/)

EAS Build is available on Expo's Free plan as well as paid plans. Consequently, do not automatically budget a paid Expo subscription, but also do not assume unlimited free builds or negligible development delays; actual allowances, queues and any paid usage need checking before adoption. Apple signing and future maintenance remain lifetime-budget items, and no $600 fit is established. [Expo build prerequisites](https://docs.expo.dev/build/setup/)

### Expo Go is not proof that the native workload works

Expo Go lets a phone run project JavaScript inside a prebuilt app without building our own native binary. Its native libraries are fixed: JavaScript cannot add a missing native API after installation. A custom development build can contain additional native libraries. **Project implication:** the selected offline transcription, speaker-verification/anti-spoof engines, background-audio behavior and radio interface need compatible bindings, or custom native work where suitable bindings are absent. Existing audio support does not establish every required API; nor must every component necessarily be written from scratch. An unchanged Python pipeline is not demonstrated. [Expo Go and native-library limits](https://docs.expo.dev/develop/development-builds/faq/)

EAS executes iOS compilation on remote macOS machines after uploading a project archive and preparing signing credentials. It removes the need to possess the build Mac, not the native integration and debugging work. Using that service would require a separately approved source/credential-handling workflow; enrollment recordings, biometric references and recovery secrets must not be assumed part of build inputs. [Expo iOS build process](https://docs.expo.dev/build-reference/ios-builds/)

### Online development need not mean online operation

Expo distinguishes development tooling from preview/release-style builds; preview builds omit developer tools and support production-like testing. Production JavaScript is packaged with the app, unlike live development reloads from a computer. [Expo build profiles](https://docs.expo.dev/build/eas-json/), [bundled versus development JavaScript](https://docs.expo.dev/develop/development-builds/faq/)

**Design inference, not validated behavior:** a cloud-built app can still operate offline if the needed code/models/assets are locally available and commands, identity checks and phone-to-aircraft communication require no internet service. That must be tested on the actual phone, including asset availability, interruptions and radio behavior; neither Expo Go nor a successful cloud compile proves it.

The PWA alternative remains open under the browser limitations already documented. No feature parity, foreground-only restriction or native architecture is approved. Whether deliberately enabled voice-control sessions must remain usable with the screen locked/phone pocketed is still a capability decision that materially affects the comparison. M1 remains Windows-first, and the independent emergency radio, onboard roles and biometric safeguards are unchanged.
