# Issue 10 final drone hardware optimization and compatibility decision packet — 2026-09-03

**Later owner amendment — September 10:** Q74 is now **11 useful minutes plus unchanged independent reserve**, same fully equipped no-extra-cargo configuration and workload proportions. The fifteen-/twenty-minute requirements and numerical pass/fail comparisons below are historical. Refer to the [current pre-purchase report](../prepurchase-decision-2026-09-10.md) and revised V26 acceptance; no automatic eleven-minute loaded-cargo requirement applies. Original component data/calculations remain historical evidence, not a revised aircraft qualification.

**Post-Q75 controlling update — 2026-09-03:** Q75 is approved and issue10 is **resolved as planning complete**, with Q74 unchanged. The [current hardware build package](../hardware/baseline-r1/README.md) records subsequent issue11 engineering. It exposes a genuine error: the selected$8 QS8-S item is a **two-pack series adapter**, not the assumed one-pack pigtail. Under the user's affected-subsystem authorization, R1.1 replaces only that interface with another genuine bare QS8 male and existing8AWG stock. Switch polarity, AHCT channel use and D500 cable reach are also corrected. The original1,897.251g/20.98min/$2,052.93 figures below are historical model/basket values, **not final R1.1 assembly totals**; see [mass/cost impact](../hardware/baseline-r1/mass-cost-impact.md). H01–H12 detailed engineering remains open; no purchase, fabrication or physical qualification is claimed. Dated pre-Q75 conclusions below do not override this update.

## Decision-ready result

The former **$800–$900 ceiling is revoked**. Cost remains an optimization target, with no fixed maximum, and no approved capability or validation gate is removed to reduce it.

The lowest-cost currently orderable component architecture found in the bounded search is the **Source One V6 / MicoAir743v2-AIO45A / XING-E 2809 800KV / APC 7×4 / Nexus 6S2P P50B** configuration below. It is the final recommended planning baseline, subject to the user's shared-understanding confirmation. It corrects the power path with a factory QS8/8AWG pack, upstream INA-BM and protected C110 copper distribution; no XT60, undersized PDB output or small prototyping board carries flight current.

This selection preserves the approved twenty-useful-minute requirement as a hard Q74 acceptance gate. The central model predicts **20.98 useful minutes plus the separate reserve**; the established moderate-loss sensitivity predicts **18.20 minutes**. That gap is a material redesign risk, not a waived requirement or an achieved result. If the built aircraft fails Q74, the twenty-minute capability remains disabled and propulsion/energy must be redesigned and retested. The user explicitly directed that an empirical requirement be defined now and validated after construction rather than treated as an endless planning decision.

No presently orderable, fully documented alternative examined here improves that endurance risk while also passing the seven-inch control, current-path and retained-feature screens. A P60B 6S2P pack is promising on cells alone, but no MOQ-one in-stock factory pack with a complete rated discharge path, exact configured mass and price was found. The recommendation is therefore a bounded least-cost result, not proof of a global market minimum.

No purchase, installation, firmware load, biometric capture, PC-ticket implementation, powered test or flight is authorized by this packet.

## Complete final BOM and cost

The synchronized cost report supplies the price observations, stock state and exact support-item ledger. The final totals are inserted here after its arithmetic check:

- **Named purchasable parts:** **$1,375.84**
- **Explicit integration/fabrication/completion materials:** **$270.00**
- **Parts plus completion:** **$1,645.84**
- **Planning scenario:** **$2,052.93** = $1,645.84 parts/completion + $75.00 delivery scenario + $172.09 illustrative tax + $100.00 first-build rework + $60.00 conditional compliance provision

Prices are dated observations, not reservations or delivered quotations. Tax and jurisdiction-dependent costs remain scenarios until the destination and actual operation are privately checked. Future ordinary repairs and worn-out replacements remain separate from the initial complete-project ledger.

