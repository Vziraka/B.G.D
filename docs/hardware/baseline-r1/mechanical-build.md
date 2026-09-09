# R1 mechanical definition and fabrication-release register

Date: 2026-09-03. **Engineering study, not released for fabrication.** The nineteen dimensioned sheets are useful design inputs, not nineteen finished manufactured parts. In particular, blanks with omitted interfaces must never be represented as fabrication-ready drawings. Q75 closes architecture planning; this remaining detailed engineering belongs to issue11.

**2026-09-05 CAD update:** [Fusion evidence](../../../cad/engineering-progress-2026-09-05.md) supersedes the preliminary master-axis/left-right labels below. Actual CAD uses FLU at the motor centroid; the older circle-centre study coordinates are retained only as history. M01's55mm blank intersects four modeled standoffs; a48mm revision clears them nominally, but remains H01. A pinned-DXF/current-product bottom-thickness discrepancy and unverified assembly stack prevent frame-dependent release. This is not a hardware-architecture change or a physical fit pass.

## Drawing set and datums

[Vector PDF](drawings/dimensioned-study.pdf), [machine-readable dimensions](mechanical-parts.json), [cut list](cut-list.csv), [generator](generate_drawings.py). All dimensions are mm. Each plate uses its own centre datum, x right/y up in its front view; slots use overall length/width and semicircular ends. Sheet tolerances are proposed manufacturing requirements, not manufacturer part tolerances. Material densities are explicitly approximate mass-screen inputs: FR4 1.85, polycarbonate 1.2, copper 8.96 g/cm³. Material grade, flammability, strength and purchased stock certification require release review.

Aircraft axes: `r` right, `s` forward, `z` up. Rotor plane z=0 is a physical datum; do not invent a frame-top-to-rotor offset. From the TBS manufacturer DXF, `r=DXF_x−1518.565263306285`, `s=1461.258462156818−DXF_y`. The manufacturer's flat DXF supplies plan geometry, not complete assembly height or component mounting verification.

| Feature | r | s | Evidence |
|---|---:|---:|---|
| FL motor | −145.2228 | 58.1040 | Manufacturer DXF centre |
| FR motor | 145.2228 | 58.1040 | Same |
| RL motor | −96.1704 | −123.3571 | Same |
| RR motor | 96.1704 | −123.3571 | Same |
| Rotor centroid | 0 | −32.62655 | Mean of four centres |
| 30.5 stack holes | ±15.25 | 12.5954 /43.0954 | Four holes, stack centre s27.8454 |
| Structural front pair | ±14.6 | 80.7287 | Manufacturer DXF |
| Structural second pair | ±14.6 | 55.7287 | Same |
| Structural middle pair | ±14.6 | −0.0382 | Same |
| Structural rear pair | ±11 | −52.9090 | Same; not same spacing as middle pair |

