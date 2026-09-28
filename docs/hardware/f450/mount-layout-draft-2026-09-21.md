# F450 mount layout — preliminary design, 21 September 2026

**September 22 update:** see [current compiled mount set](README.md) for the authoritative prototype status, revised Pi clearance/mass, hardware gaps and minimum remaining checks. The earlier layout below is design history and is superseded wherever it conflicts. Frame and landing legs are now assembled by owner report. No additional dimensional survey is required for the compiled prototypes.


Status: design work can proceed in parallel with frame assembly. This is a dimensioned design brief, not fabrication CAD or a print release. No aircraft electronics fit, mount strength, thermal performance or flight clearance has been physically verified. All dimensions are millimetres.

Scope: received HAWK'S WORK Original F450, owned Raspberry Pi 5 8GB/RasTech cooler and standard Camera Module 3, and the parts in the [live BOM](../../increment-1-2-bom.md). The four arms and both center plates are secure by owner report in the current conversation. Landing legs are not yet confirmed assembled. No replacement flight battery is selected. This document does not change those checkpoints or revive C1.

## Layout decision

### September 22 source check of supplied Gemini specifications

Exact-kit follow-up: the [RasTech installation sheet linked by ASIN B0DNF5JWB4](https://m.media-amazon.com/images/I/E1ELp11jEYL.pdf) was retrieved and visually inspected by the design agent. It confirms bottom cover, middle frame, top cover and a separate power-button insert. Images show diagonal rows of round ventilation holes within recessed channels, not established louver blades. It supplies no case dimensions or explicit snap-fit specification. Cooler images show three fan screws and two white spring-pin retainers but do not identify an official Raspberry Pi cooler or establish dimensions/pad targets. Thus the three-piece case description is supported; its numerical envelope remains unverified.

The [official Active Cooler brief](https://datasheets.raspberrypi.com/cooling/raspberry-pi-active-cooler-product-brief.pdf), January 2026, gives approximate 63.5 x 42.5 x 13.7 mm overall dimensions and a 30 x 30 mm fan plan view; it confirms three fan screws, anodised aluminium, spring-loaded push pins and pre-applied thermal pads. These specifications identify the official product, not necessarily the cooler bundled in RasTech ASIN B0DNF5JWB4. The brief does not establish the claimed 7.5 mm fan height or the exact supplied kit's pad targets. Raspberry Pi's [manufacturing account](https://www.raspberrypi.com/news/designing-the-perfect-case-and-cooling-for-raspberry-pi-5/) describes extrusion followed by CNC machining and stamping. The supplied Gemini case dimensions (94 x 67 x 30 mm) and detailed three-piece construction are not accepted as verified mount geometry without exact-kit evidence. Continue board-interface design; do not freeze a fitted case cradle using those claims.

September 22 owner tape readings: clear interplate gap approximately 1.5 in (38.1 mm); top plate centerline edge-to-edge spans approximately 3.875 in (98.4 mm) in both perpendicular directions. The owner used an annotated photo to clarify the second reading as horizontal, not diagonal. These are approximate local spans of a shaped plate, not a 98 mm square usable surface, bounding-box survey or hole/slot coordinates. Both plates are secure by owner report. Use readings for layout planning only; actual fit remains pending.

Use a small open carrier for the Pi above the top plate, the flight stack near the center, and two straps with adjustable end restraints for the battery underneath. Put the camera and forward depth sensor between the red arms. Leave room beside the battery for the downward optical-flow/range sensor. Start with separate small brackets so a single failed fit does not require reprinting the entire assembly.

| Region | Preliminary arrangement | Dependency |
| --- | --- | --- |
| Above top plate | Bare Pi board with existing cooler; long dimension fore/aft, open carrier | Top-plate attachment slots; eventual cooler/connector fit check, no case measurement prerequisite |
| Center between plates | Original MicoAir743 + 50A ESC, preserving its vibration grommets | Complete stack height and cable exits; bare FC height is insufficient |
| Above-plate fallback | Flight stack below an open Pi bridge | Use only if the between-plate fit fails; recheck total height and mass |
| Below bottom plate | Battery long dimension fore/aft; two transverse straps, pad and adjustable end stops | Replacement battery choice, actual strap path and gear clearance |
| Forward center | Upright Camera Module 3; adjacent VL53L7CX with separate unobstructed view | Frame attachment locations, live camera view and sensor dimensions |
| Downward, outside battery outline | MTF-01P bracket, sensor facing ground | Actual sensor view cone, gear and wire clearance |
| Away from power wiring | Sequre GPS/compass and receiver antenna supports | Final cable layout and powered interference/range checks |

The Matek Pi regulator, current-sensor board, fuse and high-current wiring need insulated mounting and service access near the power route. Do not use the Pi carrier as an excuse to cover or tightly bundle hot power components. Lighting brackets remain separate: captive optics, metal heatsinks and measured heat clearance are required; printed plastic is not a heatsink.

## Pi carrier geometry to take into CAD

Use the Pi mounting holes rather than clamping connectors or the cooler. The initial carrier concept is two narrow longitudinal rails joined by two crosspieces, with four mounting bosses. Avoid a solid enclosure. Nominal overall carrier planning limit: 100 fore/aft × 80 left/right, including local restrained wiring; this is a reserved envelope, not proof the existing case fits.

The [official Pi 5 reference drawing](https://datasheets.raspberrypi.com/rpi5/raspberry-pi-5-mechanical-drawing.pdf), checked September 21, gives an 85 × 56 board and a 58 × 49 mounting pattern. Define the mounting-pattern center as the carrier datum: with X right and Y forward, boss centers are (±24.5, ±29). Do not assume the PCB outline or component overhang is symmetric around this datum; use the drawing and actual board when placing rail edges. The drawing explicitly requires a physical board before production.

Draft CAD parameters: 2.5 mm rail thickness, 8 mm rail width and 8 mm boss outside diameter are starting choices for a fit prototype only, not validated structural dimensions. Use a center opening for airflow and wiring; add short ribs only where the physical load path requires them. Carrier-to-frame tabs must be located from the received plate, not generic F450 hole coordinates. Prefer existing plate slots; do not drill the power-distribution plate.

### September 22 source-based advancement

Proceed with a **bare-board mounting interface while retaining the existing cooler**, rather than making the enclosing desk case a design dependency. Leave the working desk assembly intact until the mounting trial. Its case may be omitted for flight only after confirming the cooler has independent, secure retention and the necessary connectors remain accessible. This is a proposed mounting configuration, not an instruction to dismantle the desk setup now.

The exact owned kit is [RasTech ASIN B0DNF5JWB4](https://www.amazon.com/dp/B0DNF5JWB4). September 22 searches for that ASIN and RasTech case/cooler technical drawings did not establish a manufacturer dimensional drawing for either accessory. Third-party results for other RasTech kits give rounded 4 × 3 × 1 inch item dimensions; other results give shipping-package dimensions. Neither supplies this kit's cooler envelope, overhang, mounting method or component clearances. Do not use those values or the official Raspberry Pi Active Cooler dimensions for this RasTech part. Cooler height/overhang and attachment remain explicitly unresolved, but are not required to lay out the documented Pi mounting pattern.

The board-interface core can now be dimensioned without a case measurement:

| Draft parameter | Value and derivation | Status |
| --- | --- | --- |
| Mount centers | X = ±24.5, Y = ±29; 49 × 58 pattern | Manufacturer reference drawing |
| Two longitudinal rails | 8 wide × 66 long, centered at X = ±24.5 | Design choice; 58 center span + 8 rail width |
| Two transverse rails | 57 wide × 8 long, centered at Y = ±29 | Design choice; 49 center span + 8 rail width |
| Core outside envelope | 57 wide × 66 long | Calculated; excludes frame tabs and cable supports |
| Central opening | 41 wide × 50 long | Calculated from rail arrangement |
| Nominal core thickness | 2.5 | Prototype starting choice; not strength-qualified |
| Four trial clearance holes | 2.8 diameter for M2.5 screws | Draft print allowance; verify with the actual printer/hardware |

The core's rectangular rail union has `57×66 − 41×50 = 1712 mm²` area. Subtracting four 2.8 mm holes and multiplying by 2.5 mm thickness yields approximately 4.22 cm³. At the September 20 mechanical review's 1.3 g/cm³ PETG density assumption, its fully solid geometric mass is approximately **5.5 g**, excluding tabs, ribs, fillets and all fasteners. This is a design calculation, not a slicer result or measured print. It leaves room within the existing 40 g total print allowance for the attachment tabs and other mounts, without demonstrating that the total will pass.

The 57 × 66 core fits inside the *numerical* 98.4 mm center spans, but those two local plate measurements cannot prove support beneath its corners or locate frame tabs. The board itself is larger than the core and is supported at its four holes. Frame attachment must still engage actual slots with a secure load path; no entire 98.4 mm square has been inferred. The open center avoids enclosing the cooler, and the draft has no overhead lid whose height would require a precise cooler dimension now.

Smallest eventual physical Pi check: during the planned mounting session, with power disconnected, trial the four-hole core and purchased standoffs against the board with its retained cooler. Check all four holes, underside clearance, cooler retention and connector access in one dry fit. Adjust only the interfering feature. A full case survey is needed only if the case is deliberately retained in flight. The trial does not itself establish structural or thermal qualification.

The ordered Pololu hardware includes four M2.5 11 mm standoffs, M2.5 screws and nuts. Trial the standoffs at the four Pi holes, checking underside components and screw engagement. Do not assume the purchased cooler leaves all holes accessible, or that nominal 11 mm is sufficient for every connector. Preserve microSD access, the camera connector latch, GPIO connector clearance, fan intake and exhaust. No permanent USB/HDMI cable should be required on the flying carrier.

Carrier-to-frame fasteners remain unallocated: the frame's 24 M2.5×6 screws are already used for the arms/plates; the eight M2.5×8 screws belong to the landing legs; the sixteen M3×8 screws belong to motor fit checks. Do not borrow structural screws. Select mount fasteners after plate thickness, slots and engagement are known; the ordered four M3 nylock nuts may already be needed by the flight stack.

## Camera concept

Use a shallow open-backed saddle that retains the camera by clear PCB edges, with a removable keeper and a separate ribbon strain-relief point. Keep the lens housing, autofocus assembly and board components completely free of contact. Establish actual component-free edge contact areas before drawing the keeper. The camera faces forward approximately level for the initial bench view; fixed-angle wedges can revise aim after checking the live image, without a heavier adjustable hinge.

The [official standard Camera Module 3 drawing](https://datasheets.raspberrypi.com/camera/camera-module-3-standard-mechanical-drawing.pdf), checked September 21, identifies 25 × 23.862 mm board dimensions and 2.2 mm mounting holes. The purchased M2.5 screws do **not** fit those holes. Do not enlarge the camera holes. Edge retention is the current concept; correctly sized camera fasteners are an alternative if edge clearance proves unsuitable, subject to the remaining hardware budget.

Route the owned 200 mm camera ribbon through a broad protected path to the Pi, with slack at both connectors and no tight fold at either latch. The routed path, service loops and bend allowances must fit the actual cable; 200 mm straight-line separation is not an acceptable layout target. Keep the ribbon entirely out of propeller swept space and away from sharp plate edges. Test live image corners for frame/arm/keeper obstruction before finalizing the camera angle.

## Stack and battery decisions driven by measurements

Measure `H_gap` from the top surface of the bottom plate to the underside of the top plate. Measure `H_stack` as the complete installed stack height above its mounting surface, including required lower isolation, grommets, screws and connectors. Between-plate placement requires `H_gap >= H_stack + 5`, plus unpinched cable exits. Five millimetres is the project's preliminary clearance target, not an external certification. If it fails, move the stack above the top plate and set the Pi bridge underside at least 5 mm above the measured highest stack component; include cable movement.

The owner-reported approximately 38.1 mm gap gives `H_stack <= 38.1 − 5 = 33.1 mm`, or **about 33 mm installed stack height available**. This is the useful consequence of the tape reading; do not treat its decimal conversion as 0.1 mm measurement accuracy. Retain between-plate placement provisionally. The bare controller's documented 8 mm height cannot establish the complete stack height, lower isolation or cable exit fit.

Keep the battery cradle open and adjustable rather than printing a box for the canceled CNHL pack. Retain the 170 × 60 planning zone from the live mechanical review and at least 30 mm open connector-service space, then revise against the replacement pack. The old 49 mm battery-height assumption is not binding: the live BOM has candidates with larger tolerance envelopes. No numerical battery cavity should be released until one is selected and measured.

Two ordered 16 × 250 straps pass through slots close to the battery sides, over the pad and around the battery. Add fore/aft end restraint so friction alone does not resist longitudinal sliding. Verify useful buckle/fastener overlap using the actual routed straps, including plate thickness and rounded slot edges; a perimeter calculation alone is insufficient. Do not route over exposed solder joints or permit a sharp plate edge to abrade a strap or pack.

Measured ground clearance equals underside-of-bottom-plate height minus actual battery, pad and lower retention protrusion. Require at least 30 mm static ground clearance under the completed aircraft's own weight and check gear flex; the seller's 150 mm gear drawing is not a measurement of this kit.

## Physical inputs and remaining fit checks

1. **Already supplied:** approximately 38.1 mm interplate gap and approximately 98.4 mm perpendicular top-plate center spans. Use the limitations stated above; no repeat measurement needed for preliminary layout.
2. **Frame attachment, at the fit step:** confirm actual slot geometry with a small tab/coupon or precise measurements. Existing overhead photos can guide its draft placement; do not infer hole coordinates from center spans.
3. **Pi, at the mounting step:** one dry fit of the documented four-hole pattern, standoffs and retained cooler. Exact case L/W/H is optional unless retaining the case; leave the desk assembly intact until then.
4. **With gear attached:** bottom-plate underside to tabletop at center. Check both front and rear if the frame is not level. This informs battery placement independently of the Pi carrier design.

Then prepare a small hole/slot fit template from the actual plate before a full carrier. Exact slot width/spacing and fastener clearance should be confirmed with a fit coupon or more precise measurement, not guessed from tape graduations. Weigh the frame with legs and Pi/cooler/camera when a scale is available; weight is a separate input from these tape measurements.

## Smallest useful fabrication sequence

First make a small frame-tab/slot coupon, then a Pi boss-pattern coupon, then a camera edge-retention coupon. Confirm fit without forcing screws or loading components. Only after those checks generate complete carrier geometry and its matching fastener list. A full aircraft tower print is unnecessary for answering the first fit questions.

Keep total printed flight parts within the existing 40 g planning allowance unless the aircraft mass/endurance budget is explicitly recalculated. Reserve some of that allowance for the depth/flow sensors, GPS, wiring and lighting brackets: do not spend all 40 g on the Pi. Slicer mass and actual scale mass replace estimates. Use the ordered 1.75 mm PETG with the Bambu X1E; material choice alone does not establish strength, heat resistance or creep life for a particular print.

Before a fabrication release, verify actual board fit and screw engagement, electrical insulation, cooling and connector service access, battery retention and clearance, sensor view cones, complete cable routes, and at least 20 mm physical propeller swept-space clearance including restrained wire movement/flex. Perform loaded retention and vibration/thermal observations before any flight claim. No file in this draft is ready to fly merely because it can be printed.

## Evidence and boundaries

- [Current status](../../CURRENT.md), [live BOM](../../increment-1-2-bom.md) and [exact buying snapshot](../../buying-order-2026-09-20.md) provide the live part selections. Dates in purchase forecasts are not new delivery promises.
- [September 20 mechanical review](../../research/precheckout-mechanical-2026-09-20.md) was opened specifically to recover its dated envelope, clearance and mass calculations. Its canceled battery is superseded by the live BOM.
- Pi and camera manufacturer drawings above were consulted directly; they supply reference geometry, not received-part measurements.
- This draft introduces no purchase, PCB drilling, camera modification, checkout, checkpoint edit or fabrication release. Saved locally; not committed.