| Subsystem | Exact selected item or construction | Qty | Installed role | Ground/spare role |
| --- | --- | ---: | --- | --- |
| Frame | TBS Source One V6 7-inch deadcat | 1 | Airframe, 313mm wheelbase | — |
| FC/ESC | MicoAir743v2-AIO45A, ArduPilot target | 1 | H743 FC and four 45A ESC channels | — |
| Motors | iFlight XING-E 2809 800KV | 4 | Propulsion | — |
| Propellers | APC `LP07040E-B4` bundles | 2 bundles | Four 7×4 E/EP props | One complete spare set |
| Flight battery | Nexus 6S2P Molicel P50B 10Ah, factory QS8 female, 8AWG, 7-pin JST-XH | 1 | 25.2V maximum flight source | Charged as one 6S pack |
| Flight disconnect | Genuine QS8 male | 1 | Aircraft mate to factory pack | — |
| Charge connector | Genuine QS8 male plus XT60 extension, custom **CHARGE ONLY** lead | 1 | Never installed in aircraft | M6AC XT60 output to pack, capped at 5A |
| Main wire | DFRobot FIT0580 8AWG red/black | 1m each | Pack, INA and bus path | Practice/offcuts |
| AIO feed wire | DFRobot FIT0581 10AWG red/black | 1m each | Short bus-to-AIO pair | Practice/offcuts |
| Whole-pack monitor | Matek I2C-INA-BM | 1 | All branches downstream of shunt | — |
| Distribution | Two C110 H02 bars, each 3.175×9.525×50.8mm | 2 | Positive and negative bus | Cut from purchased stock |
| Bus insulation | UL94 V-0 G10/FR4 carrier, polycarbonate touch guard, nylon standoffs and strain relief | 1 set | Protected custom bus assembly | — |
| Input filtering | Panasonic EEU-FR1V102B 35V 1000µF | 2 | One at AIO VBAT/GND | One spare |
| Branch protection | Littelfuse 0FHM0001LXN holders and 0297005.WXNV 5A/32V fuses | 2 each | Separate compute/peripheral BEC input branches | — |
| Transmitter | RadioMaster Pocket Crush M2 ELRS/FCC | 1 | Independent manual and emergency control | Ground equipment |
| Receiver | RadioMaster RP1 V2 ELRS | 1 | CRSF on FC UART6 | — |
| Transmitter cells | RadioMaster 3200mAh 18650 pair | 1 pair | Pocket power | — |
| GNSS/compass | Holybro Micro M10, case/IST8310, SKU 12044 | 1 | UART3 GNSS and I2C compass | Included 15cm cable |
| Charger | ToolkitRC M6AC, exact US mains variant | 1 | — | 6S balance charging |
| Balance extension | 6S 7-pin JST-XH extension | 1 | — | Ground charging |
| Smoke stopper | VIFLY ShortSaver 2 | 1 | — | Staged bench power-up |
| Battery containment | Pyrodrone storage/charging bag | 1 | — | Storage/charging precaution; not fireproof |
| Lost-aircraft buzzer | Exact available Finder-class self-powered buzzer frozen before order | 1 | Buzzer pads | — |
| FC storage | 16GB Class 10 microSD | 1 | ArduPilot logs | — |
| Compute | Raspberry Pi 4 Model B 2GB | 1 | Onboard vision, biometrics, local link and video | — |
| Compute storage | 32GB SanDisk Ultra Class 10 microSD | 1 | OS, app and bounded local data | — |
| Camera | Raspberry Pi Camera Module 3 NoIR standard | 1 | Owner/recipient vision and inspection video | Included 200mm CSI cable |
| Moving camera cable | Adafruit #1648 300mm 15-pin CSI FPC | 1 | Service loop for pan/tilt | — |
| Pi carrier | Adafruit #2310 Perma-Proto HAT | 1 | Fixed 40-pin power/logic carrier | — |
| Pi cooling | Adafruit #3368 5V fan and #3082 heatsink | 1 each | Forced-air compute cooling | — |
| Compute regulator | Matek BEC12S-PRO, default 5.2V | 1 | Pi/camera/D500/fan rail | — |
| Peripheral regulator | Hobbywing UBEC 5A AIR, 5.0V setting | 1 | Servos, visible lights and release actuator | — |
| Horizontal ranging | Waveshare D500 LiDAR Kit | 1 | Pi USB; 360° planar scan | Included adapter/cable |
| Downward ranging | Benewake TFmini-S | 1 | FC UART4 | Included cable |
| Pan/tilt | Adafruit #1967 two-servo mini pan/tilt | 1 | FC PWM5/PWM6 | — |
| Infrared lighting | Waveshare IR Board B | 2 | Night illumination | — |
| IR regulator | DFRobot DFR1015 configured to 3.3V | 1 | AIO 12V rail to IR boards | — |
| Visible lighting | Adafruit #5162 cool-white RGBW NeoPixel | 2 | Pi-controlled visible lighting | — |
| Light harness | Adafruit #1663 JST-SM pigtail | 1 | Lamp connection | — |
| Logic translation | TI SN74AHCT125N plus 0.1µF bypass on Pi carrier | 1 | Pi 3.3V to 5V NeoPixel data | Unused inputs tied deterministically |
| Release actuator | Adafruit #2776 5V spring-return solenoid | 1 | Retracts latch; never bears cargo load | — |
| Solenoid driver | Pololu #2802 low-side RC switch | 1 | 3A MOSFET, flyback and safe-start | FC PWM7 command |
| State sensing | Pololu #1402 SPDT lever switches | 2 | Independent holder-closed and latch-engaged sensing | — |
| AIO adapter | 1.6mm G10/FR4 plate, 55×55mm maximum, outer 30.5mm and rotated inner 25.5mm M3 patterns, insulated dampers | 1 | Installs AIO at maker-required 45° | Custom fabricated |
| Battery cradle | G10/FR4 platform, nominal 170×55mm, end stops, three 250×20mm straps and independent fore/aft restraint | 1 | Supports 139×48×72mm nominal pack with adjustment | Custom fabricated |
| Compute guard | 100×65×0.6mm polycarbonate base, two 85×8×1.2mm rails, 30×40×0.8mm fan bridge, nylon hardware | 1 | Insulated vented Pi guard | Custom fabricated |
| Sensor carriers | Nonconductive D500 mast, TFmini bracket, GNSS mast and camera/IR/light carrier | 1 set | Clears rotor plane and optical fields | Custom fabricated |
| Cargo holder | Enclosed removable 100×70×60mm planning envelope, mechanical spring latch, captive hinge, tamper-resistant aircraft interface | 1 | 250g cargo target; 170g holder mass target | Custom fabricated |
| Landing gear | Four nonconductive/aluminum supports and cross-bracing to a nominal ground plane 175mm below rotor plane | 1 set | Clears holder, camera, bus and ranger | Custom fabricated |
| Harness/support | 24AWG silicone signal wire, heat-shrink, tape, sleeving, ferrules/terminals as applicable, cable ties, threadlocker, fasteners and nylon standoffs | 1 lot | Every low-current/data connection and strain relief | Remainder/spares |
| High-current soldering | Hakko FX-888DX plus T18-C4 4mm bevel tip | 1 each | — | QS8/8AWG/bus assembly tool |
| Electronics tools | Plusivo V2 kit/meter, metric hex drivers, prop-nut wrench and bench-safety materials | 1 set | — | Assembly/inspection only; meter never measures propulsion current inline |
| Measurement resources | Scale, wind, temperature and ground-distance tools | 1 set | — | Q73/Q74 evidence |
| Simulator | FPV Freerider Windows license | 1 | — | Approved rehearsal path |

