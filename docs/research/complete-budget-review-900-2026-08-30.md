# Complete-build budget review at the new $900 ceiling

Checked **2026-08-30** in the main checkout, branch `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. This is new, uncommitted decision support, not contained in that commit. Existing reports were read without modification. Public product pages/metadata and official documentation were checked; no checkout, purchase, contact, installation, capture, account change, hardware operation or flight occurred.

The user's latest instruction, **“I think 800-900 is fine now … lets continue and finish up all the agenda,”** replaces the former conditional $800 maximum with an accepted **$800–$900 planning range and $900 ceiling** for the complete initial M1–M5 build. It is not a minimum spend, selected basket or purchase authorization. Tools, radio, charger, initial spares, necessary integration/development costs and later requested capabilities remain inside that boundary. Future repairs remain separate; required recurring service costs remain visible and unselected. Recipient verification and protection against ordinary cargo removal remain required.

## Decision

**A complete, procurable and capability-supported build within $900 is still not established.** The existing conditional $807.92 comparison leaves **$92.08**, but contains unavailable exact motor/battery variants and omits several complete subsystems. This report completes the obligation ledger, not a falsely complete shopping basket. It does not establish that every redesign must exceed $900.

Two independent checks expose the remaining gap:

- The examined Windows-to-iPhone native build route adds **$99 for the first Apple Developer membership year**, making the inherited partial comparison **$906.92 before the missing physical features**. It is conditional, not a universally mandatory fee or adopted architecture. [Apple membership](https://developer.apple.com/support/compare-memberships/), [Expo build setup](https://docs.expo.dev/build/setup/)
- Cheap individual examples for camera movement, one narrow range sensor, one infrared emitter, one visible emitter and a lock actuator add **$93.88**, making **$901.80 before phone signing, enclosure, adaptations, adequate sensor/lighting coverage, shipping/tax or an endurance-improving battery change**. These are deliberately unqualified building blocks, including unavailable/heavy components, not a proposed system, lower bound or claimed solution.

Increasing the ceiling removes the old $7.92 arithmetic overrun; it does not resolve missing subsystem designs, procurement or endurance.

## Reconciled inherited cost ledger

All amounts are USD sticker/reference prices. **R** means rechecked in this pass. **H** means carried from the linked same-day source snapshot and not freshly revalidated here. Listed stock never means reserved inventory, delivered cost or established compatibility. US/EU variants are source references; no user location is inferred or requested.

The component-level ground ledger and compute ledger retain their individual primary links and quantities: [aircraft/ground](aircraft-ground-cost-after-q53.md), [compute/video](compute-video-cost-after-q53.md). Groups below neither omit their items nor count alternatives twice.

| Obligation / exact quantity | Extended price | Evidence and boundary |
|---|---:|---|
| Source One V6 7-inch DC frame ×1 | $35.95 | H; mounting/clearance not qualified |
| MicoAir743v2-AIO-45A, ArduPilot ×1 | $74.99 | R; exact variation 3661 reports in stock, 26 units; replaces the prior $109.95 stack |
| Pocket M2 ELRS ×1 + RP1 V2 ELRS ×1 + radio 18650 pair ×1 | $102.48 | H; $71.50 + $18.99 + $11.99; independent radio retained |
| Holybro Micro M10 GPS/compass ×1 | $27.99 | H; adaptations/mounts not included |
| ToolkitRC M6AC ×1 + XT60/90 charge extension ×1 + 6S balance extension ×1 | $66.97 | H; $59.99 + $3.99 + $2.99 |
| FPV Freerider Windows license ×1 | $5.99 | H; practice direction, not installed/tested |
| NewBeeDrone V1.7 tool kit ×1 | $69.99 | H; includes iron and specified basic tools/consumables, not every workspace provision |
| Basic multimeter ×1 + ShortSaver 2 ×1 + LiPo bag ×1 | $48.48 | H; $21.50 + $14.99 + $11.99; protection limits remain |
| FC microSD ×1 | $13.95 | H; separate from supplied radio card and compute card |
| Gemfan Flash 7042 prop sets ×3 | $14.97 | H; installed set + two spare sets; exact propulsion-table revision unconfirmed |
| Small wire, three XT60/capacitor pigtails, three straps, tape, heat-shrink assortment | $40.93 | H; $3.99 + $12.99 + $8.97 + $3.99 + $10.99; not universal harness/mount coverage |
| **Conditional core/ground subtotal** | **$502.69** | No separate $14.99 iron supply only if charger/iron power sharing is electrically verified; separate charging and soldering |
| EMAX ECO II 2807/1300KV motors ×4 | $77.96 | R; $19.49 each; exact 1300KV variant still unavailable at EMAX USA |
| CNHL 3300mAh 6S 40C flight LiPos ×2 | $89.98 | R; $44.99 each; US/global variants unavailable, EU available but delivery is destination-restricted |
| Pi 4 Model B 2GB ×1 | $55.00 | R; PiShop lists in stock; combined workload not tested |
| Camera Module 3 NoIR ×1; fan/heatsink ×1; matching case ×1 | $40.40 | H; $27.50 + $6.95 + $5.95; no camera movement/airframe attachment included |
| Compute 64GB card ×1 + Matek BEC12S-PRO ×1 + shared card reader ×1 | $41.89 | H; $19.95 + $18.99 + $2.95; reader counted once |
| **Inherited partial comparison** | **$807.92** | **Not complete, purchasable or mission-qualified** |
| **Room below $900 before all outstanding items** | **$92.08** | No shipping/tax, uncertainty reserve or missing-subsystem budget already hidden here |

Fresh primary checks: [MicoAir listing](https://store.micoair.com/product/micoair743v2-aio-45a/), [Pi 4](https://www.pishop.us/product/raspberry-pi-4-model-b-2gb/), [EMAX exact variants](https://shop.emax-usa.com/products/eco-ii-2807-brushless-motor-1300kv-1500kv-1700kv.js), [CNHL exact warehouse variants](https://chinahobbyline.com/products/cnhl-3300mah-22-2v-6s-40c-lipo-battery-with-xt60-plug.js), [CNHL shipping scope](https://chinahobbyline.com/products/cnhl-3300mah-22-2v-6s-40c-lipo-battery-with-xt60-plug).

The EMAX page's default stocked **1500KV** option is not the studied **1300KV** motor. Do not carry over its thrust/power evidence to a different winding. MicoAir's 25.5mm mounting remains incompatible with the frame's listed nominal stack patterns without an engineered adaptation. The controller saving cannot also include the mutually exclusive earlier mixed-stack saving. [Cost-reduction qualification](cost-reduction-options-2026-08-30.md)

## Missing physical obligations: priced examples versus actual designs

These examples show why “just add a cheap sensor/servo” does not complete the project. They are not selected replacements or approved performance limits. An unknown actual subsystem cost stays **unknown**, even when one constituent part has a price.

| Required obligation | Current component example | What remains unpriced/unproven |
|---|---|---|
| Camera aiming/actuation and mounting | [Adafruit pan/tilt kit 1967](https://www.adafruit.com/product/1967): **$18.95**, two servos, 37g; manufacturer out of stock | Not stabilized imaging or a qualified flight mount. Required motion range, vibration, camera flex-cable travel, driver outputs/power, structure and landing clearance still need design. No complete gimbal price established. |
| Required obstacle/terrain sensing | [Waveshare TFmini-S](https://www.waveshare.com/tfmini-s-lidar-range-sensor.htm): **$49.99**, seller structured data reports InStock | One narrow single-point beam is not surrounding collision avoidance or safe landing-site assessment. Coverage, stopping distances, blind spots, surface/light response, mounting and software remain. Sensor count/type cannot be inferred from one price. |
| Infrared illumination | [Waveshare IR LED Board B](https://www.waveshare.com/infrared-led-board-b.htm): **$4.49 each**, seller structured data reports InStock | Supplier's roughly 3m ideal imaging example is not approved mission coverage. Its screw-powered attachment targets listed Waveshare cameras, not proven Module 3 compatibility. Separate power, cooling, mounting and optical/eye-safety review required; quantity unresolved. |
| Visible path illumination | [Adafruit RGBW emitter 5408](https://www.adafruit.com/product/5408): **$5.50**, exact page lists two in stock | Advertised 4W total means **1W per colour channel**, not a 4W white flashlight. Beam optics, actual useful illuminance/range, thermal design, power and protective mount remain. Not a qualified navigation light or path-light system. |
| Cargo release actuator | [Adafruit lock-style solenoid 1512](https://www.adafruit.com/product/1512): **$14.95**, out of stock; **147.71g** | Bulky cost example, not recommended airborne latch. Needs driver/flyback protection and 9–12V supply. The actuator alone supplies no enclosure, retention or resistance to ordinary manual cargo removal. |
| Secure removable cargo holder and its permanent interfaces | **Unknown** beyond actuator examples | Enclosure/door, concealed retention, hinges, fasteners, anti-bypass mounting, latch/load geometry, closed/latched sensing as needed, wiring, fabrication/service cost, landing clearance and bench load testing. User owns no assumed 3D printer or workshop. |
| Recipient face verification | Reusing camera/compute is a candidate, **incremental cost unknown** | Recipient enrollment/authorization, usable capture geometry after landing, anti-spoofing, protected state and failed-verification behavior must work. No second camera automatically added or automatically unnecessary. |
| AIO/airframe/GPS/compute installation | **Unknown** | Adapter, isolation, appropriate fasteners, pads, extra cable gauges/connectors, peripheral rails and harness lengths. Existing tape/small wire is not a universal solution. |
| Bench/workspace completion | **Unknown** | Tool-kit gaps, heat-safe work area, ventilation, insulation shrinking, suitable supply sharing and exact device protection ratings. Do not assume these are already owned. |
| Command/video transport and phone accessories | **Unknown** | Shared Pi Wi-Fi/video is a candidate, not validated range/background voice or a completed ELRS bridge. Antenna/bridge/interface/charging additions depend on real design; existing phone/EarPods avoid only their duplicate purchase. |
| PC/onboard biometric hardening additions | **Unknown** | Existing PC hardware may suffice for research; camera access, model licensing, liveness security, performance and any needed extra sensors remain unproven. No cloud subscription or paid model automatically selected. |
| Shipping, tax, duties and battery delivery | **Unknown** | No destination collected and no checkout performed. Must be included before a purchase-ready total; cannot be charged to future upkeep. |

For TFmini-S, use the [manufacturer's datasheet](https://en.benewake.com/uploadfiles/2024/04/20240426140025367.pdf) for its single-point and surface/lighting-dependent range limits, rather than applying the seller's maximum distance to all obstacles. ArduPilot's [simple avoidance documentation](https://ardupilot.org/copter/docs/common-simple-object-avoidance.html) also distinguishes avoidance inputs and mode-specific behavior; firmware support is not a complete collision-protection claim.

**Cost sensitivity only:** one of each priced example above totals $93.88; $807.92 + $93.88 = **$901.80**. It still lacks much of each real subsystem and cannot be purchased as an available set. Replacing those examples may change the price and mass in either direction. This arithmetic is not a safe design, a minimum cost or a request to approve a $1.80 overrun.

Web extraction of the two Waveshare pages returned errors on direct reopening; their current public HTML was separately retrieved read-only and its USD price/InStock structured data inspected. Availability is still seller-reported only. No cart was changed.

## Battery/endurance and iPhone sensitivities

Two higher-energy battery alternatives remain **unapproved substitutions**. Fresh listings still show Flywoo P30B 6S2P 6000mAh at **$89.99/pack**, 596.2g (add-to-cart shown, no reserved quantity), and iFlight Fullsend 6S2P 8000mAh at **$83.99/pack**, 840g, in stock. Two-pack substitutions make the inherited partial total **$897.92** or **$885.92**, leaving $2.08 or $14.08 before missing initial features and delivered charges. Flywoo displays tax-included wording, but no destination-specific final price is established. [Flywoo](https://www.flywoo.net/products/flywoo-explorer-molicell-p30b-18650-6s2p-6000mah-lionpack-battery), [iFlight](https://shop.iflight.com/Fullsend-6S-8000mAh-Li-Ion-Battery-Pro1914)

The previous motor table and illustrative energy screen do not establish twenty useful minutes plus a separate return/landing reserve for any complete configuration. Battery current/revision/thermal limits, installed mass, actual workload and control margins require qualification; advertised capacity is insufficient. Removable delivery equipment reduces non-delivery carried mass only by what is actually removed, while permanent mounts/wiring and all other mission equipment remain. The full purchase cost still counts. [Endurance/cargo evidence](endurance-cargo-options-after-q54.md)

The examined native iPhone route can build from Windows through EAS, but physical-device signing requires paid Apple membership in that route. Apple currently lists **$99 per year**; its free Xcode Personal Team route has seven-day provisioning expiry, and there is no available Mac in the confirmed project context. EAS offers a free build plan; paid EAS usage must not be automatically added or unlimited free usage assumed. First-year signing, any build charges and visible renewal implications belong in the decision. [Expo prerequisites](https://docs.expo.dev/build/setup/), [Expo development builds](https://docs.expo.dev/develop/development-builds/introduction/), [Apple membership](https://developer.apple.com/support/compare-memberships/)

A website avoids native signing only if the actual required offline, locked/pocketed voice pipeline and local networking work; that equivalence is unproven. A native wrapper does not avoid signing. Online compilation does not itself require online operation. Neither a subscription nor a foreground-only downgrade is selected. [Existing phone feasibility report](iphone-handheld-feasibility.md)

## Engineering work versus human decisions

**Cheapest supportable next direction:** retain the lower-cost H743 AIO and shared Pi 4/camera/video topology as qualification candidates. They are the most concrete existing cost reductions, not an established cheapest complete design. Establish software/combined-workload feasibility using the existing PC and supported test methods before locking onboard hardware. Do not buy substitute motors, guessed sensors or a cheap latch just to make an arithmetic basket look complete.

Engineering owns the remaining component matching, offline/background phone proof, complete electrical/structural mass accounting, sensing/lighting envelope, secure-holder mechanism and procurement totals. It should bring a concrete design with explicit unresolved tests; the user should not be asked to invent amperage, reserve energy, a sensor count or safe cargo capacity.

The user's **budget answer is already settled**. No new human choice of parts, lower cargo capacity, deleted feature, chemistry, recurring fee or higher ceiling is inferred. Before hardware closure, a defensible complete comparison must identify any actual scope/fee tradeoff that needs a decision. This pass does not justify asking for another budget increase.

If the project wishes to start the independent PC phase while complete-aircraft feasibility remains unresolved, that is a **planning-gate change**, not evidence that the whole-project shopping list is finished. Present it explicitly for the controlling workflow decision; do not silently resolve issue 10 on the strength of the new cap. No performance claim can be signed off before its actual testing, but a future test obligation should also not be confused with a requirement to conduct flight tests before any specification can exist.

## Source provenance

These local source reports were uncommitted when read. SHA-256 identifies the exact supporting snapshots; current checks above are separately sourced to public primary pages/metadata. No other report, map, index or ticket was edited in this subtask.

| Local source | SHA-256 |
|---|---|
| [Cost reductions](cost-reduction-options-2026-08-30.md) | `6EB585981864B870EE500D49767DAD7D43157D09045CF0E4C443682CD88541F1` |
| [Aircraft/ground](aircraft-ground-cost-after-q53.md) | `276967BC0DE19A1311C088744385122714BBF08D387D8ECDFBE0B54464725B57` |
| [Compute/video](compute-video-cost-after-q53.md) | `942E3E932335E0E056CABCEF1C985D0F28D477FBB8BE2FD0F4D4F447B8E7029A` |
| [Propulsion](seven-inch-propulsion-after-q53.md) | `34521ECC8EE399A3DC00C88C5F83A4936D408B36909D9A07675A9A5E3B07C636` |
| [Endurance/cargo](endurance-cargo-options-after-q54.md) | `C052A86F9E84E49BE7B38EFE383E7AAC2BE16DD9C66C8C127A398ACEB927B2F3` |
| [iPhone feasibility](iphone-handheld-feasibility.md) | `2A7C775D56A78C3B8591EDCDAA471FF1F35F0893A1982C0326D4FEF58F743E22` |
