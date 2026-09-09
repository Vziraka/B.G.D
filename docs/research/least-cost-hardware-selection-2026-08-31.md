# Issue 10 — least-cost defensible hardware proposal

Prepared **2026-08-31**, continuing the approved `grill-with-docs` planning work. **Research and engineering proposal only: no purchase, aircraft operation or PC-ticket implementation.** Decisions Q1–Q74 remain authoritative.

## Result

The least expensive combined design supported by this bounded comparison is **$1,196.64 in named purchases**, or **$1,862.64 for the complete initial-project planning scenario**. It retains the requested hardware capabilities, corrects the previous XT60 current bottleneck and has a conditional paper intersection between endurance, battery sag and control authority. It is **not a configuration meeting every approved constraint**: the complete scenario exceeds the unchanged **$900 maximum by $962.64**, and measured performance remains unproven. No complete compliant $900 configuration was found; this is not proof that none can exist.

The final proposal uses the original lower-current **800KV / APC7×4** propulsion, a factory high-current battery path, and **77g less housing/camera-mount mass without dropping functions or consuming contingency**. The final model estimates **about 21 useful minutes plus a separate reserve**. A moderate-loss case estimates only **18.2 minutes**. This is a technically defensible development candidate with limited performance margin, not a robust endurance guarantee or an approved shopping list.

The cheaper $1,679.28 historical comparison cannot be reused after simply renaming its connector. Its factory battery current path was not qualified, and its mass/endurance assumptions do not describe this design. During this pass, a heavier 1,974g/7×4 draft also failed a coupled voltage-sag/control check; a same-price 7×5 alternative failed the retained current-margin screen. Those findings caused an actual mass/layout redesign, not a weaker reserve or current criterion.

## Final proposed hardware

| Subsystem | Exact proposed selection | Why this selection matters |
|---|---|---|
| Frame | TBS Source One V6 seven-inch DC | Preserves the approved self-build size; actual manufacturer CAD supplies rotor spacing and mounting geometry. |
| Flight controller / ESC | MicoAir743v2-AIO45A, ArduPilot variant; mounting adapter | H743, logging, scripting, serial ports and separate servo outputs; 45A per motor channel. |
| Motors / props | Four iFlight XING-E2809 **800KV**; two APC7×4E and two APC7×4EP installed; one complete spare set | Lower-current propulsion with published motor parameters and manufacturer-computed propeller data. Other windings/prop families are not interchangeable. |
| Flight battery | One factory Nexus **6S2P Molicel P50B 10Ah**, **QS8 female / 8AWG**, seven-pin JST-XH balance lead | Named factory option with pack-level current data; no user battery rebuilding or series XT60 bottleneck. |
| Main power / measurement | Matching QS8, short 8AWG, Matek I2C-INA-BM, Panasonic 35V/1000µF capacitor | Every branch lies downstream of the shunt so energy accounting includes compute, lighting and conversion losses. |
| Independent radio / navigation | RadioMaster Pocket **ELRS**, RP1V2, radio cells; Holybro Micro M10/IST8310 | Preserves independent manual control, GNSS and compass. |
| Companion computer | Pi4 **2GB**, 32GB microSD; Adafruit3368 fan, Adafruit3082 heatsink, fabricated insulating base and vented guard | Same compute class with a concrete **70g** assembly allocation replacing the earlier broad 105g case/cooling allocation. |
| Camera / movement | Camera Module3 NoIR; **Adafruit1967** two-servo pan/tilt plus 3g carrier; direct FC PWM5/6 | Retains two-axis movement at **40g** versus 82g; no separate Pi HAT/PWM board required. |
| Sensing | D500 horizontal LiDAR and downward TFmini-S | Both retained; their presence does not prove arbitrary obstacle avoidance or safe-terrain recognition. |
| Power rails | Matek BEC12S-PRO for compute; Hobbywing5A AIR at 5.0V for peripherals; DFR1015 at 3.3V from the FC's 12V rail for IR | Correct device voltages, separate supplies and no Pi/peripheral back-feed. Camera3 mounting holes are not IR power terminals. |
| Night / delivery | Visible and IR emitters, drivers; recipient-verified enclosed removable holder, mechanical latch, landed/motors-stopped release | Full requested scope stays costed. Initial cargo target is **250g including packaging**, plus a **170g provisional holder**. |
| Ground / initial build | Charger, low-current charge adapter, simulator, soldering/meter kit, protection and hand tools, initial spares, fabrication and measurement resources | Complete-project accounting; nothing assumes an owned printer, laboratory oscilloscope or experienced helper. |

