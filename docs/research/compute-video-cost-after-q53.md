# Compute and inspection-video costs after Q53

Checked **2026-08-30**. New, uncommitted decision-support report authored in the main checkout, branch `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`; the base does not contain this report. Prior reports remain unchanged. No installation, device access, capture, benchmark, configuration, account, upload or purchase occurred.

Q53 covers the **complete planned build**, tools, radio, charger, initial spares and all features: **$600 goal; $800 absolute maximum only for specifically justified, user-approved tradeoffs**. Later repairs/worn-out replacements are separate; necessary initial and recurring service costs are not thereby excluded. Q52 makes the first offline phone video an inspection/framing aid, not the manual piloting display. Locked/pocketed intentional voice sessions, existing iPhone 17 Pro/USB-C EarPods, no Mac, onboard vision and independent emergency radio remain requirements. [Authoritative ticket](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md)

## Finding

**A shared camera/compute/Wi-Fi path is credible enough to evaluate before adding separate FPV equipment. It is not yet a validated complete system.** Two low-cost CPU-only candidates have priced component subtotals of **$134.34–$145.34**, excluding important integration items below. The cheaper Pi 4 is available at the checked reseller; Pi 5 is not. Neither subtotal proves face/liveness/tracking plus video concurrency, the endurance target, or a complete $600/$800 basket.

These are alternatives, not purchases to add together. No accelerator, second camera, FPV transmitter, goggles or duplicate phone is automatically required by the evidence; equally, this report cannot promise that testing will show no additional hardware is needed.

## Priced component comparison

USD sticker prices before unknown tax/shipping/import costs. PiShop's live product metadata was checked, including `instock`/stock rather than treating its `purchasable` flag as availability. ProgressiveRC's product variant reports available. Stock is a snapshot, not reserved inventory.

