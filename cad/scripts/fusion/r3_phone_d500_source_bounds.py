"""Resolve assembly transforms in the wiki-linked sensor reference."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
def run(_context:str):
 a=adsk.core.Application.get();doc=next(d for d in a.documents if d.name=='BGD_R3_D500_LINKED_SOURCE_REFERENCE');d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent
 p=OUT/'phone-d500-linked-source.json';j=json.loads(p.read_text());j['occurrences']=[]
 for o in r.allOccurrences:
  b=o.boundingBox;j['occurrences'].append({'name':o.component.name,'min_mm':[x*10 for x in b.minPoint.asArray()],'max_mm':[x*10 for x in b.maxPoint.asArray()],'transform':list(o.transform2.asArray())})
 p.write_text(json.dumps(j,indent=2));print(json.dumps(j['occurrences']))
