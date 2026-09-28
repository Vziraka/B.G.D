"""Reopen saved native archive, verify final parts/poses, close only the temporary check document."""
import json,hashlib
from pathlib import Path
import adsk.core,adsk.fusion
O=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
def run(_context:str):
 a=adsk.core.Application.get();original=a.activeDocument
 doc=a.importManager.importToNewDocument(a.importManager.createFusionArchiveImportOptions(str(O/'phone-d500-2p-candidate.f3d')));assert doc
 try:
  d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent
  expected=json.loads((O/'phone-d500-2p-candidate.json').read_text());assert r.occurrences.count==len(expected['parts'])==103
  for p in expected['parts']:
   o=next(o for o in r.occurrences if o.component.name==p['name']);bb=o.boundingBox
   for actual,target in [(bb.minPoint.asArray(),p['min_mm']),(bb.maxPoint.asArray(),p['max_mm'])]:assert all(abs(x*10-y)<.001 for x,y in zip(actual,target)),p['name']
  records=[]
  for ext in ['f3d','step','json','png']:
   p=O/('phone-d500-2p-candidate.'+ext);records.append({'path':str(p),'bytes':p.stat().st_size,'sha256':hashlib.sha256(p.read_bytes()).hexdigest()})
  result={'status':'NATIVE_ARCHIVE_REOPEN_AND_ALL103_COMPONENT_BOUNDS_PASS','files':records,'no_physical_print_purchase_or_flight':True}
  (O/'phone-d500-2p-save-check.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({'parts':103,'native_reopen':True,'all_bounds':True}))
 finally:
  doc.close(False);original.activate()
