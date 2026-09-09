# Final component and interface compatibility audit — 2026-09-03

**Post-Q75 controlling update — 2026-09-03:** Q75 is approved and issue10 is **resolved as planning complete**, with Q74 unchanged. The [current hardware build package](../hardware/baseline-r1/README.md) records subsequent issue11 engineering. It exposes a genuine error: the selected$8 QS8-S item is a **two-pack series adapter**, not the assumed one-pack pigtail. Under the user's affected-subsystem authorization, R1.1 replaces only that interface with another genuine bare QS8 male and existing8AWG stock. Switch polarity, AHCT channel use and D500 cable reach are also corrected. The original1,897.251g/20.98min/$2,052.93 figures below are historical model/basket values, **not final R1.1 assembly totals**; see [mass/cost impact](../hardware/baseline-r1/mass-cost-impact.md). H01–H12 detailed engineering remains open; no purchase, fabrication or physical qualification is claimed. Dated pre-Q75 conclusions below do not override this update.

**Current coordinated disposition:** the later [final hardware decision packet](final-hardware-optimization-2026-09-03.md) supplies the paper fabrication constraints, complete topology, two exact fused BEC branches, port map and fail-closed invariants that this audit identified as missing. Its selected-BOM matrix is controlling. Rows below that classified an absent design artifact as `INCOMPATIBLE` record the audit-time gap; after the companion design is applied, received-part fit, fabrication and operation are `REQUIRES PHYSICAL VALIDATION`. Known rejected combinations—FCHUB single-output feed, direct Camera3/IR-board contact mounting, cut USB-C power and flight-path XT60—remain `INCOMPATIBLE`.

Research-only audit of the live Issue 10 planning package. No purchase, supplier contact, account action, capture, powered test, tracker edit, implementation change, or commit was performed. Prices and availability are dated observations, not reservations or delivered quotes.

## Verdict

**There is a coherent, purchasable component candidate, but the repository does not yet contain a physically buildable complete-aircraft package.** The propulsion, voltage, data-port, and major component choices are mostly compatible on paper. The current package still lacks dimensioned fabrication drawings for six safety-critical custom assemblies: the rotated AIO adapter, high-current bus/guard, battery cradle and CG-adjustment range, Pi enclosure/mount, camera/pan-tilt/IR carrier, and cargo holder/latch. The user's rule that an incomplete physical drawing must not be called buildable therefore controls the overall verdict.

The best defensible freeze for those drawings is the existing 6S candidate, with the exact substitutions and bus architecture below. It is **not a final requirement-preserving propulsion selection**: the synchronized model gives 20.98494 useful minutes in its central case, but 18.20 minutes in a moderate-loss case and less in the stacked unfavorable case. The design preserves the twenty-minute requirement as an acceptance gate; it does not claim the aircraft has passed it. The final propulsion optimization found no cheaper documented candidate that removed this uncertainty.

Only these matrix states are used:

- **VERIFIED** — an authoritative specification, a direct compatibility rule, or a transparent calculation closes the paper interface.
- **REQUIRES PHYSICAL VALIDATION** — the paper design is coherent, but received-part inspection, assembly measurement, calibration, or testing is required.
- **INCOMPATIBLE** — a known conflict exists, or a missing exact drawing/part prevents a fabrication-ready claim.

## Frozen component candidate for drawing and commissioning

