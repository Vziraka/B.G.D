# Final buildability gate before Q75 — 2026-09-03

**Post-Q75 controlling update — 2026-09-03:** Q75 is approved and issue10 is **resolved as planning complete**, with Q74 unchanged. The [current hardware build package](../hardware/baseline-r1/README.md) records subsequent issue11 engineering. It exposes a genuine error: the selected$8 QS8-S item is a **two-pack series adapter**, not the assumed one-pack pigtail. Under the user's affected-subsystem authorization, R1.1 replaces only that interface with another genuine bare QS8 male and existing8AWG stock. Switch polarity, AHCT channel use and D500 cable reach are also corrected. The original1,897.251g/20.98min/$2,052.93 figures below are historical model/basket values, **not final R1.1 assembly totals**; see [mass/cost impact](../hardware/baseline-r1/mass-cost-impact.md). H01–H12 detailed engineering remains open; no purchase, fabrication or physical qualification is claimed. Dated pre-Q75 conclusions below do not override this update.

## Gate result

**Paper component compatibility: PASS, conditional.** No selected component pair is presently documented as fundamentally incompatible. All known incompatible alternatives were removed.

**Fabrication release: NOT YET PASSED.** The baseline is a coherent complete component architecture, but it is not ready to hand directly to a builder until the custom assemblies below receive dimensioned drawings, the final harness/netlist and the firmware/safety manifests. Those are implementation-design outputs, not reasons to change an approved requirement or repeat the BOM search.

**Physical acceptance: PENDING.** Thirty-seven audit rows are marked `REQUIRES PHYSICAL VALIDATION`. They reduce to 33 distinct gates because four rows are summary duplicates: the motor-output row repeats D03, the I2C port row repeats D08, the 6S-candidate summary repeats P02/P25, and the C110 summary repeats P10/P11 plus its carrier gate.

No current evidence requires reopening component selection. Four groups could nevertheless force a component or architecture change if they fail after receipt/build: propulsion/endurance/control; pack/CG/rotor packaging; undocumented high-current pad and regulator/load behavior; and compute/RF integration. That is real residual risk, especially Q74 endurance. A failure is not a waiver: it reopens the affected hardware choice.

## Every `REQUIRES PHYSICAL VALIDATION` gate

### Mechanical and mass

| Audit ID | Gate | Why it cannot be `VERIFIED` before receipt/assembly |
| --- | --- | --- |
| M02 | Motor-to-arm installation | Published 19×19mm M3 patterns align, but actual arm stack thickness, screw engagement and winding clearance require the received motor/arm/screw stack. |
| M03 | Prop-to-motor installation | Nominal 5mm ring/shaft and M5 nut match; concentric seating, ring tolerance, thread engagement and correct rotation require the received parts. |
| M05 | Dynamic prop clearance | CAD proves static gaps only. Blade flex, arm flex, motor-axis tolerance and wire/accessory motion exist only under the assembled thrust load. |
| M08 | Rotated AIO envelope | The calculated 50.91mm envelope fits the planned region, but actual plate edges, USB/SD access, dampers, bus and bend radii need a 1:1 received-part overlay. |
| M09 | Battery envelope and mass | Nexus dimensions/mass are approximate and the configured lead exit can vary. Actual cradle fit, cable bend, configured mass and restraint cannot be measured before receipt. |
| M22 | Complete mass and CG | The 1,897.251g/2,317.251g values contain allowances. Finished wire, guards, fasteners, adhesive and fabricated parts determine actual mass, CG and individual motor loading. |

### Propulsion, power and charging

