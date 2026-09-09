# Baseline R1.1 electrical build definition

Status: **DESIGN FOR REVIEW — NOT RELEASED FOR FABRICATION, POWER OR PROCUREMENT**. Q75 freezes the component architecture and closes issue 10 planning; it does not certify this harness. The [netlist](harness-netlist.csv) is the controlling point-to-point definition. Read it with the mechanical drawings, firmware manifest and safety truth tables in this directory. No hardware or software was installed during preparation.

R1.1 corrects only the newly proven incompatible QS8-S aircraft support lead under Q75's affected-subsystem correction authority. The selected battery, motors, FC, regulators and capabilities remain frozen. The two sensor-contact/level-shifter wiring corrections and D500 cable reach completion do not downgrade a requirement.

## Corrections exposed by detailing

1. Switches use **COM to ground and NO to the input**, not an unqualified NC-to-ground instruction. In the required mechanical arrangement, the safe condition positively depresses the lever. Removing the holder, opening the lid or breaking either conductor opens the circuit and reads unsafe. NC remains insulated and unused. This corrects electrical implementation without changing the approved recipient gate.
2. Use all four channels of the already selected SN74AHCT125N: GPIO18 for LEDs; FC M7 for release; M5 for pan; M6 for tilt. This avoids assuming that the 5V-powered RC switch or unspecified supplied servos recognize 3.3V pulses. The FC and Pi never receive the translated 5V outputs.
3. Only AIO 5V powers RP1, M10, TFmini-S, INA logic and Finder. The older compatibility report's prose putting those sensors on the peripheral rail is superseded by this exact allocation. External 5V/5.2V outputs are not tied to AIO 5V.
4. GPIO18 requires the Pi's PWM audio disabled. It is not shared with a fan PWM controller, I2S sound interface or another waveform generator. Voice arrives through the approved phone path; disabling analog PWM audio removes no selected microphone hardware.
5. The old one-foot 24AWG purchase does not cover the completed harness. The support quantities below replace that incomplete quantity assumption. They do not reopen component selection or imply a delivered-price quote.

## Netlist conventions and construction datum

Every `W` record is one conductor or a stated factory cable; `C` records are carrier connections/passives; `NC` records are intentionally unused terminals. Lengths are **maximum cut allocations in mm**, including service slack. They are not measured installed lengths. Trim only after the mechanical routing overlay; any longer route needs mass, loss and clearance review. A factory cable is not to be cut at its device connector. CSV evidence keys resolve in the source register below.

`GND` is one electrical net, distributed by dedicated returns: pack negative -> copper negative bar -> AIO and both regulator negative inputs. Nonisolated regulator grounds connect their own output returns to this net. Load current returns through its own appropriately sized pair, never through a UART/I2C ground, carbon frame, mount, servo signal lead or Pi header signal. Signal-reference wires run alongside their signals; the existence of multiple ground routes does not authorize relying on a thin signal wire after a main-return failure. Test return continuity and loss before signal connection.

On the 40-pin Pi header, **physical** pin numbers are used: 1=3.3V, 2/4=5V, 6/9/14/20/25/30/34/39=ground, 8=GPIO14 TX, 10=GPIO15 RX, 12=GPIO18, 16=GPIO23, 18=GPIO24. Locate physical pin1 from the PCB mark and official drawing; do not infer it from the aircraft's orientation. #2310 mates one-to-one with that header. Solder no propulsion conductor to #2310.

FC endpoints name the manufacturer's **silkscreen signal**, followed in the CSV by the MCU pad where useful. They do not invent a numbered connector. Direct-solder signal ends avoid an undocumented Mico cable housing assignment. Never solder to the MCU package. Unpublished AIO battery-pad dimensions remain a received-part gate; do not drill them, remove strands to make 10AWG fit, or substitute a smaller feed without a reviewed transition.

## Main power and protection

**Genuine incompatibility discovered during detailing:** the cost ledger's$8 QS8-S/8AWG/50mm listing is a **two-pack series adapter**, not a straight single-pack pigtail. Its maker specifies two male connectors and the [maker photograph](https://qsconnector.com/cdn/shop/products/s-l1600_13_700x700.jpg?v=1642992196) shows the series bridge. It cannot be installed unchanged in this one-pack aircraft. This is source evidence, not a future physical-validation uncertainty. The affected aircraft-disconnect selection must be corrected; do not bridge an unused connector, cut the series harness informally or buy it expecting a straight lead. The existing bare QS8 part is presently allocated to ground charging only.

