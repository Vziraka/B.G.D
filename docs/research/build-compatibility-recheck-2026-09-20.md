# Build compatibility recheck — 20 September 2026 (late evening)

Independent second pass over every ordered part, run after the CNHL battery was cancelled and the HOOVO 4S 6200mAh EC5 hard-case pack (Amazon B07XYM4NFC) became the flight battery. Three parallel read-only research agents checked manufacturer manuals, datasheets, the ArduCopter 4.7.1 `MicoAir743` hwdef/features and the exact retailer listings. No purchase, cart change, vendor contact, firmware flash or physical test. This supplements, and where noted corrects, the September 20 precheckout reviews ([mechanical](precheckout-mechanical-2026-09-20.md), [propulsion](precheckout-propulsion-2026-09-20.md), [electrical](precheckout-electrical-2026-09-20.md)).

## Verdict

**No ordered part needs replacing.** Every electrical and mechanical interface that a primary source documents matches the build as planned. The recheck found **three wiring/configuration mismatches that would have caused damage or confusion at first power-up**, plus several tight margins. All are fixable with configuration, re-pinning one cable, or a sub-$5 purchase; none changes the parts list today.

Nothing here is physical evidence. Fit, mass, thermal behavior and flight remain unqualified until the parts are measured and tested.

## Mismatches found (fix before first power-up)

1. **GPS cable pin order.** Sequre M10-182Q header silkscreen: `GND TX RX 5V SCL SDA`. MicoAir743 6-pin GPS socket: `GND 5V TX3 RX3 SCL SDA`. A straight 1:1 cable puts FC 5 V onto the GPS TX pin and FC RX3 onto the GPS 5 V pin. Re-pin one end so FC 5V→GPS 5V, FC TX3→GPS RX, FC RX3→GPS TX; GND/SCL/SDA straight. Read from the manufacturer product photo; confirm against the received board with a meter. Sources: [Sequre board image](https://cdn.shopify.com/s/files/1/0091/9515/9588/files/9_M10-182Q.jpg), [MicoAir743 port drawing](https://ardupilot.org/copter/_images/MicoAir743_PortsConnection.jpg).
2. **ELRS channel 5 is a 2-position arm channel.** ExpressLRS hybrid/wide switch modes transmit CH5 (AUX1) as 1 bit; CH6–11 carry 3 bits. ArduPilot's default `FLTMODE_CH` is 5, so a 3-position switch on CH5 shows only two modes. Set: arm switch on CH5 with `RC5_OPTION` = ArmDisarm; 3-position switch on CH6 with `FLTMODE_CH 6`. Verify in Mission Planner radio calibration. Source: [ELRS switch config](https://www.expresslrs.org/software/switch-config/).
3. **ESC current-sense scale.** The bundled Bluejay 50A 4-in-1 outputs 12.75 mV/A (≈78 A/V). The MicoAir743 hwdef default `BATT_AMP_PERVLT` is 40.2; MicoAir's own F405v2 text uses 116.5. Expect ~2× current error until calibrated against a meter. Moot once the ACS37220 whole-battery sensor replaces this signal, but relevant to any bench check before that harness exists. Source: [MicoAir ESC manual](https://micoair.cn/docs/wei-kong-si-he-yi-lan-niao-dian-diao-yong-hu-shou-ce), [hwdef](https://raw.githubusercontent.com/ArduPilot/ardupilot/Copter-4.7.1/libraries/AP_HAL_ChibiOS/hwdef/MicoAir743/hwdef.dat).

## Tight margins (decide after measuring received parts)

- **Motor-lead reach to the center ESC.** X2212 stock leads are 100 mm (SunnySky drawing; factory table says 20 AWG). Center-to-motor axis 225 mm; ESC pads ~21 mm from center; lead exit ~12 mm inboard; add 15–25 mm vertical/route and ≥20 mm slack → ~230–240 mm needed. 100 + 150 mm extension − splice/bullet trim ≈ 230–245 mm available. Slack ≈ 0–15 mm. The ordered 18 AWG stock (8 × 305 mm) cannot yield twelve pieces longer than ~152 mm. Lay one arm out physically before cutting all twelve; if short, one more RDQ 18 AWG foot-pair pack (~$3.50) resolves it.
- **Motor screw engagement.** Motor thread depth 2.8 mm. Kit lists both M3×7 and M3×8 screws and 8/16/17 as the count; arm pad thickness is unpublished. Engagement = screw length − pad − washer, target 2.0–2.8 mm. Caliper the pad; use washers or bought screws accordingly. Sixteen screws are needed; the no-accessory motors include none.
- **Frame mass allowance.** HAWK'S WORK 280 g very likely excludes the four skids (DJI's skid-less F450 is 282 g). If skids are ~30 g each the 400 g frame/gear allowance has near-zero margin. Weigh with and without skids on receipt.
- **Pi header current.** Samtec SSW rating 4.7 A/pin is for two pins powered; Pi header pins have no official rating. Keep the two 20 AWG 5 V leads equal length and inspect socket seating so one pin does not carry the full 5 A.
- **Charge time.** M450 is 50 W, so on 4S it delivers ~3.0–3.4 A, not 5 A (current steps 1/2/3/5 A). A 6200 mAh pack takes ~2–2.5 h from low. Manual shows no internal-resistance display; do not plan on one.

