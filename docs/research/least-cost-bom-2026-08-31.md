# Least-cost examined complete BOM — corrected power path

Researched **2026-08-31** in the main checkout, branch main, base commit 68e00796f56d1975b05efa8e8f3c5c5fd504b6ac. This report and several source reports are uncommitted; that commit does not contain them. Research only: no purchase, supplier contact, account action, upload, installation, capture, powered work, production-code change or commit.

## Result and decision boundary

**The lowest fully itemized proposal with a directly verified motor offer in this bounded pass is $1,196.64 in named purchases, or $1,862.64 with the stated completion and delivered-cost allowances.** It preserves the complete M1–M5 categories and proposes a factory QS8/8AWG battery path, explicitly modeled lower-current propulsion, whole-pack energy measurement and corrected peripheral/IR supplies. It is **$962.64 above the unchanged $900 complete-project ceiling** in that scenario. The figures are neither a global minimum nor a guaranteed delivered quote. The remaining installation and software predicates below prevent calling it a ready-to-buy, proven complete system.

**Endurance remains marginal, not established:** the synchronized lighter-aircraft model predicts approximately **20.98 useful minutes centrally with148Wh usable**, but **18.20 in the moderate-loss case with146Wh and13.64 in the stacked unfavorable case with144Wh**. These endpoint-consistent energy assumptions, coupled battery-sag/control calculations and separate reserves are detailed in the [model](least-cost-propulsion-2026-08-31.md); they are computational sensitivities, not measured results. The full requirement is retained; the model does not justify claiming that the candidate reliably meets it.

The $1,679.28 earlier comparison was cheaper partly because it retained an inadequately qualified XT60 battery assembly. Reusing that price after changing the connector name would not repair the design. Conversely, estimated shipping, fabrication and rework are not unavoidable market minima: the separately stated $1,196.64 purchase subtotal must not be reported as $1,862.64 of quoted merchandise.

An alternate retailer advertises the same 800KV motor for $25.99 rather than the manufacturer's $31.99. Until the exact variant/stock offer is confirmed, its **$24 four-motor saving** is a separate sensitivity: **$1,172.64 named / $1,836.24 full scenario**, not the primary quote. No budget increase, staged-budget interpretation or capability removal is selected by this report.

Preserved requirements include the seven-inch self-build; twenty useful minutes with camera/computer/video/navigation active and a separate protected reserve; onboard biometric arming enforcement; existing iPhone17Pro/USB-C EarPods with intentionally started, offline locked-pocket voice and inspection video; independent emergency radio; navigation/avoidance and safe-landing behavior; IR/visible night lighting; guests; and a removable enclosed holder for the approved 250g cargo, with recipient-face-verified release only when landed and motors stopped. Holder mass remains separate. One purchased pack is allowed by the Q74 clarification. No onboard microphone, goggles, second video system, Mac, paid Apple membership or duplicate owned PC/phone is introduced.

## What changed and why

The [coordinated propulsion review](least-cost-propulsion-2026-08-31.md) proposes **iFlight XING-E2809 800KV with APC7×4E/7×4EP two-blade props**, replacing F1001100KV/Gemfan7040-3. It combines APC's manufacturer-computed propeller data with published motor resistance/KV and explicit loss assumptions; **this is not a matched motor/prop bench test**. The factory **Nexus6S2P P50B10Ah, QS8 female/8AWG, seven-pin JST-XH balance** option replaces the iFlight XT60 pack; it has an explicit pack-level discharge specification. The [power review](least-cost-power-path-2026-08-31.md) screens the full assembly, limits and residual conditions. Those calculations and public ratings, rather than a battery C-rating or delayed software current limiter, support a conditional engineering candidate.

The cheapest examined appropriate flight controller remains **MicoAir743v2-AIO45A, ArduPilot variant3661, $74.99**. It combines an H743, microSD, ample serial ports and a four-channel45A ESC in10g; mounting is25.5mm rather than the frame's30.5mm stack position. The named board and explicit adapter allowance replace a $149.99 H7/65A stack. A cheaper F405 flight stack is not assumed to support the required scripting/all-arming policy. Exact firmware and fail-closed enforcement remain specification and integration obligations. [MicoAir store](https://store.micoair.com/product/micoair743v2-aio-45a/), [exact board specifications](https://micoair.com/flightcontroller_micoair743v2_aio_45a/).

The compute supply stays **Matek BEC12S-PRO, $18.99, 5.2V default,5A continuous/9A peak**. One formerly identical peripheral regulator is replaced by **Hobbywing5A AIR, SKU30607000, $13.99**, set to5.0V: it accepts2–8S, rates5A continuous/15A instantaneous and weighs21g. This saves $5 and removes the nominal5.2V-versus-TFmini-S5V±0.1V discrepancy, although delivered-voltage tolerance still needs checking. The final two-servo pan/tilt is driven from FC PWM signals and powered by this separate5V peripheral rail; there is no full Pi HAT connection joining the supplies. D500's included USB interface stays on the Pi supply. [Matek specification](https://www.mateksys.com/?portfolio=bec12s-pro), [Matek offer](https://www.progressiverc.com/products/matek-bec12s-pro), [Hobbywing offer](https://www.hobbywingdirect.com/products/ubec-5a-air), [manufacturer specification](https://www.hobbywing.com/en/products/ubec-5a93).

