"""Dimensioned orthographic candidate sheets from validated native STL edges."""
import json,html,struct,sys
from pathlib import Path
import numpy as np
ROOT=Path(__file__).resolve().parents[2];OUT=ROOT/'cad/revision-r3';F=OUT/'phone-d500-2p-print-candidates'
data=json.loads((F/'manifest.json').read_text());D=F/'drawings';D.mkdir(exist_ok=True)
notes={
 'AIO_INSULATING_ADAPTER':['48 x 48 x 2; source AIO 25.5 mm square mounting pattern.','Board is rotated45 degrees in assembly. M3 insulating attachment.','Stock-frame hole coordinates remain a receiving dependency.'],
 'GPS_MAST_C4':['4 x 5 section; 88 mm upright length.','Source GNSS envelope; mast top at Z132, module center Z136.','Both end attachments need actual frame/module measurements.'],
 'TOF_SUPPORT':['6 x 34 x 3 support beam; level sensor retained separately.','No blind screw engagement into optical module assumed.','Tie/fastener path must clear optics and connector on receipt.'],
 'PHONE_TOP_M3_BAR_NUTPOCKET':['180 x 16 x 3 bar; 2 x diameter3.2 through holes.','Hole pitch169; centers84.5 either side of assembly X0.','M3x12 +4-high DIN985 nuts; 4.2-high side-entry pockets in carrier.'],
 'D500_CONTINUOUS_GANTRY':['Top plate70 x54 x3; central30 x20 opening.','Mount XY: (-23.4,-8.525),(+23.4,-8.525),(0,+23.395).','Source housing axis(0,0); optical planeZ180.','Three diameter2.5 mounts; see critical-joint sheet.','Feet X +/-22,Y -16/+12; diameter3.2.'],
 'FC_CP2102N_CONTINUOUS_CRADLE':['38 x 24 x 10 outside; CP2102N source30 x 18 x 5.','Positive side/end stops plus tie-slot retention.','Component/USB-C clearance requires received PCB and lead.'],
 'TOF_CP2102N_CONTINUOUS_CRADLE':['Same geometry as FC cradle, separate physical part.','Fits source30 x 18 x 5 board envelope.','Frame attachment pending; no unsupported threaded hole.'],
 'MCP2221A_CONTINUOUS_CRADLE':['Common38 x 24 x 10 cradle; board27 x 17.7 x 5.','Retain UART RX wire and both temperature leads.','USB-C uses factory cable; never assume rigid USB-A plug.'],
 'USB_HUB_CONTINUOUS_CRADLE_FRAME_ATTACHMENT_PENDING':['Hub24.5 x 71.5 x 18; inverted ports point down.','End opening18 x 10 for TPM. Two tie paths retain hub.','Frame attachment requires measured plate edge/holes.'],
 'MAIN_PAYLOAD_BASE_8MM_RAILS_AIO_RELIEF_FRAME_INTERFACE_PENDING':['Rails8 x 210 x 8; top Z26. ReliefY +/-12 leaves5.5 thick.','Phone holes X +/-22,Y -104/-94; D500 Y -16/12.','Pack48 x 139 x 72; max unchanged-tray fit49.5 x142.','Cap12.5 x20 at(8,40,29);2 tie tunnels3.2 x1.4.','Two independent straps; stock frame interface pending.'],
 'PHONE_UP10_CONTINUOUS_CARRIER':['Fixed10 degree up-pitch around (0,-95,110).','Phone155.6 x 8.7 x 73.2 landscape, lens side forward.','2 x M3 nut pockets5.8 wide x4.2 high; pitch169.','Right rear entry22 deep; left entry14 deep. Keep USB corridor open.']}
def esc(s):return html.escape(str(s))
def text(x,y,s,size=17,color='#172e41'):
 return f'<text x="{x}" y="{y}" font-size="{size}" fill="{color}">{esc(s)}</text>'
