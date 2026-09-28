"""Migrate saved phone geometry to a separate Tarot integration study.

Source-size references and C4 reservations remain tagged, never maker CAD.
"""
import json
import math
from pathlib import Path
import adsk.core
import adsk.fusion

OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
DOC='BGD_ISSUE11_R3_PHONE_FOLDING'

def run(_context:str):
    app=adsk.core.Application.get()
    assert not any(d.name==DOC for d in app.documents),'Inspect partial study before retry'
    doc=app.importManager.importToNewDocument(app.importManager.createFusionArchiveImportOptions(str(OUT/'phone-layout-fit.f3d')))
    assert doc;doc.name=DOC
    d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent
    tm=adsk.fusion.TemporaryBRepManager.get()
    def pt(v):return adsk.core.Point3D.create(*[x/10 for x in v])
    def vec(v):return adsk.core.Vector3D.create(*v)
    def solidbox(center,size,axes=([1,0,0],[0,1,0])):
        return tm.createBox(adsk.core.OrientedBoundingBox3D.create(pt(center),vec(axes[0]),vec(axes[1]),*[x/10 for x in size]))
    def solidcyl(a,b,radius):return tm.createCylinderOrCone(pt(a),radius/10,pt(b),radius/10)
    def add(name,body,kind):
        o=r.occurrences.addNewComponent(adsk.core.Matrix3D.create());o.component.name=name
        o.component.attributes.add('BGD','representation',kind)
        f=o.component.features.baseFeatures.add();f.startEdit();o.component.bRepBodies.add(body,f);f.finishEdit();return o
    def box(name,center,size,kind='C4_RESERVATION_NOT_MAKER_CAD',axes=([1,0,0],[0,1,0])):
        return add(name,solidbox(center,size,axes),kind)
    def cyl(name,a,b,radius,kind='C4_FRAME_RESERVATION_NOT_MAKER_CAD'):
        return add(name,solidcyl(a,b,radius),kind)
    def printbox(name,center,size,holes=()):
        b=solidbox(center,size)
        for x,y,rr in holes:
            assert tm.booleanOperation(b,solidcyl([x,y,center[2]-size[2]],[x,y,center[2]+size[2]],rr),adsk.fusion.BooleanTypes.DifferenceBooleanType)
        return add(name,b,'DESIGNED_PRINT_CANDIDATE_NOT_FABRICATION_RELEASE')
    for o in list(r.occurrences):
        name=o.component.name
        if name.startswith(('MANTA','SUNNYSKY','MOTOR_','ROTOR_','NEXUS4','PACK_QS8','BATTERY_','SPLAYED_LEG','LANDING_FOOT','PHONE_SUPPORT','PHONE_LEFT_END_RAIL','PHONE_TOP_REMOVABLE','PHONE_RIGHT_')):
            o.deleteMe()
    for n,v,comment in [('wheelbase',650,'Nominal frame; actual hinge/tube engagement pending'),('prop_diameter',406.7,'Hobbywing maker dimension'),('arm_od',16,'TL68B51 source tube bore'),('pack_x',25,'Nexus bare dimension'),('pack_y',139,'Nexus bare dimension'),('pack_z',72,'Nexus bare dimension'),('phone_pitch',0,'Optical datum pending; no unqualified downward view implied')]:
        unit='deg' if n=='phone_pitch' else 'mm'
        d.userParameters.add('Folding_'+n,adsk.core.ValueInput.createByString(f'{v} {unit}'),unit,comment)
    box('TAROT_TOP_C4',[0,0,10],[190,140,2])
    box('TAROT_BOTTOM_C4',[0,0,-10],[190,140,2])
    # Source-dimension mount plate: exact holes, approximate silhouette/cast underside.
    a=650/(2*math.sqrt(2));rotors=[]
    for i,(sx,sy) in enumerate([(1,1),(-1,1),(-1,-1),(1,-1)],1):
        x,y=sx*a,sy*a;u=[sx/math.sqrt(2),sy/math.sqrt(2),0];v=[-sy/math.sqrt(2),sx/math.sqrt(2),0]
        cyl(f'TAROT_TUBE_{i}_16MM',[sx*55,sy*55,0],[x,y,0],8,'SOURCED16MM_OD_C4_CUT_LENGTH_AND_PIVOT')
        body=solidbox([x-23.5*u[0],y-23.5*u[1],9],[105,43,2],(u,v))
        for lx,ly,rr in [(12.5,0,1.6),(-12.5,0,1.6),(0,12.5,1.6),(0,-12.5,1.6),(0,0,5.5)]:
            xx=x+lx*u[0]+ly*v[0];yy=y+lx*u[1]+ly*v[1]
            assert tm.booleanOperation(body,solidcyl([xx,yy,6],[xx,yy,12],rr),adsk.fusion.BooleanTypes.DifferenceBooleanType)
        add(f'TL68B51_{i}_MAKER_PATTERN',body,'MAKER25MM_PATTERN_105X43_OUTER_C4_CAST_UNDERSIDE_NOT_MANUFACTURE')
        cyl(f'M4006UL_{i}_MAKER_ENVELOPE',[x,y,10],[x,y,29.3],22.2,'MAKER44_4DIAMETER19_3HEIGHT_ENVELOPE')
        rr=cyl(f'ROTOR_{i}_KEEP_OUT',[x,y,25],[x,y,41],208.35,'MAKER406_7SPAN_PLUS5MM_RADIAL_C4_Z25_41');rr.isLightBulbOn=False;rotors.append(rr)
        # Sleeve/clamp volume; actual two-bolt cast underside remains a receiving check.
        box(f'TL68B51_CLAMP_{i}_C4',[x-55*u[0],y-55*u[1],-1.5],[27,43,19],axes=(u,v))
    # Rails support the payload independently of the unverified stock hole pattern.
    # Physical attachment requires actual frame slots/bolts or separately qualified tube clamps.
    for x in [-22,22]:
        printbox(f'PAYLOAD_RAIL_INTERFACE_PENDING_{x}',[x,-5,24],[8,210,4])
        printbox(f'PHONE_POST_{x}',[x,-95,47],[5,12,43])
    for y in [-55,55]:
        printbox(f'PAYLOAD_TRANSVERSE_INTERFACE_PENDING_{y}',[0,y,18],[68,12,8])
    # Phone closure screws go through removable bar into7mm-wide end bosses.
    printbox('PHONE_TOP_M3_REMOVABLE_BAR',[0,-94,150],[180,16,3],[(-83,-94,1.6),(83,-94,1.6)])
    printbox('PHONE_LEFT_END_BOSS',[-83,-94,110],[7,16,77],[(-83,-94,1.6)])
    printbox('PHONE_RIGHT_LOWER_USB_CLEAR',[83,-94,87.5],[7,16,20])
    printbox('PHONE_RIGHT_UPPER_USB_CLEAR',[83,-94,135.5],[7,16,26],[(83,-94,1.6)])
    for x in [-83,83]:
        cyl('PHONE_M3_CLOSURE_REFERENCE_'+str(x),[x,-94,139],[x,-94,153],1.5,'PURCHASED_M3_SCREW_REFERENCE_ENGAGEMENT_NUT_CAPTURE_PENDING')
    # Long narrow6S pack retained by guide stops plus two independent straps.
    box('NEXUS6S1P_BARE_ENVELOPE',[0,25,77],[25,139,72],'NEXUS139X25X72_APPROXIMATE_SOURCE_ENVELOPE')
    box('PACK_QS8_BEND_C4',[0,121,72],[44,45,32],'C4_CONFIGURED8AWG_LEAD_AND_QS8_BEND').isLightBulbOn=False
    for y in [-47,97]:printbox('PACK_END_STOP_'+str(y),[0,y,43],[32,3,12])
    for x in [-15,15]:printbox('PACK_SIDE_GUIDE_'+str(x),[x,25,38],[3,139,8])
    for y in [-18,68]:
        printbox('PACK_CROSS_SUPPORT_'+str(y),[0,y,38],[36,8,4])
        box('PACK_STRAP_ROUTE_'+str(y),[0,y,75],[42,16,84],'TWO_INDEPENDENT_STRAP_ROUTES_NOT_SOLID_MATERIAL').isLightBulbOn=False
        for x in [-22,22]:printbox('PACK_STANDOFF_'+str(x)+'_'+str(y),[x,y,31],[6,8,10])
    # Stock gear is already inside frame mass; this is a keepout/envelope, not fabricated legs.
    for x in [-95,95]:
        cyl('TAROT_GEAR_STRUT_C4_'+str(x),[x/2,0,-11],[x,0,-95],4)
        cyl('TAROT_GEAR_SKID_C4_'+str(x),[x,-85,-100],[x,85,-100],5)
    # No occurrence transforms are modified: copied source positions stay captured.
    adsk.doEvents();app.activeViewport.refresh()
    parts=[];pm={};collisions=[]
    testprefix=('PIXEL7','VL49','NEXUS6','MICOAIR','ADAFRUIT','TPM2','CP2102','ELRS','GNSS','TOFSENSE','TFMINI_DOWN')
    for o in r.occurrences:
        kind=o.component.attributes.itemByName('BGD','representation').value;b=o.boundingBox
        volume=sum(x.volume*1000 for x in o.component.bRepBodies)
        if kind.startswith('DESIGNED_PRINT'):pm[o.component.name]=volume*.00127
        parts.append({'name':o.component.name,'kind':kind,'min_mm':[x*10 for x in b.minPoint.asArray()],'max_mm':[x*10 for x in b.maxPoint.asArray()],'volume_mm3':volume})
        if not(kind.startswith('DESIGNED_PRINT') or o.component.name.startswith(testprefix)):continue
        for rotor in rotors:
            if not b.intersects(rotor.boundingBox):continue
            group=adsk.core.ObjectCollection.create();group.add(o);group.add(rotor)
            found=d.analyzeInterference(d.createInterferenceInput(group));v=sum(x.interferenceBody.volume*1000 for x in found)
            if v>.01:collisions.append({'part':o.component.name,'rotor':rotor.component.name,'volume_mm3':v})
    result={'status':'NATIVE_PHONE_FOLDING_INTEGRATION_STUDY_NOT_MANUFACTURE_RELEASE','document':DOC,
        'source_archive':'phone-layout-fit.f3d','parts':parts,'print_mass_by_part_g':pm,'full_density_prints_g':sum(pm.values()),
        'material_density_assumed_g_cm3':1.27,'rotor_intersections':collisions,
        'nominal_rotor_gap_mm':650/math.sqrt(2)-406.7,'gap_after_two5mm_radial_reserves':650/math.sqrt(2)-416.7,
        'unclosed':['ExactTarotframeplateoutline/hinges/gear/stockholes','Tubeengagement/clampload/slip','Phonecamera/USB/buttondatum','Nutpocketsandscrewengagement','Payloadrailtoframefasteners','Finishedpackleadbendandstrapclosures','PhonepitchandnightFOV','CGbalanceandbackpackfit','Actualmassandstructuralqualification']}
    (OUT/'phone-folding-layout.json').write_text(json.dumps(result,indent=2)+'\n')
    assert d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(OUT/'phone-folding-layout.f3d')))
    assert d.exportManager.execute(d.exportManager.createSTEPExportOptions(str(OUT/'phone-folding-layout.step')))
    cam=app.activeViewport.camera;cam.eye=pt([850,-1050,650]);cam.target=pt([0,0,20]);cam.upVector=vec([0,0,1]);cam.isFitView=True
    app.activeViewport.camera=cam;app.activeViewport.fit();app.activeViewport.saveAsImageFile(str(OUT/'phone-folding-layout.png'),1600,1200)
    print(json.dumps({'document':DOC,'parts':len(parts),'print_mass_g':sum(pm.values()),'rotor_intersections':collisions}))
