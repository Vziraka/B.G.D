"""Unground imported source root part and capture the complete camera assembly."""
import json,math
from pathlib import Path
import adsk.core,adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
def run(_context:str):
    app=adsk.core.Application.get();doc=next(d for d in app.documents if d.name=='BGD_R3_HYBRID');doc.activate()
    d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent
    t=adsk.core.Matrix3D.create();t.setToRotation(math.pi/2,adsk.core.Vector3D.create(1,0,0),adsk.core.Point3D.create(0,0,0));t.translation=adsk.core.Vector3D.create(-4.45,-12.15,8.175)
    rec=[]
    d.timeline.moveToEnd()
    occurrences=list(r.occurrences)
    for o in occurrences:
        if not o.component.name.startswith(('606-','609-','611-','612-','602-')):continue
        before=o.isGrounded
        if before:o.isGrounded=False
        if hasattr(o,'isGroundToParent') and o.isGroundToParent:o.isGroundToParent=False
        o.transform2=t
        rec.append({'name':o.component.name,'was_grounded':before})
    if d.snapshots.hasPendingSnapshot:d.snapshots.add()
    d.timeline.moveToEnd()
    d.computeAll()
    for o in occurrences:
        if o.component.name.startswith(('606-','609-','611-','612-','602-')):
            b=o.boundingBox
            row=next(q for q in rec if q['name']==o.component.name)
            row['min_mm']=[x*10 for x in b.minPoint.asArray()];row['max_mm']=[x*10 for x in b.maxPoint.asArray()]
            print(json.dumps({'part':o.component.name,'min':row['min_mm'],'max':row['max_mm'],'transform':o.transform2.asArray()}))
            assert b.maxPoint.y < -10 and o.component.bRepBodies.count>0 or o.component.occurrences.count>0,'Camera part left at import origin'
    result={'camera_parts':rec,'native_source_pose_verified':True}
    (OUT/'hybrid-camera-position-verified.json').write_text(json.dumps(result,indent=2)+'\n')
    archive=OUT/'hybrid-layout-verified.f3d';assert not archive.exists();assert d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(archive)))
    d.exportManager.execute(d.exportManager.createSTEPExportOptions(str(OUT/'hybrid-layout-verified.step')))
    app.activeViewport.fit();app.activeViewport.saveAsImageFile(str(OUT/'hybrid-layout-verified.png'),1600,1200)
    print(json.dumps(result))
