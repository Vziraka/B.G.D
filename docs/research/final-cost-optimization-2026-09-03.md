# Final cost optimization and complete-build ledger — 2026-09-03

**Later owner amendment — September 10:** Q74 is now **11 useful minutes plus unchanged independent reserve**, same fully equipped no-extra-cargo configuration and workload proportions. The fifteen-/twenty-minute requirements and numerical pass/fail comparisons below are historical. Refer to the [current pre-purchase report](../prepurchase-decision-2026-09-10.md) and revised V26 acceptance; no automatic eleven-minute loaded-cargo requirement applies. Original component data/calculations remain historical evidence, not a revised aircraft qualification.

**Post-Q75 controlling update — 2026-09-03:** Q75 is approved and issue10 is **resolved as planning complete**, with Q74 unchanged. The [current hardware build package](../hardware/baseline-r1/README.md) records subsequent issue11 engineering. It exposes a genuine error: the selected$8 QS8-S item is a **two-pack series adapter**, not the assumed one-pack pigtail. Under the user's affected-subsystem authorization, R1.1 replaces only that interface with another genuine bare QS8 male and existing8AWG stock. Switch polarity, AHCT channel use and D500 cable reach are also corrected. The original1,897.251g/20.98min/$2,052.93 figures below are historical model/basket values, **not final R1.1 assembly totals**; see [mass/cost impact](../hardware/baseline-r1/mass-cost-impact.md). H01–H12 detailed engineering remains open; no purchase, fabrication or physical qualification is claimed. Dated pre-Q75 conclusions below do not override this update.

**Current coordinated disposition:** the later [final hardware decision packet](final-hardware-optimization-2026-09-03.md) uses this updated **$1,375.84 named / $2,052.93 scenario** ledger, supplies the paper fabrication/interface constraints and presents the exact baseline for Q75. The cost report's earlier unselected wording describes its pre-coordination audit state. Q74 remains a mandatory physical gate and no purchase is authorized.

Research-only review of the live Issue 10 package. No purchase, supplier contact, account action, checkout, upload, installation, powered work, production-code change, tracker edit, or commit occurred.

## Decision

**The least-cost fully enumerated near-candidate found in this bounded pass is $1,375.84 in named purchases.** Adding $270.00 of explicit fabrication/support allowances, the inherited $75.00 delivery scenario, illustrative 10% tax, $100.00 initial rework reserve, and $60.00 conditional compliance provision gives **$2,052.93**. This is a planning scenario, not a delivered quote or a global minimum.

It is **not yet a final requirement-preserving hardware selection**. The current 6S2P/XING/APC model predicts 20.98 useful minutes centrally but 18.20 minutes in the established moderate-loss case, so it does not establish the approved `>=20 useful minutes plus reserve` requirement. The companion compatibility audit also finds six safety-critical fabricated assemblies without dimensioned drawings. Removing the former $800–900 ceiling changes affordability, but it does not convert those engineering gaps into passes.

The cost is higher than the August 31 $1,862.64 scenario because this audit names previously omitted build hardware: a suitable high-current soldering station and tip, custom distribution conductors, main/branch wire, a fused compute branch, Pi power/interface carrier, lamp level shifting, cargo-actuation electronics, and state switches. Actual destination-specific shipping, tax, battery handling, fabrication quotes, remaining branch protection, and jurisdiction-specific compliance remain unknown rather than zero.

All approved capabilities remain in scope: seven-inch self-build; onboard Pi4 biometrics; existing iPhone 17 Pro and USB-C EarPods with offline locked-pocket voice/video and weekly personal signing; independent ELRS control; navigation, obstacle response and conservative landing behavior; IR and visible lighting; guests; 250g cargo including packaging; removable 170g-target secure holder; and recipient-face-verified release only while landed with motors stopped. No onboard microphone, goggles, second video system, Mac, paid Apple membership, or duplicate phone/PC is introduced.

## Price and status method

USD amounts exclude delivery and tax unless stated. `F` is a direct manufacturer or authorized-seller page checked on 2026-09-03. `C` is a same-day coordinated primary/authorized-source check recorded by the propulsion or compatibility investigator. `A` is a manufacturer-advertised price whose exact checkout or stock state was not independently established. Availability is not a reservation.

The ledger buys one flight pack, one installed prop set plus one complete spare set, one installed main capacitor plus one spare, and the tools needed for a first build. Existing user-owned PC, iPhone 17 Pro, and USB-C EarPods are reused at $0; $0 here means an identified owned item, not an unknown cost.

