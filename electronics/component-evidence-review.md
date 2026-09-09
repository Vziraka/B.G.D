# Electrical evidence continuation — 2026-09-06 UTC

Status: **digital engineering evidence, with explicit release holds**. This extends E1 without changing the circuit or selecting replacement hardware. New calculations are reproduced by `python electronics/power_checks.py`; they do not qualify a built aircraft. The [existing discrepancy register](power-and-integration.md) remains the index for Issue 11 findings.

## Coordination and corrected inputs

The mechanical/shared owner confirmed a new conservative design direction: continue without TBS correspondence, using documented dimensional envelopes and [RF-GATE-01](../cad/received-frame-inspection-gate.md). The [45 mm study](../cad/robust-aio-review.md) has only a conditional planar clearance result; fasteners and actual service routes remain unfinished. No final wire length, connector direction or mounting location is supplied by that study.

At electrical's request, that owner corrected R6/R7 pull-up prose to 4.7 kΩ in the three affected pin-allocation rows and both firmware manifests. They also corrected W060/W061 to the manufacturer's nominal 80 mm fan tails with an explicit route/termination/extension hold. **E01's document conflict is closed; E05's document error is corrected, but physical reach remains open.** This task reviewed those exact shared changes and adds regression checks; it did not edit the shared files.

The PC owner reports 96 device-free tests passing, with real voice acceptance evidence and a historical storage inconsistency still open. That is a status report from the PC task, not an electrical test result. No new PC requirement changes aircraft hardware. Ticket 02 remains outside all electrical dependencies here.

## Component evidence disposition