| Component | Pi 4 candidate | Pi 5 candidate | Source and current boundary |
|---|---:|---:|---|
| Board, **2GB** | $55.00 | $65.00 | [Pi 4 Model B](https://www.pishop.us/product/raspberry-pi-4-model-b-2gb/) in stock; [Pi 5](https://www.pishop.us/product/raspberry-pi-5-2gb/) zero stock, unavailable at this seller |
| Camera Module 3 **NoIR, standard field of view** | $27.50 | $27.50 | [Camera](https://www.pishop.us/product/raspberry-pi-camera-module-3-noir/), in stock; not the Wide variant |
| Pi 5 standard-to-mini 200mm V2 ribbon | Included standard camera cable | $2.95 | [Adapter ribbon](https://www.pishop.us/product/raspberry-pi-camera-cable-standard-mini-200mm-v2/), in stock; Pi 4 uses supplied standard ribbon |
| Cooling | $6.95 | $10.95 | [Pi 4 case fan/heatsink](https://www.pishop.us/product/case-fan-heatsink-for-raspberry-pi-4-case/); [Pi 5 Active Cooler](https://www.pishop.us/product/raspberry-pi-active-cooler/), both in stock |
| Matching Pi 4 case for that fan's designed attachment | $5.95 | — | [Official red/white case](https://www.pishop.us/product/raspberry-pi-4-case-red-white/), in stock; not claimed flight-optimal |
| 64GB Class 10 blank microSD | $19.95 | $19.95 | [Card](https://www.pishop.us/product/microsd-card-64-gb-class-10-blank/), in stock; storage candidate, not a retention-policy decision |
| Matek BEC12S-PRO regulator | $18.99 | $18.99 | [Product](https://www.progressiverc.com/products/matek-bec12s-pro), [availability data](https://www.progressiverc.com/products/matek-bec12s-pro.js); available |
| **Priced onboard component subtotal** | **$134.34** | **$145.34** | Pi 5 availability conditional; neither includes airframe attachment, power leads/connectors or bench supply |
| Optional acquisition dependency: card reader, counted once if needed | +$2.95 | +$2.95 | [Reader](https://www.pishop.us/product/high-speed-micro-sd-card-reader-maximum-128gb-black/), in stock; not an onboard item |

The **$11 difference** is modest relative to unresolved performance. A lighter Pi 4 cooling mount could replace its case, but its cost/mass/airflow cannot be assumed free. No starter kit, HDMI cable or independent bench PSU is mandatory by definition. Verified sharing of the separately budgeted charger supply through the BEC is an option; electrical ratings, connectors and simultaneous-use needs must be checked. Otherwise add a suitable bench supply explicitly.

The BEC's published 9–55V input and 5A continuous output rating is not proof of acceptable Pi supply transients, connector losses or peripheral power negotiation. Do not power the Pi from an assumed spare FC output. [Regulator specifications](https://www.progressiverc.com/products/matek-bec12s-pro)

## Why video changes the CPU comparison

Raspberry Pi documents **software encoding on Pi 5**, with a latency/encoding-efficiency tradeoff; its earlier-board streaming examples use hardware H.264 encoding. Thus Pi 4 offers a genuine encoder advantage, while Pi 5's stronger inference path still spends CPU resources producing video. The vendor documents working camera-to-streaming-server paths, not this combined drone workload. [Raspberry Pi camera software](https://www.raspberrypi.com/documentation/computers/camera_software.html)

Ultralytics documents camera inference on Pi 4/5 and reports **67.03ms/image** for YOLO26n NCNN on Pi 5, FP32, 640 input, explicitly excluding preprocessing/postprocessing. This is evidence for investigating CPU inference—not a demonstrated 2GB memory budget, sustained tracking rate, face verification, anti-spoofing or simultaneous encoding. There is no matched Pi 4 combined-workload benchmark in this review. Model weights fitting on disk is not proof that the resident pipeline fits RAM. [Model-author benchmark](https://docs.ultralytics.com/guides/raspberry-pi)

**Evaluation obligations:** share camera acquisition deliberately; measure frame copies, capture/encode buffers, model memory, command responsiveness, thermals and total electrical power under simultaneous intended work. Detector-plus-tracker scheduling may reduce inference load, but its ability to preserve a selected subject through motion/occlusion needs evidence. Do not silently stop required following to stream, weaken identity checks, or infer arbitrary-subject capability from a fixed-class detector. Image quality and latency targets, stream duty cycle during endurance testing and acceptable stale-frame behavior remain unspecified.

NoIR retains sensitivity beyond visible light because it lacks the standard infrared-cut filter; it is not thermal vision or self-illumination. Autofocus does not aim or stabilize the camera. Shared optics must satisfy identity capture, tracking and inspection framing, including daylight colour/focus tradeoffs. [Camera manufacturer specifications](https://www.raspberrypi.com/products/camera-module-3/)

## Offline receiving on the existing iPhone

Raspberry Pi documents hosting a wireless network with built-in Wi-Fi and connecting a smartphone. **Inference:** the Pi could host the local video endpoint without an internet uplink or separately purchased access point; that is a candidate topology, not measured airborne coverage. [Official network-hosting documentation](https://www.raspberrypi.com/documentation/configuration/wireless/remote-access.html)

MediaMTX documents browser reception through WebRTC or HLS; HLS generally trades greater latency for simpler connectivity. Apple's HLS supports ordinary web-server delivery to Apple devices. These establish browser-compatible possibilities, unlike assuming Safari directly consumes any raw UDP/RTSP feed. Compatible codecs, local-network permissions, authentication/encryption, local assets, reconnects and stream freshness still need validation on the installed iOS. No protocol/server is selected. [MediaMTX browser support](https://mediamtx.org/docs/read/web-browsers), [Apple HLS](https://developer.apple.com/streaming/)

**No 100m claim:** body/pocket obstruction, antenna orientation, aircraft interference, channel coexistence, link loss and greater eventual range remain untested. Sharing a network with commands/status must not let video congestion defeat authorized command handling. The phone may also need a different radio/Backpack network; simultaneous connectivity and any bridging hardware are unresolved. The independent emergency radio remains, and its existing telemetry is not silently counted as video bandwidth.

A browser video demonstration would not establish the approved **locked/pocketed voice** pipeline. Taking out the phone to view video does not authorize dropping background voice operation. Native versus PWA remains open; offline speaker verification, replay resistance and permissions remain separate from video playback. Existing EarPods avoid a duplicate basic microphone purchase, not possible charging/interface costs.

## Development fees and costs still missing

Expo documents cloud iOS builds triggered from Windows but requires paid Apple Developer signing for its physical-iPhone route. Apple lists **$99 per membership year**; its free Personal Team/Xcode path has seven-day provisioning limits and no usable Mac is available here. This is a conditional cost, not a selected subscription or a universal claim about all possible development routes. Renewal/distribution planning must remain visible, alongside possible build-service charges. Online compilation does not inherently require online runtime. [Expo device-build requirements](https://docs.expo.dev/develop/development-builds/introduction/), [Apple membership](https://developer.apple.com/support/compare-memberships/)

**Unpriced, not zero:** camera-angle mechanism/gimbal and mounts; IR illumination and separate visible path lighting; avoidance sensing/coverage; payload retention, release and authorized-recipient verification; power distribution, wiring and flight-safe mounting; any extra antennas/bridge/accessories; protected enrollment/storage/recovery and biometric hardening dependencies. Their power and mass also belong in propulsion/endurance calculations. Recording and storage requirements remain a separate decision; a live feed alone does not approve retention.

**Decision support:** retain these two CPU-only candidates for a bounded combined-workload feasibility comparison, without buying both or selecting one now. Prioritize proving shared camera/Wi-Fi inspection video alongside the required tracking/security functions before adding a second video system. Consolidate the unpriced obligations with the aircraft/tools report before presenting any above-$600 tradeoff; the conditional $800 ceiling does not make missing features free.
