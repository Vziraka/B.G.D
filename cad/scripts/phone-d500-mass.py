"""Current mass-position ledger with native print centroids and explicit purchased-part uncertainty."""
import ast,csv,json,math
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2];OUT=ROOT/'cad/revision-r3'
tree=ast.parse((ROOT/'cad/scripts/phone-folding-mass.py').read_text())
pos=next(ast.literal_eval(n.value) for n in tree.body if isinstance(n,ast.Assign) and any(isinstance(t,ast.Name) and t.id=='positions' for t in n.targets))
a=math.radians(-10);y,z=-35,-3
pos['LAMP']=([30,-95+y*math.cos(a)-z*math.sin(a),110+y*math.sin(a)+z*math.cos(a)],[8,8,8])
pos['RX']=([0,-78,13],[10,10,10])
pos.update(MOUNTS=([0,-50,65],[40,70,50]),D500=([0,0,170],[5,5,10]),LIDARWIRE=([-32,12,90],[10,20,40]),NEWMECH=([0,-40,66],[20,50,60]))
parts=json.loads((OUT/'phone-d500-2p-print-candidates/manifest.json').read_text())['records']
rows=[]
for r in csv.DictReader((ROOT/'docs/hardware/revision-r3/architecture-phone-d500-cost.csv').open()):
 m=float(r['installed_g'])
 if not m:continue
 if r['id']=='PRINTS':
  for p in parts:rows.append(dict(id=p['name'],mass_g=p['native_volume_mm3']*.00127,center_mm=p['centroid_world_mm'],centroid_uncertainty_mm=[1,1,1]))
 else:
  c,u=pos[r['id']];rows.append(dict(id=r['id'],mass_g=m,center_mm=c,centroid_uncertainty_mm=u))
total=sum(r['mass_g'] for r in rows)
cg=[sum(r['mass_g']*r['center_mm'][a] for r in rows)/total for a in range(3)]
unc=[sum(r['mass_g']*r['centroid_uncertainty_mm'][a] for r in rows)/total for a in range(3)]
result={'status':'NATIVE_PRINT_CENTROIDS_PLUS_C4_PURCHASED_PART_CENTROIDS_NOT_MEASURED_CG','rows':rows,'mass_g':total,'cg_mm':cg,'worst_case_centroid_uncertainty_mm':unc,
 'rotor_source_diameter_mm':406.7,'rotor_nominal_xy_span_mm':650/math.sqrt(2)+406.7,'rotor_reserved_xy_span_mm':650/math.sqrt(2)+416.7,
 'neighbor_clearance_mm':650/math.sqrt(2)-406.7,'neighbor_clearance_after_two5mm_reserves_mm':650/math.sqrt(2)-416.7,
 'body_ground_to_top_mm':292.8,'body_ground_z_mm':-105,'optical_plane_z_mm':180,'support_halfspan_xy_C4_mm':[95,85],
 'nominal_static_tipping_angle_deg':math.degrees(math.atan(min(95-abs(cg[0]),85-abs(cg[1]))/(cg[2]+105))),
 'limits':['Frame hinge/gear centroid and finished hardware placements are not measured; uncertainty is allocated, not statistical.',
 'Folded size cannot be established without source hinge axes/stops and cable bends. No backpack-fit claim.',
 'Static level tipping angle excludes acceleration, rotor thrust, wind, ground unevenness and gear compliance.',
 'Full native print density used; no unmeasured infill weight credit.']}
(OUT/'phone-d500-2p-mass.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k!='rows'},indent=2))
