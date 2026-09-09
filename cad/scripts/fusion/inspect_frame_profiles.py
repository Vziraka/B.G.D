"""Inspect only BGD_MASTER raw frame profiles and establish a face-on view."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion


def run(_context: str):
    app = adsk.core.Application.get()
    assert app.activeDocument.name == "BGD_MASTER"
    design = adsk.fusion.Design.cast(app.activeProduct)
    root = design.rootComponent
    assert root.attributes.itemByName("BGD", "source_sha256").value == "398556cd5f8720ac1a39b79bd1a0d1c083c6c57def55920bc17b212061b6d099"
    component = root.occurrences.item(0).component
    assert component.name == "00_SOURCE_ONE_RAW_2D_REFERENCE"
    profiles = []
    for i in range(component.sketches.count):
        s = component.sketches.item(i)
        if s.name == "Cen":
            continue
        for j in range(s.profiles.count):
            p = s.profiles.item(j)
            props = p.areaProperties(adsk.fusion.CalculationAccuracy.HighCalculationAccuracy)
            center = props.centroid
            if abs(center.x*10-1518.565263306285)>250 or abs(center.y*10-1461.258462156818)>250 or props.area*100<100:
                continue
            bounds = p.boundingBox
            profiles.append({"layer": s.name, "profile_index": j,
                             "area_mm2": props.area*100, "loops": p.profileLoops.count,
                             "centroid_mm": [center.x*10,center.y*10,center.z*10],
                             "min_mm": [bounds.minPoint.x*10,bounds.minPoint.y*10,bounds.minPoint.z*10],
                             "max_mm": [bounds.maxPoint.x*10,bounds.maxPoint.y*10,bounds.maxPoint.z*10]})
    output = Path(r"C:\Users\zvent\Downloads\B.G.D\cad\reference\source-one-v6-7in\fusion-profile-inspection.json")
    with output.open("x", encoding="utf-8") as handle:
        json.dump(profiles, handle, indent=2)
    camera = app.activeViewport.camera
    camera.eye = adsk.core.Point3D.create(151.8565263306285,146.1258462156818,100)
    camera.target = adsk.core.Point3D.create(151.8565263306285,146.1258462156818,0)
    camera.upVector = adsk.core.Vector3D.create(0,1,0)
    camera.viewExtents = 23
    camera.isFitView = False
    app.activeViewport.camera = camera
    app.activeViewport.refresh()
    print(json.dumps(profiles))