| Audit ID | Gate | Why it cannot be `VERIFIED` before receipt/assembly |
| --- | --- | --- |
| P02 | XING/APC installed thrust-power behavior | The model combines APC data and motor KV/resistance; it is not a four-motor bench map with the selected ESC firmware, prop lot, airflow and wiring. |
| P05 | QS8 flight disconnect | Paper current rating passes, but connector housing convention, contact engagement, polarity, soldering, strain relief, resistance and temperature are installation properties. |
| P10 | INA-BM high-current joints | Matek identifies the active top ends, but 8AWG wetting, clearance, mechanical support, resistance and temperature depend on the finished joint. |
| P11 | 10AWG bus-to-AIO termination | Wire ampacity passes; MicoAir does not publish pad geometry or a 10AWG acceptance claim. A received-board solder coupon/fit check may require a supported transition termination. |
| P12 | AIO capacitor installation | The 35V rating passes 6S. Polarity, lead length, attachment and actual bus transient/ripple behavior depend on the finished power loop. |
| P14 | Pi power carrier | Pi GPIO power and BEC ratings pass individually; voltage drop, current sharing across pins, #2310 trace/joint heating and brownout margin require the built carrier under load. |
| P15 | Peripheral 5V rail | The BEC is rated 5A, but the #1967 servo variant/stall current is undocumented. Actual coincident servo/light/solenoid demand and the release interlock must be measured. |
| P16 | IR 3.3V rail | Nominal 6W load is within the DFR1015 paper rating, but output accuracy, AIO 12V loading, airflow and regulator/board temperature are installation-dependent. |
| P19 | Common-ground/no-backfeed topology | The schematic forbids parallel outputs; continuity, isolation, start-up order and fault backfeed require tests on the completed harness. |
| P22 | Charger and configured pack | The M6AC supports 6S, but the delivered US mains variant, firmware, lead polarity, 4.2V/cell endpoint and balance accuracy must be checked with the actual charger/pack. |
| P24 | High-current joint process | The final BOM uses Hakko FX-888DX/T18-C4 rather than the audit's preliminary Weller candidate. Tool specifications cannot prove operator process, joint wetting, pull strength or temperature rise. |
| P25 | Twenty useful minutes plus reserve | Central prediction is 20.98 minutes and moderate sensitivity is 18.20. Only the approved Q74 workload on the complete aircraft can establish compliance. |
| P27 | Loaded payload/control envelope | The 7.40-minute/1.368 model is predictive. Holder drag, real CG, structural retention, thrust, recovery energy and control with 250g cargo require controlled loaded tests. |

### Data, firmware, sensing and behavior

| Audit ID | Gate | Why it cannot be `VERIFIED` before receipt/assembly or implementation |
| --- | --- | --- |
| D03 | 45° attitude and motor mapping | Firmware supports rotation, but installed arrow direction, AHRS rotation, motor numbering/direction and actuator response must be checked props-off on the mounted board. |
| D06 | RP1/FC CRSF link | UART6/5V match on paper. Binding, regional variant, antenna placement, failsafe, range and RF coexistence require the actual devices and installation. |
| D07 | M10 GNSS UART wiring | UART3/115200 match; the received cable's tail order, polarity, continuity and installed GNSS behavior require inspection and power-up. |
| D08 | IST8310 and INA on I2C1 | Nominal 0x0E/0x45 addresses do not collide. Actual revision, straps, voltage, pull-ups, orientation and simultaneous discovery require the received bus. |
| D09 | TFmini-S interface | UART logic/baud match. Its tight 5V±0.1V requirement must be measured at the installed connector under system load; failure would require a dedicated regulated feed. |
| D10 | D500/Pi USB | The kit supplies the documented adapter/cable. Enumeration, bandwidth, retention, power/reset recovery and coexistence with camera/video need the assembled Pi system. |
| D13 | Pi workload and thermal behavior | Component support is documented, but full biometric/video/navigation load, airflow, throttling, undervoltage and reboot behavior depend on the final guard and software. |
| D14 | Pan/tilt actuation | PWM resources are available. Servo direction, travel, end stops, stall current, camera framing and CSI snag clearance require the built mechanism. |
| D19 | Holder state switches | Two independent SPDT inputs exist; bracket actuation, debounce, alignment and open-wire fail-safe behavior require the finished latch/holder. |
| D20 | Recipient verification and release | Hardware supports the gate, but landed/motors-stopped state binding, face verification, anti-bypass behavior and physical release require implemented software plus the holder. |
| D21 | Owner biometric arming | Pi/FC interfaces support the design. Secure provisioning, liveness, freshness, cancellation and fail-closed FC enforcement require implementation and end-to-end testing. |
| D22 | Independent emergency radio | ELRS is a separate path on paper. Exact flight modes, takeover priority and link/failsafe behavior must be commissioned on the aircraft. |
| D23 | iPhone local voice/video path | Required radios exist. Antenna placement, RF coexistence, locked/pocketed flow, latency, temperature and disconnect recovery need the built aircraft and actual phone app. |
| D24 | Privacy/retention enforcement | This is not a component-fit question. Local-only capture and deletion are approved requirements, but only the implemented software and storage lifecycle can prove enforcement. |

### Audit summary rows already covered

| Audit row | Covered by |
| --- | --- |
| Motors 1–4 port summary | D03 |
| INA-BM + IST8310 port summary | D08 |
| Original 6S XING/APC/P50B summary | P02, P25 and M22 |
| C110 dual-bar distribution summary | P10, P11, P19 and custom bus fabrication below |

## Every custom-fabricated component or assembly

