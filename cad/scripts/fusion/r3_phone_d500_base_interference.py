"""Finish continuous support cradles, 6mm rails and locking-fastener envelopes."""
import json,math
from pathlib import Path
import adsk.core
import adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
def run(_context:str):
 a=adsk.core.Application.get();doc=next(d for d in a.documents if d.name=='BGD_ISSUE11_R3_PHONE_D500_2P_V2');doc.activate();d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent;tm=adsk.fusion.TemporaryBRepManager.get()
 def pt(v):return adsk.core.Point3D.create(*[x/10 for x in v])
 def solid(c,s):return tm.createBox(adsk.core.OrientedBoundingBox3D.create(pt(c),adsk.core.Vector3D.create(1,0,0),adsk.core.Vector3D.create(0,1,0),*[x/10 for x in s]))
 def cyl(x,y,z0,z1,rad):return tm.createCylinderOrCone(pt([x,y,z0]),rad/10,pt([x,y,z1]),rad/10)
 rot=adsk.core.Matrix3D.create();rot.setToRotation(math.radians(-10),adsk.core.Vector3D.create(1,0,0),pt([0,-95,110]))
 def pitched(c,s):b=solid(c,s);assert tm.transform(b,rot);return b
 def get(n):return next(o for o in r.occurrences if o.component.name==n)
 def copy(n):o=get(n);b=tm.copy(o.component.bRepBodies.item(0));assert tm.transform(b,o.transform2);return b
 def add(n,b,k='DESIGNED_PRINT_CONTINUOUS_CANDIDATE_NOT_FABRICATION_RELEASE'):
  o=r.occurrences.addNewComponent(adsk.core.Matrix3D.create());o.component.name=n;o.component.attributes.add('BGD','representation',k);f=o.component.features.baseFeatures.add();f.startEdit();o.component.bRepBodies.add(b,f);f.finishEdit();return o
 def union(b,q):assert tm.booleanOperation(b,q,adsk.fusion.BooleanTypes.UnionBooleanType);return b
 def merge(names,n,b=None):
  b=copy(names[0]) if b is None else b
  for x in names[1:] if b is not None else names:union(b,copy(x))
  assert b.shells.count==1,n+' must be connected'
  for x in names:get(x).deleteMe()
  return add(n,b)
 pairs=[]
 base=get('MAIN_PAYLOAD_BASE_8MM_RAILS_FRAME_INTERFACE_PENDING')
 for o in r.occurrences:
  if o==base or o.component.attributes.itemByName('BGD','representation').value.startswith('DESIGNED_PRINT'):continue
  if not base.boundingBox.intersects(o.boundingBox):continue
  g=adsk.core.ObjectCollection.create();g.add(base);g.add(o);rs=d.analyzeInterference(d.createInterferenceInput(g));v=sum(q.interferenceBody.volume*1000 for q in rs)
  if v>.01:pairs.append({'part':o.component.name,'intersection_mm3':v})
 print(json.dumps(pairs))