**Applied R1.1 repair:** use a **second genuine bare QS8 male**, the same documented part already selected for the separate charging lead. Solder a100mm red8AWG conductor from its positive cup to INA.BAT+, a150mm black8AWG conductor from its negative cup to BUS-, and a50mm red8AWG conductor from INA.ESC+ to BUS+. No intermediate8AWG butt splice or unused connector remains. Protect both solder cups with the maker housing/cover and insulation; fixture without a live battery, prevent contact movement and clamp each cable before the connector. Qualified Hakko process, solder wetting, polarity, insertion, resistance, pull and thermal tests remain mandatory. The factory battery cable is not modified. Named-parts arithmetic for this one correction is **-$8.00 +$2.35 =-$5.65**, excluding other support completions.

Positive passes through INA `BAT+` then `ESC+`; negative bypasses the shunt. Use its active top solder ends, not an assumed bottom mechanical pad. All loads, including external BECs, branch after the shunt. Copper bars remain isolated from the carbon frame; mechanical guards and nonconductive clamps take cable loads. Install one Panasonic EEU-FR1V102B across AIO VBAT/GND with the negative stripe at GND, leads as short as practical (target <=10mm); retain the second as spare.

F1 and F2 are separate Littelfuse 0FHM0001LXN / 0297005.WXNV 5A/32V input branches. Put each fuse within 30mm routed distance of its positive-bar takeoff; protect the short unfused section in its own sleeve and clamp. Preserve supplied holder conductors; a holder lead is not replaced by thinner wire. Never fuse only the negative return. These fuses protect bus-fed branches; a 5A input fuse does **not** prove protection of a small output wire or a servo, nor is it a main-battery fault interrupter. The main path remains unfused as in the frozen architecture, making its isolation, guard and disconnect access mandatory.

BEC12S-PRO stays at its default 5.2V. Split its output at the carrier into **two equal 22AWG positive tails to physical pins2/4 and two equal 22AWG return tails to6/9**. Bring the 18AWG trunk to insulated splice points outside the HAT trace area; solder the four tails directly at their header through-hole joints rather than assuming an arbitrary long HAT trace can carry 3A. Pins14/20 serve low-current signal references. This remains a custom, unqualified power interface until each path's drop and temperature are measured. Never plug a second Pi USB-C power source into the aircraft while this feed is connected.

Hobbywing UBEC output is set to5.0V and forms a separate peripheral star. Both servos, both RGBW lights and release electronics use this star. The DFR1015 has only its 3.3V selection bridged (remove default5V bridge); input comes from AIO12V, not the battery or Camera3. IR boards receive3.3V at their marked power contacts on insulated carriers, never through Camera3 mounting screws.

Design load screens remain: main107.404A component-rating screen; compute source5A/whole Pi input3A-capable; peripheral5A including 1.1A solenoid and up to1A lights plus measured servo demand; AIO5V2A; AIO12V2A. No load addition is justified by a fuse value. Measure TFmini supply at its connector within4.9–5.1V across load cases; if it fails, isolate the affected rail redesign and preserve the sensor requirement. Release while servos move is prohibited until coincident-load characterization demonstrates adequate margin.

## Carrier assembly U1 and passive schedule

Use TI **SN74AHCT125N PDIP14**, not an HC125 substitution. With notch upward in a top view, pin1 is upper left, pins1–7 descend left side, pins8–14 ascend right side. Pin14 goes only to peripheral5V; pin7 goes to peripheral return. U1 lives on #2310 with a visibly separated peripheral5V island: do not bridge it to the HAT's Pi5V rails. Use insulated point-to-point wire for crossing tracks. Inspect the bare carrier's existing copper connections before soldering.

| Channel | Input | Output | Output-enable |
|---|---|---|---|
| 1 | U1.2 from Pi physical12 / GPIO18 | U1.3 through330ohm to first light DIN | U1.1 toGND |
| 2 | U1.5 from FC M7 | U1.6 to Pololu RC IN | U1.4 toGND |
| 3 | U1.9 from FC M5 | U1.8 to pan signal | U1.10 toGND |
| 4 | U1.12 from FC M6 | U1.11 to tilt signal | U1.13 toGND |

