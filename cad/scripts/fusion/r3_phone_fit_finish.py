"""Finish observed packaging support/window corrections; export an honest fit study."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
def run(_context:str):
    app=adsk.core.Application.get();doc=next(d for d in app.documents if d.name=='BGD_ISSUE11_R3_PHONE');doc.activate()
    d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent
    assert not r.attributes.itemByName('BGD','phone_support_finish')
    tm=adsk.fusion.TemporaryBRepManager.get()
    def box(name,center,size):
        o=r.occurrences.addNewComponent(adsk.core.Matrix3D.create());o.component.name=name
        o.component.attributes.add('BGD','representation','DESIGNED_PRINT_CANDIDATE_NOT_FABRICATION_RELEASE')
        p=adsk.core.Point3D.create(*[x/10 for x in center])
        body=tm.createBox(adsk.core.OrientedBoundingBox3D.create(p,adsk.core.Vector3D.create(1,0,0),adsk.core.Vector3D.create(0,1,0),*[x/10 for x in size]))
        bf=o.component.features.baseFeatures.add();bf.startEdit();o.component.bRepBodies.add(body,bf);bf.finishEdit()
    for o in list(r.occurrences):
        if o.component.name.startswith('PHONE_RIGHT_SPLIT_RAIL'):o.deleteMe()
    box('PHONE_RIGHT_LOWER_USB_CLEAR',[81,-94,87.5],[3,16,20])
    box('PHONE_RIGHT_UPPER_USB_CLEAR',[81,-94,133.5],[3,16,22])
    for y in [18,72]:box('BATTERY_CROSS_SUPPORT_'+str(y),[0,y,38],[54,8,4])
    r.attributes.add('BGD','phone_support_finish','battery supported atz40+1mmfoam; USBclearwindow25mm')
    adsk.doEvents();app.activeViewport.refresh()
    result=json.loads((OUT/'phone-layout-verified.json').read_text());parts=[];pm={};collisions=[]
    rotors=[o for o in r.occurrences if o.component.name.startswith('ROTOR')]
    for o in r.occurrences:
        b=o.boundingBox;kind=o.component.attributes.itemByName('BGD','representation').value
        vol=sum(x.volume*1000 for x in o.component.bRepBodies)
        if kind.startswith('DESIGNED_PRINT'):pm[o.component.name]=vol*.00127
        parts.append({'name':o.component.name,'kind':kind,'min_mm':[x*10 for x in b.minPoint.asArray()],'max_mm':[x*10 for x in b.maxPoint.asArray()],'volume_mm3':vol})
        if not (kind.startswith('DESIGNED_PRINT') or o.component.name.startswith(('PIXEL7','VL49','NEXUS4','MICOAIR','ADAFRUIT','TPM2','CP2102','ELRS','GNSS','TOFSENSE','TFMINI_DOWN'))):continue
        for rotor in rotors:
            if not b.intersects(rotor.boundingBox):continue
            collection=adsk.core.ObjectCollection.create();collection.add(o);collection.add(rotor)
            rs=d.analyzeInterference(d.createInterferenceInput(collection));v=sum(x.interferenceBody.volume*1000 for x in rs)
            if v>.01:collisions.append({'part':o.component.name,'rotor':rotor.component.name,'mm3':v})
    result.update(parts=parts,rotor_intersections=collisions,full_density_prints_g=sum(pm.values()),print_mass_by_part_g=pm,
        material_density_assumption_g_cm3=1.27,USB_window_height_mm=25,battery_support_top_z_mm=40,battery_foam_allowance_mm=1,
        phone_foam_top_bottom_mm=1.9,status='COHERENT_NATIVE_PACKAGING_STUDY_AIRFRAME_ENERGY_AND_MASS_FAILED_NOT_FABRICATION_RELEASE')
    (OUT/'phone-layout-fit.json').write_text(json.dumps(result,indent=2)+'\n')
    assert d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(OUT/'phone-layout-fit.f3d')))
    assert d.exportManager.execute(d.exportManager.createSTEPExportOptions(str(OUT/'phone-layout-fit.step')))
    app.activeViewport.fit();app.activeViewport.saveAsImageFile(str(OUT/'phone-layout-fit.png'),1600,1200)
    print(json.dumps({'printmass':sum(pm.values()),'rotor_intersections':collisions,'parts':len(parts)}))
