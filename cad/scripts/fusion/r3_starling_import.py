"""Preserve manufacturer Rev2 STEP in a separate Starling reference document."""
import hashlib
import json
from pathlib import Path
import adsk.core
import adsk.fusion

OUT = Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')


def run(_context: str):
    app = adsk.core.Application.get()
    assert not any(d.name == 'BGD_ISSUE11_R3_STARLING' for d in app.documents), 'Inspect existing document before retry'
    source = OUT / 'sources/starling2max-hw-r2.step'
    digest = hashlib.sha256(source.read_bytes()).hexdigest()
    assert digest == '5f961e7589284bfc9dcd26bd3b9be799fc679dde8cd9555f849f83ad83718f83'
    doc = app.importManager.importToNewDocument(app.importManager.createSTEPImportOptions(str(source)))
    assert doc
    doc.name = 'BGD_ISSUE11_R3_STARLING'
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
    (OUT/'starling-source-import.json').write_text(json.dumps({'fusion_version': app.version,
        'source_sha256': digest, 'source_revision': 'manufacturer published hardware Rev2; not exact C29 confirmation',
        'records': records}, indent=2)+'\n')
    archive = OUT/'starling-manufacturer-rev2.f3d'
    assert not archive.exists()
    assert design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(archive)))
    app.activeViewport.fit()
    app.activeViewport.saveAsImageFile(str(OUT/'starling-manufacturer-rev2.png'),1400,1000)
    print(json.dumps({'document':doc.name, 'occurrences':len(records), 'root_bodies':root.bRepBodies.count}))
