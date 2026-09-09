# Issue 10: hardware paper qualification after Q74

Date: 2026-08-30. Status: bounded engineering review, not procurement approval, configuration instructions or a flight procedure. No supplier contact, purchase, installation or powered test was performed. Only this new report is changed by this subtask.

## Result

**The F1001100/Gemfan7040 candidate has sufficient documented ESC voltage/current headroom and serial interfaces for further design, including the cheaper MicoAir45A alternative. Its factory battery connector does not support treating the aircraft as an unrestricted full-output package.** This is now a specific paper conflict, not a request to conduct a flight test before planning.

The iFlight pack specifies an **AMASS XT60H-F**, whose current manufacturer specification is **35A with 12AWG and a temperature-rise condition of ≤85K**. Four simultaneous maximum motor-table points sum to **113.88A before auxiliaries**. The latter is a constructed simultaneous-demand screen, not measured mission demand or evidence that the motors can sustain that output indefinitely. Missing qualified pulse-duration evidence is not proof that the connector fails instantly; it does prevent claiming those peaks are supported. The “60” in XT60 is not a 60A continuous rating. [Pack](https://shop.iflight.com/Fullsend-6S-10000mAh-Li-Ion-Battery-Pro2363), [AMASS exact 2025 specification](https://www.china-amass.net/uploads/107.XT60H-F-SPEC-2025V01.pdf), [matched motor table](https://www.ligpower.com/product/f100-fpv-motor.html)

**P02 remains answerable design work:** reconcile the complete battery path and a documented command/current envelope, correct board-specific current measurement, and produce the mechanical/power drawing. Physical validation follows the resulting design; it is not a substitute for correcting the known connector mismatch.

## Settled scope and model carried forward

The latest issue-10 comments approve Q71's **250g cargo including packaging**, separately carrying a provisional **170g secure removable holder**; Q72's weekly native-iPhone signing direction; and Q73/Q74's aircraft/endurance acceptance definitions. Q74 requires at least three successful evaluations over at least two days and qualifying evidence for every pack released for these missions. It does **not** select two purchased packs. The whole initial M1–M5 budget remains at most $900. These approvals do not select this over-budget hardware basket or certify a safe cargo rating. [Authoritative decisions](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments)

The existing model carries **1851.6g** fully installed with one 855g pack, camera/computer, both microSD cards, backup buzzer/cell allowance, sensing and separate 50g integration contingency. Its energy basis is **216Wh from cell nominal values**, not the pack's advertised 222Wh. With the existing workload/loss/usable-energy assumptions it predicts **348.82W and 27.45 useful minutes centrally**, **434.61W and 20.30 minutes conservatively**, and **18.61 minutes under the adverse loss case**. None is a validated duration. A change from two purchased packs to one does not change airborne mass or these calculations. [Mass, equations and uncertainty](issue10-endurance-payload-model-2026-08-30.md)

This report does not silently replace that baseline with the lighter AIO, new sensors or a new harness. Each selected change needs a complete mass/power update. The approved reserve remains the greater of 20Wh and 1.5 times recovery energy; the 120-second recovery calculation and its later evidence obligations remain intact.

## Electrical qualification matrix

| Element | Evidence and finding | Paper disposition |
|---|---|---|
| F100 **1100KV**, GF7040-3 | Matched maximum point: 28.47A at 24.59V, 2033.89g thrust. The table reports motor surface temperature after one minute at full output, not continuous endurance. Exact 1100KV is essential; 1350KV and 8-inch data are different cases. | Keep as the propulsion design candidate. Do not promise unrestricted sustained maximum output. |
| Fullsend 6S10000, Pro2363 | EVE50PL, 6S2P, 25.2V fully charged, 855±10g, 43×63×148mm. Discharge lead is **XT60H-F AMASS, 95mm**. Public page does not specify conductor gauge, internal interconnect limits, pack temperature derating or a duration-qualified assembly pulse rating. | Exact connector is known; complete assembly rating remains **supplier evidence needed**. The 25C headline cannot settle it. |
| EVE50PL cells | Current exact EVE page gives 70A continuous per cell. Two parallel cells yield a **140A cell-only arithmetic screen**, before sharing, joining, wiring, connector and thermal limits. | Better than the earlier EMAX cell-current screen, but not a 140A pack rating. Do not combine unrelated sheet revisions or unspecified pulses. |
| Supplied XT60H-F and mating harness | AMASS2025V0 document gives 35A at12AWG with ≤85K rise and80V DC. No applicable pulse-duration curve was found in that exact public sheet. A temperature-rise test condition is not a suitable installed operating temperature target. | **Known mismatch for unrestricted simultaneous maximum demand.** Qualify the entire mated path and lead conditions; neither a larger ESC nor an XT60-to-XT90 adapter removes the original connector bottleneck. |
| Holybro Tekko32F4 Metal65A AM32, SKU31097 | Four65A continuous channels,4–6S; airflow is important; manufacturer requires at least12AWG battery wiring and recommends the included1000µF35V capacitor for6S. | Per-channel steady-state screen passes for the matched motor. 25.2V is inside the stated6S use. Full-charge transients and thermal installation still need an engineering envelope and later measurement. |
| MicoAir743v2-AIO45A exact variant | Four45A continuous channels, **10–27V/3–6S**, AM32. A25.2V pack is below27V;28.47A is below45A. | Credible lower-cost FC/ESC candidate, **not ruled out by the matched motor table**. The shared battery path remains unresolved; margin to27V is not proof that switching transients remain below27V. |

Sources: [F100](https://www.ligpower.com/product/f100-fpv-motor.html), [iFlight](https://shop.iflight.com/Fullsend-6S-10000mAh-Li-Ion-Battery-Pro2363), [EVE50PL](https://www.evemall.eu/consumer-battery/cylindrical-ncm-cell/21700-50pl), [AMASS](https://www.china-amass.net/uploads/107.XT60H-F-SPEC-2025V01.pdf), [Holybro ESC](https://holybro.com/products/tekko32-f4-metal-4in1-65a-esc-65a), [exact MicoAir AIO](https://micoair.com/flightcontroller_micoair743v2_aio_45a/).

As an explicitly approximate full-charge screen, assuming fixed-prop current scales with voltage squared gives `28.47 × (25.2/24.59)² = 29.90A` per motor, or119.60A total before auxiliaries. This is **not an upper bound**: motor/ESC behavior, acceleration and tolerance are omitted. It reinforces that ESC channel ratings are not the current bottleneck. The manufacturer table already tests the light-load points near25.2V; no nominal22.2V assumption is used to conceal full charge.

### Why a software current limiter is insufficient by itself

ArduPilot documents battery-current limiting as throttle reduction with a response of roughly **1–5 seconds**, allowing short excursions above the setting. The inspected source also returns unrestricted throttle when current telemetry is unavailable or estimated battery resistance is zero, integrates throttle headroom and retains authority above hover. It is feedback control, not an instantaneous electrical fuse or a guaranteed absolute current ceiling. The exact released firmware must be pinned before relying on its behavior. [ArduPilot documentation](https://ardupilot.org/copter/docs/current-limiting-and-voltage-scaling.html), [inspected implementation](https://github.com/ArduPilot/ardupilot/blob/09ab657f2b3b094a593447bb480be44b71fd4286/libraries/AP_Motors/AP_MotorsMulticopter.cpp)

An optional **30A whole-pack governor** is a reviewable engineering proposal, not an adopted setting or a connector qualification. At21V it represents630W, above the existing central348.82W reference and462.53W loaded250g calculation, but those averages do not establish recovery/control margin. The governor may reduce climb or maneuver authority, and the observed command peak must still lie within the separately documented electrical pulse envelope. No reserve or mission requirement is reduced to accommodate it.

Blindly reducing maximum motor command is not a demonstrated solution either. For illustration only, the manufacturer's55% bench-command point totals27.8A and3144.88g thrust near25.07V. Simple fixed-command voltage-squared scaling to an illustrative19.8V predicts only1962g total thrust: about1.06 times the bare1851.6g mass and **less than the2271.6g loaded target**. At60% the same approximation gives2174g, still below that loaded mass. These are screening estimates, not recommended settings or a chosen discharge endpoint. They show why a hard cap needs a voltage-dependent control/recovery analysis; “walking speed” alone does not qualify a reduced-thrust aircraft.

### Bounded correction paths and exact missing evidence

1. **Retain this factory pack only with a documented restricted electrical design.** Obtain the supplier's revision-matched complete-pack specification: installed lead gauge/material, interconnects, genuine connector/mating requirements, allowable continuous and pulse current versus duration, temperature and repetition, voltage endpoints and applicable protection behavior. Define the allowed command/current envelope, abnormal-current response and residual control authority through the selected battery endpoint. A slow governor can supplement that design but cannot prove the missing pulse capability. No such document was publicly obtainable in this pass; no supplier was contacted.
2. **Otherwise choose a factory-built alternative with a fully rated discharge path**, then redo cost, dimensions, mass and usable-energy estimates. Specify at least the intended continuous mission demand and the modeled simultaneous command peaks with explicit engineering margin and duration, rather than demand an arbitrary140A because the cells sum to140A. No exact alternative meeting that evidence standard was identified in this bounded pass. Replacing a plug alone, an adapter or novice pack modification is not the proposed correction.

These paths are design/procurement-evidence work before purchase, not a demand for pre-build flight proof. Until one is completed, the candidate remains useful for cost and endurance exploration but is not a purchase-ready complete electrical package.

**Prepared supplier evidence request — not sent:** “For Fullsend6S10000 Pro2363, please provide the specification and test conditions for the currently supplied pack revision: exact cell revision and6S2P arrangement; discharge connector/mating part number; lead conductor material, gauge and length; internal interconnect and protection limits; complete-assembly continuous current and time-limited pulse current including duration, repetition, ambient/pack-temperature limits and cooling assumptions. Please distinguish the complete pack rating from cell arithmetic or the advertised25C value. If this assembly cannot support the proposed propulsion demand, is there a factory-built higher-current variant with documented complete-path ratings? Please provide its price, mass, dimensions, usable-energy/test conditions and availability.” No email, form or other external message is authorized by preparing this text.

## Serial allocation and current-measurement corrections

The following **proposed allocation resolves port-count uncertainty now**. It is not a wiring procedure or parameter upload. Board revision, pinout, signal voltage, grounding and exact released target remain part of the drawn specification.

| Function | KakuteH7v1.5 proposal | MicoAir743v2-AIO45A proposal |
|---|---|---|
| Pi MAVLink command/telemetry | UART1 / SERIAL1 | UART1 / SERIAL1 |
| GNSS | UART3 / SERIAL3 | UART3 / SERIAL3 |
| Downward serial rangefinder | UART4 / SERIAL4 | UART4 / SERIAL4 |
| RP1 ELRS/CRSF including telemetry | UART6 / SERIAL6, true UART mode | UART6 / SERIAL6, both directions, not inverted SBUS input |
| ESC telemetry | UART7 RX / SERIAL7, reserved | Prefer supported bidirectional DShot on motor outputs; do not assume shared-target UART7 is exposed by this AIO |
| Bluetooth | UART2 reserved, not double allocated | UART8 reserved for documented Bluetooth/telemetry role unless revision proves otherwise |
| Extra serial capacity | No spare assumed | UART5 available; UART2 remains unused display-port allocation |
| External compass | FC I2C | FC external I2C |
| D500 scanner | Pi USB adapter | Pi USB adapter |
| Camera and pan/tilt | Pi CSI; Pi I2C HAT | Pi CSI; Pi I2C HAT |
| Lights, holder latch and state sensing | Pi driver/sensing interfaces, separately designed; no direct GPIO high-current loads | Same |

The UART6 mode qualification matters for Kakute: its default R6 path is not the full UART required by CRSF/ELRS. Both candidates leave independent receiver control at the flight controller; routing commands from the Pi does not prove the required all-arming authorization policy. [Kakute mapping](https://ardupilot.org/copter/docs/common-holybro-kakuteh7.html), [Kakute current hardware definition](https://github.com/ArduPilot/ardupilot/blob/09ab657f2b3b094a593447bb480be44b71fd4286/libraries/AP_HAL_ChibiOS/hwdef/KakuteH7/hwdef.dat), [MicoAir exact board mapping](https://micoair.com/flightcontroller_micoair743v2_aio_45a/)

**MicoAir has a concrete default-scale trap:** its exact AIO page specifies ArduPilot current factor **14.14**, whereas the inspected shared `MicoAir743v2` hardware definition defaults to **40.2**. Blindly inheriting that value would produce approximately **2.843 times** the nominal indicated current. The board-specific published value is the starting point, followed by calibration; a generic target name is not sufficient. This is correctable configuration design, not evidence that the AIO is incompatible. [Exact board](https://micoair.com/flightcontroller_micoair743v2_aio_45a/), [shared target](https://github.com/ArduPilot/ardupilot/blob/09ab657f2b3b094a593447bb480be44b71fd4286/libraries/AP_HAL_ChibiOS/hwdef/MicoAir743v2/hwdef.dat)

For Holybro, the generic Kakute documentation's59.5A/V default must not be assumed to equal the current SKU's differently expressed meter-scale180. Confirm the exact sensor transfer function/unit conversion before calibration. More fundamentally, external BEC branches can bypass an ESC-mounted current sensor: the drawing must show **what current is actually measured**. Choose a whole-pack measurement topology or an explicitly conservative separately accounted auxiliary-energy method. Unmeasured Pi/peripheral draw must not disappear from the reserve estimator or a purported whole-pack current governor. No additional monitor is silently assumed priced or installed.

## Power rails and mechanical layout

The exact **Matek BEC12S-PRO** manufacturer page specifies **5A continuous/9A peak**,9–55V input, and5.2V default output—not8A/12A. Keep the proposed two-regulator separation during this review: one for compute and one for peripheral actuation/lighting. Neither the18W average electronics allowance nor the sum of two headline regulator ratings proves startup/stall headroom. The next drawing must show peak-load allocations, permissible device voltage, thermal derating, shared grounds, protection and isolation of HAT/Pi5V paths; do not parallel regulator outputs or back-feed a powered USB connection. A one-BEC saving is not selected. [Matek manufacturer specification](https://www.mateksys.com/?portfolio=bec12s-pro)

The frame's **30.5mm and20mm** mounting patterns directly support the Holybro stack's30.5mm mounting. The MicoAir's **25.5mm** pattern does not directly fit: retain an explicit vibration-isolated adapter design and its mass/cost; do not assume drilling the carbon or adhesive mounting. The frame is advertised for7-inch propellers; Gemfan's actual diameter is **178.43mm**, so the assembly drawing must check that swept disk against every neighboring prop, pack, wire and mount with clearance for flex. “313mm wheelbase” is a diagonal descriptor and does not alone establish adjacent-disk clearance on a deadcat layout. [Frame](https://www.team-blacksheep.com/products/prod:source1v6), [Gemfan dimensions](https://www.gemfanhobby.com/7040-flash-pc-3-blade.html), [MicoAir dimensions](https://micoair.com/flightcontroller_micoair743v2_aio_45a/)

Exact manufacturer7-inch CAD is publicly available; the missing deliverable is an **annotated installed layout**, not a claim that drawings cannot be obtained. It must accommodate the148×63×43mm battery, compute/cooling, scanner visibility, camera/servo sweep, GNSS separation, downward ranging and secure holder/landing clearances. The F100 manufacturer actually bench-tested GF7040-3, supporting that pair; do not confuse the motor's listed internal4mm shaft with a complete prop-nut interface drawing. Thread engagement, motor screw penetration and retention still need the assembly detail. Final mass and center of gravity are measured after construction. [Exact frame CAD](https://github.com/tbs-trappy/source_one/blob/master/So1-V6-7inDC-2025-JUL-07.dxf)

## What closes P02, and what waits for construction

| Class | Specific remaining evidence | Consequence |
|---|---|---|
| Resolved paper screens | Correct1100KV/GF7040 pairing; both ESC input/channel ratings plausible; adequate allocated UARTs; exact connector identified; AIO default-scale conflict identified and correction path defined | Stop repeating generic uncertainty about these facts. Neither board is excluded merely for lack of flight proof. |
| **Answerable now: electrical redesign/supplier evidence** | Revision-matched whole-pack/connector/wire duty ratings and allowed command envelope; protection and measured-current topology | Required before selecting the complete propulsion package as electrically qualified. Current public evidence does not close it. |
| **Answerable now: integration specification** | Chosen board/firmware and sensor scale; regulator peak-load/voltage/ground plan; actual adapter/installed CAD layout; re-costed and re-weighed design | Can be produced before owning components. No silent sensor or capability substitution. |
| **Requires physical validation** | As-built mass/CG, workmanship/retention, calibrated total energy, thermal/sag/transient behavior, control margin, commissioned recovery, Q73/Q74 results and loaded250g/holder evidence | Blocks powered release/capability claims, not the ability to finish a coherent paper design. |

P01 affordability remains separate. The present work neither raises$900 nor proves a global impossibility. Q71–Q74 are settled decisions; they are not reopened because this electrical mismatch was found.

## Provenance

Research skill applied under delegated read-only technical investigation. Public manufacturer pages, manufacturer PDF and upstream source were checked2026-08-30. iFlight HTML was read with PowerShell when the web reader failed. The AMASS direct download was independently parsed; its internal version is2025V0 although the URL ends2025V01. Older search-index snippets quoting30A/60A were **not** used as the current rating. The EVE storefront's exact-model70A value remains distinct from older distributor-hosted revisions. No access controls were bypassed.

Base repository HEAD: `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. Inputs below were uncommitted shared-checkout snapshots; later same-day edits can change their hashes. ArduPilot source was checked against upstream commit `09ab657f2b3b094a593447bb480be44b71fd4286`, which is an inspected source revision, **not a selected release**.

| Input | SHA256 |
|---|---|
| `CLAUDE.md` | `0FEC96250C4D0D5CB4CC62B534FDB25ABBFE2A97AB13FAAC412EC3BD89DEAE3B` |
| `docs/agents/workflow.md` | `47CC6A80D36F95BB0CE298652682D5C7C29B6C7E9804E49332900944E049B094` |
| `.scratch/biometric-guard-drone/map.md` | `92B45F1B0B28358CAF42E0747B306AADA2E11D7DBD014EEA82DF6AA58F924002` |
| `.scratch/biometric-guard-drone/issues/10-milestone-ladder.md` | `FD2CA04FF3F6ABF5A73FBE638750C330B0E633AD523EDB557491FB5D7E57615F` |
| `docs/research/issue10-endurance-payload-model-2026-08-30.md` | `0C143436B9446476C1E3A6A63505D30667DB0B3B6BC742FB9B2F5756D9D2D487` |
| `docs/research/issue10-bom-closure-options-2026-08-30.md` | `93F98BFB99992BB6DA616EC9ED054296D24590D744FB7E0BA7C280F7834793EF` |
| Direct AMASS `107.XT60H-F-SPEC-2025V01.pdf` | `8B7B091AB8B84024A9F367BD98726E6EAB36ECB1B24B4ECEFC5B3934C7DE2774` |
| Manufacturer `So1-V6-7inDC-2025-JUL-07.dxf` | `398556CD5F8720AC1A39B79BD1A0D1C083C6C57DEF55920BC17B212061B6D099` |

The CAD was retrieved and its entities inspected, but no complete installed-clearance solution is claimed. No executable aircraft settings, novice pack-modification steps or flight instructions are supplied.
