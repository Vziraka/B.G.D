# Issue 10 — factory battery and corrected complete power path

Research date: **2026-08-31**. Status: **engineering proposal, not a selected purchase or demonstrated flight capability**. This bounded research owns the battery, connectors, main harness and whole-battery measurement. Propulsion/endurance and the complete project ledger are coordinated separately. All Q1–Q74 requirements remain unchanged, including the $900 complete-project maximum, seven-inch self-build, all later features, Q74 endurance and 250g cargo target. No purchase, supplier contact, account action, battery modification, powered test or PC implementation was performed by this planning task.

**Final coordinated correction, same date:** retain7×4 propulsion and the original current-margin criterion, but replace the heavier pan/tilt and Pi enclosure/cooling with the documented lighter assemblies. The resulting fully equipped reference mass is **1,897.251g**, with the50g integration contingency and30g pack uncertainty allowance unchanged. The final coupled model uses a19.6V reference-curve endpoint,148Wh planning energy and the complete4A auxiliary corner; it predicts **354.540W average mission power**, approximately **20.98 useful minutes** centrally and **1.375 weak-corner endpoint thrust/weight**, while the85.923A current corner still passes the existing electrical screen. These are a **conditional paper-design result**, not achieved endurance, a robust guarantee across all sensitivity cases or an affordable$900 basket. The19.6V curve state is not a raw flight-controller cutoff instruction: the same state yields approximately18.454V under the separately modelled full-command current. Read the final [propulsion review](least-cost-propulsion-2026-08-31.md) for its coupled-sag assumptions, separate loaded case and downside cases.

The earlier heavier7×4 model failed its coupled endpoint screen. The7×5 response increased current and failed the unchanged margin rule. Those findings are retained below as rejected history; the constructive response is the documented77g mass reduction and consistent endpoint/energy calculation, **not a relaxed current criterion or deleted contingency**.

## Result

An actual factory-orderable correction exists: **Nexus 6S2P Molicel P50B pack with its factory QS8 female/8AWG option**, a matching QS8 aircraft connection, short 8AWG main conductors and an upstream Matek INA-BM current sensor. This removes the previous factory XT60 bottleneck. The replacement is not an XT60 adapter, an assumed high C-rating, or a delayed current limiter.

The coordinated XING-E 2809 800KV/APC 7×4E/EP propulsion calculation currently gives **60.986A** for four motors at maximum command and 25.2V in its central case; its stated adverse parameter corner gives **81.923A**. Adding **4A for every auxiliary input together** gives **85.923A**. This fits the proposed **88A total-battery engineering ceiling** and leaves 24.077A below the conservative **110A QS8 continuous basis**. Those are calculated loads, not measurements or a guarantee that every transient stays below them. The [propulsion report](least-cost-propulsion-2026-08-31.md) must preserve its parameter assumptions and show the loaded endpoint/control-authority and endurance calculations with the synchronized mass below.

This is a technically defensible candidate for continued design, not proof that the full project fits $900. It replaces the earlier generic need for an unspecified stronger battery with named parts and a bounded design. The complete-project cost and final selection remain the parent's responsibility.

**Common screening rule for this comparison:** require every series component's applicable continuous-current rating to be at least **1.25× the pessimistic modelled steady-current corner**, followed separately by transient and thermal validation. This25% rating headroom above demand is a conservative engineering choice for unmeasured propulsion, not a universal safety standard, statutory rule, user-approved flight limit or proof that a lesser margin would fail. The110A connector permits an88A design corner under this rule. At85.923A, the required rating is107.404A: QS8's110A, P50B pack's120A and the150A shunt pass the numerical screen, subject to their stated conditions.

