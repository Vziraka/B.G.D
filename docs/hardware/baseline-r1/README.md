# B.G.D hardware build package — conditional baseline R1

**Issue10 is resolved: planning complete, Q75 approved. Issue11 remains in progress: this package is not yet implementation-ready or fabrication-released.** No procurement, fabrication, firmware installation, PC-ticket implementation or physical qualification was performed. Q74 still requires at least20 useful minutes with the independent reserve intact.

Q75 freezes the architecture, with narrowly scoped correction permitted for a demonstrated incompatibility or requirement failure. The packet below records engineering artifacts and real remaining work; a document containing an unresolved design hold is not described as a finished fabrication drawing or production firmware release.

## Artifacts

| Artifact | What exists | Release status |
|---|---|---|
| [Dimensioned drawing PDF](drawings/dimensioned-study.pdf), individual M01–M19 SVGs | Nineteen dimensioned plate/blank studies, hole/slot tables, material/thickness and tolerances | **DRAFT**. Missing slider, mast, joints, latch and vendor-interface details listed H01–H12. Not a full3D assembly or released cut package. |
| [Mechanical definition](mechanical-build.md), [cut list](cut-list.csv), [source dimensions](mechanical-parts.json) | Manufacturer frame datums, custom assembly inventory, process requirements, geometry corrections and explicit design holds | **DRAFT**. Full mounted interference/strength/CG/fastener audit not complete. |
| [Harness netlist](harness-netlist.csv), [electrical definition](electrical-build.md) | Point-to-point power/data wiring, conductor allocations, connector/termination rules, protection, level-shifter/passive schedule | **DESIGN DEFINED WITH HOLDS**. Carrier layout, exact connector/pad verification and final route overlay still required. |
| [Pin allocation](pin-allocation.csv) |43 resource rows, including intentionally unused/inaccessible resources | **PAPER ALLOCATION**. Physical continuity, pin orientation and installed behavior remain unqualified. |
| [Firmware manifest](firmware-manifest.md), [JSON](firmware-manifest.json) | Immutable source/hash references, board target, design-fixed settings, calibration placeholders, software support and security gaps | **REFERENCE/IMPLEMENTATION CONTRACT**. Not a loadable final parameter file or approved production image. |
| [Safety/state truth tables](safety-state-tables.md) | Arming, emergency control, faults, reserve, cargo and rail behavior; named enforcement owners | **IMPLEMENTATION CONTRACT**. Later policy/timing gates remain explicitly unselected/unmeasured. |
| [Acceptance traceability](acceptance-traceability.csv) |40 existing validation obligations plus33 distinct compatibility gates | **REQUIREMENTS MAPPED**, not evidence of73 passes. |
| [Mass and cost reconciliation](mass-cost-impact.md) | Known support changes and lower-bound allocation overruns | **OPEN**. Old1,897.251g /20.98min /$2,052.93 cannot be reused as final R1.1 assembly claims. |

## Evidence-driven corrections after Q75

1. **Actual selected-interface incompatibility:** the$8 QS8-S item is a two-pack series adapter, not a straight one-pack lead. Replace only that interface with one additional genuine bare QS8 male, existing8AWG stock and the already included qualified soldering process. The separate charging connector remains separate. Battery, frame, propulsion, current monitor and bus architecture stay fixed. This is R1.1's power-interface correction under the user's explicit affected-subsystem authorization; it is not procurement approval.
2. **Electrical logic:** two positively actuated switches use NO-to-ground with external pull-ups; the old NC instruction was not safe for the required geometry. All four existing SN74AHCT125 channels are allocated, including5V translation for pan/tilt/release. No additional controller is substituted.
3. **Physical cable reach:** a specified500mm USB cable replaces the D500 kit's200mm lead; retain the supplied adapter and sensor lead. This completes a selected-sensor interface, subject to final routing and mass reconciliation.
4. **FC software work after the product revision:** the former all-path face-plus-voice arming gate is superseded by the [phone/onboard v1 contract](../../phone-drone/interaction-contract.md). The production FC must accept only the separately qualified M1 manual path, a paired-radio launch edge or a fresh one-use paired-phone launch request, while rejecting unbound force-arm/script/mission paths. Onboard face+liveness then controls spoken-command permission, never airborne motor power. Continuing PWM can still keep the cargo switch active after a Pi/script failure, so FC-owned release timeout enforcement remains required. No flight software was implemented here.

## What is next

Finish H01–H12 detailed engineering, especially the battery attachment, complete touch-safe bus enclosure, structural mast/gear joints and cargo latch/seat tolerance stack. Resolve source/supplier evidence before calling an item a physical-test hold. Reconcile final material, connector, wire, fastener, carrier, mast and purchased-cable quantities with cost, CG and the propulsion/energy model. Then independently review the complete package for fabrication release; obtain explicit procurement authorization before ordering anything.

After authorized assembly, conduct the named staged bench/flight tests and collect evidence. Missing real measurements stay **pending physical validation**. A failed requirement triggers only the necessary affected redesign and retest; neither Q74 nor recipient/owner authorization may be waived to make the baseline pass. The eight PC implementation tickets remain separate.

No new user decision is required to acknowledge these engineering holds. They are unfinished implementation-design work, not a reason to reopen settled requirements or mark issue10 unresolved.
