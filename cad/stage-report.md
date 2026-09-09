# Digital engineering architecture-stage report — updated 2026-09-05

## Outcome and boundary

Created a version-control-ready `cad/` and `electronics/` workspace without touching PC biometric source, tests, specs or tickets. Q75 remains the conditional hardware baseline and Q74 remains mandatory. No software installation, purchase, fabrication, physical assembly, Fusion document, KiCad schematic or detailed custom geometry was created.

## Tooling status and demonstrated integration

- Autodesk Fusion 2704.1.53 is installed per-user at the recorded webdeploy path. Its CPython 3.14 interpreter runs from shell, but `adsk` does not import outside Fusion. Script/AddIns folders exist and are empty. Codex can author/version/deployable scripts and inspect exports; direct Fusion GUI/API/document control is **not demonstrated**.
- KiCad 10.0.6 build 50883 is installed per-user. `kicad-cli.exe version` runs successfully by full path; it is not on `PATH`. Codex can create/read KiCad source and later run CLI ERC/export commands. GUI control and any opened project are **not demonstrated**.
- System Python 3.13.12 is available, and a separate uv Python 3.11.14 was located. Standard Python is sufficient for manifests/hash/neutral-file checks. Nothing new was installed.

Full paths and evidence are in [environment.md](environment.md).

## Repository and authority structure

- [Source-of-truth rules](source-of-truth.md) set requirements/Q75 above mechanical/electrical implementations, Fusion as the future inspected mechanical authority, and KiCad as the future schematic authority.
- [Acquisition policy](acquisition-policy.md) defines the five requested model classes and confidence rules.
- `cad/components`, `assemblies`, `fabrication`, `scripts`, `reference`, `exports`, and `drawings` now have scoped policies.
- `electronics/schematics`, `harness`, `pinouts`, `fabrication`, and `exports` now have scoped policies.
- Local export ignore files exclude generated outputs without modifying the shared root `.gitignore`. Source/readme/CSV/JSON/script files are not ignored and are ready for normal Git review. No commit was made.

## CAD acquisition inventory

[component-inventory.csv](component-inventory.csv) contains 61 physical rows covering the installed/removable aircraft and relevant ground-support boundaries. Each row records exact baseline/scope, quantity, representation class, target model, authoritative evidence, confidence, acquisition state and critical geometry/keep-outs. No convenient-CAD component substitution was made. The 2026-09-05 taxonomy audit moved all self-created manufacturer-dimension-derived models from class 2 to class 4; no class 1 or authoritative third-party class 2 CAD is claimed without an acquired model.

The Source One V6 reference is the only acquired CAD: the manufacturer-owned pinned DXF, 72,083,544 bytes, commit `232ccff173c556d23cc857f0c07a6eaa66ddbc41`, Git blob `4722157f17719f98f91fd8f8c8c960c33fb45bee`, SHA-256 `398556cd5f8720ac1a39b79bd1a0d1c083c6c57def55920bc17b212061b6d099`. Its ignored local cache was rehashed. It contains 2D manufacturing views, not an assembled frame.

## Proposed Fusion master assembly

[master-assembly.md](assemblies/master-assembly.md) defines one `BGD_MASTER` tree spanning frame, propulsion/sweeps, flight/power, compute/imaging, navigation/radio/antenna zones, recipient/cargo, landing/protection and harness routes. Axes are X right, Y forward, Z up; XY origin is the motor-axis centroid. The pinned DXF transform and four relative motor centres are recorded. Physical Z and frame stack remain source/measurement holds.

[fusion-automation.md](fusion-automation.md) selects manually invoked repository-managed scripts only when parameterized regeneration pays for itself. Important dimensions stay named parameters. No always-running add-in, deployment or claim that a master assembly exists.

## Custom fabrication and KiCad architecture

[custom-fabrication-backlog.csv](custom-fabrication-backlog.csv) defines all 13 requested custom items with requirements, dimensions, interfaces, material, mounting, mass, keep-outs, fabrication method, CAD/export/drawing obligations and validation criteria.

The [KiCad hierarchy](../electronics/schematics/bgd-master/README.md) and [six-sheet plan](../electronics/schematics/bgd-master/sheet-plan.csv) cover pack/QS8/INA/C110/AIO/motors, regulated rails/protection, FC I/O, Pi/camera/USB/CSI, translated PWM/lights/cargo and every harness boundary. KiCad must reconcile against the existing 135 harness records and 43 pin allocations. No guessed symbol/footprint or placeholder project was created.

## Digital gate map

[digital-validation-gates.csv](digital-validation-gates.csv) defines 27 checks covering all 33 distinct buildability gates. Every evidence row uses exactly one requested classification: `VERIFIED DIGITALLY`, `STILL REQUIRES RECEIVED-PART MEASUREMENT`, `STILL REQUIRES BENCH VALIDATION`, or `STILL REQUIRES FLIGHT VALIDATION`. All checks are currently `NOT RUN`; the class says what evidence that check can eventually produce or where it must hand off.

Digital work can resolve or reduce static prop clearances, nominal collisions, sourced envelopes, motion/field obstruction, route length/bend feasibility, approximate CG, hole/resource allocation and schematic net mismatches. It cannot prove dynamic flex, actual configured-pack dimensions, workmanship, thermal/current behavior, RF/biometric behavior, endurance or flight control.

## Unresolved blockers

- Fusion cannot yet be controlled or inspected from this shell; the first import must be run and reviewed in Fusion.
- The official frame DXF does not provide an assembled 3D stack or physical Z datum.
- Most selected components still need authoritative CAD/drawing acquisition and confidence review.
- Battery configured dimensions/lead exit, AIO pad geometry, fastener stacks and numerous connectors need received-part evidence where manufacturer data is insufficient.
- Custom H01–H12 mechanical designs, final harness routes, mass/CG/cost reconciliation and the Q74 model remain open.
- No KiCad symbols/schematic exist yet, so ERC/netlist reconciliation has not run.

## Exact recommended first CAD task

**CAD-T01 — Source One V6 authoritative frame import and coordinate validation.** In Fusion, create a new millimetre design and one `FRAME_SOURCE_ONE_V6_7IN` component; import the pinned DXF 1:1; isolate/name the exact 7-inch plate/arm profiles; remove only duplicate manufacturing annotations after preserving the raw reference; apply the documented XY transform; verify all four motor centres and structural/stack holes against the source manifest; record profile/layer choices; leave plate spacing, fasteners and `prop_plane_z` unresolved; save an inspectable Fusion document and a traceable neutral snapshot. Review it visually in Fusion before adding motors or generating custom parts.

## Parallel-work protection

Ticket 2 implementation files/tests, the PC biometric specs/issues, shared root `.gitignore`, `CLAUDE.md`, `AGENTS.md`, dependency files and all unrelated modified/deleted skill files were intentionally left unchanged. The map was also left unchanged to avoid a shared-file conflict; issue 11 alone may receive the hardware-stage pointer. No stash/reset/clean/checkout/commit occurred.