**Independent review of the7×5 alternative:** its96.449A propulsion corner plus4A auxiliaries requires125.561A under the same rule. Both the110A connector and120A factory pack fail that margin screen; a connector-only upgrade would not suffice. Ordinary QS8-S is also rated110A continuous. The distinct, longer QS8-S+Plus has a published130–180A range, but it is not the named factory option already costed, and a120A P50B assembly would remain below125.561A. Nexus's generic “Other” connector field is not a priced, qualified QS8-S+ orQS10 factory configuration. [QS8-S manufacturer rating](https://www.youweic.com/QS8-S-110A-PG12007938), [distinct QS8-S+Plus](https://qselectronic.com/products/qs8-connector-longer-black-antispark-connector-high-current-connector-female).

The7×5 corner is below the110A absolute continuous figure, with about9.5% rating headroom above demand; that alone does not establish an adequate revised margin. The model's KV/resistance/propeller assumptions are sensitivity corners, not verified manufacturing bounds, and do not bound motor acceleration or model-form error. This review therefore **does not lower the25% criterion simply to obtain a pass**. This is not a claim that7×5 necessarily fails physically, nor that25% is immutable. No qualifying7×5 replacement was established. The final lighter7×4 design above retains the original rule and is the current coordinated candidate.

## Factory pack and public configuration

| Item | Public evidence and proposed use |
|---|---|
| Exact pack | Nexus `6s2p - P50B`, 12 Molicel P50B cells, 6S2P, 10Ah; $252 USD advertised |
| Energy/voltage | 216Wh typical; 25.2V maximum charge; manufacturer recommends 16.2V cutoff, 15V minimum. Neither is an automatic aircraft landing setting. |
| Pack current | Manufacturer publishes 120A maximum continuous; apply the cell's temperature condition and lower connector/design ceiling, not this number alone. |
| Factory choices | QS8 female with 8AWG discharge wires; balance leads, seven-pin JST-XH; no optional series BMS or separate charging port in this comparison |
| Size/mass | Approximately 139×48×72mm and 900g. Listed dimensions exclude the configurable internal cable; all stated dimensions/weights are approximate. |
| Availability | Public product available for ordering; approximately one-week build time, not ready-to-ship stock or a delivery promise |