The source is [TBS SOURCE ONE](https://github.com/tbs-trappy/source_one), file `So1-V6-7inDC-2025-JUL-07.dxf`, downloaded 2026-09-03, SHA256 `398556cd5f8720ac1a39b79bd1a0d1c083c6c57def55920bc17b212061b6d099`. Raw source remains in ignored research scratch; the filename/hash and extracted dimensions preserve provenance. The 177.8mm prop discs have approximately10.17mm nearest front/rear and14.54mm rear-pair static clearance, calculated from those centres. This is not dynamic clearance.

## Assembly targets, not final locations

| Assembly | Retained target | Drawing/release condition |
|---|---|---|
| AIO | Centre r0,s27.8454; board edges45°, arrow toward+s; component side up | M01. Frame30.5 square and AIO25.5 square are separate patterns. Do not infer AHRS yaw45 from the screw pattern. Height/USB/SD/airflow overlay H01. |
| Bus | M02/M03/M04; two rails50.8×9.525×3.175; minimum8mm rail gap | Nonconductive straps at x±10 avoid solder zones x±16..25.4. Carrier/cover gap12mm. Complete enclosing side/exit geometry H02. |
| Battery | Configured pack139×48×72 provisional; cradle170×55; three20mm straps; independent end restraint; ±25mm CG travel | M05/M06 are blanks. No slider mounting holes are released: middle/rear frame pairs have different lateral spacing. Need two supported stations, no unsupported cantilever or strand-bending load. Bottom at least15mm above rotor plane throughout travel is a clearance requirement, not a verified fit. |
| Pi | PCB centre r0,s−25; full100×75×45 service envelope below frame, approximately z−40..−85 | M07–M09. Pi58×49 screw-pattern centre is10mm from PCB centre along long axis. Rail centres x−10,y±24.5;80mm rails. Heatsink, fan, HAT and GPIO feed all remain. No perimeter/weather enclosure is claimed. |
| Camera/IR/lights | Forward swept envelope70×70×80 near s105, below scanner beam | M10/M11 blanks. Camera screw clearance, gimbal rotation/end stops,300mm CSI service loop, IR heat/light separation H05. |
| D500 | r0,s35, scan plane z115 | M12 base only. Sensor underside datum, mast section/bracing and attach H06. Adapter target z50,500mm USB route below beam; no assumption supplied200mm cable reaches. |
| GNSS/compass | Rearward near s−100, below scanner beam | M13 base only. Mast stem/attachment and magnetic separation H06. |
| TFmini | Downward, outside holder/feet/strut projection | M14 blank. Exact r/s and aim require complete holder/gear overlay H07. Do not aim through polycarbonate. |
| Holder | Approximately100×70×60 outside envelope; mass target170g, payload250g separate | M17–M19 wall blanks only. Centre near rotor centroid; underside near z−155, ground near z−175. No usable interior cargo volume promised. H09 owns full mechanism. |
| Landing gear | Four supports, feet/bracing; nominal ground z−175 | M15/M16 studies.170mm strips alone do not establish ground height, stiffness or a buildable joint. H08 defines joints and actual installed angles. |

The selected electronics and functions are unchanged. New support detail may alter mass, cost and layout; Q75 authorizes only the affected redesign if an incompatibility/requirement failure is exposed. No seven-inch-frame replacement or new propulsion search was performed.

## Every custom assembly and what is still required

The following are **design/evidence holds**, not automatically physical-validation items. Obtain available authoritative CAD/specifications and finish engineering first. Only tolerances, workmanship and actual performance are deferred to receipt/bench/flight.

| Hold | Custom assembly and present artifact | Work needed before fabrication release | Later physical check |
|---|---|---|---|
| H01 | AIO adapter M01 | Resolve assembled frame vertical stack and standoff lengths, screw engagement, board dampers, USB/SD access and 3D motor/prop geometry. Source-supported dimensions or actual-part overlay; no guessed motor screw length. | M02/M03/M05/M08/D03 fit, axis and dynamic clearance tests. |
| H02 | Bus carrier/top guard/bars M02–04 | Dimension side skirts and insulated wire exits, branch land zones, support/strain clamps, mounting to frame and fasteners. Review1.5mm outer slot edge ligament; establish joint pull-load and temperature limits. A flat top cover is not a complete live-copper guard. | P05/P10/P11/P12/P19/P24 polarity, pull, resistance and thermal tests. |
| H03 | Battery cradle/slider M05–06 | Complete slider and frame brackets against unequal frame hole pairs, ±25mm range, end-stop angles, straps/padding/lead exit, vertical rotor clearance and strength. Drawing must carry two independent restraint load paths and all fasteners. | M09/M22 actual pack dimensions, restraint and CG. |
| H04 | Pi base/rails/fan bridge M07–09 | Obtain exact vendor fan/HAT/Pi connector overlay; finish fan opening, bridge posts, aircraft support, cooling inlet/outlet and wire strain relief. Pi hole pattern is a design input pending signed-off vendor overlay. | P14/D10/D13 power drop, heat, throttling and retention. |
| H05 | Camera/IR/lighting carrier M10–11 | Finish Camera3/1967/IR/NeoPixel bolt patterns, insulating brackets, fastener lengths, servo swept envelope and ribbon restraint; documented bend specification or supplier evidence. No mounting through powered IR holes to Camera3. | D14 travel/stall/snags plus optical/glare/night tests. |
| H06 | D500/GNSS bases M12–13, mast route | Resolve exact sensor datums/hole drawings, mast stem sections, braces/feet and frame attachments; full360° scan-plane overlay, antenna/battery separation and USB retention. | D07/D08/D10 vibration, compass interference and sensor behaviour. |
| H07 | Downward sensor M14 | Complete vendor hole overlay, final aim/location and optical cone vs holder/legs over attitude range. | D09 optical/voltage qualification. |
| H08 | Landing struts/feet M15–16 | Finish frame joints, strut angles, cross-braces, foot pads, fastener schedule, static/buckling/tip-over calculations and tolerances. Select grade from documented material properties before strength claims. | Gear loads, landing deformation and clearance. |
| H09 | Holder wall blanks M17–19 | Dimension corner joints, captive hinge, spring/mechanical latch, solenoid bracket/linkage, strike, seat/rails, switch cams, anti-hand-removal interface, all tolerance stacks and fasteners. Determine available force over3mm stroke from source/bench; solenoid carries no cargo load. | D19/D20/P27 plus V35/V36 retention/security/release. |
| H10 | Flight power harness | Netlist/electrical-build exist. Complete physical routing/strain clamps, exact AIO pad termination and high-current guards; reconcile mass. Exact QS8-S supplier variant is a procurement evidence hold if ambiguous. | P05/P10/P11/P19/P24 workmanship/load tests. |
| H11 | Ground-only charge lead | Netlist defines separate QS8 male/XT60 lead,5A maximum. Final supplied-cable mating/label/strain-relief drawing follows connector polarity evidence. | P22 continuity/polarity/balance and charger endpoints. |
| H12 | Low-voltage/data/carrier harness | Pin/netlist and passive allocation exist. Carrier layout, exact connector-view verification and route overlay still need sign-off. Retain500mm D500 cable and100mm sensor lead; all four AHCT channels used. | D06–D10/P14/P15/P19 installed behaviour. |

H01–H12 are an engineering backlog for issue11, not twelve new questions for the user. None requires revisiting approved features. Where dimensions are unavailable publicly, the next input is a supplier drawing or subsequent received-part inspection; procurement remains unauthorized. Do not label an unresearched/undesigned bracket “pending physical validation” to make it disappear.

## Cargo mechanism contract

Use aircraft-mounted A and B switches with COM→GND and NO→input, external3.3V pull-ups. A is reached only by a lid tongue when holder is fully seated against its stops **and** lid is shut. B is behind the aligned strike and responds only to a bolt passing through it, not a bolt freely extending beside an absent holder. A zero is evidence of positive contact actuation; an open wire reads unsafe. A short-to-ground/stuck contact can falsely appear safe and needs the explicit fault coverage in the safety contract.

Solenoid and its keyed disconnect remain inside the removable holder. The latch must hold without coil power and must not transmit cargo load through the solenoid. Aircraft-removal fasteners are captive and accessed inside the locked compartment: pulling the whole holder cannot bypass the recipient gate. The solenoid's3mm stroke alone does not establish latch engagement, return force or tolerance margin. No final linkage dimension/force is invented in this package. Authorized access follows recipient verification, landed/disarmed/stopped confirmation and the FC-owned pulse timeout; see the [truth tables](safety-state-tables.md).

## Fabrication methods and inspection

FR4 requires controlled machining with appropriate dust extraction/PPE and electrically clean finished edges; never drill the carbon frame to compensate for wrong drawings. Polycarbonate needs material-appropriate cutting/drilling with deburring and no cracked fastener holes. Copper bars require cut/deburr/clean/tin with a validated high-thermal-mass solder process, insulating clamps and zero exposed live metal. Harnesses require the specified solder/crimp process, heat shrink, polarity labels and strain relief. No solderless breadboard or loose jumper leads are installed.

All these processes can be outsourced. A printer, mill, drill press, laser cutter or expert fabrication service is **not presumed owned or free**. A complete fabrication quote cannot be claimed until H01–H12 yield final material, joint and fastener counts. Do not send the study PDF to a fabricator as a released drawing package.

## Mechanical sources

- [MicoAir743v2 AIO manufacturer manual](https://micoair.cn/zh/docs/flight-controller/micoair743-aio-series/micoair743v2-aio-45a-manual):36×36×8mm,25.5mm M3 pattern,45° board mounting with forward arrow and airflow requirements.
- [Raspberry Pi4 drawing](https://datasheets.raspberrypi.com/rpi4/raspberry-pi-4-mechanical-drawing.pdf) and [Camera3 standard drawing](https://datasheets.raspberrypi.com/camera/camera-module-3-standard-mechanical-drawing.pdf). Web returned PDFs; local automated download returned403. Unreadable detail was not filled with an invented vendor fact; final overlay remains H04/H05.
- [D500 maker product](https://www.waveshare.com/product/modules/sensors/d500-lidar-kit.htm) and [wiki](https://www.waveshare.com/wiki/D500_LiDAR_Kit). Kit includes adapter,~200mm USB and~100mm sensor lead; use exact model mounting drawing, not generic LiDAR dimensions.
- [Adafruit1967](https://www.adafruit.com/product/1967) and [2776 solenoid](https://www.adafruit.com/product/2776). Nominal envelope/stroke does not establish bracket-hole/force/tolerance design.

All retrieved/reviewed2026-09-03. Prior optical, prop, pack and material source links remain in the frozen research packet. No new physical compatibility status is upgraded to VERIFIED by creating a drawing.
