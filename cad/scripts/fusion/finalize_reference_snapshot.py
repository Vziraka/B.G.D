"""Capture revised occurrence positions, verify, and export unreleased evidence."""
import hashlib
import json
from datetime import datetime, timezone
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT=Path(r'C:\Users\zvent\Downloads\B.G.D')


def run(_context: str):
    app=adsk.core.Application.get()
    assert app.activeDocument.name=='BGD_MASTER'
    design=adsk.fusion.Design.cast(app.activeProduct)
    root=design.rootComponent
    export_dir=ROOT/'cad/exports/reference-r1'
    assert not export_dir.exists(), 'Inspect existing export instead of overwriting'
    # Extrusion edits regenerate the timeline and can reset uncaptured moves.
    # Finish parameter edits first, apply every position, then capture once.
    for occ in root.occurrences:
        name=occ.component.name
        z=None
        if name=='02_BOTTOM_INFERRED_Draw14':z=-2.5
        elif name=='03_MIDDLE_INFERRED_Draw3':z=6
        elif name.startswith('08_STANDOFF_'):z=8 if occ.transform2.translation.x*10>80 else 0
        if z is not None:
            tr=occ.transform2
            v=tr.translation
            tr.translation=adsk.core.Vector3D.create(v.x,v.y,z/10)
            occ.transform2=tr
        for body in occ.component.bRepBodies:body.name=name
    if design.snapshots.hasPendingSnapshot:design.snapshots.add()
    entities=adsk.core.ObjectCollection.create()
    bodies=[]
    for occ in root.occurrences:
        if occ.component.name.startswith(('00_','M01_55')):continue
        entities.add(occ)
        for b in occ.bRepBodies:
            bounds=b.boundingBox
            bodies.append({'component':occ.component.name,'min_mm':[bounds.minPoint.x*10,bounds.minPoint.y*10,bounds.minPoint.z*10],
                           'max_mm':[bounds.maxPoint.x*10,bounds.maxPoint.y*10,bounds.maxPoint.z*10],
                           'volume_mm3':b.volume*1000})
    results=design.analyzeInterference(design.createInterferenceInput(entities))
    pairs=[{'one':r.entityOne.name,'two':r.entityTwo.name,'volume_mm3':r.interferenceBody.volume*1000} for r in results]
    assert not pairs, pairs
    for body in bodies:
        name=body['component']
        if name=='02_BOTTOM_INFERRED_Draw14':assert abs(body['min_mm'][2]+2.5)<1e-6 and abs(body['max_mm'][2])<1e-6
        if name=='03_MIDDLE_INFERRED_Draw3':assert abs(body['min_mm'][2]-6)<1e-6 and abs(body['max_mm'][2]-8)<1e-6
        if name.startswith('08_STANDOFF_'):assert abs(body['max_mm'][2]-30)<1e-6
    export_dir.mkdir(parents=True)
    native=export_dir/'BGD_MASTER_reference-r1.f3d'
    assert design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(native)))
    adapter=next(o.component for o in root.occurrences if o.component.name=='M01_48_MM_ADAPTER_STUDY')
    step=export_dir/'M01_48mm_STUDY_NOT_FOR_FABRICATION.step'
    assert design.exportManager.execute(design.exportManager.createSTEPExportOptions(str(step),adapter))
    camera=app.activeViewport.camera
    camera.eye=adsk.core.Point3D.create(30,-35,30)
    camera.target=adsk.core.Point3D.create(0,0,0)
    camera.upVector=adsk.core.Vector3D.create(0,0,1)
    camera.viewExtents=40
    camera.isFitView=False
    app.activeViewport.camera=camera
    app.activeViewport.refresh()
    preview=export_dir/'BGD_MASTER_reference-r1.png'
    assert app.activeViewport.saveAsImageFile(str(preview),1400,1000)
    manifest={'generated_utc':datetime.now(timezone.utc).isoformat(),'fusion_version':app.version,
              'status':'UNRELEASED_REFERENCE_AND_ADAPTER_STUDY','document':'BGD_MASTER',
              'source_sha256':root.attributes.itemByName('BGD','source_sha256').value,
              'axes':'right-handed FLU; rotor-centroid XY; arm-underside Z assumed',
              'visible_solid_interference_count':len(pairs),'visible_bodies':bodies,
              'omissions':['brace','arm spacer','camera plates/mount','screws/nuts/grommets','other aircraft systems'],
              'warnings':['Not a complete aircraft or released frame assembly','Hidden raw layout and rejected 55mm study retained in F3D','STEP is one unreleased adapter blank only','Default Fusion material masses are invalid; use engineering ledger','Manufacturer bottom-thickness discrepancy unresolved'],
              'artifacts':[{'path':str(p.relative_to(ROOT)).replace('\\','/'),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in (native,step,preview)],
              'scripts':[{'path':str(p.relative_to(ROOT)).replace('\\','/'),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in sorted((ROOT/'cad/scripts/fusion').glob('*.py'))]}
    with (ROOT/'cad/assemblies/reference-r1-manifest.json').open('x',encoding='utf-8') as f:json.dump(manifest,f,indent=2)
    print(json.dumps({'interferences':len(pairs),'bodies':len(bodies),'artifacts':manifest['artifacts']}))