| Subsystem | Selected part or construction | Why it is the freeze candidate |
|---|---|---|
| Frame | TBS Source One V6 7-inch deadcat | Manufacturer 313mm frame with 30.5×30.5 and 20×20 stack patterns; published DXF is available. |
| Flight controller/ESC | MicoAir743v2-AIO45A, ArduPilot target | 3–6S, four 45A AM32 channels, H743, microSD, seven UARTs, one I2C bus, and auxiliary PWM. It must be installed at 45° with insulated damping and airflow. |
| Motors | 4× iFlight XING-E 2809 800KV | Exact manufacturer variant documents 19×19mm M3 mount, 5mm shaft, 61g including 260mm 18AWG leads, 24V test data, and 25.63A peak test point. |
| Props | 2× APC `LP07040E-B4` bundles | Each manufacturer bundle contains two 7×4E and two 7×4EP props plus metric adapter rings; two bundles provide one installed set and one complete spare set. |
| Flight battery | Nexus 6S2P Molicel P50B 10Ah, factory QS8 female, 8AWG, 7-pin JST-XH | 25.2V maximum, 120A pack rating, 900g approximate bare-pack value; use the existing 930g configured planning allowance until received. No pack cutting or connector replacement. |
| Main connector/wire | Genuine QS8 male; DFRobot FIT0580 8AWG and FIT0581 10AWG | QS8 is the flight disconnect; no XT60/XT90 flight adapter. Manufacturer wire listings give 190A for FIT0580 and 140A for FIT0581, subject to joint and installation validation. |
| Whole-pack monitor | Matek I2C-INA-BM | 0–85V, 150A shunt, default address 0x45, alternate 0x44/0x41. It remains upstream of every branch. |
| Distribution | Two C110 H02 copper bars, each 0.125×0.375×2.0in, on G10/FR4 with a vented polycarbonate touch guard | Exact stock geometry gives 30.24mm² cross-section per rail. This avoids the FCHUB single-output continuous-rating conflict and makes the branch topology explicit. |
| Main filtering | Panasonic EEU-FR1V102B, 35V 1000µF, installed at the AIO input; one spare | Voltage rating covers 6S maximum. It is one element of the transient design, not proof of waveform compliance. |
| Manual control | RadioMaster Pocket Crush M2 ELRS/FCC + RP1 V2 + RadioMaster 18650 pair | Pocket Crush preserves the Pocket M2 EdgeTX/ELRS interface at the lower observed manufacturer price. RP1 uses 5V and CRSF. Region must match the lawful operating configuration. |
| GNSS/compass | Holybro Micro M10, case/IST8310, SKU 12044 | Includes a 15cm JST-GH six-pin colored cable; 4.7–5.2V, 115200 baud, UART plus I2C compass. |
| Compute/video | Raspberry Pi 4B 2GB + Camera Module 3 NoIR standard + included 200mm 15-pin cable + 32GB microSD | Pi4 and Camera3 have the matching standard 15-pin CSI interface. Camera carrier and flex routing remain drawing work. |
| Compute power/interface carrier | Matek BEC12S-PRO at default 5.2V feeding both Pi 5V pins and at least two grounds through Adafruit #2310 Perma-Proto HAT | Raspberry Pi specifies 5V via GPIO header, minimum 3A. The BEC is 5A continuous; the HAT supplies an exact 2×20 mating carrier and also hosts logic conditioning. Input branch is fused. |
| Cooling | Adafruit #3368 5V fan + #3082 heatsink | Exact low-mass parts; installed airflow and Pi throttling must be tested in the guard. |
| Horizontal ranging | Waveshare D500 LiDAR Kit over USB | The kit includes USB adapter and cable; 5V/290mA typical. Keep the optical window and rotating field clear. |
| Downward ranging | TFmini-S on Mico UART4 | 5V±0.1V, 3.3V LVTTL, default 115200; use a verified 5V rail and direct crossed UART wiring. |
| Pan/tilt | Adafruit #1967, two analog micro servos on Mico PWM5/PWM6, powered from a separate 5V peripheral rail | 37g assembly, about 180° pan/150° tilt. Published servo variant and stall current are not fixed, so current and travel require received-part tests. |
| Night IR | 2× Waveshare IR Board B, fed by DFRobot DFR1015 configured to 3.3V | The boards are not mechanically/electrically compatible with Camera3 mounting screws; a separate insulated carrier and wired terminals are mandatory. |
| Visible light | 2× Adafruit #5162 cool-white RGBW NeoPixel + #1663 JST-SM pigtail; TI SN74AHCT125N level shifter on #2310 | #5162 is the in-stock same-format substitute for unavailable #5408. Each needs a strong 5V supply of at least 0.5A; the AHCT device converts Pi 3.3V data to 5V. |
| Cargo release | Adafruit #2776 solenoid + Pololu #2802 low-side RC switch + 2× Pololu #1402 SPDT lever switches | Solenoid is 5V/1.1A/12.6g with spring return. #2802 supplies a 3A low-side MOSFET, flyback protection, and safe-start; two independent switches sense closed/latched state. |
| Cargo | Custom removable enclosed holder for 250g cargo, provisional 170g holder mass | Must resist ordinary manual removal and release only after recipient face verification while landed with motors stopped. No complete drawing exists. |
| High-current assembly tool | Weller SP120, 120W/120V, 1/2in chisel | The Plusivo 60W kit remains for electronics; it is not credited as adequate evidence for QS8/8AWG/bus joints. The SP120 is the exact high-mass-joint tool candidate. |

### Explicit high-current topology

The frozen electrical order is:

`factory pack QS8F/8AWG → QS8M/8AWG aircraft lead → INA-BM positive shunt and direct 8AWG negative → 8AWG positive/negative bus bars → short FIT0581 10AWG pair → AIO VBAT/GND`.

All regulator inputs branch from the downstream bus, so the INA measures propulsion and auxiliary energy. The compute-BEC input has an inline 5A branch fuse; other branch protection must be selected from each received load test rather than guessed. The AIO capacitor connects directly across VBAT/GND with short leads. No flight-current path uses XT60, the charger adapter, or a small prototyping board.