The [complete BOM](least-cost-bom-2026-08-31.md) contains exact quantities, prices, seller links, availability qualifications and allowances. The [installed layout](least-cost-integration-2026-08-31.md) contains geometry, structural allocations, wiring and the verified firmware feature baseline. The [camera-mount supplement](least-cost-pan-tilt-supplement-2026-08-31.md) documents the lighter assembly and PWM mapping.

## Complete cost against $900

| Cost category | USD |
|---|---:|
| Named component/tool purchases | **1,196.64** |
| Explicit fabrication, integration and missing-resource allowances | 276.21 |
| Parts plus completion | **1,472.85** |
| Shipping / battery-handling scenario | 75.00 |
| Illustrative tax / duty | 154.79 |
| Initial rework / qualification reserve | 100.00 |
| Conditional compliance provision | 60.00 |
| **Complete initial M1–M5 scenario** | **1,862.64** |
| **Over the approved $900 maximum** | **962.64** |

The M1/reusable allocation is **$1,300.21**, with **$562.43** in later additions. Staging does not make $900 an M1-only budget. Even named purchases alone are $296.64 above $900. Tax, delivery, fabrication and compliance are transparent planning assumptions, not delivered quotes or proof of legal sufficiency. Necessary recurring service charges are not silently authorized; Q72's free-quota phone-build evaluation remains the selected direction.

The reduced inventory keeps one installed and one spare prop set; two spare sets were an earlier research assumption, not a user requirement. A 32GB card replaces the unneeded assumed 64GB purchase, subject to an explicit OS/model/application/storage budget. Conversely, the lighter camera mount and fabricated Pi guard add some cost to obtain a supported mass reduction. Deleting those parts or the uncertainty allowances would produce a misleading comparison.

An unverified alternate motor offer could save another $24 before tax, but is **not credited** in the primary figure. No global price minimum, free supplier modification, used-part availability or free test-equipment loan is asserted.

## Power-path correction

The previous factory XT60H path had a published **35A** rating under specified test conditions against a four-motor table maximum of **113.88A before auxiliary loads**. A larger downstream adapter cannot remove that bottleneck.

The final arrangement is:

```text
Factory P50B pack, QS8/8AWG
  -> matching QS8 -> short 8AWG -> INA-BM shunt
  -> ESC and every regulator/accessory branch
```

The final 7×4 motor model gives **60.99A** centrally at full command and full-charge voltage, and **81.92A** at the stated unfavorable parameter corner. Add **4A total auxiliary battery input**: **85.92A**. The retained engineering screen requires each series component's applicable continuous rating to exceed that corner by 25%, or **107.40A**. The conservative **110A QS8**, **120A factory pack**, **150A shunt** and specified wiring pass that numerical screen. This extra margin is an engineering choice, not a universal safety standard or a hardware-enforced current limit. [Factory configuration](https://nexusbatterysystems.com/products/6s2p-p50b), [QS8 continuous rating](https://www.mgm-controllers.com/qs8-connectors), [INA-BM](https://www.mateksys.com/?portfolio=i2c-ina-bm).

The fix does not rely on a delayed current governor, battery C-rating or a claimed connector burst rating. Manufacturer thermal conditions, installed joints, cooling and actual repeated-duty behavior still matter. The ground QS8-to-XT60 adapter is **charge-only**, proposed at no more than 5A, and is absent from the flight discharge path. The [power report](least-cost-power-path-2026-08-31.md) documents ratings, source evidence, instrumentation limits and failure gates.

## Endurance, voltage sag and cargo

| Final modeled quantity | Result / limitation |
|---|---|
| Fully equipped ordinary mass | **1,897.25g**; includes 50g integration contingency, 30g configured-pack uncertainty, structural/harness allocations and every required installed subsystem |
| Loaded design mass | **2,317.25g** including 250g cargo and 170g holder |
| Ordinary central mission demand | **354.54W** with the stated mission/installation and electronics allowances |
| Ordinary usable-energy hypothesis | **148Wh** to the selected 19.6V reference-curve endpoint, after a graphical/pack uncertainty allowance; not 80–85% of nameplate energy by assumption |
| Protected reserve | Q74 unchanged: greater of **20Wh** or **1.5× recovery energy**; the initial model uses 120 seconds of recovery and a separate 4Wh pre-reference allowance |
| Ordinary central useful time | **20.98 minutes**, with the modeled reserve remaining |
| Moderate-loss useful time | **18.20 minutes** — fails the requirement; sensitivity, not a measured result |
| Additional 100g / unfavorable-loss case | **13.64 minutes** — fails; no permission to carry excess mass without redesign |
| Coupled endpoint control screen | 19.6V on the 10A/cell reference curve becomes about **18.45V under the modeled full maneuver demand**, including all 4A auxiliaries and extra dynamic resistance; weak-corner thrust/weight is **1.375**, above the provisional 1.35 screening target |
| Loaded endpoint / duration | Separate 21.7V reference-curve point, about 20.42V under modeled maneuver load, weak-corner thrust/weight **1.368**; **about 7.4 useful minutes** with a separate reserve under the provisional 83Wh loaded energy allowance |

