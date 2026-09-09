"""Derive exact curved plate solids; retain explicit assembly-Z assumptions."""
import json
import math
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT = Path(r"C:\Users\zvent\Downloads\B.G.D")
SOURCE = "398556cd5f8720ac1a39b79bd1a0d1c083c6c57def55920bc17b212061b6d099"


def run(_context: str):
    app = adsk.core.Application.get()
    assert app.activeDocument.name == "BGD_MASTER"
    design = adsk.fusion.Design.cast(app.activeProduct)
    root = design.rootComponent
    assert root.attributes.itemByName("BGD", "source_sha256").value == SOURCE
    assert root.occurrences.count == 1, "Inspect a partial execution instead of rerunning"
    output = ROOT / "cad/reference/source-one-v6-7in/fusion-solid-verification.json"
    assert not output.exists()
    source = root.occurrences.item(0).component
    raw_x = 1518.565263306285
    raw_y = (1584.615576047809 + 1403.154504392309) / 2
    # Right-handed FLU. Origin is rotor-axis centroid; Z=arm underside (assumed).
    transform = adsk.core.Matrix3D.create()
    transform.setWithArray([0,-1,0,raw_y/10, 1,0,0,-raw_x/10, 0,0,1,0, 0,0,0,1])
    specs = [
        ("01_TOP_INFERRED_Draw13", "Draw13", 47, 3912.962263530615, 2, 30),
        ("02_MIDDLE_INFERRED_Draw14", "Draw14", 23, 2881.867269164925, 2, 6),
        ("03_BOTTOM_INFERRED_Draw3", "Draw3", 26, 3118.8074489203955, 2.5, -2.5),
        ("04_FRONT_LEFT_ARM", "Frame-Arms", 74, 2541.5302271076503, 6, 0),
        ("05_FRONT_RIGHT_ARM", "Frame-Arms", 75, 2541.5302271328687, 6, 0),
        ("06_REAR_RIGHT_ARM", "Frame-Arms", 103, 2949.6440808716534, 6, 0),
        ("07_REAR_LEFT_ARM", "Frame-Arms", 104, 2949.64408087679, 6, 0),
    ]
    evidence = []
    for name, layer, index, expected_area, thickness, z in specs:
        origin = adsk.core.Matrix3D.create()
        origin.translation = adsk.core.Vector3D.create(0, 0, z/10)
        occ = root.occurrences.addNewComponent(origin)
        component = occ.component
        component.name = name
        component.attributes.add("BGD", "assembly_status", "PROVISIONAL_Z_NOT_FABRICATION_RELEASED")
        sketch = component.sketches.add(component.xYConstructionPlane)
        sketch.name = "PINNED_PROFILE_" + layer + "_" + str(index)
        old_sketch = source.sketches.itemByName(layer)
        old_profile = old_sketch.profiles.item(index)
        entities = adsk.core.ObjectCollection.create()
        seen = set()
        for loop in old_profile.profileLoops:
            for curve in loop.profileCurves:
                entity = curve.sketchEntity
                if entity.entityToken not in seen:
                    entities.add(entity)
                    seen.add(entity.entityToken)
        old_sketch.copy(entities, transform, sketch)
        candidates = [(p, p.areaProperties(adsk.fusion.CalculationAccuracy.HighCalculationAccuracy).area*100)
                      for p in sketch.profiles]
        profile, area = min(candidates, key=lambda item: abs(item[1]-expected_area))
        assert abs(area-expected_area) < 0.002, (name, area, expected_area)
        assert profile.profileLoops.count == old_profile.profileLoops.count
        feature = component.features.extrudeFeatures.addSimple(
            profile, adsk.core.ValueInput.createByString(str(thickness)+" mm"),
            adsk.fusion.FeatureOperations.NewBodyFeatureOperation)
        feature.name = "DOCUMENTED_THICKNESS_INFERRED_PLATE_ID" if "INFERRED" in name else "DOCUMENTED_6_MM_ARM"
        body = feature.bodies.item(0)
        body.name = name
        volume = body.volume*1000
        assert abs(volume-area*thickness) < 0.02, (name, volume)
        sketch.isVisible = False
        evidence.append({"component": name, "layer":layer, "profile_index":index,
                         "area_mm2":area, "loops":profile.profileLoops.count,
                         "thickness_mm":thickness, "z_bottom_mm":z,
                         "volume_mm3":volume, "area_and_volume_check":"PASS",
                         "thickness_evidence":"TBS product specification; plate role inferred from photos",
                         "z_evidence":"ASSEMBLY ASSUMPTION: 30mm front standoffs = 6mm arms + 2mm middle + 22mm rear standoffs"})
    root.occurrences.item(0).isLightBulbOn = False
    root.attributes.add("BGD", "axes", "FLU_X_FORWARD_Y_LEFT_Z_UP")
    root.attributes.add("BGD", "origin", "ROTOR_CENTROID_XY_ARM_UNDERSIDE_Z_ASSUMED")
    report = {"source_sha256":SOURCE, "document":"BGD_MASTER", "release":"REFERENCE_ONLY_NOT_COMPLETE_FRAME",
              "raw_origin_mm":[raw_x,raw_y,0], "transform":"X=raw_origin_y-DXF_Y; Y=DXF_X-raw_origin_x; Z=assumed arm underside",
              "front_evidence":"TBS A7303021.JPG and A7303026.JPG: camera end at wide pair; visual identity, not dimensional measurement",
              "parts":evidence,
              "omissions":["brace", "arm spacer", "camera plates/mount", "standoffs and fasteners", "tolerances", "physical stack confirmation"]}
    with output.open("x",encoding="utf-8") as handle:
        json.dump(report,handle,indent=2)
    camera = app.activeViewport.camera
    camera.eye = adsk.core.Point3D.create(30,-35,30)
    camera.target = adsk.core.Point3D.create(0,0,0)
    camera.upVector = adsk.core.Vector3D.create(0,0,1)
    camera.viewExtents = 22
    camera.isFitView = False
    app.activeViewport.camera = camera
    app.activeViewport.refresh()
    print(json.dumps(report))
