# Issue11 digital engineering evidence — 2026-09-05

**Subsequent focused review:** [frame revision resolution](reference/source-one-v6-7in/revision-resolution.md) and its dimension register supersede source-status uncertainty here with a documented **unresolved documentation conflict**. No corrected authoritative stack was obtained. The existing model was inspected without geometry changes; full adapter qualification remains blocked. Manufacturer inquiry prepared for approval, not sent.

Status: **active detailed engineering; not a fabrication release**. Q75/Q74 remain unchanged. User-approved Fusion Python works through Autodesk's official loopback MCP. No third-party bridge, installation, cloud save, purchase, fabrication, hardware operation, firmware upload or PC-ticket change occurred. UTC execution logs after midnight are dated September6; local engineering date is September5.

## Reproducible results

- A dedicated Fusion unit-check document measured an internal 1cm line as exactly10mm.
- The pinned 72,083,544-byte TBS DXF passed SHA-256 and imported with original coordinates and separate source layers. All four motor-axis circles match source XY within0.001mm. This is numerical import accuracy, not manufacturing tolerance.
- Created `BGD_MASTER` with seven exact curved-profile solids, eight nominal standoff envelopes and the revised adapter study:16 visible solids. Hidden raw references and the rejected55mm adapter are deliberately retained. Missing frame parts and all other aircraft systems are not represented as completed CAD.
- Copied profile areas agree within0.002mm²; solid volumes agree with area×thickness within0.02mm³. Curves/holes were copied from Fusion profiles, not approximated by DXF vertex chords.
- Final captured occurrence positions have **zero solid intersections among those16 bodies**. This narrow check excludes omitted fasteners, arm spacer, brace, camera hardware, AIO board, wiring and all other systems; it is not whole-aircraft compatibility.
- Saved a local [Fusion archive](exports/reference-r1/BGD_MASTER_reference-r1.f3d), [adapter STEP](exports/reference-r1/M01_48mm_STUDY_NOT_FOR_FABRICATION.step), [preview](exports/reference-r1/BGD_MASTER_reference-r1.png) and [hash/geometry manifest](assemblies/reference-r1-manifest.json). No cloud project was selected or modified. Generated exports remain locally ignored under existing policy; no commit or publication occurred.
- [Native archive round-trip check](assemblies/reference-r1-reopen.json) passed: Fusion reopened the saved F3D, retained provenance, and matched all16 body volumes/bounds within0.02mm³/0.001mm. Only the disposable reopened test document was closed; the working master remains open. Python's ZIP checker could not handle Autodesk's compression method, so it was not used as evidence of archive validity.

## Master coordinates

Right-handed **FLU**: +X forward, +Y left, +Z up. This replaces the earlier inconsistent right/forward/up labels; it does not change a requirement. Manufacturer photos show the wide pair at the camera end. Photos establish visual orientation only, not measured dimensions.

```text
X = 1493.8850402200592 - DXF_Y
Y = DXF_X - 1518.565263306285
Z = assumed underside of the arms
```

XY origin is the four-motor centroid. The previous circle-centre analysis datum is32.626578063241mm forward of it. To translate the old fore/aft study coordinate `s`, use `X=s+32.626578063241`. Do not reuse the old `r` left/right labels; identify sides from physical orientation, with aircraft-right=-Y. Rotor-plane height remains independent and unverified.

## Actual adapter finding and scoped revision

The55×55×1.6mm R1 adapter intersects four OD5mm standoffs in the nominal assembly, with2.1167mm maximum planar overlap. A48×48×1.6mm blank retains both eight-hole patterns and gives1.3833mm nominal edge clearance. Fusion reports zero adapter/standoff intersections. See [comparison](components/aio-screen.json) and [dimensioned revision study](drawings/M01-R2-study.svg).

Calculated FR4 blank mass changes8.7636→6.6294g, a2.1342g reduction at assumed1.85g/cm³. Do not subtract this alone from an incomplete aircraft ledger to claim a new complete mass or endurance result. Manufacturing tolerance, fastener heads, dampers, board/pad/USB/SD access, airflow and structural loads remain H01. The smaller blank is a supported **candidate**, not an approved fabrication release. Hardware identities and capabilities are unchanged.