No direct Camera Module 3/IR-board screw connection is assumed. No cut USB-C cable, FCHUB, XT60 flight adapter, small solderless/prototype board, or output-paralleled regulator appears in the flight-current path.

## Fabrication and physical layout freeze

All coordinates use the manufacturer frame CAD convention adopted in the August31 integration report: `s` forward, `r` right, millimetres. Rotor-centre centroid is `s = −32.626, r = 0`; the frame's 30.5mm stack is centred near `s = 27.845, r = 0`.

| Assembly | Paper design constraint | Build/validation consequence |
| --- | --- | --- |
| Rotor system | Motor centres `(58.104, ±145.223)` and `(−123.357, ±96.170)`; 177.8mm diameter | Calculated static adjacent-disc gaps are 10.17mm fore/aft and 14.54mm rear. Confirm dynamic blade, arm, wire and accessory clearance physically. |
| AIO adapter | 55×55×1.6mm maximum G10/FR4; 30.5mm frame holes; 25.5mm AIO holes rotated 45°; M3 nylon hardware and elastomer isolation | Rotated 36mm board envelope is 50.91mm. Verify USB/SD, plate and wire clearance on received parts; keep component side up and airflow unobstructed. |
| Main bus | 80×35×1.6mm UL94 V-0 G10/FR4 carrier; two 50.8×9.525×3.175mm C110 bars with at least 8mm designed separation; 85×40×1mm vented polycarbonate guard | Cable loads terminate in separate clamps; neither copper nor joints touch carbon. Freeze exact holes after received-part overlay, then inspect creepage, polarity, insulation, joint pull and temperature. |
| Battery | 170×55mm platform, pack centred initially near `s = −65mm`, with at least ±25mm fore/aft adjustment and three straps plus hard end restraint | Pack bottom/cradle stays at least 15mm above the rotor plane. Final position comes from measured CG, not the nominal coordinate alone. |
| Compute | Pi/guard envelope 100×75×45mm near `s = −25mm`, below the centre frame | Retain USB/CSI access, airflow and crash restraint; verify no prop-plane entry, undervoltage or thermal throttling. |
| Camera/IR/lights | Reserve 70×70×80mm forward sweep envelope near `s = +105mm`; insulated carrier separates Camera3 from both IR boards; CSI cable uses a retained slack loop | Limit travel in firmware and mechanically before the cable, frame or landing gear is contacted. Flex-cycle, vibration, glare and optical alignment are physical gates. |
| D500/GNSS/TFmini | D500 scan plane near `s = +35mm, z = +115mm`; GNSS rearward near `s = −100mm`; TFmini has an unobstructed downward view | No pack, mast, wire, antenna, lamp or camera sweep crosses the D500 plane. Verify actual self-occlusion, magnetic/RF separation and TFmini field. |
| Holder/landing gear | Holder centred near rotor centroid, 100×70×60mm envelope at approximately `z = −95…−155mm`; ground plane near `z = −175mm` | Mechanical latch bears the load. Solenoid only retracts it. Two switches independently detect closed and latched. Aircraft interface is removable only landed/disarmed with service tool. Proof-load, tip, collection access and ordinary-removal resistance are physical gates. |

