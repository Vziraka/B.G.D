"""Capture occurrence positions after timeline edits; verify camera/mount context."""
import json,math
from pathlib import Path
import adsk.core,adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
def run(_context:str):
    app=adsk.core.Application.get();doc=next(d for d in app.documents if d.name=='BGD_R3_HYBRID');doc.activate()
    design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));root=design.rootComponent
    def p(v):return adsk.core.Point3D.create(*[x/10 for x in v])
    def v(a):return adsk.core.Vector3D.create(*a)
    def tr(t,angle=0,axis=[1,0,0]):
        m=adsk.core.Matrix3D.create();m.setToRotation(angle,v(axis),p([0,0,0]));m.translation=v([x/10 for x in t]);return m
    a=650/(2*math.sqrt(2));positions={
        'PAYLOAD_DECK_FLAT_CANDIDATE':tr([0,0,50]),
        'BATTERY_TRAY_FLAT_CANDIDATE':tr([0,20,-86]),
        'OAK_REAR_U_BRIDGE_CANDIDATE':tr([0,-103.5,70],math.pi/2)}
    for i,(sx,sy) in enumerate([(1,1),(-1,1),(-1,-1),(1,-1)],1):
        positions[f'TL68B51_{i}_DIMENSION_PATTERN']=tr([sx*a,sy*a,8],math.atan2(sy,sx),[0,0,1])
    camera=[]
    for o in root.occurrences:
        if o.component.name.startswith(('606-','609-','611-','612-','602-')):
            o.transform2=tr([-44.5,-121.5,81.75],math.pi/2);camera.append(o)
        elif o.component.name in positions:o.transform2=positions[o.component.name]
    assert design.snapshots.hasPendingSnapshot
    design.snapshots.add()
    data=json.loads((OUT/'hybrid-layout.json').read_text())
    records=[]
    for o in root.occurrences:
        b=o.boundingBox;records.append({'name':o.component.name,'min_mm':[q*10 for q in b.minPoint.asArray()],
            'max_mm':[q*10 for q in b.maxPoint.asArray()],'transform':o.transform2.asArray()})
    data['positions_repaired_and_captured']=True;data['captured_parts']=records
    checks=[]
    rotors=[o for o in root.occurrences if o.component.name.startswith('ROTOR_')]
    moving=camera+[o for o in root.occurrences if o.component.name in positions and not o.component.name.startswith('TL68')]
    for first in moving:
        for second in rotors:
            if not first.boundingBox.intersects(second.boundingBox):continue
            coll=adsk.core.ObjectCollection.create();coll.add(first);coll.add(second)
            result=design.analyzeInterference(design.createInterferenceInput(coll))
            volume=sum(r.interferenceBody.volume*1000 for r in result)
            if volume>.001:checks.append({'a':first.fullPathName,'b':second.fullPathName,'mm3':volume})
    data['captured_position_rotor_intersections']=checks
    (OUT/'hybrid-layout-captured.json').write_text(json.dumps(data,indent=2)+'\n')
    for suffix,options in [('f3d',design.exportManager.createFusionArchiveExportOptions),('step',design.exportManager.createSTEPExportOptions)]:
        path=OUT/('hybrid-layout-captured.'+suffix);assert not path.exists();assert design.exportManager.execute(options(str(path)))
    cam=app.activeViewport.camera;cam.eye=p([850,-1000,650]);cam.target=p([0,0,20]);cam.upVector=v([0,0,1]);cam.isFitView=True
    app.activeViewport.camera=cam;app.activeViewport.fit();app.activeViewport.saveAsImageFile(str(OUT/'hybrid-layout-captured.png'),1600,1200)
    print(json.dumps({'camera_top_occurrences':len(camera),'corrected_rotor_intersections':checks}))
