"""Read the existing hypothesis without promoting it to a verified frame stack."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT=Path(r'C:\Users\zvent\Downloads\B.G.D')


def run(_context: str):
    app=adsk.core.Application.get()
    assert app.activeDocument.name=='BGD_MASTER'
    design=adsk.fusion.Design.cast(app.activeProduct)
    root=design.rootComponent
    expected=json.loads((ROOT/'cad/assemblies/reference-r1-manifest.json').read_text())
    assert root.attributes.itemByName('BGD','source_sha256').value==expected['source_sha256']
    visible={o.component.name:o for o in root.occurrences if not o.component.name.startswith(('00_','M01_55'))}
    assert set(visible)=={b['component'] for b in expected['visible_bodies']}
    for record in expected['visible_bodies']:
        b=visible[record['component']].bRepBodies.item(0)
        assert abs(b.volume*1000-record['volume_mm3'])<.02
        for point,key in [(b.boundingBox.minPoint,'min_mm'),(b.boundingBox.maxPoint,'max_mm')]:
            assert max(abs(a*10-c) for a,c in zip((point.x,point.y,point.z),record[key]))<.001
    adapter=visible['M01_48_MM_ADAPTER_STUDY'].bRepBodies.item(0)
    distances=[]
    for name,o in visible.items():
        if name=='M01_48_MM_ADAPTER_STUDY':continue
        b=o.bRepBodies.item(0)
        d=app.measureManager.measureMinimumDistance(adapter,b).value*10
        distances.append({'peer':name,'minimum_distance_mm':d})
    entities=adsk.core.ObjectCollection.create()
    for o in visible.values():entities.add(o)
    result=design.analyzeInterference(design.createInterferenceInput(entities))
    slots=[]
    for name,o in visible.items():
        if not name.endswith('_ARM'):continue
        s=o.component.sketches.item(0)
        p=max(s.profiles,key=lambda p:p.areaProperties().area)
        for loop in p.profileLoops:
            if loop.isOuter:continue
            curves=list(loop.profileCurves)
            lo=[min(getattr(c.boundingBox.minPoint,k)*10 for c in curves) for k in ('x','y')]
            hi=[max(getattr(c.boundingBox.maxPoint,k)*10 for c in curves) for k in ('x','y')]
            center=[(a+b)/2 for a,b in zip(lo,hi)]
            if abs(center[1])<70:continue
            arcs=[]
            for c in curves:
                arc=adsk.core.Arc3D.cast(c.geometry)
                if arc:arcs.append({'center_mm':[arc.center.x*10,arc.center.y*10],'radius_mm':arc.radius*10,
                                    'sweep_radians':arc.endAngle-arc.startAngle})
            slots.append({'arm':name,'min_xy_mm':lo,'max_xy_mm':hi,'curve_count':len(curves),'arcs':arcs})
    report={'source_sha256':expected['source_sha256'],'scope':'READ_ONLY_CHECK_OF_EXISTING_HYPOTHESIS_B_NOT_CORRECTED_AUTHORITATIVE_STACK',
            'geometry_matches_reference_r1':True,'interference_count_partial_model':result.count,
            'adapter_distances':distances,'motor_mount_inner_loops':slots,
            'not_verified':['actual plate identity/Z stack','damper/mount clearance','USB/SD plug/card access','power-wire bends','bus/harness routes','screw depths/engagement','airflow/servicing'],
            'reason':'Only the frozen partial reference is present. No absent component is counted as clearance evidence.'}
    output=ROOT/'cad/reference/source-one-v6-7in/revision-checkpoint-cad-audit.json'
    with output.open('w',encoding='utf-8') as f:json.dump(report,f,indent=2)
    print(json.dumps({'scope':report['scope'],'interference_count':result.count,'adapter_distances':distances,'motor_loops':len(slots)}))