## Safety findings

- **Matek BEC12S-Pro has no reverse-input protection** (manufacturer statement). The 5 A fuse does not protect against reversed 4S input; a reversal destroys the BEC and can drive the Pi 5 V rail negative. Use a polarized/keyed input connector and meter-check polarity before the Pi is attached.
- **Never connect USB-C power while the BEC is live.** The HAT+ spec requires GPIO power sources to tolerate simultaneous USB-C; a generic buck may sink current. Treat the two supplies as mutually exclusive.
- **5.2 V is inside USB tolerance but not an official Pi figure.** Raspberry Pi documents a 5.1 V target; 5.25 V is the USB ceiling. Measure the BEC output unloaded and at ~3 A before connecting the Pi; a unit reading above 5.25 V needs a different plan.
- **PETG next to the LED heatsinks.** At 700 mA each XM-L2 dissipates ~1.9–2.2 W. A 35 mm Aavid-class heatsink in still air rises ~30–40 °C → 55–65 °C on the bench with no prop wash. Polymaker PETG HDT is 69 °C (basic) or 78 °C (PolyLite); check the spool label. Design an air gap/standoff between bracket and heatsink, or bench-log heatsink temperature for 15 min and switch the contact part to a higher-temperature material if it exceeds ~55 °C.
- **F450 PDB lower plate is redundant with the 4-in-1.** Do not route pack current through one PDB ESC pad pair; go battery → EC5 → ACS37220 → XT60 → 4-in-1 directly and leave the PDB pads unpopulated. The frame kit includes no battery pigtail; the stack supplies the XT60 lead and 470 µF capacitor.

## Confirmed matches (primary sources)

