"""Check the shipped combined project against sources and its round-trip slice."""
from pathlib import Path
from zipfile import ZipFile
import xml.etree.ElementTree as E
import json, numpy as np
from PIL import Image,ImageDraw,ImageFont
import inspect_toolpaths as ip
H=Path(__file__).resolve().parent;D=H/'bambu-combined';PK=D/'email-package';C='http://schemas.microsoft.com/3dmanufacturing/core/2015/02';P='http://schemas.microsoft.com/3dmanufacturing/production/2015/06';t=lambda n:'{'+C+'}'+n
layout=json.loads((D/'layout.json').read_text())
def extract(f):
 out={}
 with ZipFile(f) as z:
  root=E.fromstring(z.read('3D/3dmodel.model'));conf=E.fromstring(z.read('Metadata/model_settings.config'))
  for item in root.find(t('build')):
   oid=item.get('objectid');ob=root.find(f'.//{t("object")}[@id="{oid}"]');oc=conf.find(f'object[@id="{oid}"]');name=oc.find('metadata[@key="name"]').get('value').removesuffix('.stl')
   allparts=[]
   for comp in ob.find(t('components')):
    mid=comp.get('objectid');mesh=E.fromstring(z.read(comp.get('{'+P+'}path').lstrip('/'))).find(f'.//{t("object")}[@id="{mid}"]');vs=np.array([[float(v.get(k)) for k in 'xyz'] for v in mesh.findall('.//'+t('vertex'))]);tr=np.array(list(map(float,comp.get('transform').split())));vs=vs@tr[:9].reshape(3,3)+tr[9:]
    faces=[tuple(int(a.get(k)) for k in ('v1','v2','v3')) for a in mesh.findall('.//'+t('triangle'))]
    allparts.append((oc.find(f'part[@id="{mid}"]').get('subtype'),vs,faces))
   out[name]=(allparts,list(map(float,item.get('transform').split())),{m.get('key'):m.get('value') for m in oc.findall('metadata')})
 return out
shipped=PK/'BGD-All-Parts-X1E-PETG.3mf';dest=extract(shipped)
with ZipFile(shipped) as z:assert z.testzip() is None and not any(n.endswith('.gcode') for n in z.namelist())
with ZipFile(D/'roundtrip/roundtrip.3mf') as z:
 gc=z.read('Metadata/plate_1.gcode').decode();info=E.fromstring(z.read('Metadata/slice_info.config'));assert not info.findall('.//warning')
rs=json.loads((D/'roundtrip/result.json').read_text());assert rs['return_code']==0
rs0=json.loads((D/'result.json').read_text());assert abs(rs['sliced_plates'][0]['total_predication']-rs0['sliced_plates'][0]['total_predication'])<1
ip.HERE=D
results=[]
for entry in layout:
 name=entry['name'];src=H/'bambu-pi-carrier/pi-carrier-x1e-petg.3mf' if name.startswith('pi-') else H/'bambu-verified/email-package'/f'{name}.3mf'
 old=extract(src)[name];new=dest[name]
 assert len(old[0])==len(new[0])
 for (st,a,fa),(dt,b,fb) in zip(old[0],new[0]):assert st==dt and fa==fb and np.max(np.abs(a-b))<0.001
 assert old[1][:9]==new[1][:9] and abs(old[1][11]-new[1][11])<0.001
 assert all(new[2].get(k)==v for k,v in entry['overrides'].items())
 tr=new[1];layers=ip.read_paths(gc,tr)
 # Filter to this object's separated region; actual camera/depth local origins retained.
 worldlo,worldhi=np.array(entry['bounds']);localcenter=((worldlo+worldhi)/2)[:2]-np.array(tr[9:11]);half=(worldhi-worldlo)[:2]/2+10
 cropped={zz:[v for v in vv if abs((v[0]+v[2])/2-localcenter[0])<half[0] and abs((v[1]+v[3])/2-localcenter[1])<half[1]] for zz,vv in layers.items()};cropped={k:v for k,v in cropped.items() if v}
 hits=ip.support_inside(name,cropped);assert not hits,(name,hits[:2])
 supports=sum(v[5] for vv in cropped.values() for v in vv if v[4].startswith('Support'))
 assert (supports>0)==(entry['overrides']['enable_support']=='1'),(name,supports)
 (D/name).mkdir(exist_ok=True);ip.render(name,cropped)
 results.append(dict(name=name,mesh_and_orientation_preserved=True,support_blockers=entry['blockers'],support_extrusion_mm=round(supports,3),support_in_functional_openings=hits))
# All generated paths, excluding printer startup custom moves, within printable bed.
world=ip.read_paths(gc,[1,0,0,0,1,0,0,0,1,0,0,0]);pts=np.array([(v[i],v[i+1]) for vv in world.values() for v in vv for i in [0,2]])
assert np.min(pts)>0 and np.max(pts)<256
im=Image.new('RGB',(1100,1190),'white');d=ImageDraw.Draw(im);font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',21)
d.text((35,15),'BGD | All seven pieces | X1E / 0.4 mm / PETG',font=font,fill='black')
scale=3.8;ox=60;oy=1040;d.rectangle((ox,oy-256*scale,ox+256*scale,oy),outline='black',width=2)
for zz,vv in world.items():
 for x,y,nx,ny,ft,_,w in vv:d.line((ox+x*scale,oy-y*scale,ox+nx*scale,oy-ny*scale),fill=ip.COLORS.get(ft,'#208c83'),width=1)
for en in layout:
 lo,hi=en['bounds'];d.text((ox+lo[0]*scale,oy-hi[1]*scale-26),en['name'].replace('electronics-','').replace('-core-draft',''),font=font,fill='black')
d.text((35,1080),'Actual sliced paths: blue = walls, orange = removable support',font=font,fill='black');d.text((35,1120),'6 models / 7 pieces. Keep saved orientation and per-object settings.',font=font,fill='black');im.save(PK/'plate-layout.png')
report=dict(printer='Bambu X1E 0.4 hardened steel',material='Polymaker PETG',plate='Textured PEI',total_seconds=rs['sliced_plates'][0]['total_predication'],filament_g=rs['sliced_plates'][0]['filaments'][0]['total_used_g'],roundtrip_success=True,roundtrip_estimate_matches=True,generated_path_bounds_mm=[pts.min(0).tolist(),pts.max(0).tolist()],warnings=[],parts=results,qualification='Software prototype-print verification only; physical fit and strength not established.')
(PK/'verification.json').write_text(json.dumps(report,indent=2));print(json.dumps(report,indent=2))
