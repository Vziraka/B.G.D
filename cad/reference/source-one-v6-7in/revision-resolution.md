# Source One frame revision and adapter review

Review date: 2026-09-05 America/New_York; execution after midnight2026-09-06 UTC. **Documentation conflict remains unresolved. No corrected authoritative Z-stack or fabrication release is claimed.** Issue11 stays claimed. This review supersedes any impression that the first CAD checkpoint established the current retail frame's assembly identity.

## 1. Exact selected configuration

The Q75 selection remains **TBS Source One V6 7-inch DC**, manufacturer product route [`prod:source1v6`](https://www.team-blacksheep.com/products/prod:source1v6). Q75 did not identify a production lot, manufacturing change level or supplier-confirmed drawing revision. None can be invented now. No 5-inch V6, V5, community model or differently dated file was substituted.

The exact **reference drawing** is `So1-V6-7inDC-2025-JUL-07.dxf`, tag `v6`, commit `232ccff173c556d23cc857f0c07a6eaa66ddbc41`, SHA-256 `398556cd5f8720ac1a39b79bd1a0d1c083c6c57def55920bc17b212061b6d099`. Current manufacturer Git history still points to that commit; its publication was September17,2025, distinct from the July7 drawing date. No later published7-inch replacement or revision-to-shipped-stock mapping was found. The separate August19 V6 filename is not evidence of a newer7-inch design. See the [primary-source history audit](../../../docs/research/source-one-v6-revision-audit-2026-09-05.md).

## 2. Dimension authority and discrepancy

The [dimension register](dimension-register.csv) records each value, source/configuration and confidence. **Manufacturer verified** means the stated nominal specification is documented; it does not certify received parts or settle a contradictory source. **Derived from verified geometry** applies to the pinned reference only. **Provisional** denotes an unverified engineering assignment. **Received-part validation required** covers actual tolerance, engagement and workmanship checks.

| Dimension | Current TBS 7-inch listing | Pinned July7 drawing | Status / implication |
|---|---|---|---|
| Top plate | 2mm | 2mm text beneath Draw13 layout | Nominal value agrees; layer-to-current-part mapping still provisional |
| Middle plate | 2mm | 2mm text beneath Draw3 layout | Nominal value agrees; current-part mapping still provisional |
| Bottom plate | 2.5mm | 2mm text beneath Draw14 layout | **Conflict**, not a released thickness |
| Arms / spacer | 6mm each | 6mm manufacturing labels | Nominal agreement; assembly/received fit still separate |
| Camera plates | 2mm | 2mm layout label | Nominal agreement; not yet assembled in master |
| Brace thickness | Unspecified | No confidently mapped brace thickness | Unresolved |
| Standoff inventory | 4×30,4×22,2×20mm; OD5,M3 | Same lengths/counts in BOM text | Inventory verified; location and bearing faces unverified |
| Central mounting | 30.5 and20mm square | Both four-hole patterns extracted | Reference geometry agrees with nominal listing; shipped identity unconfirmed |
| Complete assembled height / usable bay | Not stated | No authoritative assembled-Z definition established | Unresolved; lengths alone do not assign the stack |

Source: [TBS current7-inch product specifications](https://www.team-blacksheep.com/products/prod:source1v6), [pinned source manifest](source.json), [raw-label evidence](source-label-audit.json).

The selected discrepancy classification is **documentation conflict remains unresolved**. The other three explanations remain unsupported possibilities. The2mm entries are `TEXT` entities, not a default extrusion: handles4A5(Draw13 layout),10799(Draw3),4DB(Draw14), on annotation layer`Draw`. The DXF header `$THICKNESS` is0.0 and `$INSUNITS` is4(mm). Spatial assignment of a label to its manufacturing layout is a drawing-derived association; assigning that layout to the current retail bottom/middle plate needs confirmation. Do not dismiss the explicit label as metadata or declare the product page newer without an engineering change record.

## 3. Resulting Z-stack status

**No newly verified Z-stack can be constructed from the available evidence.** Consequently, this review did not change plate positions, extrusions, standoff placements or the archive. It did not silently select2.0 or2.5mm as a resolution.

The existing hypothesis B is retained solely for reversible studies, with FLU axes and Z=assumed arm underside:

| Element | Existing lower → upper Z, mm | Classification |
|---|---:|---|
| Draw14, provisionally bottom | −2.5 → 0 | Provisional; thickness conflict |
| Arms | 0 → 6 | 6mm nominal documented; datum/assembly placement provisional |
| Draw3, provisionally middle | 6 → 8 | Provisional placement/identity; 2mm nominal documented |
| Front support interpretation | 8 → 30 | Provisional use of documented22mm standoffs |
| Rear support interpretation | 0 → 30 | Provisional use of documented30mm standoffs |
| Draw13, provisionally top | 30 → 32 | Provisional placement/identity; 2mm nominal documented |
| 48mm adapter blank | 10 → 11.6 | Provisional design position and1.6mm stock choice |

The modeled main-plate exterior span is34.5mm under this hypothesis. It is **not** a manufacturer frame-height value and excludes camera hardware/brace/fastener protrusions. The apparent30mm and22mm local support spans are not universally usable electronics clearances. Propeller-plane Z remains unknown; no mount height is derived from perspective photographs.

## 4. Motor and central mounting geometry

Read-only native Fusion inspection of all four imported arms finds one nominal Ø7mm center opening and four radial slots per motor. Each slot has two semicircular ends R1.5mm with end centers at radii8.0 and9.5mm from the motor axis: derived3.0mm width and4.5mm overall length, covering16/19mm opposing-center diameters. The slot axes repeat at90°. The [CAD extraction](revision-checkpoint-cad-audit.json) preserves each arc center and sweep in master coordinates. This is exact nominal drawing geometry, not a tolerance or current-stock proof. Curve bounding boxes can be conservative; slot dimensions here come from arc radii/center separation, not those boxes.

Do not interpret a19mm opposing-center diameter as a19mm square side pitch. The selected [iFlight XING-E2809 documentation](https://shop.iflight.com/XING-E-2809-Cinelifter-Motor-Pro2064?page=3&search=9) calls its mounting pattern`19×19, Ø3mm`; exact motor datum/rotation and engagement must be reconciled with the motor drawing/part rather than assumed from that shorthand. Its supplied M3×11 screws do not establish safe penetration through6mm carbon: nominal11−6=5mm protrusion excludes any washer/other stack and still needs the motor's safe thread/winding depth. No motor incompatibility or safe screw length is asserted by this audit.

In the actual rotor-centroid FLU datum, the pinned Draw3 central30.5mm pattern has X45.222002/75.722002mm and Y±15.25mm, nominal Ø3mm. Its center is X60.472002mm. The forward20mm square pattern has X50.471846/70.471846mm,Y±10mm, nominal Ø3mm. These two pattern centers differ by about0.000156mm in the published source; the0.001mm comparison tolerance does not mean manufactured fits are accurate to a micron. The rear Draw14 pattern is separately20mm with nominal Ø2.2mm holes; do not use its hole diameter as the forward pattern's.

## 5. 48mm adapter revalidation

The [new read-only Fusion run](revision-checkpoint-cad-audit.json) matched all16 existing body bounds/volumes against the saved reference and found zero intersections among them. **This repeats a conditional screen; it is not the requested final pass against a corrected frame stack, because that stack remains unavailable.**

| Requested check | Result and remaining prerequisite |
|---|---|
| Standoff clearance | **Conditional pass:** minimum1.3833129101mm to modeled OD5 supports. Actual OD/location tolerances, hardware heads and corrected stack outstanding. |
| Plate clearance | **Conditional pass for bare blank:**2.000mm to middle,10.000mm to bottom,18.400mm to top;4.000mm to arms. No complete mounting stack implied. |
| Damper/mount clearance | **Not verified:** no exact compressed/uncompressed elastomer geometry, flange/nut envelopes or tolerances. |
| USB/SD access | **Not verified:** no authoritative connector/card insertion, withdrawal or tool envelopes positioned in CAD. |
| Power-wire bend space | **Not verified:** actual AIO pad geometry,10AWG insulation OD/minimum bend radius, solder lands and strain-relief route missing. Never reduce strands to force a fit. |
| Bus/harness clearance | **Not verified:** copper guard, branch terminations and harness routing volumes are absent from this partial model. |
| Screw depths | **Not verified:** lengths, grip stacks, nut/standoff engagement and bottoming clearance not assigned. |
| Airflow/servicing | **Not verified:** no complete AIO/harness/guard/plug model or quantified thermal allowance. Bench thermal performance remains separate. |

The [MicoAir manufacturer manual](https://micoair.cn/zh/docs/flight-controller/micoair743-aio-series/micoair743v2-aio-45a-manual) specifies36×36×8mm,25.5mm pattern,Ø3mm holes,45° mounting, component side up, insulating vibration mounts and unobstructed ESC ventilation. Those facts do not supply missing mount heights or servicing clearances. For illustration only, in hypothesis B an8mm-high AIO above the adapter leaves an upper geometric bound`damper rise + required upper clearance ≤10.4mm`; this is a conditional inequality, not a selected damper or thermal design.

The48mm candidate is retained without further resizing. No final pass/fail for the complete adapter assembly is possible yet. No drawing or STEP was released.

## 6. Release gate and exact next task

Unresolved mechanical inputs: current frame production revision/profile mapping; bottom/brace thickness; sandwich order; all standoff endpoints; camera/brace/spacer installation; plate face heights; screw/head/nut/press-in projection and tolerances; safe motor screw depth; AIO dampers/USB/SD/pad/airflow and complete routes. Authoritative nominal data should be obtained first; received-part validation remains required for actual fits, with no purchase authorized.

**Next CAD task after the manufacturer answer:** create a separately versioned, evidence-tagged frame reference from the confirmed layer mapping and bearing-face stack; include brace/spacer/camera hardware and fastener envelopes; then finish the48mm AIO mounting/service envelope checks in the table above. Preserve the existing archive as history. If corrected geometry fails, revise only the affected adapter/mount arrangement. Stop for review before drawing release or larger CAD generation.

Current answer to fabrication safety: **No.** The authoritative2D source is traceable, but the assembled reference and dependent adapter are not fabrication-safe.

## 7. Files and boundary

Created this report, dimension register, raw-label audit, native checkpoint audit, review evidence manifest and two reproducible audit scripts. Added the primary-source research report and links/status notes. **No F3D, STEP, SVG fabrication-study geometry or Fusion body changed during this review.** Existing archive hashes remain unchanged. No PC-ticket files, hardware identity, Q74 requirement, configuration, purchase, physical work, firmware or external correspondence changed.

## Manufacturer inquiry — prepared, not sent

Subject: Source One V6 7-inch DC — current revision and assembly drawing

For your currently supplied Source One V6 7-inch DC (`prod:source1v6`), please confirm:

1. Does it match `So1-V6-7inDC-2025-JUL-07.dxf`, commit232ccff? Why do its plate-layout labels say2mm while your product specifies a2.5mm bottom plate? Please identify any superseding7-inch revision.
2. Please provide an annotated section/exploded drawing mapping Draw3/Draw13/Draw14, brace and arm spacer to their thicknesses and bearing faces, with the locations of30/22/20mm standoffs and screw/press-nut orientation.
3. Are motor-slot and central mounting patterns unchanged? Please include mounting-relevant tolerances, screw assignments and engagement limits.

A dimensioned assembly drawing or authoritative assembled CAD is preferred. This is a design-information request, not an order.
