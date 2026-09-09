"""Reject the first stack hypothesis using the standard mounting-hole paths."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion


def run(_context: str):
    app=adsk.core.Application.get()
    assert app.activeDocument.name=='BGD_MASTER'
    design=adsk.fusion.Design.cast(app.activeProduct)
    root=design.rootComponent
    output=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\reference\source-one-v6-7in\fusion-stack-revision.json')
    assert not output.exists()
    assert root.occurrences.item(2).component.name=='02_MIDDLE_INFERRED_Draw14'
    for index,name,z,t in [(2,'02_BOTTOM_INFERRED_Draw14',-2.5,2.5),(3,'03_MIDDLE_INFERRED_Draw3',6,2)]:
        occ=root.occurrences.item(index)
        occ.component.name=name
        occ.component.bRepBodies.item(0).name=name
        tr=occ.transform2
        tr.translation=adsk.core.Vector3D.create(0,0,z/10)
        occ.transform2=tr
        occ.component.features.extrudeFeatures.item(0).extentOne.distance.expression=str(t)+' mm'
    for occ in root.occurrences:
        if not occ.component.name.startswith('08_STANDOFF_'):continue
        tr=occ.transform2
        v=tr.translation
        z=8 if v.x*10>80 else 0
        tr.translation=adsk.core.Vector3D.create(v.x,v.y,z/10)
        occ.transform2=tr
        occ.component.features.extrudeFeatures.item(0).extentOne.distance.expression=str(30-z)+' mm'
    centers=[(60.472002+a*15.25,b*15.25) for a in (-1,1) for b in (-1,1)]
    middle=root.occurrences.item(3).component.bRepBodies.item(0)
    checks=[]
    for x,y in centers:
        is_solid=middle.pointContainment(adsk.core.Point3D.create(x/10,y/10,.1))==adsk.fusion.PointContainment.PointInsidePointContainment
        assert not is_solid
        checks.append({'mount_x_mm':x,'mount_y_mm':y,'nominal_axis_through_middle_hole':'PASS'})
    selection=adsk.core.ObjectCollection.create()
    for occ in root.occurrences:
        if occ.component.name.startswith(('00_','M01_55')):continue
        selection.add(occ)
    result=design.analyzeInterference(design.createInterferenceInput(selection))
    report={'status':'PROVISIONAL_ASSEMBLY_HYPOTHESIS_B_NOT_MANUFACTURER_VERIFIED',
            'supersedes':'fusion-solid-verification.json initial Z/plate-role hypothesis A; areas and copied profiles remain valid',
            'reason':'Hypothesis A places solid Draw14 over all four 30.5mm mounting axes; B puts the perforated Draw3 above arms and the press-nut Draw14 below arms',
            'stack_mm':{'Draw14_bottom':[-2.5,0],'arms':[0,6],'Draw3_middle':[6,8],'Draw13_top':[30,32],
                        'front_standoffs':[8,30],'rear_standoffs':[0,30]},
            'checks':checks,'solid_interferences_excluding_rejected_adapter_and_raw_references':result.count,
            'new_source_discrepancy':'Pinned July DXF labels both middle/bottom layouts 2mm; current TBS product specifies bottom 2.5mm. Product thickness used as provisional installed input; supplier confirmation required.',
            'unresolved':['Manufacturer-approved layer/assembly identification','Complete brace, spacer, camera and fastener stack','Received frame revision and thickness','Fastener/grommet and connector service paths']}
    with output.open('x',encoding='utf-8') as f:json.dump(report,f,indent=2)
    print(json.dumps(report))
