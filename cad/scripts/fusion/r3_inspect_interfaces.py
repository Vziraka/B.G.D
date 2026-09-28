"""Read only: source cylinders, exact bounds and a local viewport image."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion

OUT = Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')


def run(_context: str):
    app = adsk.core.Application.get()
    doc = next(d for d in app.documents if d.name == 'BGD_ISSUE11_R3')
    doc.activate()
    design = adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    root = design.rootComponent
    records = []
    for o in root.allOccurrences:
        if o.component.name not in ('DJ-MN4014_8_1_1_1', 'X650-1', 'X650-2', 'X650-3', 'PRT0001', 'PLATFORM-PLAT-X650_27_1_1'):
            continue
        cylinders = []
        for body in o.bRepBodies:
            for face in body.faces:
                cylinder = adsk.core.Cylinder.cast(face.geometry)
                if cylinder:
                    cylinders.append({'origin_mm':[v*10 for v in cylinder.origin.asArray()],
                                      'axis':cylinder.axis.asArray(),'radius_mm':cylinder.radius*10})
        bb = o.preciseBoundingBox
        records.append({'path':o.fullPathName,'name':o.component.name,'cylinders':cylinders,
                        'min_mm':[v*10 for v in bb.minPoint.asArray()],
                        'max_mm':[v*10 for v in bb.maxPoint.asArray()]})
    (OUT/'source-interfaces.json').write_text(json.dumps(records,indent=2)+'\n')
    app.activeViewport.fit()
    app.activeViewport.saveAsImageFile(str(OUT/'manufacturer-reference.png'),1200,900)
    print(json.dumps({'interfaces':len(records),'cylinders':sum(len(r['cylinders']) for r in records)}))