**A further supply correction is necessary for IR:** Waveshare's compatible Camera(F) powers its IRBoardB modules through3.3V mounting terminals. Camera Module3 is not that electrical interface. Budget **DFRobot DFR1015, $5.30**, configured for3.3V, supplied from the AIO's otherwise allocated12V rail rather than the5V peripheral rail. DFR1015 specifies7.5–30V input, recommends below24V, and lists3A at3.3V without added heatsinking at25°C; the12V source avoids the full6S input concern. Two nominal3W IR boards imply about1.82A at3.3V. Input/output tolerance, switching, mounting and thermal behavior still require review. The $5.30 is transferred out of the earlier interface allowance, not counted twice. [Waveshare Camera(F) interface](https://www.waveshare.com/product/raspberry-pi/rpi-camera-f.htm), [IRBoardB](https://www.waveshare.com/infrared-led-board-b.htm), [DFR1015](https://www.dfrobot.com/product-2599.html), [manufacturer in-stock catalog](https://www.dfrobot.com/category-70.html).

## Complete purchase ledger

USD before delivery/tax. **F** means a fresh August31 source check by this agent or the coordinated component investigator. **I** means the exact August30 primary-source price is inherited from the [previous BOM](issue10-bom-closure-options-2026-08-30.md), not represented as newly verified inventory. **A** means a manufacturer-advertised offer without a reliable delivered checkout confirmation. Availability is never reserved.

M1/reuse versus later is accounting only. It does not change $900 into an M1 allowance. Quantities include one installed prop set and **one complete spare set**, one flight pack, and one spare main capacitor. Earlier reports proposed two spare sets; the user approved initial spares, not that exact quantity. The same aircraft, tools and radio remain reusable later.

| Purchase, exact candidate and quantity | Extended | Timing / evidence |
|---|---:|---|
| TBS Source One V6 seven-inch DC frame ×1 | $35.95 | M1/reuse; I; [TBS](https://www.team-blacksheep.com/products/prod%3Asource1v6) |
| MicoAir743v2-AIO45A ArduPilot variant3661 ×1 | $74.99 | M1/reuse; F; [MicoAir](https://store.micoair.com/product/micoair743v2-aio-45a/) |
| iFlight XING-E2809 **800KV** ×4 at$31.99 | $127.96 | M1/reuse; F; [iFlight exact variant](https://shop.iflight.com/XING-E-2809-Cinelifter-Motor-Pro2064) |
| APC7×4E ×4 and APC7×4EP ×4 at$2.71 | $21.68 | M1/reuse; F; installed set plus one complete spare set; [E](https://www.apcprop.com/product/7x4e/), [EP](https://www.apcprop.com/product/7x4ep/) |
| Nexus6S2P P50B10Ah, factory QS8 female/8AWG and7-pin JST-XH ×1 | $252.00 | M1/reuse; F; [Nexus](https://nexusbatterysystems.com/products/6s2p-p50b), made to order, approximately one-week advertised build time |
| Genuine QS8 **male** connector halves ×2 at$2.35 | $4.70 | M1/reuse; F; one aircraft, one charge lead; [QS Connector](https://qsconnector.com/products/qs8-connector-black-antispark-connector-high-current-connector-male) |
| DFRobot FIT0580 8AWG wire,1m red plus1m black ×1 | $7.90 | M1/reuse; F; purchase length includes practice/off-aircraft material; [DFRobot](https://www.dfrobot.com/product-1756.html) |
| Matek I2C-INA-BM whole-pack monitor ×1 | $19.99 | M1/reuse; F; seller lists100 units; [OffTheGridSun](https://offthegridsun.com/Auto-Pilot-Controller/MATEK-Mateksys-I2C-INA-BM-ULTRA-PRECISE-I2C-POWER-MONITOR) |
| Panasonic EEU-FR1V102B35V1000µF capacitors ×2 at$1.75 | $3.50 | M1/reuse; F; one installed, one spare; [DigiKey exact cut-tape part](https://www.digikey.com/en/products/detail/panasonic-industry/EEU-FR1V102B/3072262) |
| RadioMaster Pocket M2 charcoal **ELRS** ×1 | $71.50 | M1/reuse; F; [RadioMaster](https://radiomasterrc.com/products/pocket-radio-controller-m2); region variant privately matched later |
| RadioMaster RP1V2 ELRS receiver ×1 | $18.99 | M1/reuse; I; [RadioMaster](https://radiomasterrc.com/products/rp1-expresslrs-2-4ghz-nano-receiver) |
| RadioMaster3200mAh18650 cell pair ×1 | $11.99 | M1/reuse; I; [RadioMaster](https://radiomasterrc.com/products/18650-3200mah-3-7v-battery-2pcs-for-tx16s-boxer-tx12-mt12-radios) |
| Holybro Micro M10/case/IST8310 SKU12044 ×1 | $27.99 | M1/reuse; I; [Holybro](https://holybro.com/products/micro-m10-gps) |
| ToolkitRC M6AC mains6S charger ×1 | $59.99 | M1/reuse; I; [ToolkitRC](https://www.toolkitrc.com/product/m6ac/); actual mains variant must match supply |
| XT60-to-XT60/XT90 extension ×1, for low-current charger-side conversion only | $3.99 | M1/reuse; I; [Pyrodrone](https://pyrodrone.com/products/xt60-to-xt60-xt90-10cm-extension-charge-cable) |
| JST-XH6S balance extension ×1 | $2.99 | M1/reuse; I; [Pyrodrone](https://pyrodrone.com/products/balance-lead-extension-cable-200mm-jst-xh-choose-cell-count) |
| FPV Freerider Windows license ×1 | $5.99 | M1/reuse; I; [developer](https://fpv-freerider.itch.io/fpv-freerider) |
| PlusivoV2 iron/multimeter kit,110V US plug, reference0721248989277 ×1 | $28.99 | M1/reuse; A, checked August31; [manufacturer](https://www.plusivo.com/soldering-iron-kit-2/63-plusivo-soldering-iron-kit-with-digital-multimeter-v2-110-v-plug-type-us-.html) |
| VIFLY ShortSaver2 ×1 | $14.99 | M1/reuse; I; [Rotor Riot](https://rotorriot.com/products/shortsaver-2-smoke-stopper); bench source/interface must match |
| Pyrodrone battery storage/charging bag ×1 | $11.99 | M1/reuse; I; [Pyrodrone](https://pyrodrone.com/products/pyrodrone-lipo-bag-lunch-box-style); not guaranteed fire containment |
| FC16GB Class10 microSD ×1 | $13.95 | M1/reuse; I; [PiShop](https://www.pishop.us/product/microsd-card-16-gb-class-10-blank/) |
| VIFLY Finder2,1pc package ×1 | $13.49 | M1/reuse; I; [manufacturer](https://viflydrone.com/products/vifly-finder-v2-fpv-racing-drone-buzzer); conflicting page/variant stock and cell inclusion retained below |
| Small24AWG wire purchase ×1 | $3.99 | M1/reuse; I; [Pyrodrone](https://pyrodrone.com/products/1ft-silicone-wire-choose-color-and-gauge); not propulsion wiring |
|250×20mm battery straps ×3 at$2.99 | $8.97 | M1/reuse; I; [Pyrodrone](https://pyrodrone.com/products/pyrodrone-kevlar-battery-strap-w-woven-rubber-grip-metal-buckle-250x20mm); geometry requires review |
| Double-sided tape ×1 | $3.99 | M1/reuse; I; [Pyrodrone](https://pyrodrone.com/products/heavy-duty-3m-black-double-sided-tape-choose-width) |
| Heat-shrink assortment ×1 | $10.99 | M1/reuse; I; [Pyrodrone](https://pyrodrone.com/products/heat-shrink-tube-set-530pc) |
| Shared microSD reader ×1 | $2.95 | M1/reuse; I; [PiShop](https://www.pishop.us/product/high-speed-micro-sd-card-reader-maximum-128gb-black/) |
| **M1/reusable purchases** | **$866.40** | |
| Pi4 ModelB2GB ×1 | $55.00 | Later; F; [PiShop](https://www.pishop.us/product/raspberry-pi-4-model-b-2gb/) |
| Camera Module3 NoIR standard ×1 | $27.50 | Later; I; [PiShop](https://www.pishop.us/product/raspberry-pi-camera-module-3-noir/) |
| Adafruit3368 miniature5V cooling fan ×1 | $3.50 | Later; F; [Adafruit](https://www.adafruit.com/product/3368);6.2g, mounting hardware included |
| Adafruit3082 15×15×15mm aluminum heatsink ×1 | $1.95 | Later; F; [Adafruit](https://www.adafruit.com/product/3082);3.6g, thermal adhesive included |
| Compute32GB SanDisk Ultra Class10 microSD, PiShopSKU964 ×1 | $14.95 | Later; F; [PiShop](https://www.pishop.us/product/microsd-card-32-gb-class-10-blank/); in stock |
| Matek BEC12S-PRO compute supply ×1 | $18.99 | Later; F; [ProgressiveRC](https://www.progressiverc.com/products/matek-bec12s-pro) |
| Hobbywing5A AIR, SKU30607000 peripheral supply ×1 | $13.99 | Later; F; [Hobbywing](https://www.hobbywingdirect.com/products/ubec-5a-air) |
| DFRobotDFR1015 dedicated3.3V IR supply ×1 | $5.30 | Later; F; [DFRobot](https://www.dfrobot.com/product-2599.html) |
| Adafruit1967 mini pan-tilt assembly with two micro-servos ×1 | $18.95 | Later; F; [DigiKey](https://www.digikey.com/en/products/detail/adafruit-industries-llc/1967/5154681);63 listed in stock; [assembly specifications](https://www.adafruit.com/product/1967) |
| Waveshare D500 LiDAR Kit ×1 | $95.99 | Later; F; [Waveshare](https://www.waveshare.com/d500-lidar-kit.htm); USB adapter/cable included |
| TFmini-S downward ranger ×1 | $49.99 | Later; F; [Waveshare](https://www.waveshare.com/tfmini-s-lidar-range-sensor.htm) |
| WaveshareIRBoardB ×2, two-unit tier$4.09 | $8.18 | Later; F; [Waveshare](https://www.waveshare.com/infrared-led-board-b.htm) |
| Adafruit5408 RGBW natural-white emitters ×2 at$5.50 | $11.00 | Later; F; [Adafruit](https://www.adafruit.com/product/5408); two units listed in stock |
| Adafruit2776 spring-return5V latch solenoid ×1 | $4.95 | Later; F; [Adafruit](https://www.adafruit.com/product/2776) |
| **Incremental M2–M5 purchases** | **$330.24** | |
| **Whole-project named purchases** | **$1,196.64** | **$296.64 above$900 before completion/delivery allowances** |

The $12.99 old three-pack XT60/12AWG pigtail-and-capacitor bundle is removed completely. QS8 mates, suitable main wire, monitor and replacement capacitors are priced separately. The retained XT60 extension is only raw material for a cold, disconnected, low-current charging lead; it is **not an in-flight adapter around the corrected power path**. Bench short-protection interfaces and required small branches remain in the harness allowance. Only necessary connector halves are bought; purchasing redundant female QS8 halves alongside the factory female pack connector is not credited as required equipment.

## Allowance audit and delivered scenarios

These are explicit estimates, not prices or guaranteed caps. No additional tools, printer, machining service or test instruments are presumed owned. Named products do not prove the custom mechanism can be fabricated within the allowance.

| Completion obligation | M1/reuse | Later | Total |
|---|---:|---:|---:|
| Lighting optics, thermal spreading and attachments | $0 | $15.00 | $15.00 |
| Protected load switching, flyback diode/MOSFET, level interfaces and two latch/door-state switches; **after transferring$5.30 to named IR regulator** | $0 | $9.70 | $9.70 |
| Enclosed removable250g-cargo holder, mechanical latch, hinge/retention and fabrication materials | $0 | $40.00 | $40.00 |
| General mounts, fasteners, camera ribbon/adapter, small harness/bench interfaces and clearance | $20.00 | $15.00 | $35.00 |
| AIO25.5mm-to-frame adapter and vibration isolation | $10.00 | $0 | $10.00 |
| Additional tall-pack cradle, mast and landing-clearance material | $20.00 | $0 | $20.00 |
| Lightweight insulated Pi base/vented guard/fan bridge and local fasteners, replacing the purchased case | $0 | $15.00 | $15.00 |
| Metric hex drivers and prop-nut wrench missing from tool kit | $15.00 | $0 | $15.00 |
| Heat-safe bench, ventilation, pliers and insulation-shrinking resources | $45.00 | $0 | $45.00 |
| Scale, wind/temperature measurement and ground-distance marking resources | $45.00 | $0 | $45.00 |
| Phone/local-link accessory completion | $0 | $20.00 | $20.00 |
| Buzzer backup-cell/inclusion/mount contingency | $6.51 | $0 | $6.51 |
| **Completion allowances** | **$161.51** | **$114.70** | **$276.21** |
| **Named purchases + completion** | **$1,027.91** | **$444.94** | **$1,472.85** |
| Shipping/battery-handling scenario | $45.00 | $30.00 | $75.00 |
| Illustrative tax/duty allocation | $107.30 | $47.49 | $154.79 |
| Initial rework/qualification reserve | $60.00 | $40.00 | $100.00 |
| Conditional compliance provision | $60.00 | $0 | $60.00 |
| **Complete planning scenario** | **$1,300.21** | **$562.43** | **$1,862.64** |

The example tax is10% of named purchases, completion and shipping, rounded upward once to cents for the whole project; the later allocation is the remainder. It is not any jurisdiction's actual rule. Destination-specific shipping/duty, required equipment/markings/fees and local conditions remain unknown, not zero. The $60 compliance placeholder is not a sufficiency claim. Initial rework funds first-build iterations; later worn-out parts remain a separate maintenance budget. This self-build excludes paid engineering labor without presuming free professional inspection.

The earlier separate **$25 phone-build contingency is removed from the required subtotal**: Q72 explicitly selects evaluation within free hosted-build quotas and personal-signing conditions, with paid overages blocked. No $99 fee is mandatory or silently chosen. General initial-rework contingency remains, and a later required paid route would be a new unapproved cost. Physical phone/link accessories retain their separate$20 allowance; no device or entitlement compatibility is asserted by removing a duplicate fee reserve.

The final quantity audit retains a full initial spare prop set, removing the previously proposed second spare set for **$10.84** savings; another complete set is an optional$10.84, not a required line. The separate$100 initial-rework reserve remains for first-build breakage/iterations. A **32GB** SanDisk Ultra compute card saves **$5** versus the earlier64GB card. No64GB minimum was approved. This is a plausible small-system storage provision, not permission to omit required models or evidence: the M2 build must fit its OS, application, offline models, bounded local data and free-space margin on the card, or revise the purchase before deployment. A starting allocation of8GiB OS/runtime,4GiB models,2GiB application/data and8GiB free/updates is an engineering target below the card's approximately29.8GiB nominal binary capacity, not measured installed sizes or a newly approved retention policy. No unlimited onboard video recording is assumed. The FC retains its separate16GB card and the reader is still shared. [Exact32GB card](https://www.pishop.us/product/microsd-card-32-gb-class-10-blank/).

The Plusivo kit already contains the meter, iron, stand, tips, solder/flux/wick, tweezers, cutter/stripper, practice board and limited wire/tape/heat-shrink. There is no second meter or separate iron power supply. Its bundled wire is22AWG and does not replace8AWG propulsion wiring. The exact quantity/sizes of bonus heat-shrink are not established, so deleting the entire$10.99 insulation purchase is not yet a defensible complete-build saving. Workbench and measurement allowances cover distinct omissions rather than buying another full kit. The kit's nominal60W rating neither proves nor precludes satisfactory large-wire joints; cold practice and workmanship inspection are later gates. The bundled meter must not be used inline for full propulsion current or assumed suitable for mains work.

**Instrument scope is deliberately bounded:** the already priced meter may compare low-current readings within its fused rating and check INA offset/gain; the specified shunt accuracy, INA/FC/ESC logs, charger readings and temperature measurements then support steady-current, startup/reset/desynchronization, sag and thermal screening. The$45 allowance covers scale/wind/temperature/ground-marking resources. It does **not** include a high-current clamp, oscilloscope or fast differential probe, and neither logs nor the meter establish sub-millisecond voltage/current peaks. No such instrument or free borrowing is assumed. The [power review](least-cost-power-path-2026-08-31.md) defines this limited baseline commissioning approach using manufacturer6S ratings, layout/capacitor provisions and current margin. A fault or engineering review that requires independent fast diagnostics stops the affected work; obtain an actual instrument/access quote and revise the ledger, or redesign, before proceeding. That conditional expense is unresolved, not silently$0 or an invented mandatory purchase today.

For sensitivity, **$1,547.85** is the named-parts/completion subtotal plus the illustrative$75 shipping, before tax/rework/compliance. Omitting those final allowances does not produce a$900 basket. Equally, none of these scenarios establishes the lowest possible delivered cost.

## Bounded alternatives and rejected false savings

| Compared route | Cost effect / status |
|---|---|
| Main: manufacturer XING800KV/APC, factory NexusQS8, MicoAir, retained D500/TFmini-S | **$1,196.64 named / $1,862.64 full scenario**; current primary comparison |
| Same exact XING800KV at advertised alternate-retailer$25.99 | **−$24 purchases; $1,172.64 named / $1,836.24 scenario** if exact purchasable variant is confirmed; no different-KV substitution; [HPXGRC offer](https://www.hpxgrc.com/products/iflight-xing-e-2809-1250kv-800kv-4-6s-fpv-cinelifter-motor) |
| Retain F1001100/Gemfan7040 instead of XING/APC, but keep corrected factory path | Using the same installed-plus-one-spare inventory, motors cost$15.64 more and two Gemfan sets cost$13.70 less than the APC inventory: **+$1.94**. Its113.88A motor-table total before auxiliaries exceeds the QS8 maker's lower110A listing and the coordinated88A design budget. It is neither cheaper nor qualified as an unrestricted alternative under this comparison. |
| BrotherHobbySE2816/810KV nominal$22.50 each | Cheaper motor sticker price, but substantially greater mass and propeller speed/compatibility issues in the coordinated review; not a drop-in endurance-equivalent saving; [manufacturer](https://www.brotherhobby.com/se-2816-810kv-motorcw-p00219p1.html) |
| D200/TF-Luna instead of D500/TFmini-S | Prior−$60 sensor purchases plus at least$10 added mount allowance; changed scan rate/range/mass and landing coverage are not justified as equivalent. **Not a complete capability-preserving alternative.** |
| PocketCC2500 at$59.99 instead of$71.50 ELRS | Wrong radio protocol variant; not a valid saving for the priced ELRS receiver |
| One cheap F405 stack or generic all-in-one frame kit | No confirmed exact hardware/firmware/arming, propulsion and package-content equivalence; whole-kit headline prices are not added as if all required variants were included |
| PiZero2W, removing scanner/aiming/lighting/holder, phone-only biometrics, hobby battery pack rebuilding | Changes or unqualified replacement of required capacity/architecture/safety obligations; not adopted |

The new official-motor ledger reconciles from the earlier$1,034.65 purchases as follows: **−$15.64 motors +$9.71 props +$156.01 factory pack −$12.99 old pigtail bundle +$36.09 QS8/wire/monitor/capacitors −$5 peripheral regulator +$5.30 IR regulator −$5 compute card −$7.45 old case/cooling replacement +$0.96 pan/tilt replacement = $1,196.64**. The old$271.51 allowances become **$276.21** after−$25 phone buffer+$20 tall mounting−$5.30 transferred IR regulator+$15 lightweight compute protection. No previous tool saving, second-pack removal, paid-Apple avoidance or included USB adapter is subtracted twice.

## Technical qualification and honest coverage

**Power path:** the proposed Nexus configured pack, genuine QS8 mate, short8AWG aircraft harness, whole-pack shunt and AIO form one explicitly priced path. Pack, connector and monitor ratings are not interchangeable: the supplier lists120A pack continuous current, while the genuine QS8 manufacturer lists a110–180A range with application conditions still relevant. The power report uses the lower documented boundary and the explicit motor/prop model rather than the seller's300A connector headline. Both external supply inputs are downstream of the whole-pack monitor; FC-only current sensing would omit them. The35V capacitor is a component candidate, not a clamp that guarantees the AIO's27V ceiling under every transient. [Nexus](https://nexusbatterysystems.com/products/6s2p-p50b), [QS manufacturer](https://qsconnector.com/products/qs8-connector-black-antispark-connector-high-current-connector-male), [Matek monitor](https://www.mateksys.com/?portfolio=i2c-ina-bm), [Panasonic component offer/specification](https://www.digikey.com/en/products/detail/panasonic-industry/EEU-FR1V102B/3072262).

**Peripheral loads:** a provisional5V rail budget reserves2A for both servos together,1.1A for the latch,1A for the two white emitters and0.15A for TFmini-S:4.25A before small interfaces. The2A servo figure is an engineering allowance, not an extracted manufacturer stall guarantee. If exact stall/starting demand exceeds it, the regulator's instantaneous rating cannot be treated as continuous capacity; power sequencing, fault isolation or a larger regulator must be costed before relying on the configuration. No camera/control brownout is accepted to save money. IR uses its separately budgeted12V-to3.3V branch. Pi/D500 and FC/radio supplies remain separate. [Pan/tilt](https://www.adafruit.com/product/1967), [solenoid](https://www.adafruit.com/product/2776), [white emitters](https://www.adafruit.com/product/5408).

**Perception and landing:** D500 supplies360° ranging in one plane, not volumetric obstacle detection. TFmini-S supplies one downward distance, not semantic safe-terrain classification. Camera aiming, tracked-subject inference and conservative refusal/route/site policies remain necessary. Thin wires, branches, transparent/dark surfaces, sun and above/below-plane obstacles remain failure cases requiring explicit detection/confidence and operating-envelope treatment. Keeping these sensors retains a concrete development baseline; it does not establish arbitrary safe autonomous travel or terrain selection. Replacing them with cheaper, shorter-range sensors without the required justification would hide a scope change. [D500](https://www.waveshare.com/d500-lidar-kit.htm), [TFmini-S](https://www.waveshare.com/tfmini-s-lidar-range-sensor.htm).

**Biometrics, phone and video:** Pi4/2GB with Camera3NoIR and its video encoder is retained as a conditional combined-workload platform. CPU/memory/thermal/concurrency and image-quality budgets still need software measurements. H743 capacity and ports support the proposed enforcement route, but all-arming behavior, timeout/replay/failure handling and emergency-control separation are software requirements, not purchased features. Q72's no-Mac weekly-renewal route remains the selected direction for evaluation; offline locked-pocket operation and required entitlements must still work on the actual phone. [Phone route evidence](issue10-phone-build-options-2026-08-30.md).

**Night and delivery:** the visible emitters each have a1W white channel, despite a4W combined RGBW product name. IRBoardB's close-range example does not prove the needed night operating range. The spring-return solenoid releases a mechanical latch; it does not carry the cargo structurally. The shell, internal latch and inaccessible strike must resist ordinary hand removal and stay closed after detachment. The$40 fabrication provision and170g mass allowance are transparent design targets, not a tested security mechanism. Release needs positive landed/motors-stopped state and recipient-face verification; safety landing remains independent, and the drone stays disarmed for physical collection. [White emitter](https://www.adafruit.com/product/5408), [IR board](https://www.waveshare.com/infrared-led-board-b.htm), [actuator](https://www.adafruit.com/product/2776).

## Concrete mass reductions without deleting features

**Compute target70g, saving35g from the old105g aggregate:** keep the same Pi4/2GB, unmodified ports and processing capability. Raspberry Pi's official magazine lists46g for the board; use **48g** here to retain2g of revision uncertainty. Add the named6.2g fan,3.6g adhesive-backed heatsink,1g SD allowance and **11.2g for the insulated protective base, vented guard/fan bridge, local fasteners and short wiring**. This is an installation design allocation, not an existing70g commercial case or measured assembly. [Official board description](https://magazine.raspberrypi.com/articles/raspberry-pi-4-specs-benchmarks), [fan](https://www.adafruit.com/product/3368), [heatsink](https://www.adafruit.com/product/3082).

One concrete material-volume check for that11.2g allocation uses a100×65×0.6mm polycarbonate base (3.9cm³, approximately4.68g), two85×8×1.2mm rails (approximately1.96g together) and a30×40×0.8mm fan bridge before ventilation openings (approximately1.15g). At1.2g/cm³ this leaves about3.4g for standoffs, fasteners and short wire. The material density is grounded in [SABIC's polycarbonate data](https://www.sabic.com/en/Images/Polymers-All-Products_tcm1010-42650.pdf); exact purchased sheet grade/thickness, bending stiffness, clearances and attachment still need the fabrication drawing. Use existing Pi mounting holes, insulated clearances and port access; do not desolder connectors or rely on the thin sheet alone as the structural aircraft mount. The$15 fabrication provision is additional to general airframe mounting; no free printer, cutting service or owned material is assumed.

The fan/heatsink/guard must maintain cooling under the full workload and protect against incidental contact/conductive debris. It is vented, **not waterproof, dust-tight or crash-certified**, and must stay inside the dry operating envelope. A small heatsink's Pi3 example does not establish Pi4 combined-workload performance. Its15mm height, fan/bridge clearance, airflow and strain relief must fit the parent layout and pass thermal/mechanical commissioning. If the design cannot achieve protection/cooling within70g, account for the actual change and recompute; do not spend the separate50g contingency twice.

**Pan/tilt target40g, saving42g:** Adafruit1967 lists37g including its two micro-servos; add3g for a camera-adapter/attachment target, with Camera3 and its moving ribbon already counted separately. The assembly costs$18.95 through the checked DigiKey offer, versus the old$17.99 Waveshare HAT kit. Drive the servos through the AIO's available M5/M6 PWM outputs, with5V power from the peripheral regulator and a shared signal reference. The [coordinated supplement](least-cost-pan-tilt-supplement-2026-08-31.md) checks the separate timer group and exact supply/data path. No additional PCA9685 controller is needed in this proposal. Actual travel, camera-hole adaptation, signal response and load/stall behavior remain integration gates; this change retains aiming, not cinematic stabilization. [Adafruit assembly](https://www.adafruit.com/product/1967), [DigiKey offer](https://www.digikey.com/en/products/detail/adafruit-industries-llc/1967/5154681).

The combined mass reduction is **77g**. Its cost effect is **−$6.49 named purchases +$15 fabrication allowance =+$8.51 before illustrative tax**, compared with the immediately preceding same-prop/32GB basket. This costs a little more to make a lighter, explicitly protected installation; it is not a purported mass saving from deleting reserve, sensors or the holder.

## Installed mass and future evidence

The synchronized ordinary-flight reference is **1,897.251g**:613.5g retained nonpropulsion equipment/installation;244g motors;31.751g installed APC props;930g configured-pack allowance (900g approximate listing plus30g variant allowance);70g new aircraft QS8/main wire/shunt/capacitor installation; and8g dedicated IR subregulator installation. The613.5g contains the explicit100g general harness/mount/landing-interface budget and a **separate50g contingency**, not an unreported zero-mass structure. It is690.5g minus35g compute-assembly and42g pan/tilt refinements, neither achieved by deleting a capability. The70g dedicated power addition is not a second purchase of the old removed XT60 bundle. The off-aircraft charge connector, extra wire, spare props and spare capacitor cost money but are not all carried.

The power addition splits into25g aircraft QS8-mate allowance,25g short8AWG conductor allowance,4g monitor,11g signal/strain-relief allowance and5g installed capacitor allowance. The8g IR regulator is additional. These are installation estimates except identified component figures. The parent layout allocates the tall pack, scanner plane, camera travel and landing/holder clearance; a35g motor-stack model or the old1,851.6g endurance estimate cannot be reused unchanged.

The ordinary central model uses354.540W and148Wh usable to its stated endpoint, with4Wh pre-reference and20Wh reserve, yielding20.98 useful minutes. Its coupled weak-control calculation applies the10A/cell discharge-curve endpoint19.6V, an additional0.0576Ω dynamic pack step model and all4A auxiliary demand; the predicted bus is18.454V under that demand, with2,608g thrust, or approximately1.375 thrust/weight. This is an internally coupled engineering screen, not a measured endpoint or an operational battery-setting instruction. Its production, model and thermal assumptions remain material.

Adding250g cargo and170g removable holder gives **2,317.251g** provisional delivery mass; permanent interfaces remain in the ordinary configuration. The stricter loaded calculation uses a21.7V curve endpoint with the additional coupled sag; it predicts about1.368 thrust/weight. With83Wh usable,455.595W mission demand and22.78Wh reserve, the modeled useful duration is only **7.40 minutes**. Twenty-minute loaded missions were not approved and are not promised. See the [propulsion/endurance report](least-cost-propulsion-2026-08-31.md) for exact curves, reserve arithmetic and adverse cases, and the [integrated layout](least-cost-integration-2026-08-31.md) for packaging and interfaces. Actual Q73/Q74 results, CG/clearance, electrical/thermal/current behavior, software/phone performance and loaded retention/security remain future acceptance evidence rather than prerequisites to writing a conditional design.

## Remaining work, without re-asking settled preferences

- **P01 remains open:** the lowest examined complete scenario still exceeds$900, and some prices are advertised/inherited or allowances rather than checkout quotes. No automatic budget-increase question follows. A true cheaper design must retain the requirements and correct interfaces; merely removing uncertainty allowances would still not reach$900.
- **P02 advances:** there is now a concrete factory power-path correction, explicitly modeled lower-current propulsion, whole-pack measurement and rail architecture. Exact configured pack dimensions/lead mass, controller pad/large-wire termination design, voltage/transient and stall-load qualification, final mechanical drawings and the unresolved software/perception predicates still need the coordinated specification. Public ratings and the model support comparison but not a flight-readiness or robust-endurance claim.
- **Procurement refinements:** exact tool offer/mains variant; configured supplier options and shipping; buzzer stock/cell inclusion; final small-parts quantities; compatible bench adapters; fabrication/instrument quotes; applicable compliance obligations. Unknowns remain stated, not filled with assumed owned equipment.
- **Physical validation later:** workmanship, mass/CG, calibrated whole-pack energy, logged current/sag and startup/thermal behavior within the instrument scope above, reserve/endurance and loaded recovery, camera/phone/biometrics, sensor coverage and holder security. Fast waveform verification is not claimed from ordinary telemetry. No document mismatch is deliberately left for discovery in flight.

The M1/reusable allocation is **$1,300.21**, with **$562.43** later additions; their sum remains$1,862.64. This accounting does not authorize staged funding or begin aircraft purchases. The eight separately approved PC tickets are unaffected.

## Provenance and verification limits

Read CLAUDE.md, the shared workflow, map and latest issue10 comments, including Q71–Q74. Applied the research skill through this delegated background investigation. Manufacturer/seller pages and exact public variant metadata were used. Waveshare occasionally returned403 through the web extractor; read-only public HTML price/InStock and specification fields were inspected with PowerShell. PiShop public product-price fields and Shopify variant data were similarly checked. The Plusivo manufacturer-linked marketplace offer did not yield reliable checkout confirmation. No inventory is reserved and no personal destination is inferred.

The propulsion and factory-power-path investigators supplied their primary-source evidence and are independently checking the synchronized candidate. This report changes only this new file; the parent owns tracker/index and final packet reconciliation. The named ledger was independently summed in integer cents:41 priced rows=$1,196.64; subtotals and the single whole-project tax rounding were recomputed.

Source snapshots read in this investigation, SHA-256:

| Source | Hash |
|---|---|
| Issue10 through post-Q74 review | 0C3678EF029051EB29A86302680CB6F9324024A95503AD5BC076B245739B5176 |
| Project map | F1C7E015B2B137456C7640DEB35FFB49DF12AC78B884F637C56C15A34650AA67 |
| [Prior complete BOM](issue10-bom-closure-options-2026-08-30.md) | 93F98BFB99992BB6DA616EC9ED054296D24590D744FB7E0BA7C280F7834793EF |
| [Post-Q74 affordability](issue10-affordability-after-q74-2026-08-30.md) | DC367BE6C1A32C05A7B4E0121196E15037006E08B3616BF6EB773B2ED282AA3E |
| [Prior paper qualification](issue10-hardware-paper-qualification-after-q74-2026-08-30.md) | 2689F7AA17EB4FCE1E08176AE93DD3146A9A3D0E997C7B24C39F0A36CED20DAC |
| [Phone build route](issue10-phone-build-options-2026-08-30.md) | CA062C7FB9E9ACF2465A00EF7BFB0DB29217D69A44AC63471F2822B6D5D55667 |

Current coordinated reports are supporting engineering evidence, not approved purchases or test results. The following hashes identify the read snapshots used for the final cost/model reconciliation; live files may later change and should then be reconciled again.

| Coordinated source | Read-snapshot SHA-256 |
|---|---|
| [Propulsion/endurance](least-cost-propulsion-2026-08-31.md) | 91CA95194E47A8A9BCE283B2FF93AB0BB6F55FBA8ACE333304A9F57F8DC5CA0A |
| [Factory power path](least-cost-power-path-2026-08-31.md) | BAFCADB71A50CE52ECE1902A92DE5594CF32A6EF8E539DC3BC4B01CE70EAC84B |
| [Installed layout/interfaces](least-cost-integration-2026-08-31.md) | D54DE67594BBE18E32FE49EB35EDF99AA2FEDB12F9F84C3AEF39EDB47026C122 |
| [Pan/tilt substitution](least-cost-pan-tilt-supplement-2026-08-31.md) | 3EC437E33053BFB1B20F0B7608A48B53CF3399D11326AD66B05D5C0AD44A3A4C |