The exact hole positions that depend on delivered tolerances are drilled only after a 1:1 received-part overlay. That is a normal fabrication datum transfer and is explicitly a **REQUIRES PHYSICAL VALIDATION** item; it is not an unpriced missing component or permission to improvise topology.

## Complete electrical and interface allocation

High-current order:

`factory 6S2P pack QS8F/8AWG → aircraft QS8M/8AWG → INA-BM positive shunt and direct negative → positive/negative C110 bars → short 10AWG pair → AIO VBAT/GND`.

Every regulator input branches downstream of the INA. The AIO capacitor is mounted directly across VBAT/GND with short leads. Regulator outputs share signal ground only and are never paralleled.

| Rail/net | Source and protection | Loads | Design maximum / rule |
| --- | --- | --- | --- |
| Main 6S | QS8/8AWG, INA and C110 bars | AIO/ESC plus protected regulator branches | 85.923A modeled upper whole-system corner; 107.404A component-rating screen |
| Compute 5.2V | Matek BEC12S-PRO; fused input branch | Pi4 via both 5V pins and at least two grounds, Camera3, D500 USB, fan | 5A continuous source; Pi requires 3A-capable input; validate connector/trace drop and full-load brownout |
| AIO 5V | Mico onboard 5V/2A | RP1, Holybro M10, TFmini-S and INA logic | Exact coincident load and TFmini's 5V±0.1V at its connector must be measured |
| Peripheral 5V | Hobbywing UBEC 5A AIR; fused input branch | Pan/tilt servos, two RGBW lights, solenoid/driver | Release interlock prevents solenoid actuation while pan/tilt is moving; servo stall remains a received-part load test |
| IR 3.3V | AIO 12V/2A → DFR1015 at 3.3V | Two IR Board B modules | About 6W nominal output; validate regulator voltage, heat and AIO 12V loading |

The copper pair has about 28.9µΩ per bar using `ρ = 1.72×10⁻⁸Ω·m`, so the pair dissipates about **0.67W at 107.404A**. This verifies the selected conductor section on paper; it does not verify solder joints or installed cooling.

The harness cut list below accounts for every selected interconnect. Lengths are maximum planning cuts and are trimmed only after the received-part 1:1 overlay; routing beyond an allowance requires mass/loss review.