[Nexus product and factory options](https://nexusbatterysystems.com/products/6s2p-p50b).

The read-only product JSON reported `price:25200`, `available:true`, tag `6s`, variant `46123739185410`. The page's public product-options data, set `1048204`, applies to the `6s` tag. Its QS8/8AWG and seven-pin JST-XH selections contain **no surcharge field**; optional BMS/extra-port choices explicitly contain separate prices. Thus $252 is the supported public configured subtotal for this proposal, rather than assuming a free custom modification. No cart or checkout was submitted. Shipping, tax, final availability and the final configured order still require ordinary procurement review. The JSON's 1,035g commerce weight is not substituted for the stated approximate installed mass. [Public product JSON](https://nexusbatterysystems.com/products/6s2p-p50b.js).

Molicel's version-1.1 cell sheet gives **18Wh typical, 17.5Wh minimum**, so twelve cells provide a **210Wh minimum-nameplate screening basis** before discharge-rate, temperature, aging, reserve and usable-capacity reductions. Its 60A continuous cell rating explicitly has an **80°C cutoff condition**; 2×60A is not an unconditional installed-pack temperature guarantee. The proposed 88A pack ceiling corresponds to 44A per equally sharing parallel cell, below that cell-current limit, but matching, internal heating and current sharing still require qualification. Do not plan to operate cells at 80°C. [Molicel P50B cell specification](https://www.molicel.com/wp-content/uploads/Product-Data-Sheet-of-INR-21700-P50B-80122.pdf).

**Endpoint consistency is mandatory:** if control authority requires a higher loaded battery endpoint, integrate usable energy only down to that endpoint. For example, 21V loaded means 3.5V per cell; it cannot automatically inherit 80–85% of a nameplate capacity specified down to 2.5V. The manufacturer's discharge curves and a conservative load model must support the energy estimate now, with installed validation later. A current-compatible pack alone does not settle twenty-minute feasibility.

The public pack assembly rating, selectable factory lead gauge and primary cell data are sufficient for this conservative paper selection. They do not require an endless demand for private weld drawings before writing specifications. Received construction, documentation, temperature behavior and electrical checks remain normal commissioning gates. If received documentation contradicts the design, stop and revise before power testing.

## Complete discharge topology and ratings

```text
Factory pack positive → factory QS8 / aircraft QS8 mate → 8AWG → INA-BM shunt
  → common positive distribution → ESC battery input
                                → compute regulator input
                                → peripheral/actuator regulator input
                                → every other battery-powered branch

Factory pack negative → QS8 mate → 8AWG → common return

INA-BM logic power from the regulated FC supply; I2C to the FC.
All battery-powered branches are downstream of the shunt.
```

| Element | Published basis | Engineering disposition |
|---|---|---|
| Factory P50B pack and 8AWG lead | 120A pack statement, temperature-conditioned cell data above | Proposed total limit 88A; do not infer unbounded pulse capability |
| Genuine QS8 mated connection | QS publishes 110–180A rated range, 8–12AWG wire and 36g per set; MGM explicitly lists 110A continuous | Use **110A**, not Nexus's 300A headline or an undurated peak claim |
| Main wire | DFRobot FIT0580, nominal 8AWG/10mm² silicone, claimed allowable 190A | Short 8AWG route, no 12AWG flight neck-down; installation/routing/joints still inspected and tested |
| Whole-pack sensor | Matek INA-BM: 150A continuous shunt, 200µΩ, 0–85V measurement, 4–9V logic supply | Adequate numerical headroom for the proposed path; it measures current, it is not an overcurrent breaker |
| Distribution and ESC input | Direct inspected conductor/terminal joints, controller/ESC selected in companion review | No unspecified small power board, connector or thin supplied pigtail may become a hidden series bottleneck |
| Regulators and other branches | Their own voltage/current/peak ratings; separate protected rails and common reference | All inputs counted within the 4A auxiliary allocation; outputs must not be accidentally paralleled/back-fed |

[QS connector manufacturer](https://qsconnector.com/products/qs8-anti-spark-connector), [MGM's explicit continuous QS8 rating](https://www.mgm-controllers.com/qs8-connectors), [DFRobot FIT0580](https://www.dfrobot.com/product-1756.html), [Matek INA-BM](https://www.mateksys.com/?portfolio=i2c-ina-bm).

The four-amp auxiliary ceiling is a **maximum coincident battery-input design allocation**, not a measured consumption figure or four amps per device. The final device/load ledger must include both regulator losses, FC, sensors, compute/camera/video, lighting and simultaneous servo/lock demand at the lowest allowed battery voltage. If that ledger exceeds 4A, recalculate the full current corner; do not silently discard a load. The endurance mission uses its separate measured/modelled average load.

All ordinary operating cases must remain inside the complete continuous ratings; no short-duration overrating is needed to justify the present candidate. The propulsion calculation must bound the expected full-command demand without depending on ArduPilot's delayed current governor. An additional operational current limit can provide supervision but cannot certify missing transient protection. Qualify motor/ESC heating over the real duty cycle separately; a current calculation does not establish an indefinite full-throttle motor rating.

## Sensor integration, layout and accounting

The INA-BM board is **27×20×6mm, 4g** and includes a 20cm JST-GH four-wire cable. Its high-current connection uses the two top-side conductive ends adjacent to the shunt; Matek explicitly warns that the large underside pad is electrically inactive. The final drawing must show actual solderable conductor placement close to the shunt, insulation, a supported nonconductive mount and strain relief; the tiny board must not carry connector/wire pull loads. Do not substitute soldering the underside pad or route high current through its signal connector. [Matek board and connection instructions](https://www.mateksys.com/?portfolio=i2c-ina-bm).

Allocate a short **0.20m maximum combined positive-plus-negative aircraft main-wire length** for this mass budget, including the shunt-to-distribution segment. This is a layout assumption, not an instruction to stretch or tension wires to meet a number. Longer routing requires revised mass/loss accounting. Reserve approximately **35×28×14mm** for the aircraft QS8 body plus a deliberate mating/unmating and bend area; confirm the actual connector drawing and factory cable exit against the frame layout. The nominal battery dimensions cannot be treated as a guaranteed exact fit. [A factory QS8 male pigtail's connector dimensions](https://maxamps.com/products/maxamps-qs8-male-connector-with-wirepigtail).

| Installed mass entry | Proposed model allowance | Basis |
|---|---:|---|
| Factory-configured pack | **930g** | 900g approximate product value +30g configuration uncertainty, not a measured extra harness |
| Aircraft QS8 male only | 25g | Engineering allowance; do not add the entire 36g pair when the pack already includes its female half |
| Main 8AWG conductors | 25g | Engineering allowance for combined 0.20m route |
| INA-BM | 4g | Published board mass |
| Sensor cable, insulation and main-harness strain relief | 11g | Engineering allowance |
| Installed capacitor | 5g | Engineering allowance for the named capacitor/attachment |
| **Aircraft main path including sensor/capacitor** | **70g** | Replaces the prior main-harness allowance; not an additional duplicate harness |

Any remaining local BEC/device harness and mounting allowances must be reconciled explicitly in the full model. The charge lead and spare capacitor stay on the ground. Reweigh the received pack and finished assembly; exceeding these allowances triggers a model/layout review before flight, rather than automatically rejecting a safe part or pretending the original mass still applies.

Use the upstream INA monitor as the whole-battery energy source. The MicoAir ESC's current channel may remain a secondary diagnostic, with its board-specific factor **14.14** checked against the incorrect shared-target assumption **40.2** described in the prior paper review. Do not add both readings as though they represented separate batteries. The shunt includes BEC losses because it measures their input current; it must not omit an independent branch wired directly to the battery. The chosen firmware must expose the INA2XX driver/I2C bus without a compass-address conflict. Pin mapping and sensor-loss behavior belong in the reviewed hardware specification, before assembly.

**Documented I2C address, not a completed installed-bus test:** Matek specifies **69 decimal /0x45 by default**, with **68/0x44 and65/0x41** alternatives. Its documented ArduPilot monitor is INA2XX/type21; address0 requests supported-address probing, not a physical device address of0. Confirm the received board's straps, actual compass revision/address, bus pull-ups/voltage and selected firmware driver before assembly. A documented nominal address difference is useful paper evidence; it does not prove that both installed devices communicate correctly. [Matek address/configuration specification](https://www.mateksys.com/?portfolio=i2c-ina-bm), [ArduPilot parameter definitions](https://autotest.ardupilot.org/Parameters/ArduPlane/Parameters.html).

The published stable Copter/MicoAir743v2 feature list checked on2026-08-31 contains `AP_BATTERY_INA2XX_ENABLED`. Driver availability is established for that checked build; pin/bus configuration and actual installed operation remain to verify. [Stable build feature list](https://firmware.ardupilot.org/Copter/stable/MicoAir743v2/features.txt).

## Power-block cost, without duplicate old parts

All USD observations are dated above and exclude delivery/tax. Public sale availability is not a reservation.

| Purchase line | Quantity / subtotal | Source and availability basis |
|---|---:|---|
| Nexus P50B factory pack, configuration above | 1 / **$252.00** | Product and read-only option metadata above; available to build |
| Genuine QS8 male contact assemblies | 2×$2.35 / **$4.70** | One aircraft mate, one charge mate. Public one-unit variant available; manufacturer uses female-housing/male-gold-contact wording, so verify mating convention, not title alone. [QS male product](https://qsconnector.com/products/qs8-connector-black-antispark-connector-high-current-connector-male) |
| DFRobot FIT0580, 1m red +1m black 8AWG | 1 / **$7.90** | [Manufacturer offered wire package](https://www.dfrobot.com/product-1756.html); remainder is spare wire |
| Matek I2C-INA-BM | 1 / **$19.99** | [OffTheGridSun](https://offthegridsun.com/Auto-Pilot-Controller/MATEK-Mateksys-I2C-INA-BM-ULTRA-PRECISE-I2C-POWER-MONITOR) lists 100 units; [GetFPV](https://www.getfpv.com/mateksys-ultra-precise-12c-power-monitor-ina-bm.html) also lists in stock but its price was not extracted |
| Panasonic EEU-FR1V102B, 35V/1000µF | 2×$1.75 / **$3.50** | One installed, one spare; parent BOM agent verified DigiKey stock. [Exact capacitor](https://www.digikey.com/en/products/detail/panasonic-industry/EEU-FR1V102B/3072262) |
| Existing proposed XT60 charger extension | 1 / **$3.99** | Retain the prior ledger's charge-side cable cost; convert only the disconnected ground cable's battery end to the second QS8 mate, after pin/polarity review |
| **Battery/main path/charge connection subtotal** | **$292.08** | Does not include ESC, regulators, charger, general consumables, tools or shipping already handled elsewhere |

The nonbattery replacement power parts are $32.59 before capacitor and retained charge cable; **remove the old $12.99 XT60 pigtail/capacitor bundle**, rather than adding both. Keep appropriate branch wire/insulation in the existing consumables allowance. This is an aircraft-harness assembly proposal; the factory pack is never cut, opened or resoldered. Practise large-wire joints on disconnected spare material, inspect workmanship, and revise the tooling plan if the proposed iron cannot produce acceptable joints. Nominal iron wattage is not evidence of successful soldering.

The charge cable may legitimately join QS8 to the charger's original XT60 interface at a proposed **5A maximum charge current**, below both the battery's 10A charge limit and the connector limits. It must be labeled **CHARGE ONLY**, physically absent from the aircraft discharge path, and used with a compatible 6S balance charger and the factory seven-pin balance lead. Confirm charger chemistry, 4.2V-per-cell endpoint, polarity, insulation and cell count before connection. A connector adapter is acceptable for this bounded low-current ground purpose; it is not a repair for the old flight bottleneck. No battery pack modification or parallel-pack charging is proposed.

## Cheaper alternatives actually examined

| Alternative | Why it is not the present coordinated candidate |
|---|---|
| Existing iFlight 10Ah factory XT60 pack | Its 35A exact connector remains incompatible with the new approximately 86A upper current screen; a larger downstream plug does not remove it. |
| Nexus Samsung 50S 6S2P, $204/approximately900g/216Wh, factory QS8 option | A real $48 cheaper comparison, not inherently impossible. Its90A pack rating is1.047×85.923A, below this comparison's1.25× criterion; P50B's120A is1.397×. Samsung's authored50S sheet distinguishes25A without temperature cutoff from45A with80°C cutoff. A supported lower-current/thermal/duty design retaining control authority could qualify it; simply citing90A does not pass this screen. [Factory pack](https://nexusbatterysystems.com/products/6s2p-50s), [Samsung-authored v1.0 sheet, distributor-hosted](https://www.bto.pl/pdf/10600/INR21700-50SCell%20Specification__v1.0_210419.pdf) |
| Nexus Reliance RS50 6S2P, $252/approximately840g/216Wh | Not EVE50PL. Same base price as P50B; this pass did not find equally strong original cell-manufacturer evidence for its claimed140A pack rating. Its lower mass is not borrowed into the P50B model. [Factory pack](https://nexusbatterysystems.com/products/6s2p-rs50) |
| Ovonic 6S9000 XT90, $78.43/1100.33g/199.8Wh | Attractive price, substantially heavier and less energy. Exact XT90-family current evidence only supports a far lower design envelope than the new motor corner. Its35C headline is not a whole-path qualification. [Factory pack](https://us.ovonicshop.com/products/ovonic-6s-9000mah-35c-22-2v-lipo-battery-w-xt90-plug) |
| Generic factory XT90 substitution | AMASS's current XT90H/XT90HW/XT90S catalog gives45A with10AWG under its stated temperature-rise condition, not an unconditional90A continuous path. [AMASS2025 catalog](https://www.china-amass.com/public/upload/20250319/41b7a7787d7c61edc3371469ba98f193.pdf) |
| Yangda 6S10Ah solid-state pack, approximately810g/219Wh | Official current data:30A continuous,100A for10s; current page is quote-based with no purchase price or exact factory connector established. Does not close this lower-cost rated-path search. [Manufacturer](https://www.yangdaonline.com/yangda-xturbo-6s-10000mah-solid-state-li-ion-battery-for-drone/) |

This establishes the **least-expensive examined factory option that passes the stated coordinated current screen**, not the global minimum or proof that the cheaper50S cannot work. The25% rating headroom criterion is an engineering judgment, not a universal manufacturer requirement or new user-approved policy. A lower-current propulsion design or a justified duty/thermal envelope may improve cost; neither is assumed to exist or declared impossible.

## Gates: design now, physical proof later

**Answerable now, before a locked hardware specification:** synchronize the final motor calculation, 4A auxiliary worst case, 930g pack/70g main-path mass and complete ledger; produce the annotated frame/pad/wire/connector layout; specify battery/temperature/low-energy protection, current-monitor loss behavior, appropriate balance charging and each rail's fault behavior. Do not silently add a series BMS that can disconnect in flight, bypass a supplied protection device, or treat measurement as a hard protective cutoff. The factory's balance-lead option and device-protection warnings must be incorporated into the aircraft's reviewed protection design. Final budget fit and selection are still explicit planning decisions.

**Requires physical validation:** received configuration/continuity/polarity; disconnected solder/strain/insulation checks; voltage and low-current consistency checks within the actual reference meter's verified ratings; props-off rail startup/stall and reset checks; safely staged load/thermal/logged-sag tests; as-built mass/CG; motor/ESC startup and repeated-duty behavior; measured usable energy and protected recovery; Q73 commissioning and Q74 fully equipped endurance, followed separately by loaded-cargo checks. The ordinary small multimeter must never be inserted as a full-propulsion ammeter. The following scoped instrumentation plan defines what these tests can establish.

### Minimum baseline instrumentation and its limits

The baseline uses the **already budgeted INA-BM, FC/ESC logs, charger and Plusivo-kit multimeter**, plus the existing **$45 measurement allowance for mass, wind, temperature and distance resources**. It does **not** require purchase or presumed free access to an oscilloscope, high-current probe, laboratory supply or independent high-current analyzer. This is a proposed risk-based commissioning scope for manufacturer-rated6S components with the reviewed short harness, capacitor and current margin, not a claim of comprehensive waveform certification.

1. Inspect the exact meter/manual, input protection and leads before deciding its allowed low-current check. Never assume its10A socket is fused or suitable for aircraft current: Plusivo has a published meter variant with an unfused10A input. Use the meter for voltage, resistance/continuity when disconnected, and only a bounded low-current comparison within a verified protected range. Small test-load/insulation material belongs in the already accounted bench consumables; if the received kit cannot support even that safe check, update the tooling plan before use. [Plusivo meter variant and input limits](https://www.plusivo.cn/en/all-products/77-plusivo-digital-multimeter.html).
2. Treat the low-current comparison as an **installation/configuration plausibility check**, including sign, zero behavior and response to a known load change. It is not an empirical calibration of the full88A range. Matek supplies a150A continuous shunt and advertises±2% current accuracy without user calibration; use its specified shunt/configuration and appropriate uncertainty, rather than adjusting it until an inexpensive meter agrees perfectly. Reject unexplained differences outside the combined instrument resolution/accuracy and test uncertainty. [Matek measurement specification](https://www.mateksys.com/?portfolio=i2c-ina-bm).
3. For staged propulsion loads use the onboard whole-battery current/voltage log, compare ESC readings as a secondary diagnostic with all auxiliary inputs accounted, and collect temperature, reset/desynchronization and voltage-sag evidence. These tests assess steady/repeated-duty operation and detected faults. They **do not prove the magnitude of sub-millisecond current spikes, switching ripple or bus overshoot**; neither does a successful flight. Retain the component-rating, short-wire, capacitor and design-margin justification rather than relabeling sampled logs as a high-bandwidth measurement.
4. Require separately planned diagnostics if there are unexplained voltage/current disagreements, heat, resets/desynchronization, changed long-wire/capacitor arrangements, or a later review identifies a need for waveform proof before proceeding. Stop the affected test/capability, then obtain an actual rental/service/purchase quote and update the complete-project ledger or choose a supported redesign. **No free loan or assumed scope access is credited.** Such fault-triggered diagnostics are a conditional cost risk, not an omitted mandatory instrument in the baseline or permission to exceed$900.

ArduPilot's generic analog-monitor guidance suggests approximately10A calibration because many analog sensors are inaccurate at very low currents; that is not an instruction to put the bundled meter into a10A propulsion circuit or apply analog scale parameters to this factory digital INA monitor. The chosen INA driver and manufacturer settings control this design. [ArduPilot monitor configuration and analog-calibration distinction](https://ardupilot.ardupilot.org/plane/docs/common-power-module-configuration-in-mission-planner.html).

Set conservative operational and stop temperatures in the reviewed test plan using the lowest installed component limit and the measurement location/uncertainty; an80°C cell cutoff or85K connector-rise test is not a desired operating temperature. A surface measurement is not automatically a cell-core measurement. If observed current, heating, voltage sag, connection resistance, total mass, reserve or control authority exceeds the reviewed envelope, keep flight or the affected later capability disabled and correct the design. Do not obtain a passing endurance time by cutting reserve or disabling required equipment.

These pending measurements do not prevent writing specifications or closing a coherent, affordable planning package. They do prevent claiming flight readiness. Conversely, a known current conflict, uncounted required load or unaffordable basket is a design problem and cannot be relabeled as pending physical validation.

## Local provenance

Source checkout: `C:\Users\zvent\Downloads\B.G.D`, branch `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. The following live sources contain uncommitted context; the base commit alone does not preserve these snapshots. Their SHA-256 values were read during this investigation:

| Local source | SHA-256 |
|---|---|
| `.scratch/biometric-guard-drone/map.md` | `F1C7E015B2B137456C7640DEB35FFB49DF12AC78B884F637C56C15A34650AA67` |
| `.scratch/biometric-guard-drone/issues/10-milestone-ladder.md` | `0C3678EF029051EB29A86302680CB6F9324024A95503AD5BC076B245739B5176` |
| `docs/research/issue10-hardware-paper-qualification-after-q74-2026-08-30.md` | `2689F7AA17EB4FCE1E08176AE93DD3146A9A3D0E997C7B24C39F0A36CED20DAC` |
| Final synchronized `docs/research/least-cost-propulsion-2026-08-31.md` | `91CA95194E47A8A9BCE283B2FF93AB0BB6F55FBA8ACE333304A9F57F8DC5CA0A` |

Earlier conflicts and acceptance approvals are preserved in those sources. New propulsion numbers were received from the coordinated endurance research and cross-checked against its final saved report/hash above. They are not attributed to a manufacturer test of this exact installed aircraft. Parent owns linking the final reports from the tracker/index; this power-path task writes only this report, with the later separately delegated pan/tilt findings in their own supplement.
