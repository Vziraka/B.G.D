# Cost-reduction check — 2026-08-30

Checked **2026-08-30**, after Q62, in the main checkout on branch `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. This is a **new, uncommitted research report**, not contained in that commit. Existing records were read and preserved. No purchase, checkout, account, installation, device operation, configuration, test or branch/worktree change occurred.

## Decisive finding

**No materially cheaper, validated complete-core route was established. One worthwhile new integration candidate saves $34.96 on controller/ESC sticker price, not enough to establish the complete project within $800.** Combined with the previously researched $14.99 charger/iron power-sharing option, the earlier incomplete Pi 4 comparison becomes **$807.92**, before adaptation, delivery, tax and still-unpriced required features. This is an arithmetic sensitivity, not a minimum possible price or a selected basket.

The $600 goal and conditional $800 absolute maximum still cover the complete M1–M5 build. Two **new LiPos**, onboard compute/camera, the selected independent radio, tools, protection and initial spares remain in the comparison. No cargo cap, reduced endurance, F4 controller, authorization bypass or phone-for-onboard substitution is proposed.

## One new candidate: integrated H743 controller and ESC

The manufacturer's **MicoAir743v2-AIO-45A**, **ArduPilot firmware variant**, is **$74.99**. Public product-variation data identifies **variation 3661**, `is_in_stock:true`, with **26 in stock** during this check. That establishes a seller-reported available exact variant, not reserved inventory or destination-specific delivery. The $109.95 Lucid H7 stack in the existing ledger is the alternative being replaced, not another purchase. [MicoAir direct listing](https://store.micoair.com/product/micoair743v2-aio-45a/)

The board combines an **STM32H743** flight controller, BMI088/BMI270 sensors, SPL06 barometer, microSD slot and four AM32 ESC channels advertised at **45A continuous each, 3–6S**. Manufacturer dimensions are 36×36×8mm, 10g, with **25.5mm mounting**. It has no built-in compass; retain the separate GPS/compass and onboard-compute regulator. This is not a lower-powered F4 flight-controller replacement. Accessory leads, capacitors and mounting pieces were not established as a complete itemized package; no baseline spares are deducted. [Manufacturer specifications and pinout](https://micoair.com/flightcontroller_micoair743v2_aio_45a/)

The manufacturer specifies the **`MicoAir743v2`** ArduPilot target—not the older `MicoAir743-AIO`. The current upstream hardware definition contains the corresponding H743, sensor and microSD support; the stable target's feature list includes scripting and SD-card storage. These are useful prerequisites, not proof that the exact installed release, all interfaces or biometric arming policy work. [Upstream hardware definition](https://raw.githubusercontent.com/ArduPilot/ardupilot/master/libraries/AP_HAL_ChibiOS/hwdef/MicoAir743v2/hwdef.dat), [stable feature manifest](https://firmware.ardupilot.org/Copter/stable/MicoAir743v2/features.txt)

### Compatibility conditions before treating the saving as real

- **Mounting:** the retained Source One V6 7-inch lists 20mm/30.5mm stack patterns, not 25.5mm. A suitable adapter, vibration isolation, fastening, clearance and wiring space remain unpriced. Do not assume drilling carbon or mounting on tape is an approved remedy. [Frame specifications](https://www.team-blacksheep.com/products/prod%3Asource1v6)
- **Electrical envelope:** advertised channel current is not measured thermal margin for the selected motors/props, enclosed airflow, fully charged pack or maneuver transients. AIO integration couples FC and ESC replacement/thermal concerns. Current limiting or weaker flight behavior must not silently compensate for an unsuitable board.
- **Pinout/revision:** use the AIO-specific connector map. The generic ArduPilot `MicoAir743v2` page describes a separate FC with different regulator/compass details; its default current-sensor scaling also differs from the AIO manufacturer's value. Confirm supplied revision, voltage rails, peripheral levels, battery-current measurement and firmware defaults. The AIO's 5V peripheral rail is not the Pi's automatically adequate power source. [AIO pinout](https://micoair.com/flightcontroller_micoair743v2_aio_45a/), [generic-target documentation](https://ardupilot.org/copter/docs/common-MicoAir743v2.html)
- **Authorization:** audit every new arming path, including radio requests, freshness/replay handling and missing/restarted authorization components. Scripting availability does not prove unavoidable owner face-and-voice enforcement. Independent manual takeover and safe landing once airborne remain intact. The existing gate-enforcement gap is not resolved by changing brands.

## Non-duplicated cost sensitivity

Unchanged prices below are carried from the same-day reports, **not rechecked as available purchases**. The baseline's motor/LiPo stock and performance qualifications remain. Shipping/tax are not known; no exact landed cost is claimed.

| Comparison | Core/ground | Motors + two new LiPos | Pi 4 compute/camera + one reader | Incomplete total |
|---|---:|---:|---:|---:|
| Existing conditional baseline | $552.64 | $167.94 | $137.29 | **$857.87** |
| Replace only $109.95 stack with $74.99 AIO | $517.68 | $167.94 | $137.29 | **$822.91** |
| Additionally share charger/iron power, conditionally | $502.69 | $167.94 | $137.29 | **$807.92** |

The third row saves **$49.95 total**, about 5.8% of the earlier comparison, but still exceeds $800 by **$7.92** and $600 by **$207.92** before missing obligations. It does **not** also subtract the older mixed-stack saving: those are mutually exclusive controller choices. The Pi 5 equivalent adds the existing $11 difference and retains its stock uncertainty.

Power sharing was already documented: the priced M6AC supply function and included iron cable could remove the separate $14.99 supply only after electrical verification, with soldering and charging separate. The full tool kit, meter, fault protection and charging/storage provisions remain. No owned/borrowed tool inventory is assumed. [Earlier power-sharing evidence](hardware-cost-options-after-q54.md)

## Bundle check and stopping boundary

The **HGLRC Nblade PRO Power Kit** was checked as a possible bundled saving. Its direct product page and exact Power Kit variant both price it at **$399.99**; variant **41153753841722** says available, while the rendered page also displays out-of-stock/preorder text. Treat availability as unresolved. A different zero-priced analog variant is **not a free complete kit**. Included equipment, assembly status and supplied revision were not sufficiently established to credit replacements; this is not a cheaper self-build recommendation. [Manufacturer page](https://www.hglrc.com/products/hglrc-nblade-pro-7-inch-dji-o4pro-long-battery-life-freestyle-cinematic-fpv-drone), [variant data](https://www.hglrc.com/products/hglrc-nblade-pro-7-inch-dji-o4pro-long-battery-life-freestyle-cinematic-fpv-drone.js)

**Still unpriced:** camera actuation/gimbal and mounts, navigation/avoidance coverage, IR and visible path lighting, the holder preventing ordinary hand-removal before recipient verification, release/enrollment security, further wiring/bench needs and possible iPhone integration/build fees. These are initial M2–M5 obligations, not future repairs. A generic latch or rangefinder does not establish the complete behavior.

The twenty-useful-minute no-extra-cargo requirement and separate return/landing reserve remain unvalidated. Higher-energy Li-ion examples in the earlier report are **unapproved substitutions** costing more and changing installed mass/current constraints; they are not included here. The new controller's smaller listed mass cannot be translated into safe cargo capacity without a complete measured mass/power ledger. No 250g, 500g or tentative 3lb carrying promise follows.

**Next engineering decision:** keep the AIO as a qualification candidate, not a purchase, and resolve its integration cost alongside the missing feature costs and propulsion evidence. This pass supports a larger controller saving than earlier $5–$10 substitutions, but not approval of $800 spending, a higher ceiling or a capability cut.

## Source-snapshot provenance

The following local source reports were uncommitted when read; SHA-256 values identify their exact snapshots. Current prices newly investigated above come from public manufacturer pages/metadata, not these hashes.

| Source | SHA-256 |
|---|---|
| [Complete-build synthesis](complete-build-feasibility-after-q53.md) | `C5DEAB04A94157AD8601194DB4420A5755652E10A76CC9440637261DC0A797D9` |
| [Earlier hardware reductions](hardware-cost-options-after-q54.md) | `7B967BE94A6A488FA502C162D6762AF2DDF2B3E14890B68D80566F77F1684B04` |
| [Endurance/cargo directions](endurance-cargo-options-after-q54.md) | `C052A86F9E84E49BE7B38EFE383E7AAC2BE16DD9C66C8C127A398ACEB927B2F3` |
| [Aircraft/ground ledger](aircraft-ground-cost-after-q53.md) | `276967BC0DE19A1311C088744385122714BBF08D387D8ECDFBE0B54464725B57` |
| [Compute/video ledger](compute-video-cost-after-q53.md) | `942E3E932335E0E056CABCEF1C985D0F28D477FBB8BE2FD0F4D4F447B8E7029A` |
