# Hardware cost options after Q54

> **Decision update through Q58 — 2026-08-30:** Recipient face verification, protection against ordinary manual cargo removal before verification, and a landed, motors-stopped first handoff are required. The first version then stays disarmed for someone to carry the drone back. Earlier conditional delivery wording below is historical; necessary holder/release hardware remains inside the complete-build scope. Its design, force/theft resistance and capacity remain open. This update does not revalidate prices or select a mechanism. See [ticket 10's latest comments](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

Checked **2026-08-30**. Bounded primary-source research, authored uncommitted in the main checkout on `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`; that commit does not contain this report. No purchase, installation, hardware configuration or test. Existing work is preserved.

Source snapshots used: [aircraft/ground baseline](aircraft-ground-cost-after-q53.md), SHA-256 `276967BC0DE19A1311C088744385122714BBF08D387D8ECDFBE0B54464725B57`; [complete-build synthesis](complete-build-feasibility-after-q53.md), SHA-256 `C5DEAB04A94157AD8601194DB4420A5755652E10A76CC9440637261DC0A797D9`. These source reports are also uncommitted. Public product HTML/variant metadata and official documentation were read; no checkout was initiated.

## Result

**Only modest conditional savings were supported. Reusing the already-priced charger to power the existing soldering kit can avoid $14.99. A mixed H7 controller/ESC costs $9.97 less before extra integration costs, but is not recommended yet.** Even crediting both leaves the earlier incomplete Pi 4 comparison at **$832.91**, above $800 before unresolved features, shipping and tax. This is not a lower bound on every possible design.

The chosen Pocket ELRS and its cells are unchanged. The $600 goal and conditional $800 absolute maximum cover the complete planned project, including secure delivery hardware if retained by the delivery decision. Future maintenance remains separate. No capabilities, initial tools, spares or reserve requirements have been deleted to manufacture a fit.

## 1. Reuse the M6AC's power-supply function

The existing **$59.99 M6AC** has an adjustable constant-voltage/current output; the official manual specifies 1–28V and 0.5–15A. The manufacturer page separately specifies **100W on AC**: do not apply the 300W DC-input headline to mains operation. Its included AC cable supplies the mains connection. [Manufacturer page](https://www.toolkitrc.com/product/m6ac/), [official manual, printed pp. 6, 30 and 37](https://download.toolkitrc.com/wp-content/uploads/2024/12/M6AC-Manual-V1.0.pdf)

The retained **NewBeeDrone V1.7 kit, $69.99**, includes its iron's XT60 power cable. The manufacturer specifies 65W, DC12–27V and a centre-positive 5.5×2.5mm input. This gives a credible electrical basis for sharing the charger instead of purchasing the baseline $14.99 Sequre wall supply. The kit includes the same solder, flux, iron stand, practice board and hand tools as before; none is removed. Pyrodrone's public product JSON reported `price:6999, available:true` for its sole default variant during this check. [Manufacturer kit specifications](https://newbeedrone.com/collections/newbeedrone/products/newbeedrone-tool-kit-v1-6), [retailer listing](https://pyrodrone.com/products/newbeedrone-tool-kit-v1-7)

**Saving: $14.99; conditional core/ground subtotal $537.65.** This is an engineering candidate, not a tested connection or setup instruction. Verify actual output, polarity, cable rating and startup behaviour before use. Charging and soldering use the same main output and must be separate activities; do not split it between a battery and iron. Retain the meter, fault-current protection, battery provisions and safe soldering workspace. The kit's unresolved pliers/stripping/ventilation needs remain. Product pages do not establish a safe complete workbench.

## 2. Lower-cost H7 controller plus a separate ESC

| Exact item | Current displayed USD price and availability | Included / relevant evidence |
| --- | ---: | --- |
| SEQURE H743 V2, SKU CPFKSQH743V2 | **$59.99**, explicitly in stock | FC, 8-pin and two 4-pin cables, buzzer, damping pieces; ICM42688P, barometer, 16MB onboard logging flash, 30.5mm mounting option |
| FLYWOO GOKU G55M, AM32 option, family SKU FW19003605 | **$39.99**, AM32 shown with Add to cart; no reserved stock or checkout confirmation | Four-in-one ESC, connection cable, capacitor, XT60 lead, damping pieces; 3–6S, advertised 55A continuous, 30.5mm mounting |
| Pair | **$99.98** | **$9.97 below** the baseline $109.95 TBS Lucid H7 stack, before adaptations |

Sources: [SEQURE direct listing](https://sequremall.com/products/sequre-h743-v2-fc-4-8s-dual-bec-x8-freestyle), [FLYWOO direct ESC listing](https://flywoo.net/products/goku-g55m-32bit-128k-3-6s-45a-esc-30.5x30.5-). The latter URL contains “45a,” but the page title, description and specification table identify **G55M 55A**; verify the actual supplied revision. The FC's older indexed $41.99 price was contradicted by its opened $59.99 page and is **not used**.

ArduPilot's own board README identifies both SequreH743 revisions, CRSF input, DShot outputs and external-compass support. Its current hardware definition includes the ICM42688 and onboard dataflash logging. That is stronger evidence than the vendor's generic ArduPilot claim, but it does not prove all planned features. [ArduPilot board README](https://raw.githubusercontent.com/ArduPilot/ardupilot/master/libraries/AP_HAL_ChibiOS/hwdef/SequreH743/README.md), [hardware definition](https://raw.githubusercontent.com/ArduPilot/ardupilot/master/libraries/AP_HAL_ChibiOS/hwdef/SequreH743/hwdef.dat)

**Do not select this pair yet.** Equal mounting pitch and compatible nominal voltage are not matching connector pinouts, current-sensor calibration or motor/ESC validation. The mixed harness and mechanical clearance need checking. Onboard dataflash is not interchangeable with an SD filesystem for scripts; logging capacity, script deployment and the later all-arming authorization design must be evaluated before treating this as equivalent to the Lucid. No SD-card saving is credited and no safety gate is bypassed. Supplied capacitor/XT60 contents are identified, but the baseline spare pigtail/capacitor purchase is not deducted a second time.

As a cross-check, the complete FLYWOO H743 Pro 55A stack is displayed at **$109.99**, essentially the baseline's price; its collection's “from $39.99” is an ESC-only variant, not a $39.99 H7 stack. [Complete stack and variants](https://www.flywoo.net/products/goku-h743-pro-55a-32bit-128k-30x30-stack-plug-play-o4-o4-pro)

## Accounting and next decision

| Sensitivity comparison, not a selected basket | Core/ground | Earlier partial Pi 4 route | Earlier partial Pi 5 route |
| --- | ---: | ---: | ---: |
| Existing baseline | $552.64 | $857.87 | $868.87 |
| Charger/iron sharing only | $537.65 | $842.88 | $853.88 |
| Sharing plus mixed-stack sticker difference | $527.68 | $832.91 | $843.91 |

Motors, two new flight packs, compute, camera, regulators and the one shared card reader are held at the earlier comparison amounts, not revalidated or counted again. The mixed-stack row deliberately retains baseline allowances until replacement obligations are known; it is not an exact revised shopping list. Delivery verification/release, avoidance, camera movement, lighting, phone integration, hardening, mounting, bench needs and transport charges remain unpriced where previously unresolved.

**Justified next step:** keep charger power sharing as a cost-reduction candidate, but do not ask the user to approve a complete hardware purchase or lower a capability based on these small savings. Clarify delivery's retained recipient-verification/release behaviour, then include its actual hardware and mass in the same full-project comparison. The evidence supports further architecture/capacity work; it does not support promising 3 lb, twenty useful minutes plus reserve, or a complete $800 fit.