## Named purchase ledger

| Exact purchase and quantity | Extended | Status and primary/authorized evidence |
|---|---:|---|
| TBS Source One V6 7-inch DC frame ×1 | $35.95 | C; [TBS](https://www.team-blacksheep.com/products/prod%3Asource1v6) |
| MicoAir743v2-AIO45A, ArduPilot variant 3661 ×1 | $74.99 | C; [MicoAir store](https://store.micoair.com/product/micoair743v2-aio-45a/) and [specification](https://micoair.com/flightcontroller_micoair743v2_aio_45a/) |
| iFlight XING-E 2809 800KV motors ×4 at $31.99 | $127.96 | C; [iFlight](https://shop.iflight.com/XING-E-2809-Cinelifter-Motor-Pro2064) |
| APC `LP07040E-B4` four-prop bundles ×2 at $7.06 | $14.12 | F; each bundle has two 7×4E, two 7×4EP, and metric rings; installed set plus one full spare set; [APC](https://www.apcprop.com/product/7x4e-b4/) |
| Nexus 6S2P Molicel P50B 10Ah pack, factory QS8 female/8AWG/7-pin JST-XH ×1 | $252.00 | C; made-to-order advertised; [Nexus](https://nexusbatterysystems.com/products/6s2p-p50b) |
| QS Connector QS8-S male/8AWG 50mm tinned-end aircraft harness ×1 | $8.00 | F; [manufacturer](https://qsconnector.com/products/qs8-s-series-harness-8awg-with-tinned-ends-build-your-own) |
| Genuine QS8 male connector half ×1 | $2.35 | C; for the disconnected ground charge lead only; [manufacturer](https://qsconnector.com/products/qs8-connector-black-antispark-connector-high-current-connector-male) |
| XT60-to-XT60/XT90 10cm extension ×1 | $3.99 | C; cut only to make the QS8-to-M6AC **CHARGE ONLY**, 5A-capped lead; [Pyrodrone](https://pyrodrone.com/products/xt60-to-xt60-xt90-10cm-extension-charge-cable) |
| DFRobot FIT0580 8AWG, 1m red + 1m black ×1 | $7.90 | F; INA-to-bus route plus practice stock; [DFRobot](https://www.dfrobot.com/product-1756.html) |
| DFRobot FIT0581 10AWG, 1m red + 1m black ×1 | $6.90 | F; short bus-to-AIO pair; [DFRobot](https://www.dfrobot.com/product-1757.html) |
| DFRobot FIT0585 18AWG, 1m red + 1m black ×1 | $2.50 | F; regulator branch wire; [DFRobot](https://www.dfrobot.com/product-1761.html) |
| OnlineMetals C110 H02 0.125×0.375in copper bar, 1ft ×1 | $7.12 | C; cut into two 2in rails, leaving practice/spare stock; [exact stock](https://www.onlinemetals.com/en/buy/copper/0-125-x-0-375-copper-rectangle-bar-110-h02/pid/4258); [Alcobra comparison](https://alcobrametals.com/copper/rectangular-flat-bar/) |
| Matek I2C-INA-BM whole-pack monitor ×1 | $19.99 | C; [authorized seller](https://offthegridsun.com/Auto-Pilot-Controller/MATEK-Mateksys-I2C-INA-BM-ULTRA-PRECISE-I2C-POWER-MONITOR), [maker specification](https://www.mateksys.com/?portfolio=i2c-ina-bm) |
| Panasonic EEU-FR1V102B 35V 1000µF capacitors ×2 at $1.75 | $3.50 | C; installed plus spare; [DigiKey](https://www.digikey.com/en/products/detail/panasonic-industry/EEU-FR1V102B/3072262) |
| Littelfuse 0FHM0001LXN inline fuse holder ×2 at $6.42 | $12.84 | C; fixed compute-BEC and peripheral-BEC input branches; [DigiKey search](https://www.digikey.com/en/products?keywords=0FHM0001LXN) |
| Littelfuse 0297005.WXNV 5A fuse ×2 at $0.39 | $0.78 | C; 32V rating covers 6S maximum; each protects its 18AWG input branch while the regulators retain their own output protections; [DigiKey search](https://www.digikey.com/en/products?keywords=0297005.WXNV) |
| RadioMaster Pocket Crush M2 ELRS/FCC ×1 | $64.99 | F; [RadioMaster](https://radiomasterrc.com/products/pocket-crush-radio-controller) |
| RadioMaster RP1 V2 2.4GHz ELRS receiver ×1 | $18.99 | C; [RadioMaster](https://radiomasterrc.com/products/rp1-expresslrs-2-4ghz-nano-receiver) |
| RadioMaster 3200mAh 18650 pair ×1 | $11.99 | C; [RadioMaster](https://radiomasterrc.com/products/18650-3200mah-3-7v-battery-2pcs-for-tx16s-boxer-tx12-mt12-radios) |
| Holybro Micro M10/case/IST8310, SKU 12044 ×1 | $27.99 | C; [Holybro](https://holybro.com/products/micro-m10-gps) |
| ToolkitRC M6AC mains 6S charger ×1 | $59.99 | C; [manufacturer](https://www.toolkitrc.com/m6ac/); exact US mains version checked before order |
| JST-XH 6S balance extension ×1 | $2.99 | C; [Pyrodrone](https://pyrodrone.com/products/balance-lead-extension-cable-200mm-jst-xh-choose-cell-count) |
| FPV Freerider Windows license ×1 | $5.99 | C; [developer](https://fpv-freerider.itch.io/fpv-freerider) |
| Plusivo V2 110V kit with multimeter and fine-work consumables ×1 | $28.99 | A; [manufacturer](https://www.plusivo.com/soldering-iron-kit-2/63-plusivo-soldering-iron-kit-with-digital-multimeter-v2-110-v-plug-type-us-.html); its 60W iron is not credited for high-current joints |
| Hakko FX-888DX soldering station ×1 | $121.47 | F; in stock direct; [Hakko](https://hakkousa.com/products/soldering/soldering-stations/fx-888dx.html) |
| Hakko T18-C4 4mm bevel tip ×1 | $6.47 | F; in stock direct and compatible with station; [Hakko accessories](https://hakkousa.com/products/soldering/fx-888dx.html); the earlier T18-C5 suggestion was backordered |
| Plusivo 0.8mm 50g solder + rosin paste flux kit ×1 | $8.99 | A; Amazon availability advertised, checkout unverified; [manufacturer](https://www.plusivo.com/solder-wire-paste-kit/132-plusivo-solder-wire-08mm-50g-and-rosin-paste-flux-for-pcb-electrical-soldering.html) |
| VIFLY ShortSaver 2 ×1 | $14.99 | C; [Rotor Riot](https://rotorriot.com/products/shortsaver-2-smoke-stopper) |
| Pyrodrone battery storage/charging bag ×1 | $11.99 | C; [Pyrodrone](https://pyrodrone.com/products/pyrodrone-lipo-bag-lunch-box-style); not represented as fireproof containment |
| FC 16GB Class 10 microSD ×1 | $13.95 | C; [PiShop](https://www.pishop.us/product/microsd-card-16-gb-class-10-blank/) |
| VIFLY Finder 2 with self-contained 80mAh cell ×1 | $17.99 | C; current authorized offer; [RaceDayQuads search](https://www.racedayquads.com/search?q=VIFLY+Finder+2) |
| 24AWG silicone signal wire purchase ×1 | $3.99 | C; [Pyrodrone](https://pyrodrone.com/products/1ft-silicone-wire-choose-color-and-gauge) |
| 250×20mm battery straps ×3 at $2.99 | $8.97 | C; [Pyrodrone](https://pyrodrone.com/products/pyrodrone-kevlar-battery-strap-w-woven-rubber-grip-metal-buckle-250x20mm) |
| Heavy-duty double-sided tape ×1 | $3.99 | C; [Pyrodrone](https://pyrodrone.com/products/heavy-duty-3m-black-double-sided-tape-choose-width) |
| Shared microSD reader ×1 | $2.95 | C; [PiShop](https://www.pishop.us/product/high-speed-micro-sd-card-reader-maximum-128gb-black/) |
| **M1/reusable named purchases** | **$1,018.56** | One pack; later hardware reuses these items |
| Raspberry Pi 4 Model B 2GB ×1 | $55.00 | C; [PiShop](https://www.pishop.us/product/raspberry-pi-4-model-b-2gb/) |
| Raspberry Pi Camera Module 3 NoIR standard ×1 | $27.50 | C; includes 200mm standard 15-pin cable; [PiShop](https://www.pishop.us/product/raspberry-pi-camera-module-3-noir/) |
| Adafruit #1648 300mm 15-pin camera flex cable ×1 | $1.95 | F; in stock; exact moving-camera service-loop cable; [Adafruit](https://www.adafruit.com/product/1648) |
| Adafruit #3368 miniature 5V fan ×1 | $3.50 | C; [Adafruit](https://www.adafruit.com/product/3368) |
| Adafruit #3082 15mm aluminum heatsink ×1 | $1.95 | C; [Adafruit](https://www.adafruit.com/product/3082) |
| Compute 32GB Class 10 microSD ×1 | $14.95 | C; [PiShop](https://www.pishop.us/product/microsd-card-32-gb-class-10-blank/) |
| Matek BEC12S-PRO compute regulator ×1 | $22.99 | F; in stock; [RaceDayQuads](https://www.racedayquads.com/products/matek-bec12s-pro-9-55v-to-5-8-12v-5a), [maker](https://www.mateksys.com/?portfolio=bec12s-pro) |
| Hobbywing 5A AIR peripheral regulator, SKU 30607000 ×1 | $13.99 | C; [Hobbywing](https://www.hobbywingdirect.com/products/ubec-5a-air) |
| DFRobot DFR1015 dedicated 3.3V IR regulator ×1 | $5.30 | C; [DFRobot](https://www.dfrobot.com/product-2599.html) |
| Adafruit #1967 mini pan/tilt with two micro servos ×1 | $18.95 | C; authorized offer; [DigiKey](https://www.digikey.com/en/products/detail/adafruit-industries-llc/1967/5154681), [maker specification](https://www.adafruit.com/product/1967) |
| Waveshare D500 LiDAR Kit ×1 | $95.99 | C; USB adapter/cable included; [Waveshare](https://www.waveshare.com/d500-lidar-kit.htm) |
| TFmini-S downward ranger ×1 | $49.99 | C; [Waveshare](https://www.waveshare.com/tfmini-s-lidar-range-sensor.htm) |
| Waveshare IR Board B ×2 at the two-unit $4.09 tier | $8.18 | C; [Waveshare](https://www.waveshare.com/infrared-led-board-b.htm) |
| Adafruit #5162 4W cool-white RGBW NeoPixel ×2 at $5.50 | $11.00 | F; in stock, replacing unavailable #5408; [Adafruit](https://www.adafruit.com/product/5162) |
| Adafruit #1663 three-pin JST-SM cable set ×1 | $1.50 | F; in stock; [Adafruit](https://www.adafruit.com/product/1663) |
| TI SN74AHCT125N level shifter ×1 | $0.95 | F; authorized stock; [DigiKey](https://www.digikey.com/en/products/detail/texas-instruments/SN74AHCT125N/375798) |
| Adafruit #2310 Perma-Proto HAT, no EEPROM ×1 | $4.95 | F; in stock, includes 2×20 header; Pi power and logic carrier; [Adafruit](https://www.adafruit.com/product/2310) |
| Adafruit #2776 5V spring-return solenoid ×1 | $4.95 | F; [Adafruit](https://www.adafruit.com/product/2776) |
| Pololu #2802 RC switch with 3A low-side MOSFET/flyback ×1 | $8.95 | F; rationed, backorders allowed; [Pololu](https://www.pololu.com/product/2802) |
| Pololu #1402 SPDT 16.7mm lever switches ×2 at $2.37 | $4.74 | F; backorders allowed; [Pololu](https://www.pololu.com/product/1402) |
| **Incremental M2–M5 named purchases** | **$357.28** | |
| **Whole-project named purchases** | **$1,375.84** | Before allowances, delivery, tax, rework, and compliance |

The custom charge lead retains the M6AC-compatible XT60 end because neither the M6AC page nor its manual establishes a 4mm-banana output. The examined $10 QS8-to-banana cable is therefore rejected. It never enters the aircraft flight-current path.

The flight-current order is `factory QS8F/8AWG pack → prewired QS8M/8AWG aircraft harness → INA positive shunt/direct negative → 8AWG → separate C110 positive and negative rails → short 10AWG pair → AIO`. All regulator inputs branch downstream of the INA. The two copper rails are each 0.125×0.375×2.0in; the pair cut from one foot of stock weighs approximately **27.5g before holes or trimming** by nominal geometry and copper density. This is a component mass, not an automatic 27.5g increase: the prior 100g harness/mount allocation already covered unnamed distribution material.

## Fabrication and support allowances

These amounts keep required work visible but are **engineering allowances, not vendor quotes or caps**. The exact result can be higher. Named hardware above must not be double-counted here.

| Obligation not yet reducible to a fixed delivered quote | Allowance |
|---|---:|
| Visible-light optics, cooling spreaders, glare shields, and attachments | $15.00 |
| Enclosed removable holder, hinge, captive retention, mechanical latch, two switch brackets, and materials for 250g cargo / 170g holder target | $40.00 |
| C110 bus: flame-retardant G10/FR4 carrier, vented polycarbonate touch guard, lugs/joints, strain relief, and insulating fasteners | $30.00 |
| Remaining sensor/camera/servo wiring, connectors, strain relief, fasteners, and mounts | $15.00 |
| 25.5mm AIO-to-frame rotated adapter, damping, and insulation | $10.00 |
| Tall-pack cradle, D500 mast, landing legs, TFmini clearance, and CG adjustment material | $20.00 |
| Lightweight Pi guard, fan bridge, and local fasteners | $15.00 |
| Metric hex drivers and prop-nut wrench not fixed by the fine-work kit | $15.00 |
| Heat-safe bench, ventilation, pliers, and insulation-shrinking resources | $45.00 |
| Scale, wind and surface-temperature measurement, and ground-distance marking resources | $45.00 |
| Phone/local-link accessory completion | $20.00 |
| **Fabrication/support allowances** | **$270.00** |

Both external BEC input branches use separately named 5A/32V fuses and holders. The fuses protect the 18AWG input branches against a bus-fed fault; they do not prove downstream load compatibility or replace the regulators' own output protections. The peripheral rail's final coincident servo/lamp/solenoid load remains a received-part test because the supplied #1967 servo variant/stall current is not fixed.

The $40 holder allowance does not prove that an ordinary-hand-removal-resistant enclosure can be built at that price or within 170g. A dimensioned design and an actual fabrication quote are still required. Paid engineering labor is excluded; this does not imply that qualified help is free.

## Delivered-cost scenario and reconciliation

| Layer | Current scenario |
|---|---:|
| Named purchases | $1,375.84 |
| Fabrication/support allowances | $270.00 |
| Delivery/battery-handling scenario | $75.00 |
| Illustrative tax/duty: 10% of preceding three rows, rounded up once | $172.09 |
| Initial rework/qualification reserve | $100.00 |
| Conditional compliance provision | $60.00 |
| **Planning scenario** | **$2,052.93** |

The delivery row is retained only for comparison with the August 31 scenario. It is unlikely to be a reliable checkout total across the many suppliers and a made-to-order battery. Destination, consolidated orders, hazardous-goods treatment, sales tax/duty, and legal requirements are unknown. The $60 compliance provision is not a claim of sufficiency for any jurisdiction.

| Change from August 31 | Named purchases | Full scenario |
|---|---:|---:|
| August 31 basis | $1,196.64 | $1,862.64 |
| September 3 basis | $1,375.84 | $2,052.93 |
| **Increase** | **$179.20** | **$190.29** |

Direct price/quantity savings are $25.06: APC bundles save $7.56, Pocket Crush saves $6.51, and deleting the duplicate heat-shrink assortment saves $10.99 because the Plusivo fine-work kit already includes heat shrink. The $204.26 of offsetting additions and current-price corrections close omitted interfaces and tooling. The largest is the $127.94 Hakko station-plus-tip line; tool wattage and tip width still do not certify joint workmanship.

## Substitutions examined

| Candidate | Cost effect | Result |
|---|---:|---|
| Current 6S2P P50B / XING 800KV / APC 7×4 near-candidate | Baseline | **REQUIRES PHYSICAL VALIDATION** — only examined combination with the frozen mechanical/current interfaces, but the moderate endurance sensitivity misses 20 minutes |
| EMAX Pro 2810 950KV + Nexus 5S2P P50B | About $58 named saving before secondary changes | **INCOMPATIBLE** — about 19.20 central useful minutes at endpoint; 128.126A rating screen exceeds both 110A QS8 and 120A pack statements; exact first-party motor geometry/resistance evidence incomplete |
| Nexus 5S3P or 6S3P variants | Higher pack price | **INCOMPATIBLE** — examined energy/control intersections fail because added pack mass consumes the energy gain |
| Matek FCHUB-12S V2 distribution | Would replace custom bus only if valid | **INCOMPATIBLE** — one 70A-continuous output is below the modeled 85.923A system corner; paralleling two outputs onto one AIO input is undocumented |
| QS8-to-4mm-banana charge cable | $3.66 more than the retained custom ground lead | **INCOMPATIBLE** — no authoritative M6AC 4mm-banana output interface was found |
| Adafruit #5408 natural-white lamp / #1787 AHCT carrier | Same lamp price / small carrier difference | **INCOMPATIBLE** — direct pages showed unavailable; #5162 plus SN74AHCT125N/#2310 is the current replacement |
| Cut cable from an official Pi USB-C supply | Small possible saving | **INCOMPATIBLE** — severing the cable removes the source-side USB-C power contract; Pi instead uses its documented 5V GPIO path through #2310 |

No global-minimum claim follows from a bounded catalog pass. Lower prices on cosmetically or nominally similar parts are not savings until current rating, mechanical fit, firmware features, interfaces, installed mass, and the endurance/control model all remain supported.

## Cost and mass gates before a shopping list can be frozen

The named ledger is sufficiently complete for specification and fabrication-drawing work, but **not for purchase authorization**:

1. Produce dimensioned drawings for the rotated AIO adapter, insulated C110 bus/guard, pack cradle/CG range, Pi guard, camera/pan-tilt/IR/light carrier, landing clearance, and recipient-verified cargo holder/latch.
2. Freeze the wire-by-wire cut lengths/connectors, joint geometry, strain relief, and common-ground scheme. Both external BEC input fuses are already exact named items; received load tests still govern whether their values or downstream distribution must change.
3. Reconcile mass once, without double-counting the old 100g harness/mount allowance. The two raw copper rails are about 27.5g; #2310, switches, guard, lugs, fuse holder, exact branch wire, and final fasteners must be weighed or sourced. The prior **1,897.251g** model predates this exact physical package and must not be silently reused as final mass.
4. Re-run propulsion/endurance/control with the reconciled mass. The current central 20.98-minute prediction passes narrowly; the 18.20-minute moderate case fails. Reserve and required active equipment remain fixed.
5. Obtain destination-specific checkout totals and the actual holder/fabrication quote. Replace the $75 shipping, 10% tax, $30 bus/support, $40 holder, and $60 compliance scenarios with actual values; do not force actual costs to fit them.
6. After the paper package is coherent, perform received-part, disconnected electrical, props-off rail/actuator, thermal/current/logged-sag, mass/CG, Q73, and Q74 acceptance work. Failed evidence triggers redesign; it does not authorize dropping features or reserve.

The ordinary kit meter is limited to continuity, voltage, and verified low-current checks. It is never inserted into the full propulsion path. INA/FC/ESC logs support bounded steady/startup/sag/thermal commissioning but do not prove sub-millisecond peaks. Fast diagnostic equipment remains a fault- or review-triggered quote, not assumed free access or an invented baseline charge.

## Provenance

Repository base for the research chain: `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. The working tree contains later uncommitted planning/research changes; the commit alone does not reproduce them.

| Local source | SHA-256 |
|---|---|
| `.scratch/biometric-guard-drone/map.md` | `DC527EC9B47691939498F71A28EA21CF30D0F728387EC0307C1A7D9AE6A6DBB1` |
| `.scratch/biometric-guard-drone/issues/10-milestone-ladder.md` | `0198CA4D93C85DE697853EE51152148F3B56BAA1E5A6C3014ECFD1EBC9DB99E3` |
| `docs/research/least-cost-bom-2026-08-31.md` | `F31FFA6C3EE4D48AFC7FC7714D0419BCFE646C241077A610832FCBAF50DC3E2E` |
| `docs/research/least-cost-power-path-2026-08-31.md` | `BAFCADB71A50CE52ECE1902A92DE5594CF32A6EF8E539DC3BC4B01CE70EAC84B` |
| `docs/research/least-cost-pan-tilt-supplement-2026-08-31.md` | `3EC437E33053BFB1B20F0B7608A48B53CF3399D11326AD66B05D5C0AD44A3A4C` |
| `docs/research/least-cost-integration-2026-08-31.md` | `D54DE67594BBE18E32FE49EB35EDF99AA2FEDB12F9F84C3AEF39EDB47026C122` |
| `docs/research/final-propulsion-optimization-2026-09-03.md` | `4CE1C362FC724CD37A89066903070198477BF5B5EDC1CD5178B7CC8D89690A52` |
| `docs/research/final-compatibility-audit-2026-09-03.md` | `AB32E06F4A2E1B5F1BE50EDFC48B9DD62E0207817FA21DB64AB97C8331395042` |

Same-day price and compatibility checks were coordinated with the propulsion and interface audits and independently reconciled arithmetically here. Prices can change after retrieval.
