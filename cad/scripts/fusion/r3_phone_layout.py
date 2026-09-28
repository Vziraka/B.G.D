"""Native phone-aircraft integration study; sourced dimensions and marked C4 envelopes."""
import csv
import json
import math
from pathlib import Path
import adsk.core
import adsk.fusion

OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
DOC='BGD_ISSUE11_R3_PHONE'

def run(_context: str):
    app=adsk.core.Application.get()
    assert not any(d.name==DOC for d in app.documents),'Inspect existing phone study before retry'
    doc=app.documents.add(adsk.core.DocumentTypes.FusionDesignDocumentType);doc.name=DOC
    design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    root=design.rootComponent
    tm=adsk.fusion.TemporaryBRepManager.get()
    params=[('wheelbase',440,'Current maker dimension image; previous402 text conflicts'),
            ('prop_diameter',254,'APC10x5E diameter'),('tracking_allowance',5,'Unverified radial reserve'),
            ('phone_width',155.6,'Google landscape handset length'),('phone_height',73.2,'Google handset width'),
            ('phone_depth',8.7,'Google body thickness; camera bump reserved separately'),
            ('phone_z',105,'Designed optical height above rotor sweep'),('phone_y',-95,'Designed forward installation'),
            ('pack_x',48,'Nexus bare pack dimension'),('pack_y',93,'Nexus bare pack dimension'),
            ('pack_z',72,'Nexus bare pack dimension'),('pack_aft',45,'Designed CG trim'),
            ('frame_plate_width',64,'C4 center outline reservation, NOT maker CAD'),
            ('frame_plate_length',240,'C4 center outline reservation'),('print_wall',3,'CandidatePETGwall'),
            ('stack_pitch',30.5,'Maker frame mounting diagram'),('aio_pitch',25.5,'MicoAir board pattern')]
    for n,v,note in params:design.userParameters.add('Phone_'+n,adsk.core.ValueInput.createByString(f'{v} mm'),'mm',note)
    def pt(v):return adsk.core.Point3D.create(*[x/10 for x in v])
    def vec(v):return adsk.core.Vector3D.create(*v)
    allparts=[];custom=[];rotors=[];payload=[]
    def component(name,kind):
        o=root.occurrences.addNewComponent(adsk.core.Matrix3D.create());o.component.name=name
        o.component.attributes.add('BGD','representation',kind);allparts.append(o);return o
    def add(o,solid):
        bf=o.component.features.baseFeatures.add();bf.startEdit()
        b=o.component.bRepBodies.add(solid,bf);bf.finishEdit();assert b
        return b
    def box(name,center,size,kind='C4_DIMENSION_ENVELOPE_NOT_MANUFACTURER_SOLID',axes=None):
        o=component(name,kind)
        a,b=axes or ([1,0,0],[0,1,0])
        add(o,tm.createBox(adsk.core.OrientedBoundingBox3D.create(pt(center),vec(a),vec(b),*[x/10 for x in size])))
        return o
    def cyl(name,a,b,r,kind):
        o=component(name,kind);add(o,tm.createCylinderOrCone(pt(a),r/10,pt(b),r/10));return o
    def printbox(name,center,size):
        o=box(name,center,size,'DESIGNED_PRINT_CANDIDATE_NOT_FABRICATION_RELEASE');custom.append(o);return o
    def plate(name,outline,holes,thickness,z=0):
        o=component(name,'DESIGNED_PRINT_CANDIDATE_NOT_FABRICATION_RELEASE');c=o.component
        sk=c.sketches.add(c.xYConstructionPlane)
        for a,b in zip(outline,outline[1:]+outline[:1]):sk.sketchCurves.sketchLines.addByTwoPoints(pt([*a,0]),pt([*b,0]))
        c.features.extrudeFeatures.addSimple(sk.profiles.item(0),adsk.core.ValueInput.createByString(f'{thickness} mm'),adsk.fusion.FeatureOperations.NewBodyFeatureOperation)
        if holes:
            h=c.sketches.add(c.xYConstructionPlane)
            for x,y,r in holes:h.sketchCurves.sketchCircles.addByCenterRadius(pt([x,y,0]),r/10)
            profiles=adsk.core.ObjectCollection.create()
            for p in h.profiles:profiles.add(p)
            inp=c.features.extrudeFeatures.createInput(profiles,adsk.fusion.FeatureOperations.CutFeatureOperation)
            inp.setDistanceExtent(False,adsk.core.ValueInput.createByString(f'{thickness} mm'));c.features.extrudeFeatures.add(inp)
        m=adsk.core.Matrix3D.create();m.translation=vec([0,0,z/10]);o.transform2=m
        custom.append(o);return o
    # C4 outline deliberately simpler than manufacturer carbon shape; mounting pattern is sourced.
    box('MANTA_BOTTOM_C4_OUTLINE',[0,0,-1.5],[64,240,3],'C4_OUTLINE_SOURCE_THICKNESS_3MM')
    box('MANTA_TOP_C4_OUTLINE',[0,0,26],[64,240,2],'C4_OUTLINE_SOURCE_THICKNESS_2MM_PLATE_SPACING25MM')
    a=440/(2*math.sqrt(2))
    for i,(sx,sy) in enumerate([(1,1),(-1,1),(-1,-1),(1,-1)],1):
        x,y=sx*a,sy*a
        u=[sx/math.sqrt(2),sy/math.sqrt(2),0];v=[-sy/math.sqrt(2),sx/math.sqrt(2),0]
        box(f'MANTA_ARM_{i}_C4_OUTLINE',[(x+sx*25)/2,(y+sy*25)/2,3.5],[math.hypot(x-sx*25,y-sy*25),24,7],'C4_ARM_WIDTH_SOURCE_THICKNESS7MM_AND_MOTOR_CENTERS',axes=(u,v))
        cyl(f'SUNNYSKY_{i}_DIMENSION_ENVELOPE',[x,y,7],[x,y,37],13.75,'MAKER_MOTOR_OUTER_DIMENSIONS_NOT_INTERNAL_SOLID')
        # Shoulder/prop nut datum unverified; broad vertical sweep explicitly reserved.
        r=cyl(f'ROTOR_{i}_KEEP_OUT',[x,y,36],[x,y,64],132,'254MM_PROP_PLUS5MM_RADIAL_AND_C4_VERTICAL_ALLOWANCE')
        r.isLightBulbOn=False;rotors.append(r)
        for xx,yy in [(9.5,0),(-9.5,0),(0,8),(0,-8)]:
            cyl(f'MOTOR_{i}_M3_INTERFACE_{xx}_{yy}',[x+xx,y+yy,4],[x+xx,y+yy,10],1.5,'SOURCED_16_19MM_MOTOR_PATTERN_CHECK_SCREW_ENGAGEMENT')
    # Sourced30.5frame/25.5AIO adapter, board installed45deg per maker manual.
    holes=[(x,y,1.6) for x in [-15.25,15.25] for y in [-15.25,15.25]]
    d=25.5/math.sqrt(2)
    holes += [(d,0,1.6),(-d,0,1.6),(0,d,1.6),(0,-d,1.6)]
    plate('AIO_INSULATING_ADAPTER',[[-24,-24],[24,-24],[24,24],[-24,24]],holes,2,5)
    o=box('MICOAIR743V2_ENVELOPE',[0,0,15],[36,36,8],'MAKER_BOARD_DIMENSION_PLUS_SOURCED45DEG_ORIENTATION',axes=([math.sqrt(.5),math.sqrt(.5),0],[-math.sqrt(.5),math.sqrt(.5),0]));payload.append(o)
    box('AIO_WIRE_ACCESS',[0,0,16],[60,60,20],'CONNECTOR_WIRE_KEEP_OUT_C4').isLightBulbOn=False
    # Landscape phone: main camera remains near left end, USB exits right end.
    o=box('PIXEL7_GOOGLE_BODY',[0,-95,105],[155.6,8.7,73.2],'GOOGLE_OUTER_DIMENSIONS_CAMERA_BAR_NOT_INCLUDED');payload.append(o)
    box('PIXEL_CAMERA_BAR_CLEARANCE',[-57,-101,105],[30,8,73.2],'C4_CAMERA_BAR_ENVELOPE_EXACT_LENS_POSITION_PENDING').isLightBulbOn=False
    box('PIXEL_USB_PLUG_AND_BEND',[96,-95,105],[36,20,24],'C4_USB_HOST_ADAPTER_BEND_KEEP_OUT').isLightBulbOn=False
    box('PIXEL_SIDE_BUTTON_CLEARANCE',[0,-95,143],[90,20,8],'C4_BUTTON_ACCESS_RESERVE').isLightBulbOn=False
    # End frame captures all axes; removable top member and right-sideUSB gap.
    printbox('PHONE_BOTTOM_CROSSBAR',[0,-94,65],[170,16,3])
    printbox('PHONE_TOP_REMOVABLE_BAR',[0,-94,145],[170,16,3])
    printbox('PHONE_LEFT_END_RAIL',[-81,-94,105],[3,16,77])
    for z in [83,128]:printbox('PHONE_RIGHT_SPLIT_RAIL_'+str(z),[81,-94,z],[3,16,31])
    for x in [-77,77]:
        for z in [71,139]:printbox('PHONE_EDGE_FRONT_LIP_'+str(x)+'_'+str(z),[x,-101, z],[7,2,9])
    # C4supports to stockfront topplate; position must matchactual standoffs/slots.
    for x in [-22,22]:printbox('PHONE_SUPPORT_INTERFACE_PENDING_'+str(x),[x,-95,45],[5,12,37])
    o=box('VL49RGB_BODY',[30,-130,102],[82,32,68],'ULANZI_OUTER_DIMENSIONS_INDEPENDENT_BATTERY');payload.append(o)
    printbox('LAMP_COLD_SHOE_BASE',[30,-130,65],[24,22,3])
    printbox('LAMP_SUPPORT_INTERFACE_PENDING',[30,-111,64],[8,42,4])
    # Fullpackbareenvelope plus separate cable/connector volume, not fictionalcompactbattery.
    o=box('NEXUS4S2P_BARE_ENVELOPE',[0,45,77],[48,93,72],'NEXUS_APPROXIMATE_BARE_DIMENSIONS_CONFIGURATION_PENDING');payload.append(o)
    box('PACK_QS8_LEAD_BEND',[0,114,66],[48,44,32],'C4_FACTORY_WIRE_AND_QS8_RETENTION_VOLUME').isLightBulbOn=False
    for y in [-3,93]:printbox('BATTERY_END_STOP_'+str(y),[0,y,38],[54,3,12])
    for x in [-26,26]:printbox('BATTERY_SIDE_STOP_'+str(x),[x,45,36],[3,88,8])
    for y in [18,72]:box('BATTERY_STRAP_ROUTE_'+str(y),[0,y,70],[58,16,92],'STRAP_ROUTE_NOT_SOLID_MATERIAL').isLightBulbOn=False
    # Electronicsreservedbelowpack; hubdataexitsright, auxiliarypowerportleftunused.
    payload.append(box('ADAFRUIT2998_HUB',[0,75,14],[24.5,71.5,18],'MAKER_HUB_DIMENSIONS'))
    payload.append(box('TPM2GO_ENVELOPE',[36,59,14],[36,16,10],'C4_COMPLETE_USB_DEVICE_ENVELOPE'))
    payload.append(box('CP2102N_FRIEND',[36,90,14],[30,18,5],'ADAFRUIT_BOARD_DIMENSIONS_PLUG_PENDING'))
    payload.append(box('ELRS_RECEIVER_ENVELOPE',[0,-68,13],[25,16,8],'C4_SELECTED_RECEIVER_REVISION_PENDING'))
    payload.append(box('GNSS_MODULE_ENVELOPE',[0,118,136],[25,25,8],'C4_EXACT_GPS_VARIANT_PENDING'))
    printbox('GPS_MAST_C4',[0,115,88],[4,5,88])
    payload.append(box('TOFSENSE_M_FRONT',[20,-152,83],[28,12,12],'C4_MODULE_AND_PLUG_ENVELOPE_SOURCE_INTERFACE_PENDING'))
    printbox('TOF_SUPPORT',[20,-138,68],[6,34,3])
    payload.append(box('TFMINI_DOWN',[0,-88,-13],[23,35,17],'BENewake_OUTER_DIMENSIONS_ROTATED_DOWN'))
    cyl('TFMINI_DOWN_CLEAR_RAY',[0,-88,-22],[0,-88,-200],5,'SINGLE_RANGE_RAY_NOT_OMNIDIRECTIONAL_COVERAGE').isLightBulbOn=False
    # Lightweight feet are only a designedcandidate; impact/creep/loadtests remain.
    for x in [-45,45]:
        for y in [-75,75]:
            printbox('LANDING_LEG_'+str(x)+'_'+str(y),[x,y,-20],[5,5,36])
            printbox('LANDING_FOOT_'+str(x)+'_'+str(y),[x,y,-39],[22,12,3])
    # Native body/rotor intersection; keepouts excluded from physical mass accounting.
    collisions=[]
    for first in payload+custom:
        for second in rotors:
            if not first.boundingBox.intersects(second.boundingBox):continue
            g=adsk.core.ObjectCollection.create();g.add(first);g.add(second)
            findings=design.analyzeInterference(design.createInterferenceInput(g))
            vol=sum(i.interferenceBody.volume*1000 for i in findings)
            if vol>.01:collisions.append({'part':first.component.name,'rotor':second.component.name,'mm3':vol})
    records=[]
    for o in allparts:
        b=o.boundingBox;volume=sum(x.volume*1000 for x in o.component.bRepBodies)
        records.append({'name':o.component.name,'kind':o.component.attributes.itemByName('BGD','representation').value,'min_mm':[x*10 for x in b.minPoint.asArray()],'max_mm':[x*10 for x in b.maxPoint.asArray()],'volume_mm3':volume})
    solid_print_g=sum(sum(b.volume*1000 for b in o.component.bRepBodies) for o in custom)*.00127
    printgroup={o.component.name:sum(b.volume*1000 for b in o.component.bRepBodies)*.00127 for o in custom}
    data={'status':'SOURCE_DIMENSION_NATIVE_STUDY_NOT_FABRICATION_RELEASE','document':DOC,'fusion_version':app.version,
        'axes':'Xright,Y aft,Zup;phonecamera looks-Y','frame_evidence':'currentmakerdiagram440/389+-5g;catalog402/272conflicts',
        'source_geometric_tip_gap_mm':440/math.sqrt(2)-254,'radial_gap_after_two5mm_allowances_mm':440/math.sqrt(2)-264,
        'native_rotor_intersections':collisions,'full_density_PETG_prints_g':solid_print_g,'print_mass_by_part_g':printgroup,
        'hardware_foam_straps_not_in_print_mass':True,'parts':records,
        'unclosed':['ActualmakerframeoutlineandstandoffXY','Framevariant355.8photoor389+-5specmass','Phonecameraopticaldatum/bar/USBbuttonclearance','Motorthreadadapterengagement','Lampcoldshoeexactprofile','TOFandGPSexactPCBmounts','Phoneclampfoamandfastenerretention','Batterystrapandframeattachmentloadpath','Landinglegframeattachment','Massbudgetreconciliation','Backpackactualdimensionsandarmremovalstrategy']}
    (OUT/'phone-layout.json').write_text(json.dumps(data,indent=2)+'\n')
    assert not (OUT/'phone-layout.f3d').exists()
    assert design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(OUT/'phone-layout.f3d')))
    assert design.exportManager.execute(design.exportManager.createSTEPExportOptions(str(OUT/'phone-layout.step')))
    cam=app.activeViewport.camera;cam.eye=pt([700,-850,620]);cam.target=pt([0,0,50]);cam.upVector=vec([0,0,1]);cam.isFitView=True
    app.activeViewport.camera=cam;app.activeViewport.fit();app.activeViewport.saveAsImageFile(str(OUT/'phone-layout.png'),1600,1200)
    print(json.dumps({'document':DOC,'parts':len(records),'rotor_intersections':collisions,'full_density_print_mass_g':solid_print_g}))