Each C110 bar is 3.175×9.525×50.8mm, cross-section 30.24mm². Using 1.72×10⁻⁸Ω·m for copper gives approximately 28.9µΩ per bar; the positive-plus-negative pair dissipates approximately 0.67W at the 107.4A screen (`I² × 2R`). That calculation verifies the stock section, but not the joints, temperature rise, insulation, or mounting.

The bus drawing must place the two rails on a flame-retardant G10/FR4 substrate, keep them physically separated, provide nonconductive strain relief that carries every cable load, and use a separate vented polycarbonate touch guard. The bars and joints may not contact the carbon frame. Exact holes, creepage, lug/joint geometry, guard spacing, and aircraft position remain unresolved; this assembly is therefore not yet fabrication-ready.

### Compute and low-voltage allocation

- Matek BEC12S-PRO, default 5.2V: Raspberry Pi only, through Adafruit #2310 and both 5V header pins. Confirm at least 5.0V at the Pi under the full Pi+Camera3+D500 workload and stay within the Pi input requirement.
- Separate 5V peripheral rail: RP1, Holybro M10, TFmini-S, two #5162 lamps, two pan/tilt servos, and #2776 solenoid/#2802. The prior Hobbywing 5A AIR candidate is retained unless a final load ledger proves another selected rail. Do not parallel it with the Pi BEC or AIO 5V rail.
- AIO 12V output → DFR1015 input; DFR1015 is modified exactly as its maker instructs for 3.3V and powers only the two IR boards. The 12V rail and DFR1015 output must be verified before connecting IR hardware.
- Pi GPIO14/TX and GPIO15/RX cross to Mico UART1 RX/TX with common ground; both are 3.3V logic. Pi GPIO18 is reserved for RGBW data through one SN74AHCT125N channel. GPIO23 and GPIO24 are reserved for the two closed/latched switches, wired fail-safe normally closed to ground with pull-ups and software debounce. Unused AHCT inputs and output-enable pins receive deterministic ties, and the IC gets a local 0.1µF bypass capacitor.

### Flight-controller port allocation

| Function | Mico resource | Electrical/interface contract | State |
|---|---|---|---|
| Motors 1–4 | PWM1–4 / TIM1 | DShot group, mapped after the mandatory 45° board rotation | REQUIRES PHYSICAL VALIDATION |
| Pan and tilt | PWM5/PWM6 / TIM3 | Ordinary servo PWM, signal ground shared; servos powered separately | VERIFIED |
| Cargo solenoid | PWM7 / TIM4 via Pololu #2802 | Ordinary PWM/RC pulse, fail-safe inactive; do not configure PWM11 as serial LED | VERIFIED |
| Spare safety output | PWM8 / TIM4 | Same protocol group as PWM7; reserve for a later interlock, not lighting | VERIFIED |
| Pi MAVLink | UART1 | 3.3V crossed TX/RX/common ground | VERIFIED |
| Holybro GNSS | UART3 | 115200 UBX; 5V power; cable tail to solder pads | VERIFIED |
| TFmini-S | UART4 | 115200, 3.3V LVTTL, 5V±0.1V power | VERIFIED |
| ELRS RP1 | UART6/RCIN | CRSF, 5V, crossed TX/RX/common ground | VERIFIED |
| INA-BM + IST8310 | I2C1 | INA default 0x45; IST8310 nominal 0x0E; received addresses and pull-ups must be checked | REQUIRES PHYSICAL VALIDATION |
| Buzzer | BZ-/5V/GND | Finder-class self-powered buzzer; exact available SKU/cell inclusion must be re-frozen | INCOMPATIBLE |

## Complete compatibility matrix

### Mechanical, mass, clearance, and environment

