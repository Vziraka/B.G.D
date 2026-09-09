# Issue 10: proposed endurance and payload design model

**Decision update — Q74, 2026-08-30:** the user now approves the reference workload, envelope, reserve methodology and repetition/evidence package, with the pack-count correction below. No two-pack purchase, BOM or battery chemistry is selected. Hardware-specific protection must be validated or increased before reliance; actual endurance and safe cargo capacity remain **pending physical validation**. Older proposal/unanswered wording is retained as research history and superseded only for this acceptance definition; model estimates remain conditional on the unselected aircraft.

**Decision update — Q71, 2026-08-30:** **250g cargo is now the approved initial design target**, with the holder separate. Its 170g allowance remains provisional; the aircraft/BOM/chemistry, actual safe capacity and loaded endurance are not approved by that answer. The research below retains its original proposal language. **Q74 is proposed, unanswered:** review the reference endurance contract with one correction to its pack assumption—at least three successful complete evaluations across at least two days, and qualifying evidence for each pack released for those missions; no two-pack purchase is selected by approving the test plan. The earlier “both identified flight packs” wording reflects the unselected two-pack BOM, not a required inventory. See the [current decision record](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

**Status: planning proposal, 2026-08-30.** Main checkout, branch `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. This new report is uncommitted and is not contained in that commit. It proposes numerical design assumptions and future acceptance evidence; it does not approve purchases, chemistry changes, flight, a safe cargo rating or passed performance. Q69/Q70 and the subsequent PC handoff remain settled; this task changes no PC documents.

## Decision now possible

**The preferred seven-inch experimental candidate is now T-HOBBY F100/1100KV with Gemfan7040 three-blade props**, the H7/65A stack and a factory-built iFlight6S10000 pack. The corrected proposed reference configuration totals **1851.6g including a separate 50g integration contingency**. Using **216Wh cell-nominal energy**, its model predicts **27.5 useful minutes plus a separate 20Wh recovery reserve** centrally. Sensitivity cases give **20.3–35.9 minutes**; an additional adverse propulsion case gives **18.6 minutes**. These are engineering scenarios, not measured bounds or confidence intervals.

The F100 pairing reduces a documented current conflict in the earlier EMAX proposal without assuming a throttle cap. It supports a conditional design basis, not a twenty-minute guarantee or an unrestricted electrically qualified package. Exact pack/connector limits must be checked on paper before purchase; the [coordinated complete-cost proposal](issue10-bom-closure-options-2026-08-30.md) must fit an explicitly approved budget. Actual flight proof belongs after construction. Voice remains through the existing iPhone/EarPods path: the redundant onboard microphone has been removed.

The retained requirement is **at least twenty useful minutes, then sufficient separate return/landing reserve**, with camera/computer and the required mission equipment installed, without extra delivery cargo, within 100m in dry, calm daylight. The budget remains **$900 for the full initial M1–M5 project** unless the user explicitly changes it. Delivery remains recipient-verified, protected against ordinary manual removal, removable between flights, landed/motors-stopped at handoff, and physically carried back while disarmed.

## Exact proposed propulsion and battery

| Part | Proposed quantity and evidence | Planning status |
| --- | --- | --- |
| T-HOBBY **F100 2810/1100KV** | Four at **$35.90**, **$143.60** total; manufacturer page selects KV1100 and reports in-stock schema. **67g each including cable**. | Preferred experimental motor; not the 1350KV variant. |
| Gemfan **7040 Flash PC, three blade** | Three four-prop sets at **$3.99**, **$11.97** total from the checked TBS listing; **7.9g per prop** from Gemfan. Four installed, two spare sets. | Nominal match to the manufacturer's F100 test; supplied revision/hub fit still checked before purchase. |
| iFlight Fullsend **6S10000mAh**, `Pro2363` | Two at **$95.99**, **$191.98** total. Listed **222Wh, 855g ±10g**, EVE21700-50PL, 43×63×148mm, 25C, in stock. | Factory pack proposal. One pack aboard; the second funds another sortie. Current/thermal and supplied-revision qualification remain. |
| Holybro Kakute H7 v1.5 + Tekko32 F4 Metal **65A AM32** stack | Coordinated cost proposal identifies the **$149.99** exact stack variant `45081936724157`; use **35g installed allowance** here. | Proposed higher-current replacement; all-arming authorization, firmware and electrical compatibility still need design review. |

Sources: [F100 manufacturer product/test data](https://www.ligpower.com/product/f100-fpv-motor.html), [Gemfan7040 manufacturer specification](https://www.gemfanhobby.com/7040-flash-pc-3-blade.html), [TBS exact four-prop listing](https://www.team-blacksheep.com/products/product:3787), [iFlight10000 product](https://shop.iflight.com/Fullsend-6S-10000mAh-Li-Ion-Battery-Pro2363), [Holybro stack variants](https://holybro.com/products/kakute-h7-v1-stacks).

Compared with two previously considered iFlight8000 packs, the 10000 choice adds **$24 total and 15g aboard**, with 44.4Wh more advertised energy per sortie. The model now uses the lower **216Wh** from twelve EVE50PL cells at 3.6V×5Ah; the pack listing advertises 222Wh on its 22.2V basis. Neither is usable-energy proof. The [8000 listing](https://shop.iflight.com/Fullsend-6S-8000mAh-Li-Ion-Battery-Pro1914) remains a comparison using its stated 177.6Wh, not a matched cell revision analysis.

### Matched F100 data and the electrical selection gate

The F100 manufacturer's **1100KV / GF7040-3** table gives these points near full 6S voltage. They are single-rotor bench measurements, not complete-aircraft measurements:

| Single-rotor thrust | Voltage | Current | Electrical power |
| ---: | ---: | ---: | ---: |
| 401.76g | 25.16V | 2.45A | 61.66W |
| 474.60g | 25.14V | 3.26A | 82.04W |
| 557.59g | 25.13V | 4.08A | 102.60W |
| 627.53g | 25.11V | 4.96A | 124.58W |
| 714.03g | 25.09V | 5.95A | 149.20W |
| 786.22g | 25.07V | 6.95A | 174.17W |
| 870.11g | 25.05V | 7.83A | 196.22W |
| 2033.89g, maximum listed | 24.59V | 28.47A | 699.92W |

[F100 manufacturer table](https://www.ligpower.com/product/f100-fpv-motor.html). Its temperature result is from one minute at full throttle, not an indefinite duty rating. Do not transfer the page's 1350KV or eight-inch results. Declining-voltage behavior, exact prop revision and installed thermal conditions still need qualification.

**Cell/pack current evidence:** EVE's exact50PL manufacturer storefront specifies **70A continuous per cell**, or at most **140A by simple two-parallel-cell arithmetic before pack/connector/thermal derating**. Its public page does not give a matched pulse duration. An older, distributor-hosted EVE-branded Version A sheet instead states125A maximum with75°C recommended/80°C maximum temperature cutoffs and180A for2s. Those different bases cannot be combined with an unidentified supplied pack revision. The storefront brochure requires login; no access restriction was bypassed. [EVE exact50PL specification](https://www.evemall.eu/consumer-battery/cylindrical-ncm-cell/21700-50pl), [EVE-branded Version A sheet, page6](https://www.nkon.nl/en/amfile/file/download/file/796/product/5881/)

Four F100 maximum table points sum to **113.88A before electronics**, below the140A cell-only continuous screen. This is a better paper candidate, **not a verified113.88A pack allowance**: exact cell revision, parallel sharing, wiring, supplied connector, cooling, duration and full25.2V response must still support the intended envelope. The65A-per-channel ESC rating does not solve a lower pack or connector limit. **Block purchase of the complete propulsion package until the paper current envelope is reconciled**, then perform controlled validation before flight. No throttle/current limit is adopted here. If the real pack path cannot support the intended demands, either select a matched alternative or present an explicit restricted maneuver/control envelope for review; do not conceal that restriction.

**Why the lower-cost EMAX pairing is no longer preferred:** its1500KV/HQ7353 table peaks at53.3A per rotor at21V, or **213.2A total**, demanding106.6A per cell in2P before electronics. That exceeds the current70A-cell continuous basis by52.3%. The1300KV/HQ7353 table's47.1A maximum also does not solve that screen. These are a known paper conflict for unrestricted continuous use, not proof that every short maneuver is impossible. The EMAX option saves$65.64 on four motors and$1.20 on three prop sets, but its old energy result cannot be presented as an electrically qualified cheaper substitute. A bounded further comparison also found Flycci2810/1100KV/GF7040 data at31.9A maximum/25V, but without a checked purchasable price or low-hover points; it is not promoted over the F100. [EMAX table, pages7–8](https://evelta.com/content/datasheets/449-0101096022.pdf), [Flycci manufacturer table](https://www.flyccimotor.com/fa2810-fpv-racing-motor-product/)

## Complete proposed reference mass budget

This accounts for the proposed future equipment rather than the earlier generic 250g-compute/150g-remainder estimate. Listed values and engineering allowances are distinguished; packing weights are deliberately not claimed as installed measurements.

| Installed item | Grams | Basis |
| --- | ---: | --- |
| Source One V6 7-inch frame | 173.0 | Manufacturer specification |
| Four F1001100 motors, including cables | 268.0 | 4×67g manufacturer specification; no separate motor-wire row |
| Four Gemfan7040 props | 31.6 | 4×7.9g manufacturer specification |
| H7/65A controller and ESC installation | 35.0 | Engineering allowance including mounting |
| GNSS/compass | 15.0 | Coordinated component allowance |
| RP1 receiver | 2.0 | Component mass; external wiring/mounting below |
| Pi4, its microSD, cooling and enclosure | 105.0 | Engineering allowance, not measured application hardware |
| Separate flight-controller microSD | 1.0 | Engineering allowance; not the Pi or radio card |
| Camera and ribbon | 9.0 | 4g camera +5g ribbon allowances |
| Backup buzzer, its cell and mounting | 10.0 | Explicit installation allowance; not an owned component or taken from contingency |
| Two regulators | 25.0 | Engineering allowance |
| D500 horizontal LiDAR | 45.0 | Manufacturer specification |
| TFmini-S downward rangefinder | 5.0 | Manufacturer specification |
| Pan/tilt assembly | 82.0 | Conservative use of listed package weight until installed weight is known |
| IR/visible lighting and thermal/mount parts | 40.0 | Engineering allowance; installed but unnecessary emitters off in daylight reference |
| Shared harnesses, connectors, mounting, straps and landing clearance | 100.0 | Engineering allowance; includes permanent delivery interfaces |
| One 10000mAh flight pack | 855.0 | Manufacturer specification |
| Integration contingency | 50.0 | Explicit unallocated mass allowance |
| **Reference takeoff mass** | **1851.6** | Calculated; no extra cargo or removable delivery holder |

Sources for the coordinated items: [frame](https://www.team-blacksheep.com/products/prod:source1v6), [D500 kit](https://www.waveshare.com/d500-lidar-kit.htm), [TFmini-S](https://www.waveshare.com/tfmini-s-lidar-range-sensor.htm), [pan/tilt HAT](https://www.waveshare.com/pan-tilt-hat.htm); other primary sources are above. Pi/cooling, regulators and general installation figures are explicit project allocations, not manufacturer mass guarantees. The VIFLY Finder V2 is a possible buzzer reference: its page lists5g and an80mAh/0.3Wh cell, but also contradictory battery-inclusion text. The10g allowance includes the actual backup cell/mount; supplied contents and cost must be reconciled, not assumed free. [VIFLY exact product data](https://viflydrone.com/products/vifly-finder-v2-fpv-racing-drone-buzzer.js)

The baseline contains the proposed NoIR camera. If a separate daylight RGB camera/interface is necessary, an **additional20g** allowance gives **1871.6g** and a central modeled27.0 useful minutes. That is an explicit alternative/configuration sensitivity, not a second camera silently installed or a requirement waived. Costs and the actual camera-switch/interface power must also be accounted for before choosing it. The existing iPhone/EarPods supplies voice; there is no onboard USB microphone in this ledger. The50g contingency remains separately intact.

This is a complete **proposed configuration**, not proof that those devices satisfy every capability. Horizontal LiDAR plus one downward rangefinder does not establish universal obstacle coverage; camera/compute performance, blind spots, landing clearance and all-arming enforcement remain their own validation gates. If further equipment is required, add its cost, mass and power and recompute. The 50g contingency is not permission to hide unspecified hardware. Removable delivery hardware remains in the financial budget even when absent from this endurance configuration.

## Power, usable energy and predicted endurance

Use piecewise linear interpolation **within** the published thrust points, with per-rotor equilibrium thrust `mass_g / 4`. Interpolation is a screening model, not another manufacturer measurement. It ignores detailed airflow interaction and attitude effects; the scenario multiplier below explicitly represents uncertainty in propulsion efficiency, mission duty and installation. No forward-flight efficiency improvement is credited in the central case.

`P_reference = 4 × interpolated_single_rotor_power(mass_g / 4)`

`P_useful = k × P_reference + P_electronics`

`E_useful = u × E_design − E_before_useful − E_reserve`

`E_design = 216Wh` from the twelve cells' nominal voltage and capacity, **not** the pack's advertised222Wh.

`t_useful_minutes = 60 × E_useful / P_useful`

At **1851.6g**, each rotor supports **462.9g** in the static screen; `P_reference = 315.07W`. Central `k=1.05`, electronics **18W**, usable fraction **85% of216Wh**, and pre-segment energy **4Wh** produce **348.82W** useful-segment demand. The electronics allocation covers Pi/camera, navigation sensors, flight electronics, buzzer backup-cell charging/standby, average actuation and regulator losses. It is an allocation to measure, not a processor benchmark or peak limit. D500 alone is listed at1.45W. The motor table is near25V; declining-voltage effects are uncertain and included only provisionally in the scenario multiplier, not established by extrapolating a fixed efficiency.

| Scenario — all assumptions provisional | Mass | k | Electronics | Usable fraction | Whole-aircraft average | Separate reserve | Predicted useful time |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| Favorable | 1751.6g | 0.95 | 12W | 90% | 284.73W | 20.00Wh | **35.9min** |
| Central design | 1851.6g | 1.05 | 18W | 85% | 348.82W | 20.00Wh | **27.5min** |
| Conservative screen | 1951.6g | 1.20 | 25W | 80% | 434.61W | 21.73Wh | **20.3min** |
| Additional adverse propulsion case | 1951.6g | 1.30 | 25W | 80% | 468.74W | 23.44Wh | **18.6min** |

All rows use **216Wh cell-nominal energy and4Wh before the useful segment**. They include ±100g assembly uncertainty, installation/workload variation and energy derating; they are not empirical bounds. The adverse row shows that a further propulsion penalty can erase the apparent conservative margin. At an illustrative21V, central demand is **16.6A for the whole aircraft**, conservative demand **20.7A**. That voltage is a comparison point, not a selected battery endpoint. Averages do not establish maneuver, startup, depleted-pack or emergency current margins.

With the same F100 central configuration, the8000 pack's stated177.6Wh and15g mass saving predict **22.1 useful minutes plus reserve**, but its conservative scenario gives only **16.3 minutes**. The10000 pack therefore buys useful modeled margin for$24 across two packs; this replaces the old EMAX-based comparison. The central216Wh model allows approximately **468.5W average** for twenty minutes with the reserve formula below, versus estimated348.8W: **119.7W central margin**. Under the conservative assumptions, total mass must be about **1.97kg or less** to reach twenty minutes. That is a model sensitivity, not a validated takeoff-mass limit or permission to remove required equipment.

## Proposed reserve and reference mission contract

These values are explicit **engineering proposals for review**, not user-approved settings or instructions to conduct a first flight.

- **Useful workload:** twenty minutes comprising **twelve minutes following at 1–2m/s, six minutes stopped/hovering and two minutes of gentle turns/transitions**. Spread those activities across the segment rather than placing all favorable movement first. Run camera, compute, video and required navigation processing throughout. The first result at lower equipment load does not qualify the finished configuration.
- **Initial validation envelope:** dry daylight, **15–30°C**, measured mean wind **at most 2m/s** and gusts **at most 3m/s**, radius **at most 100m**, height **at most 10m above the takeoff area**, with suitable visibility, obstacle clearance and applicable permissions. These proposed limits are a narrow model context, not a guarantee of aircraft or solo-pilot readiness. Conditions/site assessment may require tighter limits. Broader eventual operation requires its own validation.
- **Recovery model:** initially allocate **120 seconds**: up to50 seconds to cover100m at a validated2m/s ground speed,20 seconds positioning/contingency and50 seconds descent/landing. Protect **1.5 times** the modeled recovery energy, with a **20Wh floor**: `E_reserve = max(20Wh, 1.5 × P_recovery × 120 / 3600)`. For screening only, use useful-segment power as `P_recovery`; measured recovery demand must replace that proxy. Centrally the formula's20Wh floor governs, equivalent to about **3.44 minutes** at348.82W. The factor/floor are proposed conservatism, not certification thresholds.
- **Before relying on reserve:** demonstrate that measured worst-case recovery time/energy within the accepted envelope, including uncertainty and positioning/landing behavior, is bounded by the protection. If longer or more demanding, **raise the reserve and recompute useful time**. Do not cut the reserve to obtain a twenty-minute result. Energy unusable because of voltage sag, thermal/current limits or a suitable battery endpoint is outside `u × E_design`; it cannot also be counted as available reserve.
- **Acceptance evidence:** propose **three successful complete reference evaluations over at least two days, using both identified flight packs** after separate build/commissioning and safe readiness prerequisites. Log configuration/version, measured mass, weather, calibrated battery voltage/current, cumulative Wh, segment timestamps, estimator limits, recovery energy, residual state and faults. At each twenty-minute checkpoint the full validated reserve must still be available; then assess the planned recovery without deliberately exhausting the pack. Record every attempted evaluation. Safety stops override sample counts; faults/early recovery are investigated, not erased from the evidence. This endurance evidence is separate from Q62's M1 piloting demonstration.

ArduPilot provides battery-monitor and staged failsafe mechanisms, but they do not validate this reserve proposal by themselves. Exact endpoint, calibration, low-battery policy and selected firmware behavior belong in the reviewed build design before operation. No generic documentation example is copied into this aircraft as a safe setting. [ArduPilot battery-failsafe documentation](https://ardupilot.org/copter/docs/failsafe-battery.html)

## Provisional delivery design target

Recommend **250g cargo plus a 170g removable secure-holder budget** as the first engineering target, not a proven carrying rating. Retain **500g as a stretch comparison**, requiring a separate explicit design decision. The earlier tentative 3lb remains an analytical comparison, not a selected requirement or promise. The user need not name an item to choose an initial engineering target.

The 170g holder budget allocates **80g enclosure, 35g actuator/latch/wiring and 55g removable mounting/retention**; permanent interfaces are already in the reference harness/mount allowance. Cargo allowance includes its own packaging. This budget must produce a holder that prevents ordinary manual removal before recipient verification; a removable box that simply exposes its contents when detached fails that requirement. Force resistance and theft of the whole drone are not promised.

| Cargo comparison | Complete modeled mass including 170g holder | Central average demand | Modeled separate reserve | Central energy-limited useful duration |
| --- | ---: | ---: | ---: | ---: |
| **250g first design target** | **2271.6g** | 462.53W | 23.13Wh | 20.3min |
| 500g stretch comparison | 2521.6g | 544.67W | 27.23Wh | 16.8min |
| Tentative3lb =1360.777g | 3382.4g | 815.06W | 40.75Wh | 10.2min |

These rows assume the same simplified workload and therefore **are not delivery-duration commitments or safe capacities**. Holder drag, centre of gravity, structural loads, landing stability, voltage sag and control margins can dominate before energy runs out. The no-extra-cargo twenty-minute requirement is unchanged. Safe initial capacity is determined only after a reviewed staged build-test programme covers retention, balance, command margins, electrical/thermal behavior, loaded recovery and verified landed release. No executable load-test or novice flight procedure is supplied here.

## What can close now, and what waits for construction

**Answerable now:** choose or reject the provisional F100/Gemfan7040/10000-pack direction; resolve its paper electrical envelope and honest complete cost; agree the reference workload, proposed reserve logic and initial cargo design target; write specifications and validation tickets around those boundaries. The design can be frozen conditionally without demanding physical flight proof. Any pack chemistry/part change, increased budget or reduced requirement still needs the user's explicit decision.

**Engineering before powered use:** confirm exact revisions and obtainable variants; reconcile connectors/retention/clearance; review 6S full-charge motor/ESC/pack transient limits and the command envelope; establish the battery endpoint/calibration and recovery policy; resolve needed sensor coverage and onboard-compute feasibility. A passing arithmetic average does not close these gates.

**Evidence after build:** weigh the installed configuration, characterize actual power and usable energy, validate safe commissioning and the command gate, and execute the reviewed endurance/payload evidence plan. Update the model from those results. No current report certifies the aircraft, software or operator.

**If the complete proposal cannot fit$900:** present its actual total and gap. Credible tradeoffs are a separately approved complete-design budget or continued redesign while all requirements remain active. The8000 alternative saves only$24 for two packs and loses conservative endurance margin; the EMAX saving reintroduces the stated current conflict. Dropping a spare pack, sensors, recipient verification, software/signing costs or reserve is not adopted. Keep approved PC work moving independently without declaring aircraft planning complete.

## Provenance

- Authoritative ticket read snapshot SHA-256: `83C9A1FD8E6006BAC7826DCECC70B324B20EA4EFCD0F03E04EFDBE17384146C4`.
- Map read snapshot SHA-256: `E4102C5DFE4061E076197499D8B2AA5F27B1CC14391768AA322B1035583DD784`.
- Prior endurance-closure report SHA-256: `6669A94529B6DD7D9B459641882D79CD9C90153BD26CEE9F89E5864861634E5B`.
- EMAX PDF freshly retrieved and visually inspected, pages 7–8: `81B13EDED16A94295F65E0A7859DF5D93A6469DFBC8EF92841B61F67D9F1B56E`.
- Live coordination with the complete-budget task supplied the explicitly labeled Pi/regulator/installation allocations, backup-buzzer allowance and exact Holybro stack candidate. These are proposal inputs, not additional user approvals. The final1851.6g calculation replaces the preliminary EMAX configuration and its microphone omission/correction history.
- Review correction: remove redundant2.2g USB microphone; add1g separateFC card and10g complete backup-buzzer allowance; replace215.4g EMAX/wire allowance with268g F100/cables and35.2g HQ props with31.6g Gemfan props. Net+57.8g over the previous1793.8g draft. The optional20g RGB case is separate; the50g contingency remains unchanged. Recompute all current model results with216Wh cell-nominal energy. No new voice-input policy is proposed.

Primary pages were checked on 2026-08-30. Where the web reader omitted specifications, direct read-only HTTPS retrieval of public manufacturer HTML supplied them. PDF page images were rendered only to the system temporary directory for inspection. This task wrote only this report in the repo; no implementation, purchases, capture, physical operation or commits occurred.
