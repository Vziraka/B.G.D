# Fusion automation strategy

Use Fusion-hosted Python where parametric regeneration or repeated checks reduce error: adapter/plate patterns, battery slider configurations, mast heights, sensor fields, servo sweeps, landing geometry, cargo tolerance configurations, mass-property exports and interference reports. Keep vendor components as imported/derived components; do not rebuild a fixed supplier part procedurally without benefit.

Repository scripts will own named parameters and generation logic. Fusion owns the inspected resulting assembly. A script is deployed manually to the installed API Scripts directory only after review, then run from Fusion. The generated document is inspected, saved and exported with source-script commit/hash and parameter manifest. No script deployment or execution is performed in this pass.

Required adjustable parameters include mounting-hole pitches, plate/material thicknesses, configured battery envelope,50mm CG travel, mast heights, sensor orientations, servo axes/limits, camera/CSI clearance and landing-ground clearance. Physical calibration remains adjustable rather than embedded as an ideal value.

Failure behavior: stop on missing named components, units, ambiguous profiles, impossible parameters or unresolved source dimensions. Never create best-guess mounting holes. Do not use Fusion API success as evidence of a manufacturable or physically compatible design; save inspection results and gate classification separately.

No always-running add-in is justified yet. Start with one manually invoked frame-import/validation script only if direct manual import proves too error-prone; the first frame task may be completed manually because it is a one-time authoritative import. Add an add-in only when multiple components need a repeatable command/UI.
