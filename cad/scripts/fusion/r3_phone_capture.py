"""Capture moves after all feature edits and verify resulting native positions."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
def run(_context:str):
    app=adsk.core.Application.get();doc=next(d for d in app.documents if d.name=='BGD_ISSUE11_R3_PHONE');doc.activate()
    d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent;d.timeline.moveToEnd()
    for o in r.occurrences:
        if o.component.name.startswith(('PIXEL','PHONE_BOTTOM','PHONE_TOP','PHONE_LEFT','PHONE_RIGHT','PHONE_EDGE','VL49','LAMP_','AIO_INSULATING')):
            m=adsk.core.Matrix3D.create();m.translation=adsk.core.Vector3D.create(0,0,.5);o.transform2=m
    assert d.snapshots.hasPendingSnapshot;d.snapshots.add();adsk.doEvents();app.activeViewport.refresh()
    result=json.loads((OUT/'phone-layout-current.json').read_text());result['parts']=[];collisions=[]
    rotors=[o for o in r.occurrences if o.component.name.startswith('ROTOR')]
    for o in r.occurrences:
        b=o.boundingBox;kind=o.component.attributes.itemByName('BGD','representation').value
        result['parts'].append({'name':o.component.name,'kind':kind,'min_mm':[x*10 for x in b.minPoint.asArray()],'max_mm':[x*10 for x in b.maxPoint.asArray()],'transform':o.transform2.asArray(),'volume_mm3':sum(x.volume*1000 for x in o.component.bRepBodies)})
        if o.component.name.startswith('PHONE_BOTTOM'):
            assert b.minPoint.z*10>68,'Move not evaluated/captured'
        if not (kind.startswith('DESIGNED_PRINT') or o.component.name.startswith(('PIXEL7','VL49','NEXUS4','MICOAIR','ADAFRUIT','TPM2','CP2102','ELRS','GNSS','TOFSENSE','TFMINI_DOWN'))):continue
        for rotor in rotors:
            if not b.intersects(rotor.boundingBox):continue
            c=adsk.core.ObjectCollection.create();c.add(o);c.add(rotor)
            rs=d.analyzeInterference(d.createInterferenceInput(c));vol=sum(i.interferenceBody.volume*1000 for i in rs)
            if vol>.01:collisions.append({'a':o.component.name,'b':rotor.component.name,'mm3':vol})
    result['rotor_intersections']=collisions;result['positions_captured_after_all_feature_edits']=True
    (OUT/'phone-layout-verified.json').write_text(json.dumps(result,indent=2)+'\n')
    assert d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(OUT/'phone-layout-verified.f3d')))
    assert d.exportManager.execute(d.exportManager.createSTEPExportOptions(str(OUT/'phone-layout-verified.step')))
    app.activeViewport.fit();app.activeViewport.saveAsImageFile(str(OUT/'phone-layout-verified.png'),1600,1200)
    print(json.dumps({'rotor_intersections':collisions,'phone_body_minz_mm':next(x for x in result['parts'] if x['name']=='PIXEL7_GOOGLE_BODY')['min_mm'][2]}))