| ID | Component/interface | Evidence and implication | State |
|---|---|---|---|
| M01 | Source One V6 frame kit | Manufacturer states 313mm, 173g, 6mm arms, plate thicknesses, stack patterns, and included fasteners/standoffs. | VERIFIED |
| M02 | XING motor-to-arm pattern | Motor is 19×19mm M3 and includes M3×11 screws; final screw engagement must not touch windings. | REQUIRES PHYSICAL VALIDATION |
| M03 | APC prop-to-XING shaft | Props include a 5mm metric ring; motor shaft is 5mm with M5 flange nut. Rotation and seating remain inspection items. | REQUIRES PHYSICAL VALIDATION |
| M04 | Static prop clearance | The published Source One DXF calculation gave 10.17mm minimum adjacent-disc gap and 14.54mm rear gap for 7-inch discs. | VERIFIED |
| M05 | Dynamic prop/flex clearance | No drawing proves blade flex, motor-axis tolerance, wire movement, or accessory clearance under thrust. | REQUIRES PHYSICAL VALIDATION |
| M06 | AIO physical size and mount | AIO is 36×36×8mm on 25.5mm M3; frame exposes 30.5/20mm patterns. An adapter is required. | VERIFIED |
| M07 | AIO 45° adapter drawing | Manufacturer now requires a 45° installation, insulated damping, correct arrow/orientation, and airflow. No dimensioned 25.5-to-frame adapter exists. | INCOMPATIBLE |
| M08 | AIO rotated envelope | A 36mm square at 45° has a 50.91mm axis-aligned envelope. Clearance to frame, bus, USB, SD, and wiring is not drawn. | REQUIRES PHYSICAL VALIDATION |
| M09 | Battery size/mass | Nexus advertises approximately 139×48×72mm and 900g for the 6S pack; factory options and lead exit can change the delivered envelope. | REQUIRES PHYSICAL VALIDATION |
| M10 | Pack cradle/straps/prop plane | Three 250×20mm straps are plausible, but no cradle drawing proves restraint, QS8 access, rotor-plane clearance, or ordinary handling loads. | INCOMPATIBLE |
| M11 | Empty-aircraft CG | Prior DXF work places the rotor centroid about 32.626mm aft of the chosen longitudinal origin. No final component-coordinate ledger locates actual CG there. | INCOMPATIBLE |
| M12 | Loaded CG and 250g cargo | Holder/cargo moment and adjustment range are absent. Loaded control cannot be inferred from total mass alone. | INCOMPATIBLE |
| M13 | Pi guard/mount/cooling | Parts and a 70g assembly allowance exist, but no guard drawing proves attachment, prop clearance, ventilation, connector access, or crash restraint. | INCOMPATIBLE |
| M14 | D500 mount/field | Maker supplies dimensions/models; final mast and 360° scan clearance around frame, battery, GPS, lamps, and wiring are not drawn. | INCOMPATIBLE |
| M15 | TFmini downward view | Sensor dimensions are known; no leg/mount drawing proves an unobstructed downward cone through all attitudes. | INCOMPATIBLE |
| M16 | Pan/tilt/camera carrier | #1967 platform and Camera3 board dimensions are compatible as rectangles, but hole pattern, lens clearance, flex bend radius, end stops, and vibration restraint are not drawn. | INCOMPATIBLE |
| M17 | IR-board carrier | IR Board B screw contacts are designed for Waveshare Camera E/F/H, not Camera3. The direct screw-mount proposal is incompatible; a fully insulated carrier is required. | INCOMPATIBLE |
| M18 | Visible-light mounts/thermal path | #5162 dimensions are known; beam aim, heatsinking/airflow, attachment, and glare into Camera3/D500 are not drawn. | INCOMPATIBLE |
| M19 | Cargo enclosure/latch | No dimensioned holder, hinge, captive fasteners, latch geometry, access boundary, or proof-load target exists. | INCOMPATIBLE |
| M20 | Landing gear and ground clearance | The planning allowance does not define leg geometry or clearance for TFmini, camera, bus guard, holder, or solenoid. | INCOMPATIBLE |
| M21 | Dry/daylight temperature envelope | Approved endurance evaluation is dry, 15–30°C; Pi4 maker operating limit is 0–50°C. Component-level ranges overlap. | VERIFIED |
| M22 | Fully assembled mass | Prior 1897.251g reference and 2317.251g cargo-loaded figures predate the exact bus, HAT, switches, stronger iron (ground-only), and final custom drawings. | REQUIRES PHYSICAL VALIDATION |

### Propulsion, power, charging, and harnesses