| Net | Conductor/cable | Maximum cut / supplied length | Termination and routing |
| --- | --- | ---: | --- |
| Pack to INA/bus | Prewired QS8-S 8AWG harness plus FIT0580 | 50mm supplied + 100mm per rail | QS8 harness is not modified at its connector; positive crosses INA active top ends, negative bypasses shunt; both terminate at guarded bars |
| Bus to AIO | FIT0581 10AWG red/black | 80mm each | Direct solder at bars and AIO VBAT/GND; capacitor at AIO pads; independent strain relief at both ends |
| Bus to compute BEC | FIT0585 18AWG red/black | 150mm each | 0FHM0001LXN/5A fuse in positive lead; soldered BEC input; no output parallel |
| Compute BEC to Pi carrier | FIT0585 18AWG | 200mm positive + 2×200mm ground maximum | 5.2V to both Pi 5V header pins through #2310; at least two ground pins; fixed soldered/strain-relieved path |
| Bus to peripheral BEC | FIT0585 18AWG red/black | 150mm each | Separate 0FHM0001LXN/5A fuse in positive lead; soldered BEC input |
| Peripheral 5V star | BEC supplied output plus 18/24AWG branches | 150mm trunk; 250mm per load maximum | Insulated soldered star to two servo power leads, #1663 lights and #2802/solenoid; signals stay separate; no breadboard |
| AIO 5V sensor star | 24AWG silicone | 250mm per branch maximum | RP1, M10, TFmini-S and INA logic power; insulated soldered splice; measure TFmini voltage at connector |
| AIO 12V to DFR1015 | 24AWG silicone | 200mm pair | Direct solder, polarity marked; DFR1015 set and verified at 3.3V before IR connection |
| DFR1015 to IR boards | 24AWG silicone | 250mm pair per board | Separate insulated carrier terminals; no Camera3 screw contacts |
| Pi to FC MAVLink | 24AWG, TX/RX/GND plus optional spare | 250mm | GPIO14→UART1 RX, GPIO15←UART1 TX, common ground; 3.3V logic only |
| INA to FC I2C | Supplied 200mm JST-GH lead | 200mm | 5V, GND, SDA, SCL to Mico I2C1; preserve 0x45 strap |
| M10 to FC | Supplied 150mm cable | 150mm | UART3 TX/RX plus I2C compass, 5V and ground; tail order continuity-checked before soldering |
| RP1 to FC | Receiver supplied lead | Supplied | 5V/GND and crossed CRSF TX/RX to UART6/RCIN |
| TFmini-S to FC | Sensor supplied cable | Supplied | 5V/GND and crossed 3.3V TX/RX to UART4 |
| D500 to Pi | Kit USB adapter/cable | Supplied | Pi USB-A; locking/strain clip on both ends |
| Camera3 to Pi | Adafruit #1648 300mm CSI cable | 300mm | 15-pin CSI; one retained slack loop through pan/tilt travel; no sharp fold |
| Servo signals | #1967 supplied servo leads | Supplied | Signal to PWM5/PWM6, common ground; red power leads only to peripheral BEC |
| Release signal | 24AWG | 250mm | PWM7/GND to #2802; driver output to supplied solenoid leads |
| Holder switches | 24AWG, two independent pairs | 350mm per pair | Normally closed contact to GPIO23/GPIO24 and ground; connectorized at removable-holder boundary |
| Visible-light data | 24AWG plus #1663 JST-SM | 300mm | Pi GPIO18 through SN74AHCT125N; 5V/GND from peripheral star; daisy-chain second lamp |
| Finder buzzer | Supplied lead or 24AWG | 150mm | AIO BZ-/5V/GND; self-contained cell remains isolated per maker wiring |

Every cable crossing a removable boundary is keyed or distinctly labeled, and every solder joint is insulated. Power and signal bundles are restrained separately from the compass, antenna, moving CSI loop and rotor disks. The factory battery is never opened, cut or reterminated.

| Function | Resource | Interface/configuration |
| --- | --- | --- |
| Motors 1–4 | Mico PWM1–4 / TIM1 | DShot300; map after the mandatory 45° board rotation |
| Pan/tilt | PWM5/PWM6 / TIM3 | Ordinary servo PWM; separate 5V power; common signal ground |
| Cargo release | PWM7 / TIM4 → Pololu #2802 | Fail-safe inactive; PWM8 remains reserved |
| Pi/FC | UART1 | Crossed 3.3V TX/RX and common ground; signed MAVLink |
| GNSS | UART3 | 115200 UBX; external 5V power |
| Downward range | UART4 | TFmini-S 115200, 3.3V LVTTL |
| Manual radio | UART6/RCIN | RP1 CRSF |
| Power/compass | I2C1 | INA-BM `0x45`; IST8310 `0x0E`; discover received devices before activation |
| D500 | Pi USB | Included CP2102 adapter/cable; retained and strain-relieved |
| Camera | Pi CSI | Camera3 15-pin cable with 300mm service-loop option |
| Visible lights | Pi GPIO18 → SN74AHCT125N → first NeoPixel | 5V logic supply, local 0.1µF bypass, deterministic unused input/OE ties |
| Holder switches | Pi GPIO23/GPIO24 | Normally closed to ground with pull-ups; open/wire break is unsafe/unknown |

ArduPilot's stable MicoAir743v2 target documents the necessary INA2XX, IST8310, CRSF, scripting, servo-mount, TFmini, MAVLink-signing, follow and avoidance feature families. The exact release `.apj`, checksum, parameter file, rollback image, board rotation, motor order, calibration and failsafes are frozen in the M1 aircraft implementation package before hardware activation.

Arming remains fail-closed: a new arm requires a fresh, bound owner face-and-voice authorization plus healthy aircraft preconditions, even if the radio arm switch is used. Once airborne, independent ELRS emergency control and safe landing do not require another biometric check. Cargo release output is active only when the aircraft is landed, motors are stopped/disarmed, the designated recipient face check is valid and fresh, and both holder sensors report a safe known state. Any stale, open, contradictory, missing or failed input keeps the actuator inactive. These invariants are requirements for the later software truth tables and tests; this planning task does not implement them.

## Mass, CG, power and endurance model

