"""Apply reviewed local corrections, measure after recompute, export local evidence."""
import hashlib
import json
import math
import re
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT=Path(r'C:\Users\zvent\Downloads\B.G.D')
OUT=ROOT/'cad/engineering-r2-2026-09-10'
def run(_context: str):
    app=adsk.core.Application.get()
    doc=next(d for d in app.documents if d.name=='BGD_ISSUE11_R2');doc.activate()
    design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    root=design.rootComponent
    data=json.loads((OUT/'assembly-inputs.json').read_text())
    group=next(o for o in root.occurrences if o.component.name=='R2_DETAIL_'+data['revision'])
    items={re.sub(r' \(\d+\)$','',o.component.name):o.createForAssemblyContext(group) for o in group.component.occurrences}
    for name,occ in items.items():occ.component.attributes.add('BGD','canonical_name',name)
    adapter=items['AIO_45_FR4_ADAPTER'].component
    for c in adapter.sketches.item(0).sketchCurves.sketchCircles:
        if abs(c.radius-.11)<1e-6:c.radius=.12
    for name,p in data['parameters'].items():
        parameter=design.userParameters.itemByName('R2_'+name)
        if parameter:parameter.expression=str(p['value'])+' mm'
    for p in data['parts']:
        if p['shape'].endswith('_strut'):continue
        tr=adsk.core.Matrix3D.create();tr.setToRotation(math.radians(p['angle']),adsk.core.Vector3D.create(0,0,1),adsk.core.Point3D.create(0,0,0))
        x,y,z=p['center'];tr.translation=adsk.core.Vector3D.create(x/10,y/10,(z-p['size'][2]/2)/10)
        items[p['name']].transform2=tr
    fan=next(o for o in root.occurrences if o.component.name=='R2_NOCTUA_MANUFACTURER_REFERENCE')
    tr=adsk.core.Matrix3D.create();tr.setToRotation(math.pi/2,adsk.core.Vector3D.create(1,0,0),adsk.core.Point3D.create(0,0,0))
    fc=data['fan_center_mm'];tr.translation=adsk.core.Vector3D.create(fc[0]/10,fc[1]/10,(fc[2]-5.2963057257)/10)
    fan.transform2=tr
    if design.snapshots.hasPendingSnapshot:design.snapshots.add()
    assert design.computeAll()
    app.activeViewport.refresh()
    records=[]
    for p in data['parts']:
        occ=items[p['name']]
        bodies=list(occ.bRepBodies)
        assert bodies
        lo=[min(b.boundingBox.minPoint.asArray()[i]*10 for b in bodies) for i in range(3)]
        hi=[max(b.boundingBox.maxPoint.asArray()[i]*10 for b in bodies) for i in range(3)]
        assert all(hi[i]>lo[i] for i in range(3)),p['name']
        records.append({'name':p['name'],'native_name':occ.component.name,'kind':p['kind'],'material_basis':p['material'],'hold':p['hold'],
                        'volume_mm3':sum(b.volume for b in bodies)*1000,'min_mm':lo,'max_mm':hi,'bodies':len(bodies),'visible':occ.isLightBulbOn})
    digest=hashlib.sha256((OUT/'assembly-inputs.json').read_bytes()).hexdigest()
    group.component.attributes.add('BGD','input_sha256',digest)
    health=[]
    for comp in design.allComponents:
        for feature in comp.features.extrudeFeatures:
            if int(feature.healthState)!=0:health.append({'name':feature.name,'health':int(feature.healthState),'message':feature.errorOrWarningMessage})
    result={'status':'RECOMPUTED_NATIVE_DIMENSIONS_NOT_PHYSICAL_PROOF','input_sha256':digest,'parts':records,'timeline_health':health,
            'corrections':['M2 adapter holes2.4mm','Fan moved3mm above secondary shroud','Post-recompute BRep bounding boxes replace invalid during-build cached zero boxes'],
            'mass_basis':'Do not use default solid-envelope densities. Exact custom volumes plus sourced material density and manufacturer component mass are separate.'}
    (OUT/'fusion-build.json').write_text(json.dumps(result,indent=2)+'\n')
    export=OUT/'exports';export.mkdir(exist_ok=True)
    paths=[]
    native=export/'BGD_ISSUE11_R2_CONDITIONAL.f3d'
    assert design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(native)));paths.append(native)
    whole=export/'BGD_ISSUE11_R2_VISIBLE_ASSEMBLY_NOT_FOR_FABRICATION.step'
    options=design.exportManager.createSTEPExportOptions(str(whole),root)
    options.isIncludingInvisibleBodies=False;options.isIncludingInvisibleComponents=False
    assert design.exportManager.execute(options);paths.append(whole)
    detail=export/'R2_DETAIL_ONLY_NOT_FRAME_NOT_FOR_FABRICATION.step'
    assert design.exportManager.execute(design.exportManager.createSTEPExportOptions(str(detail),group.component));paths.append(detail)
    for name in ('FAN_SECONDARY_BRIDGE','BATTERY_TPU_PAD','FOOT_TPU_SECONDARY_0'):
        comp=items[name].component
        step=export/(name+'_NOT_FOR_FABRICATION.step')
        assert design.exportManager.execute(design.exportManager.createSTEPExportOptions(str(step),comp));paths.append(step)
        stl=export/(name+'_NOT_FOR_FABRICATION.stl')
        opt=design.exportManager.createSTLExportOptions(comp,str(stl));opt.sendToPrintUtility=False;opt.isBinaryFormat=True
        assert design.exportManager.execute(opt);paths.append(stl)
    manifest={'status':'CONDITIONAL_DESIGN_ARTIFACTS_NOT_MANUFACTURING_RELEASE','fusion_version':app.version,'input_sha256':digest,
              'artifacts':[{'path':p.relative_to(ROOT).as_posix(),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in paths],
              'archive_contents':'Pinned frame and maker fan; current146part R2D design and hidden rejected R2A/B/C history. Visible assembly STEP excludes hidden history and keepouts; separate detail STEP excludes original frame/fan. Printed-part STEP/STL are independent custom secondary designs only; no commercial fan copied for manufacture.',
              'reopen_verification':'Pending separate round-trip read'}
    (OUT/'export-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print(json.dumps({'parts':len(records),'timeline_health_findings':len(health),'artifacts':len(paths)}))
