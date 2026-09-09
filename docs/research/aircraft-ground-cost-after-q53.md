# Aircraft and ground costs after Q53

Checked **2026-08-30**. New, uncommitted research authored directly in the main checkout on `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`; that commit does not contain this report. No source worktree, purchase, installation, hardware access or flight test. Existing research and unrelated changes remain untouched.

## Finding and accounting boundary

**The concrete core/ground basket below is $552.64 before motors, two new flight packs, compute/video and unresolved integration items. It is a conservative priced candidate, not a demonstrated minimum or complete purchasable system.** Only $47.36 remains against $600, or $247.36 against the conditional $800 maximum, before those missing categories and delivery costs. This replaces the old partly estimated core basket for comparisons; do not add the old $504.31 again.

[Q53](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments) covers the **whole planned build**, including tools, radio, charger, initial spares and later capabilities. Future wear/repairs are separate, not free. Keep targeting $600; spending above it requires specific benefits, limitations and user approval, with $800 an absolute maximum. No package or expenditure is approved here.

## Exact-price ledger

USD sticker prices, before unknown shipping, tax, import charges and battery-shipping restrictions. Manufacturer/direct-seller pages and public variant metadata were checked; **A** means the exact variant was listed available, not inventory reserved or delivered compatibility established. **C** means conflicting availability. Product-family headline prices were not substituted for selected variants. US-plug pricing is a reference, not an inferred location or regulatory choice.