| ID | Component/interface | Evidence and implication | State |
|---|---|---|---|
| P01 | 6S pack-to-AIO voltage | Pack maximum 25.2V is below AIO 27V/6S maximum and below the 35V capacitor rating. | VERIFIED |
| P02 | XING/APC model | APC manufacturer prop data plus published motor KV/resistance supports the documented model; it is not an exact installed bench map. | REQUIRES PHYSICAL VALIDATION |
| P03 | AIO ESC current | Four 45A continuous channels exceed the model's 20.48A-per-motor unfavorable corner, with maker-required cooling. | VERIFIED |
| P04 | Pack current screen | 120A factory pack rating exceeds 1.25× the 85.923A modeled pack corner (107.404A). | VERIFIED |
| P05 | QS8 current screen | The selected genuine QS8 path has adequate published headroom in the prior power audit; received housing/contact convention and joints remain checks. | REQUIRES PHYSICAL VALIDATION |
| P06 | 8AWG main wire | FIT0580 maker lists 10mm², 190A allowable current, 600VAC/3kVDC, and −60–200°C. Short installed length is required. | VERIFIED |
| P07 | C110 bus conductor | Exact geometry and resistance/loss calculation close conductor cross-section on paper. | VERIFIED |
| P08 | Bus carrier/guard fabrication | Exact G10 grade/thickness, polycarbonate guard, hole pattern, creepage, joint positions, mounting, and strain relief are not in a dimensioned drawing. | INCOMPATIBLE |
| P09 | INA-BM placement | Positive passes through the shunt; negative bypasses it but shares system ground. Every branch is downstream. | VERIFIED |
| P10 | INA high-current joints | Matek warns to use the active top conductive ends, not the inactive underside pad. 8AWG fit, solder wetting, support, resistance, and temperature require assembly checks. | REQUIRES PHYSICAL VALIDATION |
| P11 | Bus-to-AIO 10AWG | FIT0581 is maker-rated 140A. AIO VBAT/GND pad dimensions and 10AWG acceptance are unpublished. | REQUIRES PHYSICAL VALIDATION |
| P12 | AIO input capacitor | 35V exceeds 25.2V. Lead length, polarity, attachment, and actual transient behavior require inspection/logging; no fast-waveform claim is made. | REQUIRES PHYSICAL VALIDATION |
| P13 | Compute BEC input/output | 9–55V input and 5.2V/5A output cover 6S and Pi's 5V/3A requirement. It lacks reverse-input protection. | VERIFIED |
| P14 | Pi power carrier | Pi4 officially supports 5V via GPIO, minimum 3A; #2310 mates the 40-pin header. Parallel 5V/ground pin current, HAT traces, fuse, and joint temperature are not manufacturer-qualified for this exact 3A path. | REQUIRES PHYSICAL VALIDATION |
| P15 | Peripheral 5V rail | Hobbywing 5A AIR accepts 2–8S and is 5A continuous. Final coincident lamps+servos+solenoid+GPS+receiver+TFmini peak ledger is incomplete because #1967 servo stall current is unspecified. | REQUIRES PHYSICAL VALIDATION |
| P16 | DFR1015 IR supply | 12V input is inside 7.5–30V; 3.3V/3A published no-heatsink output exceeds two nominal 3W lamps only under the documented thermal conditions. | REQUIRES PHYSICAL VALIDATION |
| P17 | Branch fusing | A fuse series and candidate 5A holder/fuse have been researched, but final branch currents and exact installed quantities are not frozen. | INCOMPATIBLE |
| P18 | Branch connectors/cut list | No final wire-by-wire table gives connector manufacturer/part, gauge, length, color, termination, fuse, and destination for every branch. | INCOMPATIBLE |
| P19 | Grounding/backfeed | Architecture calls for one common reference and forbids paralleling regulator outputs; continuity and startup tests remain required. | REQUIRES PHYSICAL VALIDATION |
| P20 | Charger cell count | ToolkitRC M6AC accepts up to 6S. The flight pack requires a 6S seven-pin JST-XH balance extension. | VERIFIED |
| P21 | Charge-current connector path | QS8-to-charger XT60 is ground-only and capped at 5A, below the pack's 10A charge limit. It never flies. | VERIFIED |
| P22 | Charger mains variant | Exact US mains version, firmware, chemistry, 4.2V/cell endpoint, balance accuracy, and delivered leads must be confirmed. | REQUIRES PHYSICAL VALIDATION |
| P23 | Battery safety/storage | Factory pack remains sealed and unmodified; bag is storage/charging containment only and is not represented as fireproof. | VERIFIED |
| P24 | High-current soldering tool | Weller SP120 is 120W with 1/2in chisel for high-mass joints; the actual joint process still requires practice sections, pull inspection, and temperature validation. | REQUIRES PHYSICAL VALIDATION |
| P25 | Twenty useful minutes | Central paper model passes narrowly; moderate and stacked cases fail. Three complete Q74 reference cycles across at least two days remain the actual acceptance test. | REQUIRES PHYSICAL VALIDATION |
| P26 | Protected reserve | Approved rule is `max(20Wh, 1.5 × measured recovery energy)`, with only upward replacement from measured needs. | VERIFIED |
| P27 | Payload endurance/control | The prior loaded model gives only about 7.40 useful minutes with reserve and 1.368 endpoint thrust/weight centrally. Cargo delivery capability is not flight-qualified. | REQUIRES PHYSICAL VALIDATION |

### Data, firmware, compute, sensing, and control