- R1–R4: 10kohm, 1%, >=0.125W, one from each U1 input toGND; inputs remain low while upstream GPIOs are high impedance.
- R5: 330ohm, 1%, >=0.125W, between U1.3 and first lamp DIN, at the receiving end of the data run.
- R6/R7: 4.7kohm, 1%, >=0.125W, GPIO23/GPIO24 to Pi3.3V; do not pull either input to5V.
- R8/R9: 330ohm, 1%, >=0.125W, in the two switch signal paths before the Pi inputs. Closed-input divider is approximately `3.3*330/(4700+330)=0.216V`; actual input thresholds and contacts are checked during commissioning.
- C1: 100nF, >=16V X7R, within10mm of U1.14/U1.7. C2/C3:100nF, >=16V X7R, each switch GPIO toGND at the carrier.
- C4: 1000uF, >=10V low-ESR electrolytic across peripheral star at first lamp feed, marked polarity. This supports LED transients; it does not replace measured servo/rail qualification.
- For reproducible procurement use Yageo MFR-25FBF52-10K, -330R, -4K7 through-hole resistors; KEMET C315C104K5R5TA 100nF; Nichicon UHE1A102MPD1000uF/10V, subject to current authorized-source confirmation. These instantiate the existing passive/support allowance; no purchase is authorized.

All channels are allocated; there are no floating unused buffer inputs. Holding buffer inputs low prevents continuous ON pulses but does not guarantee LEDs extinguish after a host crash: addressable pixels can retain their last color until commanded/reset. Nor can a buffer or #2802 distinguish a valid-looking stale PWM stream from a genuine authorization. Those are firmware/system safety gates, not properties of a level shifter.

## Release and holder sensing

Pololu #2802 is powered at its `VCC` and `LOAD HIGH` from peripheral5V with both optional power bridges **open**. Its `GND` goes to peripheral return; `VRC`, `GOOD` and `OUT` are unused insulated pads. Do not connect its5V status outputs to Pi GPIO. `LOAD LOW` is the switched solenoid negative, not a general ground connection. `LRN` remains open except for a documented unpowered-load setup procedure.

