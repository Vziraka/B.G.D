"""Integrate source-dimensioned D500, conservative 2P pack, and phone-up10 candidate.

Preserves prior archives. Frame attachment and delivered-part fit remain unqualified.
"""
import json,math
from pathlib import Path
import adsk.core
import adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
def run(_context:str):
 app=adsk.core.Application.get();name='BGD_ISSUE11_R3_PHONE_D500_2P_V2'
 assert not any(d.name==name for d in app.documents),'Inspect existing document before retry'
 doc=app.importManager.importToNewDocument(app.importManager.createFusionArchiveImportOptions(str(OUT/'phone-folding-final.f3d')));assert doc;doc.name=name
 d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent;tm=adsk.fusion.TemporaryBRepManager.get()
 def point(v):return adsk.core.Point3D.create(*[x/10 for x in v])
 def solid(c,s):return tm.createBox(adsk.core.OrientedBoundingBox3D.create(point(c),adsk.core.Vector3D.create(1,0,0),adsk.core.Vector3D.create(0,1,0),*[x/10 for x in s]))
 def cylinder(c,z0,z1,rad,rad2=None):return tm.createCylinderOrCone(point([*c,z0]),rad/10,point([*c,z1]),(rad if rad2 is None else rad2)/10)
 def add(n,b,k='DESIGNED_PRINT_CANDIDATE_NOT_FABRICATION_RELEASE',visible=True):
  o=r.occurrences.addNewComponent(adsk.core.Matrix3D.create());o.component.name=n;o.component.attributes.add('BGD','representation',k)
  f=o.component.features.baseFeatures.add();f.startEdit();o.component.bRepBodies.add(b,f);f.finishEdit();o.isLightBulbOn=visible;return o
 def box(n,c,s,k='DESIGNED_PRINT_CANDIDATE_NOT_FABRICATION_RELEASE',cuts=(),visible=True):
  b=solid(c,s)
  for cut in cuts:assert tm.booleanOperation(b,cut,adsk.fusion.BooleanTypes.DifferenceBooleanType)
  return add(n,b,k,visible)
 def delete_prefix(prefixes):
  for o in list(r.occurrences):
   if o.component.name.startswith(prefixes):o.deleteMe()
 # Pitch phone, its closure and lamp together, then rebuild lower supports.
 rotate=adsk.core.Matrix3D.create();rotate.setToRotation(math.radians(-10),adsk.core.Vector3D.create(1,0,0),point([0,-95,110]))
 pitched=[]
 for o in list(r.occurrences):
  n=o.component.name
  if (n.startswith(('PIXEL','PHONE_','M3X12_SCREW','DIN934_NUT','VL49','LAMP_','USB_PHONE_CABLE_RESTRAINT')) and not n.startswith('PHONE_POST')):
   bodies=[tm.copy(b) for b in o.component.bRepBodies]
   for b in bodies:assert tm.transform(b,o.transform2)
   k=o.component.attributes.itemByName('BGD','representation').value;vis=o.isLightBulbOn
   o.deleteMe()
   for b in bodies:assert tm.transform(b,rotate);add(n,b,k,vis)
   pitched.append(n)
 delete_prefix(('PHONE_POST','NEXUS6S1P','PACK_END_STOP','PACK_SIDE_GUIDE','PACK_CROSS_SUPPORT','PACK_STRAP_ROUTE','PACK_CASE_TEMP'))
 for x in [-22,22]:
  endpoint=point([x,-94,63.5]);endpoint.transformBy(rotate)
  stalk=tm.createCylinderOrCone(point([x,-99,29]),.4,endpoint,.4)
  cap=solid([x,-94,63.5],[5,12,10]);assert tm.transform(cap,rotate)
  assert tm.booleanOperation(stalk,cap,adsk.fusion.BooleanTypes.UnionBooleanType)
  assert tm.booleanOperation(stalk,solid([x,-99,28],[20,22,4]),adsk.fusion.BooleanTypes.UnionBooleanType)
  for y in [-104,-94]:assert tm.booleanOperation(stalk,cylinder([x,y],18,35,1.6),adsk.fusion.BooleanTypes.DifferenceBooleanType)
  add('PHONE_UP10_POST_'+str(x),stalk)
  for y in [-104,-94]:
   add('PHONE_FOOT_M3X12_SHANK_'+str(x)+'_'+str(y),cylinder([x,y],18,30,1.5),'PURCHASED_M3X12_REFERENCE_VERIFY_HEAD_AND_LOCKING')
   box('PHONE_FOOT_M3_NUT_'+str(x)+'_'+str(y),[x,y,20.8],[5.5,6.35,2.4],'DIN934_NOMINAL_ENVELOPE_NOT_HEX_SOLID')
 # Approximate factory pack source envelope; larger reserve does not replace source dimensions.
 box('NEXUS6S2P_SOURCE_ENVELOPE',[0,25,77],[48,139,72],'SOURCE_APPROX139X48X72_CONFIGURED_MASS1035G_CONSERVATIVE')
 box('NEXUS6S2P_RECEIVING_CLEARANCE',[0,25,77],[50,145,78],'C4_RECEIVING_DIMENSION_RESERVE_NOT_ACTUAL_BODY',visible=False)
 for y in [-48,98]:box('PACK2P_END_STOP_'+str(y),[0,y,43],[56,3,12])
 for x in [-26.5,26.5]:box('PACK2P_SIDE_GUIDE_'+str(x),[x,25,38],[3,139,8])
 for y in [-18,68]:
  box('PACK2P_CROSS_SUPPORT_'+str(y),[0,y,38],[56,8,4])
  box('PACK2P_STRAP_ROUTE_'+str(y),[0,y,75],[66,16,84],'TWO_INDEPENDENT_STRAP_ROUTES_NOT_SOLID_MATERIAL',visible=False)
 box('PACK2P_CASE_TEMP_C4',[26.5,25,77],[5,20,15],'C4_TMP117_CASE_CONTACT_AND_INSULATION')
 # Known custom rail joints. No new primary frame holes are assumed.
 boltxy=[(x,y) for x in [-22,22] for y in [-4,12]]
 for o in list(r.occurrences):
  if o.component.name.startswith('PAYLOAD_RAIL_INTERFACE_PENDING'):
   n=o.component.name;b=tm.copy(o.component.bRepBodies.item(0));x=-22 if '-22' in n else 22;o.deleteMe()
   for y in [-104,-94,-4,12]:assert tm.booleanOperation(b,cylinder([x,y],18,35,1.6),adsk.fusion.BooleanTypes.DifferenceBooleanType)
   add(n,b)
 for x in [-32,32]:
  xx=-27 if x<0 else 27;shaft=solid([x,4,89.9],[6,8,119.8]);foot=solid([xx,4,28],[20,25,4])
  assert tm.booleanOperation(shaft,foot,adsk.fusion.BooleanTypes.UnionBooleanType)
  for y in [-4,12]:assert tm.booleanOperation(shaft,cylinder([-22 if x<0 else 22,y],18,35,1.6),adsk.fusion.BooleanTypes.DifferenceBooleanType)
  add('D500_MAST_'+str(x),shaft)
 for x,y in boltxy:
  add('D500_FOOT_M3X12_SHANK_'+str(x)+'_'+str(y),cylinder([x,y],18,30,1.5),'PURCHASED_REFERENCE_M3X12_VERIFY_HEAD_AND_LOCKING')
  box('D500_FOOT_M3_NUT_'+str(x)+'_'+str(y),[x,y,20.8],[5.5,6.35,2.4],'DIN934_NOMINAL_ENVELOPE_NOT_HEX_SOLID')
 # Platform fits source mounting triangle and keeps all support beneath optical band.
 holes=[(-23.4,-8.525),(23.4,-8.525),(0,23.395)]
 cuts=[solid([0,0,151.3],[30,20,8])]+[cylinder([x,y],145,158,1.25) for x,y in holes]
 box('D500_PLATFORM',[0,4,151.3],[70,54,3],cuts=cuts)
 # Current PDF geometry: 35high, optical27.2abovebase. Linked LD19 STEP is inapplicable.
 box('D500_STL19P_FIXED_HOUSING',[0,0,163.9],[38.59,38.59,22.2],'SOURCE_DIMENSION_ENVELOPE_NOT_EXACT_TAPERED_BODY')
 add('D500_STL19P_ROTATING_HEAD',cylinder([0,0],175,187.8,18.0,17.645),'SOURCE_TOP35_29D12_8H_LOWER_RADIUS_APPROXIMATE')
 for i,(x,y) in enumerate(holes):
  b=cylinder([x,y],152.8,156.3,3.6)
  for cut in [cylinder([x,y],150,158,1.25),cylinder([x,y],154.3,158,2.23)]:assert tm.booleanOperation(b,cut,adsk.fusion.BooleanTypes.DifferenceBooleanType)
  add('D500_STL19P_MOUNT_EAR_'+str(i),b,'SOURCE_HOLE2_5_COUNTERBORE4_46X2_BASE3_5THICK_C4')
  add('D500_M2X8_SHANK_C4_'+str(i),cylinder([x,y],146.3,154.3,1),'C4_M2X8_ENGAGEMENT_REQUIRES_ACTUAL_FOOT_THICKNESS')
  box('D500_M2_NUT_C4_'+str(i),[x,y,149],[4,4.62,1.6],'M2_NUT_NOMINAL_ENVELOPE_VERIFY_SOURCE')
 box('D500_SOURCE_OPTICAL_DATUM',[0,0,180],[.8,.8,.8],'SOURCE27_2_ABOVEBASE_OPTICAL_DATUM_NOT_SOLID_MATERIAL',visible=False)
 # Lidar lead to existing MCP2221A RX; no fifth USB device or new host lead.
 box('D500_4PIN_LOOM_CORRIDOR',[ -31,12,90],[10,16,142],'C4_RETAINED_DATA_POWER_PATH_TO_EXISTING_MCP_RX',visible=False)
 box('D500_LOWER_CABLE_TIE',[-32,4,40],[12,14,4],cuts=(solid([-32,4,40],[8,3.2,8]),))
 box('D500_UPPER_CABLE_TIE',[-32,4,140],[12,14,4],cuts=(solid([-32,4,140],[8,3.2,8]),))
 r.attributes.add('BGD','phone_d500_2p','SOURCE_STUDY_2950G_0_79_20_8V_UP10_LOW_FLIGHT_ENVELOPE')
 adsk.doEvents();app.activeViewport.refresh()
 parts=[];pm={};hits=[];camera_hits=[]
 rotors=[o for o in r.occurrences if o.component.name.startswith('ROTOR_')]
 camera=next(o for o in r.occurrences if o.component.name=='PIXEL_FULL_CAMERA_BAR_RESERVE')
 for o in r.occurrences:
  k=o.component.attributes.itemByName('BGD','representation').value;b=o.boundingBox;v=sum(q.volume*1000 for q in o.component.bRepBodies)
  if k.startswith('DESIGNED_PRINT'):pm[o.component.name]=v*.00127
  parts.append({'name':o.component.name,'kind':k,'min_mm':[x*10 for x in b.minPoint.asArray()],'max_mm':[x*10 for x in b.maxPoint.asArray()],'volume_mm3':v})
  if not(k.startswith('DESIGNED_PRINT') or o.component.name.startswith(('PIXEL7','VL49','NEXUS6S2P_SOURCE','D500_STL','ADAFRUIT','TPM2','FC_CP','TOF_CP','MCP222','MIDI','PACK2P_CASE','AIO_CASE','USB_A_DOWN'))):continue
  for keep in rotors+([camera] if k.startswith('DESIGNED_PRINT') else []):
   if not b.intersects(keep.boundingBox):continue
   g=adsk.core.ObjectCollection.create();g.add(o);g.add(keep);rs=d.analyzeInterference(d.createInterferenceInput(g));vol=sum(t.interferenceBody.volume*1000 for t in rs)
   if vol>.01:(camera_hits if keep==camera else hits).append({'part':o.component.name,'keepout':keep.component.name,'mm3':vol})
 result={'status':'NATIVE_D500_2P_REVIEW_NOT_FABRICATION_OR_FLIGHT_RELEASE','document':name,'source_archive':'phone-folding-final.f3d','parts':parts,'print_mass_by_part_g':pm,'full_density_prints_g':sum(pm.values()),'rotor_intersections':hits,'camera_bar_intersections':camera_hits,'phone_pitch_up_deg':10,'phone_rotation_center_mm':[0,-95,110],'pitched_parts':pitched,'lidar_optical_center_mm':[0,0,180],'lidar_base_z_mm':152.8,'lidar_top_z_mm':187.8,'pack_source_dimensions_mm':[48,139,72],'pack_planning_mass_g':1035,'lidar_mount_holes_xy_mm':holes,'unclosed':['Exact purchased frame mounting/hinges/gear','Configured pack mass/lead envelope and7pin balancelead','Lidar foot thickness/fastener engagement andsourceyaw','Printed assembly process/retention/vibration/hot creep','Actualcameraopticaldatumandcablebends','Physicalsensor/night/bodyattitudequalification']}
 (OUT/'phone-d500-2p-v2-layout.json').write_text(json.dumps(result,indent=2)+'\n')
 assert d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(OUT/'phone-d500-2p-v2-layout.f3d')))
 assert d.exportManager.execute(d.exportManager.createSTEPExportOptions(str(OUT/'phone-d500-2p-v2-layout.step')))
 app.activeViewport.fit();app.activeViewport.saveAsImageFile(str(OUT/'phone-d500-2p-v2-layout.png'),1600,1200)
 print(json.dumps({'parts':len(parts),'prints_g':sum(pm.values()),'rotor_hits':hits,'camera_hits':camera_hits}))