The endpoint calculation couples voltage to current at the same battery state rather than combining a low-current energy curve with unrealistically stiff full-throttle voltage. Cell resistance is still a sensitivity assumption, not a measured factory-pack envelope. Propeller data are **manufacturer-computed aerodynamics**, combined with an approximate motor model; they are not a matched bench test of this aircraft. [Full reproducible model and caveats](least-cost-propulsion-2026-08-31.md), [Molicel source discharge curves](https://www.molicel.com/wp-content/uploads/Product-Data-Sheet-of-INR-21700-P50B-80122.pdf).

With 148Wh usable and a 20Wh reserve, the practical twenty-minute power budget is **372W** after the separate 4Wh allowance. The central estimate leaves only **17.46W**. If the required recovery reserve rises to 25Wh, the budget falls to 357W. This makes measured power, usable energy and actual recovery authority explicit acceptance obligations; a twenty-minute timer alone cannot pass Q74. The voltages above are calculation reference points, **not instructions to set low-battery failsafes**.

The 250g target is preserved, but neither its safe capacity nor a delivery range is certified. No twenty-minute loaded-flight requirement was approved. Night lighting, greater range, a different pack, different mounts or loaded flight require their own qualified envelope; no feature is deleted merely because its physical evidence comes later.

## Disposition of issue 10

| Item | Classification and current disposition |
|---|---|
| Hardware comparison, exact factory power-path fix, mass/layout and interface proposal | **Answerable now — supplied as a coherent conditional proposal.** Final user selection and specification freeze have not occurred. |
| Complete $900 affordability | **Answerable now — unresolved.** This candidate exceeds it. No budget increase, capability cut or staged-budget reinterpretation is adopted. |
| M1 and endurance acceptance definitions | **Answerable now — already resolved by Q73/Q74.** Do not re-ask them. |
| Detailed M1 fabrication/wiring, rail fault behavior, configuration-specific temperature/energy limits and monitoring-loss handling | **Answerable now — aircraft specification work before assembly/activation.** This is not a claim that all implementation drawings already exist. |
| Detailed M2–M5 behaviors previously deferred | **Answerable now — named later-spec gates**, as already recorded; not forgotten requirements or physical unknowns. |
| Actual mass/CG/clearance, workmanship, temperatures, current/energy, recovery/control, Q73/Q74 results | **Requires physical validation — explicitly deferred** to V09–V11, V19/V26 and affected configuration-change gates. |
| Actual camera/phone/biometric/link/sensing/night/250g delivery results | **Requires physical validation — explicitly deferred** to the corresponding V12–V37 gates, after their software/specification prerequisites. |

The existing [40-item validation register](issue10-validation-register-2026-08-30.md) remains the acceptance and release record. As-built changes must update cost, mass, power and affected tests together (V39/V40). Ordinary low-current installation checks and sampled flight logs do not prove sub-millisecond voltage/current transients; the power report specifies what baseline instrumentation establishes and when further diagnostics must be quoted and planned.

**Issue 10 remains claimed.** The missing $900 fit and final hardware selection are actual planning issues; an unbuilt aircraft is not the reason to keep it open. This result advances P02 from a known incompatible path to a specific candidate, but it does not authorize declaring all requirements locked or purchasing it. The eight PC implementation tickets remain outside this task.

## Verification and provenance

Research was delegated under the active research/grilling skills and reconciled in the main checkout. The parent independently reproduced the named-cost totals, mass arithmetic, APC-based central power, upper-current corner, coupled endpoint thrust/voltage and reserve-duration arithmetic. Manufacturer CAD was parsed and visually inspected; firmware feature support and PWM timer grouping were checked at the recorded release commit. Source limits and graphical approximations remain explicit.

Base commit: `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`; these new reports are **uncommitted** and that commit does not contain them. No PC code or tickets were implemented by this planning work; concurrent workspace changes belong to their existing owners. No cart submission, supplier message, purchase, firmware upload, capture, powered test, staging or commit occurred.