The design commands1000us OFF and2000us ON at50Hz, restores maker threshold/direction defaults, and tests them with the actuator disconnected. Maker safe-start needs a valid OFF before ON; missing pulses turn the output off after about130ms and re-enter safe-start after about630ms total. A continuing ON waveform survives this mechanism. The firmware manifest must therefore prove bounded release duration and timeout-to-OFF even on companion/process failure; safe-start alone is not the security gate. Reference [Pololu guide](https://www.pololu.com/docs/0J60/all).

Switch A must be **aircraft-mounted and actuated by a conjunctive mechanical feature**: the holder is fully seated against its stops AND its lid is closed. Switch B asserts only with the latch bolt fully engaged through the aligned strike. A disconnected/missing/partially seated holder must make A unsafe even if the bolt is extended. Two ordinary switches mounted solely on the removable holder cannot independently prove its attachment. Test each mechanical condition with a fixture before powered release.

Safe sensing uses active-low logic; stable0 on both inputs is necessary, never sufficient, for release. Open/wire-break reads1. A short to ground or welded contact can falsely assert safe; this simple circuit does not detect every wiring fault. Full stroke tests, preflight transition checks, continuity/isolation inspection and the tamper-resistant mechanical path remain mandatory. Do not call an absent holder a sensor failure during ordinary no-delivery flights: mission configuration explicitly disables delivery and keeps release OFF.

## Connectors and orientations

| Interface | Mating/view definition and action |
|---|---|
| Battery/QS8 | Match actual conductive contact sex, molded polarity and full insertion, not the word male alone. Factory pack lead remains untouched. Red is positive only after meter confirmation. Photograph both mating faces with '+'/'-' labels; power cannot be applied until continuity agrees. |
| AIO | Direct solder at maker-labeled VBAT/GND, RX/TX, M5–M7, SDA/SCL,5V/12V and buzzer pads. Received silkscreen/model must match sourceS1; no invented pitch, pad width or connector pin sequence. |
| Holybro M10 | Supplied JST-GH6 lead. In the maker **antenna/top view, arrow forward and socket at bottom**, leads left-to-right are5V red, RX white, TX blue, SCL yellow, SDA green, GND black. This is a board top view, not a view into the loose cable plug. Cross RX/TX to the FC; verify tail continuity before solder. |
| INA-BM | Supplied JST-GH4 lead, matched to printed5V/SCL/SDA/G. The two sockets are mirrored in the maker top-view drawing; do not reuse left-to-right order on the opposite socket. Use the socket with adjacent printed5V,SCL,SDA,G order; leave the other empty. |
| TFmini-S | Preserve its supplied10cm cable and identify5V/GND/TX/RX by the received TFmini-S manual and continuity. Vendor descriptions conflate GH1.25 and Molex51021; **do not buy a same-pitch substitute or infer cavity numbers from TFmini Plus**. Netlist endpoint functions are frozen; exact received connector order is a hold point. |
| RP1 | Direct solder at the receiver's5V/GND/TX/RX labels. Antenna stays on its factory RF mate; snap/coax retention checked without crushing cable. |
| Servos | Supplied three-wire plugs retained and secured to insulated three-pin male headers on fixed carriers: signal/end, +5V/center, GND/end, assigned only after maker/received-lead check. No hobby-color-only polarity assumption. Reds must never reach an FC power pin. |
| NeoPixels | Existing #1663 JST-SM pigtail mates first lamp **input**; lamp1 OUT mates lamp2 IN. Verify DIN/DOUT arrows,5V/GND and both mating contacts before solder; keyed housing alone does not certify third-party wire colors. Lamp2 output is capped. |
| Pi CSI | #1648 300mm15-pin FPC into Pi CSI connector (not DSI) and Camera3. Pi end exposed contacts face the HDMI side; camera end contacts face the camera PCB per official assembly image. Release latches first, seat squarely and close; preserve swept service loop. |
| D500 USB | Retain the kit adapter and100mm sensor lead, but install **StarTech UUSBHAUB50CM500mm USB-A-to-Micro-B** in place of the supplied~200mm USB lead. Adapter mounted on scanner mast near(s=35,r=0,z=50mm); sensor lead routed<=90mm. USB follows Pi->central frame corridor->mast,<=400mm routed path plus>=100mm retained service allowance, entirely below the scanner plane and clear of rotor sweeps. The supplied~200mm lead is ground spare. No rawUART-to-Pi substitute. Final device ports are transferred to the routing overlay before cutting clamps. |
| Buzzer | Exact VIFLY Finder2 from the cost ledger:5V/red, GND/black, BZ-/yellow. Confirm supplied instructions and polarity; separate internal cell is never paralleled to another rail. |
| Removable-holder actuator | Pololu #2180 and #2181 JST-RCY factory-crimped100mm20AWG mating leads. Aircraft source uses#2180 recessed female contacts; holder uses#2181 male contacts. Mate red-to-red and black-to-black by continuity, not an assumed cavity number or hobby naming convention. Use a secondary retaining clip inside the service-accessible enclosure. Only the1.1A actuator passes this pair, never the whole peripheral rail. Both switch bodies remain aircraft-mounted. |
| Charge-only | M6AC XT60 output to separate QS8 male via the existing extension;7-pin6S JST-XH balance lead preserved straight-through and checked cell-by-cell. Large **CHARGE ONLY—5A MAX—NOT AIRCRAFT** label. No banana-plug assumption. |

No Dupont jumpers or solderless breadboard remain installed. Supplied connectors are retained only where they are the named exact mating pair; fixed bare ends receive insulated solder joints and cable clamps. The final mechanical assembly decides which internal connectors are accessible for service, not whether polarity can be improvised.

## Support inventory and accounting

The CSV is a wire allocation, not another price search. Retain the frozen named parts and make the following existing support allowance explicit before a procurement request:

| Material | Quantity to reserve | Accounting rule |
|---|---:|---|
| FIT0580 8AWG red/black | Existing1m each | R1.1 red100+50mm, black150mm; no factory50mm aircraft tail and no butt splice. Remaining850mm per color is practice/offcut stock. |
| R1.1 aircraft connector |1additional genuine bare QS8 male |$2.35 observed part; separate from charge connector. Replaces rejected$8 two-pack series adapter; already-selected Hakko tool/process required. |
| FIT0581 10AWG red/black | Existing1m each | AIO80mm cuts plus practice; never use smaller offcuts to solve pad fit. |
| FIT0585 18AWG red/black | Existing1m each | CSV allocates600mm per color;400mm per color remains for termination practice/offcuts. |
| 22AWG silicone copper red/black | **2m each** | CSV allocates1250mm per color for Pi tails/peripheral/IR branches;750mm per color remains. >=60V insulation. |
| 24AWG silicone copper | **3m black,1m red,1m each white/blue/yellow/green/orange/purple** |10m total; CSV allocates5m total. Supplied sensor/servo wires are separate. Do not count a one-foot item as this full set. |
| Holder disconnect |1each Pololu#2180/#2181 |Factory-crimped100mm20AWG leads; observed$2.95each/$5.90pair before delivery. No new crimp tooling required. |
| D500 reach correction |1 StarTech UUSBHAUB50CM |500mm USB2.0 A-to-Micro-B, maker-listed21g/28AWG. US delivered cost unquoted; do not silently absorb into prior fixed total. Retain supplied200mm kit cable as ground spare, not additional aircraft mass. |
| R1–R9, C1–C4 | As passive schedule;2 spare of each value | Existing integration allowance; quote exact lot at procurement. |
| Three-pin male servo mating header |2 sections with retaining clips | Soldered fixed carrier and sleeved backs; no loose reversible flying adapter. |
| Sleeving/heat-shrink |1m abrasion sleeve;2m mixed heat-shrink including QS8/8AWG joint size | Existing tool-kit stock may be credited only after inventory; no flame near battery. |
| Cable clamps/ties/labels |20 nonconductive ties/clamps;2 labels per harness; strain mounts on both sides of moving/removable boundaries | Included support category; actual mass is measured. |

The old price ledger's$15 remaining-wiring allowance is not proven sufficient for these quantities. Price and installed mass must be reconciled before procurement/fabrication release; do not silently retain the$2,052.93 scenario or1,897.251g as a newly validated total. Extra lengths on the bench are not aircraft mass. The selected source/regulator/actuator architecture is unchanged except for the documented incompatible QS8-S support-item correction.

The previous70g whole-main-path target is also unsupported:300mm of8AWG copper is about22.5g,160mm of10AWG copper about7.54g, copper bars27.53g, INA4g and the specified FR4carrier/polycarbonate guard about12.06g, totaling **73.63g before connector housings, insulation, capacitor, solder and clamps**. These are geometric lower-bound estimates, not weighed installed mass. A revised assembly ledger and propulsion model must account for this known planning error; physical weighing cannot justify keeping a lower known-impossible subtotal.

## Acceptance and release checks

1. With flight battery, charger, USB and buzzer cell isolated as applicable, check every CSV endpoint, output-rail separation, bare-carrier copper bridges, ground continuity and insulation to carbon. Reject reversed capacitors, stray strands, unsupported heavy joints or exposed spare connector outputs. Meter resistance readings through electronics are not by themselves a complete isolation test.
2. Qualify high-current joint coupons and the received10AWG/AIO pad interface before final assembly. Check support, pull, voltage drop and temperature using rated test equipment; never route propulsion current through a handheld meter's current input. Missing geometry is a hold, not permission to reduce conductor size.
3. Future authorized props-off power-up is staged, current limited, with actuators initially disconnected. Measure every rail before attaching loads. A ShortSaver does not make high-power motor testing safe or establish a fuse coordination result.
4. Record simultaneous rail-load, servo stall, release pulse, LED, IR, Pi/USB/camera stress and brownout results. Inspect both equal Pi power paths. Test separate-rail startup/shutdown and unpowered UART/I2C leakage; direct GPIO interfaces are not isolated and no regulator reverse-blocking guarantee was established.
5. Inspect I2C pull-ups at the received AIO/INA/GPS revisions; only3.3V logic pull-ups are acceptable at FC SDA/SCL. Establish combined effective resistance and rise time at the chosen clock; do not add blind extra pull-ups or assume nominally distinct addresses prove electrical compatibility.
6. Prove switch absence/partial seating/lid open/partial bolt/open wire states, release OFF on boot/loss/time expiry, motor-output mapping and signed-command enforcement using the companion firmware safety packet. Only then attach the solenoid for a restrained, props-off functional test.

## Primary-source register

Research checked2026-09-03. These links support nominal interfaces; they do not certify the aircraft. Function-level netlist endpoints intentionally stop short of inventing received connector positions.

- S1 [MicoAir743v2-AIO45A manual and pin map](https://micoair.cn/zh/docs/flight-controller/micoair743-aio-series/micoair743v2-aio-45a-manual).
- S2 [Matek INA-BM wiring](https://www.mateksys.com/wp-content/uploads/2024/03/I2C-INA-BM_w.jpg), [INA product](https://www.mateksys.com/?portfolio=i2c-ina-bm), [BEC12S-PRO](https://www.mateksys.com/?portfolio=bec12s-pro).
- S3 [Raspberry Pi hardware/header/power](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html), [camera connections](https://www.raspberrypi.com/documentation/accessories/camera.html), [#2310 carrier](https://www.adafruit.com/product/2310).
- S4 [TI SN74AHCT125 datasheet](https://www.ti.com/lit/ds/symlink/sn74ahct125.pdf), [Adafruit Pi/NeoPixel wiring and PWM audio conflict](https://learn.adafruit.com/neopixels-on-raspberry-pi/raspberry-pi-wiring), [NeoPixel installation practices](https://learn.adafruit.com/adafruit-neopixel-uberguide/best-practices).
- S5 [Pololu RC switch guide](https://www.pololu.com/docs/0J60/all), [schematic](https://www.pololu.com/file/0J699/pololu-rc-switch-with-small-low-side-mosfet-schematic-diagram.PDF), [switch dimensions](https://www.pololu.com/product/1402), [Adafruit solenoid](https://www.adafruit.com/product/2776).
- S6 [Holybro MicroM10](https://holybro.com/products/micro-m10-gps), [maker pinout image](https://cdn.shopify.com/s/files/1/0604/5905/7341/files/12043Pinouts.jpg?v=1775198375).
- S7 [Benewake TFmini-S datasheet](https://en.benewake.com/uploadfiles/2023/03/20230331102010281.pdf), [ArduPilot Benewake interface](https://ardupilot.org/copter/docs/common-benewake-tfmini-lidar.html), [D500 kit](https://www.waveshare.com/d500-lidar-kit.htm).
- S8 [RP1 V2](https://radiomasterrc.com/products/rp1-expresslrs-2-4ghz-nano-receiver), [Finder2](https://viflydrone.com/collections/drone-buzzer/products/vifly-finder-v2-fpv-racing-drone-buzzer).
- S9 [Hobbywing UBEC5A](https://www.hobbywing.com/products/ubec-5a93), [DFR1015 selection and pad layout](https://www.dfrobot.com/product-2599.html), [IR BoardB](https://www.waveshare.com/infrared-led-board-b.htm), [#1967 servos](https://www.adafruit.com/product/1967), [#5162 lights](https://www.adafruit.com/product/5162).
- S10 [QS8-S harness](https://qsconnector.com/products/qs8-s-series-harness-8awg-with-tinned-ends-build-your-own), [QS8 contact](https://qsconnector.com/products/qs8-connector-black-antispark-connector-high-current-connector-male), [frozen cost inventory](../../research/final-cost-optimization-2026-09-03.md).
- S11 [Pololu#2180 source half](https://www.pololu.com/product/2180) and [#2181 matching holder half](https://www.pololu.com/product/2181): exact factory-crimped pair and lead length/gauge, observed2026-09-03. RCY is not JST-GH/SH/XH and is not used for sensors or main current.
- S12 [StarTech UUSBHAUB50CM manufacturer specification](https://www.startech.com/fr-fr/cables/uusbhaub50cm), [manufacturer datasheet](https://media.startech.com/cms/pdfs/uusbhaub50cm_datasheet-de.pdf):500mm A-to-Micro-B USB2.0,21g. The inspected Waveshare kit page lists~200mm USB and~100mm sensor cable. The extension is a reach correction, not an unsupported claim that stock cable length fits the proposed aircraft.

Prepared from the live uncommitted planning state. No claim of fabricated, powered or flight-tested compatibility is made.