| Item | Evidence gained or checked | Disposition |
|---|---|---|
| Fan 3368 / E06 | [Adafruit](https://www.adafruit.com/product/3368) publishes nominal 5 V, 0.2 A and 80 mm leads. No allowed voltage interval or startup/stall bound was found. | Keep the inherited 5.2 V connection conditional. Do not add a guessed series resistor/diode or move it to an unqualified rail. Vendor tolerance evidence or an explicitly reviewed affected-subsystem correction is needed. |
| Lamps 5162 / E04 | [Exact selected product](https://www.adafruit.com/product/5162) still supplies a minimum-capacity recommendation rather than a maximum-current guarantee. Its specification link remains unavailable. An [available sibling 5163 PDF](https://cdn-shop.adafruit.com/product-files/5163/5163_C16536-001%20-%20A-P032001MA4SD6-3000K.pdf) covers a warm-white variant and lists SM16714 and a 4 W module figure. | Do not transfer that variant's electrical or protocol specification to the selected cool-white module without identity/revision evidence. The 1.6 A combined calculation remains a scenario, not a bound. No firmware/library substitution is justified. |
| Pan/tilt 1967 | [Current product](https://www.adafruit.com/product/1967) permits SG90 or SG92 type servos. [2015 seller support](https://forums.adafruit.com/viewtopic.php?t=73111) estimates about 250 mA stall each, but does not identify the currently supplied variant, voltage/tolerance or production maximum. | Historical support advice cannot close the current peak/stall budget. Obtain exact servo identity and its current/voltage/pulse limits; later characterize both axes with their actual load. |
| D500 kit / W101–102 | [Waveshare](https://www.waveshare.com/wiki/D500_LiDAR_Kit) documents 290 mA operating demand and 1.45 W, with 4.5–5.5 V sensor input. Its UART pin-function table describes the sensor, not the complete USB adapter assembly. | Add operating demand as a partial USB budget only. Adapter overhead, motor startup and USB aggregate remain unknown; no factory cable internal map is released. The sensor already belongs inside the Pi load allocation and must not be counted twice. |
| RP1, Finder and IR | Reviewed maker evidence still does not establish all coincident demand, charging/startup peaks or IR module curves needed by E1. | Retain the existing open load entries; do not substitute unrelated-receiver or bare-emitter ratings. |

## F1/F2 and regulator protection — E10

The [Littelfuse selection guide](https://www.littelfuse.com/assetdocs/fuse-selection-guide?assetguid=1d99e3a6-f314-48d7-b124-9d5d56955f09) explicitly includes the selected `0297***.WXNV` MINI 32 V family, with 1,000 A interrupt rating. Its time limits produce these cases for a 5 A fuse:

| Actual input current | Minimum opening time | Maximum opening time |
|---:|---:|---:|
| 5.5 A | 100 hours | Not specified |
| 6.75 A | 0.75 seconds | 600 seconds |
| 10 A | 0.15 seconds | 5 seconds |
| 17.5 A | 0.08 seconds | 0.5 seconds |
| 30 A | 0.03 seconds | 0.1 seconds |

These are fuse test limits, not expected aircraft fault currents. No interpolation, thermal derating or fault-clearing conclusion is made from them alone. The 1,000 A rating also requires checking prospective fault current; the battery model's operating-current screen is not a short-circuit-current bound. An [aftermarket-family sheet](https://www.littelfuse.com/assetdocs/lf_aftermarketcatalog_2016_micro3?assetguid=231dbb04-2bf5-4da4-ac3e-23aa05c4339b) reinforces application-dependent derating, but its separately listed `0MIN` cold resistance and typical melting-energy values are not adopted as exact `0297005.WXNV` limits.

[Matek BEC12S-PRO](https://www.mateksys.com/?portfolio=bec12s-pro) documents thermal shutdown, self-recovering overcurrent protection and **two seconds of output-short tolerance**. Its 9 A peak rating has no reviewed duration suitable for sustained allocation. These statements do not prove a latched fault disconnect. The manufacturer page was available through search-index text after direct fetch failures; no additional trip threshold is inferred.

**Engineering conclusion:** F1 cannot be credited with clearing every output short within the regulator's documented interval. A converter's input current differs from output current, and some fuse test cases permit more than two seconds. This is a missing protection guarantee, not a prediction that the hardware fails after exactly two seconds. Before release, either obtain evidence that this exact assembly safely handles sustained/repeated output faults or review a protective change with defined trip current, clearing time, restart behavior, voltage drop, mass and thermal effects. Do not select an output fuse from the normal-load estimate alone.

[Hobbywing's exact 30607000 listing](https://www.hobbywingdirect.com/products/ubec-5a-air) documents 5 A continuous, 15 A instantaneous and overcurrent, short-circuit and thermal protection. The reviewed page does not give the trip/time/restart curves needed to qualify the smaller output conductors. Its instantaneous rating is not continuous headroom. REG2 therefore retains a separate protection-evidence hold even though those protective functions are documented.

The [Littelfuse-authored FHM datasheet hosted by its distributor](https://www.mouser.com/datasheet/2/240/Littelfuse-3159421.pdf) identifies `0FHM0001LXN` as a 20 A, 32 V holder with 14 AWG black GXL leads. This supports preserving its supplied conductor gauge; it does not turn the added 18 AWG branch into a 20 A branch. Mechanical must count all installed pigtail/splice length in the existing maximum 30 mm unfused-route requirement, not just the separately cut extension.

## Cargo connector rating boundary — E11

[Pololu 2180](https://www.pololu.com/product/2180) and [2181](https://www.pololu.com/product/2181) are listed as Generic, with 20 AWG factory-crimped 100 mm leads. [JST's actual RCY specification](https://www.jst-mfg.com/product/index.php?series=521) covers AWG 28–22 contacts and gives 3 A at AWG 22. That rating cannot automatically certify this generic AWG 20 assembly. The selected matching pair remains in the schematic; exact assembly rating, contact retention, resistance and temperature-rise evidence remain required. Do not recrimp larger wire into JST's AWG 22 terminals or claim a 3 A guarantee from the connector-family name.

## Quantitative acceptance constraints that do not need a wire route

**TFmini supply:** use the existing 4.9–5.1 V terminal requirement and 0.2 A peak allowance. The total positive-plus-return resistance budget is `(source_min - 4.9)/0.2`. At conditional source minima of 4.95 V and 5.00 V, this is respectively 0.25 Ω and 0.50 Ω, including connectors and joints. A source minimum of 4.9 V leaves zero drop budget. These ceilings allocate no noise/transient margin and are not an instruction to select maximum-length wire. Source maximum plus overshoot must separately stay within the sensor limit. Exact cable resistance, source tolerance and load transients still gate release.

**External I2C / E07:** [TI SLVA689](https://www.ti.com/lit/pdf/slva689) gives `Rmin=(Vpullup−VOLmax)/IOL` and `Rmax=tr/(0.8473*Cbus)`. The calculator reproduces TI's 200 pF, 3.3 V, 3 mA, 300 ns worked example: approximately 967–1,770 Ω. It also calculates eight capacitance/rise-time scenarios. At 400 pF and 300 ns, that assumed 3 mA sink capability yields no resistance window; slowing the bus is only a candidate subject to actual device and timing requirements.

For illustration, 4.7 kΩ and 100 pF gives about 398 ns rise time; two such pull-ups in parallel give about 199 ns. Neither resistor count nor capacitance has been established for the installed modules. Measure/obtain each board's pull-up rail, effective parallel resistance, sink capability and total bus capacitance before choosing added resistors or bus speed. Never pull this bus to 5 V by assumption. No I2C resistor is added to the schematic in this checkpoint.

**Bulk capacitor:** nominal C4 = 1,000 µF supplies a 1 A current deficit for only 0.1 ms before an ideal 0.1 V droop (`dt=C*dV/I`). Real ESR/ESL and tolerance further affect the transient. It cannot compensate for sustained simultaneous servo/solenoid/lamp demand.

## Required evidence at the independent-rail boundary

The following are integration acceptance cases, not authorized test instructions or completed results. All rail states mean valid operating voltages; intermediate ramps and brownouts require separate capture. RC supervision is future FC/onboard work, not PC Ticket 02.

| FC rail | Pi rail | Peripheral rail | Required result/evidence |
|---|---|---|---|
| Off | On | Off | Pi TX/LED signals must not back-power unpowered FC/U1 beyond allowed pin currents. |
| On | Off | Off | FC UART/PWM must not back-power Pi/U1; companion absence cannot create a new authorization. |
| Off | Off | On | U1 input pull-downs/defaults must keep release off; powering lamps alone must not be treated as software initialization. |
| On | On | Off | Valid logic outputs into unpowered U1 need electrical qualification; peripheral return must not find a signal-ground substitute. |
| On | Off | On | FC must expire release authority independently; a continuing valid ON pulse requires its own bounded supervisor. |
| Off | On | On | FC restart/absence must not grant release; Pi must not drive the FC rail through UART. |
| On | On | On | Simultaneous load, signal levels, switch plausibility, release timeout and approved light modes need integrated evidence. |

Also cover loss/restoration of each supply, USB attachment/service power, a stuck-low cargo input and a lost load return. Do not deliberately create live high-current faults from this document. Define safe fixtures, limits and instrumented procedures only after the missing ratings and separate physical authorization exist.

## Precise next information, by owner

- Electrical/component evidence: permitted fan voltage and maximum startup current; exact cool-white lamp revision, channel current limits and timing; actual servo identity, voltage interval, startup/stall demand and allowed pulses; exact generic RCY assembly current/contact data; sustained/repeated regulator fault response and downstream wire/connector withstand.
- Mechanical: actual AIO pad/USB/SD service corridors and conductor bend evidence; joint/isolator details; 80 mm fan-tail usable reach including terminations; module placement/airflow/heat-sinking and cargo travel. Supply connector orientation with manufacturer or received-part evidence, not perspective-image estimates.
- Future FC/onboard: release maximum ON interval and duty from coil/latch evidence; independent lease expiry; GPIO ownership and switch debounce/plausibility; behavior across the above supply cases. No PC Ticket 02 changes are needed.
- Shared baseline owner: maintain E01/E05 corrections and append this continuation to Issue 11. E10/E11 are documented evidence boundaries, not automatically approved hardware substitutions.

No external supplier correspondence, component purchase, firmware upload, physical operation or mechanical geometry change occurred. Remaining unknowns require new authoritative component data, received-part evidence, actual mechanical detail or future onboard implementation; none is filled with a guessed value.
