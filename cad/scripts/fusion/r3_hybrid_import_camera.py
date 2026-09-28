"""Start the selected hybrid document with exact public Luxonis enclosure geometry."""
import hashlib
import json
from pathlib import Path
import adsk.core
import adsk.fusion

OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')

def run(_context: str):
    app=adsk.core.Application.get()
    assert not any(d.name=='BGD_R3_HYBRID' for d in app.documents),'Inspect existing hybrid document before retry'
    source=OUT/'sources/hybrid-oak-d-pro-enclosure.stp'
    doc=app.importManager.importToNewDocument(app.importManager.createSTEPImportOptions(str(source)))
    assert doc
    doc.name='BGD_R3_HYBRID'
    design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    root=design.rootComponent
    records=[]
    for o in root.allOccurrences:
        b=o.boundingBox
        holes=[]
        for body in o.bRepBodies:
            for face in body.faces:
                cylinder=adsk.core.Cylinder.cast(face.geometry)
                if cylinder:
                    holes.append({'radius_mm':cylinder.radius*10,'origin_mm':[v*10 for v in cylinder.origin.asArray()],'axis':cylinder.axis.asArray()})
        records.append({'path':o.fullPathName,'bodies':o.component.bRepBodies.count,
                        'min_mm':[v*10 for v in b.minPoint.asArray()],
                        'max_mm':[v*10 for v in b.maxPoint.asArray()],'cylinders':holes})
    report={'document':doc.name,'source':'Luxonis public DM9098Pro_enclosure.stp',
            'sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'fusion_version':app.version,
            'status':'Manufacturer enclosure reference; current A00565 receiving comparison still required','occurrences':records}
    (OUT/'hybrid-camera-source.json').write_text(json.dumps(report,indent=2)+'\n')
    archive=OUT/'hybrid-camera-source.f3d'
    assert not archive.exists()
    assert design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(archive)))
    app.activeViewport.fit()
    app.activeViewport.saveAsImageFile(str(OUT/'hybrid-camera-source.png'),1400,1000)
    print(json.dumps({'document':doc.name,'occurrences':len(records),'root_bodies':root.bRepBodies.count}))
