"""Combine verified projects without changing their meshes; slice locally only."""
from pathlib import Path
from zipfile import ZipFile, ZIP_DEFLATED
import xml.etree.ElementTree as E
import json, copy, uuid, subprocess
import numpy as np
H=Path(__file__).resolve().parent
OUT=H/'bambu-combined'; OUT.mkdir(exist_ok=True)
C='http://schemas.microsoft.com/3dmanufacturing/core/2015/02'; P='http://schemas.microsoft.com/3dmanufacturing/production/2015/06'; R='http://schemas.openxmlformats.org/package/2006/relationships'
E.register_namespace('',C); E.register_namespace('p',P)
t=lambda n:'{'+C+'}'+n
parts=['pi-carrier-core-draft','battery-end-stops','forward-depth-bracket','electronics-stack-adapter','electronics-flow-support','camera-bracket']
centers=[(60,76),(147,68),(211,70),(62,176),(146,175),(214,174)]
files=[H/'bambu-pi-carrier/pi-carrier-x1e-petg.3mf']+[H/'bambu-verified/email-package'/f'{n}.3mf' for n in parts[1:]]
def read(f):
 with ZipFile(f) as z:return {n:z.read(n) for n in z.namelist()}
def transform(v,tr):
 a=np.array(tr[:9]).reshape(3,3);return v@a+tr[9:]
base=read(files[0]); root=E.fromstring(base['3D/3dmodel.model']); res=root.find(t('resources')); res.clear(); build=root.find(t('build')); build.clear()
config=E.Element('config'); plate=E.Element('plate')
for k,v in [('plater_id','1'),('plater_name','BGD all seven pieces'),('locked','false'),('filament_map_mode','Auto For Flush'),('filament_maps','1'),('filament_volume_maps','0'),('gcode_file','')]:E.SubElement(plate,'metadata',key=k,value=v)
rels=E.Element('{'+R+'}Relationships')
out={k:base[k] for k in ['[Content_Types].xml','_rels/.rels']}
settings=json.loads(base['Metadata/project_settings.config']); settings['print_sequence']='by layer';settings['enable_support']='0';settings['print_settings_id']='BGD combined PETG 0.20'
settings['enable_prime_tower']='0'
# Part-specific support overrides use Bambu's object metadata format.
keys=['enable_support','support_type','support_style','support_on_build_plate_only','support_remove_small_overhang','bridge_no_support','support_threshold_angle']
report=[]; nextid=1
for index,(name,file,center) in enumerate(zip(parts,files,centers),1):
 data=read(file); model=E.fromstring(data['3D/3dmodel.model']); ob=model.find(t('resources'))[0]; item=model.find(t('build'))[0]
 oc=E.fromstring(data['Metadata/model_settings.config']).find('object'); components=ob.find(t('components'))
 oldpath=components[0].get('{'+P+'}path').lstrip('/'); mesh=E.fromstring(data[oldpath]); mp=f'3D/Objects/object_{index}.model'
 mapping={}
 for mo in mesh.find(t('resources')):
  old=mo.get('id');mapping[old]=str(nextid);mo.set('id',str(nextid));nextid+=1
 normalid=oc.find('part[@subtype="normal_part"]').get('id')
 normalcomp=next(c for c in components if c.get('objectid')==normalid)
 normalmesh=mesh.find(f'.//{t("object")}[@id="{mapping[normalid]}"]')
 verts=np.array([[float(v.get(k)) for k in 'xyz'] for v in normalmesh.findall('.//'+t('vertex'))])
 ct=list(map(float,normalcomp.get('transform').split())); bt=list(map(float,item.get('transform').split()))
 world=transform(transform(verts,ct),bt);mid=(world.min(0)+world.max(0))/2
 bt[9]+=center[0]-mid[0];bt[10]+=center[1]-mid[1]
 world=transform(transform(verts,ct),bt)
 oid=str(nextid);nextid+=1;ob.set('id',oid);oc.set('id',oid);item.set('objectid',oid);item.set('transform',' '.join(map(str,bt)))
 for el in [ob,item,*components]:el.set('{'+P+'}UUID',str(uuid.uuid4()))
 for comp in components:comp.set('objectid',mapping[comp.get('objectid')]);comp.set('{'+P+'}path','/'+mp)
 for part in oc.findall('part'):part.set('id',mapping[part.get('id')])
 sd=json.loads(data['Metadata/project_settings.config']);overrides={k:sd[k] for k in keys}
 for k,v in overrides.items():
  for old in oc.findall(f'metadata[@key="{k}"]'):oc.remove(old)
  E.SubElement(oc,'metadata',key=k,value=v)
 res.append(ob);build.append(item);config.append(oc)
 inst=E.SubElement(plate,'model_instance')
 for k,v in [('object_id',oid),('instance_id','0'),('identify_id',str(index))]:E.SubElement(inst,'metadata',key=k,value=v)
 E.SubElement(rels,'{'+R+'}Relationship',Target='/'+mp,Id=f'rel-{index}',Type='http://schemas.microsoft.com/3dmanufacturing/2013/01/3dmodel')
 out[mp]=E.tostring(mesh,encoding='utf-8',xml_declaration=True)
 report.append(dict(name=name,object_id=oid,transform=bt,bounds=[world.min(0).tolist(),world.max(0).tolist()],overrides=overrides,blockers=len(oc.findall('part[@subtype="support_blocker"]'))))
config.append(plate);E.SubElement(config,'assemble')
for path,el in [('3D/3dmodel.model',root),('Metadata/model_settings.config',config),('3D/_rels/3dmodel.model.rels',rels)]:out[path]=E.tostring(el,encoding='utf-8',xml_declaration=True)
out['3D/_rels/3dmodel.model.rels']=E.tostring(rels,encoding='utf-8',xml_declaration=True).replace(b'ns1:',b'').replace(b'xmlns:ns1=',b'xmlns=').replace(b'ns0:',b'').replace(b'xmlns:ns0=',b'xmlns=')
out['Metadata/project_settings.config']=json.dumps(settings).encode()
with ZipFile(OUT/'combined-input.3mf','w',ZIP_DEFLATED) as z:
 for n,d in out.items():z.writestr(n,d)
(OUT/'layout.json').write_text(json.dumps(report,indent=2))
exe=r'C:\Program Files\Bambu Studio\bambu-studio.exe'
r=subprocess.run([exe,'--slice','0','--debug','2','--outputdir',str(OUT),'--export-3mf','combined-sliced.3mf',str(OUT/'combined-input.3mf')],capture_output=True,creationflags=subprocess.CREATE_NO_WINDOW,timeout=180)
(OUT/'slice.log').write_bytes(r.stdout+r.stderr)
print('exit',r.returncode);print((OUT/'result.json').read_text() if (OUT/'result.json').exists() else (r.stdout+r.stderr).decode(errors='replace')[-3000:])