| Custom item | Baseline construction | Required before fabrication/release |
| --- | --- | --- |
| Rotated AIO adapter | Maximum 55×55×1.6mm G10/FR4 plate; outer 30.5mm M3 frame pattern; inner 25.5mm M3 pattern rotated 45°; nylon hardware and elastomer damping | 1:1 frame/AIO overlay; dimensioned hole/edge drawing; USB/SD/wire clearance; board arrow and component-side-up marking; airflow and screw-length check |
| High-current bus and guard | Two C110 H02 bars, each 3.175×9.525×50.8mm, on an approximately 80×35×1.6mm UL94 V-0 G10/FR4 carrier with at least 8mm designed rail separation; vented approximately 85×40×1mm polycarbonate cover | Dimensioned carrier/guard drawing; cable/joint locations; insulation/creepage; nonconductive strain clamps; frame mounting; polarity marking; drill/deburr/tin procedure; pull/resistance/temperature inspection |
| Battery cradle/CG slider | Nominal 170×55mm G10/FR4 platform, hard end stops, three 250×20mm straps, independent fore/aft restraint and at least ±25mm adjustment | Received 139×48×72mm pack overlay and lead-bend zone; frame attachment drawing using existing holes; rotor-plane clearance; strap slots; anti-crush padding; measured CG adjustment range and restraint proof test |
| Pi guard/fan bridge | 100×65×0.6mm polycarbonate base, two 85×8×1.2mm rails, 30×40×0.8mm fan bridge, nylon standoffs/fasteners | Cut/vent/hole drawing; #2310/Pi/fan/heatsink clearances; USB/CSI access; aircraft attachment; wire strain relief; airflow, stiffness, impact restraint and thermal test |
| Camera/pan-tilt/IR/light carrier | Insulated carrier within the 70×70×80mm forward sweep envelope; Camera3 mounted separately from two IR boards; two #5162 lights; 300mm CSI slack loop | Dimensioned plate/brackets; hole patterns; lens/IR/light aim; electrical isolation; servo-axis/end-stop geometry; CSI bend/slack/retention; glare, vibration and full-travel checks |
| D500 mast | Nonconductive mast positioning the scan plane near `s=+35mm, z=+115mm` | Dimensioned mast/base; frame attachment; cable clip; 360° self-occlusion overlay; stiffness/vibration and rotor/antenna/camera clearance |
| GNSS/compass mast | Rearward nonmagnetic support near `s=−100mm`, below D500 scan plane | Dimensioned support; cable route; separation from battery, bus, BECs, motors and ELRS antenna; vibration and magnetic-interference check |
| TFmini-S downward bracket | Nonconductive bracket outside holder/landing-leg footprints | Dimensioned sensor hole pattern and aim; unobstructed downward field; cable restraint; ground/holder/leg clearance through expected attitudes |
| Secure removable cargo holder | Enclosed approximately 100×70×60mm planning envelope for 250g cargo; 170g holder target; captive hinge; mechanical spring latch; solenoid only retracts latch; two switch cams; tamper-resistant aircraft interface | Full dimensioned enclosure/door/latch/interface drawing; chosen sheet/fastener materials; cargo padding/retention; latch load path; switch brackets; removal/service method; ordinary-hand-removal threat test; proof load, drop/retention, CG and release tests |
| Landing gear | Four supports and bracing to a nominal ground plane about 175mm below the rotor plane | Material/section and dimensioned attachment drawing; holder door/removal, TFmini and camera clearances; foot geometry; static load, flex, tip-over and uneven-ground tests |
| Aircraft power harness | Prewired QS8 8AWG section, INA transition, 8AWG bus leads, short 10AWG AIO pair, two separately fused 18AWG BEC branches and insulated star harnesses | Final netlist/cut sheet; termination drawings; fuse/connector/polarity labels; common-ground point; branch separation; strain relief; continuity/isolation, pull, voltage-drop and temperature tests |
| Ground-only charge lead | XT60 extension converted to genuine QS8 male, marked **CHARGE ONLY**, limited to 5A | Pinout/polarity drawing; solder/insulation/strain relief; permanent labeling; continuity/polarity test before pack connection; never installed in aircraft |
| Low-voltage/data harness | UART/I2C/PWM/GPIO wiring, supplied device cables, #1663 light lead, switch disconnect and CSI service loop | Final pin-to-pin netlist, colors, cut lengths, keyed labels, removable-boundary connector, signal/power separation, continuity and no-backfeed test |

## Q75 implication

Q75 can approve this as the **conditional planning baseline** because no known incompatible selected pair remains. It cannot truthfully mean “fabrication drawings complete,” “ready to purchase,” or “performance verified.” The M1 aircraft specification/build package must complete the fabrication-release items above before cutting material or applying power, and Q73/Q74 plus the later validation register remain mandatory after assembly.

No settled requirement is reopened and no BOM optimization is performed by this gate.
