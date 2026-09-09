# Milestone 1 — Bill of Materials (owns-nothing first build)

> **Consolidation note — 2026-08-30**
> Superseded hardware/cost baseline, not a purchase list. See the provisional lifetime-budget rebaseline; compatibility and endurance remain unresolved.
> Source: `research/milestone-1-bom`, commit `1afc6e10e2f92dd5f62f75f2db3aeb72308ee3af`, file `docs/research/milestone-1-bom.md`.
> Original report text is retained below, with line endings normalized; this consolidation did not revalidate its external claims. Current decisions: [Lock the milestone ladder](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md).
> Newer budget evidence: [lifetime budget rebaseline](lifetime-budget-rebaseline.md).

**Date of price research: 2026-08-06.** Prices in USD, US retail. Confidence: **H** = read off retailer/manufacturer page today; **M** = reported in search results / recent listing; **L** = estimated from typical market price, could not load the page.

Locked upstream decisions honored: ArduPilot on a supported F405-class stack, 2.4 GHz ELRS, line-of-sight (no FPV gear), 250 g Pi-5 payload reservation, total ceiling $500–600 including the ~$88–112 already committed to the RadioMaster Pocket + sim.

## Airframe sizing (why 7-inch, why these motors)

Payload reservation drives everything: 250 g (Pi 5 + AI HAT + camera) plus a 5 V/5 A BEC tap plus ~90×60 mm of flat deck. A 5-inch freestyle frame has neither the deck space nor the efficient disc area; a 7-inch deadcat long-range frame (320 mm motor-to-motor) has both and is the cheapest class that does.

**Thrust/weight check** (EMAX ECO II 2807 1300KV, 6S, 7×4×3 props):

