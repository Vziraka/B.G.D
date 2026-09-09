# B.G.D mechanical engineering workspace

Status: **robust-design studies continue without TBS correspondence; no fabrication release**. The [current AIO robustness review](robust-aio-review.md) supersedes the earlier correspondence/review stop. The48mm outline fails the chosen clearance budget; a45mm study passes only the planar bound, with full-mount design still incomplete. The [received-frame inspection gate](received-frame-inspection-gate.md) controls dimension-sensitive release. Original [master evidence](engineering-progress-2026-09-05.md) and [snapshot](assemblies/reference-r1-manifest.json) remain historical, unchanged. Q75/Q74 remain controlling.

- [Engineering authority and artifact rules](source-of-truth.md)
- [Local tool inventory](environment.md)
- [Physical-component acquisition inventory](component-inventory.csv)
- [Master assembly architecture and coordinate system](assemblies/master-assembly.md)
- [Custom CAD backlog](custom-fabrication-backlog.csv)
- [Digital validation map](digital-validation-gates.csv)
- [Authoritative Source One reference](reference/source-one-v6-7in/README.md)
- `components/`: one directory per acquired or derived component model, with source metadata beside geometry
- `fabrication/`: released custom source models; currently empty by design
- `drawings/`: source-controlled dimensioned drawings; no generated cache
- `scripts/`: repository-managed CAD acquisition/validation/Fusion scripts
- `exports/`: generated interchange and preview output; ignored except its policy file

The earlier studies under [`docs/hardware/baseline-r1`](../docs/hardware/baseline-r1/README.md) remain inputs and evidence, not Fusion source models. Nothing in this workspace authorizes purchase, fabrication or physical operation. Q75 controls the conditional architecture; Q74 remains mandatory.
