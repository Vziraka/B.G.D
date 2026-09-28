"""C4 mass-position ledger; conservative geometric uncertainty, not measured CG."""
import csv
import json
import math
from pathlib import Path
ROOT=Path(__file__).resolve().parents[2]
OUT=ROOT/'cad/revision-r3'
cost=list(csv.DictReader((ROOT/'docs/hardware/revision-r3/architecture-phone-folding-cost.csv').open()))
layout=json.loads((OUT/'phone-folding-final.json').read_text())
positions={
 'FRAME':([0,0,-10],[30,30,30]),'MOTOR':([0,0,19.65],[3,3,3]),'PROP':([0,0,33],[3,3,8]),
 'MOTORINTERFACE':([0,0,30],[10,10,10]),'FCESC':([0,0,15],[3,3,3]),
 'PHONE':([0,-95,110],[8,8,8]),'LAMP':([30,-130,107],[8,8,8]),
 'DOWNRANGE':([0,-88,-13],[5,5,5]),'FRONTDEPTH':([2.5,-115.25,67.25],[30,40,30]),
 'GPS':([0,118,136],[5,5,5]),'RX':([0,-68,13],[10,10,10]),'BUZZER':([0,-50,15],[30,30,20]),
 'POWER':([0,0,5],[35,45,15]),'UART':([-50,-40,20],[5,5,5]),'HUB':([50,-45,65],[5,5,5]),
 'USBCABLE':([15,-45,40],[40,50,30]),'TPM':([50,12,65],[10,10,10]),
 'PACK':([0,25,77],[5,8,5]),'SIXSFAULT':([-60,45,-24],[20,30,20]),
 'CASETEMP':([-5,20,35],[25,40,30])}
pm=layout['print_mass_by_part_g']
mounts=[p for p in layout['parts'] if p['name'] in pm and not p['name'].startswith('PAYLOAD_') and p['name'] not in ['AIO_INSULATING_ADAPTER','GPS_MAST_C4','TOF_SUPPORT']]
mount_weight=sum(pm[p['name']] for p in mounts)
mount_center=[sum((p['min_mm'][a]+p['max_mm'][a])/2*pm[p['name']] for p in mounts)/mount_weight for a in range(3)]
positions['MOUNTS']=(mount_center,[15,20,15])
rows=[]
for row in cost:
    mass=float(row['installed_g'])
    if not mass:continue
    center,uncertainty=positions[row['id']]
    rows.append({'id':row['id'],'mass_g':mass,'center_mm':center,'centroid_uncertainty_mm':uncertainty})
total=sum(r['mass_g'] for r in rows)
cg=[sum(r['mass_g']*r['center_mm'][a] for r in rows)/total for a in range(3)]
unc=[sum(r['mass_g']*r['centroid_uncertainty_mm'][a] for r in rows)/total for a in range(3)]
result={'status':'C4_ESTIMATE_NOT_MEASURED_CG_OR_TIPPING_QUALIFICATION','rows':rows,'mass_g':total,
 'cg_mm':cg,'worst_case_centroid_uncertainty_mm':unc,
 'frame_centroid_is_largest_uncertainty':'600g at assumed[0,0,-10] with30mm per-axis allowance; no exact frame/internal CAD mass properties',
 'flight_nominal_prop_span_xy_mm':650/math.sqrt(2)+406.7,
 'gear_support_halfspan_xy_mm':[95,85],'gear_ground_z_mm':-105,
 'static_level_tipping_angle_nominal_deg':math.degrees(math.atan(min(95-abs(cg[0]),85-abs(cg[1]))/(cg[2]+105))),
 'limits':['Tipping angle excludes wind, acceleration, uneven ground, gear flex and prop thrust',
           'Envelopes use component center approximation; no false density-based mass for phones or purchased components',
           'Folded size cannot be inferred without actual hinge axes/stops and cable paths',
           'Hardware centroid insideMOUNTS is provisionally equal to designed printed-body group centroid']}
(OUT/'phone-folding-mass.json').write_text(json.dumps(result,indent=2)+'\n')
print(json.dumps({k:v for k,v in result.items() if k!='rows'},indent=2))
