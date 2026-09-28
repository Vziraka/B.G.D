"""Validate native STL units/topology; create explicitly oriented bed copies."""
import json,struct,hashlib,collections
from pathlib import Path
import numpy as np
OUT=Path(__file__).resolve().parents[2]/'cad/revision-r3'
folder=OUT/'phone-d500-2p-print-candidates';data=json.loads((folder/'native-export.json').read_text());(folder/'bed').mkdir(exist_ok=True)
dtype=np.dtype([('normal','<f4',(3,)),('vertices','<f4',(3,3)),('attr','<u2')]);result=[]
for r in data['records']:
 path=OUT/r['path'];raw=path.read_bytes();count=struct.unpack_from('<I',raw,80)[0];assert len(raw)==84+50*count
 triangles=np.frombuffer(raw,dtype=dtype,count=count,offset=84).copy();v=triangles['vertices'].astype(np.float64)
 # Fusion exports component-local STL despite receiving an occurrence.
 pose=np.array(r['occurrence_transform_cm']).reshape(4,4)
 v=v@pose[:3,:3].T+pose[:3,3]*10
 triangles['normal']=triangles['normal']@pose[:3,:3].T
 edges=collections.Counter()
 for tri in v:
  ps=[tuple(p) for p in tri]
  for i in range(3):edges[tuple(sorted((ps[i],ps[(i+1)%3])))]+=1
 assert all(n==2 for n in edges.values()),r['name']+' is not a closed two-manifold'
 six=np.einsum('ij,ij->i',v[:,0],np.cross(v[:,1],v[:,2]));volume=float(six.sum()/6);assert volume>0
 center=(np.einsum('i,ij->j',six,v.sum(axis=1))/24)/volume
 assert abs(volume/r['native_volume_mm3']-1)<.005
 lo=v.min(axis=(0,1));hi=v.max(axis=(0,1));assert np.all(np.abs(lo-r['world_min_mm'])<.1) and np.all(np.abs(hi-r['world_max_mm'])<.1), (r['name'],lo,hi)
 angle=-90 if r['name'] in ['PHONE_UP10_CONTINUOUS_CARRIER','D500_CONTINUOUS_GANTRY','GPS_MAST_C4'] else 10 if r['name']=='PHONE_TOP_M3_BAR_NUTPOCKET' else 0
 rad=np.deg2rad(angle);rotation=np.array([[1,0,0],[0,np.cos(rad),-np.sin(rad)],[0,np.sin(rad),np.cos(rad)]])
 oriented=v@rotation.T;offset=-oriented.min(axis=(0,1));oriented+=offset
 triangles['vertices']=oriented;triangles['normal']=triangles['normal']@rotation.T
 target=folder/'bed'/path.name;target.write_bytes(b'BGD candidate STL millimeters; not permission to print'.ljust(80,b' ')+struct.pack('<I',count)+triangles.tobytes())
 r.update(triangles=count,closed_two_manifold=True,positive_volume_mm3=volume,volume_difference_fraction=volume/r['native_volume_mm3']-1,centroid_world_mm=center.tolist(),bed_rotation_x_deg=angle,bed_translation_mm=offset.tolist(),bed_dimensions_mm=oriented.max(axis=(0,1)).tolist(),bed_path=str(target.relative_to(OUT)),bed_sha256=hashlib.sha256(target.read_bytes()).hexdigest());result.append(r)
manifest={'status':'VALIDATED_DIGITAL_PRINT_CANDIDATES_NOT_FABRICATION_RELEASE','native_archive':'phone-d500-2p-candidate.f3d','units':'mm','count':len(result),'checks':'Binary format, explicit millimeters, bounds against native, closed two-manifold edges, positive volume within0.5percent native; no physical print or material validation','records':result}
(folder/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
print(json.dumps({'parts':len(result),'max_volume_error_fraction':max(abs(r['volume_difference_fraction']) for r in result),'largest_bed_dimension_mm':max(max(r['bed_dimensions_mm']) for r in result)},indent=2))
