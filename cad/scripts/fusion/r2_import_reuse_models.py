"""Inspect acquired commercial CAD in separate local documents before reuse."""
import hashlib
import json
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT=Path(r'C:\Users\zvent\Downloads\B.G.D')
OUT=ROOT/'cad/engineering-r2-2026-09-10'
def run(_context: str):
    app=adsk.core.Application.get()
    records=[]
    for label,file in [('R2_POLOLU_REFERENCE','electrical-pololu-d24v7.step'),('R2_HOLYBRO_REFERENCE','mechanical_holybro_x500v2.step')]:
        source=ROOT/'docs/hardware/engineering-r2-2026-09-10'/file
        assert source.is_file()
        existing=[d for d in app.documents if d.name==label]
        assert len(existing)<=1
        doc=existing[0] if existing else app.importManager.importToNewDocument(app.importManager.createSTEPImportOptions(str(source)))
        assert doc;doc.name=label;doc.activate()
        design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
        root=design.rootComponent
        root.attributes.add('BGD','reference_only','Manufacturer integration study; exact revision/license and geometry reconciliation required; not selected aircraft geometry')
        def bounds(obj):
            bb=obj.boundingBox
            return {'min_mm':[v*10 for v in bb.minPoint.asArray()],'max_mm':[v*10 for v in bb.maxPoint.asArray()]}
        children=[]
        def walk(comp,path=''):
            for body in comp.bRepBodies:
                children.append({'path':path+'/'+body.name,'volume_mm3':body.volume*1000,**bounds(body)})
            for occ in comp.occurrences:
                children.append({'path':path+'/'+occ.name,'kind':'occurrence',**bounds(occ)})
                walk(occ.component,path+'/'+occ.name)
        walk(root)
        record={'document':label,'source':str(source.relative_to(ROOT)),'sha256':hashlib.sha256(source.read_bytes()).hexdigest(),
                'bbox':bounds(root),'entities':children,'warning':'Nested body coordinates may be component-local; occurrence bounding boxes use their parent context. No cross-context fit or mass claim.'}
        (OUT/(label.lower()+'-inspection.json')).write_text(json.dumps(record,indent=2)+'\n')
        records.append({'document':label,'entities':len(children),'bbox':record['bbox']})
    next(d for d in app.documents if d.name=='BGD_ISSUE11_R2').activate()
    print(json.dumps(records))
