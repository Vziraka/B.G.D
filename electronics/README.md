# B.G.D electrical engineering workspace

Status: **E1 native KiCad logical draft with release holds**. Open [bgd-master.kicad_pro](schematics/bgd-master/bgd-master.kicad_pro). The15-sheet hierarchy contains48 component/module symbols and192 terminal nodes; [validation](validation-report.json) records nativeERC and independent exported-netlist checks. No PCB, physical connector layout, released harness or powered qualification exists.

- `schematics/bgd-master/`: planned hierarchical source project
- `harness/`: KiCad-to-wire-level reconciliation and future harness drawings
- `pinouts/`: reviewed component connector/pin evidence
- `fabrication/`: future released carrier/PCB outputs only
- `exports/`: generated plots/netlists/BOM/ERC reports, ignored by default

E1 reconciles the [135-record harness](../docs/hardware/baseline-r1/harness-netlist.csv) and [43-row pin allocation](../docs/hardware/baseline-r1/pin-allocation.csv) at the stated logical boundary. The shared baseline remains controlling for physical details. The September 6 continuation incorporates the shared owner's E01 resistor-prose correction and E05 nominal fan-tail correction; physical fan reach and voltage remain held. The five held factory interfaces do not gain internal pin coverage from ERC. Q75/R1.1 is unchanged.

The [component evidence continuation](component-evidence-review.md) adds fuse/regulator protection analysis, a partial scanner load, conditional voltage-drop and I2C calculations, and E10/E11 protection/connector evidence holds. It also records current coordination with the mechanical and PC owners. The logical circuit is unchanged.

Read the [engineering handoff](engineering-handoff.md), [power/integration review](power-and-integration.md), [source register](pinouts/sources.md) and [reproduction instructions](schematics/bgd-master/README.md). Plotted [schematic PDF](exports/bgd-master.pdf), nativeERC JSON and XML netlist are local ignored outputs; source/hash records are visible toGit but remain uncommitted. No purchase, physical operation, firmware upload or PC change occurred.
