"""Build detailed R2 conditional assembly using acquired manufacturer geometry.

Run only after r2_open_and_audit.py and r2_import_fan.py. A partial run is
inspectable and is never silently deleted or retried. Original archives stay intact.
"""
import hashlib
import json
import math
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT=Path(r'C:\Users\zvent\Downloads\B.G.D')
OUT=ROOT/'cad/engineering-r2-2026-09-10'

def run(_context: str):
    app=adsk.core.Application.get()
    doc=next(d for d in app.documents if d.name=='BGD_ISSUE11_R2')
    doc.activate()
    app.userInterface.workspaces.itemById('FusionSolidEnvironment').activate()
    design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    root=design.rootComponent
    data=json.loads((OUT/'assembly-inputs.json').read_text())
    input_hash=hashlib.sha256((OUT/'assembly-inputs.json').read_bytes()).hexdigest()
    label='R2_DETAIL_'+data['revision']
    assert not any(o.component.name==label for o in root.occurrences), 'Inspect existing/partial R2 detail before retry'
    assembly=root.occurrences.addNewComponent(adsk.core.Matrix3D.create())
    assembly.component.name=label
    assembly.component.attributes.add('BGD','input_sha256',input_hash)
    assembly.component.attributes.add('BGD','status',data['status'])
    wall_name='R2_secondary_ASA_wall'
    if not design.userParameters.itemByName(wall_name):
        design.userParameters.add(wall_name,adsk.core.ValueInput.createByString('2.4 mm'),'mm','Secondary ASA parts only; no strength qualification. Regenerate assembly for placement changes.')
    for name,p in data['parameters'].items():
        pname='R2_'+name
        if not design.userParameters.itemByName(pname):
            design.userParameters.add(pname,adsk.core.ValueInput.createByString(str(p['value'])+' mm'),'mm',p['basis']+'; range '+str([p['min'],p['max']])+'; placement requires regeneration')
    records=[]
    def point(a):return adsk.core.Point3D.create(*[v/10 for v in a])
    def add_angle(comp,p):
        a,b=p['a'],p['b']
        z=adsk.core.Vector3D.create(*[b[i]-a[i] for i in range(3)]); length=z.length;z.normalize()
        ref=adsk.core.Vector3D.create(0,0,1) if abs(z.z)<.9 else adsk.core.Vector3D.create(1,0,0)
        x=ref.crossProduct(z);x.normalize();y=z.crossProduct(x);y.normalize()
        midpoint=[(a[i]+b[i])/2 for i in range(3)]
        w,t=p['width'],p['wall']
        bf=comp.features.baseFeatures.add();bf.name=p['name']+'_stock_section';assert bf.startEdit()
        tm=adsk.fusion.TemporaryBRepManager.get()
        # L profile split into nonoverlapping rectangles; no hidden double volume.
        rectangles=[(0,-(w-t)/2,w,t),(-(w-t)/2,t/2,t,w-t)]
        if p['shape']=='tube_strut':
            rectangles=[(0,-(w-t)/2,w,t),(0,(w-t)/2,w,t),(-(w-t)/2,0,t,w-2*t),((w-t)/2,0,t,w-2*t)]
        for dx,dy,ww,hh in rectangles:
            c=[midpoint[i]+x.asArray()[i]*dx+y.asArray()[i]*dy for i in range(3)]
            box=adsk.core.OrientedBoundingBox3D.create(point(c),x,y,ww/10,hh/10,length/10)
            body=comp.bRepBodies.add(tm.createBox(box),bf);assert body
            body.name=p['name']
        assert bf.finishEdit()
    for p in data['parts']:
        tr=adsk.core.Matrix3D.create()
        if not p['shape'].endswith('_strut'):
            tr.setToRotation(math.radians(p['angle']),adsk.core.Vector3D.create(0,0,1),adsk.core.Point3D.create(0,0,0))
            x,y,z=p['center'];h=p['size'][2]
            tr.translation=adsk.core.Vector3D.create(x/10,y/10,(z-h/2)/10)
        occ=assembly.component.occurrences.addNewComponent(tr)
        comp=occ.component;comp.name=p['name']
        comp.attributes.add('BGD','canonical_name',p['name'])
        comp.attributes.add('BGD','representation',p['kind'])
        comp.attributes.add('BGD','material_basis',p['material'])
        comp.attributes.add('BGD','hold',p['hold'] or 'Conditional engineering geometry; no physical qualification')
        if p['shape'].endswith('_strut'):add_angle(comp,p)
        else:
            w,h,t=p['size']
            sketch=comp.sketches.add(comp.xYConstructionPlane)
            sketch.name=p['name']+'_dimensioned_profile'
            if p['shape']=='cylinder':sketch.sketchCurves.sketchCircles.addByCenterRadius(adsk.core.Point3D.create(0,0,0),w/20)
            else:
                lines=sketch.sketchCurves.sketchLines.addTwoPointRectangle(adsk.core.Point3D.create(-w/20,-h/20,0),adsk.core.Point3D.create(w/20,h/20,0))
                # Native dimensions make custom part width/height reviewable.
                if p['kind']=='printed_secondary':
                    dims=sketch.sketchDimensions
                    dims.addDistanceDimension(lines.item(0).startSketchPoint,lines.item(0).endSketchPoint,adsk.fusion.DimensionOrientations.HorizontalDimensionOrientation,adsk.core.Point3D.create(0,-h/20-.5,0))
                    dims.addDistanceDimension(lines.item(1).startSketchPoint,lines.item(1).endSketchPoint,adsk.fusion.DimensionOrientations.VerticalDimensionOrientation,adsk.core.Point3D.create(w/20+.5,0,0))
            for hx,hy,diam in p.get('holes',[]):sketch.sketchCurves.sketchCircles.addByCenterRadius(adsk.core.Point3D.create(hx/10,hy/10,0),diam/20)
            if p.get('inner'):
                hx,hy,diam=p['inner'];sketch.sketchCurves.sketchCircles.addByCenterRadius(adsk.core.Point3D.create(hx/10,hy/10,0),diam/20)
            # A large aperture can have greater area than the surrounding part.
            # Select the material profile by all its inner loops, then verify area.
            loop_count=1+len(p.get('holes',[]))+(1 if p.get('inner') else 0)
            candidates=[q for q in sketch.profiles if q.profileLoops.count==loop_count]
            area=(math.pi*w*w/4 if p['shape']=='cylinder' else w*h)
            area-=sum(math.pi*hole[2]**2/4 for hole in p.get('holes',[]))
            if p.get('inner'):area-=math.pi*p['inner'][2]**2/4
            candidates=[q for q in candidates if abs(q.areaProperties().area*100-area)<0.001]
            assert len(candidates)==1,(p['name'],'ambiguous material profile')
            profile=candidates[0]
            expr=wall_name if p['kind']=='printed_secondary' and p['material']=='ASA' else str(t)+' mm'
            feature=comp.features.extrudeFeatures.addSimple(profile,adsk.core.ValueInput.createByString(expr),adsk.fusion.FeatureOperations.NewBodyFeatureOperation)
            feature.name=p['name']+'_thickness'
            feature.bodies.item(0).name=p['name'];sketch.isVisible=False
        occ.isLightBulbOn=p['kind'] not in ('keepout','interface_axis')
        bb=occ.boundingBox
        records.append({'name':p['name'],'kind':p['kind'],'material_basis':p['material'],'hold':p['hold'],
                        'volume_mm3':sum(b.volume for b in comp.bRepBodies)*1000,
                        'min_mm':[v*10 for v in bb.minPoint.asArray()],'max_mm':[v*10 for v in bb.maxPoint.asArray()],
                        'bodies':comp.bRepBodies.count,'visible':occ.isLightBulbOn})
        # Recoverable checkpoint on long builds; a partial file is explicit.
        if len(records)%20==0:(OUT/'fusion-build-progress.json').write_text(json.dumps({'status':'PARTIAL','records':records},indent=2)+'\n')
    for o in root.occurrences:
        if o.component.name.startswith('M01_') or (o.component.name.startswith('R2_DETAIL_') and o.component.name!=label):o.isLightBulbOn=False
    fan=next(o for o in root.occurrences if o.component.name=='R2_NOCTUA_MANUFACTURER_REFERENCE')
    tr=adsk.core.Matrix3D.create()
    tr.setToRotation(math.pi/2,adsk.core.Vector3D.create(1,0,0),adsk.core.Point3D.create(0,0,0))
    fc=data['fan_center_mm'];tr.translation=adsk.core.Vector3D.create(fc[0]/10,fc[1]/10,(fc[2]-5.2963057257)/10)
    fan.transform2=tr;fan.isLightBulbOn=True
    if design.snapshots.hasPendingSnapshot:design.snapshots.add()
    manifest={'status':'BUILD_COMPLETE_NOT_RELEASED','fusion_version':app.version,'input_sha256':input_hash,
              'parts':records,'parameters':'Native secondary-ASA thickness and native custom profile width/height. Placement and uncertain interfaces regenerate from assembly.py; user parameters with range comments do not themselves move geometry.',
              'native_default_mass':'INVALID; manufacturer component masses and sourced-density custom volumes belong in the separate engineering ledger'}
    (OUT/'fusion-build.json').write_text(json.dumps(manifest,indent=2)+'\n')
    assembly.component.attributes.add('BGD','build_complete','true')
    print(json.dumps({'status':manifest['status'],'parts':len(records),'bodies':sum(r['bodies'] for r in records)}))
