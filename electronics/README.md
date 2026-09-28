# B.G.D electrical engineering workspace

**Superseded for current-product requirements — September 10 product reset.** The [current requirements](../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#current-checkpoint) reopen architecture, remove cargo and require ten useful minutes excluding takeoff/landing. This document and its linked configuration files preserve earlier design evidence, not current component mandates or revised acceptance. Historical pass/fail results remain unchanged for their original inputs. Reconcile retained interfaces and validation principles against the new configuration before reuse.

**September10 R2 amendment:** the [current electrical corrections and native carrier evidence](../docs/hardware/engineering-r2-2026-09-10/electrical-selection.md) supersede the named fan/sensor/protection/connector/bus selections below. E1 remains the preserved logical reference; R2 carrier boards are draft and do not release the whole harness or qualify fault behavior. The [integrated report](../docs/prepurchase-decision-2026-09-10.md) controls current mass/energy and architecture holds. Historical PC coordination is not active product scope.

Status: **E1 native KiCad logical draft with release holds**. Open [bgd-master.kicad_pro](schematics/bgd-master/bgd-master.kicad_pro). The15-sheet hierarchy contains48 component/module symbols and192 terminal nodes; [validation](validation-report.json) records nativeERC and independent exported-netlist checks. No PCB, physical connector layout, released harness or powered qualification exists.

- `schematics/bgd-master/`: planned hierarchical source project
- `harness/`: KiCad-to-wire-level reconciliation and future harness drawings
- `pinouts/`: reviewed component connector/pin evidence
- `fabrication/`: future released carrier/PCB outputs only
- `exports/`: generated plots/netlists/BOM/ERC reports, ignored by default

E1 reconciles the [135-record harness](../docs/hardware/baseline-r1/harness-netlist.csv) and [43-row pin allocation](../docs/hardware/baseline-r1/pin-allocation.csv) at the stated logical boundary. The shared baseline remains controlling for physical details. The September 6 continuation incorporates the shared owner's E01 resistor-prose correction and E05 nominal fan-tail correction; physical fan reach and voltage remain held. The five held factory interfaces do not gain internal pin coverage from ERC. Q75/R1.1 is unchanged.

The [component evidence continuation](component-evidence-review.md) adds fuse/regulator protection analysis, a partial scanner load, conditional voltage-drop and I2C calculations, and E10/E11 protection/connector evidence holds. It also records current coordination with the mechanical and PC owners. The logical circuit is unchanged.

Read the [engineering handoff](engineering-handoff.md), [power/integration review](power-and-integration.md), [source register](pinouts/sources.md) and [reproduction instructions](schematics/bgd-master/README.md). Plotted [schematic PDF](exports/bgd-master.pdf), nativeERC JSON and XML netlist are local ignored outputs; source/hash records are visible toGit but remain uncommitted. No purchase, physical operation, firmware upload or PC change occurred.
