"""Finish continuous support cradles, 6mm rails and locking-fastener envelopes."""
import json,math
from pathlib import Path
import adsk.core
import adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
def run(_context:str):
 a=adsk.core.Application.get();doc=next(d for d in a.documents if d.name=='BGD_ISSUE11_R3_PHONE_D500_2P_V2');doc.activate();d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent;tm=adsk.fusion.TemporaryBRepManager.get()
 assert not r.attributes.itemByName('BGD','d500_manufacturing_candidates')
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
 # Unite module trays and their edge/tie features.
 for pre in ['FC_CP2102N','TOF_CP2102N','MCP2221A']:
  names=[o.component.name for o in r.occurrences if o.component.name.startswith(pre) and o.component.attributes.itemByName('BGD','representation').value.startswith('DESIGNED_PRINT')]
  names.sort(key=lambda n:0 if n.endswith('_TRAY') else 1)
  merge(names,pre+'_CONTINUOUS_CRADLE')
 names=[o.component.name for o in r.occurrences if o.component.name.startswith(('USB_HUB_SIDE_LEDGE','USB_HUB_POST','USB_HUB_END_STOP'))]
 # First sideledge+its post, then both endbridges, then opposite side.
 names.sort(key=lambda n:0 if n=='USB_HUB_SIDE_LEDGE_38' else 1 if n=='USB_HUB_POST_38' else 2 if 'END_STOP' in n else 3)
 merge(names,'USB_HUB_CONTINUOUS_CRADLE_FRAME_ATTACHMENT_PENDING')
 # Continuous main printed base. 6mm rails retain original topZ26; plate attachments remain C4.
 names=[o.component.name for o in r.occurrences if o.component.name.startswith(('PAYLOAD_','PACK2P_END_STOP','PACK2P_SIDE_GUIDE','PACK2P_CROSS_SUPPORT','PACK_STANDOFF'))]
 b=copy('PAYLOAD_RAIL_INTERFACE_PENDING_-22')
 for x in [-22,22]:union(b,solid([x,-5,23],[8,210,6]))
 for n in names:
  if n!='PAYLOAD_RAIL_INTERFACE_PENDING_-22':union(b,copy(n))
 for x in [-26.5,26.5]:union(b,solid([x,25,38],[3,145,8]))
 for x in [-22,22]:
  for y in [-104,-94,-4,12]:assert tm.booleanOperation(b,cyl(x,y,14,35,1.6),adsk.fusion.BooleanTypes.DifferenceBooleanType)
 assert b.shells.count==1,'Mainbase must be connected'
 for n in names:get(n).deleteMe()
 add('MAIN_PAYLOAD_BASE_6MM_RAILS_FRAME_INTERFACE_PENDING',b)
 # M3 foot joint: 4mmfoot+6mmrail+4mmnyloc; M3x16 exits2mm beyond insert.
 for o in list(r.occurrences):
  n=o.component.name
  if n.startswith(('D500_FOOT_M3','PHONE_FOOT_M3')):
   bb=o.boundingBox;x=(bb.minPoint.x+bb.maxPoint.x)*5;y=(bb.minPoint.y+bb.maxPoint.y)*5;o.deleteMe()
   if 'SHANK' in n:
    add(n.replace('M3X12','M3X16'),cyl(x,y,14,30,1.5),'PURCHASED_M3X16_SHANK_VERIFY_HEAD_BEARING_AND_INSERT_EXIT')
   else:add(n.replace('_NUT_','_NYLOC_'),solid([x,y,18],[5.5,6.35,4]),'SOURCE_ACCU_HNN_M3_A2_AF5_5_HEIGHT4_ENVELOPE')
 # Phone closure pocket deepened for source4mmnyloc, retaining removable topbar.
 b=copy('PHONE_UP10_CONTINUOUS_CARRIER')
 for x,yy,depth in [(-84.5,-90,14),(84.5,-86,22)]:assert tm.booleanOperation(b,pitched([x,yy,143.8],[5.8,depth,4.2]),adsk.fusion.BooleanTypes.DifferenceBooleanType)
 assert b.shells.count==1;get('PHONE_UP10_CONTINUOUS_CARRIER').deleteMe();add('PHONE_UP10_CONTINUOUS_CARRIER',b)
 for x in [-84.5,84.5]:
  get('DIN934_NUT_ENVELOPE_'+str(x)).deleteMe();add('PHONE_M3_NYLOC_'+str(x),pitched([x,-94,143.8],[5.5,6.35,4]),'SOURCE_M3_AF5_5_HEIGHT4_NYLOC_ORIENT_INSERT_TOWARD_SCREW_EXIT')
 # M2 locking nuts sourceAF4,H2.8; M2x8 still crosses completeinsert onlyif3.5footassumptionholds.
 for i,(x,y) in enumerate([(-23.4,-8.525),(23.4,-8.525),(0,23.395)]):
  get('D500_M2_NUT_C4_'+str(i)).deleteMe();add('D500_M2_NYLOC_'+str(i),solid([x,y,148.4],[4,4.62,2.8]),'SOURCE_ACCU_HNN_M2_A2_HEIGHT2_8_AF4_VERIFY_ENGAGEMENT')
 r.attributes.add('BGD','d500_manufacturing_candidates','continuouscradles6mmrailsM3M2nyloc;frameattachmentunclosed')
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
 result=json.loads((OUT/'phone-d500-2p-v2-final.json').read_text());result.update(status='CURRENT_NATIVE_PRINT_CANDIDATES_NOT_FABRICATION_OR_FLIGHT_RELEASE',parts=parts,print_mass_by_part_g=pm,full_density_prints_g=sum(pm.values()),candidate_intersections=hits,print_shell_counts=shells,rail_thickness_mm=6,phone_nut_pocket_height_mm=4.2,foot_fasteners='8xM3x16with4mmnyloc;3xM2x8with2.8mmnylocfootthicknessconditional')
 (OUT/'phone-d500-2p-candidate.json').write_text(json.dumps(result,indent=2)+'\n')
 assert d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(OUT/'phone-d500-2p-candidate.f3d')))
 assert d.exportManager.execute(d.exportManager.createSTEPExportOptions(str(OUT/'phone-d500-2p-candidate.step')))
 a.activeViewport.fit();a.activeViewport.saveAsImageFile(str(OUT/'phone-d500-2p-candidate.png'),1600,1200)
 print(json.dumps({'parts':len(parts),'prints_g':sum(pm.values()),'hits':hits,'print_shells':shells}))