| Configuration | Planning mass | Model result |
| --- | ---: | --- |
| Fully equipped reference, no delivery cargo | **1,897.251g** | 354.54W central; 148Wh endpoint-usable; 20Wh reserve; **20.98 useful minutes** |
| Moderate-loss sensitivity | Same provisional mass | 401.96W; 146Wh endpoint-usable; 20.10Wh reserve; **18.20 useful minutes** |
| Delivery, 250g cargo + provisional 170g holder | **2,317.251g** | 455.59W central; 83Wh at earlier control endpoint; 22.78Wh reserve; **7.40 useful minutes**; no 20-minute loaded requirement |

The no-cargo weak-corner model gives 18.454V bus, 35.888A propulsion and 2,608.21g thrust, or **1.375 thrust/weight** against the provisional 1.35 control screen. The full-charge high-current corner is 81.923A propulsion plus 4A auxiliaries; the retained 1.25 rating factor produces **107.404A**. QS8's lower cited 110A rating, the factory pack's 120A statement, 150A INA shunt, 8AWG/10AWG conductors and 45A-per-motor ESC channels pass this paper screen.

The mass includes a 930g configured-pack allowance, 70g main-path allowance, 100g structural/local-harness allowance and 50g unallocated integration contingency. The exact support-part ledger must be reconciled against those allowances before fabrication; no purchased spare or ground tool is airborne. Empty CG is targeted at the rotor centroid by pack adjustment. Cargo and holder are centred at the same longitudinal datum so they do not deliberately introduce a pitch moment. Actual empty/loaded CG, individual motor loading and tip stability remain measured gates.

## Major-component compatibility matrix

`VERIFIED` means manufacturer/authoritative documentation or the stated engineering calculation establishes the paper interface. `REQUIRES PHYSICAL VALIDATION` means the selected interface is coherent but delivered-part fit, fabrication, calibration or operation must be measured. `INCOMPATIBLE` is used only for rejected combinations; no known-incompatible item remains in the selected BOM.

