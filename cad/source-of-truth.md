# Engineering sources of truth

## Authority order

1. Approved project requirements and the issue10/Q75 record define required behavior, capability, safety and acceptance. Q74's 20 useful minutes plus independent reserve cannot be relaxed by CAD or convenience.
2. Q75 plus the narrowly authorized R1.1 interface corrections define the conditional hardware baseline. Missing CAD is never permission to substitute a component.
3. The inspected Fusion master assembly will become the mechanical and physical-integration source of truth: installed position, orientation, mounting, motion, keep-outs, routing volumes, preliminary mass properties and custom part geometry.
4. KiCad source schematics will become the electrical connectivity source of truth. The reviewed harness CSV remains the wire-level cut/termination source until it is generated from or reconciled with KiCad. Any disagreement is a release blocker.
5. This repository is the engineering record for scripts, source metadata, interchange models, drawings, KiCad sources, harness definitions, pinouts, manifests and reviews. The [first local native snapshot](assemblies/reference-r1-manifest.json) is a partial reference/adapter study, not a released aircraft. The September 9 user-authorized Git checkpoint preserves the named reference-r1 and AIO R3 native snapshots/previews and the reviewed electrical netlist, PDF and ERC result through exact export ignore exceptions. Other generated exports remain ignored. A local commit does not establish remote backup or engineering release.

## Evidence and change rules

- Prefer manufacturer STEP/STP. A manufacturer DXF or dimensioned drawing may support a derived model when its limits are recorded.
- Community CAD is reference-only until every important interface dimension is checked against authoritative evidence. Appearance is not evidence.
- A simplified envelope preserves overall dimensions, mounting holes, connector location, service/bend space, keep-outs, moving volume, mass and orientation to the extent evidence permits. Unknown values remain explicit.
- Every model directory carries source URL, immutable revision/hash when available, retrieval date, units, transformation history, confidence and known omissions.
- Generated/exported artifacts carry source path/revision and generation time in a sibling manifest. Cache, autosave and temporary files are ignored.
- Fusion fit can support `VERIFIED DIGITALLY` only for the modeled static geometry and stated tolerances. It cannot prove stiffness, vibration, thermal behavior, connector seating, dynamic blade flex, endurance, flight control or workmanship.
- A received-part discrepancy, genuine interface incompatibility or failed requirement reopens only the affected subsystem. Approved behavior remains fixed and cost is minimized within it.
- No fabrication file is released until its source model, dimensioned drawing, material, manufacturing method and validation gates pass review.

## Required release reconciliation

Mechanical and electrical release baselines identify exact Fusion archive/export revision, KiCad project revision, component-inventory revision, harness/netlist revision, firmware manifest and digital-gate evidence. A green CAD collision check does not upgrade a bench/flight gate.
