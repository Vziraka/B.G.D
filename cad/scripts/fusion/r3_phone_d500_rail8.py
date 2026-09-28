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
 # Increase rails downward, preserving phone/pack/scan world pose.
 b=copy('MAIN_PAYLOAD_BASE_6MM_RAILS_FRAME_INTERFACE_PENDING')
 for x in [-22,22]:union(b,solid([x,-5,22],[8,210,8]))
 for x in [-22,22]:
  for y in [-104,-94,-4,12]:assert tm.booleanOperation(b,cyl(x,y,12,35,1.6),adsk.fusion.BooleanTypes.DifferenceBooleanType)
 assert b.shells.count==1
 get('MAIN_PAYLOAD_BASE_6MM_RAILS_FRAME_INTERFACE_PENDING').deleteMe();add('MAIN_PAYLOAD_BASE_8MM_RAILS_FRAME_INTERFACE_PENDING',b)
 for o in list(r.occurrences):
  n=o.component.name
  if n.startswith(('D500_FOOT_M3','PHONE_FOOT_M3')):
   bb=o.boundingBox;x=(bb.minPoint.x+bb.maxPoint.x)*5;y=(bb.minPoint.y+bb.maxPoint.y)*5;o.deleteMe()
   if 'SHANK' in n:add(n.replace('M3X16','M3X18'),cyl(x,y,12,30,1.5),'SOURCE_ACCU_SSC_M3_18_A2_SHANK_VERIFY_HEAD_CLEARANCE')
   else:add(n,solid([x,y,16],[5.5,6.35,4]),'SOURCE_ACCU_HNN_M3_A2_AF5_5_HEIGHT4_ENVELOPE')
 r.attributes.add('BGD','rail8mm_repair','8mmrailsM3x18;supportYplusminus55;stockframeinterfacepending')
 a.activeViewport.refresh();adsk.doEvents()
 parts=[];pm={};hits=[];shells={}
 keeps=[o for o in r.occurrences if o.component.name.startswith('ROTOR_') or o.component.name in ['PIXEL_FULL_CAMERA_BAR_RESERVE','PIXEL_USB_PLUG_AND_BEND','PIXEL7_GOOGLE_BODY','NEXUS6S2P_SOURCE_ENVELOPE']]
 for o in r.occurrences:
  k=o.component.attributes.itemByName('BGD','representation').value;bb=o.boundingBox;v=sum(q.volume*1000 for q in o.component.bRepBodies)
  parts.append({'name':o.component.name,'kind':k,'min_mm':[x*10 for x in bb.minPoint.asArray()],'max_mm':[x*10 for x in bb.maxPoint.asArray()],'volume_mm3':v})
  if not k.startswith('DESIGNED_PRINT'):continue
  pm[o.component.name]=v*.00127;shells[o.component.name]=sum(q.shells.count for q in o.component.bRepBodies)
  for keep in keeps:
   if not bb.intersects(keep.boundingBox):continue
   g=adsk.core.ObjectCollection.create();g.add(o);g.add(keep);rs=d.analyzeInterference(d.createInterferenceInput(g));vol=sum(t.interferenceBody.volume*1000 for t in rs)
   if vol>.01:hits.append({'part':o.component.name,'keepout':keep.component.name,'mm3':vol})
 result=json.loads((OUT/'phone-d500-2p-candidate.json').read_text());result.update(status='CURRENT_NATIVE_PRINT_CANDIDATES_NOT_FABRICATION_OR_FLIGHT_RELEASE',parts=parts,print_mass_by_part_g=pm,full_density_prints_g=sum(pm.values()),candidate_intersections=hits,print_shell_counts=shells,rail_thickness_mm=8,phone_nut_pocket_height_mm=4.2,foot_fasteners='8xM3x18with4mmnyloc;3xM2x8with2.8mmnylocfootthicknessconditional')
 (OUT/'phone-d500-2p-candidate.json').write_text(json.dumps(result,indent=2)+'\n')
 assert d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(OUT/'phone-d500-2p-candidate.f3d')))
 assert d.exportManager.execute(d.exportManager.createSTEPExportOptions(str(OUT/'phone-d500-2p-candidate.step')))
 a.activeViewport.fit();a.activeViewport.saveAsImageFile(str(OUT/'phone-d500-2p-candidate.png'),1600,1200)
 print(json.dumps({'parts':len(parts),'prints_g':sum(pm.values()),'hits':hits,'print_shells':shells}))
