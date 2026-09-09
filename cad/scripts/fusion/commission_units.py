"""Create only a dedicated disposable B.G.D. unit-test design; no file writes."""
import json
import adsk.core
import adsk.fusion


def run(_context: str):
    app = adsk.core.Application.get()
    name = "BGD_COMMISSION_UNITS_20260905"
    if any(app.documents.item(i).name == name for i in range(app.documents.count)):
        raise RuntimeError("Test document already exists; inspect it rather than rerun")
    doc = app.documents.add(adsk.core.DocumentTypes.FusionDesignDocumentType)
    doc.name = name
    design = adsk.fusion.Design.cast(app.activeProduct)
    assert design and app.activeDocument == doc
    design.unitsManager.distanceDisplayUnits = adsk.fusion.DistanceUnits.MillimeterDistanceUnits
    sketch = design.rootComponent.sketches.add(design.rootComponent.xYConstructionPlane)
    sketch.name = "10_MM_UNIT_CHECK_NOT_A_FRAME"
    line = sketch.sketchCurves.sketchLines.addByTwoPoints(
        adsk.core.Point3D.create(0, 0, 0), adsk.core.Point3D.create(1, 0, 0))
    length_mm = design.unitsManager.convert(line.length, "cm", "mm")
    assert abs(length_mm - 10) < 1e-6, length_mm
    app.activeViewport.fit()
    print(json.dumps({"document": doc.name, "fusion_version": app.version,
                      "display_units": design.unitsManager.defaultLengthUnits,
                      "expected_mm": 10, "measured_mm": length_mm,
                      "tolerance_mm": 1e-6, "status": "PASS"}))