| Interface | Finding | Source |
| --- | --- | --- |
| HOOVO battery ↔ everything | 4S EC5, JST-XH 4S balance (seller images), 91.76 Wh label, 139×47×48.5 ±2 mm, 534 ±10 g | [Listing](https://www.amazon.com/dp/B07XYM4NFC) |
| X2212 ↔ F450 arm | 16×19 mm M3 pattern both sides; arm has a center hole for the 2.5 mm shaft protrusion | [Motor drawing](https://cdn.shopify.com/s/files/1/2024/0305/files/2212_7407c954-fd6c-459b-9f62-5b952dc0ac63.jpg), [frame image](https://m.media-amazon.com/images/I/61ery8PU-2L._AC_SL1000_.jpg) |
| X2212 ↔ SS-Prop-9450 | M6×1 shaft, 6 mm thread, no adapter shipped; prop is self-locking with built-in nut, "mounts directly to X2212". Black-cap prop ↔ CW motor, silver-cap ↔ CCW motor (manufacturer photo + DJI convention). ArduPilot Quad-X: M1/M2 = CCW + silver, M3/M4 = CW + black | [Prop page](https://sunnyskyusa.com/products/sunnysky-multirotor-9450-propellers-cw-ccw-rotation-pair-fit-a2212-x2212-multirotor-motors), [HAWK'S WORK guide](https://www.hawks-work.com/pages/f450_guide_book) |
| Mass/thrust | 400 + 224 + 44 + 534 + 45 + 150 + 250 ≈ 1,647 g vs 1,710 g target and 1.8 kg frame limit; 4 × 1230 gf at 14.8 V → T/W ≈ 2.9; hover ≈ 4 A/motor | [Motor page](https://sunnyskyusa.com/products/sunnysky-x2212-brushless-motors-new) |
| MicoAir743 UARTs | UART1/3/4/6 = SERIAL1/3/4/5, all full-duplex, unreserved; UART2 shared with DJI port; UART7 RX-only on ESC connector (NC with this ESC); 5 V/3 A and 9 V/3 A BECs; I2C1 on 4-pin and GPS connectors | [hwdef](https://raw.githubusercontent.com/ArduPilot/ardupilot/Copter-4.7.1/libraries/AP_HAL_ChibiOS/hwdef/MicoAir743/hwdef.dat), [manual](https://micoair.cn/en/docs/flight-controller/micoair743/micoair743-flight-controller-manual) |
| Motor outputs | PWM1–4 on one timer group, DShot600 supported (`MOT_PWM_TYPE 6`); MicoAir suggests starting at DShot300 | [DShot docs](https://ardupilot.org/copter/docs/common-dshot-escs.html) |
| Firmware features | 4.7.1 MicoAir743 build enables QMC5883L, IST8310, u-blox, MAVLink optical flow/rangefinder, CRSF, EK3 optflow fusion; default `FRAME_TYPE 12` (BetaflightX order) | [features.txt](https://firmware.ardupilot.org/Copter/stable-4.7.1/MicoAir743/features.txt) |
| ESC harness | 8-pin: Curr, NC, M4, M3, M2, M1, VBAT, GND; included 3 cm cable; 470 µF cap, XT60, 12 AWG in box | [Pyrodrone listing](https://pyrodrone.com/products/micoair-743-stack-with-h743-bmi088-flight-controller-and-2-6s-50a-bluejay-4in1-esc-30x30mm) |
| ELRS Nano ↔ UART6 | 5 V in, CRSF out; RX TX→RX6, RX RX→TX6; SERIAL5 default protocol 23; T antenna included | [BETAFPV RX](https://betafpv.com/products/elrs-nano-receiver) |
| LiteRadio 4 | 10 ch, internal ELRS 2.4 GHz 25/50/100 mW, USB-C charge/config, 2000 mAh; BETAFPV ELRS-3 fork — flash only BETAFPV .bin via WiFi WebUI; RF power fix `TX_LR4_Series_ELRS3_v1.0.6_20260428`; keep RX on ELRS 3.x | [BETAFPV](https://betafpv.com/products/literadio-4-radio-transmitter), [support](https://support.betafpv.com/hc/en-us/articles/36869017436953-LiteRadio-4) |
| Sequre M10-182Q | 3.3–5 V, 115200, UBX/NMEA, QMC5883L at 0x0D, 8 g; "Q" = with compass | [Sequre](https://sequremall.com/products/sequre-gps-small-size-fast-positioning-racing-drone-fpv-return-qmc5883-compass) |
| MTF-01P ↔ SERIAL4 | 5 V/0.5 W, 3.3 V UART; `SERIAL4_PROTOCOL 1`, `SERIAL4_BAUD 115`, `SERIAL4_OPTIONS 1024`, `FLOW_TYPE 5`, `RNGFND1_TYPE 10`, sensor `mav_id` 200 | [ArduPilot guide](https://ardupilot.org/copter/docs/common-mtf-01.html) |
| Dual compass | External QMC5883L probed before onboard IST8310 → lands in PRIO1; different addresses, no conflict | AP_Compass.cpp at Copter-4.7.1 |
| Pi 5 GPIO power | Officially sanctioned ("Power HAT+"); `PSU_MAX_CURRENT=5000` skips PD negotiation and lifts the 600 mA USB cap | [HAT+ spec](https://datasheets.raspberrypi.com/hat/hat-plus-specification.pdf), [PD whitepaper](https://pip-assets.raspberrypi.com/categories/685-app-notes-guides-whitepapers/documents/RP-009856-WP-1-USB%20Power%20delivery%20on%20Raspberry%20Pi%205.pdf) |
| Matek BEC12S-Pro | 9–55 V in, 5.2 V default (both pads open), 5 A cont/9 A peak, pads IN/G/G/OUT | [Matek](https://www.mateksys.com/?portfolio=bec12s-pro) |
| Samtec SSW-105-02-G-D | 2×5, 2.54 mm, 4.93 mm solder tail, 0.64 mm square posts, 4.7 A/pin (two powered) | [Samtec](https://www.samtec.com/products/ssw-105-02-g-d) |
| Fuse | BF353 accepts ATO, 16 AWG leads, 30 A holder; 0287005 is 5 A/32 V fast-acting; branch draws ≤1.9 A at 4S, so no nuisance trip (a 3 A ATO would be tighter and equally safe) | [Littelfuse](https://www.littelfuse.com/products/fuses-overcurrent-protection/fuses/automotive-fuses/blade-fuses-shunt/atof/287/0287005-pxcn) |
| ACS37220 + divider | 20 mV/A, 2.5 V zero, non-ratiometric, ≥10 kΩ load OK; divided: 1.25 V zero, 10 mV/A, 2.25 V at 100 A → `BATT_AMP_PERVLT 100`, `BATT_AMP_OFFSET 1.25`; Pololu 60 A continuous test; 10 AWG holes | [Pololu 5292](https://www.pololu.com/product/5292) |
| M450 + leads | 2–4S, 50 W, storage 3.85 V/cell, balance lead mandatory; AC-EC5C6 battery end is the charger-type EC5 that mates a standard battery plug, XT60 end mates the charger; 4S balance extension has 5 wires | [ToolkitRC](https://www.toolkitrc.com/m450/), [ProgressiveRC](https://www.progressiverc.com/products/ec5-charge-cable) |
| VL53L7CX ↔ Pi | 3.3 V VIN sets I2C level; 0x29; 100/150 mA; ST Linux driver (validated on Pi 3) or pimoroni VL53L5CX Python; raise I2C baud to ≥400 kHz | [Pololu 3418](https://www.pololu.com/product/3418), [STSW-IMG038](https://www.st.com/en/embedded-software/stsw-img038.html) |
| Lighting | XM-L2 Vf 2.72 typ/3.15 max at 700 mA; series pair ≤7 V; BuckPuck 5–32 V in, 2.5 V margin → 9.5 V minimum ≪ 13.2 V loaded 4S; ~0.3 A battery draw; 10734 fits 20 mm star and 10140 optic | [LEDSupply BuckPuck](https://www.ledsupply.com/led-drivers/buckpuck-dc-led-drivers), [Cree DS](https://cree-led.com/media/documents/XLampXML2.pdf) |
| Pi mounting | 58×49 mm Ø2.7 holes; Pololu 1952 M2.5 11 mm + 6 mm stud | [Pi 5 drawing](https://datasheets.raspberrypi.com/rpi5/raspberry-pi-5-mechanical-drawing.pdf) |

## Still unverified from any source

- F450 center-plate thickness, plate separation and top-plate hole pattern (no 30.5 or 45 mm pattern stated; images show a large central hole and slots). The 30.5 mm printed adapter is provisional until measured.
- X2212 lead termination (photo suggests 3.5 mm bullets; text silent). True prop diameter (SunnySky says 9×4.5; the same-pattern DJI 9450 is 9.4×5.0).
- LiteRadio 4 stick mode as shipped by RDQ (BETAFPV sells Mode 1 and Mode 2 SKUs; RDQ lists one variant). Switch letter assignments.
- ELRS Nano RX shipped firmware version (RDQ text is stale; BETAFPV says 3.3.0).
- M450 US plug and XT60/XH connectors from a primary source (manual does not name connectors).
- Bottom-plate strap slot size vs 16 mm Kevlar straps.
- Official Raspberry Pi maximum for the 5 V GPIO rail and the Active Cooler current.

## Owner checks on receipt (consolidated, in build order)

1. Frame: weigh with/without skids; caliper arm pad thickness, plate thickness, plate gap; map top-plate holes/slots; measure strap slots; confirm PDB pads face up; count motor screws (need 16).
2. Motors: read CW/CCW engraving; test prop nut handedness by hand; measure lead length and note bullets; pin-check 2.8 mm hole depth; lay one motor + 150 mm extension along an arm to the ESC pad position before cutting twelve.
3. Props: measure tip-to-tip, weigh; nut threads fully home on the M6 shaft with hub seated on the Ø7.85 boss.
4. Stack: silkscreen reads MicoAir743 V1.x (not v2/Lite/AIO); 8-pin cable, cap, XT60, 6-pin GPS cable and four 4-pin cables present; flash `MicoAir743` 4.7.1 only.
5. GPS: meter-verify the header order, re-pin the cable, then power.
6. Radio: check box/SKU for Mode 2; connect to BETAFPV Configurator with the radio OFF; read firmware; flash v1.0.6 if older; set binding phrase; read RX version via WebUI, keep on 3.x; wire RX TX→RX6, RX RX→TX6.
7. Mission Planner: CH5 = arm (two positions), CH6 = 3-position → `FLTMODE_CH 6`; `MOT_PWM_TYPE 6` (or 5 first); props-off motor test against `FRAME_TYPE 12`.
8. BEC: both voltage pads open; measure OUT unloaded and at ~3 A; polarity meter-check; polarized input connector; never co-power with USB-C. Pi first boot on BEC: `vcgencmd pmic_read_adc`, set `PSU_MAX_CURRENT=5000`.
9. Current sensor: locate "5V B10" and "+i" arrow; ADC ≈1.25 V at zero current; calibrate at ~10 A.
10. Charger: US plug, XT60 output, XH balance socket, storage mode present; no IR readout expected; first HOOVO charge in the LiPo bag, attended, cells 3.7–3.9 V before starting.
11. VL53L7CX: VIN to pin 1 (3V3); `i2cdetect -y 1` shows 0x29.
12. Lighting: bench-run both LEDs 15 min in still air with a temperature probe on a heatsink before finalizing bracket geometry; read the PETG spool label.

## Budget consequence

None required today. Possible small adds after measurement: one 18 AWG foot-pair pack (~$3.50), M3 screws/washers of measured length (a few dollars), a 3 A ATO fuse if tighter protection is wanted (~$0.50). All fit inside the ~$90 estimated margin after the battery swap.
