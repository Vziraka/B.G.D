"""Create a separate, unreleased full-envelope study; preserve BGD_MASTER."""
import hashlib
import json
import math
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT=Path(r'C:\Users\zvent\Downloads\B.G.D')

def run(_context: str):
    app=adsk.core.Application.get()
    assert app.activeDocument.name=='BGD_MASTER'
    master=app.activeDocument
    name='BGD_AIO_ENVELOPE_R3'
    assert not any(d.name==name for d in app.documents)
    e=json.loads((ROOT/'cad/components/aio-envelope-inputs.json').read_text())
    result=json.loads((ROOT/'cad/components/aio-envelope-results.json').read_text())
    source=json.loads((ROOT/'cad/components/aio-screen.json').read_text())
    out=ROOT/'cad/exports/aio-envelope-r3'
    assert not out.exists()
    doc=app.documents.add(adsk.core.DocumentTypes.FusionDesignDocumentType)
    doc.name=name
    design=adsk.fusion.Design.cast(app.activeProduct)
    design.fusionUnitsManager.distanceDisplayUnits=adsk.fusion.DistanceUnits.MillimeterDistanceUnits
    root=design.rootComponent
    root.attributes.add('BGD','status','ENVELOPE_STUDY_NOT_PHYSICAL_ASSEMBLY_NOT_FOR_FABRICATION')
    root.attributes.add('BGD','datum','P=mounting plate upper face; maps to hypothesis-B master X60.472002 Y0 Z8 only')
    root.attributes.add('BGD','bottom_thickness','2.0..2.5 documented conflict; design allowance1.85..2.65; neither authoritative')
    root.attributes.add('BGD','input_sha256',result['input_sha256'])
    objects=[]
    def primitive(label,x,y,z,w,h,t,angle=0,circular=False,visible=True,holes=()):
        tr=adsk.core.Matrix3D.create()
        tr.setToRotation(math.radians(angle),adsk.core.Vector3D.create(0,0,1),adsk.core.Point3D.create(0,0,0))
        tr.translation=adsk.core.Vector3D.create(x/10,y/10,z/10)
        occ=root.occurrences.addNewComponent(tr)
        comp=occ.component;comp.name=label
        comp.attributes.add('BGD','representation','design envelope, not manufacturer CAD')
        s=comp.sketches.add(comp.xYConstructionPlane)
        if circular:s.sketchCurves.sketchCircles.addByCenterRadius(adsk.core.Point3D.create(0,0,0),w/20)
        else:s.sketchCurves.sketchLines.addTwoPointRectangle(adsk.core.Point3D.create(-w/20,-h/20,0),adsk.core.Point3D.create(w/20,h/20,0))
        for hx,hy,d in holes:s.sketchCurves.sketchCircles.addByCenterRadius(adsk.core.Point3D.create(hx/10,hy/10,0),d/20)
        p=max(s.profiles,key=lambda p:p.areaProperties().area)
        body=comp.features.extrudeFeatures.addSimple(p,adsk.core.ValueInput.createByString(str(t)+' mm'),adsk.fusion.FeatureOperations.NewBodyFeatureOperation).bodies.item(0)
        body.name=label;s.isVisible=False;occ.isLightBulbOn=visible
        objects.append({'component':label,'visible':visible,'envelope_mm':[w,h,t],'z_bottom_mm':z,'rotation_deg':angle})
        return occ
    pitch=25.5/math.sqrt(2)
    aio_holes=[(pitch,0,3.2),(-pitch,0,3.2),(0,pitch,3.2),(0,-pitch,3.2)]
    frame_holes=[(x,y,3.2) for x in (-15.25,15.25) for y in (-15.25,15.25)]
    gap=sum(e['adapter_support_gap_mm'])/2
    primitive('R3_45mm_ADAPTER_NOMINAL_DRILLING_HOLD',0,0,gap,45,45,1.6,holes=frame_holes+aio_holes)
    board_z=gap+1.6+e['isolator_effective_rise_mm'][1]
    board=primitive('AIO_MAX_37x37x9_CLASS4_ENVELOPE',0,0,board_z,37,37,9,45,
                    holes=[(x,y,3.0) for x in (-12.75,12.75) for y in (-12.75,12.75)])
    for i,(x,y,d) in enumerate(aio_holes):
        primitive('ISOLATOR_'+str(i)+'_OD6_RISE3_CONTRACT_ONLY',x,y,gap+1.6,6,6,3,circular=True)
        primitive('FASTENER_TOP_'+str(i)+'_PROJECTION_CONTRACT_ONLY',x,y,board_z+9,7,7,2.5,circular=True)
        primitive('FASTENER_UNDER_'+str(i)+'_PROJECTION_CONTRACT_ONLY',x,y,gap-2,7,7,2,circular=True)
    supports=[]
    for i,(x,y) in enumerate(source['standoff_centers_xy_mm']):
        supports.append(primitive('FRAME_SUPPORT_'+str(i)+'_OD5_2_ENVELOPE',x-source['adapter_center_x_mm'],y,-2.65,5.2,5.2,33,circular=True))
    primitive('LOCAL_P_PLANE_REFERENCE_NOT_FULL_FRAME',0,0,-.2,50,50,.2,visible=False)
    primitive('BOTTOM_CONFLICT_THICKNESS_SWEEP_1_85_TO_2_65_NOT_PLACEMENT',0,0,-10.65,50,50,.8,visible=False)
    primitive('BAY_CEILING_MIN21_25_CONDITIONAL_TOPOLOGY_B',0,0,21.25,70,60,.2,visible=False)
    service=primitive('USB_SD_ALL_SIDE12_TRIAL_KEEP_OUT_NOT_REAL_CONNECTOR',0,0,board_z,61,61,12,45,visible=False)
    primitive('WIRE_BEND_R36_OD6_PLUS2_KEEP_OUT_NO_ROUTE',0,0,-45,82,82,6,circular=True,visible=False)
    minimum=min(app.measureManager.measureMinimumDistance(board.bRepBodies.item(0),o.bRepBodies.item(0)).value*10 for o in supports)
    coll=adsk.core.ObjectCollection.create();coll.add(service)
    for o in supports:coll.add(o)
    collisions=design.analyzeInterference(design.createInterferenceInput(coll))
    camera=app.activeViewport.camera
    camera.eye=adsk.core.Point3D.create(9,-10,9)
    camera.target=adsk.core.Point3D.create(0,0,.8)
    camera.upVector=adsk.core.Vector3D.create(0,0,1)
    camera.viewExtents=10
    camera.isFitView=False
    app.activeViewport.camera=camera
    app.activeViewport.refresh()
    out.mkdir(parents=True)
    archive=out/'BGD_AIO_ENVELOPE_R3_NOT_FOR_FABRICATION.f3d'
    assert design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(archive)))
    preview=out/'aio-envelope-r3.png'
    assert app.activeViewport.saveAsImageFile(str(preview),1200,900)
    manifest={'status':'PARTIAL_ROBUST_DESIGN_STUDY_FULL_MOUNT_NOT_QUALIFIED','input_sha256':result['input_sha256'],
              'original_master_unchanged':True,'parameters':'JSON inputs plus reproducible regeneration; sketches are not claimed as fully constrained native parameters',
              'nominal_board_to_max_od_support_gap_mm':minimum,'all_side_service_trial_collisions':collisions.count,
              'objects':objects,'artifacts':[{'path':str(p.relative_to(ROOT)).replace('\\','/'),'sha256':hashlib.sha256(p.read_bytes()).hexdigest()} for p in (archive,preview)]}
    (ROOT/'cad/components/aio-envelope-fusion-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print(json.dumps({'body_count':len(objects),'nominal_board_gap':minimum,'service_trial_collisions':collisions.count,'archive':str(archive)}))
    master.activate()
