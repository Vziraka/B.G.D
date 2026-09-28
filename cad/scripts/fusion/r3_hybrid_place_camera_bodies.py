"""Place exact manufacturer B-reps without imported grounding/history constraints."""
import json,math,hashlib
from pathlib import Path
import adsk.core,adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
def run(_context:str):
    app=adsk.core.Application.get();target=next(d for d in app.documents if d.name=='BGD_R3_HYBRID')
    d=adsk.fusion.Design.cast(target.products.itemByProductType('DesignProductType'));r=d.rootComponent
    assert not any(o.component.name=='OAK_EXACT_MAKER_BREPS_PLACED' for o in r.occurrences)
    source=OUT/'sources/hybrid-oak-d-pro-enclosure.stp'
    srcdoc=app.importManager.importToNewDocument(app.importManager.createSTEPImportOptions(str(source)))
    sd=adsk.fusion.Design.cast(srcdoc.products.itemByProductType('DesignProductType'))
    t=adsk.core.Matrix3D.create();t.setToRotation(math.pi/2,adsk.core.Vector3D.create(1,0,0),adsk.core.Point3D.create(0,0,0));t.translation=adsk.core.Vector3D.create(-4.45,-12.15,8.175)
    tm=adsk.fusion.TemporaryBRepManager.get();copies=[]
    for o in sd.rootComponent.allOccurrences:
        for body in o.bRepBodies:
            cp=tm.copy(body);assert cp
            result=tm.transform(cp,t)
            print(json.dumps({'stage':'sourcecopy','name':o.fullPathName,'result':result,'min':[q*10 for q in cp.boundingBox.minPoint.asArray()]}))
            copies.append((o.fullPathName,cp))
    target.activate();d.timeline.moveToEnd()
    for o in list(r.occurrences):
        if o.component.name.startswith(('606-','609-','611-','612-','602-')):o.isLightBulbOn=False
    o=r.occurrences.addNewComponent(adsk.core.Matrix3D.create());c=o.component;c.name='OAK_EXACT_MAKER_BREPS_PLACED'
    c.attributes.add('BGD','source_sha256',hashlib.sha256(source.read_bytes()).hexdigest())
    c.attributes.add('BGD','representation','Exact maker STEP B-reps rigidly transformed; no geometry inferred from image')
    bf=c.features.baseFeatures.add();assert bf.startEdit()
    for name,cp in copies:
        body=c.bRepBodies.add(cp,bf);assert body;body.name=name
    assert bf.finishEdit();d.computeAll()
    b=o.boundingBox
    print(json.dumps({'stage':'placed','count':len(copies),'min':[q*10 for q in b.minPoint.asArray()],'max':[q*10 for q in b.maxPoint.asArray()]}))
    assert b.maxPoint.y<-10 and b.minPoint.z>5
    collision=[]
    for other in r.occurrences:
        if not other.component.name.startswith(('ROTOR_','OAK_REAR_')):continue
        if not b.intersects(other.boundingBox):continue
        coll=adsk.core.ObjectCollection.create();coll.add(o);coll.add(other)
        rs=d.analyzeInterference(d.createInterferenceInput(coll));vol=sum(q.interferenceBody.volume*1000 for q in rs)
        if vol>.001:collision.append({'part':other.component.name,'mm3':vol})
    report={'exact_body_count':len(copies),'source_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),
            'min_mm':[q*10 for q in b.minPoint.asArray()],'max_mm':[q*10 for q in b.maxPoint.asArray()],
            'camera_vs_rotor_and_rear_bracket_intersections':collision,
            'repair':'Old imported constrained occurrences hidden. Exact fresh maker B-reps transformed within identity component.',
            'status':'CAMERA_POSITION_VERIFIED; FRAME_AND_RETENTION_STILL_CONDITIONAL'}
    (OUT/'hybrid-camera-placement-final.json').write_text(json.dumps(report,indent=2)+'\n')
    for ext,fn in [('f3d',d.exportManager.createFusionArchiveExportOptions),('step',d.exportManager.createSTEPExportOptions)]:
        path=OUT/('hybrid-current.'+ext);assert not path.exists();assert d.exportManager.execute(fn(str(path)))
    app.activeViewport.fit();app.activeViewport.saveAsImageFile(str(OUT/'hybrid-current.png'),1600,1200)
    srcdoc.close(False)
    print(json.dumps(report))
