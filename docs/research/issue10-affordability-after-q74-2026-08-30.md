# Issue 10 — affordability after Q74

Researched **2026-08-30**, main checkout, branch `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. This new report is uncommitted; the base commit does not contain it. Research only: no purchase, contact, account action, upload, installation, capture, powered operation, code change or commit.

## Result

**The bounded pass finds a meaningful cheaper tool route, but still no responsibly supported complete $900 build.** Keeping the F1001100KV/Gemfan7040/6S10000 propulsion basis, buying one flight pack, comparing the MicoAir45A AIO and replacing the earlier tool kit plus separate multimeter produces **$1,034.65 in named parts**. The full estimate is **$1,679.28** with explicitly itemized integration, delivery and uncertainty allowances: **$779.28 above the approved ceiling**. This is a costed comparison, not a qualified shopping list, minimum possible cost or proposal to raise the budget.

A cheaper D200/TF-Luna sensing comparison reduces named parts to **$974.65** and the allowance scenario to **$1,624.28**, but it changes sensing range, update rate and installation mass. It is **not counted as a capability-equivalent complete basket** until the perception and landing envelope is justified on paper. Neither deleting required sensing nor assuming an unspecified replacement solves affordability is accepted.

The current aircraft also has a documented battery-connector/current qualification problem. That is **P02 paper engineering**, not something to defer until a flight experiment. An affordable, electrically coherent selection remains missing. Actual endurance, physical fit and performance are separate future validation.

## Approved boundary and bounded search

Q71 approves **250g cargo including packaging**, with holder mass separate. Q72 approves evaluating native iPhone personal signing renewed through Windows at least weekly, using private hosted builds within free quotas. Q73/Q74 approve the M1 and fully equipped endurance acceptance packages. **Q74 does not require purchasing two flight packs.** One purchased pack is therefore a legitimate BOM comparison without weakening the repetition requirement. Battery chemistry and exact parts are still unselected.

Preserved: self-built seven-inch aircraft; twenty useful minutes with a separate validated reserve; onboard face/biometric enforcement; existing iPhone17Pro/USB-C EarPods with intentionally enabled locked-pocket offline voice and inspection video; independent emergency radio; selected-subject autonomy/navigation/avoidance; night lighting; guest controls; removable secure holder preventing ordinary manual cargo removal, with recipient-face-verified landed/motors-stopped release and disarmed physical collection. No onboard microphone, goggles, second video system, Mac or paid Apple membership is added.

The pass investigated three substantial routes: one-pack/AIO consolidation; a complete soldering/meter bundle instead of individually duplicated tools; and a cheaper named scanner/rangefinder pair. It did not chase minor coupons, assume wholesale eligibility, take headline prices from the wrong radio variant, or treat unquoted secondhand parts as available. The prior exact propulsion remains the comparison basis; an inexpensive motor without matched useful-load/current data cannot simply inherit its endurance estimate.

## Earlier arithmetic reconciled

There was no arithmetic contradiction between the prior report's **$1,097.15** parts figure and its **$1,721.63** full scenario:

| Operation | Running amount |
|---|---:|
| Prior 37 named rows | $1,268.14 |
| Remove second $95.99 flight pack | $1,172.15 |
| Replace $149.99 stack with $74.99 AIO | $1,097.15 |
| Prior optimistic, unquoted $9 tool substitution | $1,088.15 |
| Add $10 mounting adapter and $246.51 other integration allowances | $1,344.66 |
| Add $75 shipping scenario | $1,419.66 |
| Add illustrative 10% tax, rounded upward to cents | $1,561.63 |
| Add $100 initial rework and $60 conditional compliance provision | **$1,721.63** |

The new comparison below replaces the speculative $9 tool saving with a different named bundle and a visible missing-driver allowance. It does not subtract either saving twice. The source is the [prior BOM](issue10-bom-closure-options-2026-08-30.md).

## New evidence that changes the cost comparison

**Tool bundle:** Plusivo's exact **V2 kit with digital multimeter, 60W/110V US-plug variant, reference0721248989277**, is advertised at **$28.99**. It includes the iron, tips, stand, meter/probes, cutter, stripper, tweezers, solder/paste/wick, small practice PCB and limited wire/tape/heat-shrink. This replaces the $69.99 NewBeeDrone kit and $21.50 separate meter, saving **$62.50 before missing tools**. Add **$15** for suitable metric hex drivers and a prop-nut wrench; the supplied small screwdrivers are not presumed adequate. Retain separate larger wiring/insulation/spares and workbench provisions. The manufacturer points to Amazon for purchase; a reliable live checkout offer was not extracted, so this is a manufacturer-advertised price and availability statement, not a delivered quote. The exact mains variant must match the actual supply privately before purchase. Nominal60W does not prove a novice can make acceptable large-wire joints; practice/inspection remains required. Do not use the bundled meter as an inline full-propulsion ammeter or rely on marketing safety-category claims for mains work. [Manufacturer kit and contents](https://www.plusivo.com/soldering-iron-kit-2/63-plusivo-soldering-iron-kit-with-digital-multimeter-v2-110-v-plug-type-us-.html), [manufacturer-linked sales listing](https://www.amazon.com/Soldering-Iron-Kit-Temperature-Desoldering/dp/B07Q2B4ZY9/).

**Scanner comparison:** Waveshare D200/LD14P kit is **$54.99**, with public seller metadata reporting in stock. Its listed scanner mass is **101g**, versus45g for D500; power is at most1.5W, nominal range0.1–8m, scan rate6Hz by default/2–8Hz adjustable and UART230400. Manufacturer/supplier documentation gives black-surface accuracy only through6m and an80klux internal sunlight test, not a general outdoor detection guarantee. The $41 saving brings greater mounting/occlusion burden and slower scans. At2m/s, one6Hz revolution spans roughly0.33m of motion before processing/braking delays; this is an engineering illustration, not a safe clearance. The same one-plane blind zones remain. [D200 product](https://www.waveshare.com/d200-lidar-kit.htm), [D200 specifications](https://www.waveshare.com/wiki/D200_LiDAR_Kit).

**Downward ranger comparison:** TF-Luna is **$30.99**, seller metadata in stock, less than5g and at most0.35W; it supports3.3V-level UART/I2C on a3.7–5.2V supply. Listed range is8m on90% targets but only **2.5m on10% targets**, versus the prior TFmini-S's7m dark-target listing. That $19 saving does not establish ground detection from the approved upper flight height or classification of safe terrain. Its2° field of view is a single point. A lower-range landing phase would need an explicit sensor-transition/confidence/refusal design; no height or capability reduction is adopted. [TF-Luna product/specifications](https://www.waveshare.com/tf-luna-lidar-range-sensor.htm).

The Pocket radio's cheaper $59.99 manufacturer variant is **CC2500**, not ELRS; the checked ELRS variants remain **$71.50**. No false radio saving is credited. Nor does a bare iron or a wholesale-only kit replace a fully accounted retail toolkit. [Exact Pocket variants](https://radiomasterrc.com/products/pocket-radio-controller-m2), [PINECIL contents](https://pine64.com/product/pinecil-smart-mini-portable-soldering-iron/), [NewBeeDrone retail kit](https://newbeedrone.com/collections/newbeedrone/products/newbeedrone-tool-kit-v1-6).

## Complete-category named-parts comparison

All amounts USD. **M1/reuse** identifies items in the manual-aircraft/workbench subset that remain reusable later; **M2–M5** identifies incremental purchases, not omitted project scope. These timing columns are accounting only: no staged budget is adopted. Quantities include initial spares. The existing PC, iPhone and EarPods are reused, with no assumed additional owned drone equipment.

The [prior BOM](issue10-bom-closure-options-2026-08-30.md) provides the exact primary URLs/variants for unchanged rows. Its same-day price snapshots are inherited, not misrepresented as fresh inventory checks. Fresh checks here cover the proposed new tool/sensor alternatives and exact radio variant. Availability conflicts and paper incompatibilities remain disclosed.

| Item and purchase quantity | Extended price | Timing |
|---|---:|---|
| TBS Source One V6 seven-inch DC frame ×1 | $35.95 | M1/reuse |
| MicoAir743v2-AIO45A, ArduPilot variant3661 ×1 | $74.99 | M1/reuse |
| F1002810/1100KV motors ×4 at$35.90 | $143.60 | M1/reuse |
| Gemfan Flash7040 PC clear four-prop sets ×3 at$3.99 | $11.97 | M1/reuse |
| iFlight Fullsend6S10000 Pro2363 flight pack ×1 | $95.99 | M1/reuse |
| RadioMaster Pocket M2 ELRS ×1 | $71.50 | M1/reuse |
| RadioMaster RP1V2 ELRS receiver ×1 | $18.99 | M1/reuse |
| RadioMaster3200mAh18650 radio-cell pair ×1 | $11.99 | M1/reuse |
| Holybro Micro M10/case/IST8310 SKU12044 ×1 | $27.99 | M1/reuse |
| ToolkitRC M6AC mains charger ×1 | $59.99 | M1/reuse |
| XT60 charge extension ×1 | $3.99 | M1/reuse |
| JST-XH6S balance extension ×1 | $2.99 | M1/reuse |
| FPV Freerider Windows license ×1 | $5.99 | M1/reuse |
| Plusivo V2 soldering kit with multimeter, exact variant above ×1 | $28.99 | M1/reuse |
| VIFLY ShortSaver2 ×1 | $14.99 | M1/reuse |
| Battery storage/charging bag ×1 | $11.99 | M1/reuse |
| FC16GB microSD ×1 | $13.95 | M1/reuse |
| VIFLY Finder2 backup buzzer,1pc pack ×1 | $13.49 | M1/reuse |
| Small24AWG wire pack ×1 | $3.99 | M1/reuse |
| XT60/12AWG pigtails with capacitors, three-pack ×1 | $12.99 | M1/reuse |
| Battery straps ×3 at$2.99 | $8.97 | M1/reuse |
| Double-sided tape ×1 | $3.99 | M1/reuse |
| Heat-shrink assortment ×1 | $10.99 | M1/reuse |
| Shared microSD reader ×1 | $2.95 | M1/reuse |
| **M1/reusable named parts** | **$693.22** | |
| Pi4 Model B2GB ×1 | $55.00 | M2–M5 |
| Camera Module3 NoIR standard ×1 | $27.50 | M2–M5 |
| Pi4 fan/heatsink ×1 | $6.95 | M2–M5 |
| Matching Pi4 case ×1 | $5.95 | M2–M5 |
| Compute64GB microSD ×1 | $19.95 | M2–M5 |
| Matek BEC12S-PRO ×2 at$18.99 | $37.98 | M2–M5 |
| Waveshare Pan-Tilt HAT complete kit ×1 | $17.99 | M2–M5 |
| D500 LiDAR Kit ×1 | $95.99 | M2–M5 |
| TFmini-S downward ranger ×1 | $49.99 | M2–M5 |
| Waveshare IR LED Board B ×2 at two-unit price$4.09 | $8.18 | M2–M5 |
| Adafruit5408 RGBW emitters ×2 at$5.50 | $11.00 | M2–M5 |
| Adafruit2776 spring-return5V latch solenoid ×1 | $4.95 | M2–M5 |
| **Incremental M2–M5 named parts** | **$341.43** | |
| **Whole-project named parts** | **$1,034.65** | **$134.65 above$900 before allowances** |

MicoAir remains a **conditional comparison**: the motor's28.47A matched-test maximum is below the AIO's advertised45A continuous rating, but that alone qualifies neither the pack connector nor the installed system. Its25.5mm mounting requires an adapter to the frame; the allowance below is not an existing selected part. [MicoAir product](https://store.micoair.com/product/micoair743v2-aio-45a/), [F100 data](https://www.ligpower.com/product/f100-fpv-motor.html).

## Allowances and delivery scenarios

These are explicit engineering estimates, **not vendor quotes, guaranteed limits or evidence that the unresolved design works**. They keep absent costs visible. Larger actual bills require review; an unknown cost is not made zero by assigning it to a later milestone.

| Obligation | M1/reuse | M2–M5 | Total |
|---|---:|---:|---:|
| Lighting optics/heat spreading/attachment | $0 | $15.00 | $15.00 |
| Protected load drivers, latch-state switches and interface parts | $0 | $15.00 | $15.00 |
| Enclosed removable250g-cargo holder fabrication/retention materials | $0 | $40.00 | $40.00 |
| Mounts, clearance, fasteners, wiring, camera ribbon and harness completion | $20.00 | $15.00 | $35.00 |
|25.5mm-to-frame AIO adapter fabrication/isolation | $10.00 | $0 | $10.00 |
| Metric hex drivers and prop-nut wrench missing from Plusivo kit | $15.00 | $0 | $15.00 |
| Workbench, heat-safe surface, ventilation, pliers and insulation-shrinking provisions | $45.00 | $0 | $45.00 |
| Scale, wind/temperature measurement and ground-distance marking resources | $45.00 | $0 | $45.00 |
| Local link/accessory integration | $0 | $20.00 | $20.00 |
| Phone build/setup contingency, no paid membership selected | $0 | $25.00 | $25.00 |
| Buzzer backup-cell/inclusion and mounting contingency | $6.51 | $0 | $6.51 |
| **Integration/tool allowances** | **$141.51** | **$130.00** | **$271.51** |
| **Named parts plus allowances** | **$834.73** | **$471.43** | **$1,306.16** |
| Shipping/battery-handling scenario | $45.00 | $30.00 | $75.00 |
| Illustrative tax/duty allocation | $87.98 | $50.14 | $138.12 |
| Initial rework/qualification reserve | $60.00 | $40.00 | $100.00 |
| Conditional jurisdiction-dependent provision | $60.00 | $0 | $60.00 |
| **Complete planning scenario** | **$1,087.71** | **$591.57** | **$1,679.28** |

The tax example is10% of parts/allowances/shipping, rounded upward once for the whole project, then allocated across phases; it is not any jurisdiction's actual tax rule. The later allocation is the remainder so the phase columns sum exactly. Separate future orders may cost more shipping. The compliance placeholder is not a legal sufficiency judgment; any actual module, labeling, registration or fee must be privately determined and quoted. Paid engineering labor is not included for this self-build project; no free outside professional inspection is assumed.

The holder allowance buys only fabrication/material capacity for the proposed mechanism, not a proven secure product: cargo must remain enclosed when the holder is detached, the mechanical latch carries load, and the solenoid only releases it when authorized. No guaranteed forced-entry resistance is introduced. A particular enclosure geometry, fabrication process, compliant wiring/connector redesign or perception redesign exceeding its allowance remains a cost risk. The separate initial-rework reserve does not magically qualify any of those choices.

## Three compared routes and the actual savings

| Route | Named parts | Integration allowance | Full scenario | Difference from$900 |
|---|---:|---:|---:|---:|
| A: one pack/AIO, previous$69.99 kit plus separate meter, retained D500/TFmini-S | $1,097.15 | $256.51 | $1,731.53 | +$831.53 |
| B: one pack/AIO, Plusivo kit and$15 missing-driver allowance, retained D500/TFmini-S | $1,034.65 | $271.51 | **$1,679.28** | **+$779.28** |
| C: B plus D200 and TF-Luna; additional$10 scanner-mount allowance | $974.65 | $281.51 | $1,624.28 | +$724.28 |

All routes use the same$75 shipping,$100 rework,$60 conditional compliance and illustrative10% tax method. Route B saves **$229.34** against the earlier two-pack/65A full scenario of$1,908.62. Route C saves another$55 after its extra mounting allowance and illustrative tax, but its changed sensor coverage/latency is unqualified. The route A figure excludes the previous speculative$9 PINECIL saving; this explains its$9.90 difference from the prior$1,721.63 scenario.

Route B is the least-cost **retained-sensor full-category comparison** established here, conditional on the advertised tool offer and resolving the aircraft paper design. Route C is a separately costed redesign lead, not a supported substitute with identical capability. No route is selected. A low marketplace kit price without exact H7/ArduPilot, powertrain and sensing compatibility would not repair this conclusion.

## M1-only visibility, not a changed budget

The same route B yields **$693.22 in M1/reusable parts** and **$1,087.71 in the complete M1 allocation**, with the long-term propulsion/pack retained. The incremental M2–M5 allocation is **$591.57**, bringing the unchanged full project to$1,679.28. The M1 subtotal before illustrative tax, rework and compliance is$879.73; advertising that figure as a complete$900 M1 budget would hide real unresolved obligations.

This decomposition answers purchase timing without approving it. The user has **not** changed$900 from a whole-project maximum into an M1 allowance, accepted a higher later budget, or authorized buying a partial build. Even the M1 complete scenario is above$900. Shared tools, radio, charger, GPS, storage reader and propulsion are counted only once; later components remain visible rather than being relabeled maintenance. No twenty-minute fully equipped acceptance is claimed for the stripped M1 accounting subset.

## Remaining paper work versus future tests

- **P01, answerable now:** no examined full design fits$900. Exact retail offers, delivered charges, applicable compliance costs and priced completion of mechanical/power interfaces remain to close a purchasable ledger. Conditional lower-cost leads are not proof that a$900 alternative cannot exist; no automatic request for another budget increase follows.
- **P02, answerable now:** the iFlight pack's exact AMASS XT60H-F connector must be reconciled with the required operating/transient current, wiring and control authority. The manufacturer specifies35A with12AWG and a temperature-rise condition of≤85K, versus113.88A aggregate motor-table maximum; that hot rating condition is not a proposed operating-temperature target. Neither advertised pack C-rating nor a delayed software current limiter qualifies unrestricted use. Resolve a bounded operating envelope with adequate authority, or a supplier-supported assembly redesign and its price, **before purchase**. Do not wait for a flight to discover a documented mismatch. [AMASS exact connector](https://www.china-amass.net/xt60h-f-product/), [iFlight pack](https://shop.iflight.com/Fullsend-6S-10000mAh-Li-Ion-Battery-Pro2363), [F100 table](https://www.ligpower.com/product/f100-fpv-motor.html).
- **P02, answerable now:** retain **two** BECs. Matek BEC12S-PRO is **5A continuous/9A peak**, not8A/12A, and defaults to5.2V; final rail design must reconcile exact sensor/servo/Pi input limits, regulation tolerance and back-feed protection. No single-regulator saving is credited. MicoAir pin assignments, arming enforcement, scanner transport, camera travel/clearance and physical installation layout remain concrete specification work. [Matek exact regulator](https://www.mateksys.com/?portfolio=bec12s-pro).
- **P02, answerable now:** D200/TF-Luna need detection/landing coverage and latency reasoning before being counted as replacements. Even retained D500/TFmini-S do not prove arbitrary wire detection or safe-terrain classification; conservative refusal/route/site policies and all later operating envelopes remain assigned to their milestone specs. A low-cost sensor label is not a completed autonomy design.
- **Procurement details, answerable now:** confirm the Plusivo offer/exact mains variant, buzzer inventory and backup-cell inclusion, exact pack revision/lead construction, suitable instruments, holder fabrication and delivered prices. The tool/buzzer ambiguities are stated, not covered by pretending unknown parts are owned.
- **Pending physical validation:** acceptable soldering/build workmanship, installed mass/CG, thermal/current behavior, fully equipped Q74 endurance with reserve, Q73 piloting, actual phone/vision/link operation and loaded250g retention/control/security. These occur after approved construction/implementation; they are not prerequisites to writing a conditional spec, and they do not erase P01/P02.

## Provenance

Read the canonical instructions, shared workflow, map and latest issue10 comments, including Q73/Q74 approval. Parent and propulsion agent are independently updating the acceptance and paper-qualification records. This report changes none of those records or the separate PC implementation.

Waveshare web extraction returned403 for some product pages; their public product HTML was fetched read-only with PowerShell, inspecting price/InStock structured data and descriptions. The manufacturer's linked tool marketplace page was inspected but did not yield a reliable current checkout offer. Other unchanged prices retain their explicitly dated same-day source snapshot. No inventory is reserved and no destination is inferred.

Source read snapshots, SHA-256; uncommitted sources are not represented by the base commit:

| Source | Hash |
|---|---|
| Issue10, including Q73/Q74 approval | `FD2CA04FF3F6ABF5A73FBE638750C330B0E633AD523EDB557491FB5D7E57615F` |
| Project map | `92B45F1B0B28358CAF42E0747B306AADA2E11D7DBD014EEA82DF6AA58F924002` |
| [Prior BOM](issue10-bom-closure-options-2026-08-30.md) | `93F98BFB99992BB6DA616EC9ED054296D24590D744FB7E0BA7C280F7834793EF` |
| [Endurance model](issue10-endurance-payload-model-2026-08-30.md) | `0C143436B9446476C1E3A6A63505D30667DB0B3B6BC742FB9B2F5756D9D2D487` |
| [Phone route](issue10-phone-build-options-2026-08-30.md) | `CA062C7FB9E9ACF2465A00EF7BFB0DB29217D69A44AC63471F2822B6D5D55667` |
