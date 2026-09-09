# Hardware budget feasibility — controller, compute and missing peripherals

## Approved complete-build budget after Q53 — 2026-08-30

The user now approves applying the **$600 goal and conditional $800 absolute maximum** to the complete planned project, including aircraft, radio, charger, tools, initial spares and all requested later capabilities. Future repairs and worn-out replacements are budgeted separately. This resolves the upkeep-boundary question in the earlier note below; it does not make upkeep free or permit moving unfinished features outside the build budget. Necessary development/build costs and recurring charges must remain visible; no fee or service is approved.

Any proposal above $600 still needs a specific, worthwhile tradeoff approved by the user; $800 is not the default spend. No complete fit, purchase-ready package or performance validation is established. Historical prices/findings below are retained, not revalidated by this decision. See the [latest ticket comments](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

## Budget clarification during Q53 — 2026-08-30

The user clarifies **$600 as the goal and $800 as the absolute maximum**, with spending above $600 considered only when specific benefits justify the additional cost and the user approves the tradeoff. The earlier $600-ceiling wording below is historical; $800 is not the default budget, a selected package or purchase permission. Prior full-project coverage includes tools and later capabilities; separating future upkeep remains an unanswered Q53 proposal. No capability is removed and no complete fit at either amount is established. Prices, availability and compatibility have not been rechecked by this decision update. See the [latest ticket comments](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

Checked **2026-08-30** for ticket 10 through Q44. New, uncommitted research authored directly in the main checkout, based on commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`; that commit does not contain this report. Existing records are preserved. This is decision support, not a selected configuration, purchase authorization or security/performance validation.

## Decision status after Q51 — 2026-08-30

Offline live viewing of the drone camera on the phone is now an **approved later capability** alongside battery/status feedback. Earlier text calling live video unratified is historical; its transport, hardware/software workload, power/mass and lifetime costs remain unresolved. The user also identified owned USB-C EarPods for the existing iPhone 17 Pro, with basic connector compatibility confirmed but project audio/security performance untested. See the [phone research status](iphone-handheld-feasibility.md) and [latest ticket comments](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

No replacement basket, video hardware, service fee, purchase or overrun is approved. The original conditional subtotals below are not recalculated as though they include a validated video system. The $600 lifetime target/working ceiling, approved endurance and other retained capabilities remain unchanged.

## Decision status after Q46 — 2026-08-30

The user identifies an **iPhone 17 Pro** for the approved handheld evaluation; its installed iOS version is unknown. The [iPhone feasibility report](iphone-handheld-feasibility.md) now checks platform APIs, background-operation limits, possible radio interfaces and Mac/Xcode/signing implications. These are evidence and unresolved costs, not an app-platform choice, validated handheld or permission to buy development hardware. The Q45 note and original findings below remain historical records.

## Decision status after Q45 — 2026-08-30

The user has approved pursuing and evaluating an existing phone as the offline handheld voice controller in place of a separate handheld computer. The earlier request for permission to evaluate that direction is therefore answered; the phone model, native-app versus web-app choice and feasibility remain open. No final architecture, savings, purchase or M1 phone implementation is approved. Additional radio/interface hardware may be necessary; onboard computation/face verification and independent emergency radio control remain. The original evidence and recommendations below are retained as history; see the [latest ticket comments](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

## Finding

**A complete $600 lifetime fit remains unsubstantiated.** Completing a conditional bare-board compute allowance and adding one priced GPS/compass already pushes the earlier $504.31 partial aircraft/ground subtotal to **$690.59**, before several retained capabilities. The equivalent kit comparison is **$709.69**. These are illustrative comparisons with an estimated, unqualified baseline—not minimum achievable prices or proof that every redesign is impossible. Propulsion/endurance analysis remains separate; two new LiPos, the self-built 7-inch aircraft and selected radio are unchanged.

Availability has also weakened: PiShop's live product metadata reports zero stock for both quoted Pi 5 2GB options. One alternate [Adafruit listing](https://www.adafruit.com/product/6007) also showed the 2GB board out of stock, at $75. This is a bounded two-reseller check, not a universal shortage claim. A displayed price is not an available basket. Q44 permits safe independent work, not waived checks or a budget increase.

## Focused price check

USD sticker prices, excluding unknown shipping/tax/import charges. **Listed** means the seller reports availability, not a reserved item. **Conditional** means unavailable stock, unresolved compatibility, or an estimate. Manufacturer/reseller product metadata was checked where rendered pages were ambiguous.

| Item / exact variant | USD | Current evidence and accounting boundary |
|---|---:|---|
| TBS Lucid H7 FC, dual ICM42688 / DPS310 | 59.95 | Manufacturer lists in stock. FC only, not FC+ESC. [TBS](https://www.team-blacksheep.com/products/prod%3Alucid_h7) |
| TBS Lucid H7 Stack 8S 60A | 109.95 | Same page says both preorder and in stock: conditional. Alternative to FC-only row, never additive. [TBS stack](https://www.team-blacksheep.com/products/prod%3Alucid_h7_stack) |
| Pi 5 2GB bare board | 65.00 | Product metadata: `stock:0`, `instock:false`, despite `purchasable:true`; delivery not established. [PiShop](https://www.pishop.us/product/raspberry-pi-5-2gb/) |
| Camera Module 3 NoIR + standard-to-mini 200mm V2 ribbon | 30.45 | $27.50 + $2.95, listed in stock; correct Pi 5 connector. [Camera](https://www.pishop.us/product/raspberry-pi-camera-module-3-noir/), [ribbon](https://www.pishop.us/product/raspberry-pi-camera-cable-standard-mini-200mm-v2/) |
| Official Active Cooler | 10.95 | Live price metadata; in stock. [PiShop](https://www.pishop.us/product/raspberry-pi-active-cooler/) |
| 64GB Class 10 blank microSD | 19.95 | In stock; storage candidate, not endurance/logging qualification. [PiShop](https://www.pishop.us/product/microsd-card-64-gb-class-10-blank/) |
| Matek BEC12S-PRO | 18.99 | Variant available; independent onboard regulator. [Seller](https://www.progressiverc.com/products/matek-bec12s-pro), [variant data](https://www.progressiverc.com/products/matek-bec12s-pro.js) |
| Compute mounting/power wiring | 10.00 | Existing planning allowance, not verified parts; excludes movable camera mechanism. |
| **Bare in-flight compute/camera subtotal** | **155.34** | Conditional board availability and complete integration; no bench PSU or card reader. |
| microSD reader | 2.95 | In stock; ground accessory, counted once. [PiShop](https://www.pishop.us/product/high-speed-micro-sd-card-reader-maximum-128gb-black/) |
| Pi 5 2GB starter kit, alternative | 117.95 | Board/cooler/64GB card/reader/27W PSU/case/HDMI. Metadata now shows zero stock. Replaces those bare-package items. [Kit](https://www.pishop.us/product/raspberry-pi-5-starter-kit-2gb/) |
| **Kit-based compute including camera/ribbon/BEC/$10 mounting** | **177.39** | Independent bench kit comparison, not mandatory minimum; do not add bare package again. |
| Holybro Micro M10, **with case / IST8310** | 27.99 | Manufacturer variant available; GPS plus compass, supplied cables; mounting/integration additional. [Product](https://holybro.com/products/micro-m10-gps), [variant data](https://holybro.com/products/micro-m10-gps.js) |
| Pocket M2 **ELRS** + RP1 V2 receiver | 90.49 | $71.50 + $18.99; both FCC/LBT variants available, without choosing regulatory variant. Already inside old subtotal. [Pocket data](https://radiomasterrc.com/products/pocket-radio-controller-m2.js), [RP1 data](https://radiomasterrc.com/products/rp1-expresslrs-2-4ghz-nano-receiver.js) |
| FPV Freerider | 5.99 | Developer's current minimum purchase price; already inside old subtotal. [Developer](https://fpv-freerider.itch.io/fpv-freerider) |

Arithmetic: $504.31 + $155.34 + $2.95 + $27.99 = $690.59; or $504.31 + $177.39 + $27.99 = $709.69. The [earlier rebaseline](lifetime-budget-rebaseline.md) still contains unverified tool/wiring/cell allowances and batteries not proven to meet the now-firm endurance requirement. These comparisons do not revalidate that subtotal.

## Controller compatibility is not authorization enforcement

The exact listed FC matches ArduPilot's `TBS_LUCID_H7` direction, with barometer, microSD and UART capacity for receiver, GPS and companion. It has **no built-in compass**. Manufacturer power specifications now say 3–8S and 5V/2A continuous, while ArduPilot's page says 2–6S and 5V/3A: reconcile board revision, manual and supplied hardware before selection; do not infer the Pi can use the FC's peripheral supply. [Manufacturer](https://www.team-blacksheep.com/products/prod%3Alucid_h7), [ArduPilot board](https://ardupilot.org/copter/docs/common-tbs-lucidh7.html)

ArduPilot documents Lua auxiliary arming authorization and protections against missing/stopped scripts. F4 boards do not support scripting, so an F405 saving cannot inherit this proposed route unchanged. H7 capability is useful evidence, not a finished biometric gate. [Scripting](https://ardupilot.org/copter/docs/common-lua-scripts.html), [official example](https://raw.githubusercontent.com/ArduPilot/ardupilot/master/libraries/AP_Scripting/examples/arming-check-batt-temp.lua)

**Source-audit caveat:** current upstream code distinguishes normal pre-arm checks from other arming paths; auxiliary authorization is not demonstrated as an unavoidable security boundary across all of them. Audit the selected release, radio and command paths, configuration privileges, restart/missing-script behavior, freshness and replay prevention before claiming Q8/Q26 enforcement. A companion merely withholding its own arm command is insufficient. [Upstream arming implementation](https://github.com/ArduPilot/ardupilot/blob/master/libraries/AP_Arming/AP_Arming.cpp)

Required architecture remains: deny unauthorized **new** arming, while radio takeover and safe landing already airborne remain independent of renewed biometrics or companion health. Neither this separation nor an equivalent cheaper-controller design has been validated. No bypass settings or implementation are selected here.

## CPU-only compute is a benchmark candidate

Ultralytics reports Pi 5 YOLO26n NCNN inference at **67.03ms**, excluding preprocessing/postprocessing. This supports investigating CPU inference, not claiming complete 2GB face/liveness/tracking performance, arbitrary-subject support, filming concurrency or flight-control latency. Measure the actual workload, memory pressure, thermals and power; model throughput does not establish attack resistance. No accelerator is assumed necessary or silently credited with free performance. [Original benchmark](https://docs.ultralytics.com/guides/raspberry-pi)

The BEC is rated for 9–55V input and 5A continuous output; connector losses, transient behavior and Pi power-detection/peripheral limits still need validation. A separate bench PSU may be avoided only through deliberately verified reuse of the already-budgeted charger's supply and BEC; no free adapter or simultaneous charging is assumed. Case/HDMI kit accessories are optional for flight. [BEC specifications](https://www.progressiverc.com/products/matek-bec12s-pro), [Pi power documentation](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html#power-supply)

## Remaining lifetime obligations — unpriced, not zero

- **Desk hardening:** the coordinating agent's read-only inventory found an Ultra 7 255H, about 31.4GiB RAM, RTX4050 Laptop GPU, HP5MP/IR camera endpoints and microphones. Avoid automatically buying duplicate desk capture devices. Enumeration does not prove IR-frame access, supported acceleration, trusted capture, liveness or the approved Windows recovery integration. Extra sensors/test equipment remain conditional; development and validation effort remains substantial.
- **Navigation:** the priced Micro M10 uses a UART and compass I2C, requires compatible firmware, and adds 16g with case before installation. Connector adaptation, interference-safe placement and calibration remain work. Positioning hardware is not proof of a clear landing patch or reliable reserve prediction. [Holybro specifications](https://holybro.com/products/micro-m10-gps)
- **Handheld/audio:** microphone, offline voice verification/STT/anti-spoof processing, battery, charging, enclosure and interface remain uncosted. The Pocket is not a demonstrated speech computer. Reusing a suitable existing smartphone could reduce purchases, but ownership/model and permission to use it are unknown; it is not a selected solution. Phone reuse may require software porting and additional interface integration, so lower purchase cost would not by itself establish faster development.
- **Radio/ground:** retain radio cells, charging/data cables, flight-controller log storage, tools, leads, safe charging provisions and repair/consumable allowances. The old $66 tool and $15 radio-cell allocations are estimates, not a verified complete basket. No helper fee is assumed under the solo-novice decision.
- **Video/HUD:** ExpressLRS supports Pocket Backpack telemetry, but its documented kilobytes-per-second MAVLink rates are not a live-video transport. A separate video path/display/encoding workload may add hardware and power; exact live-view expectations from Gemini remain unratified. Do not count the radio twice or pretend telemetry includes video. [Backpack support](https://www.expresslrs.org/hardware/backpack/esp-backpack/), [MAVLink bandwidth](https://www.expresslrs.org/software/mavlink/)
- **Night, filming, avoidance and delivery:** NoIR needs illumination to see in darkness; visible path lighting is another requirement. Camera-angle actuation/stabilization, mounts, avoidance sensing and field coverage, secure payload retention/release and authorized-recipient verification remain unpriced. A bare camera, one rangefinder or cheap servo does not establish these capabilities. [Camera manufacturer](https://www.raspberrypi.com/products/camera-module-3/), [ArduPilot avoidance](https://ardupilot.org/copter/docs/common-object-avoidance-landing-page.html)

**Next genuine input:** ask whether evaluating an existing smartphone as the offline handheld is acceptable, without assuming ownership or weakening the security/command requirements; obtain model/capability information only if accepted. Separately clarify whether live video/HUD is required. Neither answer alone establishes $600 feasibility; maintain all approved capabilities and raise evidenced shortfalls explicitly.