## Frame source/revision gate

The [current TBS specification](https://www.team-blacksheep.com/products/prod:source1v6) lists bottom2.5mm, middle/top2mm and arms6mm. The pinned July7 drawing's manufacturing labels identify the two relevant plate layouts as2mm. Its authoritative2D profiles do not settle which currently supplied revision/thickness applies. The source release has no complete assembled3D model or finished assembly manual establishing the missing stack.

Evidence reviewed: [manufacturer assembly image](https://www.team-blacksheep.com/img/gallery/A7303021.JPG), [side image](https://www.team-blacksheep.com/img/gallery/A7303025.JPG), [underside image](https://www.team-blacksheep.com/img/gallery/A7303026.JPG), [camera-detail image](https://www.team-blacksheep.com/img/gallery/A7303027.JPG), the pinned DXF including its manufacturing labels, all structural/imported profiles and the [manufacturer repository](https://github.com/tbs-trappy/source_one/tree/232ccff173c556d23cc857f0c07a6eaa66ddbc41). No dimensions were measured from perspective photographs.

Two stack interpretations were examined. Hypothesis A places Draw14 above the arms and blocks all four30.5mm mounting axes, so it is rejected for the intended above-plate stack. Hypothesis B places Draw14 below the arms, Draw3 above and uses front22mm/rear30mm supports; the mounting axes and modeled solids clear. **B is still an engineering hypothesis, not manufacturer-verified assembly identity.** It must not be propagated as a received-part fact or a released mounting datum. See [revision report](reference/source-one-v6-7in/fusion-stack-revision.json).

An intermediate interference run also exposed a Fusion workflow issue: feature regeneration reverted uncaptured occurrence moves. The final script applies poses after feature edits, captures the position snapshot, checks actual body Z bounds and reruns interference. The eight intermediate collisions in `fusion-interference-pairs.json` are historical model-state errors; the final manifest supersedes them. Neither is a measured hardware failure.

### Evidence needed before frame-dependent release

Obtain manufacturer/supplier confirmation of the current7-inch V6 plate-to-layer mapping, bottom thickness, arm-spacer/brace placement, front/rear standoff lengths and complete fastener stack. A revision-controlled assembly drawing or authoritative assembled CAD can resolve this before hardware purchase. If unavailable, record an incoming-part measurement/assembly gate; do not invent the data or drill the carbon to fit a study. No external inquiry was sent without authorization.

Suggested technical inquiry, prepared but **not sent**:

> For the Source One V6 7-inch DC currently supplied, does the pinned July7 DXF still define the shipped profiles? Its bottom/middle layouts are marked2mm, but the product lists a2.5mm bottom plate. Please identify Draw3/Draw13/Draw14, the stack order and heights, locations of22/30/20mm standoffs, brace/spacer geometry and thickness, and screw/press-nut assembly. An exploded dimensioned drawing or assembled STEP would avoid designing mounts against the wrong revision.

## Remaining work and physical limits

H01–H12 remain engineering holds; none is closed by this snapshot. Frame-dependent attachment geometry, motor/prop vertical datums, battery/CG travel, mounts/gear/latch/guards/routes, full mass/cost/endurance reconciliation and final manufacturing drawings remain unfinished. They must continue from this evidence, with unverified input parameters kept separate from released dimensions. No owner requirement is reopened.

The existing135-row harness,43-row pin allocation, firmware manifests and safety/state tables remain controlling. No native KiCad source or ERC/DRC result was created or claimed during this mechanical checkpoint. Harness lengths cannot be finalized from this partial assembly.

Received dimensions/tolerances, mechanical strength, workmanship, insulation, vibration, thermal performance, EMI, actuator/security faults, flight stability, loaded capability and **Q74's20 useful minutes plus reserve** still require their specified physical acceptance evidence. Zero CAD interference is not evidence for any of these outcomes. Issue11 remains claimed.
