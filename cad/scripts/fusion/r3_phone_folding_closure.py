"""Close phone fastener/camera-side capture and source-informed USB routing."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')

def run(_context:str):
    app=adsk.core.Application.get();doc=next(d for d in app.documents if d.name=='BGD_ISSUE11_R3_PHONE_FOLDING');doc.activate()
    d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent
    assert not r.attributes.itemByName('BGD','phone_usb_closure'),'Inspect partial operation before retry'
    tm=adsk.fusion.TemporaryBRepManager.get()
    def pt(v):return adsk.core.Point3D.create(*[x/10 for x in v])
    def boxsolid(c,s):return tm.createBox(adsk.core.OrientedBoundingBox3D.create(pt(c),adsk.core.Vector3D.create(1,0,0),adsk.core.Vector3D.create(0,1,0),*[x/10 for x in s]))
    def cylinder(a,b,rr):return tm.createCylinderOrCone(pt(a),rr/10,pt(b),rr/10)
    def add(n,b,kind='DESIGNED_PRINT_CANDIDATE_NOT_FABRICATION_RELEASE'):
        o=r.occurrences.addNewComponent(adsk.core.Matrix3D.create());o.component.name=n;o.component.attributes.add('BGD','representation',kind)
        f=o.component.features.baseFeatures.add();f.startEdit();o.component.bRepBodies.add(b,f);f.finishEdit();return o
    def box(n,c,s,kind='DESIGNED_PRINT_CANDIDATE_NOT_FABRICATION_RELEASE',cuts=()):
        b=boxsolid(c,s)
        for cut in cuts:assert tm.booleanOperation(b,cut,adsk.fusion.BooleanTypes.DifferenceBooleanType)
        return add(n,b,kind)
    removed=('PHONE_TOP_M3','PHONE_LEFT_END','PHONE_RIGHT_','PHONE_M3_CLOSURE','PHONE_EDGE_FRONT','ADAFRUIT2998','TPM2GO','CP2102N','PIXEL_CAMERA_BAR')
    for o in list(r.occurrences):
        if o.component.name.startswith(removed):o.deleteMe()
    holes=[cylinder([x,-94,137],[x,-94,154],1.6) for x in [-84.5,84.5]]
    box('PHONE_TOP_M3_BAR_NUTPOCKET',[0,-94,150],[180,16,3],cuts=holes)
    #5.8wideX holds5.5AF nut flats;2.6height accepts2.4high DIN934 nut.
    #Pocket opens on screen sideY=-86 for insertion; no camera-side obstruction.
    for x in [-84.5,84.5]:
        pocket=boxsolid([x,-90,143.8],[5.8,14,2.6])
        if x<0:box('PHONE_LEFT_NUT_BOSS',[x,-94,110],[10,16,77],cuts=(holes[0],pocket))
        else:
            box('PHONE_RIGHT_LOWER_USB_OPEN',[x,-94,87.5],[10,16,20])
            box('PHONE_RIGHT_UPPER_NUT_BOSS',[x,-94,135.5],[10,16,26],cuts=(holes[1],pocket))
        add('M3X12_SCREW_REFERENCE_'+str(x),cylinder([x,-94,140.5],[x,-94,152.5],1.5),'M3X12_SHANK_PLUS1MM_WASHER_STACK_CANDIDATE')
        box('DIN934_NUT_ENVELOPE_'+str(x),[x,-94,143.8],[5.5,6.35,2.4],'SOURCE5_5AF2_4THICK_NUT_BOUNDING_BOX_NOT_HEX_SOLID')
    for x in [-77,77]:
        for z in [76,143]:box('PHONE_SCREEN_SIDE_CAPTURE_'+str(x)+'_'+str(z),[x,-89.5,z],[7,2,8])
    for x,z in [(77,76),(77,143),(0,76)]:box('PHONE_REAR_CAPTURE_AWAY_FROM_CAMERA_'+str(x)+'_'+str(z),[x,-100.5,z],[7,2,8])
    camera=box('PIXEL_FULL_CAMERA_BAR_RESERVE',[-57,-101,110],[42,8,73.2],'C4_WHOLE_CAMERA_BAR_RESERVE_NOT_EXACT_OPTICAL_DATUM');camera.isLightBulbOn=False
    #Actual hub image:3topA ports +1endA. Install inverted, top ports face down.
    hub=box('ADAFRUIT2998_INVERTED',[50,-45,65],[24.5,71.5,18],'MAKER_BODY_THREE_TOP_ONE_END_PORT_INVERTED_C4_PORT_DATUM')
    for x in [38,62]:
        box('USB_HUB_SIDE_LEDGE_'+str(x),[x,-45,54],[3,78,4])
        box('USB_HUB_POST_'+str(x),[x,-45,32.5],[3,12,43])
    for y in [-82, -8]:box('USB_HUB_END_STOP_'+str(y),[50,y,60],[30,3,12])
    box('TPM2GO_END_PORT_RESERVE',[50,12,65],[16,36,10],'C4_USB_A_TPM_DIMENSIONS_AND_ENGAGEMENT_RESERVE')
    #FactoryA-to-Cleads, no imaginary direct-plug USB-Cboards.
    for n,y,s in [('FC_CP2102N',-40,[30,18,5]),('TOF_CP2102N',-5,[30,18,5]),('MCP2221A',30,[27,17.7,5])]:
        box(n+'_USB_C_BOARD',[-50,y,20],s,'MAKER_BOARD_OUTER_DIMENSIONS_CONNECTOR_DATUM_PENDING')
        box(n+'_TRAY',[-50,y,16],[36,24,2])
        for x in [-68,-32]:box(n+'_EDGE_'+str(x),[x,y,20],[2,24,6])
        #Two3.2x12tie slots pertray, retained cable/board loop without adhesive-onlysupport.
        for yy in [y-9,y+9]:
            box(n+'_TIE_ANCHOR_'+str(yy),[-50,yy,15],[16,5,4],cuts=(boxsolid([-50,yy,15],[11,3.2,8]),))
    #ThreeAplugs pointdown toZ31; cablegoesunderpack atZ25 withC4bend reservation.
    for idx,y in enumerate([-63,-44,-25],1):
        box('USB_A_DOWN_PLUG_'+str(idx),[50,y,43.5],[16,8,25],'C4_FACTORY4472_PLUG_RESERVE_NOT_MAKER_CONNECTOR_SOLID')
        box('USB_4472_ROUTE_'+str(idx),[0,y,27],[90,12,12],'C4_UNDERPACK_CABLE_BEND_CORRIDOR_FACTORY152MM').isLightBulbOn=False
    #Factoryhubcable130mm; route tohostadapter is<125mm withreservedbend, conditionaldatum.
    box('USB_HOST_ROUTE_C4',[90,-86,95],[65,28,64],'C4_FACTORY130MM_HOST_CABLE_ROUTE_REQUIRE_ACTUAL_BEND_CHECK').isLightBulbOn=False
    box('USB_PHONE_CABLE_RESTRAINT',[104,-95,84],[22,12,5],cuts=(boxsolid([104,-95,84],[12,3.2,9]),))
    #Envelope for electrical additions; masses remain electrical allocations, not printvolume.
    box('MIDI_FUSE_HOLDER_C4',[-60,65,24],[60,28,20],'C4_PURCHASED_COVERED_HOLDER_DIMENSIONS_PENDING')
    box('PACK_CASE_TEMP_C4',[15,25,77],[5,20,15],'C4_TMP117_CASE_CONTACT_AND_INSULATION')
    box('AIO_CASE_TEMP_C4',[0,0,21],[15,15,3],'C4_TMP117_CASE_CONTACT_AND_INSULATION')
    r.attributes.add('BGD','phone_usb_closure','camera-side-open M3 pockets and4occupiedUSBports')
    adsk.doEvents();app.activeViewport.refresh()
    parts=[];pm={};collisions=[];camera_hits=[]
    rotors=[o for o in r.occurrences if o.component.name.startswith('ROTOR_')]
    for o in r.occurrences:
        kind=o.component.attributes.itemByName('BGD','representation').value;b=o.boundingBox;v=sum(x.volume*1000 for x in o.component.bRepBodies)
        if kind.startswith('DESIGNED_PRINT'):pm[o.component.name]=v*.00127
        parts.append({'name':o.component.name,'kind':kind,'min_mm':[x*10 for x in b.minPoint.asArray()],'max_mm':[x*10 for x in b.maxPoint.asArray()],'volume_mm3':v})
        if not(kind.startswith('DESIGNED_PRINT') or o.component.name.startswith(('PIXEL7','VL49','NEXUS6','ADAFRUIT','TPM2','FC_CP','TOF_CP','MCP222','MIDI','PACK_CASE','AIO_CASE','USB_A_DOWN'))):continue
        for keepout in rotors+([camera] if kind.startswith('DESIGNED_PRINT') else []):
            if not b.intersects(keepout.boundingBox):continue
            g=adsk.core.ObjectCollection.create();g.add(o);g.add(keepout)
            rs=d.analyzeInterference(d.createInterferenceInput(g));volume=sum(x.interferenceBody.volume*1000 for x in rs)
            if volume>.01:(camera_hits if keepout==camera else collisions).append({'part':o.component.name,'keepout':keepout.component.name,'mm3':volume})
    result=json.loads((OUT/'phone-folding-layout.json').read_text());result.update(parts=parts,print_mass_by_part_g=pm,
        full_density_prints_g=sum(pm.values()),rotor_intersections=collisions,camera_bar_intersections=camera_hits,
        phone_fasteners={'nut_standard':'DIN934M3 AF5.5 H2.4','pocket_mm':[5.8,14,2.6],'pocket_center_z_mm':143.8,'bolt_centers_x_mm':[-84.5,84.5],'topbar_z_mm':150,'screw':'M3x12 with1mmwasher stack, verify exacthead/engagement'},
        usb={'ports':'3topinverted+1end,allfourused','leads':'3xAdafruit4472AtoC152mm;hubfactory130mm;hostadapterexactpending','remaining':'Portdatum/bendradius/strainreliefphysicalfit;C4routecorridorsnotactualcablecurves'})
    (OUT/'phone-folding-closure.json').write_text(json.dumps(result,indent=2)+'\n')
    assert d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(OUT/'phone-folding-closure.f3d')))
    assert d.exportManager.execute(d.exportManager.createSTEPExportOptions(str(OUT/'phone-folding-closure.step')))
    app.activeViewport.fit();app.activeViewport.saveAsImageFile(str(OUT/'phone-folding-closure.png'),1600,1200)
    print(json.dumps({'parts':len(parts),'printmass':sum(pm.values()),'rotor_hits':collisions,'camera_hits':camera_hits}))
