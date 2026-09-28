"""Create an isolated native rail coupon for a reproducible conditional FEA study."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\engineering-r2-2026-09-10')
def run(_context: str):
    app=adsk.core.Application.get()
    existing=[d for d in app.documents if d.name=='R2_RAIL_IDEAL_SUPPORT_FEA']
    assert len(existing)<=1
    doc=existing[0] if existing else app.documents.add(adsk.core.DocumentTypes.FusionDesignDocumentType)
    doc.name='R2_RAIL_IDEAL_SUPPORT_FEA';doc.activate()
    design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));root=design.rootComponent
    assert root.bRepBodies.count==0,'Coupon already built; inspect before repeating'
    outer=12.5;wall=1.2065;length=84.2176
    sk=root.sketches.add(root.xYConstructionPlane)
    for size in (outer,outer-2*wall):sk.sketchCurves.sketchLines.addTwoPointRectangle(adsk.core.Point3D.create(-size/20,-size/20,0),adsk.core.Point3D.create(size/20,size/20,0))
    profile=next(p for p in sk.profiles if p.profileLoops.count==2)
    assert abs(profile.areaProperties().area*100-(outer**2-(outer-2*wall)**2))<0.001
    feature=root.features.extrudeFeatures.addSimple(profile,adsk.core.ValueInput.createByString(str(length)+' mm'),adsk.fusion.FeatureOperations.NewBodyFeatureOperation)
    feature.bodies.item(0).name='MIN_SECTION_CLOSED_RAIL';sk.isVisible=False
    root.attributes.add('BGD','physical_evidence','NONE')
    root.attributes.add('BGD','FEA_boundary','Ideal clamped base, transverse end force29.41995N; not actual frame attachment, tube stock qualification, landing load or fatigue proof')
    (OUT/'stress-study-definition.json').write_text(json.dumps({'geometry_mm':{'outer':outer,'wall':wall,'length':length},'material':{'designation':'6061-T6 conditional stock acceptance','E_MPa':69000,'nu_assumed':0.33,'yield_screen_floor_MPa':200,'density_kg_m3':2700},
       'boundary':{'fixed_face':'annular end atZ0','force_face':'annular end atZ84.2176mm','direction':[1,0,0],'total_force_N':29.41995,'proof_multiplier':2},
       'mesh_mm':[0.8,0.6,0.4],'comparison':'Compare tip deflection and section bending stress away from clamp with mechanical_calcs.py closed_section_corrections. Require <5% tip-displacement change between final two meshes. Do not accept a singular clamp-corner stress as a material failure or hide a real joint failure.',
       'status':'Native geometry prepared; no mesh, load setup, material assignment or solved result claimed yet','limitations':['FEA cannot establish unprovided frame laminate/bearing/contact parameters','Repeated/static native solve would not establish S-N endurance or printed-process scatter','Cloud solve/upload and any token use must be explicitly authorized before submission']},indent=2)+'\n')
    out=OUT/'exports';out.mkdir(exist_ok=True)
    assert design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(out/'R2_RAIL_IDEAL_SUPPORT_FEA_UNSOLVED.f3d')))
    assert design.exportManager.execute(design.exportManager.createSTEPExportOptions(str(out/'R2_RAIL_IDEAL_SUPPORT_FEA_UNSOLVED.step'),root))
    cam=app.activeViewport.camera;cam.eye=adsk.core.Point3D.create(12,-12,12);cam.target=adsk.core.Point3D.create(0,0,4)
    cam.upVector=adsk.core.Vector3D.create(0,0,1);cam.viewExtents=13;cam.isFitView=False;app.activeViewport.camera=cam;app.activeViewport.refresh()
    print('Isolated rail coupon prepared with exact load/mesh/material recipe; no solve or physical proof.')
