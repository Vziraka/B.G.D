"""Close positive printed load paths; preserve initial layout as evidence."""
import json,math
from pathlib import Path
import adsk.core
import adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')
def run(_context:str):
 a=adsk.core.Application.get();doc=next(d for d in a.documents if d.name=='BGD_ISSUE11_R3_PHONE_D500_2P');doc.activate();d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent;tm=adsk.fusion.TemporaryBRepManager.get()
 assert not r.attributes.itemByName('BGD','d500_positive_carriers')
 def pt(v):return adsk.core.Point3D.create(*[x/10 for x in v])
 def solid(c,s):return tm.createBox(adsk.core.OrientedBoundingBox3D.create(pt(c),adsk.core.Vector3D.create(1,0,0),adsk.core.Vector3D.create(0,1,0),*[x/10 for x in s]))
 rot=adsk.core.Matrix3D.create();rot.setToRotation(math.radians(-10),adsk.core.Vector3D.create(1,0,0),pt([0,-95,110]))
 def pitched(c,s):b=solid(c,s);assert tm.transform(b,rot);return b
 def body(n):return tm.copy(next(o for o in r.occurrences if o.component.name==n).component.bRepBodies.item(0))
 def combine(b,q):assert tm.booleanOperation(b,q,adsk.fusion.BooleanTypes.UnionBooleanType);return b
 def add(n,b):
  o=r.occurrences.addNewComponent(adsk.core.Matrix3D.create());o.component.name=n;o.component.attributes.add('BGD','representation','DESIGNED_PRINT_CONTINUOUS_CARRIER_NOT_FABRICATION_RELEASE');f=o.component.features.baseFeatures.add();f.startEdit();o.component.bRepBodies.add(b,f);f.finishEdit();return o
 gantry=['D500_PLATFORM','D500_MAST_-32','D500_MAST_32','D500_LOWER_CABLE_TIE','D500_UPPER_CABLE_TIE'];b=body(gantry[0])
 for n in gantry[1:]:combine(b,body(n))
 for o in list(r.occurrences):
  if o.component.name in gantry:o.deleteMe()
 add('D500_CONTINUOUS_GANTRY',b)
 names=['PHONE_BOTTOM_CROSSBAR','PHONE_RIGHT_LOWER_USB_OPEN','PHONE_RIGHT_UPPER_NUT_BOSS','PHONE_LEFT_NUT_BOSS','PHONE_UP10_POST_-22','PHONE_UP10_POST_22','LAMP_SUPPORT_INTERFACE_PENDING','LAMP_COLD_SHOE_BASE','USB_PHONE_CABLE_RESTRAINT']
 clips=[o.component.name for o in r.occurrences if o.component.name.startswith(('PHONE_SCREEN_SIDE_CAPTURE','PHONE_REAR_CAPTURE'))]
 b=body('PHONE_BOTTOM_CROSSBAR')
 combine(b,pitched([84.5,-94,74.5],[10,16,6]))
 combine(b,body('PHONE_RIGHT_LOWER_USB_OPEN'))
 combine(b,pitched([84.5,-85.5,84],[10,9,25]))
 combine(b,pitched([84.5,-81.5,111.5],[10,5,74]))
 combine(b,pitched([84.5,-85.5,135.5],[10,9,26]))
 for n in ['PHONE_RIGHT_UPPER_NUT_BOSS','PHONE_LEFT_NUT_BOSS','PHONE_UP10_POST_-22','PHONE_UP10_POST_22']:combine(b,body(n))
 combine(b,pitched([0,-100.5,71.75],[7,2,.5]))
 for n in clips:combine(b,body(n))
 combine(b,body('LAMP_SUPPORT_INTERFACE_PENDING'));combine(b,body('LAMP_COLD_SHOE_BASE'))
 combine(b,pitched([92,-95,84],[8,12,5]));combine(b,body('USB_PHONE_CABLE_RESTRAINT'))
 assert tm.booleanOperation(b,pitched([84.5,-86,143.8],[5.8,22,2.6]),adsk.fusion.BooleanTypes.DifferenceBooleanType)
 for o in list(r.occurrences):
  if o.component.name in names+clips:o.deleteMe()
 add('PHONE_UP10_CONTINUOUS_CARRIER',b)
 r.attributes.add('BGD','d500_positive_carriers','onegantryandonephone_lowercarrier;removabletopbar;USBbackboneclearanceandnutentry')
 a.activeViewport.refresh();adsk.doEvents()
 parts=[];pm={};hits=[];camera_hits=[];usb_hits=[]
 rotors=[o for o in r.occurrences if o.component.name.startswith('ROTOR_')];camera=next(o for o in r.occurrences if o.component.name=='PIXEL_FULL_CAMERA_BAR_RESERVE');usb=next(o for o in r.occurrences if o.component.name=='PIXEL_USB_PLUG_AND_BEND')
 for o in r.occurrences:
  k=o.component.attributes.itemByName('BGD','representation').value;b=o.boundingBox;v=sum(q.volume*1000 for q in o.component.bRepBodies)
  if k.startswith('DESIGNED_PRINT'):pm[o.component.name]=v*.00127
  parts.append({'name':o.component.name,'kind':k,'min_mm':[x*10 for x in b.minPoint.asArray()],'max_mm':[x*10 for x in b.maxPoint.asArray()],'volume_mm3':v})
  if not k.startswith('DESIGNED_PRINT'):continue
  for keep in rotors+[camera,usb]:
   if not b.intersects(keep.boundingBox):continue
   g=adsk.core.ObjectCollection.create();g.add(o);g.add(keep);rs=d.analyzeInterference(d.createInterferenceInput(g));vol=sum(t.interferenceBody.volume*1000 for t in rs)
   if vol>.01:(camera_hits if keep==camera else usb_hits if keep==usb else hits).append({'part':o.component.name,'keepout':keep.component.name,'mm3':vol})
 result=json.loads((OUT/'phone-d500-2p-layout.json').read_text());result.update(status='NATIVE_CONTINUOUS_CARRIERS_REVIEW_NOT_FABRICATION_RELEASE',parts=parts,print_mass_by_part_g=pm,full_density_prints_g=sum(pm.values()),rotor_intersections=hits,camera_bar_intersections=camera_hits,usb_plug_reserve_intersections=usb_hits,positive_carriers=['D500_CONTINUOUS_GANTRY','PHONE_UP10_CONTINUOUS_CARRIER'])
 (OUT/'phone-d500-2p-final.json').write_text(json.dumps(result,indent=2)+'\n')
 assert d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(OUT/'phone-d500-2p-final.f3d')))
 assert d.exportManager.execute(d.exportManager.createSTEPExportOptions(str(OUT/'phone-d500-2p-final.step')))
 a.activeViewport.fit();a.activeViewport.saveAsImageFile(str(OUT/'phone-d500-2p-final.png'),1600,1200)
 print(json.dumps({'parts':len(parts),'prints_g':sum(pm.values()),'rotor_hits':hits,'camera_hits':camera_hits,'USB_hits':usb_hits}))