| Component | Connects to | Electrical requirements | Communication/interface | Mechanical requirements | Supporting hardware | Evidence | Status |
| --- | --- | --- | --- | --- | --- | --- | --- |
| Source One V6 frame | Motors, adapter, cradle, carriers | Conductive carbon kept isolated from power | — | 313mm; published 30.5/20mm patterns and DXF | Custom mounts/landing gear | TBS specifications and DXF-derived rotor coordinates/gaps | VERIFIED |
| XING-E 2809 800KV ×4 | AIO ESC; APC props; arms | 6S model; 20.48A/motor unfavorable modeled corner <45A channel | DShot through ESC | 19×19mm M3, 5mm shaft, screw depth checked | M3 screws, threadlocker | iFlight dimensions/test data; current calculation | REQUIRES PHYSICAL VALIDATION |
| APC 7×4 E/EP | XING shafts; frame rotor envelope | — | Correct CW/CCW placement | 5mm adapter ring; calculated static gaps 10.17/14.54mm | Included rings/nuts | APC bundle/dimensions and TBS CAD calculation | REQUIRES PHYSICAL VALIDATION |
| MicoAir743v2-AIO45A | Battery bus, motors, radio, sensors, Pi, actuators | 3–6S; 45A×4; onboard 5V2A/12V2A | 7 UARTs, I2C, PWM groups | 36×36×8mm; 25.5mm M3; 45° mount; airflow | G10 adapter/dampers, capacitor | MicoAir manual and explicit resource map | REQUIRES PHYSICAL VALIDATION |
| Nexus 6S2P P50B | QS8 aircraft lead; M6AC charge lead | 25.2V max; 120A maker pack statement; 10Ah | 7-pin JST-XH balance | Nominal 139×48×72mm; ~900g before allowance | Cradle, three straps, QS8 | Nexus configuration and P50B evidence | REQUIRES PHYSICAL VALIDATION |
| QS8/8AWG/INA/C110/10AWG path | Pack to AIO and all branches | 107.404A screen; INA 150A; conductor-loss calculation | INA I2C `0x45` | Insulated, guarded, strain-relieved; short routes | C110 bars, G10, guard, capacitor | Maker ratings plus transparent current/resistance calculation | REQUIRES PHYSICAL VALIDATION |
| M6AC charging chain | Factory pack | 6S, 4.2V/cell; custom lead capped at 5A | JST-XH balance + XT60/QS8 charge lead | Ground-only, polarity keyed/labeled | Balance extension, bag | ToolkitRC 6S/XT60 documentation and pack charge limit | REQUIRES PHYSICAL VALIDATION |
| RadioMaster Pocket/RP1 | Pilot to FC UART6 | RP1 5V; lawful matching 2.4GHz ELRS region | CRSF | Antenna separation/retention | 18650 pair | RadioMaster manuals; FC UART allocation | REQUIRES PHYSICAL VALIDATION |
| Holybro Micro M10/IST8310 | FC UART3/I2C | 4.7–5.2V | 115200 UART; compass `0x0E` | Elevated, away from power/magnets | Included cable and mast | Holybro specification; noncolliding address calculation | REQUIRES PHYSICAL VALIDATION |
| Pi4/Camera3/D500 | Matek BEC; FC UART1; CSI/USB | 3A-capable Pi input; D500 5V/290mA; Camera ~250mA | Signed MAVLink, CSI2, USB serial | Guard, cooling, retained cables and optical clearance | #2310, fan, heatsink, carrier | Raspberry Pi/Waveshare/Matek specifications | REQUIRES PHYSICAL VALIDATION |
| Matek BEC12S-PRO | 6S bus to Pi carrier | 9–55V in; 5.2V/5A continuous | — | Short fused branch, airflow | Fuse, wire, #2310 | Matek specification vs Pi 3A requirement | REQUIRES PHYSICAL VALIDATION |
| TFmini-S | AIO 5V and UART4 | 5V±0.1V; ≤140mA average/200mA peak | 3.3V UART, 115200 | Downward unobstructed view | Bracket/cable | Benewake manual and FC allocation | REQUIRES PHYSICAL VALIDATION |
| Adafruit #1967 pan/tilt | FC PWM5/6 and peripheral BEC | 5V; exact servo stall undocumented | Servo PWM | Camera carrier, end stops, CSI service loop | Custom insulated carrier | Adafruit geometry and timer allocation | REQUIRES PHYSICAL VALIDATION |
| IR Board B ×2 + DFR1015 | AIO 12V rail; camera carrier | DFR1015 7.5–30V in/3.3V3A out; ~6W lamps | On/off power control | Electrically insulated from Camera3 | Separate carrier/wiring | Waveshare/DFRobot docs | REQUIRES PHYSICAL VALIDATION |
| #5162 lights + AHCT125 | Peripheral BEC and Pi GPIO18 | 5V, ≥0.5A each | 5V NeoPixel via valid 3.3→5V translation | Aim/cooling without sensor glare | #1663, IC, bypass | Adafruit and TI datasheets | REQUIRES PHYSICAL VALIDATION |
| Solenoid/#2802/switches | Peripheral BEC, PWM7, Pi GPIO | 5V/1.1A load; 3A driver with flyback | RC PWM; two fail-safe switch inputs | Solenoid retracts non-load-bearing latch | Brackets, latch, closed/latched cams | Adafruit/Pololu docs and safety truth table | REQUIRES PHYSICAL VALIDATION |
| Secure removable holder | Aircraft interface and release system | No release on power/software fault | Recipient gate through Pi/FC | 250g cargo; ~170g holder target; enclosed/captive/tamper-resistant | Hinge, mechanical latch, service fasteners, landing gear | Approved Q55–Q58/Q65/Q71 requirements and defined proof tests | REQUIRES PHYSICAL VALIDATION |
| Stable ArduPilot Mico target | AIO and listed devices | — | INA2XX, IST8310, CRSF, scripts, mount servo, TFmini, signing, follow, avoidance | Exact artifact/parameters installed later | `.apj`, checksum, rollback/parameter manifest | ArduPilot stable target feature manifest | VERIFIED |

Rejected combinations remain explicit:

| Rejected combination | Status | Reason |
| --- | --- | --- |
| Matek FCHUB-12S V2 as the single AIO feed | INCOMPATIBLE | Documented 70A continuous per output is below the 85.923A upper steady model; parallel convergence at the AIO pads is undocumented. |
| Direct IR Board B screw/electrical mounting to Camera Module 3 | INCOMPATIBLE | The Waveshare contact/mount interface is for other camera boards; the final design uses an insulated carrier and wired 3.3V supply. |
| Cut USB-C lead as Pi power input | INCOMPATIBLE | No authoritative conductor/source-role proof; the final design uses the documented Pi 5V GPIO path through a fixed carrier. |
| XT60/XT90 adapter in the flight path | INCOMPATIBLE | It reintroduces a documented current bottleneck; XT60 exists only in the 5A ground charge lead. |
| EMAX 950KV + 5S2P P50B | INCOMPATIBLE | Paper endurance is below 20 minutes and the 128.126A rating screen exceeds pack/QS8 evidence; exact motor interfaces are underdocumented. |
| XING 800KV + 5S3P P50B | INCOMPATIBLE | Weak-corner thrust/weight is about 1.141. |
| 900KV + 5S3P P50B | INCOMPATIBLE | No common discharge state satisfies both twenty minutes and 1.35 control screen. |
| XING 800KV + 6S3P P50B | INCOMPATIBLE | Pack mass drives the control screen to about 1.346 and useful time to 18.07 minutes at the viable endpoint. |
| MaxAmps 6S2P 12Ah / Lumenier 6S 12Ah | INCOMPATIBLE | Complete-pack continuous ratings of 36A/50A are below the 85.923A upper system screen. |