| Item and purchase quantity | Unit / extended | Stock; inclusion or boundary |
|---|---:|---|
| 1 [TBS Source One V6 7-inch DC frame](https://www.team-blacksheep.com/products/prod%3Asource1v6) | $35.95 | A; carbon frame and listed fasteners/standoffs/camera mount |
| 1 [TBS Lucid H7 Stack, 8S 60A](https://www.team-blacksheep.com/products/prod%3Alucid_h7_stack) | $109.95 | **C**; page says both preorder and in stock; FC plus four-in-one ESC |
| 1 [Pocket M2, Charcoal, ELRS](https://radiomasterrc.com/products/pocket-radio-controller-m2) | $71.50 | A for FCC/LBT; included USB-C cable, pouch and radio SD card; no cells |
| 1 [RP1 V2 ELRS 2.4GHz receiver](https://radiomasterrc.com/products/rp1-expresslrs-2-4ghz-nano-receiver) | $18.99 | A for FCC/LBT; antenna and CRSF wire included |
| 1 [RadioMaster 3200mAh 18650 two-pack](https://radiomasterrc.com/products/18650-3200mah-3-7v-battery-2pcs-for-tx16s-boxer-tx12-mt12-radios) | $11.99 | A; **two genuine radio cells**, not flight batteries |
| 1 [Holybro Micro M10, with case, IST8310](https://holybro.com/products/micro-m10-gps) | $27.99 | A, SKU 12044; GPS/compass and cables; FC adaptation/mount unresolved |
| 1 [ToolkitRC M6AC, US plug](https://www.toolkitrc.com/product/m6ac/) | $59.99 | A; built-in mains supply, AC cable and USB cable included; EU same price, UK/AU $60.99 |
| 1 [XT60-to-XT60/XT90 10cm charge extension](https://pyrodrone.com/products/xt60-to-xt60-xt90-10cm-extension-charge-cable) | $3.99 | A; additional charge lead, not another mains supply |
| 1 [JST-XH balance extension, 6S seven-pin, 200mm](https://pyrodrone.com/products/balance-lead-extension-cable-200mm-jst-xh-choose-cell-count) | $2.99 | A; exact 6S price, not cheaper 2S headline |
| 1 [FPV Freerider](https://fpv-freerider.itch.io/fpv-freerider) | $5.99 | Developer's paid Windows download; no installation or controller test |
| 1 [NewBeeDrone Tool Kit V1.7](https://pyrodrone.com/products/newbeedrone-tool-kit-v1-7) | $69.99 | A; iron, solder/flux, drivers, cutters, tweezers, prop wrench, case; see below |
| 1 [Sequre SQ001/TS100 power supply](https://pyrodrone.com/products/sequre-soldering-power-supply-for-sq001-ts100) | $14.99 | A; independent iron-power candidate; plug, polarity and mains-lead contents need confirmation |
| 1 [SparkFun basic multimeter TOL-12966](https://www.sparkfun.com/digital-multimeter-basic.html) | $21.50 | In stock; two probes and 9V battery included |
| 1 [VIFLY ShortSaver 2](https://rotorriot.com/products/shortsaver-2-smoke-stopper) | $14.99 | A; bench fault-current protection candidate, not an airborne component |
| 1 [Pyrodrone lunch-box LiPo bag](https://pyrodrone.com/products/pyrodrone-lipo-bag-lunch-box-style) | $11.99 | A; 8×6×6 inches; not guaranteed fire containment |
| 1 [SanDisk Edge 16GB Class 10 blank microSD](https://www.pishop.us/product/microsd-card-16-gb-class-10-blank/) | $13.95 | In stock; FC logging card, no adapter; separate from radio and compute cards |
| **3 sets** [Gemfan Flash 7042 two-blade, Ferrari Red](https://pyrodrone.com/products/gemfan-flash-7042-durable-2-blade-choose-color) | $4.99 / **$14.97** | A for red; each set 2CW+2CCW: one installed set plus two initial spare sets |
| 1 [24AWG silicone wire pair](https://pyrodrone.com/products/1ft-silicone-wire-choose-color-and-gauge) | $3.99 | A; 1m red + 1m black; small wiring only, not universal power wire |
| 1 [three-pack XT60/12AWG pigtails with 35V 1000µF capacitors](https://pyrodrone.com/products/black-xt60-lipo-pigtail-w-35v-1000uf-capacitor-12awg-3pcs) | $12.99 | A; 10cm each; one initial plus two spares, subject to stack contents/rating review |
| **3** [250×20mm Kevlar/rubber battery straps](https://pyrodrone.com/products/pyrodrone-kevlar-battery-strap-w-woven-rubber-grip-metal-buckle-250x20mm) | $2.99 / **$8.97** | A; two candidate working straps plus one spare; pack/frame fit unvalidated |
| 1 [3M CP5108 double-sided tape, 10mm × 3m](https://pyrodrone.com/products/heavy-duty-3m-black-double-sided-tape-choose-width) | $3.99 | A; small-component retention material, not sole battery restraint |
| 1 [530-piece heat-shrink assortment](https://pyrodrone.com/products/heat-shrink-tube-set-530pc) | $10.99 | A; 2–20mm assortment; insulation material, not a validated assembly method |
| **Core/ground subtotal** | **$552.64** | Conditional candidate, not complete-system total |
| Four motors + **two new** flight packs | **Elsewhere; not zero** | [Propulsion ledger](seven-inch-propulsion-after-q53.md); props counted only above |
| Compute, camera, cooling, regulator, compute storage and any reader | **Elsewhere; not zero** | [Compute/video ledger](compute-video-cost-after-q53.md); alternatives must not be added together |

## What still prevents calling this complete

**Tools:** The kit's itemized contents include 1.5/2/2.5mm hex drivers, Phillips driver, M5 ratchet prop wrench, wire cutters, tweezers, iron/holder/sponge, solder, flux, practice board and XT60 power cable. Generic marketing mentions pliers, but the itemized list does **not** establish general-purpose pliers or a wire stripper. Its iron needs external power. The priced Sequre supply's voltage/current and barrel dimensions are promising, not proof of polarity, included mains lead or a tested combination. Do not assume every required hand tool, heat-safe workspace, ventilation or insulation-shrinking provision is already owned. [Kit](https://pyrodrone.com/products/newbeedrone-tool-kit-v1-7), [supply](https://pyrodrone.com/products/sequre-soldering-power-supply-for-sq001-ts100)

The checked kit-plus-independent-supply route costs **$84.98**, before meter/protection/storage. The [manufacturer's V1.7 listing](https://newbeedrone.com/products/newbeedrone-tool-kit-v1-6) was also $69.99; its cheaper $11 adapter was unavailable. **No cheaper complete iron/tool route was validated in this bounded check.** The old $66 tool allowance is not evidence that one exists. Sharing an adjustable charger supply might avoid a second supply after electrical/cable and simultaneous-use review; it is not booked as a saving.

**Charging/storage:** M6AC mains and USB cables are supplied; the two extensions above are additional. Pack connector fit, polarity, balance access and bag reach remain unchecked. No parallel-charge board is assumed. Radio cells use the Pocket's charging facility, but the actual USB supply arrangement remains to be confirmed without automatically adding another charger. ShortSaver's advertised 7–25V/2–6S wording needs reconciliation at a fully charged 6S voltage; the H7 stack's 8S label does not make every accessory 8S-capable. A bag does not replace a suitable charging/storage plan. [M6AC](https://www.toolkitrc.com/product/m6ac/), [Pocket](https://radiomasterrc.com/products/pocket-radio-controller-m2), [ShortSaver](https://rotorriot.com/products/shortsaver-2-smoke-stopper)

**Airframe/firmware:** Frame and stack advertise compatible nominal mounting patterns, not verified clearance, vibration control, wiring or loaded balance. The stack listing does not clearly itemize every harness, capacitor and battery lead; verify supplied contents before removing apparent duplicates. Its 60A figure is time-qualified, not established indefinite continuous capability. ArduPilot documents a Lucid H7 target and external-compass need, but firmware support does **not** validate every arming path, biometric authorization, telemetry integration or later compute power. Preserve H7 pending those checks; no F4 substitution or safety bypass is justified by price. [Frame](https://www.team-blacksheep.com/products/prod%3Asource1v6), [stack](https://www.team-blacksheep.com/products/prod%3Alucid_h7_stack), [ArduPilot board documentation](https://ardupilot.org/copter/docs/common-tbs-lucidh7.html)

The propulsion research matches a nominal Gemfan 7042 two-blade designation, not yet this Flash SKU/revision; prop compatibility and loaded endurance remain unproven. Battery pads, GPS mounting, zip ties, exact connector adaptations, additional fasteners and later payload attachment/power harnesses remain **unpriced, not free**. Neither generic tape nor 24AWG wire certifies their suitability. A card reader, if needed, belongs **once** in the compute acquisition ledger and can serve the separate FC card; no reader is charged here. [Propulsion evidence](seven-inch-propulsion-after-q53.md), [compute boundaries](compute-video-cost-after-q53.md)

## One checked lower-cost alternative

[Pocket Crush M2 ELRS, Slate Grey](https://radiomasterrc.com/products/pocket-crush-radio-controller) is **$64.99**, with FCC/LBT variants listed available: **$6.51 less**, reducing this subtotal to **$546.13** if adopted. It includes USB cable/pouch and still requires the same two cells. This is an exact alternative to assess, not an approved radio change or a complete-budget solution. No second alternative is claimed without equivalent evidence.

Price checking establishes neither a currently fulfillable basket nor flight readiness. Simulator-first/native-Windows M1 remains; ROS/WSL, aircraft biometrics and autonomy are later work. No 1500mAh airtime assumption, performance target, legal permission or all-arming guarantee follows from this ledger.
