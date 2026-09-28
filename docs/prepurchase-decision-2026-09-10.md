# Issue11 pre-fabrication decision report — September 10, 2026, R2

**Superseded for current-product requirements — September 10 product reset.** The [current requirements](../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#current-checkpoint) reopen architecture, remove cargo and require ten useful minutes excluding takeoff/landing. This document and its linked configuration files preserve earlier design evidence, not current component mandates or revised acceptance. Historical pass/fail results remain unchanged for their original inputs. Reconcile retained interfaces and validation principles against the new configuration before reuse.

**Issue11 remains claimed and unreleased. The current propulsion/energy baseline misses Q74 in the moderate model; the detailed construction candidate is rejected on endurance.** This report supersedes the earlier 2,168.11 g / 11.15-minute checkpoint. [Issue11](../.scratch/biometric-guard-drone/issues/11-hardware-build-package.md) owns integration. Historical R1 artifacts remain available without becoming current qualification evidence.

## 1. Implemented and verified

The [Fusion package](../cad/engineering-r2-2026-09-10/README.md) contains **146 current construction parts**, acquired manufacturer CAD, component envelopes, service/motion spaces, nonprinted support paths, battery travel and cable-route reservations. F3D, STEP and three conditional secondary-part STEP/STL pairs are actual Fusion exports. Sources, licenses, transforms and hashes are recorded; the original frame-reference archive is unchanged.

Independent verification covers 124 geometry screens, 121 native plate/cylinder bounds, 121 sketch profile areas/volumes, ten selected native interference pairs, and reopened archives: **146 native parts and 115 visible STEP parts** retain their dimensions and volumes. STL coordinates/volumes agree in millimetres. Inspection caught and repaired an incorrect fan-aperture extrusion before final export. These checks cover their named geometry, not complete assembly fit or qualification.

A separate Fusion assembly aligns the acquired Pololu regulator model with native KiCad holes. Core-only STEP thickness is 1.51 mm; finished-board reservation remains 1.6 mm. A native hollow-rail Static Stress study has valid constraints/load, green pre-check and a generated **74,340-element / 124,068-node** mesh. The installed local solve failed because `NASTRAN.exe` is absent. The configured archive reopened successfully; **no solved stress or convergence is claimed**. Autodesk's supported route is cloud-based; submission remains pending. The assessment uses a conservative 200 MPa yield floor rather than accepting the library's 369 MPa yield as proof.

The [electrical package](hardware/engineering-r2-2026-09-10/electrical-selection.md) contains two editable schematics and routed precision/protection carriers: both native ERC/DRC reports have zero violations and both boards have zero unconnected items. Independent audits cover 51 critical manufacturer pins, 36 precision pads, 82 protection pads and ten main power segments plus one via. Six exact-part typical SPICE scenarios support the precision rail. Fusion independently verified the final protection board outline and mounting holes. [Hashed Gerber X2/Excellon drafts](hardware/engineering-r2-2026-09-10/electrical-manufacturing-manifest.json) are prepared, explicitly **not released for fabrication**.

Typical simulation does not establish guaranteed fault timing or manufacturing bounds. Routed resistance requires at least 5.052 V at the raw Pi rail for the stated 4.75 V endpoint screen; the conservative overvoltage boundary requires less than 5.270 V. The converter's complete tolerance is unknown. Startup bypasses the overcurrent timer, while active current limiting remains; capacitance/inrush and concurrent peripheral loading therefore need their own checks. Thermal behavior and full fault timing remain explicit holds. The [mechanical proof](hardware/engineering-r2-2026-09-10/mechanical-proof.md) records tolerance, beam, retention, failure-mode and commercial-reuse screens.

The [tool provenance record](hardware/engineering-r2-2026-09-10/electrical-tool-provenance.json) records one security limitation: an initial Freerouting version/help probe may have transmitted application metadata, and its version checker made GitHub requests. Subsequent board routing used local mode with analytics/API disabled; the audit found no board-upload invocation. This is a source/invocation audit, not a packet capture or a claim of zero external traffic.

[Issue12's simulator](phone-drone/simulator.md) remains complete for its actuator-free slice: eleven synthetic scenarios and 35 deterministic tests. Run `python -m phone_drone_sim`, open [the demo](phone-drone/simulator-demo.html), and run `python -m unittest discover -s tests/phone_drone_sim -v`. Camera guidance, biometrics, failures, replay, disconnects and restarts are simulated; there is no actual camera, biometric evidence or actuator connection. Remote Mac access remains the expected [native-iPhone direction](research/iphone-route-recheck-2026-09-10.md), without a selected/purchased provider. The PC product remains retired.

## 2. Q74 and energy decision

The later owner decision is **at least 11 useful minutes**, superseding fifteen and twenty. Preserve the fully equipped no-extra-cargo reference and 6.6-minute follow / 3.3-minute hover / 1.1-minute transition workload. Deduct the separate 4 Wh pre-reference allowance and protect `max(20 Wh, 1.5 × recovery energy)`, initially using a 120-second recovery proxy. Reserve is never useful time. **12.1 moderate-model useful minutes** remains a provisional 10% paper margin, not a raised acceptance minimum or a bound on all uncertainty.

The [current model and ledgers](hardware/engineering-r2-2026-09-10/mass-energy.md) couple accessible energy to the voltage/current endpoint needed for recovery. They retain the 50 g integration contingency and 30 g pack uncertainty. Scenarios are not measured bounds.

| Reference scenario | Mass | Moderate mission power | Accessible endpoint energy | Separate reserve | Useful minutes |
|---|---:|---:|---:|---:|---:|
| Lighter component ledger; support feasibility unqualified | 2,199.614 g | 482.67 W | 109.93 Wh | 24.13 Wh | **10.17** |
| Counted conditional native construction | 2,737.798 g | 635.15 W | 6.79 Wh | 31.76 Wh | **0** |

The lighter case misses eleven by 0.83 minute / 6.70 Wh and the 12.1-minute target by 15.54 Wh. Its central 11.56-minute result does not override the moderate miss. The native construction adds 538.184 g including support paths and joints. This rejects **that construction**, not every possible seven-inch design. All 146 bodies are classified once; purchased envelopes receive no fictional solid mass and replacement stock is not double-counted. Undrawn obligations have explicit allowances, whose feasibility remains unproven.

The 172.319 g removable holder plus 250 g cargo gives 2,621.933 g even against the lighter reference, with no modeled useful energy after its own reserve. Delivery retains its separate validated envelope, not an automatic eleven-minute target.

There are **67 mass rows and 78 cost obligations**. Cost scenarios are **$2,148.34 / $2,169.24 / $2,847.34**, with 20 unquoted obligations and no delivered-price bound. The planning arithmetic does not quote the heavy construction's additional joints/stock. Stock and prices are dated observations.

**The XING-E 2809 800 KV / APC 7×4 / Nexus 6S2P P50B baseline has no defensible purchase-ready Q74 case.** A lighter reuse solution remains possible in principle, but no investigated drop-in support establishes the necessary mass, strength and margin.

The retained7×4 complete-path density sensitivity also reaches111.46 A against the conservative110 A QS8 screen. That connector corner requires resolution even before adopting7×5; a nominal central-current result does not qualify the whole path.

## 3. Components and architecture

Retain approved equipment, independent radio, authority/safety requirements and nonprinted primary load paths. Selected **engineering corrections**, still subject to release checks:

| Subsystem | Selection / reason | Accounted consequence |
|---|---|---|
| Fan | Noctua NF-A4x10 5V; documented voltage rating and maker CAD | +8.8 g / +$12.45; independent support/cooling checks |
| Sensor rail | Pololu D24V7F6 #5594 plus TPS7A9001DSKR carrier | 6 g / $12 assembly allowance; explicit loss/voltage budget |
| Auxiliary protection | Two TPS259474L-based latch-off carriers | 16 g / $40 allowance; circuit/layout evidence is not a qualified commercial module |
| Cargo connector | Molex 2147511021 / 2147531021 | 4.060 g aircraft + 4.319 g holder, $4.01 pair |
| Battery straps | RDQ 400×20 nylon/metal-buckle three-pack, variant39543827890289 | $15.99, retained30 g allowance; unavailable RCB selection replaced |
| Pan/tilt procurement | Adafruit1968 kit plus two SG92R169 servos | Replaces unavailable bundled1967; retained37 g allowance |
| Main bus | Two28 mm C110 rails with solder lands, insulation and clamps | 15.174 g copper before hole credit; joints remain unqualified |

Manufacturer evidence corrects lamp demand to4 W/module. The27 W planning auxiliary ledger includes2 W incremental conversion/protection losses. The convenient Southco latch was rejected with the retained solenoid:6–7 N release demand versus an old nonguaranteed approximately0.785 N solenoid figure. A lever cannot create force without trading stroke.

The [holder kinematic study](hardware/engineering-r2-2026-09-10/mechanical_holder_results.json) resolves a pivoting keeper's geometry with4,501 angle samples and eight assertions, avoiding the impossible earlier3 mm straight withdrawal within2.2 mm travel. Its exact direct-sear variant is still **rejected**: the selected switch can require0.9 N, exceeding the light return spring, and the release-force margin lacks support. B must mechanically witness the actual strike/lock state; a free pin extending in air must not report locked. These are quantified design failures, not an unfinished box presented as a working latch. The mechanical report specifies the smallest decisive force/return fixture before any dependent machining.

[Exact alternative comparisons](hardware/engineering-r2-2026-09-10/mass-energy.md#current-r2d-integration-and-architecture-checkpoint) cover compatibility, availability, mass, power, endurance, cost and redesign:

- **Smallest battery/propeller lead:** MaxAmps8000Lite6S,994 g/$480/177.6 nominalWh, plus APC7×5 is conditionally plausible near the lighter ledger. Adverse arithmetic requires140.08 Wh for eleven or150.77 Wh for12.1, including reserve. Its130.212 A path screen rejects the existing QS8/Nexus path and genuine AS150/AS150U. Exact factory connector and delivered-energy curves remain missing. Pack cost is+$228 before mounting/connector/charging changes. With the heavy native construction, eleven requires**181.90 Wh**, exceeding all nominal pack energy: that combination is rejected digitally.
- **OEM support reuse:** acquired Holybro CAD resolves dimensions, but `TUBE300` actually measures250 mm and its9.4 mm model diameter conflicts with the catalog10 mm. Adapters, joints and retention prevent claiming a drop-in saving. No manufacturer part is released for copying.
- **Larger matched platforms:** Chimera9ECO ($99.99/377 g frame), X500V2 ($135 mechanical/$329 ARF), and X650 ($899 ARF,2 kg before pack) are comparison baselines, not selections. The old800 KV motor with9×4.5 gives238.61 A and exceeds APC RPM limits. A larger route requires matched motor/prop/ESC/pack and new installed validation.

The [completed matched-platform comparison](hardware/engineering-r2-2026-09-10/larger-platform-results.json) now makes the proposal specific: **Holybro X650 Development Kit SKU30181, matched T-Motor P15×5 propellers and a factory MaxAmps11Ah6S pack**. The supplied Gemfan1555 props are not the props in the linked motor test table, so their performance was not invented. The nine-inch Hobbywing3110/900KV/HQ9×4×3 alternative already requires a218.5 A path screen at its tested24 V and does not offer a smaller compatible correction. The16Ah X650 alternative loses too much control margin.

For the X650/11Ah proposal, counted Pi support is106.298 g rather than the old unqualified14 g allowance. It is **separate from** the retained200 g kit-mass sensitivity,50 g integration contingency and30 g pack uncertainty. Resulting reference mass is**4,438.40 g**. At690.83 W moderate demand, required energy before the loaded bus reaches22.2 V is**165.19 Wh for11 /177.86 Wh for12.1**, including34.54 Wh independent reserve. The adverse case needs**194.00 /208.93 Wh**, including40.71 Wh reserve. Actual available endpoint energy remains unknown;244.2 nominal Wh is not a delivered-energy result. This provides a conditional engineering opportunity, not a Q74 pass.

FactoryQS8/8AWG is an actual documented option; configured pack envelope is163×60×62 mm. Its conservative110 A rating clears the22.2 V test-table screen but does not settle25.2 V current or the stockPDB/XT60 bottleneck. No adapter upgrades that bottleneck. A genuine140 g QS10-S sensitivity raises mass to4,542.40 g and moderate12.1 demand to182.97 Wh, with availability/factory identity and distribution redesign unresolved. No current-qualified complete alternative has been silently selected.

Whole-project substitution arithmetic, retaining tools, ground support, matching spare props and all20 original unquoted obligations, is **$3,654.89 / $3,675.79 / $4,353.89**. The planning increase versus the seven-inch ledger is**$1,506.55**, before three additional unquoted interface/current-path/support differences. These are illustrative scenarios, not delivered quotes or cost bounds; the$1,790.80 kit/flight-prop/pack subset is not the project total.

The first construction was also challenged directly: a counted straight-column Pi support is106.30 g, saving57.05 g from its163.343 g counterpart. A60 g tethered-secondary target is not achieved mass; four upper tethers alone fail to constrain upward travel and swing. Even removing all Pi/fan/GNSS supports entirely would leave that heavy construction324.16 g above the current eleven-minute crossing. These [support studies](hardware/engineering-r2-2026-09-10/mechanical_support_audit_results.json) reject electronics-only rescue without claiming a minimum achievable airframe mass.

**Recommended owner decision:** adopt the X650/P15/11Ah concept as the next **conditional design direction**, replacing the seven-inch frame/AIO propulsion architecture for further integrated Fusion work. This approximately doubles reference mass, changes to15-inch propellers and a Pixhawk-based flight stack, increases cost and changes near-person hazards. It preserves equipment, eleven-minute acceptance, independent reserve, cargo outcome and the approved printing boundary. Selection is proposed, not adopted; purchasing and physical release remain separate. Comparative research was already authorized and has been completed—it does not need another permission.

## 4. Approved printing boundary

The owner approved **secondary mounts, guides, shrouds, pads and appropriate hybrid holder components**, with nonprinted frame, arms, motor mounts and other safety-critical load paths. Independent nonprinted retention must prevent printed failure releasing a pack, cargo or a part into a propeller. This approval supersedes the earlier pending-scope question.

Reuse the [ten-printer/material assessment](hardware/prepurchase-2026-09-10/integration-assessment.md): X1 Carbon/unfilled ASA for outdoor secondary candidates; A1/PETG for fits and appropriate low-temperature secondary duty; externally fed TPU95A for captured pads; PLA for fits. Voron, UltiMaker and Creality alternatives remain conditional on their actual standard configuration. No upgrades/calibration are assumed. The exported shroud and pads remain **NOT FOR FABRICATION** pending final assembly/process and retention review. No structural flight print is released.

## 5. Immediate continuation and bounded holds

The native archives, electrical sources, models and local interface corrections are ready for engineering reuse. Direct Fusion control worked; no manual setup is needed. [Reproduction and verification](../cad/engineering-r2-2026-09-10/README.md) identify exact artifacts and limits.

The next consequential dependency is the specific architecture decision above. Preserve reusable sensors, electrical corrections and source models; do not finalize frame-specific manufacturing joints, harness cut lengths or production files for an endurance-rejected construction. Adopting X650 would start a new integrated assembly revision from manufacturer evidence, reconcile its power-distribution/auxiliary-supply interfaces and evaluate the explicit pack/current envelope before procurement. It would not inherit the R2D fit checks as though the frames were interchangeable. Protection performance, holder mechanism, frame revision/stack, motor fastening, RF/scan and thermal/vibration bounds remain named holds. Configured Fusion FEA can continue through its supported cloud route once submission is authorized; solving an ideal beam cannot qualify real joints or recover missing endurance.

## 6. Minimal physical evidence and permissions

Only after separate authorization and a credible selected architecture:

1. **Incoming/installed inspection:** unresolved frame revision/stack, actual pack variant/leads, material certificates and installed mass/CG. Use manufacturer evidence for known dimensions.
2. **One low-voltage fixture:** dummy-load rail/fault timing, brownout/latch restart, sensor transients and heating. Require the documented<100 ms protected-fault removal and4.9–5.1 V usable sensor rail. Reuse for peripheral concurrency.
3. **Shared retention/joint fixture plus a small force fixture:** nonenergized dummy pack/cargo, calibrated loading, independent catch and documented proof/permanent-set criteria. Separately map solenoid force/friction over stroke/temperature. The [mechanical report](hardware/engineering-r2-2026-09-10/mechanical-proof.md) specifies loads, gauges, shims, cycles and thresholds. Check only the final printed process/duty.
4. **Integrated propulsion/energy characterization:** exact pack delivered energy/DC sag, complete-path resistance, control margin, thermal/vibration/EMI and recovery endpoint. Combine logging. Retain Q74's three complete successful evaluations across at least two days for every released pack, all attempts logged and independent reserve evidence. Cargo has its own validation.

Maximum physical speed and altitude remain **unknown until configuration and evidence are finalized**. Executable results contain null, not invented maxima. Keep estimates, demonstrated bounds and operational/legal limits distinct; Q74 test pace/height are not physical maxima.

No purchasing, fabrication, hardware operation, firmware upload, supplier message or Git publication occurred. No Mac provider was selected. Reuse-first guidance remains once in [CLAUDE.md](../CLAUDE.md); unrelated and dormant PC work is preserved.
