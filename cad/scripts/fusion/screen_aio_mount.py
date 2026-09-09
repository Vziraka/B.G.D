"""Screen AIO study geometry against sourced XY and provisional frame stack."""
import json
import math
from pathlib import Path
import adsk.core
import adsk.fusion


def run(_context: str):
    app = adsk.core.Application.get()
    assert app.activeDocument.name == "BGD_MASTER"
    design = adsk.fusion.Design.cast(app.activeProduct)
    root = design.rootComponent
    assert root.occurrences.count == 8, "Do not rerun after a partial operation"
    output = Path(r"C:\Users\zvent\Downloads\B.G.D\cad\components\aio-screen.json")
    assert not output.exists()
    imported = json.loads(Path(r"C:\Users\zvent\Downloads\B.G.D\cad\reference\source-one-v6-7in\fusion-import-raw.json").read_text())
    ox, oy = 1518.565263306285,1493.8850402200592
    circles = next(s['circles'] for s in imported['sketches'] if s['name']=='Draw13')
    support = [(oy-c['y_mm'],c['x_mm']-ox) for c in circles
               if abs(c['x_mm']-ox)<20 and abs(c['y_mm']-1461.258462156818)<120 and abs(c['radius_mm']-1.5)<1e-6]
    assert len(support)==8
    mounts = []

    def new_component(name,x,y,z):
        tr = adsk.core.Matrix3D.create()
        tr.translation = adsk.core.Vector3D.create(x/10,y/10,z/10)
        occ = root.occurrences.addNewComponent(tr)
        occ.component.name=name
        occ.component.attributes.add('BGD','release','STUDY_NOT_FABRICATION_RELEASED')
        return occ,occ.component.sketches.add(occ.component.xYConstructionPlane)

    def extrude(occ,sketch,height):
        p=max(sketch.profiles,key=lambda p:p.areaProperties().area)
        body=occ.component.features.extrudeFeatures.addSimple(p,adsk.core.ValueInput.createByString(str(height)+' mm'),adsk.fusion.FeatureOperations.NewBodyFeatureOperation).bodies.item(0)
        sketch.isVisible=False
        return body

    for i,(x,y) in enumerate(support):
        z=0 if x>80 else 8
        occ,s=new_component('08_STANDOFF_'+str(i+1)+'_POSITION_INFERRED',x,y,z)
        s.sketchCurves.sketchCircles.addByCenterRadius(adsk.core.Point3D.create(0,0,0),.25)
        s.sketchCurves.sketchCircles.addByCenterRadius(adsk.core.Point3D.create(0,0,0),.15)
        extrude(occ,s,30-z)
        mounts.append(occ)
    center=60.472002
    adapters=[]
    for size in (55,48):
        occ,s=new_component('M01_'+str(size)+'_MM_ADAPTER_STUDY',center,0,10)
        s.sketchCurves.sketchLines.addTwoPointRectangle(adsk.core.Point3D.create(-size/20,-size/20,0),adsk.core.Point3D.create(size/20,size/20,0))
        holes=[(a*15.25,b*15.25) for a in (-1,1) for b in (-1,1)]
        pitch=25.5/math.sqrt(2)
        holes += [(pitch,0),(-pitch,0),(0,pitch),(0,-pitch)]
        for x,y in holes:
            s.sketchCurves.sketchCircles.addByCenterRadius(adsk.core.Point3D.create(x/10,y/10,0),.16)
        body=extrude(occ,s,1.6)
        entities=adsk.core.ObjectCollection.create()
        entities.add(occ)
        for mount in mounts: entities.add(mount)
        results=design.analyzeInterference(design.createInterferenceInput(entities))
        adapters.append({'side_mm':size,'interferences_with_standoffs':results.count,'volume_mm3':body.volume*1000,
                         'mass_g_at_assumed_FR4_1_85':body.volume*1.85,
                         'minimum_nominal_edge_gap_mm':min(math.hypot(max(abs(x-center)-size/2,0),max(abs(y)-size/2,0))-2.5 for x,y in support)})
        if size==55: occ.isLightBulbOn=False
    middle=root.occurrences.item(2).component.bRepBodies.item(0)
    through=[]
    for x in (center-15.25,center+15.25):
        for y in (-15.25,15.25):
            relation=middle.pointContainment(adsk.core.Point3D.create(x/10,y/10,.1))
            through.append({'x_mm':x,'y_mm':y,'inside_middle_plate':relation==adsk.fusion.PointContainment.PointInsidePointContainment})
    report={'release':'STUDY_ONLY','frame_z_assumed':True,'adapter_bottom_z_mm':10,'adapter_center_x_mm':center,
            'standoff_centers_xy_mm':support,'adapter_candidates':adapters,'frame_mount_axis_middle_plate_screen':through,
            'limits':['No fastener heads, screw engagement or rubber grommets modeled','AIO pad/USB/SD service volumes not yet modeled','Not complete structural or thermal qualification']}
    with output.open('x',encoding='utf-8') as f:json.dump(report,f,indent=2)
    print(json.dumps(report))
