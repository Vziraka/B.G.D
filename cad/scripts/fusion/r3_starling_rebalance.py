"""Move the lower lamp rearward, inspect clearance and preserve both studies."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion

OUT = Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')


def run(_context: str):
    app = adsk.core.Application.get()
    doc = next(d for d in app.documents if d.name == 'BGD_ISSUE11_R3_STARLING')
    doc.activate()
    design = adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    root = design.rootComponent
    parent = next(o for o in root.occurrences if o.component.name == 'STARLING_REV2_LAMP_LAYOUT_01')
    lower = next(o for o in parent.component.occurrences if o.component.name == 'VL49RGB_DOWN_ENVELOPE_NOT_MAKER_GEOMETRY')
    lamp = lower.createForAssemblyContext(parent)
    assert lamp.transform2.translation.length < 1e-8
    transform = adsk.core.Matrix3D.create()
    transform.translation = adsk.core.Vector3D.create(0,0,-19)
    lamp.transform2 = transform
    if design.snapshots.hasPendingSnapshot:
        design.snapshots.add()
    parent.component.name = 'STARLING_REV2_LAMP_LAYOUT_02'
    lamp = lower.createForAssemblyContext(parent)
    collisions = []
    for other in root.allOccurrences:
        if other.fullPathName.startswith(parent.fullPathName) and 'ROTOR_SWEEP' not in other.component.name:
            continue
        if not other.component.bRepBodies.count or not lamp.boundingBox.intersects(other.boundingBox):
            continue
        coll = adsk.core.ObjectCollection.create()
        coll.add(lamp);coll.add(other)
        result = design.analyzeInterference(design.createInterferenceInput(coll))
        volume = sum(r.interferenceBody.volume*1000 for r in result)
        if volume > .001:
            collisions.append({'part':other.fullPathName,'overlap_mm3':volume})
    report = {'status':'CONDITIONAL_REV2_LAYOUT_02_NOT_ATTACHMENT_RELEASE',
              'down_lamp_center_mm':[0,-40,-115], 'down_lamp_size_mm':[90,35,80],
              'native_intersections':collisions,
              'lamp_only_nominal_cg_shift_mm':{'x':0,'y':101*(85-40)/798,'z':101*(54.5-115)/798},
              'cg_basis':'Both101g lamp centroids at envelope centers; original aircraft plus30g mounts at origin only for sensitivity, not measured CG',
              'landing_note':'Downlamp extends60mm beyond rear motor/footline;10.13mm levelgap requires slope/tipping test, not a universal landing clearance',
              'source_revision':'Rev2 published CAD; current C29 confirmation required'}
    (OUT/'starling-layout-rev2-balanced.json').write_text(json.dumps(report,indent=2)+'\n')
    cam = app.activeViewport.camera
    cam.eye=adsk.core.Point3D.create(50,36,50);cam.target=adsk.core.Point3D.create(0,2,0)
    cam.upVector=adsk.core.Vector3D.create(0,1,0);cam.isFitView=True
    app.activeViewport.camera=cam;app.activeViewport.fit()
    assert app.activeViewport.saveAsImageFile(str(OUT/'starling-layout-rev2-balanced.png'),1600,1200)
    archive=OUT/'starling-layout-rev2-balanced.f3d'
    assert not archive.exists()
    assert design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(archive)))
    print(json.dumps(report))
