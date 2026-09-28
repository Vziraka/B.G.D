"""One selected hybrid: native source camera and parameterized integration study.

Reference airframe/envelopes are explicitly provisional, not copied maker CAD.
"""
import json
import math
from pathlib import Path
import adsk.core
import adsk.fusion

OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')

def run(_context: str):
    app=adsk.core.Application.get()
    doc=next(d for d in app.documents if d.name=='BGD_R3_HYBRID')
    doc.activate()
    design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    root=design.rootComponent
    assert not design.userParameters.itemByName('Hybrid_wheelbase'),'Inspect partial operation before retry'
    params=[('wheelbase',650,'Nominal TL65B01 diagonal; actual hinge/arm coordinates unresolved'),
            ('prop_diameter',406.7,'Hobbywing maker dimension drawing'),
            ('arm_od',16,'Tarot tube interface'),('frame_width',190,'Provisional frame reservation, not exact Tarot geometry'),
            ('frame_depth',140,'Provisional frame reservation'),('deck_width',160,'Designed payload deck'),
            ('deck_depth',220,'Designed payload deck'),('deck_thickness',3,'Designed flat sheet; material/loads require qualification'),
            ('deck_z',50,'Initial integration arrangement'),('camera_pitch',0,'Initial horizontal datum; final10deg nose-down revision after source check'),
            ('camera_y',-120,'Forward camera center'),('camera_z',70,'Above reserved rotor sweep'),
            ('battery_y',20,'Aft trim to offset camera and lamp'),('battery_z',-52,'Below frame'),
            ('mount_plate_thickness',3,'Manufacturing candidate'),('rotor_radial_allowance',5,'Unqualified tracking/flex allowance'),
            ('rotor_halfheight',8,'Provisional sweep reservation; actual prop datum and deflection to verify')]
    for n,v,b in params:
        unit='deg' if n=='camera_pitch' else 'mm'
        design.userParameters.add('Hybrid_'+n,adsk.core.ValueInput.createByString(f'{v} {unit}'),unit,b)
    def pt(v):return adsk.core.Point3D.create(*[x/10 for x in v])
    def vec(v):return adsk.core.Vector3D.create(*v)
    def occ(name,kind):
        o=root.occurrences.addNewComponent(adsk.core.Matrix3D.create())
        o.component.name=name
        o.component.attributes.add('BGD','representation',kind)
        return o
    tm=adsk.fusion.TemporaryBRepManager.get()
    references=[]; customs=[]; rotors=[]
    def add_temp(o,body):
        bf=o.component.features.baseFeatures.add();assert bf.startEdit()
        b=o.component.bRepBodies.add(body,bf);assert b
        assert bf.finishEdit();return b
    def box(name,center,size,kind='SOURCE_DIMENSION_ENVELOPE_NOT_MANUFACTURER_SOLID'):
        o=occ(name,kind)
        b=tm.createBox(adsk.core.OrientedBoundingBox3D.create(pt(center),vec([1,0,0]),vec([0,1,0]),*[v/10 for v in size]))
        add_temp(o,b);references.append(o);return o
    def cylinder(name,a,b,r,kind='NOMINAL_FRAME_INTERFACE_NOT_MANUFACTURER_SOLID'):
        o=occ(name,kind);add_temp(o,tm.createCylinderOrCone(pt(a),r/10,pt(b),r/10));references.append(o);return o
    def plate(name,outline,holes,thickness,transform=None):
        o=occ(name,'DESIGNED_PART_CANDIDATE_NOT_RELEASED_FOR_FABRICATION')
        c=o.component;s=c.sketches.add(c.xYConstructionPlane);s.name=name+'_outline'
        lines=s.sketchCurves.sketchLines
        for a,b in zip(outline,outline[1:]+outline[:1]):lines.addByTwoPoints(pt([*a,0]),pt([*b,0]))
        ex=c.features.extrudeFeatures.addSimple(s.profiles.item(0),adsk.core.ValueInput.createByString(thickness),adsk.fusion.FeatureOperations.NewBodyFeatureOperation)
        ex.name=name+'_thickness'
        if holes:
            sk=c.sketches.add(c.xYConstructionPlane);sk.name=name+'_through_holes'
            for x,y,r in holes:sk.sketchCurves.sketchCircles.addByCenterRadius(pt([x,y,0]),r/10)
            profiles=adsk.core.ObjectCollection.create()
            for p in sk.profiles:profiles.add(p)
            inp=c.features.extrudeFeatures.createInput(profiles,adsk.fusion.FeatureOperations.CutFeatureOperation)
            inp.setDistanceExtent(False,adsk.core.ValueInput.createByString(thickness))
            c.features.extrudeFeatures.add(inp)
        if transform:o.transform2=transform
        customs.append(o);return o
    def move_rotate(translation,axis=None,angle=0):
        m=adsk.core.Matrix3D.create()
        if axis:m.setToRotation(angle,vec(axis),pt([0,0,0]))
        m.translation=vec([x/10 for x in translation]);return m
    # Actual camera source: worldX right, worldY aft, worldZ up; camera looks-Y.
    original=[root.occurrences.item(i) for i in range(root.occurrences.count)]
    camera_transform=move_rotate([-44.5,-121.5,81.75],[1,0,0],math.pi/2)
    camera=[]
    for o in original:
        m=o.transform2;m.transformBy(camera_transform);o.transform2=m;camera.append(o)
    box('TAROT_CENTER_UPPER_PROVISIONAL',[0,0,10],[190,140,2],'ASSUMED_FRAME_OUTLINE_NOT_TAROT_CAD')
    box('TAROT_CENTER_LOWER_PROVISIONAL',[0,0,-10],[190,140,2],'ASSUMED_FRAME_OUTLINE_NOT_TAROT_CAD')
    a=650/(2*math.sqrt(2))
    for i,(sx,sy) in enumerate([(1,1),(-1,1),(-1,-1),(1,-1)],1):
        cx,cy=sx*a,sy*a
        cylinder(f'ARM_{i}_16MM_PROVISIONAL',[sx*55,sy*55,0],[cx,cy,0],8)
        cylinder(f'M4006_{i}_SOURCE_ENVELOPE',[cx,cy,10],[cx,cy,29.3],22.2,'MAKER_DIMENSION_CYLINDER_NOT_INTERNAL_MOTOR_CAD')
        o=cylinder(f'ROTOR_{i}_KEEP_OUT',[cx,cy,25],[cx,cy,41],203.35+5,'PROP_SWEPT_VOLUME_PLUS_ASSUMED_DEFLECTION')
        o.isLightBulbOn=False;rotors.append(o)
        # Motor mount105x43 reservation aligned with arm. Its exact cast underside is not modeled.
        m=move_rotate([cx,cy,8],None)
        m.setToRotation(math.atan2(sy,sx),vec([0,0,1]),pt([0,0,0]));m.translation=vec([cx/10,cy/10,.8])
        h=[(12.5,0,1.6),(-12.5,0,1.6),(0,12.5,1.6),(0,-12.5,1.6),(0,0,5.5)]
        mount=plate(f'TL68B51_{i}_DIMENSION_PATTERN',[[-76,-21.5],[29,-21.5],[29,21.5],[-76,21.5]],h,'2 mm',m)
        mount.component.attributes.add('BGD','representation','MAKER_PATTERN_REFERENCE_ONLY_NOT_CAST_PART_MANUFACTURING')
        customs.remove(mount);references.append(mount)
        cylinder(f'ESC_{i}_LEAD_EXIT_RESERVATION',[sx*160,sy*160,-8],[sx*160,sy*160,-15],16,'WIRING_VOLUME_PLACEHOLDER')
    holes=[(x,y,2) for x in [-65,65] for y in [-90,90]]
    deck=plate('PAYLOAD_DECK_FLAT_CANDIDATE',[[-80,-110],[80,-110],[80,110],[-80,110]],holes,'Hybrid_deck_thickness',move_rotate([0,0,50]))
    # Support posts reserve routes, not certified frame fastening points.
    for x in [-65,65]:
        for y in [-55,55]:cylinder('DECK_POST_INTERFACE_PENDING_'+str(x)+'_'+str(y),[x,y,11],[x,y,50],4,'ASSUMED_ATTACHMENT_POSITION_REQUIRES_FRAME_REVISION_CLOSURE')
    box('ORIN_NANO_KIT_MAX_ENVELOPE',[0,0,76],[106,94,38])
    box('ORIN_FAN_AIRFLOW_KEEP_OUT',[0,0,106],[70,70,22],'CLEAR_AIRFLOW_REQUIRED_NOT_PART')
    box('ORIN_CONNECTOR_BEND_KEEP_OUT',[0,65,77],[106,38,38],'USB_DC_ANTENNA_BEND_RESERVATION_VERIFY_ACTUAL_CABLES')
    box('TATTU10AH_PACK_MAX_ENVELOPE',[0,20,-52],[70,181,62])
    battery=plate('BATTERY_TRAY_FLAT_CANDIDATE',[[-40,-95],[40,-95],[40,95],[-40,95]],[(x,y,2) for x in [-34,34] for y in [-70,70]],'Hybrid_mount_plate_thickness',move_rotate([0,20,-86]))
    box('BATTERY_STRAP_ROUTE_1',[0,-30,-52],[84,22,70],'POSITIVE_RETENTION_ROUTE_NOT_SOLID_STRAP')
    box('BATTERY_STRAP_ROUTE_2',[0,70,-52],[84,22,70],'POSITIVE_RETENTION_ROUTE_NOT_SOLID_STRAP')
    # U-shaped camera rear bridge leaves middle USB access open; native rearM4 at±37.5mm.
    outline=[[-55,-15],[55,-15],[55,-10],[44.5,-10],[44.5,10],[30.5,10],[30.5,-10],[-30.5,-10],[-30.5,10],[-44.5,10],[-44.5,-10],[-55,-10]]
    camera_mount=plate('OAK_REAR_U_BRIDGE_CANDIDATE',outline,[(-37.5,0,2.2),(37.5,0,2.2)],'Hybrid_mount_plate_thickness',move_rotate([0,-103.5,70],[1,0,0],math.pi/2))
    for x in [-37.5,37.5]:
        spacer=cylinder('OAK_M4_SPACER_'+str(x),[x,-108.5,70],[x,-106.5,70],4,'DESIGNED_SPACER_2MM_REQUIRES_M4_ENGAGEMENT_CHECK')
        references.remove(spacer);customs.append(spacer)
    box('OAK_USB_CONNECTOR_KEEP_OUT',[20,-84,79],[28,48,14],'EXACT_USB_PLUG_AND_BEND_TO_VERIFY')
    box('VL49RGB_ENVELOPE',[0,-95,128],[82,32,68])
    box('TFMINI_DOWN_ENVELOPE',[55,-40,-25],[36,23,17])
    cylinder('TFMINI_CLEAR_DOWN_RAY',[55,-40,-33.5],[55,-40,-220],5,'RANGE_RAY_CLEARANCE_NOT_AREA_COVERAGE')
    # Native overlap checks for payload against reserved rotors; intentional supports excluded.
    tested=[o for o in references if any(s in o.component.name for s in ['ORIN_NANO','TATTU10','VL49','TFMINI_DOWN'])]+camera+customs
    collisions=[]
    for first in tested:
        for second in rotors:
            if not first.boundingBox.intersects(second.boundingBox):continue
            group=adsk.core.ObjectCollection.create();group.add(first);group.add(second)
            result=design.analyzeInterference(design.createInterferenceInput(group))
            volume=sum(r.interferenceBody.volume*1000 for r in result)
            if volume>.001:collisions.append({'a':first.fullPathName,'b':second.fullPathName,'mm3':volume})
    records=[]
    for o in root.occurrences:
        b=o.boundingBox
        records.append({'name':o.component.name,'min_mm':[v*10 for v in b.minPoint.asArray()],'max_mm':[v*10 for v in b.maxPoint.asArray()],
                        'representation':o.component.attributes.itemByName('BGD','representation').value if o.component.attributes.itemByName('BGD','representation') else 'LUXONIS_MANUFACTURER_SOURCE'})
    report={'status':'NATIVE_INTEGRATION_STUDY_NOT_FABRICATION_RELEASE','document':doc.name,'axes':'X right Y aft Z up',
            'nominal_prop_tip_gap_mm':650/math.sqrt(2)-406.7,'rotor_overlap_checks':collisions,
            'parts':records,'unclosed':['ExactTarotframehinges/gear/armcoordinates','Motorclampinsertionandcastunderside','CameraM4threadengagement','Deckframefastenings','Batterytrayframefastenings','Lampandcomputepositiveretention','Finalcamera10degpitchandFOV','Actualmassmaterialandstructuralqualification']}
    (OUT/'hybrid-layout.json').write_text(json.dumps(report,indent=2)+'\n')
    archive=OUT/'hybrid-layout.f3d';assert not archive.exists()
    assert design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(archive)))
    assert design.exportManager.execute(design.exportManager.createSTEPExportOptions(str(OUT/'hybrid-layout.step')))
    cam=app.activeViewport.camera;cam.eye=pt([900,-1000,650]);cam.target=pt([0,0,20]);cam.upVector=vec([0,0,1]);cam.isFitView=True
    app.activeViewport.camera=cam;app.activeViewport.fit()
    assert app.activeViewport.saveAsImageFile(str(OUT/'hybrid-layout.png'),1600,1200)
    print(json.dumps({'document':doc.name,'parts':len(records),'rotor_collisions':collisions}))
