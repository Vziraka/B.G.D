# BGD master KiCad project — E1 logical draft

Open `bgd-master.kicad_pro` in KiCad10. The root and14 child sheets implement the six planned groups, splitting dense groups into readable pages. The symbols describe documented module terminals; they do not assign unknown connector cavity numbers or physical board layouts. No footprints or PCB are released. Use:

`C:/Users/zvent/AppData/Local/Programs/KiCad/10.0/bin/kicad-cli.exe`

The [sheet plan](sheet-plan.csv) remains unchanged and defines review boundaries. [Reconciliation](../../harness/reconciliation.csv) types all135 source records:104 wires/carrier links,13 passive components, one expanded3-wire LED chain, five factory-interface holds and12 intentional-isolation declarations. A schematic line is connectivity evidence, not voltage/current/thermal qualification. Physical terminals and whole cables deliberately stop at the evidence boundary.

## Reproduce and inspect

From the repository root in PowerShell:

```powershell
python electronics/build_schematic.py
& 'C:/Users/zvent/AppData/Local/Programs/KiCad/10.0/bin/kicad-cli.exe' sch erc electronics/schematics/bgd-master/bgd-master.kicad_sch -o electronics/exports/erc.json --format json --severity-all --exit-code-violations
& 'C:/Users/zvent/AppData/Local/Programs/KiCad/10.0/bin/kicad-cli.exe' sch export netlist electronics/schematics/bgd-master/bgd-master.kicad_sch --format kicadxml -o electronics/exports/bgd-master.net.xml
python electronics/validate_electrical.py
python electronics/power_checks.py
& 'C:/Users/zvent/AppData/Local/Programs/KiCad/10.0/bin/kicad-cli.exe' sch export pdf electronics/schematics/bgd-master/bgd-master.kicad_sch -o electronics/exports/bgd-master.pdf
```

The fixed generator is the reproducible authoring source for E1; update it alongside reviewed native changes before regenerating, since regeneration rewrites the listed schematic/library files. Its source manifest records actual uncommitted input and native source hashes. Run validation **before** regeneration when checking for upstream drift. `validate_electrical.py` checks the exported circuit without importing the generator, including147 independent node expectations and seven fault mutations.

NativeERC initially identified three power inputs behind passive shunt/fuses without power-output markers. Three `#FLG` assertions now declare their documented upstream sources; they add no hardware, create no BOM item and waive no fault/thermal gate. Independent checks retain the shunt/fuse boundaries. No ERC violation is excluded by this project. KiCad's default-disabled checks are enumerated in the validation report; no SPICE or footprint compatibility claim is made.

Functional module numeric fields use the source terminal names for nonnumbered pads; Pi uses physicalJ8 numbers and U1 uses realPDIP14 pins. Motor phase letters are harness commissioning labels, not manufacturer pad-view facts. CMAIN in the harness is referenceCM1 in KiCad. C4 terminal1 is positive; terminal2 is negative. E1 is a whole-module wiring design, not a fabricated circuit-board netlist.

## Required net families

High current: `PACK_POS`, `BUS_POS`, `GND`, `AIO_VBAT`. Power rails: `AIO_5V`, `AIO_12V`, `COMPUTE_5V2`, `PERIPHERAL_5V`, `IR_3V3`, `PI_3V3_LOGIC`. Interfaces: `FC_PI_UART`, `GNSS_UART`, `FC_I2C1`, `TFMINI_UART`, `CRSF`, `PAN_PWM`, `TILT_PWM`, `RELEASE_PWM`, `LED_DATA`, `HOLDER_CLOSED`, `LATCH_ENGAGED`, `D500_USB`, `CAMERA_CSI`.

Regulator outputs remain separate even though returns share `GND`. No power-output symbol or label may imply paralleling. USB/CSI, motor phases and antenna/coax are represented as connector/harness interfaces even where KiCad does not simulate them.

## Verification path

1. Exact symbols/connector views from authoritative data.
2. Hierarchical sheet/net-label review.
3. Electrical Rules Check with documented justified exclusions only.
4. Exported netlist compared with the wire-level harness/pin allocation.
5. Current/voltage/gauge/protection review; KiCad ERC alone cannot do this.
6. Cross-probe every electrical component to its Fusion component and route volume.
