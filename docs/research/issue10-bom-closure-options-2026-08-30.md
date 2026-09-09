# Issue 10 — proposed complete bill of materials and closure options

Checked **2026-08-30**, main checkout, branch `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. New, uncommitted planning research; this commit does not contain the report. No purchases, account actions, software installation, captures, hardware tests, flight, PC-ticket changes or commits occurred. This report proposes a design for review now; it does not require an unbuilt aircraft to pass flight tests before specification.

## Result for the current decision

**A concrete experimental design can now be proposed, but it does not fit the approved $900 complete-project maximum.** Named parts total **$1,268.14**. Explicit materials, integration, tools and build-service allowances bring the subtotal to **$1,514.65**. With the shipping, tax, initial rework and jurisdiction-dependent allowance scenario below, the planning total is **$1,908.62**, roughly **$1,910**. These are distinct numbers: $1,910 is neither a supplier quote nor a minimum possible project cost.

The proposal retains the seven-inch self-build, two factory flight packs, independent radio, onboard biometrics, offline iPhone voice/video, navigation/avoidance, lighting and removable recipient-verified delivery. A currently available motor/propeller pairing has its own near-full-charge manufacturer data; a newly investigated10,000mAh pack makes twenty useful minutes plus reserve plausible in the central analytical model. A conservative modeled case narrowly passes, while a stronger installation-loss stress case misses the target. The point is a reviewable engineering candidate with explicit risks, not an endurance guarantee.

Even the unselected **one-pack plus cheaper MicoAir45A AIO** comparison leaves **$1,097.15 in named parts**, plus an explicit$10 mounting-adapter allowance, before the other materials, tax, shipping, workspace or development allowances. The examined reductions therefore do not close$900. This is a complete proposal assembled in a bounded pass with a cheaper conditional comparison; neither is a global minimum or proof that every redesign fails. No capability cut, battery change, higher budget or purchase is approved by this report.

## Proposed system boundary

- **Flight:** Source One V6 seven-inch frame; LIGPOWER/T-HOBBY F100 **1100KV** motors; Gemfan Flash7040 PC three-blade propellers; Holybro Kakute H7v1.5/Tekko32 F4 Metal **65A AM32** stack; factory iFlight Fullsend6S10,000mAh Li-ion and a backup-powered recovery buzzer. This is a proposed replacement of earlier candidates, not a silent substitution.
- **Compute and vision:** Pi 4 2GB, Camera Module 3 NoIR, cooling and pan/tilt actuation. The existing iPhone/USB-C EarPods supply voice input; no redundant onboard microphone is added. Shared camera/compute/Wi-Fi serve inspection video; no duplicate FPV system or goggles are added.
- **Navigation and sensing:** existing GPS/compass plus a D500 horizontal scanning LiDAR and a downward TFmini-S. The Pi interprets the scanner; the flight controller receives appropriate obstacle inputs and range data. The actual coverage and mode limitations are defined below; this is not arbitrary wire detection or guaranteed safe-site recognition.
- **Night and delivery:** separate IR and visible lighting, protected auxiliary power, a spring-return release actuator inside a fabricated enclosed holder, and retained mounts/landing clearance. A locked holder stays closed if detached; its attachment must not expose cargo or the actuator. Face verification and the landed/disarmed condition jointly gate release. The drone remains disarmed for physical return afterward.
- **Phone:** proposed native app with the newly researched no-membership-fee personal-signing route as a **conditional option**, plus a small development contingency. Paid Apple signing is shown separately. Weekly refresh and the app's offline/background behavior are real engineering/maintenance requirements, not assumed proof.

## Named-parts ledger

USD sticker prices; quantities are purchases, not necessarily quantities installed at once. **Fresh** identifies newly checked primary seller/manufacturer pages or public variant metadata in this pass. **Prior same-day** retains the exact 2026-08-30 snapshot from the [ground ledger](aircraft-ground-cost-after-q53.md) or [compute ledger](compute-video-cost-after-q53.md); it is not represented as freshly checked stock. Primary links in those source reports preserve exact variants and inclusion details. No checkout or destination-specific delivery quote was obtained.

| Item / proposed quantity | Unit price | Extended | Source and status |
|---|---:|---:|---|
| TBS Source One V6 seven-inch DC frame ×1 | $35.95 | $35.95 | [Manufacturer](https://www.team-blacksheep.com/products/prod%3Asource1v6); prior same-day |
| Kakute H7 v1.5 + Tekko32 F4 Metal 65A AM32 stack ×1 | $149.99 | $149.99 | [Holybro](https://holybro.com/products/kakute-h7-v1-stacks); fresh, exact SKU `11091+31097`, variant `45081936724157`, available |
| LIGPOWER/T-HOBBY F1002810/1100KV motors ×4 | $35.90 | $143.60 | [Manufacturer](https://www.ligpower.com/product/f100-fpv-motor.html); fresh,1100KV page/variant, available,67g with wires each |
| Gemfan Flash7040 PC three-blade clear sets ×3, four props/set | $3.99 | $11.97 | [TBS exact set](https://www.team-blacksheep.com/products/product:3787); fresh, in stock, one installed set and two spare sets; [manufacturer7.9g each](https://www.gemfanhobby.com/7040-flash-pc-3-blade.html) |
| iFlight Fullsend 6S 10,000mAh Li-ion ×2 | $95.99 | $191.98 | [iFlight Pro2363](https://shop.iflight.com/Fullsend-6S-10000mAh-Li-Ion-Battery-Pro2363); fresh coordinated propulsion check, listed in stock |
| RadioMaster Pocket M2 charcoal ELRS ×1 | $71.50 | $71.50 | [RadioMaster](https://radiomasterrc.com/products/pocket-radio-controller-m2); prior same-day; regulatory variant chosen privately before purchase |
| RadioMaster RP1 V2 ELRS receiver ×1 | $18.99 | $18.99 | [RadioMaster](https://radiomasterrc.com/products/rp1-expresslrs-2-4ghz-nano-receiver); prior same-day |
| RadioMaster 3200mAh 18650 pair ×1 | $11.99 | $11.99 | [Radio cells](https://radiomasterrc.com/products/18650-3200mah-3-7v-battery-2pcs-for-tx16s-boxer-tx12-mt12-radios); prior same-day |
| Holybro Micro M10 with case/IST8310 ×1 | $27.99 | $27.99 | [Holybro](https://holybro.com/products/micro-m10-gps); prior same-day SKU12044 |
| ToolkitRC M6AC mains charger ×1 | $59.99 | $59.99 | [ToolkitRC](https://www.toolkitrc.com/product/m6ac/); prior same-day, plug variant must suit actual supply |
| XT60-to-XT60/XT90 charge extension ×1 | $3.99 | $3.99 | [Charge lead](https://pyrodrone.com/products/xt60-to-xt60-xt90-10cm-extension-charge-cable); prior same-day |
| JST-XH 6S balance extension ×1 | $2.99 | $2.99 | [Balance lead](https://pyrodrone.com/products/balance-lead-extension-cable-200mm-jst-xh-choose-cell-count); prior same-day |
| FPV Freerider Windows license ×1 | $5.99 | $5.99 | [Developer](https://fpv-freerider.itch.io/fpv-freerider); prior same-day |
| NewBeeDrone tool kit V1.7 ×1 | $69.99 | $69.99 | [Exact retailer kit](https://pyrodrone.com/products/newbeedrone-tool-kit-v1-7); prior same-day; iron/cable and specified tools/consumables included |
| SparkFun basic multimeter ×1 | $21.50 | $21.50 | [SparkFun](https://www.sparkfun.com/digital-multimeter-basic.html); prior same-day |
| VIFLY ShortSaver 2 ×1 | $14.99 | $14.99 | [Product](https://rotorriot.com/products/shortsaver-2-smoke-stopper); prior same-day; protection ratings must match actual bench source |
| LiPo storage/charging bag ×1 | $11.99 | $11.99 | [Bag](https://pyrodrone.com/products/pyrodrone-lipo-bag-lunch-box-style); prior same-day; not guaranteed fire containment |
| FC 16GB microSD ×1 | $13.95 | $13.95 | [Card](https://www.pishop.us/product/microsd-card-16-gb-class-10-blank/); prior same-day |
| VIFLY Finder2 backup buzzer,1pc pack ×1 | $13.49 | $13.49 | [Manufacturer](https://viflydrone.com/products/vifly-finder-v2-fpv-racing-drone-buzzer); fresh public variant metadata says available, extracted page also says sold out; availability and conflicting backup-cell inclusion wording need confirmation, with$6.51 allowance below |
| 24AWG small wire pack ×1 | $3.99 | $3.99 | [Wire](https://pyrodrone.com/products/1ft-silicone-wire-choose-color-and-gauge); prior same-day; not motor/power wiring |
| Three-pack XT60/12AWG pigtails and capacitors ×1 | $12.99 | $12.99 | [Pigtails](https://pyrodrone.com/products/black-xt60-lipo-pigtail-w-35v-1000uf-capacitor-12awg-3pcs); prior same-day; initial and spare materials |
| 250×20mm battery straps ×3 | $2.99 | $8.97 | [Straps](https://pyrodrone.com/products/pyrodrone-kevlar-battery-strap-w-woven-rubber-grip-metal-buckle-250x20mm); prior same-day |
| Double-sided tape ×1 | $3.99 | $3.99 | [Tape](https://pyrodrone.com/products/heavy-duty-3m-black-double-sided-tape-choose-width); prior same-day |
| Heat-shrink assortment ×1 | $10.99 | $10.99 | [Insulation](https://pyrodrone.com/products/heat-shrink-tube-set-530pc); prior same-day |
| Pi 4 Model B 2GB ×1 | $55.00 | $55.00 | [PiShop](https://www.pishop.us/product/raspberry-pi-4-model-b-2gb/); fresh price/stock from preceding pass, untested combined workload |
| Camera Module 3 NoIR standard ×1 | $27.50 | $27.50 | [Camera](https://www.pishop.us/product/raspberry-pi-camera-module-3-noir/); prior same-day |
| Pi 4 fan/heatsink ×1 | $6.95 | $6.95 | [Cooling](https://www.pishop.us/product/case-fan-heatsink-for-raspberry-pi-4-case/); prior same-day |
| Matching Pi 4 case ×1 | $5.95 | $5.95 | [Case](https://www.pishop.us/product/raspberry-pi-4-case-red-white/); prior same-day; not a finalized airborne mount |
| Compute 64GB microSD ×1 | $19.95 | $19.95 | [Card](https://www.pishop.us/product/microsd-card-64-gb-class-10-blank/); prior same-day |
| Matek BEC12S-PRO ×2 | $18.99 | $37.98 | [Regulator](https://www.progressiverc.com/products/matek-bec12s-pro); one compute rail and one peripheral rail, proposed separation |
| Shared card reader ×1 | $2.95 | $2.95 | [Reader](https://www.pishop.us/product/high-speed-micro-sd-card-reader-maximum-128gb-black/); prior same-day, counted once |
| Waveshare Pan-Tilt HAT kit ×1 | $17.99 | $17.99 | [Waveshare](https://www.waveshare.com/pan-tilt-hat.htm); fresh, in stock; HAT, two servos, mechanism/acrylic/screws |
| Waveshare D500 LiDAR Kit ×1 | $95.99 | $95.99 | [Waveshare](https://www.waveshare.com/d500-lidar-kit.htm); fresh, in stock; includes USB adapter/cable |
| TFmini-S downward range sensor ×1 | $49.99 | $49.99 | [Waveshare](https://www.waveshare.com/tfmini-s-lidar-range-sensor.htm); fresh seller metadata in stock |
| Waveshare IR LED Board B ×2 | $4.09 at two-unit tier | $8.18 | [Waveshare](https://www.waveshare.com/infrared-led-board-b.htm); same-day two-unit tier, supply/mount adaptation below |
| Adafruit 5408 RGBW white emitters ×2 | $5.50 | $11.00 | [Adafruit](https://www.adafruit.com/product/5408); fresh same-day exact variant, two listed in stock |
| Adafruit 2776 spring-return 5V solenoid ×1 | $4.95 | $4.95 | [Adafruit](https://www.adafruit.com/product/2776); fresh, in stock,12.6g; actuates a latch, does not carry payload load |
| **Named-parts total** | | **$1,268.14** | **$368.14 above $900 before the following obligations** |

The old$807.92 route becomes **$1,061.05** after the$75 stack difference, $102 two-pack difference, $65.64 four-motor difference, −$3 three-prop-set difference, and$13.49 recovery buzzer. The remaining$207.09 in named parts above funds the added peripheral regulator, pan/tilt, scanner, downward rangefinder, lighting and actuator. Nothing is bought twice through both ledgers.

## Explicit engineering allowances

These are **author-proposed estimates, not verified vendor prices or guaranteed caps**. They replace missing-cost zeros so the planning decision can be made honestly. Procurement and detailed design must refine them before spending; an overrun requires review, not permission to charge it elsewhere.

| Remaining obligation | Planning allowance | Basis / deliverable covered |
|---|---:|---|
| Lighting optics, heat spreading, safe attachment | $15 | Two visible emitters and two IR boards are already priced; this adds their mechanical/thermal integration, not a proven illumination range |
| Load drivers, protection, latch-state sensing and small interface parts | $15 | MOSFETs/diodes/resistors, small board/connectors and door/latch switches; separate from high-current battery harness |
| Enclosed secure removable holder fabrication and retention | $40 | Material or small fabrication order, door/hinge, internal latch/striker, concealed fasteners/closed detached enclosure; not a free assumed printer |
| Frame/compute/GPS/sensor mounts, permanent clearance and harness completion | $35 | Fasteners, standoffs, appropriate additional wire/connectors, camera ribbon/adapter and landing-clearance material; no 25.5mm AIO adapter needed for the proposed30.5mm stack |
| Workbench and omitted hand-tool provisions | $45 | Pliers/stripping, heat-safe surface, extraction/ventilation arrangement and insulation-shrinking provisions not established as owned; actual suitability still required |
| Measurement instruments/materials | $45 | Scale, wind measurement, distance markings/tape and safe temperature measurement; multimeter and FC current logging already separately accounted |
| Local link/accessory integration | $20 | Short leads/USB-interface or antenna/bridge contingency; proposed primary topology reuses Pi Wi-Fi and independent ELRS, not a second full radio/video system |
| Phone build/service/setup contingency | $25 | Candidate free personal signing/cloud quota is costed at $0 membership; this reserve is not an approved recurring service or payment fallback |
| Recovery buzzer backup-cell/inclusion and mounting contingency | $6.51 | Makes the buzzer provision$20 in total; manufacturer descriptions conflict on included cell, so a complete backup-powered assembly is not assumed for$13.49 |
| **Allowances subtotal** | **$246.51** | Requires refinement; not a second hardware package |
| **Parts + integration subtotal** | **$1,514.65** | Before destination/delivery and initial uncertainty |
| Shipping/battery-handling scenario | $75.00 | Multi-supplier planning estimate, no destination inferred; not guaranteed delivery cost |
| Tax/duty scenario | $158.97 | Illustrative10% of the preceding subtotal plus shipping, rounded up; **not a jurisdiction's actual tax rule**, and some line items may be treated differently |
| Initial rework/qualification reserve | $100.00 | First-build replacements/iterations before the planned capability works; future wear/repairs remain outside the initial budget |
| Jurisdiction-dependent compliance provision | $60.00 | Placeholder toward any required module/marking/registration or related initial equipment/fees; **not a legal sufficiency determination**. Requirements and actual costs remain for private jurisdiction review |
| **All-allowance planning scenario** | **$1,908.62** | **$1,008.62 over the approved ceiling; not an approved revised cap** |

The scenario excludes no capability by calling it later maintenance. A model/API license, mandated equipment, larger build charge, sensor redesign or fabrication bill exceeding its allowance is a budget risk, not silently free. Existing PC, iPhone and EarPods are reused without buying duplicates; paid human engineering labor is not included because this is a self-build learning project. No free professional physical inspection is assumed.

The native paid-signing alternative adds **$99 for the first membership year**, yielding **$2,007.62** under the same other allowances. This is not mandatory: see the separate [phone-build comparison](issue10-phone-build-options-2026-08-30.md), which proposes legitimate personal signing from Windows with weekly refresh and private hosted-Mac build quotas. Any required renewal before the complete project is delivered remains visible in initial costs; later renewal obligations are not erased.

## Compatibility and operational claims

**Motor, battery and ESC:** the proposed F1001100KV/Gemfan7040-3 manufacturer table reaches28.47A per motor at24.59V:113.88A for four before auxiliaries. This resolves a known paper mismatch in the earlier EMAX1500KV/HQ candidate, whose53.3A at only21V implies213.2A for four. EVE currently lists70A continuous per50PL cell, suggesting140A for a2P arrangement before pack wiring, connector and thermal limits; the seller's25C headline is not qualification for250A. The matched F100 table is a much better starting point, but actual pack-assembly continuous/transient ratings and harness protection still need documented review before purchase. [F100 manufacturer data](https://www.ligpower.com/product/f100-fpv-motor.html), [EVE50PL](https://www.evemall.eu/consumer-battery/cylindrical-ncm-cell/21700-50pl), [earlier EMAX data](https://evelta.com/content/datasheets/449-0101096022.pdf)

The proposed65A continuous/75A burst ESC has4–6S input,30.5mm mounting, current sensing and a matched manufacturer stack. It is retained as the single primary comparison; the lower-cost45A AIO becomes a plausible alternative with this lower-current propulsion pair, and is priced below. Neither selection proves wiring, heat or control margins. No silent throttle cap is used to make the arithmetic fit. [Holybro ESC](https://holybro.com/products/tekko32-f4-metal-4in1-65a-esc-65a)

The full Kakute H7v1.5 has microSD, an H743, ICM42688P and a SPA06 barometer. Upstream hardware definitions include the IMU and SPL06 driver; that driver's code includes SPA06 identification. The stable feature manifest includes scripting and SD storage. These support the choice on paper; the precise installed release, sensor revision, harness and unavoidable all-arming policy remain verification obligations. Do not substitute a Mini/50A variant because its headline price is lower. [Board](https://holybro.com/products/kakute-h7), [hardware definition](https://raw.githubusercontent.com/ArduPilot/ardupilot/master/libraries/AP_HAL_ChibiOS/hwdef/KakuteH7/hwdef.dat), [barometer driver](https://raw.githubusercontent.com/ArduPilot/ardupilot/master/libraries/AP_Baro/AP_Baro_SPL06.cpp), [stable features](https://firmware.ardupilot.org/Copter/stable/KakuteH7/features.txt)

**Power and connectors:** Pi power stays separate from motor/noisy actuation loads. Two budgeted BECs do not automatically prove sufficient startup/stall current. The HAT's shared5V connection must be mapped before connecting an independently powered peripheral rail; prevent back-feeding and ground/reference mistakes. The FC's available UARTs support a proposed assignment for receiver, GPS, Pi commands, downward ranging and ESC telemetry; the D500 uses the Pi's included USB adapter. Final pin assignments, active Bluetooth/UART sharing, logic levels and harness lengths belong in the hardware specification.

**Vision and aiming:** the Pi4 proposal uses hardware video encoding and CPU inference, with a2GB memory/performance risk to benchmark. Camera Module3's autofocus is not pointing/stabilization. The Waveshare kit adds aiming; its acrylic mount and moving CSI ribbon must be adapted/checked for Module3 and the frame. A pan/tilt kit does not promise cinema stabilization or an unblocked downward/front view in every attitude. Camera concurrency, selected-subject tracking, biometric hardening and inspection feed performance are named M2/M3 development tasks, with contingency if the shared hardware cannot meet them.

**Obstacle and landing coverage:** D500 is45g, approximately1.45W,12m nominal range,360° **in one plane**, typically10Hz, with60klux advertised ambient tolerance. TFmini-S adds downward distance, not a ground-safety classifier. The scanning plane moves as the aircraft tilts; frame/prop/mount occlusion, thin wires, branches, transparent/dark surfaces, overhangs, obstacles above/below the plane, sun, dust and blind-zone behavior matter. Proposal: implement conservative low-speed operating envelopes and refuse routes/landings when perception is insufficient. No guarantee of every-object detection or a self-selected arbitrary safe landing site follows from this hardware. [D500](https://www.waveshare.com/d500-lidar-kit.htm), [TFmini-S manufacturer sheet](https://en.benewake.com/uploadfiles/2024/04/20240426140025367.pdf), [ArduPilot avoidance modes](https://ardupilot.org/copter/docs/common-simple-object-avoidance.html)

This sensing baseline is a concrete starting design for later validation, not a complete solution to every requested environment. Establish the accepted initial operating envelope during M3 design; if it needs multi-plane/depth sensing, that becomes an explicit redesign/cost decision before the dependent capability is claimed. A tiny generic allowance cannot substantiate arbitrary obstacle avoidance. Detailed later-feature envelopes need not all be fully specified to close a sketch-level milestone ladder, but this limitation must be accepted rather than hidden.

**Night and secure delivery:** the two RGBW devices have1W white channels each despite4W total per RGBW package. The IR supplier's short-distance imaging example does not establish useful night escort range; illumination geometry, heat and image quality need design. The12.6g solenoid has a3mm stroke and about1.1A at5V; it releases an unloaded, mechanically retained latch, and must not act as the structural payload support. A spring-closed/internal latch, inaccessible strike and closed detachable shell are the proposed mechanism. Frame detachment must leave the cargo enclosed. Release remains recipient-face-verified, landed and motors stopped; safety landing and manual emergency control remain independent. No forced-entry/theft guarantee is added. [Visible emitter](https://www.adafruit.com/product/5408), [IR board](https://www.waveshare.com/infrared-led-board-b.htm), [actuator](https://www.adafruit.com/product/2776)

## Endurance model and future test boundary

The coordinated [endurance/payload model](issue10-endurance-payload-model-2026-08-30.md) explicitly counts the proposed complete ordinary configuration, including the scanner, pan/tilt, lights, electronics, separate FC microSD, backup-powered buzzer, retained interfaces and a50g installation contingency. Its provisional mass is **1,851.6g** with one855g10,000mAh pack installed. The second purchased pack funds another sortie, not simultaneous energy. The holder can be removed between ordinary and delivery missions, but permanent interfaces remain counted and its purchase cost remains in this report. A separate optional RGB camera is not silently added; any such redesign changes price and mass.

Central assumptions estimate about **27.5 useful minutes** after a separate modeled reserve; the coordinated conservative case is approximately **20.3minutes**, and a stronger installation-loss stress case is **18.6minutes**. These scenarios are not statistical confidence bounds. This is enough to nominate a plausible experimental candidate now, not to certify twenty useful minutes. The report defines the calculations, its conservative216Wh energy basis and the remaining design/validation work. A larger accepted budget by itself would not prove endurance or safe cargo capacity.

Planning may select this conditional design and its test obligations without first owning it. **Before purchase/assembly:** settle exact revisions, mechanical layout, current/power/thermal envelopes, applicable requirements and delivered prices. **Before flight:** complete construction inspection, commissioning and readiness checks. **Before any capability claim:** perform the consented/authorized software, range, endurance and load/holder tests against predeclared criteria. Budget/scope approval and exact procurement choices are answerable now; measured endurance and resistance to attacks belong to later evidence.

## Bounded cost alternatives, not accepted changes

| Alternative | Named-parts effect | Decision / limitation |
|---|---:|---|
| Keep current proposed65A stack and two10,000mAh packs | **$1,268.14** | Main comparison, all capabilities budgeted; no claim globally cheapest |
| Buy only one flight pack initially | −$95.99 → **$1,172.15** | Unselected change to two-pack initial provision; fewer consecutive practice sorties and recharge dependency; same energy per flight |
| Substitute TBS Lucid H7 60A stack | −$40.04 → **$1,228.10** | [TBS $109.95](https://www.team-blacksheep.com/products/prod%3Alucid_h7_stack); page still contradictory preorder/in-stock,60A60s/85A30s ratings. Exact thermal/current/availability qualification required; not equivalent continuous rating |
| One pack plus conditional Lucid | −$136.03 → **$1,132.11** | Still$232.11 over900 **before all allowances**; both changes unselected |
| Substitute MicoAir743v2-AIO45A ArduPilot variant | −$75.00 → **$1,193.14**, plus$10 adapter allowance | [MicoAir$74.99](https://store.micoair.com/product/micoair743v2-aio-45a/), exact ArduPilot variant3661 public metadata available. F10028.47A matched-test maximum is below advertised45A continuous; now a plausible paper option.25.5mm→30.5mm mounting, vibration isolation, pin assignments and exact firmware remain design work; no implicit throttle reduction |
| One pack plus conditional MicoAir AIO | **$1,097.15**, plus$10 adapter allowance | Cheapest examined board/pack combination; still$197.15 over900 before the adapter and all other allowances |
| Smaller8000mAh factory packs instead of10,000mAh | −$24.00 → **$1,244.14** | Materially less energy for only15g less listed mass per installed pack; not an adequate cost solution or selected endurance tradeoff |
| Personal signing instead of paid Apple membership | Saves **$99/year** if supported | Already used in the lower-cost main scenario, with weekly-refresh/trust/build-quota constraints; cannot subtract it again |
| Shared charger/iron power | Saves prior **$14.99** supply | Already credited; M6AC output/iron cable must be verified, charging and soldering separate |

**Tools check:** PINECIL V2 is currently$25.99 and in stock, but includes only the iron and tip; it is not a complete replacement for the$69.99 kit. A complete alternative would still need a suitable power cable, drivers/prop wrench, cutters/tweezers, iron rest, solder/flux and practice supplies. Adding an explicitly estimated$35–$45 for those missing parts gives$60.99–$70.99 before additional shipping, a possible$9 saving at best on this allowance comparison, not the false$44 saving obtained by deleting the kit. It has not been selected. M6AC remains the concrete low-cost combination of mains charger and shared supply; no cheaper fully accounted mains/6S alternative emerged in this bounded pass. [PINECIL contents and price](https://pine64.com/product/pinecil-smart-mini-portable-soldering-iron/), [existing tool/supply evidence](hardware-cost-options-after-q54.md)

Even applying that optimistic$9 tool difference to the one-pack/MicoAir comparison leaves **$1,088.15 in the adjusted parts comparison**, plus the$10 adapter and all other allowances. Applying the same$246.51 integration,$75 shipping,10% illustrative tax and$160 rework/compliance allowances yields **$1,721.63** for this cheapest examined scenario. It is a conditional comparison containing estimated tool substitutions, not a verified checkout basket or lower bound. Removing sensors, lights, secure delivery, tools or the phone from the complete-build accounting would change scope and is not adopted.

## What can be decided now

The review can accept or reject a **conditional design direction**, its initial operating-envelope limitations and a declared qualification/rework risk without waiting for proof from an unbuilt aircraft. It can also decide the phone maintenance route and whether two packs remain an initial purchase requirement. These are real tradeoffs, unlike asking the user to invent motor current or a safe payload rating.

Under the current$900 maximum, this proposal **cannot be approved as a funded full build**. Either further cost/architecture work must produce a fit, or the user must explicitly change the funding/scope boundary. No automatic budget increase is requested or inferred here. The already approved independent PC handoff continues; it does not close whole-project affordability or mean the later features have disappeared. Issue10 closure must accurately state what design and risk the user actually approves, not claim procurement or flight success.

## Provenance and check limits

Fresh product facts were gathered from public manufacturer/seller pages and exact Shopify/WooCommerce variants. Waveshare web extraction returned403 errors, so public product HTML was fetched read-only through PowerShell; price and InStock structured data and product descriptions were inspected. Some other sources rely on the explicitly dated prior same-day snapshot. No inventory is reserved. The propulsion agent independently retrieved/inspected the1100KV/Gemfan table and new battery listing; its report preserves that evidence. Conflicting visible/variant stock and inclusion wording for the recovery buzzer is reported, not resolved by pretending inventory was reserved.

Uncommitted local source snapshots (SHA-256):

| Source | SHA-256 |
|---|---|
| Ticket10 | `83C9A1FD8E6006BAC7826DCECC70B324B20EA4EFCD0F03E04EFDBE17384146C4` |
| Project map | `E4102C5DFE4061E076197499D8B2AA5F27B1CC14391768AA322B1035583DD784` |
| [Previous complete-budget review](complete-budget-review-900-2026-08-30.md) | `4BB6FD5B22AF085B588C3D0E60E3CC4ED100B10597FD0291EAE873176F8E4AFE` |
| [Ground ledger](aircraft-ground-cost-after-q53.md) | `276967BC0DE19A1311C088744385122714BBF08D387D8ECDFBE0B54464725B57` |
| [Compute ledger](compute-video-cost-after-q53.md) | `942E3E932335E0E056CABCEF1C985D0F28D477FBB8BE2FD0F4D4F447B8E7029A` |
| [Phone build options](issue10-phone-build-options-2026-08-30.md) | `20E7533B000940B68DBE396DCD2D85A55120CB598983D13BE0F0D9CBAB3E6EC1` |
| [Coordinated endurance model](issue10-endurance-payload-model-2026-08-30.md) | `EEC7BC6DA6EAEF9E20FE6ECB695AB01FE14B7D9E926230F56BEAFE72C1D51034` |
