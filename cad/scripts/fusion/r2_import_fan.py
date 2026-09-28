"""Inspect manufacturer fan STEP without treating its internal geometry as functional evidence."""
import hashlib
import json
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT=Path(r'C:\Users\zvent\Downloads\B.G.D')
def run(_context: str):
    app=adsk.core.Application.get()
    doc=next(d for d in app.documents if d.name=='BGD_ISSUE11_R2')
    doc.activate()
    design=adsk.fusion.Design.cast(app.activeProduct)
    root=design.rootComponent
    path=ROOT/'cad/engineering-r2-2026-09-10/sources/NF-A4x10_public-CAD.stp'
    assert hashlib.sha256(path.read_bytes()).hexdigest()=='025db52996d82392dcf831b26751a02f1490ba2c9d1d07521fee4211b6a85023'
    found=[o for o in root.occurrences if o.component.name=='R2_NOCTUA_MANUFACTURER_REFERENCE']
    assert len(found)<=1
    occ=found[0] if found else root.occurrences.addNewComponent(adsk.core.Matrix3D.create())
    occ.component.name='R2_NOCTUA_MANUFACTURER_REFERENCE'
    if not found:
        result=app.importManager.importToTarget2(app.importManager.createSTEPImportOptions(str(path)),occ.component)
        assert result and result.count
    occ.isLightBulbOn=False
    def bbox(b):
        bb=b.boundingBox
        return {'min_mm':[v*10 for v in bb.minPoint.asArray()], 'max_mm':[v*10 for v in bb.maxPoint.asArray()]}
    audit={'manufacturer_model':str(path.relative_to(ROOT)),'occurrence':bbox(occ),
           'bodies':[{'name':b.name,**bbox(b)} for b in occ.component.bRepBodies],
           'children':[{'name':o.name,**bbox(o)} for o in occ.component.occurrences],
           'license':'Noctua CAD terms: external integration/visualization only; modified internal geometry excludes aerodynamic or thermal-performance proof and fan reproduction'}
    (ROOT/'cad/engineering-r2-2026-09-10/fan-cad-audit.json').write_text(json.dumps(audit,indent=2)+'\n')
    print(json.dumps(audit))