| ID | Component/interface | Evidence and implication | State |
|---|---|---|---|
| D01 | ArduPilot board support | Stable `MicoAir743v2` Copter build exists; checked build is 4.7.1 and advertises INA2XX, IST8310, CRSF, scripting, mount-servo, TFmini, NeoPixel, gripper, MAVLink signing, follow, and avoidance features. | VERIFIED |
| D02 | Exact firmware artifact | The final `.apj`, checksum, bootloader state, parameter file, and rollback artifact are not frozen in the repo. | INCOMPATIBLE |
| D03 | 45° attitude/motor mapping | Board orientation, AHRS rotation, motor order/direction, and props-off actuator mapping must be configured and verified after the mandatory physical rotation. | REQUIRES PHYSICAL VALIDATION |
| D04 | Pi/Mico UART | UART1 is available; both endpoints use 3.3V UART and common ground. Crossed TX/RX is paper-compatible. | VERIFIED |
| D05 | MAVLink security | ArduPilot build supports signing, but keys, fail-closed unsigned-message policy, link-loss behavior, and provisioning procedure belong in the reviewed spec. | INCOMPATIBLE |
| D06 | RP1/Mico CRSF | UART6/RCIN and 5V are compatible with RP1 V2; binding, region, failsafe, antenna placement, and coexistence require test. | REQUIRES PHYSICAL VALIDATION |
| D07 | Holybro GNSS UART | UART3 and 115200 match the module default; included cable provides the connector side. Tail-to-pad order/polarity must be continuity-checked. | REQUIRES PHYSICAL VALIDATION |
| D08 | IST8310 + INA I2C addresses | Nominal addresses 0x0E and 0x45 do not collide. Received variant, straps, bus voltage, pull-ups, orientation, and discovery remain tests. | REQUIRES PHYSICAL VALIDATION |
| D09 | TFmini UART | UART4, 3.3V LVTTL, and 115200 match. The sensor's unusually tight 5V±0.1V supply must be measured at load. | REQUIRES PHYSICAL VALIDATION |
| D10 | D500 USB | Kit includes CP2102 adapter and USB-A-to-microUSB cable; Pi4 provides USB. Cable retention, enumeration, bandwidth, and reset recovery need testing. | REQUIRES PHYSICAL VALIDATION |
| D11 | Camera3 CSI | Pi4 and Camera3 use standard 15-pin 1mm CSI; the 200mm cable is included. | VERIFIED |
| D12 | Moving CSI cable | Standard FFC is not specified for repeated pan/tilt flexing. Slack loop, bend radius, retention, and cycle life require a drawn route and test. | INCOMPATIBLE |
| D13 | Pi thermal/load capability | Pi4 can host camera and USB sensor, but no measured full model/video/navigation load, undervoltage, throttling, or reboot evidence exists in the final guard. | REQUIRES PHYSICAL VALIDATION |
| D14 | Pan/tilt PWM | Stable build includes servo mount support and PWM5/6 are a separate TIM3 group. Direction, trim, limits, current, and cable snag tests remain. | REQUIRES PHYSICAL VALIDATION |
| D15 | Visible-light data | SN74AHCT125N at 5V accepts Pi 3.3V high and drives NeoPixel data; local bypass and deterministic unused inputs are required. | VERIFIED |
| D16 | Visible-light stock substitution | Adafruit #5408 and #1787 were unavailable in the fresh direct check. #5162 and TI SN74AHCT125N are the frozen purchasable replacements. | VERIFIED |
| D17 | Solenoid electrical drive | #2802's 3A low-side output and integrated flyback exceed #2776's 1.1A nominal draw. | VERIFIED |
| D18 | Solenoid safety state | PWM7 can command #2802; firmware must default off at boot, link loss, disarm, crash, and verification failure. No final truth table/parameter/script artifact exists. | INCOMPATIBLE |
| D19 | Door/latch switches | Two SPDT switches enable independent fail-safe closed/latched observations. Exact bracket actuation and wire-break/open-state behavior need physical test. | REQUIRES PHYSICAL VALIDATION |
| D20 | Recipient verification/release | Requirement is face-verified recipient, landed, motors stopped, then release; no bypass by voice, phone, or radio. The hardware can support the gate, but software/acceptance evidence does not exist. | REQUIRES PHYSICAL VALIDATION |
| D21 | Owner biometric arming | Pi-mediated face+voice for every new arming is an approved behavior; secure boot/provisioning, liveness, timeout, cancellation, and FC fail-closed enforcement remain specification/implementation work. | REQUIRES PHYSICAL VALIDATION |
| D22 | Independent emergency radio | ELRS is independent of the phone/Pi app path and can provide emergency control. Exact mode/failsafe behavior must be commissioned. | REQUIRES PHYSICAL VALIDATION |
| D23 | iPhone local link/video | Pi4 has dual-band Wi-Fi and iPhone17Pro is owned, but no final antenna placement, RF coexistence, locked-pocket voice flow, video latency, thermal, or disconnect recovery evidence exists. | REQUIRES PHYSICAL VALIDATION |
| D24 | Data retention/privacy | Local-only capture and bounded deletion policy remain approved planning constraints. They do not change component fit; software enforcement is not yet validated. | REQUIRES PHYSICAL VALIDATION |

## Rejected and accepted substitutions

