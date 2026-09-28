"""Read the D500 wiki-linked LD19 STEP without treating it as an exact STL-19P revision."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
def run(_context:str):
    app=adsk.core.Application.get()
    name='BGD_R3_D500_LINKED_SOURCE_REFERENCE'
    assert not any(d.name==name for d in app.documents)
    doc=app.importManager.importToNewDocument(app.importManager.createSTEPImportOptions(str(OUT/'sources/phone-d500-wiki-linked-LD19.step')))
    assert doc;doc.name=name
    d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent
    parts=[];cyl=[]
    for c in d.allComponents:
        for b in c.bRepBodies:
            bb=b.boundingBox
            parts.append({'component':c.name,'body':b.name,'min_mm':[v*10 for v in bb.minPoint.asArray()],'max_mm':[v*10 for v in bb.maxPoint.asArray()]})
            for f in b.faces:
                g=adsk.core.Cylinder.cast(f.geometry)
                if g:cyl.append({'component':c.name,'radius_mm':g.radius*10,'origin_mm':[v*10 for v in g.origin.asArray()],'axis':list(g.axis.asArray())})
    out={'status':'WIKI_LINKED_LD19_NOT_VERIFIED_EXACT_STL19P','parts':parts,'cylinders':cyl}
    (OUT/'phone-d500-linked-source.json').write_text(json.dumps(out,indent=2))
    assert d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(OUT/'phone-d500-linked-source.f3d')))
    app.activeViewport.fit();app.activeViewport.saveAsImageFile(str(OUT/'phone-d500-linked-source.png'),1200,900)
    print(json.dumps({'document':name,'parts':len(parts),'cylinders':len(cyl)}))
