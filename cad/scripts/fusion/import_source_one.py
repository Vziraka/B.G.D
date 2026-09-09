"""Import the pinned structural/reference DXF layers into a new BGD_MASTER.

No assembled Z or manufactured geometry is inferred by this operation.
"""
import hashlib
import json
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT = Path(r"C:\Users\zvent\Downloads\B.G.D")
REF = ROOT / "cad/reference/source-one-v6-7in"


def run(_context: str):
    manifest = json.loads((REF / "source.json").read_text())
    source = (ROOT / manifest["local_cache"]).resolve()
    assert source.is_relative_to(ROOT.resolve())
    assert hashlib.sha256(source.read_bytes()).hexdigest() == manifest["sha256"]
    output = REF / "fusion-import-raw.json"
    assert not output.exists(), "Import evidence already exists; inspect rather than overwrite"
    app = adsk.core.Application.get()
    assert not any(app.documents.item(i).name == "BGD_MASTER" for i in range(app.documents.count)), "Master already open"
    doc = app.documents.add(adsk.core.DocumentTypes.FusionDesignDocumentType)
    doc.name = "BGD_MASTER"
    design = adsk.fusion.Design.cast(app.activeProduct)
    assert design and app.activeDocument == doc
    design.unitsManager.distanceDisplayUnits = adsk.fusion.DistanceUnits.MillimeterDistanceUnits
    root = design.rootComponent
    root.attributes.add("BGD", "source_sha256", manifest["sha256"])
    occurrence = root.occurrences.addNewComponent(adsk.core.Matrix3D.create())
    component = occurrence.component
    component.name = "00_SOURCE_ONE_RAW_2D_REFERENCE"
    options = app.importManager.createDXF2DImportOptions(str(source), component.xYConstructionPlane)
    available = list(options.layers)
    selected = ["Frame-Arms", "Draw3", "Draw13", "Draw14", "Cen"]
    assert set(selected).issubset(available), available
    options.layers = selected
    options.isSingleSketchResult = False
    imported = app.importManager.importToTarget2(options, component)
    assert imported is not None, "DXF import returned no result; inspect the document"
    sketches = []
    for i in range(component.sketches.count):
        sketch = component.sketches.item(i)
        circles = []
        for j in range(sketch.sketchCurves.sketchCircles.count):
            c = sketch.sketchCurves.sketchCircles.item(j).geometry
            circles.append({"x_mm": c.center.x * 10, "y_mm": c.center.y * 10,
                            "z_mm": c.center.z * 10, "radius_mm": c.radius * 10})
        sketches.append({"name": sketch.name, "curve_count": sketch.sketchCurves.count,
                         "profile_count": sketch.profiles.count, "circles": circles})
    expected = [(1422.394892437729, 1584.615576047809),
                (1614.735634174839, 1584.615576047809),
                (1373.342510706664, 1403.154504392309),
                (1663.788015905904, 1403.154504392309)]
    motor_sketch = next(s for s in sketches if s["name"] == "Frame-Arms")
    checks = []
    for x, y in expected:
        circle = min(motor_sketch["circles"], key=lambda c: (c["x_mm"]-x)**2+(c["y_mm"]-y)**2)
        error = ((circle["x_mm"]-x)**2+(circle["y_mm"]-y)**2)**0.5
        checks.append({"source_x_mm": x, "source_y_mm": y, "imported": circle,
                       "center_error_mm": error, "pass": error <= 0.001 and abs(circle["radius_mm"]-3.5) <= 0.001})
    report = {"fusion_version": app.version, "document": doc.name,
              "source_sha256": manifest["sha256"], "selected_layers": selected,
              "available_layers": available, "display_units": design.unitsManager.defaultLengthUnits,
              "internal_length_unit": "cm", "transform": "identity; raw DXF coordinates retained",
              "sketches": sketches, "motor_import_checks": checks,
              "import_scale_pass": all(c["pass"] for c in checks),
              "assembled_z_status": "NOT ESTABLISHED", "fabrication_release": False}
    with output.open("x", encoding="utf-8") as handle:
        json.dump(report, handle, indent=2)
    app.activeViewport.fit()
    print(json.dumps({"report": str(output), "scale_pass": report["import_scale_pass"],
                      "sketches": [{k:v for k,v in s.items() if k != "circles"} for s in sketches]}))
    assert report["import_scale_pass"], "Do not align or export as verified until scale discrepancy is resolved"
