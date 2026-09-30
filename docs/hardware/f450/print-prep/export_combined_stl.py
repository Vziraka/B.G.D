"""Export one STL of seven print pieces, then verify topology and Bambu import."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
import xml.etree.ElementTree as E
import numpy as np
import struct,json,subprocess,collections,shutil
H=Path(__file__).resolve().parent;D=H/'bambu-combined';O=D/'stl-package';O.mkdir(exist_ok=True)
C='http://schemas.microsoft.com/3dmanufacturing/core/2015/02';P='http://schemas.microsoft.com/3dmanufacturing/production/2015/06';t=lambda n:'{'+C+'}'+n
src=D/'email-package/BGD-All-Parts-X1E-PETG.3mf'
def trans(v,s):
 a=np.array(list(map(float,s.split())));return v@a[:9].reshape(3,3)+a[9:]
def triangles(f):
 result=[]
 with ZipFile(f) as z:
  root=E.fromstring(z.read('3D/3dmodel.model'));cfg=E.fromstring(z.read('Metadata/model_settings.config'))
  for it in root.find(t('build')):
   oid=it.get('objectid');ob=root.find(f'.//{t("object")}[@id="{oid}"]');oc=cfg.find(f'object[@id="{oid}"]')
   for co in ob.find(t('components')):
    mid=co.get('objectid');part=oc.find(f'part[@id="{mid}"]')
    if part.get('subtype')!='normal_part':continue
    mesh=E.fromstring(z.read(co.get('{'+P+'}path').lstrip('/'))).find(f'.//{t("object")}[@id="{mid}"]')
    vs=np.array([[float(v.get(k)) for k in 'xyz'] for v in mesh.findall('.//'+t('vertex'))]);vs=trans(trans(vs,co.get('transform')),it.get('transform'))
    fs=np.array([[int(a.get(k)) for k in ('v1','v2','v3')] for a in mesh.findall('.//'+t('triangle'))]);result.extend(vs[fs])
 return np.array(result)
orig=triangles(src);arr=orig.copy();arr[:,:,2][abs(arr[:,:,2])<0.00001]=0
f=O/'BGD-All-Seven-Parts-One-Plate.stl'
with f.open('wb') as out:
 out.write(b'BGD all seven pieces; millimeters; no supports/settings'.ljust(80,b' '));out.write(struct.pack('<I',len(arr)))
 for tri in arr:
  normal=np.cross(tri[1]-tri[0],tri[2]-tri[0]);normal/=np.linalg.norm(normal)
  out.write(struct.pack('<12fH',*normal,*tri.flatten(),0))
raw=f.read_bytes();count=struct.unpack_from('<I',raw,80)[0];assert len(raw)==84+50*count
actual=np.array([struct.unpack_from('<12fH',raw,84+50*i)[3:12] for i in range(count)]).reshape(-1,3,3)
assert np.max(np.abs(actual-orig))<0.001
# Weld coordinate-identical vertices and validate all seven closed shells.
vs,inv=np.unique(actual.reshape(-1,3),axis=0,return_inverse=True);faces=inv.reshape(-1,3);edges=collections.Counter();direct=collections.Counter();adj=[set() for _ in vs]
for a,b,c in faces:
 for x,y in [(a,b),(b,c),(c,a)]:edges[tuple(sorted((x,y)))]+=1;direct[(x,y)]+=1;adj[x].add(y);adj[y].add(x)
assert all(n==2 for n in edges.values());assert all(n==direct[(y,x)] for (x,y),n in direct.items())
assert np.min(np.linalg.norm(np.cross(actual[:,1]-actual[:,0],actual[:,2]-actual[:,0]),axis=1))>1e-8
unseen=set(range(len(vs)));shells=[]
while unseen:
 todo=[unseen.pop()];group=set(todo)
 while todo:
  for nxt in adj[todo.pop()]:
   if nxt in unseen:unseen.remove(nxt);group.add(nxt);todo.append(nxt)
 mask=np.array([a in group for a in faces[:,0]]);ts=actual[mask];volume=np.einsum('ij,ij->i',ts[:,0],np.cross(ts[:,1],ts[:,2])).sum()/6
 assert volume>0
 shells.append(dict(triangles=int(mask.sum()),volume_mm3=float(volume),bounds_mm=[vs[list(group)].min(0).tolist(),vs[list(group)].max(0).tolist()]))
assert len(shells)==7
check=D/'stl-import-check';check.mkdir(exist_ok=True)
with ZipFile(src) as z:(check/'settings.json').write_bytes(z.read('Metadata/project_settings.config'))
r=subprocess.run([r'C:\Program Files\Bambu Studio\bambu-studio.exe','--export-3mf','imported-stl.3mf','--outputdir',str(check.resolve()),str(f.resolve())],capture_output=True,creationflags=subprocess.CREATE_NO_WINDOW,timeout=90)
(check/'import.log').write_bytes(r.stdout+r.stderr);assert r.returncode==0,r.returncode
# Slicer may center the whole STL; verify all triangle geometry up to one translation.
imported=triangles(check/'imported-stl.3mf')
def canon(a):
 points=a.reshape(-1,3);points=points-(points.min(0)+points.max(0))/2;points=np.round(points,3);return sorted(map(tuple,points))
assert len(imported)==len(actual)
# Float serialization can round at exactly half a micron; compare sorted full precision.
a=actual.reshape(-1,3);b=imported.reshape(-1,3);a=a-(a.min(0)+a.max(0))/2;b=b-(b.min(0)+b.max(0))/2
a=np.unique(a,axis=0);b=np.unique(b,axis=0)
def nearest_error(x,y):
 return max(np.sqrt(((chunk[:,None,:]-y[None,:,:])**2).sum(2).min(1)).max() for chunk in np.array_split(x,40))
err=max(nearest_error(a,b),nearest_error(b,a));assert err<0.001,err
report=dict(file=f.name,triangles=count,closed_manifold_shells=len(shells),consistent_winding=True,no_degenerate_triangles=True,source_geometry_max_error_mm=float(np.max(np.abs(actual-orig))),bambu_studio_import_export_success=True,bambu_roundtrip_geometry_max_error_mm=float(err),bounds_mm=[actual.min((0,1)).tolist(),actual.max((0,1)).tolist()],shells=shells,limitations='STL has no units/settings/support blockers. Import as millimeters. Prepared 3MF is the verified print setup; physical fit/strength not established.')
(O/'STL-verification.json').write_text(json.dumps(report,indent=2));print(json.dumps({k:v for k,v in report.items() if k!='shells'},indent=2))
