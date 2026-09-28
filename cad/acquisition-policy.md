# Component model acquisition policy

The five inventory classes describe the **planned representation**, not a compatibility grade:

1. Manufacturer-authoritative CAD acquired without geometric reinterpretation.
2. Authoritative third-party CAD derived from manufacturer dimensions, accepted only after its important interfaces are checked against those dimensions.
3. Existing repository/reference CAD, retaining source authority and verification limits.
4. Simplified dimensional envelope created by B.G.D. from authoritative dimensions because adequate engineering CAD is unavailable or unnecessary.
5. Custom B.G.D. component requiring design and release.

Acquisition order follows integration risk: frame, motors/props, battery, AIO/power, compute/sensors, radio/antennas, moving camera and landing structure. STEP/STP is preferred. DXF is acceptable for planar manufactured profiles; PDFs/images support derived geometry but are not imported as magically accurate solids.

Each component directory eventually contains `source.json`, original or derived geometry, and a review note. Important hole/connector/keep-out dimensions must match authoritative documentation. Community CAD may accelerate visual layout only after those interfaces pass checks; otherwise it remains quarantined and cannot support `VERIFIED DIGITALLY`.

Historical initial inventory audit (superseded by the R2 imports): no class 1 or class 2 model was claimed then. The official TBS DXF is class 3 because it is already present as repository/reference CAD. Standard components without acquired authoritative CAD are class 4 even when their envelope uses manufacturer dimensions.
