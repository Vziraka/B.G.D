"""Repair observed rotor overlaps in the existing phone study; preserve first export."""
import json
import math
from pathlib import Path
import adsk.core
import adsk.fusion

OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')

def run(_context: str):
    app=adsk.core.Application.get();doc=next(d for d in app.documents if d.name=='BGD_ISSUE11_R3_PHONE');doc.activate()
    design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));root=design.rootComponent
    assert not root.attributes.itemByName('BGD','phone_clearance_repaired'),'Already repaired; inspect before retry'
    tm=adsk.fusion.TemporaryBRepManager.get()
    def pt(v):return adsk.core.Point3D.create(*[x/10 for x in v])
    def add(o,solid):
        bf=o.component.features.baseFeatures.add();bf.startEdit();o.component.bRepBodies.add(solid,bf);bf.finishEdit()
    def boxsolid(center,size):return tm.createBox(adsk.core.OrientedBoundingBox3D.create(pt(center),adsk.core.Vector3D.create(1,0,0),adsk.core.Vector3D.create(0,1,0),*[x/10 for x in size]))
    moves=[];oldfeet=[]
    for o in root.occurrences:
        n=o.component.name
        if n.startswith(('PIXEL','PHONE_BOTTOM','PHONE_TOP','PHONE_LEFT','PHONE_RIGHT','PHONE_EDGE','VL49','LAMP_')):
            m=o.transform2;m.translation=adsk.core.Vector3D.create(0,0,.5);o.transform2=m;moves.append(n)
        if n.startswith('PHONE_SUPPORT_INTERFACE'):
            x=-22 if n.endswith('-22') else 22
            add(o,boxsolid([x,-95,66],[5,12,5]))
        if n.startswith(('LANDING_LEG','LANDING_FOOT')):oldfeet.append(o)
    for o in oldfeet:o.deleteMe()
    for x in [-60,60]:
        for y in [-75,75]:
            for n,solid in [
                ('SPLAYED_LEG',tm.createCylinderOrCone(pt([math.copysign(22,x),y,-1]),.3,pt([x,y,-39]),.3)),
                ('LANDING_FOOT',boxsolid([x,y,-41],[22,12,3]))]:
                o=root.occurrences.addNewComponent(adsk.core.Matrix3D.create());o.component.name=f'{n}_{x}_{y}'
                o.component.attributes.add('BGD','representation','DESIGNED_PRINT_CANDIDATE_NOT_FABRICATION_RELEASE');add(o,solid)
    design.userParameters.itemByName('Phone_phone_z').expression='110 mm'
    root.attributes.add('BGD','phone_clearance_repaired','phone/lamp+5mm; legs splayed to±60mm')
    if design.snapshots.hasPendingSnapshot:design.snapshots.add()
    rotors=[o for o in root.occurrences if o.component.name.startswith('ROTOR')]
    collisions=[];parts=[];printmass={}
    for o in root.occurrences:
        n=o.component.name;kind=o.component.attributes.itemByName('BGD','representation').value
        b=o.boundingBox;volume=sum(x.volume*1000 for x in o.component.bRepBodies)
        if kind.startswith('DESIGNED_PRINT'):printmass[n]=volume*.00127
        parts.append({'name':n,'kind':kind,'min_mm':[x*10 for x in b.minPoint.asArray()],'max_mm':[x*10 for x in b.maxPoint.asArray()],'volume_mm3':volume})
        tested=kind.startswith('DESIGNED_PRINT') or n.startswith(('PIXEL7','VL49','NEXUS4','MICOAIR','ADAFRUIT','TPM2','CP2102','ELRS','GNSS','TOFSENSE','TFMINI_DOWN'))
        if not tested:continue
        for rotor in rotors:
            if not o.boundingBox.intersects(rotor.boundingBox):continue
            collection=adsk.core.ObjectCollection.create();collection.add(o);collection.add(rotor)
            result=design.analyzeInterference(design.createInterferenceInput(collection))
            vol=sum(i.interferenceBody.volume*1000 for i in result)
            if vol>.01:collisions.append({'a':n,'b':rotor.component.name,'mm3':vol})
    result={'status':'NATIVE_PACKAGING_STUDY_NOT_FABRICATION_OR_FLIGHT_RELEASE','phone_optical_body_z_mm':110,'moved_parts':moves,
        'rotor_intersections':collisions,'full_density_prints_g':sum(printmass.values()),'print_mass_by_part_g':printmass,'parts':parts,
        'source_dimensions':'440mmframe /254mmprops /5mmradialreserve /36..64mmC4rotorsweep',
        'critical_gaps':['Makerframeweightcontradictsformer277gallocation','P50Bsourceenergydoesnotestablish115Whto13V','Exactframeattachmentpositions','Printerstructuralcreep/impact/retentionhardware','Cameraopticaldatum/USB/buttonclearance','Lamp/ToFfieldgeometry','Noactualbackpackfit']}
    (OUT/'phone-layout-current.json').write_text(json.dumps(result,indent=2)+'\n')
    assert design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(OUT/'phone-layout-current.f3d')))
    assert design.exportManager.execute(design.exportManager.createSTEPExportOptions(str(OUT/'phone-layout-current.step')))
    app.activeViewport.fit();app.activeViewport.saveAsImageFile(str(OUT/'phone-layout-current.png'),1600,1200)
    print(json.dumps({'rotor_intersections':collisions,'print_mass_g':sum(printmass.values()),'parts':len(parts)}))

