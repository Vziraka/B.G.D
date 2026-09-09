# Assembly-manual artifact path

No assembly procedure is authored before designs exist. Each released assembly component will eventually contribute one row with:

| Required field | Source |
|---|---|
| Component and exact revision | Component inventory/source manifest |
| Installed location/orientation | Inspected Fusion master assembly |
| Fasteners and stack order | Released Fusion model and dimensioned drawing |
| Electrical connection | KiCad schematic plus reconciled harness/pinout |
| CAD view/drawing | Traceable Fusion/KiCad export manifest |
| Workmanship/torque | Manufacturer-authoritative requirement or explicit engineering release; never generic guess |
| Check before proceeding | Digital/received-part/bench gate with objective evidence |
| Associated validation gate | `digital-validation-gates.csv` and existing acceptance register |

The future guide follows dependency order: inspect parts, frame/propulsion, power distribution, FC/radio/navigation, compute/sensors/camera, guards/landing structure, optional cargo module, wiring/inspection, unpowered checks, controlled bench commissioning and only then approved flight gates. This is a document topology, not permission or step-by-step assembly instructions.
