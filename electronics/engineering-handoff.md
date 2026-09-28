# Issue 11 electrical engineering handoff

**Superseded for current-product requirements — September 10 product reset.** The [current requirements](../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#current-checkpoint) reopen architecture, remove cargo and require ten useful minutes excluding takeoff/landing. This document and its linked configuration files preserve earlier design evidence, not current component mandates or revised acceptance. Historical pass/fail results remain unchanged for their original inputs. Reconcile retained interfaces and validation principles against the new configuration before reuse.

**September10 R2 continuation:** the [selected local corrections, native carrier layouts and verification](../docs/hardware/engineering-r2-2026-09-10/electrical-selection.md) now govern the affected electrical interfaces. E1 below remains the preserved logical reference; carrier design does not release the full harness. The [integrated decision report](../docs/prepurchase-decision-2026-09-10.md) supersedes older mass/energy conclusions. The retired PC product has no current engineering dependency.

Status: **E1 logical circuit with September 6 UTC evidence continuation delivered; Issue 11 remains claimed and incomplete. No fabrication, procurement or power release.**
Local date: 2026-09-05 (UTC work continues September 6).

## Product-authority reconciliation — September 10

The [phone/onboard v1 contract](../docs/phone-drone/interaction-contract.md) supersedes the face-plus-voice all-arming policy. The firmware and safety inputs now distinguish paired-device launch, onboard face/liveness command sessions and independent manual radio authority. The [review record](authority-reconciliation-review.json) confirms that this changes no selected electrical part, net, pin, rail, connector, harness record or native KiCad source. `source-manifest.json` carries the new input hashes. Logical-circuit evidence remains scoped to connectivity; the revised software authority still requires implementation and simulated/bench validation.

## Latest continuation — September 6 UTC

- Coordinated with both existing tasks. Mechanical continues conservative design without TBS correspondence, using its 45 mm partial study and RF-GATE-01. PC Ticket 02 has no new aircraft interface requirements and remains independent. Earlier mechanical review-stop statements are superseded.
- E01 resistor documentation is now reconciled by the shared owner. E05 nominal fan-tail documentation is corrected to 80 mm; route/termination/extension and voltage tolerance remain held. Electrical reviewed the source changes and added three regression mutations that detect those documentation errors.
- Added the [component evidence review](component-evidence-review.md): exact fuse timing and regulator protection limitations, partial scanner demand, generic RCY rating boundary, eight I2C scenarios, conditional TFmini voltage-drop limits and seven independent-rail acceptance cases. No unsupported maximum current or final wire route was selected.
- E10 identifies missing regulator/output-fault protection evidence. E11 prevents applying JST component ratings to a Generic AWG20 cable assembly by connector-family name. These are specific release holds, not proven physical failures.
- Validation passes: 147 independent circuit expectations, seven circuit/value fault mutations and three shared-record regression mutations. Twelve source inputs match. [Source drift review](continuation-source-review.json) proves all eighteen native source files are byte-for-byte unchanged, so the prior zero-violation native ERC and reviewed PDF remain applicable. The updated power calculator passes its published TI example, infeasible-case and invalid-input checks.

Exact files changed in this continuation: `electronics/{README.md,build_schematic.py,validate_electrical.py,power_checks.py,power-calculations.json,source-manifest.json,validation-report.json,power-and-integration.md,engineering-handoff.md,pinouts/sources.md}`. New files: `electronics/component-evidence-review.md` and `electronics/continuation-source-review.json`. Regenerated native/circuit registers retain identical content. Shared baseline corrections were made by the mechanical/shared owner, not this task. All work remains uncommitted.


## Ownership and source boundary

The user assigned the Electrical agent task (`01a0740c-c749-7553-9c08-d24440327afe`) the `electronics/**` workstream. The active task `Continue planning and finished PC webapp` (`01a052df-570d-7822-87d7-7a4bc047edf2`) owns Fusion/CAD and shared Issue11/baseline records. A coordination message reserves these paths and requests interface updates. PC Ticket02 and all PC code/tests remain outside this workstream. No shared baseline file is edited by this task. The shared owner made the coordinated E01/E05 corrections described above.

Authority: latest Issue11 comments, Q75/R1.1, electrical-build.md and harness-netlist.csv. The latest CAD progress supersedes older architecture-stage claims that no Fusion master exists. Its current FLU axes and unresolved frame stack prohibit adopting historical routing coordinates as installed facts.

Source checkout: main at `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`, with extensive pre-existing uncommitted files and skill changes. That commit does not contain the engineering baseline. [Source manifest](source-manifest.json) identifies twelve actual input hashes and eighteen native source hashes. Existing research worktrees are preserved. All electrical changes remain uncommitted.

## Integration findings requiring shared-owner action

- **E01 — corrected switch pull-up documentation:** R1.1 and the shared pin table/firmware manifests now agree on 4.7 kΩ, retaining 330 Ω series and 100 nF filters. The shared owner corrected the prose on September 6 UTC; no circuit change or physical validation is inferred.
- **E02 — net names are not all equipotential nodes:** carrier records include resistors/capacitors, W030 and W100–103/W106 are multi-conductor factory interfaces, and NC records group terminals. Blindly connecting every CSV `net` would short signal inputs/rails. C009 crosses R5, so its receiving side needs a distinct LED_DIN net. A typed reconciliation is required.
- **E03 — placement-dependent entries:** W101/W102 and electrical-build contain old scanner placement/route coordinates. They remain historical cut/route allocations, not installed coordinates. Mechanical owns updated locations, routes, lead exits and strain relief.

## Mechanical dependencies

- Confirm frame revision/stack, board datums, service/airflow volumes and connector-facing evidence before any physical pin-layout or harness release.
- Supply route centre-lines, maximum travel sweeps, cable OD/bend data and service/strain allowances for each W record. No exact installed lengths are established here.
- HAT assembly needs insulated peripheral-5V wiring separated from Pi-5V copper, direct split-power joints, U1/passive heights and clamp access. Carrier copper bridges require inspection.
- Cargo switches must be aircraft-mounted with positive holder-seated AND lid-closed actuation, plus a separate bolt-through-strike condition. Wiring cannot establish those mechanical predicates.

## Software dependencies

- Existing PC Ticket02 has no aircraft electrical interface and blocks none of this logical wiring work. Do not request PC enrollment code changes for electrical progress.
- Future onboard/FC work owns paired-radio and one-use paired-phone launch enforcement, onboard face/liveness command sessions and independent in-flight manual landing; stock ArduPilot does not implement the [v1 authority contract](../docs/phone-drone/interaction-contract.md).
- FC owns exclusive M7 release output, bounded coil energization and timeout-to-OFF even with stale companion output. Exact maximum pulse/lease and servo endpoints remain unresolved.
- Pi owns GPIO18 exclusive waveform use, UART0/no serial console, switch debounce/plausibility and persistent scanner identity. These are future hardware-software contracts, not completed PC features.

## Completed

- Implemented the six planned schematic groups as a native KiCad 10 project: one root plus fourteen child sheets, 48 module/discrete components and 192 exported terminal nodes. The XML export has 66 nets including intentionally unconnected terminals. Three additional ERC source flags are annotations, not hardware.
- Defined battery/shunt/bus distribution, separate regulator rails, returns, FC/Pi UART, GNSS/range/receiver interfaces, I2C, four motor phase groups, PWM translation, lamps, IR supply, cargo switches and switched solenoid return. Ground-only charge equipment has distinct nets.
- Reconciled all 135 harness IDs: 104 wires/carrier links, 13 passive-component records, one expanded three-conductor LED chain, five explicitly held factory interfaces and 12 intentional-isolation records. Preserved the source cut/gauge/route allocations without representing them as installed measurements.
- Added manufacturer-source and terminal evidence, inventory cross-references, reproducible power calculations, an independent exported-netlist checker, native ERC evidence and a plotted 15-page review PDF.
- Recorded discrepancies E01–E09 in the [power and integration review](power-and-integration.md). These are findings attached to Issue 11, not a replacement issue tracker.

## Exact files created or modified

Paths below are repository-relative. No files outside `electronics/**` were changed by this electrical task. Existing `sheet-plan.csv`, fabrication stubs and export ignore policy were preserved.

Modified existing documentation:

```text
electronics/README.md
electronics/harness/README.md
electronics/schematics/bgd-master/README.md
```

Created engineering sources, registers and reports:

```text
electronics/.gitignore
electronics/build_schematic.py
electronics/validate_electrical.py
electronics/power_checks.py
electronics/source-manifest.json
electronics/validation-report.json
electronics/power-calculations.json
electronics/power-and-integration.md
electronics/engineering-handoff.md
electronics/harness/reconciliation.csv
electronics/pinouts/schematic-pins.csv
electronics/pinouts/sources.md
```

Created native KiCad sources:

```text
electronics/schematics/bgd-master/bgd-master.kicad_pro
electronics/schematics/bgd-master/bgd-master.kicad_sch
electronics/schematics/bgd-master/bgd.kicad_sym
electronics/schematics/bgd-master/sym-lib-table
electronics/schematics/bgd-master/10-1.kicad_sch
electronics/schematics/bgd-master/10-2.kicad_sch
electronics/schematics/bgd-master/20-1.kicad_sch
electronics/schematics/bgd-master/20-2.kicad_sch
electronics/schematics/bgd-master/30-1.kicad_sch
electronics/schematics/bgd-master/30-2.kicad_sch
electronics/schematics/bgd-master/40-1.kicad_sch
electronics/schematics/bgd-master/40-2.kicad_sch
electronics/schematics/bgd-master/40-3.kicad_sch
electronics/schematics/bgd-master/50-1.kicad_sch
electronics/schematics/bgd-master/50-2.kicad_sch
electronics/schematics/bgd-master/50-3.kicad_sch
electronics/schematics/bgd-master/50-4.kicad_sch
electronics/schematics/bgd-master/60-1.kicad_sch
```

Generated local ignored deliverables: `electronics/exports/bgd-master.pdf`, `electronics/exports/bgd-master.net.xml`, and `electronics/exports/erc.json`. Review intermediates also remain in that ignored directory: `erc-initial.json`, `page2.png`, `page11.png`, `review-01.png` through `review-15.png`, `contact-1.png`, `contact-2.png`, and `final-15.png`. KiCad's local `bgd-master.kicad_prl` is ignored application state. These ignored files are available in this checkout; they are not saved by a future ordinary Git commit. The source project and reproduction commands recreate the principal exports.

## Validated

- KiCad CLI **10.0.6** opened/exported the native hierarchy successfully. Final native ERC with all enabled severities: **zero violations**. Initial missing-source findings behind the shunt/input fuses were corrected with three explicit upstream-source flags, not exclusions.
- [Independent validation report](validation-report.json): all 192 exported pins match the declaration; 147 independently specified node expectations pass; all 135 harness IDs are accounted for; inventory IDs resolve; the 43-row pin allocation is accounted for, with 13 explicit FC pad/MCU mappings checked. Timer groups and the two allocated external I2C addresses match the baseline.
- Seven intentional fault mutations were rejected: supply bridge, coil return tied to ground, swapped release PWM, bypassed LED resistor, bypassed input fuse, missing Pi ground and incorrect switch pull-up value. These exercise the checker against hazardous changes; they are not hardware fault tests.
- Twelve input hashes and eighteen native source hashes match the continued reviewed snapshot. The validation report records raw XML/ERC output hashes. Run validation before regenerating when checking for later upstream changes.
- `power_checks.py` reproduces the labeled partial rail, coil, shunt-loss and switch-filter calculations. No complete power or endurance budget passes merely because the arithmetic passes.
- All fifteen PDF pages were rendered and visually reviewed; detailed checks covered battery, U1 and the final corrected charge-equipment page. Text/title overlaps and an initially incorrect charger graphic were corrected before final delivery.
- No custom ERC suppressions were added. KiCad defaults leave single-global-label, four-way-junction, simulation-model and footprint-filter checks disabled; the report lists them. No SPICE simulation, PCB DRC, footprint-fit, thermal, protection, EMC or physical qualification is claimed.

Reproduction commands and generator ownership are in the [native project README](schematics/bgd-master/README.md). Regeneration rewrites the generated native files; preserve/reconcile manual KiCad edits first.

## Decisions established from evidence

- Retain Q75/R1.1 hardware selections and separate compute, peripheral, AIO and IR positive rails. All flight loads remain downstream of the positive shunt; common negative bypasses it. F1/F2 remain input-branch fuses.
- Use physical Pi header numbers and the TI PDIP14 pin map where documented. For modules, use named functional terminals; do not invent cavity numbers, footprints or mating-face views.
- Follow the controlling 4.7 kΩ switch resistor schedule, with 330 Ω series resistors and 100 nF filters. E01 shared-document reconciliation is complete; the circuit itself is unchanged.
- Keep all four U1 output enables grounded and the four input pull-downs. Split the two sides of LED resistor R5 into distinct nets. Treat W030 as a three-conductor chain, not one equipotential signal.
- Preserve the Pololu driver's open optional power bridges and switched LOAD LOW return. NC terminals stay isolated. The release path is exclusively FC M7, subject to the unfinished control contract.
- Keep W100/W101/W102/W103/W106 at explicit factory-interface boundaries. Their internal pin mapping is not validated by the scalar circuit checker.

## Provisional items

- This is a whole-module logical wiring draft. Physical symbol orientation, connector cavity order, carrier construction, footprint assignment and harness drawings are unreleased.
- Compute 3.2 A is a supply-capacity allocation including the nominal fan, not measured consumption. The AIO 0.401 A subtotal omits unresolved receiver/Finder demand. The two-lamp 1.6 A calculation is an investigation scenario, not a maximum rating; servo coincidence remains unknown.
- Fan operation at the inherited 5.2 V connection is conditional on obtaining its permitted voltage range. The manufacturer page establishes nominal 5 V only; neither compatibility nor incompatibility is proven.
- Three source flags state intended connectivity only. They do not establish regulator startup, fuse clearing, backfeed protection, wire ampacity or return-fault tolerance.

## Other blockers

- **Electrical/component evidence:** lamp maximum current and thermal conditions (the linked specification PDF returned 404); exact supplied servo variant and stall/inrush currents; fan voltage tolerance; RP1/Finder peak demand; scanner USB startup demand; IR module current curves.
- **Protection and signal evidence:** regulator fault/thermal behavior, input-fuse time-current coordination, connector contact ratings/drawings, rail tolerances and transients, unpowered-pin leakage, I2C pull-up voltage/resistance and bus timing for exact module revisions.
- **Received-part/physical qualification:** polarity and balance-pin order, optional-bridge inspection, joint/return resistance, load transients, cooling, insulation, vibration and cargo-release duty. No physical operations were performed or authorized by this task.
- **Mechanical current checkpoint:** the 2 mm drawing versus 2.5 mm product-page conflict remains unresolved, but current authorization permits conservative digital design without TBS correspondence. The 48 mm outline fails the newer declared clearance envelope; a 45 mm study meets only the conditional planar bound. Fastener/service routes remain unfinished and RF-GATE-01 applies before fabrication.

## Recommended next electrical work

Immediately available digital work:

1. Shared owner has linked E1 and reconciled E01/E05. Append the latest continuation findings E10/E11 to Issue 11 while retaining claimed/incomplete status.
2. Obtain missing component evidence for E04/E06/E07 and exact servo identity. Prepare supplier questions where public documentation is insufficient; external messages require separate authorization.
3. Extend the load/protection ledger only when new evidence supplies valid peaks, tolerances or curves. Update generator, source register and independent checks together for any supported circuit change.

Work that must wait:

1. Physical harness drawings, cut lengths, connector facing and strain relief await confirmed mechanical datums/routes, travel envelopes and exact terminal evidence.
2. Final release behavior awaits future FC/onboard timing, startup and fault contracts plus solenoid duty evidence. **PC Ticket 02 does not block this electrical work and requires no change.**
3. Any release, manufacturing package or power qualification awaits the listed physical acceptance evidence. Q74 now requires 11 useful minutes plus unchanged independent reserve under the September 10 owner amendment; this package does not establish that result.

## Integration warnings for the other owners

- **Shared baseline:** E01 is resolved to 4.7 kΩ in circuit and prose. Retain the separate U1 10 kΩ pull-downs; they were never part of the conflict.
- **Mechanical/harness:** W060/W061 now record the maker's nominal **80 mm** supplied fan leads. This is not usable routed reach; retain termination/extension holds and do not credit a mass saving. Do not propagate old D500 coordinates into the current FLU frame.
- **Power/software:** the old combined lamp “up to 1 A” claim is unsupported. Do not treat a minimum supply recommendation as maximum demand or silently reduce required illumination to make the budget fit.
- **Future FC/onboard:** continuing valid ON PWM can defeat pulse-loss shutdown. Establish bounded coil energization and supervisor expiry independently of companion behavior; a static logical schematic cannot supply that safeguard.
- **All owners:** shared GND connectivity does not replace the dedicated return conductors. ERC success does not release the design. Shared hardware records, Fusion/CAD and PC code/tests were left untouched; no purchases, physical operations, firmware uploads or Git publication occurred.
