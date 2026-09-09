# Lifetime budget rebaseline — provisional, not a purchase list

## Approved complete-build budget after Q53 — 2026-08-30

The user now approves applying the **$600 goal and conditional $800 absolute maximum** to the complete planned project, including aircraft, radio, charger, tools, initial spares and all requested later capabilities. Future repairs and worn-out replacements are budgeted separately. This resolves the upkeep-boundary question in the earlier note below; it does not make upkeep free or permit moving unfinished features outside the build budget. Necessary development/build costs and recurring charges must remain visible; no fee or service is approved.

Any proposal above $600 still needs a specific, worthwhile tradeoff approved by the user; $800 is not the default spend. No complete fit, purchase-ready package or performance validation is established. Historical prices/findings below are retained, not revalidated by this decision. See the [latest ticket comments](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

## Budget clarification during Q53 — 2026-08-30

The user clarifies **$600 as the goal and $800 as the absolute maximum**, with spending above $600 considered only when specific benefits justify the additional cost and the user approves the tradeoff. The earlier $600-ceiling wording below is historical; $800 is not the default budget, a selected package or purchase permission. Prior full-project coverage includes tools and later capabilities; separating future upkeep remains an unanswered Q53 proposal. No capability is removed and no complete fit at either amount is established. Prices, availability and compatibility have not been rechecked by this decision update. See the [latest ticket comments](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

> **Consolidation note — 2026-08-30**
> Provisional budget research, not an approved build or shopping list. A complete fit within the working lifetime ceiling has not been demonstrated.
> Source: uncommitted `docs/research/lifetime-budget-rebaseline.md` in `research/milestone-1-bom`, based on `1afc6e10e2f92dd5f62f75f2db3aeb72308ee3af`. The base commit does not contain this report. Source-file SHA-256: `545567b058cd259fd672a9b0796d4a04688ed2be10851481eb1bc9a58d39c3db`.
> Original report text is retained below, with line endings normalized; this consolidation did not revalidate its external claims. Current decisions: [Lock the milestone ladder](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md).

Date checked: **2026-08-30**. Ticket: **10, milestone ladder**. USD sticker prices; US availability checked where possible. This note supplements the earlier research; it does not amend the ticket, map, or accepted specifications.

## Requirements and decision status

The user approved reopening hardware around **$600 as the working lifetime project ceiling**. No overrun is authorized. Preserve the learning-first, self-built 7-inch aircraft, two **new** LiPos, radio/manual override, offline operation, and future onboard vision, voice, follow/autonomy and handheld interaction. The hardened desk phase still requires liveness checks, encrypted biometric storage, polished enrollment and replay resistance. Authorization-dependent aspirations remain requirements subject to their existing safety/legal gates; neither deferring purchases nor removing an accelerator deletes capabilities.

**Verdict: a complete $600 fit is not established.** An optimistic, partly estimated aircraft/ground-equipment candidate is **$504.31**. Adding the kit-based CPU-only compute candidate gives **$681.70**, before several required lifetime costs. Even its incomplete bare-board counterpart reaches **$618.75**. These are conditional planning subtotals, not proven working builds, universal minimum prices, or proof that every redesign must exceed $600.

Evidence labels: **V** = current product/variant price read; **C** = conditional stock, compatibility or performance; **E** = allowance, not a verified purchasable row. A product being listed or in stock does not validate it in this aircraft.

## Aircraft and ground equipment: lowest candidate developed in this timebox

| Item | USD | Evidence and limitation |
|---|---:|---|
| New TBS Source One V6 7-inch frame | 35.95 | V: manufacturer lists in stock; 173 g, 313 mm, 30.5/20 mm stack mounts. Payload deck fit remains a physical-layout check. [TBS](https://www.team-blacksheep.com/products/prod%3Asource1v6) |
| Four iFlight NIDICI 2807, 1300KV motors | 47.96 | V/C: $11.99 each, in stock; 60.5 g each including wire, 19×19 mm M3 mount. Page specifies 24 V, not explicitly fully charged 6S at 25.2 V; confirm before selection. [iFlight](https://shop.iflight.com/NIDICI-2807-FPV-Motor-Pro2314) |
| TBS Lucid H7 + 60A 4-in-1 stack | 109.95 | V/C: advertised price; main page mixes in-stock and preorder language. Confirm exact available revision. [TBS](https://www.team-blacksheep.com/products/prod%3Alucid_h7_stack) |
| Three sets of 7-inch props | 15.00 | E: carried planning allowance. Exact motor/prop pairing and live delivered price unresolved. [HQProp example](https://www.hqprop.com/hq-durable-prop-7x4x3-light-grey-2cw2ccw-poly-carbonate-popo-p0133.html) |
| RadioMaster RP1 ELRS receiver | 18.99 | Listed price carried from earlier research; exact current variant/stock must be rechecked. [RadioMaster](https://radiomasterrc.com/products/rp1-expresslrs-2-4ghz-nano-receiver) |
| Two new CNHL MiniStar 1500mAh 6S 120C LiPos | 41.98 | V/C: US two-pack variant available at $41.98; suitability/endurance not established. [CNHL](https://chinahobbyline.com/products/cnhl-ministar-series-1500mah-22-2v-6s-120c-lipo-battery-with-xt60-plug) |
| ToolkitRC M6AC, built-in mains PSU | 60.99 | V/C: upper end of official $59.99–60.99 range; includes AC cable. Exact US checkout/lead requirements still need confirmation. [ToolkitRC](https://www.toolkitrc.com/product/m6ac/) |
| Wiring, connectors, straps and hardware | 15.00 | E: aggregate allowance; verify supplied stack parts before avoiding duplicates. |
| AC iron / solder / meter / drivers / smoke stopper / LiPo bag | 66.00 | E: $15 + $6 + $12 + $10 + $13 + $10. No assumption that these are already owned; no verified complete tool basket. |
| Pocket ELRS radio | 71.50 | V: selected ELRS variant; no separate external transmitter presumed necessary. [RadioMaster](https://radiomasterrc.com/products/pocket-radio-controller-m2) |
| Two suitable radio cells | 15.00 | E: radio batteries are not included; verify genuine cells and charging supply/cable. |
| Previously selected simulator | 5.99 | Carried from ticket 08, not repriced here. |
| **Partial aircraft + ground-equipment subtotal** | **504.31** | **Contains estimates and compatibility gates; excludes compute and costs below.** |

The charger removes the old unsupported assumption of a free laptop PSU. It supports 1–6S chemistry selection, balancing and discharge/storage workflows; follow its manual, supervised charging, sound packs and a suitable noncombustible charging location. A bag is not a guarantee of containing a battery fire. Do not cut safety equipment, substitute unknown chargers or buy used LiPos to force the total down. [M6AC specifications](https://www.toolkitrc.com/m6ac/), [manual](https://download.toolkitrc.com/wp-content/uploads/2024/12/M6AC-Manual-V1.1.pdf).

### What the savings change

The motor candidate saves **$30** against four $19.49 EMAX motors, but not against a verified equivalent propulsion system: exact prop thrust, loaded current, cooling and full-charge voltage compatibility remain unverified. EMAX's $19.49 1300KV variant was unavailable; its 1500KV variant was available, but changing winding is not a free substitution. [EMAX variants](https://shop.emax-usa.com/products/eco-ii-2807-brushless-motor-1300kv-1500kv-1700kv.js).

The 1500mAh packs cost **$58.02 less** than the old estimated $100 pair. Each has nominal energy **33.3 Wh**, versus **73.26 Wh** for 3300mAh: approximately half the energy, with lower mass (246 g manufacturer claim). That can materially shorten sorties. C-ratings are manufacturer claims, not measured aircraft current margins. Establish a minimum loaded sortie duration, reserve, voltage sag and temperature limits before accepting the capacity reduction.

A current US-stock **2000mAh 6S 100C pair is $77.98**, adding $36 and 33% nominal energy over the 1500 pair; loaded endurance still needs testing. The cheaper $32.99 2200mAh/40C pack was EU-stock only, not an assured US saving. [2000mAh](https://chinahobbyline.com/products/cnhl-black-series-2000mah-22-2v-6s-100c-lipo-battery-with-xt60-plug), [2200mAh](https://chinahobbyline.com/products/cnhl-black-series-2200mah-6s-22-2v-40c-lipo-battery-with-xt60-plug).

Discard the earlier unverified thrust-to-weight and flight-time promises. Hover throttle is not simply the reciprocal of peak thrust-to-weight. Reweigh the complete aircraft, retain the 250 g payload reservation until demonstrated unnecessary, verify deck fit/centre of gravity, and qualify propulsion with the selected pack and representative payload.

## F405 versus H7: savings are not feature equivalence

- **H7 baseline:** ArduPilot explicitly supports Lucid H7, including barometer and UARTs for receiver, GPS and companion link; exact target is `TBS_LUCID_H7`. Its peripheral BEC is not the Pi's supply. Stable firmware availability does not validate our wiring or arming policy. [Board documentation](https://ardupilot.org/copter/docs/common-tbs-lucidh7.html), [stable target](https://firmware.ardupilot.org/Copter/stable/TBS_LUCID_H7/).
- **Supported F405 with barometer:** SpeedyBee V3/V4 are supported under `speedybeef4v3` / `speedybeef4v4`, not the older research's guessed target spelling. However, current RDQ V4 $86.49 and V5 $119.99 listings were sold out; manufacturer V5 is discontinued. Do not count this apparent $23.46 V4 saving as available procurement. [ArduPilot](https://ardupilot.org/copter/docs/common-speedybeef4-v3.html), [RDQ listing](https://www.racedayquads.com/collections/all-stacks-combos-aios/connector_bluetooth%2Bmanufacturer_speedybee), [manufacturer V5](https://www.speedybee.com/speedybee-f405-v5-55a-stack/).
- **Available F405 is not automatically suitable:** Diatone's ICM42688P F405 MK2 V2 + F55 BLS variant is $85.98/available, but the supported MK2 documentation warns of no barometer. Adding altitude sensing, verifying the exact revision and retaining future safety features erodes the nominal saving. Its advertised low headline is not the complete stack price. [Variant data](https://www.diatone.us/products/mamba-f405mk2-v2-fc.js), [ArduPilot warning](https://ardupilot.org/copter/docs/common-mamba405-mk2.html).

ArduPilot explicitly says scripting is unavailable on F4 autopilots. A documented Lua auxiliary-arming-authorization implementation therefore favors H7. **Q8 confirmed by the user on 2026-08-30:** once biometrics are enabled, all new arming requests, including the radio switch, require face-and-voice authorization; emergency takeover and safe landing remain independent. The requirement is settled, not its implementation: a cheaper board must demonstrate an equivalent gate rather than permit radio bypass. [Lua requirements](https://ardupilot.org/copter/docs/common-lua-scripts.html), [auxiliary authorization example](https://raw.githubusercontent.com/ArduPilot/ardupilot/master/libraries/AP_Scripting/examples/arming-check-batt-temp.lua).

## Reopened compute candidates

| Kit-based CPU-only package | USD |
|---|---:|
| [Pi 5 2GB starter kit](https://www.pishop.us/product/raspberry-pi-5-starter-kit-2gb/) — independent bench PSU and kit accessories | 117.95 |
| [Camera Module 3 NoIR](https://www.pishop.us/product/raspberry-pi-camera-module-3-noir/) | 27.50 |
| [Correct standard-to-mini CSI ribbon](https://www.pishop.us/product/raspberry-pi-camera-cable-standard-mini-200mm-v2/) | 2.95 |
| [Matek BEC12S-PRO](https://www.progressiverc.com/products/matek-bec12s-pro) | 18.99 |
| Mount/wire allowance, E | 10.00 |
| **Row-summed compute subtotal** | **177.39** |

This kit is a costed convenience candidate, **not a mandatory minimum**. A [bare Pi 5 2GB at $65](https://www.pishop.us/product/raspberry-pi-5-2gb/) plus the same camera, ribbon and BEC totals **$114.44**, before storage/reader, cooling, mounts, power wiring and bench power. A separately budgeted charger's adjustable supply may feed the BEC only after voltage, connector and power-mode validation; shared use is not free simultaneous charging. Do not double-count an independent Pi PSU if that reuse is deliberately selected.

Three directions remain open:

1. **H7 + CPU-only Pi:** $504.31 + $177.39 = **$681.70** partial; benchmark before hardware commitment. The bare incomplete version is **$618.75**.
2. **H7 + 13-TOPS acceleration if required:** an in-stock [AI HAT+ 13 TOPS at $76.95](https://www.pishop.us/product/raspberry-pi-ai-hat-13-tops/) makes compute **$254.34**, combined **$758.65** partial. Confirm model/operator compatibility; 13 TOPS is not the old 26-TOPS configuration.
3. **Conditional F405/shared accessories/inspected secondhand:** any cheaper controller must meet the confirmed Q8 all-arming authorization boundary and measurable workload/endurance requirements. No verified complete configuration or guaranteed used-price reduction exists. Frames, hand tools and tested chargers may be secondhand candidates; no unknown-history LiPos, assumed free PSU or untested electronics savings are included above.

CPU-only retains the requested capabilities as targets, not demonstrated performance. Ultralytics reports Pi 5 YOLO26n NCNN inference at 67.03 ms for 640-pixel input; preprocessing/postprocessing are excluded and this is not proof of the 2GB onboard workload. Benchmark the actual phase-dependent combination of detection/tracking, event-driven face/liveness checks, logging and control I/O for memory, thermals and latency offline. Voice verification, speech decoding and audio anti-spoofing remain on the PC/handheld and require a separate workload test; this rebaseline does not move voice processing onto the drone. Accelerator-specific examples are not end-to-end project proof. [Ultralytics](https://docs.ultralytics.com/guides/raspberry-pi), [Hailo applications](https://github.com/hailo-ai/hailo-apps).

## Unpriced lifetime obligations and next gates

GPS/compass for future positioning/RTL, handheld hardware and audio, avoidance/gimbal hardware, any additional hardened-authentication sensors or illumination, applicable authorization/compliance costs, taxes/shipping/import charges, consumable packs/props and repairs remain **unpriced, not zero**. Confirm tool-kit completeness, charging leads, radio charging cable/supply and the actual storage/cooling contents before a purchase-ready subtotal. Define a lifetime usage horizon; two packs and three prop sets do not fund indefinite operation.

Pocket ELRS is on the official supported Backpack table; internal-radio MAVLink requires Backpack 1.5 or newer. Keep the radio and bench-test the configured telemetry/command path rather than budgeting a redundant external transmitter by assumption. Offline range, interference and failure handling remain tests. [Backpack support](https://www.expresslrs.org/hardware/backpack/esp-backpack/), [MAVLink requirements](https://www.expresslrs.org/software/mavlink/).

Enforce the confirmed Q8 arming boundary and resolve minimum loaded sortie and concurrent compute acceptance criteria before locking parts. Then replace allowances with a delivered-price basket and include all lifetime obligations. Until that succeeds, the $600 ceiling stays binding and purchases stay blocked; no capability has been removed to manufacture a fit.
