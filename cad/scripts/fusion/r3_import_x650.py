"""Import the preserved manufacturer X650 STEP into a new dedicated document."""
import hashlib
import json
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT = Path(r'C:\Users\zvent\Downloads\B.G.D')
OUT = ROOT / 'cad/revision-r3'


def run(_context: str):
    app = adsk.core.Application.get()
    assert not any(d.name == 'BGD_ISSUE11_R3' for d in app.documents), 'Inspect existing R3 document before retry'
    source = OUT / 'sources/x650-frame-2025-0825.stp'
    assert hashlib.sha256(source.read_bytes()).hexdigest() == '62cf031a85c59a7f023c2b525115497dfb0821de9c964c1a5cf905c549d156f7'
    doc = app.importManager.importToNewDocument(app.importManager.createSTEPImportOptions(str(source)))
    assert doc
    doc.name = 'BGD_ISSUE11_R3'
    design = adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    root = design.rootComponent
    records = []
    for o in root.allOccurrences:
        b = o.boundingBox
        records.append({'path': o.fullPathName, 'name': o.component.name,
                        'bodies': o.component.bRepBodies.count,
                        'min_mm': [v*10 for v in b.minPoint.asArray()],
                        'max_mm': [v*10 for v in b.maxPoint.asArray()],
                        'transform': o.transform2.asArray()})
    (OUT/'source-import.json').write_text(json.dumps({'fusion_version': app.version, 'records': records}, indent=2)+'\n')
    archive = OUT/'X650_manufacturer_reference.f3d'
    assert not archive.exists()
    assert design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(archive)))
    app.activeViewport.fit()
    print(json.dumps({'document':doc.name, 'occurrences':len(records), 'root_bodies':root.bRepBodies.count}))