| Mass item | grams |
|---|---|
| Frame (TBS Source One V5.1 7" DC, verified net weight) | 144 |
| Motors 4 × 47.5 g (verified) | 190 |
| Stack + RX + props + wiring/straps/hardware (est.) | ~170 |
| **Dry weight** | **~505** |
| Battery CNHL 6S 3300 mAh (typ. ~505 g, est.) | ~505 |
| **AUW, no payload** | **~1010** |
| Pi 5 + HAT + camera + mount reservation | 250 |
| **AUW, full payload** | **~1260** |

EMAX's spec sheet for the ECO II 2807 1300KV claims ~1310 W max on 6S and roughly 1.8–1.9 kg peak thrust per motor with a 7" tri-blade (manufacturer figure, not independently re-verified — confidence M). Even derated conservatively to 1500 g/motor: 4 × 1500 = 6000 g total thrust → **TWR ≈ 4.7 : 1 at full payload, ≈ 5.9 : 1 empty; hover throttle ≈ 21 % loaded.** Comfortably above the 2 : 1 minimum ArduPilot wants for stable loiter and well past the payload requirement. ([EMAX ECO II 2807 page](https://shop.emax-usa.com/products/eco-ii-2807-brushless-motor-1300kv-1500kv-1700kv), [RMRC listing with weight/price](https://www.readymaderc.com/products/details/emax-eco-ii-2807-brushless-motor-1300kv))

**ArduPilot support (verified 2026-08-06):** the SpeedyBee F405 V3/V4 stack is on ArduPilot's supported-autopilots list ([ardupilot.org supported hardware](https://ardupilot.org/copter/docs/common-autopilots.html) — "SpeedyBee F4 V3/V4", target `SpeedyBeeF405v3`). The V4 is discontinued; the **V3 50A stack is still sold new (~$65–70)** and is the recommendation. The newer F405 V5 is ambiguous — SpeedyBee's own page lists Betaflight only ([speedybee.com V5](https://www.speedybee.com/speedybee-f405-v5-55a-stack/)) while ArduPilot's list shows a "SpeedyBee F4 V5" entry; buy the V3 and avoid the question. Fallback if V3 stock dries up: Matek H743-SLIM + separate 4-in-1 ESC (better board, ~$120+ — busts the budget unless something else gives).

## The BOM

Sec-hand = secondhand-viable. **LiPos: always NO.**

| # | Item | Concrete example | New price | Sec-hand? | Notes |
|---|---|---|---|---|---|
| 1 | Frame, 7" deadcat | [TBS Source One V5.1 7" DC](https://www.progressiverc.com/products/tbs-source-one-v5-7-inch-dc-quad-frame) | $42.99 (H) | **Yes** — carbon is easy to inspect for cracks/delamination | 320 mm, 144 g, open-source design, cheap spare arms ($15.95/set at [TBS](https://www.team-blacksheep.com/products/product:6979)). Sold out at ProgressiveRC on research date; also carried by [GetFPV](https://www.getfpv.com/tbs-source-one-v5-7-long-range-frame-deadcat.html) and [WREKD](https://wrekd.com/products/tbs-source-one-v5-7-inch-frame-kit) — check stock. Long top/bottom plates give the ~90×60 mm flat deck for the Pi. |
| 2 | Motors ×4, 2807 1300KV | [EMAX ECO II 2807 1300KV](https://www.readymaderc.com/products/details/emax-eco-ii-2807-brushless-motor-1300kv) | $77.96 (4 × $19.49, H) | **Inspect** — spin for grinding, check bent shaft/magnet rub; crashed motors hide damage | Sized for 6S + 7" prop with big thrust margin for the 250 g payload (calc above). Amazon 4-packs run ~$60–70 (M) ([listing](https://www.amazon.com/1300KV-1500KV-1700KV-Brushless-Quadcopter/dp/B0CTT1XQ6K)). 1300KV out of stock at EMAX USA direct on research date. |
| 3 | FC + ESC stack | [SpeedyBee F405 V3 BLS 50A 30×30](https://www.speedybee.com/speedybee-f405-v3-bls-50a-30x30-fc-esc-stack/) | $69.99 (M; $65.25 seen in stock) | Risky — ESCs die invisibly; only from a trusted seller | ArduPilot-supported target `SpeedyBeeF405v3` (verified above). 3–6S, 50 A — plenty for ECO II 2807s at 6S cruise; full-throttle punches are brief. Flash ArduCopter ≥4.5 via SpeedyBee/STM32 DFU. |
| 4 | Props, 4 sets | [HQProp 7×4×3 (2CW+2CCW)](https://www.hqprop.com/hq-durable-prop-7x4x3-light-grey-2cw2ccw-poly-carbonate-popo-p0133.html) | $19.96 (4 × $4.99, H; $3.59/set direct) | No (pointless — they're consumables) | Polycarbonate, crash-friendly. Four sets = first month of learning. Buy more with any later order. |
| 5 | ELRS receiver | [RadioMaster RP1 V2 2.4 GHz](https://radiomasterrc.com/products/rp1-expresslrs-2-4ghz-nano-receiver) | $18.99 (H) | Yes, but at $19 new not worth it | Pairs with the already-budgeted RadioMaster Pocket ELRS. CRSF to a spare UART on the FC. Get the FCC variant (US). |
| 6 | LiPo ×2, 6S 3300 mAh 40C | [CNHL 3300 mAh 22.2 V 6S 40C XT60](https://chinahobbyline.com/products/cnhl-3300mah-22-2v-6s-40c-lipo-battery-with-xt60-plug) | ~$112 (2 × ~$56, **L** — page price didn't load; CNHL's 6S line runs $29–53 at 1200–1550 mAh, 3300 typ. $52–60) | **NO — always new** | 6S matches 1300KV motors. 3300 mAh @ 40C = 132 A continuous — far above the ~40–60 A this quad draws loaded. Capacity chosen for payload duty: ~8–12 min mixed flying loaded, more empty. Two packs = practice cadence while one charges. |
| 7 | Charger | [ToolkitRC M6 150 W DC](https://oscarliang.com/toolkitrc-m6-battery-charger/) | $29.99 (M) + PSU | Charger yes; PSU yes (any 19–20 V laptop brick) | DC-only: feed it a used/spare laptop brick (~$0–15) — 100 W in charges a 3300 6S at ~1C in ~1 h. Safe: balance charging, cell monitoring, storage mode. All-in-one alternative: [ISDT 608AC](https://isdtshop.com/products/isdt-608ac) ~$55–65 (M) if no brick available. Avoid IMAX B6 clones. |
| 8 | Wiring / connectors / spares | XT60 pigtail ×2, 14AWG silicone wire, heatshrink assortment, battery straps ×3, M3 hardware/standoffs, zip ties, foam battery pad | ~$25 (M, aggregate Amazon/LFS pricing) | Straps yes; connectors no (crimp/solder fatigue) | Stack ships with XT60 pigtail + 1500 µF cap; this is the crash-spares margin. |
| 9 | Payload BEC (reserved, deferred) | Matek/Hobbywing-class 5 V ⎓ 5 A UBEC | ($10–15, L — **not in M1 total**) | No | Milestone-2 item when the Pi mounts; listed so the 25 W tap is planned, wired from the battery lead, not the FC's 5 V rail. |
| **T1** | Soldering iron | [Pinecil V2](https://pine64.com/product/pinecil-smart-mini-portable-soldering-iron/) | $25.99 (H) | Yes | Ships with a tip. Needs a 65 W USB-C PD brick — most people own one; add ~$15 if not. Cheapest-viable: any 60 W adjustable AC iron kit ~$15. |
| T2 | Solder | 63/37 leaded rosin-core, 0.8 mm, ~100 g | ~$8 (M) | No | Leaded is far easier for a first-timer than lead-free. |
| T3 | Multimeter | AstroAI DM130 class | ~$13 (M) | Yes | Continuity beeper is the tool that prevents the fire. |
| T4 | Hex drivers | 1.5/2.0/2.5/3.0 mm set + M5 prop wrench (e.g. RDQ/SpeedyBee tool kit) | ~$15 (M) | Yes | Ball-end 2.0 mm does 90 % of the work. |
| T5 | Smoke stopper | [XT60 smoke stopper w/ buzzer](https://www.amazon.com/HobbyFly-Shortsaver-smoke-stopper-buzzer/dp/B097H12XRM) | ~$12.99 (M) | Yes | Non-negotiable for a first build: first power-up through this, not straight to the pack. |
| T6 | LiPo-safe bag | [CNHL LiPo safe bag](https://chinahobbyline.com/products/cnhl-lipo-safe-fireproof-explosionproof-charge-storage-bag) | ~$12.99 (M) | Yes (inspect lining) | Charge and store in it, always. |

## Totals

| | Typical (new) | Cheapest-viable |
|---|---|---|
| Quad (1–8) | **$418** | **$339** (used frame $28, Amazon motor 4-pack $62, stack on sale $65, 3 prop sets $15, RX $19, LiPos $100 on sale — still new, M6 + free brick $30, wiring $15, +smoke items below) |
| Tools (T1–T6) | **$88** | **$66** (AC iron kit $15, solder $6, meter $12, hex $10, smoke stopper $13, bag $10) |
| **Quad + tools** | **$506** | **$405** |
| Already committed (Pocket + cells + sim) | $88–112 | $88–112 |
| **Project total** | **$594–618** | **$493–517** |

**Budget verdict:** cheapest-viable holds the ceiling with ~$85 to spare. Typical-new lands at $594–618 — **it busts the $600 ceiling by up to ~$18 at the top of the committed range.** Named cut, in order: (1) buy motors as the ~$62 Amazon 4-pack instead of à-la-carte (−$16), (2) drop to 3 prop sets (−$5). Those two get typical-new to ≈$585–597 ≤ ceiling. Do **not** cut the smoke stopper, the LiPo bag, or battery quality.

## Secondhand guidance

- **Yes:** frames (inspect carbon for cracks/fuzzing at arm roots), radios/transmitters, chargers, all hand tools, laptop PSU for the charger.
- **Inspect carefully:** motors (free smooth spin, no shaft play, no magnet rub, unbent bell), receivers (fine if it binds).
- **Risky:** FC/ESC stacks — MOSFET and regulator damage is invisible; only with return rights.
- **Never:** LiPo batteries. Unknown history = fire risk and dead cells. Always new. (Also skip used props.)

## Optional later: cheap FPV

Not in this build (line-of-sight mandate). Adding budget analog FPV later: camera + 25–400 mW VTX combo (e.g. Caddx Ant + generic VTX) ≈ **$30–40** on the quad, plus box goggles (e.g. Eachine EV800D-class) ≈ **$70–100**. Budget ~$110–140 total; the frame has room, the stack has a spare UART and 9 V pad.

## What I could not verify (2026-08-06)

- **CNHL 6S 3300 mAh street price** — product page exists but price didn't render; ~$56/pack is an estimate from CNHL's adjacent 6S pricing. Biggest single price risk (±$20 across two packs).
- **EMAX thrust table** — EMAX/GetFPV/Tyto pages wouldn't serve the chart; the ~1.8 kg/motor figure is the widely reproduced manufacturer spec. The TWR math above already derates it 20 %.
- **Source One V5.1 7" stock** — sold out at ProgressiveRC on research date; multiple other carriers listed, none stock-verified. Frame availability is the schedule risk; substitute any 7" deadcat with a long top deck (e.g. iFlight Chimera7-style clones, ~$50–60) if TBS stock is dry.
- **SpeedyBee F405 V3 live price** — $69.99/$65.25 from search snippets, not a page fetch.

## Sources

- ArduPilot supported autopilots: https://ardupilot.org/copter/docs/common-autopilots.html
- SpeedyBee F405 V3 stack: https://www.speedybee.com/speedybee-f405-v3-bls-50a-30x30-fc-esc-stack/
- SpeedyBee F405 V5 (Betaflight-only note): https://www.speedybee.com/speedybee-f405-v5-55a-stack/
- EMAX ECO II 2807: https://shop.emax-usa.com/products/eco-ii-2807-brushless-motor-1300kv-1500kv-1700kv , https://www.readymaderc.com/products/details/emax-eco-ii-2807-brushless-motor-1300kv
- TBS Source One V5.1 7" DC: https://www.progressiverc.com/products/tbs-source-one-v5-7-inch-dc-quad-frame , https://www.team-blacksheep.com/products/product:6979
- HQProp 7×4×3: https://www.hqprop.com/hq-durable-prop-7x4x3-light-grey-2cw2ccw-poly-carbonate-popo-p0133.html , https://wrekd.com/products/hq-prop-durable-7x4x3-tri-blade-7-prop-4-pack-grey-1
- RadioMaster RP1 V2: https://radiomasterrc.com/products/rp1-expresslrs-2-4ghz-nano-receiver
- CNHL 6S 3300 40C: https://chinahobbyline.com/products/cnhl-3300mah-22-2v-6s-40c-lipo-battery-with-xt60-plug
- ToolkitRC M6: https://oscarliang.com/toolkitrc-m6-battery-charger/ ; ISDT 608AC: https://isdtshop.com/products/isdt-608ac
- Pinecil V2: https://pine64.com/product/pinecil-smart-mini-portable-soldering-iron/
- Smoke stopper / LiPo bag: https://www.amazon.com/HobbyFly-Shortsaver-smoke-stopper-buzzer/dp/B097H12XRM , https://chinahobbyline.com/products/cnhl-lipo-safe-fireproof-explosionproof-charge-storage-bag