| Candidate | Decision | Reason |
|---|---|---|
| EMAX Pro2810 950KV + Nexus 5S2P P50B | INCOMPATIBLE | EMAX's official page omits motor mounting pattern, shaft, leads, resistance, and exact test table. The synchronized screen also produced about 19.25 useful minutes at endpoint and required 128.126A at the 1.25× current criterion, above the pack's 120A and QS8's cited 110A path rating. |
| XING 800KV + 5S3P P50B | INCOMPATIBLE | Mass and low-voltage control screen failed; weak-corner thrust/weight was reported about 1.141 even before cargo. |
| Original 6S XING/APC/P50B | REQUIRES PHYSICAL VALIDATION | It remains the only examined candidate with documented mechanical/electrical motor interfaces and the accepted current screen. Endurance sensitivity is marginal, so it is a commissioning candidate, not a compliance claim. |
| Matek FCHUB-12S V2 as single AIO feed | INCOMPATIBLE | Each output is 70A continuous/110A burst. One output is below the 85.923A upper modeled steady corner; paralleling outputs would create another undocumented convergence onto the AIO input. |
| C110 dual-bar distribution | REQUIRES PHYSICAL VALIDATION | Conductor geometry and loss are calculable; it avoids the PDB output neck-down. The exact protected carrier and joint drawing is still mandatory. |
| APC `LP07040E-B4` bundles | VERIFIED | Same exact E/EP propeller models and adapter rings, lower price and simpler quantity accounting than eight singles. |
| RadioMaster Pocket Crush M2 ELRS/FCC | VERIFIED | Same Pocket M2 functional family and ELRS/FCC interface at the lower observed manufacturer price. Cosmetic difference does not affect aircraft interface. |
| Adafruit #5162 + TI SN74AHCT125N | VERIFIED | Purchasable replacements for out-of-stock #5408/#1787; electrical interfaces are documented. Cool-white instead of natural-white is not an approved capability reduction. |
| Cut cable from an official Pi wall supply | INCOMPATIBLE | A severed USB-C lead has no authoritative proof of source-role CC advertisement or conductor pinout. Pi power instead uses the maker-supported 5V GPIO input through a fixed carrier. |

## Fabrication package required before “buildable” may be claimed

The following are design outputs, not post-purchase surprises. Pending physical tests are allowed; missing drawings and netlists are not.

1. **One dimensioned top/side assembly drawing or CAD model** with the exact frame revision, rotor discs, AIO at 45°, bus/guard, battery/lead bend zones, Pi/guard, GPS, D500, TFmini, pan/tilt/camera/IR/lights, landing gear, and empty/loaded cargo holder.
2. **CG and mass table tied to that drawing**, including each part's coordinate, fasteners, wire, guard, adhesives, 930g pack allowance, empty CG adjustment range, loaded CG, and a no-credit contingency. Re-run endurance/control from the same mass revision.
3. **Six dimensioned custom-part drawings**: AIO adapter/dampers; bus substrate/guard/strain relief; pack cradle; Pi guard/fan bridge; pan/tilt/Camera3/IR/light carrier; cargo holder/hinge/latch/switch brackets/landing legs.
4. **Electrical schematic and wire cut list** for every net, with part number, quantity, gauge, insulation, length, color, connector/terminal, splice/joint, fuse, source, destination, common-ground point, and strain relief. It must include the C110 bar joint pattern and AIO pad termination.
5. **Port and parameter manifest** containing firmware checksum, board rotation, motor order/direction, PWM grouping, UART/I2C settings, INA address and calibration, battery thresholds/reserve behavior, ELRS modes/failsafe, servo limits, switch polarity/debounce, and all boot/link-loss defaults.
6. **Safety truth tables** for arming and cargo release. Hardware outputs must remain inactive until every required condition is simultaneously true; any stale/unknown/failed input closes the gate.
7. **Commissioning procedure** that starts disconnected/props-off, then validates rails, shorts, polarity, sensor enumeration, actuator direction/limits, logging, thermal/current behavior, restrained low-power propulsion, manual Q73 flights, Q74 endurance, and finally separate loaded-cargo trials. Failure keeps the affected capability disabled.

Until items 1–6 exist and cross-check, the package's overall state is **INCOMPATIBLE with the requested “physically buildable complete drone” label**. Completing them does not mark the aircraft flight-ready; it moves the remaining items to **REQUIRES PHYSICAL VALIDATION**.

## Fresh primary sources

