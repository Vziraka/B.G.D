# C1 power and battery-monitor assembly — revision 1 (30 September 2026)

**Status: concrete disconnected assembly plan; BATTERY POWER NOT RELEASED.** Three first-motor extension blanks may be cut under the separately bounded [September 30 one-arm preparation release](stack-and-motor-route-dry-fit-2026-09-28.md#september-30--first-motor-extension-preparation); it does not release a splice or an ESC joint. The main-power sections now choose a direct base EC5-to-ESC assembly, exact board-function views and disconnected checks, followed by the final whole-battery sensor and accessory conversion. Each named construction step can follow its actual-part/route checks; no blanket claim of completed C1 is made. The first-power section remains preparation until physical assembly and C2 evidence pass. Keep the flight battery and charger disconnected, USB unplugged, and propellers off. Never test continuity or resistance on the battery.

## Motor-pad view and output assignment — September 30 preparation

The [manufacturer's 50 A ESC component-side diagram](https://micoair.cn/api/media/file/docs/2026/07/66a9f0799f1ee-c81c0deb7b-b56902bd14.webp), viewed with its white eight-pin socket at the **top** and battery tabs at the **bottom**, shows left-upper motor trio **ESC2**, left-lower **ESC1**, right-upper **ESC4**, right-lower **ESC3**. Bottom battery tab left is **+**, right is **−**. These are board-relative positions, not aircraft motor numbers. Confirm the received layout and actual installed rotation before selecting a pad group.

If the ESC socket is ultimately toward the two red front arms and each motor uses its nearest group, the required standard Quad X assignment is:

| ESC output / FC channel | Aircraft position | Required ArduPilot motor function |
| --- | --- | --- |
| ESC1 / SERVO1 | Rear left | Motor2 |
| ESC2 / SERVO2 | Front left | Motor3 |
| ESC3 / SERVO3 | Rear right | Motor4 |
| ESC4 / SERVO4 | Front right | Motor1 |

This is conditional engineering preparation; **no parameter change has been made or released here**. A different ESC rotation needs a revised table. The saved September 29 board baseline has `SERVO1..4_FUNCTION=33,34,35,36` (Motor1..4), so it does not already implement the table. [ArduPilot's motor-order/test instructions](https://ardupilot.org/copter/docs/connect-escs-and-motors.html) require the later props-off test A/B/C/D to operate front-right/rear-right/rear-left/front-left for standard Quad X. Confirm actual direction separately.

The baseline also has `MOT_PWM_TYPE=0`; this is not a verified Bluejay signal-protocol setup. Select and verify the supported digital protocol against the exact board/ESC firmware before C3 motor operation using [ArduPilot's DShot guidance](https://ardupilot.org/copter/docs/common-dshot-escs.html). Do not infer that USB radio success qualifies motor output.

All three factory motor wires are winding phases; their red/black/blue colors do not indicate battery positive/negative. Once attached to a motor, phase-to-phase continuity is expected through the windings, so silence between these three leads is **not** the no-short criterion. Check each new splice's own wire path, mechanical hold and insulation instead; the battery-input short screen remains separate.

## Selected assembly order — revision 1, September 30

This revision supplies a **base propulsion harness first**, followed by the final whole-battery current sensor and accessory branches. Completing a disconnected named subassembly does not wait for independent Pi, GPS or lamp work. All full-product requirements remain required. The reported supported stack fit and first-motor wire preparation are recorded in CURRENT; no main-power joint, capacitor/accessory inspection, main-harness meter pass or battery connection is yet reported.

**For every construction and meter step below:** flight battery physically away and unplugged; charger and FC USB unplugged; propellers absent. Never use continuity/resistance mode on the pack. Use the owned wire, EC5 pairs, heatshrink and solder tools. No bench supply, smoke stopper or other unreported equipment is assumed.

### Stage P — direct EC5-to-ESC base circuit

Selected method: solder the aircraft-side EC5 **device contacts** to two 12 AWG leads, then solder those leads directly to the ESC battery pads. Fit the supplied capacitor in parallel at the ESC pads. The separate loose XT60 stays unused; an additional connector is unnecessary when the pack already disconnects at EC5. **Do not alter the pack's factory EC5 or balance leads.** The premade ProgressiveRC charge lead remains dedicated to C2.

```text
AIRCRAFT EC5, viewed by its literal + / − housing marks
    + contact ── 12 AWG POSITIVE ────────── ESC + battery pad
    − contact ── 12 AWG NEGATIVE ────────── ESC − battery pad
                                              │         │
                                        capacitor +   capacitor −
                                                     stripe side
```

For the ESC component view with white eight-pin socket at top, **battery + is the bottom-left tab, battery − the bottom-right tab**. If the installed board is rotated, these diagram-relative positions rotate too; the actual printed `+` and `−` marks decide. Source: [official 50 A diagram](https://micoair.cn/api/media/file/docs/2026/07/66a9f0799f1ee-c81c0deb7b-b56902bd14.webp).

#### P1 — identify and reserve the exact parts

- Actual loose device EC5 half must have **metal pin contacts**, a keyed blue housing and readable `+`/`−` marks. It is the mating device type, not the battery's metal socket-contact half. Compare with the EC5 end of the **disconnected** verified charge lead; do not plug a loose terminal or unfinished harness into the live pack to test fit.
- Supplied capacitor must read **470 µF** and have a readable voltage rating of **at least 25 V** for this 16.8 V maximum 4S circuit; identify its negative stripe. A lower/illegible rating or damaged can is unresolved. The shorter lead may corroborate polarity on an untrimmed capacitor, but does not replace its stripe.
- Use supplied 12 AWG red/black wire where long enough and the owned black 12 AWG spool for additional reach. For any positive segment made from black wire, add **red heatshrink or durable red identification at both ends before attachment**. Do not use 18 AWG motor extensions for the main battery feed.
- Confirm actual ESC battery tabs and short eight-pin cable match the official original/50 A diagrams; report only a mismatch or named missing part. The existing ordinary visual board match does not establish the unreported capacitor/cable contents.

#### P2 — choose lengths at the supported stack

With all power absent, run intact 12 AWG stock from the accessible future EC5 disconnect location to the two ESC battery tabs. Keep the EC5 accessible with the upper plate present, clear of straps, sharp edges and propeller sweep. Leave a relaxed service bend; keep wires from pulling on the stack dampers.

Choose a clear accessible segment in the positive route for the later approximately 18 × 20 mm Pololu carrier. Mark `SENSOR LATER` on that insulated segment. It must remain accessible without moving the motors or remaking the ESC pad joint. The base circuit uses one continuous positive wire there; **no sensor bypass splice is needed**. Negative takes its final direct route.

Mark each conductor at its two actual termination points and measure the marked routed length. Allow **3 mm inside its EC5 solder cup and approximately 5 mm at its ESC pad**, in addition to the relaxed route. For the temporary series-fuse option below, reserve an additional **10 mm of positive-wire rework allowance on each side of the SENSOR LATER segment**; keep that 20 mm in an accessible relaxed bend, not by pulling the stack or changing the negative route. This allows removal of the two temporary soldered overlaps without making the later sensor ends short. Record positive and negative cut lengths before cutting. Reserve the fuse/BEC/sensor stock before using offcuts. Nominal 150 mm main-path figures in the BOM are stock-planning estimates, not mandatory installed cut lengths.

Route the capacitor body beside the ESC input, supported against movement, away from the board above and frame copper. Keep its leads short, insulated individually except at their pad joints, and free of strain. Recheck upper-plate/FC clearance with that body and the two thick leads present; the previous bare-stack fit did not include them.

#### P3 — assemble the disconnected EC5 end

Use [E-flite's EC connector assembly instructions](https://assets.horizonhobby.com/on/demandware.static/-/Sites-horizon-master/default/dw7a038c80/Manuals/E-fliteECConnectorInstructions.pdf) as the contact-and-housing reference. They distinguish device metal pins from battery metal tubes; verify the received pair uses that construction.

1. Hold one loose contact by its body with pliers/helping hands, never an energized mating battery. Strip about **2–3 mm** of the selected wire; tin wire and solder cup, then heat them together until solder wets both. Keep solder off the contact exterior.
2. Make one joint at a time. For these heavy joints use a clean broad chisel tip; **380 °C is this card's engineering starting setting for the owned lead-free solder**, not a manufacturer-prescribed board setting. Heat the work and feed solder to the work. If solder will not flow into the joint promptly, lift the iron and allow cooling; improve tip contact/holding before retrying. Do not compensate by repeatedly heating the plastic or pulling a pad/contact.
3. Place the positive-wire contact in the housing cavity actually marked `+`, negative in `−`, following the received contact retention direction. Support the housing and push on the contact's rear shoulder with a suitable small flat tool; never use the wire as a ram or force a visibly incompatible part. Each contact must lock and resist a gentle pull on its insulated wire.
4. When cooled, test each contact to its own free wire end, then opposite contacts/wires, using P5 **before** attaching the leads to the ESC. Inspect and insulate any exposed solder cup behind the housing.

A contact that will not retain, exterior solder that prevents insertion, or deformed housing is a repair issue; it is not solved by more insertion force.

#### P4 — solder the ESC input and capacitor

Leave the FC off the work area and the eight-pin cable unplugged at both ends. Support the ESC without loading a component or its soft grommets. Tin approximately 5 mm of each thick lead and only the named `+`/`−` pad. The stripped portion must fit wholly over its own pad without a free strand extending beyond it.

Join positive wire to `+`, negative to `−`; capacitor positive lead goes to `+`, **striped negative lead to `−`**. Soldering order is the two power leads, then the separately insulated capacitor leads. If the capacitor needs the opposite face of a battery tab, use it only where the same marked pad is visibly plated through and clear of parts; do not infer another nearby copper island is equivalent.

Support each wire while the joint cools. Inspect each joint before hiding it: complete wetting to pad and conductor, no lifted pad, bridge, loose strand, insulation melting or unsupported capacitor lead. Hold the insulated wire and apply a gentle tug while supporting the board. Retain wires near the board on the frame/print so the joint and dampers carry no harness pull; ties must not crush electronics or pin the FC rigidly. Use the existing heatshrink to cover exposed leads/copper where it can fit without hiding damage, and retain the capacitor body. Repeat actual-height top-plate clearance.

#### P5 — exact disconnected meter checks

Working meter is AstroAI AM33D: black probe in right `COM`, red in middle `VΩmA`, **never left `10A`**. Beeper/diode position is lower-right. Probes touching must beep; apart must not. Check accessible terminal/pad metal, not insulation or an assumed cavity position.

| Subassembly / probes | Expected result |
| --- | --- |
| EC5 lead alone, `+` contact ↔ positive free tip | Steady continuity comparable to touched probes |
| EC5 lead alone, `−` contact ↔ negative free tip | Same |
| EC5 lead alone, either contact ↔ opposite free tip; contact `+` ↔ contact `−` | Open/no beep; no boards/capacitor attached |
| Completed base circuit, EC5 `+` ↔ ESC marked `+` pad | Direct steady continuity |
| Completed base circuit, EC5 `−` ↔ ESC marked `−` pad | Direct steady continuity |
| Capacitor negative lead's exposed pad joint ↔ ESC `−`; positive joint ↔ ESC `+` | Their respective direct paths |
| Completed base circuit, EC5 `+` ↔ `−`, each probe direction | Screen for a persistent hard short; record display and beep behavior |

Across the assembled ESC/capacitor, a brief changing reading or transient beep can be capacitor charging, and a one-direction semiconductor reading is not automatically a solder bridge. **A sustained near-probe-touch/near-zero reading in both directions stops power.** Let a changing reading settle for approximately ten seconds, then reverse probes and record it. A silent test detects no hard short in that test; it does not prove every component sound. An unexplained sustained beep/low reading must be resolved from its recorded value, rather than ignored or treated as a definitive short solely from sound. Do not intentionally short capacitor leads to discharge them; if this assembly has previously been powered, measure DC voltage first and wait for zero before resistance checks.

Recheck contact identity, capacitor stripe, insulation, tug result and mechanical clearances together with the table. A beep alone does not qualify a high-current joint. **None of P1–P5 releases battery power**; they make the completed base circuit reviewable for the C3 sequence below.

### FC–ESC harness — actual board views and two distinct current-sensor stages

Match the [original FC diagram](https://micoair.cn/api/media/file/docs/2026/07/667c0fbaa3976-8a38aec13b-20c3f71554.webp) and [50 A ESC diagram](https://micoair.cn/api/media/file/docs/2026/07/66a9f0799f1ee-c81c0deb7b-b56902bd14.webp):

| Board view / connector | Left-to-right board functions |
| --- | --- |
| ESC component face, white socket at top | `Curr, NC, M4, M3, M2, M1, VBAT, GND` |
| Original FC connector/arrow face, arrow up, **top-right** socket | `Curr, RX7, M4, M3, M2, M1, VBAT, GND` |

The FC top-left eight-pin socket carries M10–M5, VBAT, GND and is **not** this connection. Hold each loose harness plug just outside its socket in its keyed mating orientation to identify cavities by those board functions; turning a plug over reverses an apparent left/right view. Connector key fit alone is insufficient.

With the cable alone and unplugged, map each FC-labeled cavity to the ESC end using accessible terminal metal and the meter. Required paths are `Curr→Curr`, `RX7→NC`, `M4→M4`, `M3→M3`, `M2→M2`, `M1→M1`, `VBAT→VBAT`, `GND→GND`; each must have exactly one direct path, with no adjacent-conductor short. Do not force the AM33D tip into a 1 mm contact. If contact access cannot be made without spreading it, report that one limitation; do not repeat blind cavity probing.

**Base propulsion stage:** leave the verified original `Curr→Curr` conductor intact. The ESC sensor measures the propulsion/FC circuit only. It is acceptable for this intermediate circuit, with its later measured calibration; it does not satisfy final whole-product consumption monitoring. Keep the Pololu VOUT entirely disconnected at this stage.

**Final Pololu stage:** disconnect both cable ends and remove the competing ESC `Curr` path before adding the divided Pololu signal. Selected novice method avoids assuming a known extraction tab: label the **verified Curr conductor**, cut that conductor once near its midpoint while leaving neighboring wires intact, insulate the ESC-side cut end individually, and extend the FC-side cut end with an insulated small signal wire from spare stack-cable stock. Solder/heatshrink that one extension and retain it without pulling either plug. Do not cut by guessed color; confirm the cut conductor by the isolated cable map first. If its short tails cannot be held/tinned/insulated without connector heat damage, use a confirmed housing-lance extraction method after inspecting the actual housing, or a correctly terminated replacement; do not improvise on the other seven paths.

Post-isolation cable tests, **before plugging either end in**: ESC Curr cavity ↔ FC Curr cavity must be open; new signal-wire tip ↔ FC Curr cavity must have direct continuity; its tip must be open to every other FC cavity. The remaining seven intended paths must still pass. This is the current-ADC entry point; never tie two analog sensor outputs together.

### Stage W — convert positive feed to final whole-battery sensing

The final topology is preserved:

```text
EC5 + ─12 AWG─ Pololu high-current INPUT ─ high-current OUTPUT ─12 AWG─ ESC +
                                                          ├─ 5 A fuse ─ Matek IN (later)
                                                          └─ protected lamp feed (later)
EC5 − ───────────────────────────────────────────────────12 AWG──── ESC −
                                                                  ├─ Matek G (later)
                                                                  └─ lamp return (later)
```

At the marked accessible positive-wire segment, the later conversion adds **two sensor power-path joints**; the EC5 and ESC pad joints and negative feed can remain. Cut only while completely disconnected and once the sensor's retained physical placement is settled. If the C3 temporary fuse already divided this wire, reuse its two 12 AWG segments after removing the temporary overlaps; do not cut another section out of their remaining service bends. Remeasure the actual sensor route and fresh strip allowances after removal. Trim to that actual placement with relaxed bends; use the carrier's largest power-path through-holes for the 12 AWG wires. Battery-to-load current follows the `+i` arrow printed on the carrier **bottom**: its arrow-tail high-current side receives EC5 positive, arrow-head side feeds ESC positive. Confirm `5V B10` on the received bottom before using this module's figures. The low-current `VDD/VOUT/GND` holes are **never** the battery-current path.

Use the output-side copper's second appropriate high-current hole for the later 16 AWG fuse-holder input lead; the manufacturer's second-largest holes accept up to 14 AWG, so the owned 16 AWG lead fits. It must be on the same **output** current-path copper as the ESC wire, not an unrelated signal pad. Keep the sensor off frame copper, support its body on insulating material and strain-relieve both heavy wires. Do not enclose it in a dense bundle/heatshrink sleeve that prevents cooling. No load taps EC5 positive before this sensor.

The [Pololu 5292 manufacturer page](https://www.pololu.com/product/5292) permits thick soldered wires for its current path. It distinguishes ±100 A **measurement range** from its 60 A continuous thermal test at approximately 25 °C; actual capacity depends on mounting/connections/cooling. The [SunnySky test table](https://sunnyskyusa.com/products/sunnysky-x2212-brushless-motors-new) reaches a calculated approximately 78 A for four motors at one listed point. Full-throttle duration/current/temperature qualification remains required before unrestricted operation.

#### W1 — isolated divider and sensor signals

Reserve an unused four-pin stack lead for sensor logic power at the original FC's **UART8 port**: the [original FC diagram](https://micoair.cn/api/media/file/docs/2026/07/667c0fbaa3976-8a38aec13b-20c3f71554.webp) shows it on the **USB/card-slot face, right lower edge**, labeled top→bottom `RX8, TX8, 5V, GND`. This is the opposite face from the top-right ESC socket. Identify the keyed plug cavities by those board functions before using conductors. At the free end use only the mapped `5V` and `GND`; insulate the unused RX8/TX8 ends individually. Check both required end-to-end paths and absence of cross shorts with the cable isolated.

```text
FC UART8 5V ───────────────────────────── Pololu VDD
FC UART8 GND ───────┬──────────────────── Pololu GND
                    └─ R2, 10 kΩ ── NODE ── R1, 10 kΩ ── Pololu VOUT
                                    │
                                    └─ isolated FC Curr wire
```

Build this divider **off the boards first**, using the two owned 10 kΩ 1% resistors. Insulate each exposed axial lead and splice separately; strain relief belongs to insulated wire, not the resistor body. R1 goes from VOUT to NODE; R2 from NODE to GND. Measure resistors individually on the AM33D **20k Ω** range before attachment: 9.8–10.2 kΩ screening band, allowing resistor tolerance and the AM33D's resolution/accuracy. This screens the received 10 kΩ part identity; calibration still uses actual readings. With the divider alone and FC/sensor disconnected, NODE↔VOUT and NODE↔GND each read about 10 kΩ, and VOUT↔GND about 20 kΩ on the **200k Ω range**; two resistors can exceed the 20k range maximum. A displayed open/out-of-range on an insufficient range is not proof of a broken divider. Verify the NODE lead's direct path to its assigned FC Curr contact and that the ESC Curr path is still isolated before final connection.

Connect logic VDD only to the mapped FC **5V**, never VBAT or 3V3. The selected module needs 4.5–5.5 V and outputs nominal 2.5 V plus 20 mV/A; the divider gives nominal 1.25 V zero and 10 mV/A. These figures are calculations for preparation; actual zero, scale and ADC input loading must be measured. **Never connect raw VOUT to the FC's 3.3 V ADC.** Power the sensor from FC 5V independently of Pi; retain ESC VBAT/GND and onboard voltage sensing.

After the high-current conversion, repeat P5 for EC5 positive to sensor input and sensor output to ESC positive separately. Those two high-current sides also normally have continuity through the sensor's low-resistance current conductor; that is expected. Require isolation between its high-current path and unpowered logic pads, and no added battery positive-to-negative hard short. Repeat final mechanical/polarity review after mounting.

### Stage A — separately fused Matek input, then Pi and lamp

This stage follows propulsion construction; it does not delay Stage P motor/ESC assembly.

Use the owned MPD BF353 holder and 5 A Littelfuse: sensor **output-side** copper → holder input lead → removable 5 A fuse → holder output lead → short red 20 AWG lead → Matek `IN`. Use a supported soldered overlap splice for the 16-to-20 AWG transition: approximately 5 mm exposed copper on each, tinned, overlapped and held stationary while solder wets both, then gentle tug/continuity check before heatshrink. Keep the fuse **out** while constructing/checking the branch. Short black 20 AWG return goes from Matek input `G` to ESC battery `−`; this added pad joint is made only with the main circuit disconnected and then rechecked.

[The received Matek diagram](assets/bec.jpg) labels `IN/G/G/OUT`; match each actual printed label, not a guessed left/right order. Leave both voltage-select bridges open for the documented default 5.2 V. The [manufacturer documentation](https://www.mateksys.com/?portfolio=bec12s-pro) specifies 9–55 V input, 5 A continuous output and **no reverse-input protection**. The input fuse does not correct wrong polarity or independently protect every Pi output fault.

With BEC disconnected from the branch and fuse removed: sensor output ↔ first fuse terminal must have continuity; second fuse terminal ↔ red BEC-IN tip must have continuity; the two fuse terminals must be open. Negative ↔ black BEC-G tip must have continuity; each positive path ↔ return must be open. After attaching BEC, screen input `IN↔G` and output `OUT↔G` for a sustained hard short as in P5, recognizing semiconductor/capacitor behavior; keep Pi/socket unattached. Insert the actual 5 A fuse only for the later released BEC power test.

**Pi output work remains separate:** parallel short equal-length 20 AWG feeds to both physical Pi contacts **2 and 4**, returns to **6 and 9**, through the retained Samtec 2×5 socket over physical pins 1–10. Pin-1 orientation and all socket contacts must be mapped on the actual part before solder or Pi insertion. Loaded voltage at the Pi, output conductor/contact temperature and Pi undervoltage flags must pass; first BEC testing excludes the Pi. Remove Pi desk USB-C supply before GPIO aircraft power. Preserve the working desk setup until that output harness is ready. [Pi power/configuration guidance](https://www.raspberrypi.com/documentation/computers/configuration.html).

**Lamp work remains separate:** battery-positive feed must be downstream of the sensor, with its own defined protection for the 20 AWG feed; the Pi-only fuse does not protect an unfused lamp branch. No exposed live reserve pigtail is added now. The two emitters ultimately operate in series on the selected BuckPuck, with qualified heatsinks/retention. Before Pi–FC serial connection, resolve power-off backfeeding for FC on/Pi off and the reverse condition; raw TX/RX cross-connection is not an approved solution to that unresolved interface. These remaining engineering tasks do not prevent assembling the disconnected base circuit.

## C3 staged-power preparation — observations required before execution

**September 30 owner report:** neither a current-limited bench supply nor an RC smoke stopper is physically available. The owned **MPD BF353 holder and Littelfuse 0287005.PXCN 5 A fuse** supply a temporary series-fuse option for the following idle checks. The absent bench supply/smoke stopper does not create an automatic new-purchase dependency.

This card's current main-power batch covers **disconnected P1–P5 construction; no battery connection in that batch**. Motor-phase assembly follows its separate bounded instructions. P1–P5, all motor-joint insulation and the isolated harness map are assembly acceptance, not powered results. C2 pack voltage/cell/charge gates remain separate. A later first-power batch can follow this conditional sequence once all listed physical self-checks match; there is no additional approval after every ordinary substep. Any mismatched part, polarity, joint, insulation or reading stops the affected step for repair.

### C3-T — insert and check the temporary series fuse, still disconnected

1. Keep battery, charger and USB absent, and every propeller off. Confirm the base P5 checks have passed. At the marked SENSOR LATER positive segment, lay out the BF353 outside the frame for this bench test, keeping its incoming path near the accessible EC5 and off frame copper. Keep the negative 12 AWG route unchanged. If the positive lead was already cut without P2's rework reserve, remeasure its two future sensor termination routes before shortening anything; resolve reach with the owned stock rather than making a taut lead.
2. Remove the fuse. Cut **only the identified positive 12 AWG conductor** once at the reserved segment. Join EC5-side 12 AWG to one red 16 AWG holder lead and the other holder lead to ESC-side 12 AWG. Use approximately 5 mm stripped/tinned overlaps, support while cooling, inspect, gently tug, and individually heatshrink both joints. Preserve the factory holder-lead length apart from required strip/overlap. Label the two 12 AWG pieces EC5 SIDE and ESC SIDE; the holder itself is electrically nondirectional.
3. Retain the holder and wire bends so they cannot pull a splice or touch a motor, loose metal or board. **Every motor and temporary-power splice must have individual insulation before energization**; loose exposed joints waiting for a final shrink pass are not acceptable. The fuse protects downstream faults; EC5-side wire and its upstream splice still need complete insulation.
4. With fuse **removed**, meter these exact disconnected paths:

| Probe points | Required result |
| --- | --- |
| EC5 `+` contact ↔ holder contact on EC5-side lead | Direct continuity |
| Holder contact on ESC-side lead ↔ ESC `+` pad | Direct continuity |
| EC5 `+` contact ↔ ESC `+` pad | **OPEN/no beep**, because the fuse gap interrupts this path |
| EC5 `−` contact ↔ ESC `−` pad | Direct continuity |
| Two blades of the removed fuse | Direct continuity; confirm stamped rating **5 A**, not color alone |

5. Recheck capacitor stripe/rating, exact EC5/ESC signs, pad bridges, joint retention and clearance after this change. Fit the intact 5 A fuse with everything still unpowered; EC5 `+` ↔ ESC `+` now must have direct continuity. Repeat P5's assembled positive-to-negative hard-short screen in both probe directions, allowing capacitor charging to settle. Do not connect the pack on a failed or unexplained reading.

```text
EC5 + ─12 AWG─ insulated overlap ─16 AWG─ BF353 / 5 A ─16 AWG─ insulated overlap ─12 AWG─ ESC +
EC5 − ─────────────────────────────────────────────12 AWG───────────────────────────────── ESC −
```

The [BF353 manufacturer drawing](https://www.memoryprotectiondevices.com/datasheets/BF353/BF353-datasheet.pdf) specifies 15 A, 16 AWG leads and ATO/ATC compatibility. The [287-series Littelfuse datasheet](https://www.littelfuse.com/assetdocs/littelfuse-datasheet-287-atof?assetguid=43dcdce8-8ca2-426f-8998-7e566f048d40), pages 1–3, covers the exact PXCN part: 32 V DC, 1000 A interrupting rating at 32 V, with these 5 A opening limits:

| Current | Fuse opening time |
| --- | --- |
| 5.5 A | At least 100 hours |
| 6.75 A | 0.75–600 seconds |
| 10 A | 0.15–5 seconds |
| 30 A | Maximum 0.1 second |

This is **additional downstream fault interruption**, not an electronic 5 A current clamp or guaranteed semiconductor protection. A fault can deliver substantial current before the fuse opens. The external 470 µF capacitor stores approximately **0.066 J at 16.8 V** (calculated); total capacitance/inrush and fuse survival have not been measured. One brief insertion spark can reflect capacitor charging, but it does not excuse repeated sparking or heat. Only one 5 A fuse is recorded owned: if it opens, disconnect, diagnose and obtain an intact correct fuse before reuse or the final Pi branch. Never bypass it or substitute a larger rating to make a suspect circuit run.

### C3-I — bounded idle energization, no motor commands

1. Props absent, pack outside the frame, accessible EC5 disconnect, FC USB/charger off; all Pi/BEC/lamp/sensor logic branches detached. With the checked temporary fuse fitted, first energize **ESC/motors/base capacitor only**, FC–ESC cable unplugged, for approximately five seconds. No arming or motor commands. Startup motor tones may occur. Disconnect at EC5 using its housing. Abnormal heat, smell, smoke, repeated sparking after insertion, sustained unexpected rotation, an opened fuse or a damaged connection stops further tests.
2. Unplug the pack before moving anything. Inspect joints/insulation, measure residual ESC input DC voltage and wait until zero before resistance checks, fuse removal or adding connections. Repeat the changed-path continuity and battery short/polarity screens if anything moved.
3. Add the verified original FC–ESC cable with receiver and other peripherals detached; keep the temporary 5 A fuse in place and USB off. Attach meter probes at accessible **mapped** 5V/GND pads or insulated lead-end test points while unpowered, avoiding adjacent-contact bridges; do not force probes into a powered 1 mm socket. Energize briefly and measure FC **5V↔GND** on AM33D **20 V DC**, red to 5V, black to GND: positive **4.75–5.25 V** is this card's engineering acceptance band. Disconnect again, then inspect and record voltage/fuse/temperature behavior. No arming, RC calibration with motor output, or motor test commands in this temporary-fuse batch.
4. With pack/USB absent and residual voltage zero, remove the temporary 16 AWG path **before any propulsion-current test or flight**. Cut away each temporary overlap on its 12 AWG side without consuming the reserved relaxed bend; preserve the holder's remaining 16 AWG leads for Stage A. Remeasure both resulting 12 AWG pieces, allow fresh strip lengths, and install Stage W's sensor current path once its actual markings/placement match. Never replace the holder with an exposed jumper. Reinspect and repeat the changed joints' tug, insulation, polarity and P5 meter checks before another battery connection.
5. Reserve the intact holder and 5 A fuse for the final Pi-input branch. Fit them there only after Stage A's fuse-removed tests. If relocation changed a holder lead or splice, its new branch tests must be repeated; earlier main-path readings do not qualify it.

The five-second observation is a staged diagnostic, not a thermal qualification, and a surviving fuse is not a component or flight pass. The 16 AWG holder path remains a temporary **idle-only** circuit; neither its 15 A rating nor the 5 A fuse qualifies aircraft propulsion current.

### Subsequent integration remains separate

After the temporary path has been removed and the final main-path changes checked, finish output mapping/protocol and receiver/failsafe checks before any motor command. Add Nano only after the FC-supply check and its previously deferred power-to-signal short screen; earlier USB functional success does not erase those open checks. Compare Mission Planner pack voltage with the meter.

Finish W's sensor/divider with ESC Curr isolated; verify VDD, zero/scale and voltage/current calibration against actual measurements. The AM33D **10 A input is not placed in the aircraft high-current path**. A credible current reference and high-current temperature evidence remain to be selected; no invented current reading or device pass is recorded.

Then add the fused BEC with Pi absent, verify `OUT↔G` positive voltage/polarity, and perform its specified loaded voltage/temperature test before Pi. No unowned electronic load is assumed; the actual load method and loaded acceptance still need a finite card. Integrate Pi/lamp/sensors and complete their separate power, communications and product acceptance afterward. Native ESC current is intermediate evidence, never final whole-product energy protection.

## Remaining narrow owner observations and engineering work

The next main-power observations are **only**: actual EC5 device half/polarity marks; capacitor capacitance/voltage/stripe; eight-pin cable identity/map or specific contact-access obstacle; measured positive/negative routes plus capacitor retention/clearance. Then record the named joint/tug/insulation and P5 meter results as they are completed. Ordinary matching parts need text; request an image only for a specific unreadable mark, joint or obstruction.

For the final circuit, additionally record the actual Pololu `5V B10/+i` marks/retained placement, the UART8 power-lead map, isolated Curr cut/extension map, resistor values/divider table, Matek pad/bridge match and fuse-branch checks. Pi socket orientation/retention, loaded supply qualification, UART power-off isolation, lamp protection and high-current/current-monitor calibration remain agent-owned engineering work. **No main-power construction or battery result is inferred from earlier receiver USB success or the seven-print receipt.**
