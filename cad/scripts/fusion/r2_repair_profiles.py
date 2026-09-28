"""Correct two reviewed aperture-selection defects and verify every detail area."""
import json
import math
import re
from pathlib import Path
import adsk.core
import adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\engineering-r2-2026-09-10')
def run(_context: str):
    app=adsk.core.Application.get()
    doc=next(d for d in app.documents if d.name=='BGD_ISSUE11_R2');doc.activate()
    app.userInterface.workspaces.itemById('FusionSolidEnvironment').activate()
    design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    group=next(o for o in design.rootComponent.occurrences if o.component.name=='R2_DETAIL_R2D')
    items={re.sub(r' \(\d+\)$','',o.component.name):o for o in group.component.occurrences}
    data=json.loads((OUT/'assembly-inputs.json').read_text())
    checked=[]
    for p in data['parts']:
        if p['shape'].endswith('_strut'):continue
        comp=items[p['name']].component;sk=comp.sketches.item(0)
        w,h,t=p['size'];area=math.pi*w*w/4 if p['shape']=='cylinder' else w*h
        area-=sum(math.pi*x[2]**2/4 for x in p.get('holes',[]))
        if p.get('inner'):area-=math.pi*p['inner'][2]**2/4
        loops=1+len(p.get('holes',[]))+(1 if p.get('inner') else 0)
        matches=[q for q in sk.profiles if q.profileLoops.count==loops and abs(q.areaProperties().area*100-area)<0.001]
        assert len(matches)==1,p['name']
        feature=comp.features.extrudeFeatures.item(0)
        old=feature.bodies.item(0).volume*1000
        if abs(old-area*t)>0.01:
            assert feature.timelineObject.rollTo(True)
            feature.profile=matches[0]
            assert design.timeline.moveToEnd()
        checked.append({'name':p['name'],'loops':loops,'expected_area_mm2':area,'old_volume_mm3':old,'expected_volume_mm3':area*t})
    assert design.computeAll()
    for row in checked:
        actual=items[row['name']].component.bRepBodies.item(0).volume*1000
        assert abs(actual-row['expected_volume_mm3'])<.01,(row['name'],actual)
        row['verified_volume_mm3']=actual
    coupon=next(d for d in app.documents if d.name=='R2_RAIL_IDEAL_SUPPORT_FEA');coupon.activate()
    cd=adsk.fusion.Design.cast(coupon.products.itemByProductType('DesignProductType'))
    sk=cd.rootComponent.sketches.item(0)
    feature=cd.rootComponent.features.extrudeFeatures.item(0)
    assert feature.timelineObject.rollTo(True)
    feature.profile=next(p for p in sk.profiles if p.profileLoops.count==2)
    assert cd.timeline.moveToEnd()
    assert cd.computeAll()
    volume=cd.rootComponent.bRepBodies.item(0).volume*1000
    expected=(12.5**2-(12.5-2*1.2065)**2)*84.2176
    assert abs(volume-expected)<.01
    for ext in ('f3d','step'):
        path=OUT/'exports'/('R2_RAIL_IDEAL_SUPPORT_FEA_UNSOLVED.'+ext)
        options=cd.exportManager.createFusionArchiveExportOptions(str(path)) if ext=='f3d' else cd.exportManager.createSTEPExportOptions(str(path),cd.rootComponent)
        assert cd.exportManager.execute(options)
    (OUT/'profile-verification.json').write_text(json.dumps({'checks':checked,'coupon_volume_mm3':volume,'correction':'Select material by loop topology AND independent analytical area; rejected maximum-area rule plugged large openings.'},indent=2)+'\n')
    doc.activate()
    print(json.dumps({'verified_profiles':len(checked),'coupon_hollow_volume_mm3':volume}))
