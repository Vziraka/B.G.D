# TBS Source One V6 7-inch authoritative reference

**Current user direction supersedes the earlier review stop:** do not send the TBS inquiry or wait for a reply. Preserve the2.0–2.5mm conflict and continue [bounded robust-design studies](../../robust-aio-review.md), subject to the [received-frame inspection gate](../../received-frame-inspection-gate.md). The45mm replacement outline passes only the declared planar envelope; full mounting/services and assembly topology remain unqualified. No uncertain dimension becomes manufacturer verified.

**Latest review:** [revision resolution and adapter audit](revision-resolution.md), [dimension/confidence register](dimension-register.csv). Outcome: documentation conflict unresolved. The2mm values are explicit DXF text, not extrusion defaults. The existing48mm adapter still passes only the unchanged hypothetical bare-blank screen. No corrected authoritative Z-stack or fabrication release exists.

**2026-09-05 execution update:** the source is now imported and numerically checked in an actual `BGD_MASTER`; see [current CAD evidence](../../engineering-progress-2026-09-05.md). The older source-analysis transform/left-right labels below are historical and must not be used for placement. Actual CAD uses FLU at the motor centroid. Assembly thickness/revision/Z remains a release hold.

This is the first mechanical prerequisite. TBS publishes `So1-V6-7inDC-2025-JUL-07.dxf` in its manufacturer-owned `tbs-trappy/source_one` repository.

| Field | Value |
|---|---|
| Upstream commit checked | `232ccff173c556d23cc857f0c07a6eaa66ddbc41` |
| Git blob | `4722157f17719f98f91fd8f8c8c960c33fb45bee` |
| File size | 72,083,544 bytes |
| Cached file SHA-256 | `398556cd5f8720ac1a39b79bd1a0d1c083c6c57def55920bc17b212061b6d099` |
| Upstream file | [Pinned DXF](https://github.com/tbs-trappy/source_one/blob/232ccff173c556d23cc857f0c07a6eaa66ddbc41/So1-V6-7inDC-2025-JUL-07.dxf) |
| Local cache | `.scratch/hardware-artifacts/frame.dxf` (ignored, hash rechecked 2026-09-04) |
| Representation | Class 3: existing authoritative repository/reference CAD |

The DXF contains multiple manufacturing views/layers, including flat plate profiles, rather than an assembled 3D frame. It establishes plan geometry but does not establish assembled plate spacing, standoff height, motor screw engagement or rotor-plane Z.

The master assembly will use millimetres and a right-handed aircraft system: **X right, Y forward, Z up**. Its XY origin is the four-motor rotor centroid. For raw DXF coordinates used in the current extraction:

```text
X_master = DXF_X - 1518.565263306285
Y_master = 1493.885012156818 - DXF_Y
```

Extracted motor centres relative to that origin:

| Motor | X mm | Y mm |
|---|---:|---:|
| front-left | −145.2228 | 90.73055 |
| front-right | 145.2228 | 90.73055 |
| rear-left | −96.1704 | −90.73055 |
| rear-right | 96.1704 | −90.73055 |

The first Fusion task must import the pinned DXF at 1:1mm, isolate and name the correct 7-inch structural profiles, compare these four centres and the documented frame holes, and save an inspected frame-reference component. The Z origin and assembled stack must remain parameters/holds until authoritative assembly dimensions exist. No Fusion master document has been created yet.
# Current status — 2026-09-05

The pinned source has now been imported and numerically checked in Fusion. See [current master evidence, datum correction and unresolved source revision](../../engineering-progress-2026-09-05.md). The original source-analysis notes below are historical preparation, not current assembly instructions. No frame-dependent fabrication release is claimed.