- [TBS Source One V6 product and design files](https://www.team-blacksheep.com/products/prod:source1v6)
- [MicoAir743v2-AIO45A official specification](https://micoair.com/flightcontroller_micoair743v2_aio_45a/)
- [iFlight XING-E 2809 official product](https://shop.iflight.com/motors-cat88/XING-E-2809-Cinelifter-Motor-Pro2064?order=ASC&sort=p.model)
- [APC 7×4E four-prop bundle](https://www.apcprop.com/product/7x4e-b4/)
- [DFRobot FIT0580 8AWG](https://www.dfrobot.com/product-1756.html) and [FIT0581 10AWG](https://www.dfrobot.com/product-1757.html)
- [Matek INA-BM](https://www.mateksys.com/?portfolio=i2c-ina-bm) and [BEC12S-PRO](https://www.mateksys.com/?portfolio=bec12s-pro)
- [RadioMaster Pocket Crush](https://radiomasterrc.com/products/pocket-crush-radio-controller) and [RP1 V2](https://radiomasterrc.com/products/rp1-expresslrs-2-4ghz-nano-receiver)
- [Holybro Micro M10](https://holybro.com/products/micro-m10-gps)
- [Raspberry Pi 4 specification](https://www.raspberrypi.com/products/raspberry-pi-4-model-b/specifications/), [Camera Module 3](https://www.raspberrypi.com/products/camera-module-3/), and [camera interface documentation](https://www.raspberrypi.com/documentation/accessories/camera.html)
- [Adafruit #2310 Perma-Proto HAT](https://www.adafruit.com/product/2310), [#1967 pan/tilt](https://www.adafruit.com/product/1967), [#5162 RGBW light](https://www.adafruit.com/product/5162), [#1663 JST-SM cable](https://www.adafruit.com/product/1663), and [#2776 solenoid](https://www.adafruit.com/product/2776)
- [TI SN74AHCT125N authorized listing and datasheet](https://www.digikey.com/en/products/detail/texas-instruments/SN74AHCT125N/375798)
- [Pololu #2802 RC low-side switch](https://www.pololu.com/product/2802) and [#1402 SPDT lever switch](https://www.pololu.com/product/1402)
- [Waveshare D500](https://www.waveshare.com/d500-lidar-kit.htm), [TFmini-S](https://www.waveshare.com/tfmini-s-lidar-range-sensor.htm), and [IR Board B](https://www.waveshare.com/infrared-led-board-b.htm)
- [DFRobot DFR1015](https://www.dfrobot.com/product-2599.html)
- [C110 H02 bar offer](https://alcobrametals.com/copper/rectangular-flat-bar/) and [exact ASTM-B187 one-foot fallback](https://www.onlinemetals.com/en/buy/copper/0-125-x-0-375-copper-rectangle-bar-110-h02/pid/4258)
- [Weller SP120 authorized listing](https://www.digikey.com/en/products/detail/apex-tool-group/SP120/4525514)

## Local provenance

Research used the live main checkout, whose planning documents and research reports are not necessarily contained by the current Git commit. SHA-256 values at the time of this audit:

| Local source | SHA-256 |
|---|---|
| `CLAUDE.md` | `0FEC96250C4D0D5CB4CC62B534FDB25ABBFE2A97AB13FAAC412EC3BD89DEAE3B` |
| `docs/agents/workflow.md` | `47CC6A80D36F95BB0CE298652682D5C7C29B6C7E9804E49332900944E049B094` |
| `.scratch/biometric-guard-drone/map.md` | `DC527EC9B47691939498F71A28EA21CF30D0F728387EC0307C1A7D9AE6A6DBB1` |
| `.scratch/biometric-guard-drone/issues/10-milestone-ladder.md` | `0198CA4D93C85DE697853EE51152148F3B56BAA1E5A6C3014ECFD1EBC9DB99E3` |
| `docs/research/least-cost-bom-2026-08-31.md` | `F31FFA6C3EE4D48AFC7FC7714D0419BCFE646C241077A610832FCBAF50DC3E2E` |
| `docs/research/least-cost-integration-2026-08-31.md` | `D54DE67594BBE18E32FE49EB35EDF99AA2FEDB12F9F84C3AEF39EDB47026C122` |
| `docs/research/least-cost-power-path-2026-08-31.md` | `BAFCADB71A50CE52ECE1902A92DE5594CF32A6EF8E539DC3BC4B01CE70EAC84B` |
| `docs/research/least-cost-propulsion-2026-08-31.md` | `91CA95194E47A8A9BCE283B2FF93AB0BB6F55FBA8ACE333304A9F57F8DC5CA0A` |
| `docs/research/least-cost-pan-tilt-supplement-2026-08-31.md` | `3EC437E33053BFB1B20F0B7608A48B53CF3399D11326AD66B05D5C0AD44A3A4C` |
| `docs/research/final-propulsion-optimization-2026-09-03.md` | `4CE1C362FC724CD37A89066903070198477BF5B5EDC1CD5178B7CC8D89690A52` |

The exact final cost remains owned by the synchronized cost report. This audit intentionally does not copy a stale total or imply that a parts subtotal includes fabrication, shipping, tax, rework, or validation.