## Remaining work classification

All current planning questions other than the final shared-understanding selection are resolved.

| Item | Classification | Current disposition |
| --- | --- | --- |
| Budget policy and cost response | Answerable now — resolved | No hard ceiling; dated complete ledger retained; choose the lowest complete requirement-preserving candidate. |
| Complete BOM and support items | Answerable now — resolved | The exact candidate, custom assemblies, wiring, adapters, tools and ground equipment above form the planning baseline. Refresh quotes before purchase. |
| Main power architecture | Answerable now — resolved | Factory QS8/8AWG, INA upstream, guarded C110 bars, 10AWG AIO feed and separated regulated rails; FCHUB rejected. |
| FC resources and interfaces | Answerable now — resolved | UART/I2C/PWM allocation, nominal addresses, power domains and safety invariants are frozen above. |
| Mass, CG, endurance and cargo estimates | Answerable now — resolved | Model values and placement targets are stated without claiming measurements. |
| M1 and endurance acceptance definitions | Answerable now — resolved by Q73/Q74 | Existing approved protocols remain controlling and are not reopened. |
| Final conditional hardware selection | Answerable now — awaiting Q75 | Confirm this baseline and its explicit endurance-redesign risk for issue-10 planning closure. |
| Later M2–M5 detailed policies/specifications | Answerable later — assigned | Existing validation-register entry/exit gates remain; no capability is deleted or implemented here. |

The following are **pending physical validation**, not open planning questions:

1. Received SKU/revision, dimensions, connector sex/polarity, cable pinout, charger variant and firmware artifact checks.
2. As-fabricated fit, fastener engagement, strain relief, insulation/creepage, dynamic prop clearance, landing/collection clearance and optical fields.
3. As-built mass, empty/loaded CG, individual motor loading, restraint, tip stability and structural/proof loads.
4. Main joints, polarity, resistance, rail voltage/ripple, branch protection, regulator temperature, servo-stall/solenoid/light coincidence, current-sensor calibration and full-system brownout/thermal behavior.
5. Motor/ESC/prop thrust-current behavior, battery usable energy/sag/balance/temperature and protected recovery authority across the approved conditions.
6. Q73 simulator/build/commissioning/basic-flight evidence and the three qualifying exercises across at least two sessions.
7. Q74 twenty-useful-minute reference mission with all equipment active, full independent reserve remaining, at least three successful evaluations across at least two days and qualifying evidence for every released pack.
8. Loaded 250g cargo plus holder structural retention, control, energy/recovery, safe capacity and delivery-envelope tests; the current 7.40-minute figure is predictive only.
9. Camera/pan-tilt cable life, video, Pi thermals, RF/telemetry, sensor interference/coverage, day/night perception, iPhone operation and later autonomous behaviors under their milestone gates.
10. Owner face-and-voice arming, recipient-face release, liveness/replay resistance, fail-closed boot/link/fault behavior, ordinary manual-removal resistance and every other V12–V37 software/human acceptance item.

Failure of any test keeps the affected capability disabled and triggers correction plus affected revalidation under V40. It never silently reduces reserve, removes equipment, permits a bypass or converts the failed result into a planning pass.

## Genuine remaining decision — Q75

**Recommendation: yes.** Accept this exact 6S2P/XING/APC configuration as the issue-10 planning baseline, while keeping Q74's twenty-minute result mandatory and accepting that the moderate model creates a meaningful post-build redesign risk. This is the least-cost path that lets specifications and build work proceed without pretending the hardware has already passed.

An answer of **yes** means issue 10 may close as **planning complete, with the listed physical validations deferred to implementation/testing**. It does not authorize purchase, construction, flight, capture, paid services or PC-ticket implementation. An answer of **no** means the seven-inch propulsion/energy architecture must remain open until a stronger documented pack or motor/prop option becomes orderable; no current evidence-backed alternative can be substituted automatically.

## Evidence and provenance

Primary-source links and detailed calculations are retained in the [component compatibility audit](final-compatibility-audit-2026-09-03.md), [propulsion optimization](final-propulsion-optimization-2026-09-03.md), [August31 integration report](least-cost-integration-2026-08-31.md) and synchronized [final cost report](final-cost-optimization-2026-09-03.md). The [validation register](issue10-validation-register-2026-08-30.md) remains the acceptance traceability source.

Prepared in the live main checkout from uncommitted planning state at base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. No commit or external action was performed.
