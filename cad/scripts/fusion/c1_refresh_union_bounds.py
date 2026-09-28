"""Refresh C1B connected-body bounds after native recompute; geometry untouched."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion

def run(_context):
    app=adsk.core.Application.get()
    doc=next(d for d in app.documents if d.name=='BGD_ISSUE11_C1B_REVIEW')
    design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    assert design.computeAll()
    occ=next(o for o in design.rootComponent.occurrences if o.component.name=='BELLY_CARRIER_UNION')
    assert occ.component.bRepBodies.count==1
    occ.isLightBulbOn=True
    occ.component.bRepBodies.item(0).isVisible=True
    bb=occ.component.bRepBodies.item(0).boundingBox
    path=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\candidate-c1\fusion-build.json')
    data=json.loads(path.read_text())
    data['belly_union']['min_mm']=[v*10 for v in bb.minPoint.asArray()]
    data['belly_union']['max_mm']=[v*10 for v in bb.maxPoint.asArray()]
    path.write_text(json.dumps(data,indent=2)+'\n')
    print(json.dumps(data['belly_union']))
