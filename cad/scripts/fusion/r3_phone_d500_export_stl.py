"""Export only candidate printed bodies to millimeter binary STL, never to a printer."""
import json,hashlib
from pathlib import Path
import adsk.core
import adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
def run(_context:str):
 a=adsk.core.Application.get();doc=next(d for d in a.documents if d.name=='BGD_ISSUE11_R3_PHONE_D500_2P_V2');d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent
 folder=OUT/'phone-d500-2p-print-candidates'/'assembly';folder.mkdir(parents=True,exist_ok=True);records=[]
 for o in r.occurrences:
  k=o.component.attributes.itemByName('BGD','representation').value
  if not k.startswith('DESIGNED_PRINT'):continue
  assert o.component.bRepBodies.count==1 and o.component.bRepBodies.item(0).isSolid and o.component.bRepBodies.item(0).shells.count==1
  path=folder/(o.component.name+'.stl');opt=d.exportManager.createSTLExportOptions(o,str(path));opt.isBinaryFormat=True;opt.unitType=adsk.fusion.DistanceUnits.MillimeterDistanceUnits;opt.sendToPrintUtility=False;opt.surfaceDeviation=.001;opt.normalDeviation=.0872665;opt.maximumEdgeLength=.5
  assert d.exportManager.execute(opt)
  b=o.boundingBox;records.append({'name':o.component.name,'path':str(path.relative_to(OUT)),'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'occurrence_transform_cm':o.transform2.asArray(),'native_volume_mm3':o.component.bRepBodies.item(0).volume*1000,'world_min_mm':[x*10 for x in b.minPoint.asArray()],'world_max_mm':[x*10 for x in b.maxPoint.asArray()]})
 (OUT/'phone-d500-2p-print-candidates'/'native-export.json').write_text(json.dumps({'status':'CANDIDATE_STL_NOT_AUTHORIZATION_TO_PRINT','units':'mm','surface_deviation_mm':.01,'normal_deviation_deg':5,'maximum_edge_mm':5,'records':records},indent=2))
 print(json.dumps({'exported':len(records),'directory':str(folder)}))
