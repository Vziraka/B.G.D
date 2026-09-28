"""Repair observed fuse keepout and end-port access; export final review state."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
def run(_context:str):
    app=adsk.core.Application.get();doc=next(d for d in app.documents if d.name=='BGD_ISSUE11_R3_PHONE_FOLDING');doc.activate()
    d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent;tm=adsk.fusion.TemporaryBRepManager.get()
    assert not r.attributes.itemByName('BGD','phone_folding_final')
    def solid(c,s):return tm.createBox(adsk.core.OrientedBoundingBox3D.create(adsk.core.Point3D.create(*[x/10 for x in c]),adsk.core.Vector3D.create(1,0,0),adsk.core.Vector3D.create(0,1,0),*[x/10 for x in s]))
    def add(n,b,k):
        o=r.occurrences.addNewComponent(adsk.core.Matrix3D.create());o.component.name=n;o.component.attributes.add('BGD','representation',k)
        f=o.component.features.baseFeatures.add();f.startEdit();o.component.bRepBodies.add(b,f);f.finishEdit();return o
    for o in list(r.occurrences):
        if o.component.name in ['MIDI_FUSE_HOLDER_C4','USB_HUB_END_STOP_-8']:o.deleteMe()
    add('MIDI_FUSE_HOLDER_C4_UNDERFRAME',solid([-60,45,-24],[60,28,20]),'C4_PURCHASED_HOLDER_OUTLINE_ATTACHMENT_PENDING')
    b=solid([50,-8,60],[30,3,12]);assert tm.booleanOperation(b,solid([50,-8,64],[18,7,10]),adsk.fusion.BooleanTypes.DifferenceBooleanType)
    add('USB_HUB_END_STOP_PORT_OPEN',b,'DESIGNED_PRINT_CANDIDATE_NOT_FABRICATION_RELEASE')
    r.attributes.add('BGD','phone_folding_final','fuse below frame; endA port window open')
    adsk.doEvents();app.activeViewport.refresh()
    results=json.loads((OUT/'phone-folding-closure.json').read_text());parts=[];pm={};hits=[];camera_hits=[]
    rotors=[o for o in r.occurrences if o.component.name.startswith('ROTOR_')]
    camera=next(o for o in r.occurrences if o.component.name=='PIXEL_FULL_CAMERA_BAR_RESERVE')
    for o in r.occurrences:
        k=o.component.attributes.itemByName('BGD','representation').value;b=o.boundingBox;volume=sum(t.volume*1000 for t in o.component.bRepBodies)
        if k.startswith('DESIGNED_PRINT'):pm[o.component.name]=volume*.00127
        parts.append({'name':o.component.name,'kind':k,'min_mm':[x*10 for x in b.minPoint.asArray()],'max_mm':[x*10 for x in b.maxPoint.asArray()],'volume_mm3':volume})
        if not(k.startswith('DESIGNED_PRINT') or o.component.name.startswith(('PIXEL7','VL49','NEXUS6','ADAFRUIT','TPM2','FC_CP','TOF_CP','MCP222','MIDI','PACK_CASE','AIO_CASE','USB_A_DOWN'))):continue
        for keep in rotors+([camera] if k.startswith('DESIGNED_PRINT') else []):
            if not b.intersects(keep.boundingBox):continue
            g=adsk.core.ObjectCollection.create();g.add(o);g.add(keep)
            rs=d.analyzeInterference(d.createInterferenceInput(g));v=sum(t.interferenceBody.volume*1000 for t in rs)
            if v>.01:(camera_hits if keep==camera else hits).append({'part':o.component.name,'keepout':keep.component.name,'mm3':v})
    results.update(parts=parts,print_mass_by_part_g=pm,full_density_prints_g=sum(pm.values()),rotor_intersections=hits,camera_bar_intersections=camera_hits,
        status='NATIVE_FINAL_REVIEW_STUDY_NOT_MANUFACTURE_RELEASE',fuse_center_mm=[-60,45,-24],usb_end_port_opening_mm=[18,10])
    (OUT/'phone-folding-final.json').write_text(json.dumps(results,indent=2)+'\n')
    assert d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(OUT/'phone-folding-final.f3d')))
    assert d.exportManager.execute(d.exportManager.createSTEPExportOptions(str(OUT/'phone-folding-final.step')))
    app.activeViewport.fit();app.activeViewport.saveAsImageFile(str(OUT/'phone-folding-final.png'),1600,1200)
    print(json.dumps({'parts':len(parts),'prints_g':sum(pm.values()),'rotor_hits':hits,'camera_hits':camera_hits}))