def edges(r):
 raw=(OUT/r['bed_path']).read_bytes();dt=np.dtype([('n','<f4',(3,)),('v','<f4',(3,3)),('a','<u2')]);v=np.frombuffer(raw,dtype=dt,offset=84)['v'].astype(float)
 verts,ix=np.unique(np.round(v.reshape(-1,3),4),axis=0,return_inverse=True);ix=ix.reshape(-1,3)
 e=np.concatenate([ix[:,[0,1]],ix[:,[1,2]],ix[:,[2,0]]]);e.sort(axis=1);faces=np.tile(np.arange(len(v)),3)
 order=np.lexsort((e[:,1],e[:,0]));pairs=e[order].reshape(-1,2,2);adj=faces[order].reshape(-1,2)
 assert np.all(pairs[:,0]==pairs[:,1])
 n=np.cross(v[:,1]-v[:,0],v[:,2]-v[:,0]);n/=np.maximum(np.linalg.norm(n,axis=1)[:,None],1e-20)
 return verts[pairs[:,0]],n[adj[:,0]],n[adj[:,1]]
def view(e,n1,n2,axes,x,y,w,h):
 hidden=next(a for a in range(3) if a not in axes);crease=np.einsum('ij,ij->i',n1,n2)<.95
 silhouette=(n1[:,hidden]*n2[:,hidden]<-1e-8)|((abs(n1[:,hidden])<1e-6)&(abs(n2[:,hidden])>1e-6))|((abs(n2[:,hidden])<1e-6)&(abs(n1[:,hidden])>1e-6))
 p=e[crease|silhouette][:,:,axes];lo=p.min(axis=(0,1));span=p.max(axis=(0,1))-lo;s=min((w-45)/max(span[0],1),(h-60)/max(span[1],1));p=(p-lo)*s;p[:,:,0]+=x+20;p[:,:,1]=y+h-30-p[:,:,1]
 out='<path d="'+''.join(f'M{a[0]:.2f},{a[1]:.2f}L{b[0]:.2f},{b[1]:.2f}' for a,b in p)+'" fill="none" stroke="#234b63" stroke-width=".75"/>'
 out+=text(x+20,y+h-6,f'{span[0]:.2f} x {span[1]:.2f} mm',15)
 return out
for page in ([int(sys.argv[1])-1] if len(sys.argv)>1 else range(4)):
 records=data['records'][page*3:page*3+3];s=['<svg xmlns="http://www.w3.org/2000/svg" width="1600" height="1260" viewBox="0 0 1600 1260"><rect width="1600" height="1260" fill="white"/><g font-family="Arial,sans-serif">',text(35,45,'B.G.D ISSUE11 / D500 + 6S2P / native candidate part drawings',28),text(35,77,f'Sheet {page+1}/4 | millimeters | orthographic mesh edges | verify dimensions, never scale the image',17),text(35,104,'DIGITAL CANDIDATES. Not fabrication release. Known print geometry is separate from pending stock-frame interfaces.',17,'#974b20')]
 for j,r in enumerate(records):
  y=130+j*355;s.append(f'<rect x="25" y="{y}" width="1550" height="340" fill="none" stroke="#a8bbc7"/>');s.append(text(40,y+29,r['name'],20));e,n1,n2=edges(r)
  s.append(view(e,n1,n2,(0,1),40,y+45,470,240));s.append(view(e,n1,n2,(0,2),525,y+45,400,240))
  s.append(text(950,y+65,f'Full-density PETG: {r["native_volume_mm3"]*.00127:.2f} g',18))
  for k,t in enumerate(notes[r['name']]):s.append(text(950,y+99+k*29,t,15))
  s.append(text(950,y+244,f'Bed rotation X: {r["bed_rotation_x_deg"]:+.0f} degrees; dimensions:',15));s.append(text(950,y+269,' x '.join(f'{x:.2f}' for x in r['bed_dimensions_mm'])+' mm',16))
 s.extend([text(35,1233,'Source: validated native STL; model/manifest retain exact geometry and hashes. Nominal fit tolerance guidance: +/-0.20 mm after process calibration.',16),'</g></svg>']);(D/f'phone-d500-parts-{page+1}.svg').write_text(''.join(s))
print('Wrote4 dimensioned native-mesh sheets')
