"""Two-rail linear beam sensitivity. Support coordinates are a receiving requirement, not stock holes."""
import json
from pathlib import Path
import numpy as np
O=Path(__file__).resolve().parents[2]/'cad/revision-r3'
p=json.loads((O/'phone-d500-2p-print-candidates/manifest.json').read_text())['records']
m={r['name']:r['native_volume_mm3']*.00127 for r in p}
# One rail carries half each retained group; pack load enters two known cross-supports.
phone=(197+101+m['PHONE_UP10_CONTINUOUS_CARRIER']+m['PHONE_TOP_M3_BAR_NUTPOCKET'])*.001*5*9.81/2
pack=1035*.001*5*9.81/4
lidar=(45+m['D500_CONTINUOUS_GANTRY'])*.001*5*9.81/2
base=m['MAIN_PAYLOAD_BASE_8MM_RAILS_AIO_RELIEF_FRAME_INTERFACE_PENDING']*.001*5*9.81/2
loads=[(-99,phone),(-18,pack),(68,pack),(4,lidar),(0,base),(40,3.9*.001*5*9.81/2)]
cases=[]
for supports in [(-55,55),(-40,40)]:
 a,b=supports;rb=sum(f*(x-a) for x,f in loads)/(b-a);ra=sum(f for x,f in loads)-rb
 x=np.linspace(-110,100,21001);moment=ra*np.maximum(x-a,0)+rb*np.maximum(x-b,0)
 for at,f in loads:moment-=f*np.maximum(x-at,0)
 thickness=np.where(abs(x)<=12,5.5,8);I=8*thickness**3/12;S=I/(thickness/2);E=1000
 curvature=moment/(E*I);dx=x[1]-x[0]
 slope=np.r_[0,np.cumsum((curvature[1:]+curvature[:-1])*dx/2)]
 disp=np.r_[0,np.cumsum((slope[1:]+slope[:-1])*dx/2)]
 da,db=np.interp([a,b],x,disp);c1=(da-db)/(b-a);c0=-da-c1*a;disp+=c1*x+c0
 cases.append(dict(support_y_mm=supports,span_mm=b-a,front_overhang_to_phone_mm=a+99,reaction_per_rail_N=[ra,rb],peak_bending_Nmm=float(abs(moment).max()),nominal_stress_MPa=float((abs(moment)/S).max()),elastic_deflection_max_mm_at_assumed_E1000MPa=float(abs(disp).max())))
result={'status':'RECEIVING_SUPPORT_BOUND_AND_LINEAR_BEAM_SCREEN_NOT_MATERIAL_QUALIFICATION','one_rail_loads_y_mm_force_N':loads,'section_mm':[8,8],'local_relief_y_mm':[-12,12],'local_relief_thickness_mm':5.5,'section_modulus_mm3':85.3333333333,'cases':cases,
 'required_support_geometry':'Two supported crossmembers nearY=-55,+55; maximum110mm clear support span, phone overhang<=44mm and pack rear overhang<=13mm. Different source holes require load calculation update, not invented holes.',
 'qualification':'Actual joint fixity/support compliance and hot conditioned print coupon strength/modulus unmeasured. Require at least2x computed nominal stress in selected material/process plus inert full-joint test; linear calculation omits holes, anisotropy, creep and stress concentration.'}
(O/'phone-d500-rail-load.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps(result,indent=2))
