# R1.1 support-detail impact — 2026-09-03

**The historical1,897.251g and$2,052.93 figures are not final totals for this artifact package.** Required support details are now more explicit and expose allocation overruns. The architecture remains conditionally frozen; this file does not launch another optimization or reduce any requirement/contingency.

## Known price changes

| Change against the Q75 planning basket | USD change | Scope |
|---|---:|---|
| Remove incompatible QS8-S two-pack series adapter | −8.00 | Cannot serve the one-pack topology unchanged |
| Add one genuine bare QS8 male for aircraft | +2.35 | In addition to the separate ground charging connector; existing8AWG wire and Hakko process |
| Pololu2180 +2181 mating holder power leads | +5.90 | Required1.1A solenoid disconnect support |
| StarTech UUSBHAUB50CM500mm D500 USB cable | **Unquoted USD** | Genuine routing correction; supplied200mm cable stays ground spare |
| Revised wire/passive/connector/fastener/fabrication quantities | **Unquoted difference** | Reconcile against existing$270 support allowance; do not charge twice or assume allowance sufficient |

Known named subtotal becomes `$1,375.84−8+2.35+5.90=$1,376.09`, **plus the unquoted USB cable**. This is a partial subtotal, not a newly complete project price. The prior$270 completion/$75delivery/10%illustrative tax/$100rework/$60conditional compliance scenario remains historical until item-by-item reconciliation and quotations. No shipping/tax or unquoted item is assigned zero, and no fixed budget maximum is reinstated. Sources for exact correction, connector offer and cable are in [electrical-build](electrical-build.md).

## Mass calculation boundary

The [cut list](cut-list.csv) sums to **175.653g** of defined study blanks at the stated density assumptions. This includes40.186g cargo shell and27.530g copper bars; it excludes numerous necessary joints, stems, fasteners, guards, adhesives and electronic carrier parts. It is neither all airborne support nor a validated holder mass. Do not add all175.653g to the old aircraft total: several existing allowances already cover these parts.

At the netlist's maximum cut allocations, ideal solid-copper wire mass uses:

`diameter_mm=0.127×92^((36−AWG)/39)`; `mass_g=π/4×diameter_mm²×length_mm×0.00896`.

This is a nominal conductor-area calculation. Real stranded/tinned conductor, insulation, connector, solder and offcut masses differ. No per-metre insulation mass is invented. The calculation is reproducible from [the netlist](harness-netlist.csv) and dimensions; shortened final routes must be explicitly re-counted.

| Allocation | Identified partial content | Estimated g | Consequence |
|---|---|---:|---|
| Old70g main-path allocation |8AWG300mm +10AWG160mm nominal copper |30.029| Insulation and connector housing excluded |
| Same | M02 carrier +M03 top cover +twoM04 rails |39.591| Side guards, clamps and mounting excluded |
| Same | INA monitor |4.000| Existing nominal manufacturer mass |
| **Main partial subtotal** | Above only |**73.620**| Already3.620g over70g before cap, QS8 housing, solder, insulation and full guarding |
| Old100g shared support allocation | M05/M06/M12/M13/M14/M15/M16 studies |74.126| No mast stems, slider joints, braces, strap masses or permanent holder rail |
| Same | Named500mm USB cable |21.000| Replaces supplied200mm cable; no duplicate kit cable aboard |
| Same | Other cut18/22/24AWG copper:1.2/2.5/5.0m |25.313| Factory leads and all insulation excluded; does not count motor factory leads twice |
| **Shared partial subtotal** | Above only |**120.439**| Already20.439g over100g before many required support parts |
| Old11.2g local Pi guard allowance | M07/M08/M09 |7.525| Only3.675g remains for local fasteners/leads; HAT/carrier/aircraft mounting cannot disappear |
| Old170g removable holder allowance | M17/M18/M19 shell sheets |40.186| Hinge/latch/solenoid/switch actuation/strike/joints/connector not yet complete; no capacity proof |

The same-scope planning arithmetic, without reclaiming any other allowance or spending50g contingency, is therefore **at least1,921.310g on this partial allocation accounting**: `1,897.251+3.620+20.439`. This is **not a physical lower bound on an as-built aircraft**: several input masses remain conservative allowances and unneeded wire length can be trimmed. It is an explicit warning that the current detailed design cannot claim the old assembly mass. The complete ledger and CG moments remain an H03/H06/H08/H09/H10/H12 release dependency.

## Q74 consequence

The prior20.98min central and18.20min moderate figures remain reference calculations for their stated1,897.251g configuration and assumptions. They are not recomputed predictions for a heavier, incompletely dimensioned installation. Extra structure, HAT/passives, wire insulation, USB cable and changed airflow must enter a complete ledger before running the coupled propulsion/sag model again.

The approved energy contract is unchanged. Under the old provisional148Wh usable energy and4Wh pre-reference allowance, with reserve `max(20Wh,0.05×mission_W)`, twenty useful minutes requires `mission_W≤372W`. The old354.54W central prediction has only17.46W headroom, and the moderate case already misses Q74. The newly exposed support overrun therefore matters; no endurance margin may be manufactured by deleting features, spending protected reserve or quietly dropping contingency.

Physical acceptance remains the exact Q74 workload/repetitions and independent reserve validation. Before that, finish the engineering ledger and model; those are answerable engineering tasks, not physical validation. No replacement battery, motor, frame or propulsion system is selected by this accounting note.
