"""Inspect bolt/nut access at source Rev2 holes without modifying source parts."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion

OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')


def run(_context: str):
    app=adsk.core.Application.get()
    doc=next(d for d in app.documents if d.name=='BGD_ISSUE11_R3_STARLING');doc.activate()
    design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    root=design.rootComponent
    label='STARLING_REV2_BOLT_ACCESS_PROBES'
    assert not any(o.component.name==label for o in root.occurrences)
    source=[o for o in root.allOccurrences if o.component.bRepBodies.count and not o.fullPathName.startswith('STARLING_REV2_')]
    parent=root.occurrences.addNewComponent(adsk.core.Matrix3D.create());parent.component.name=label
    tm=adsk.fusion.TemporaryBRepManager.get()
    rows=[]
    for x,z in ((7.5,44.5),(-7.5,44.5),(7.5,-44.5),(-7.5,-44.5)):
        for side,y0,y1 in (('top_nut',5,8),('bottom_head',-3,0)):
            occ=parent.component.occurrences.addNewComponent(adsk.core.Matrix3D.create())
            comp=occ.component;comp.name=f'PROBE_{x}_{z}_{side}'
            bf=comp.features.baseFeatures.add();assert bf.startEdit()
            assert comp.bRepBodies.add(tm.createCylinderOrCone(adsk.core.Point3D.create(x/10,y0/10,z/10),.24,adsk.core.Point3D.create(x/10,y1/10,z/10),.24),bf)
            assert bf.finishEdit()
            probe=occ.createForAssemblyContext(parent)
            overlaps=[]
            for other in source:
                if 'Thicker frame' in other.component.name or not probe.boundingBox.intersects(other.boundingBox):continue
                coll=adsk.core.ObjectCollection.create();coll.add(probe);coll.add(other)
                results=design.analyzeInterference(design.createInterferenceInput(coll))
                volume=sum(r.interferenceBody.volume*1000 for r in results)
                if volume>.001:overlaps.append({'part':other.component.name,'overlap_mm3':volume})
            rows.append({'x_mm':x,'z_mm':z,'side':side,'radius_mm':2.4,'y_interval_mm':[y0,y1],'overlaps':overlaps})
            occ.isLightBulbOn=False
    (OUT/'starling-bolt-access.json').write_text(json.dumps(rows,indent=2)+'\n')
    print(json.dumps(rows))
