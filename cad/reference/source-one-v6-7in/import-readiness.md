# CAD-T01 continuation — 2026-09-05

**Executed; not fabrication-released.** The user approved broad Issue11 Python execution and the import, unit/coordinate checks and partial master now exist. See [current evidence](../../engineering-progress-2026-09-05.md). The pre-import procedure below is retained as history; it does not override current execution authorization or the actual master datum. Per-call prompt enforcement remains unverified.

## Source and measurements ready for comparison

Use the exact [source manifest](source.json), with cached SHA-256 `398556cd5f8720ac1a39b79bd1a0d1c083c6c57def55920bc17b212061b6d099`, not a newly selected revision. The [provisional analysis](frame-2d-verification.json) checks the 2025-JUL-07 Source One V6 7-inch DC identity. AutoCAD 2000 DXF declares millimetres (`$INSUNITS=4`) and metric measurement (`$MEASUREMENT=1`). Multiple flat manufacturing views/layers are present.

The corrected verifier computes mounting pitches from actual circle centers. Its 0.001 mm tolerance is an extraction/comparison tolerance, not a manufacturing capability or fit allowance. The motor common-circle diameter is 312.830419 mm, within ±0.5 mm of the published whole-millimetre nominal 313 mm. The dead-cat opposite-motor diagonal is a different measurement, about 301.991326 mm. Do not scale the DXF to force the diagonal to 313 mm.

## Coordinate correction before import

The user's example of +X forward, +Y right, +Z up is left-handed. Fusion needs a consistent right-handed model; proposed **+X forward, +Y left, +Z up** keeps upward Z and avoids reflecting the source. Aircraft-right offsets then equal negative Fusion Y. This corrects the mathematical convention, without changing aircraft requirements.

The earlier reference README/master plan used X right/Y forward/Z up with a raw transform that reverses the raw sketch plane's handedness. Treat that transform and its left/right labels as preliminary, not as an inspected placement instruction. Do not transform asymmetric plates using it.

The provisional analysis uses the manufacturer construction-circle center as its analysis datum. That center is not the four-motor centroid used in the earlier assembly proposal: they differ by approximately 32.626578 mm along the provisional fore/aft axis. Both are legitimate documented datums, but they cannot be silently interchanged. Preserve both in the eventual reference; choose and document the master origin after the camera/front end is identified. No master placement has occurred.

Current provisional rotation/translation from raw drawing coordinates is:

```text
X = 1461.258462156818 - DXF_Y
Y = DXF_X - 1518.565263306285
```

This is a rotation, not reflection. It is still provisional: the wide dead-cat pair is inferred to be front, and physical plate/layer identity has not been inspected in Fusion. Z=0 is only a drawing plane; it does not establish the assembled frame's top surface or rotor plane.

## Import and verification sequence

1. Use a new B.G.D. reference design, not another person's/current unrelated document. Choose millimetres. Do not save to an unspecified Autodesk project or overwrite an existing local archive.
2. Import the pinned DXF on the XY plane at its declared 1:1 scale. Preserve separate source layers and raw coordinates in the first import. In the official API, `createDXF2DImportOptions` plus `isSingleSketchResult=False` and `importToTarget2` are documented by the live server. Actual execution and large-file behavior remain untested; never retry a timed-out import blindly.
3. Check imported motor circles and central mounting-hole centers against the source report before alignment. Fusion's internal API length units must be converted explicitly; display units do not establish an imported scale.
4. Inspect frame/camera outlines to establish front and assign physical plate names. Compare curved outlines as well as circles; the lightweight source parser's vertex bounds/chord areas do not establish exact curved plate boundaries or usable closed profiles.
5. Establish the documented axes/datums in a separate reference component. Re-measure transformed centers and symmetry. Keep raw-source provenance and transformation history.
6. Only after those checks pass, export a native reference archive and measurement manifest with hashes. Do not call a blank test document or a source-only JSON report a verified Fusion reference.

## Beginner concepts used in this step

- **DXF:** a drawing interchange file containing geometry and layers; it is not automatically an assembled aircraft.
- **1:1:** one millimetre in the source remains one millimetre in Fusion. Verify known distances instead of trusting appearance.
- **Sketch/profile:** sketch curves define flat geometry; a closed profile is an enclosed region suitable for later solid modeling. Intersecting or broken curves can prevent that.
- **Origin/axes/datum:** the zero point, three directions and reference features used to locate every later component. A consistent convention prevents mirrored mounts and displaced parts.
- **Motor/hole center:** the axis location used for mounting and spacing, not the outer edge of a circle.

If a manual import is needed, give click-by-click instructions against the live Fusion screen at that point; the current UI has new Part/Assembly/Hybrid design choices. Do not present old menu instructions as already tested.

The next prerequisite after this stage is **assembled-frame Z geometry**: plate stack/order, standoffs and mating faces. Motor envelope and propeller swept-volume placement depend on that stack. Do not proceed to detailed custom mounts or substitute hardware. CAD-T01 still ends at the user's frame-reference review checkpoint.
# Execution update — 2026-09-05

Import, units, motor-centre comparison and curved-profile copying have now run successfully. Use [current evidence](../../engineering-progress-2026-09-05.md) and the final snapshot manifest; this pre-import procedure is retained as history. Its circle-centre datum differs from the actual master rotor-centroid datum. Assembly identity/Z remains unverified.
