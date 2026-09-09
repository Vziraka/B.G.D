"""Generate millimetre engineering study drawings, NOT fabrication-release files.

Python standard library plus ReportLab. No network, device access or flight code.
Dimensions are project design choices unless explicitly identified as vendor data.
Run from any directory: python path/to/generate_drawings.py
"""
from pathlib import Path
import csv, json, math
from xml.sax.saxutils import escape
from reportlab.pdfgen import canvas
from reportlab.lib.units import mm

ROOT = Path(__file__).resolve().parent
OUT = ROOT / 'drawings'
OUT.mkdir(exist_ok=True)
parts = []
def plate(id, name, w, h, t, material, qty=1, holes=(), slots=(), note=''):
    parts.append(dict(id=id,name=name,w=w,h=h,t=t,material=material,qty=qty,
                      holes=list(holes),slots=list(slots),note=note))
def four(x,y,d): return [(a*x,b*y,d) for a in (-1,1) for b in (-1,1)]

# Hole coordinates relative to centre; x=right, y=up, through unless stated.
rot = 25.5/math.sqrt(2)
plate('M01','AIO adapter',55,55,1.6,'FR4',holes=four(15.25,15.25,3.2)+[(rot,0,3.2),(-rot,0,3.2),(0,rot,3.2),(0,-rot,3.2)],note='Frame 30.5 square; AIO 25.5 square rotated 45deg. Arrow FORWARD, not board edge. HOLD H01.')
plate('M02','Bus carrier',80,35,1.6,'FR4',holes=four(34,12,3.2),slots=[(-10,0,3,7),(10,0,3,7),(-10,-15,3,2),(-10,15,3,2),(10,-15,3,2),(10,15,3,2)],note='Rail centres y=+/-8.7625; gap8.0. Strap lanes x=+/-10 clear solder zones. Edge strength HOLD H02.')
plate('M03','Bus top guard',85,40,1.0,'PC',holes=four(34,12,3.2),note='12mm nylon spacers; side skirts and protected wire exits still required by H02. This top sheet is NOT a complete guard.')
plate('M04','C110 bus rail',50.8,9.525,3.175,'C110',qty=2,note='No drilled current joints; deburr R0.3; solder zones x=+/-16..25.4. Polarity permanently marked. HOLD H02.')
plate('M05','Battery cradle blank',55,170,1.6,'FR4',slots=[(-22,y,3,22) for y in (-55,0,55)]+[(22,y,3,22) for y in (-55,0,55)],note='Three20mm straps through paired22mm slots. Slider/frame mount holes OMITTED: H03, not a completed cradle.')
plate('M06','Battery end stop',55,15,1.6,'FR4',qty=2,holes=[(-18,0,3.2),(18,0,3.2)],note='Vertical stop; bolt to cradle via insulating angles, not unsupported adhesive. HOLD H03.')
plate('M07','Pi insulating base',100,65,0.6,'PC',holes=[(x-10,y,d) for x,y,d in four(29,24.5,2.7)],note='Pi PCB centred;58x49 holes offset x=-10 from PCB centre. Exact connector/part overlay HOLD H04.')
plate('M08','Pi longitudinal rail',80,8,1.2,'PC',qty=2,holes=[(-29,0,2.7),(29,0,2.7)],note='Rail centres on base x=-10,y=+/-24.5. Clamp through Pi posts. HOLD H04.')
plate('M09','Fan bridge',40,30,0.8,'PC',slots=[(-16,0,2.7,20),(16,0,2.7,20)],note='Fan opening and mounting pattern TRANSFER after exact3368 drawing/part. Do not obstruct blades. HOLD H04.')
plate('M10','Camera adapter blank',38,36,0.8,'PC',note='Camera3 and pan/tilt fastening patterns OMITTED pending authoritative overlay; not a finished adapter. HOLD H05.')
plate('M11','Front accessory shelf',65,35,1.0,'FR4',holes=four(27,11,3.2),note='IR/light and pan/tilt mount holes TRANSFER; separate optics from hot IR boards. HOLD H05.')
plate('M12','D500 base',60,55,1.0,'FR4',holes=four(24,21,3.2),note='Mast support holes only; sensor mounting holes omitted pending dimensioned vendor drawing. HOLD H06.')
plate('M13','GNSS platform',45,45,1.0,'FR4',holes=four(16,16,3.2),note='Nonmagnetic restraint; exact12044 base attachment TRANSFER. HOLD H06.')
plate('M14','TFmini base',48,25,1.0,'FR4',holes=[(-19,0,3.2),(19,0,3.2)],note='Sensor mounting holes omitted pending vendor overlay. Downward optical aperture unobstructed. HOLD H07.')
plate('M15','Landing strut study',12,170,1.6,'FR4',qty=4,holes=[(0,-78,3.2),(0,78,3.2)],note='Requires bracing and frame/foot joints; flat strips alone NOT released as landing gear. HOLD H08.')
plate('M16','Landing foot',40,15,1.6,'FR4',qty=4,holes=[(-6,0,3.2),(6,0,3.2)],note='Foot pads/strut angles/bracing require resolved joint drawing H08.')
plate('M17','Cargo lid/base',100,70,1.0,'PC',qty=2,note='Outside planning envelope100x70x60. Joints/strike/hinge NOT released. HOLD H09.')
plate('M18','Cargo long wall',100,58,1.0,'PC',qty=2,note='Wall between lid and base; captive internal fasteners; no exterior hand-release. HOLD H09.')
plate('M19','Cargo end wall',68,58,1.0,'PC',qty=2,note='Ends between long walls; corner joints and latch detail NOT released. HOLD H09.')

density={'FR4':1.85,'PC':1.2,'C110':8.96} # g/cm3 screening values, not certified material lots
for p in parts:
    area=p['w']*p['h']-sum(math.pi*(d/2)**2 for x,y,d in p['holes'])
    # Rounded slot uses overall outside width/height.
    for x,y,w,h in p['slots']:
        a,b=max(w,h),min(w,h)
        area-=b*(a-b)+math.pi*(b/2)**2
    p['net_mass_g']=round(area*p['t']/1000*density[p['material']],4)
(ROOT/'mechanical-parts.json').write_text(json.dumps(parts,indent=2)+'\n',encoding='utf-8')
with (ROOT/'cut-list.csv').open('w',newline='',encoding='utf-8') as f:
    out=csv.writer(f);out.writerow(['id','part','quantity','width_mm','height_mm','thickness_mm','material','estimated_each_g','status'])
    for p in parts: out.writerow([p['id'],p['name'],p['qty'],p['w'],p['h'],p['t'],p['material'],p['net_mass_g'],'ENGINEERING STUDY - HOLD'])

pdf=canvas.Canvas(str(OUT/'dimensioned-study.pdf'),pagesize=(297*mm,210*mm))
for p in parts:
    # A4 landscape SVG sheet with 1:1 geometry; image/viewer print scaling is separate.
    cx,cy=80,110
    txt=lambda x,y,s,size=3.2: f'<text x="{x}" y="{y}" font-size="{size}">{escape(s)}</text>'
    chunks=['<svg xmlns="http://www.w3.org/2000/svg" width="297mm" height="210mm" viewBox="0 0 297 210">',
            '<rect width="297" height="210" fill="white"/><g font-family="Arial" fill="#111">',
            txt(10,12,p['id']+' / '+p['name'],5),txt(10,20,'ENGINEERING STUDY - NOT RELEASED FOR FABRICATION',4),
            txt(165,35,f"{p['material']} t={p['t']} mm; quantity {p['qty']}"),txt(165,42,f"Blank {p['w']} x {p['h']} mm"),
            txt(165,49,'All dimensions mm. Datum: part centre.'),txt(165,56,'Outer size +/-0.25; holes +/-0.10.'),
            txt(165,63,'Slot end radius=min(width,height)/2.'),txt(165,70,'Hole table: x, y, diameter (THRU)')]
    chunks.append(f'<rect x="{cx-p["w"]/2}" y="{cy-p["h"]/2}" width="{p["w"]}" height="{p["h"]}" fill="#eff5ff" stroke="black" stroke-width="0.2"/>')
    for i,(x,y,d) in enumerate(p['holes']):
        chunks.append(f'<circle cx="{cx+x}" cy="{cy-y}" r="{d/2}" fill="white" stroke="black" stroke-width="0.2"/>')
        chunks.append(txt(165,77+i*5,f'{i+1}: {x:.4f}, {y:.4f}, {d}'))
    sy=82+len(p['holes'])*5
    for i,(x,y,w,h) in enumerate(p['slots']):
        chunks.append(f'<rect x="{cx+x-w/2}" y="{cy-y-h/2}" width="{w}" height="{h}" rx="{min(w,h)/2}" fill="white" stroke="black" stroke-width="0.2"/>')
        chunks.append(txt(165,sy+i*5,f'S{i+1}: ({x},{y}) overall {w} x {h}'))
    chunks.extend([txt(10,204,p['note'],2.4),'</g></svg>'])
    (OUT/(p['id']+'.svg')).write_text(''.join(chunks),encoding='utf-8')
    # PDF preserves vector geometry and uses same source dimensions.
    pdf.setFont('Helvetica-Bold',13);pdf.drawString(10*mm,198*mm,p['id']+' / '+p['name'])
    pdf.setFont('Helvetica-Bold',10);pdf.drawString(10*mm,190*mm,'ENGINEERING STUDY - NOT RELEASED FOR FABRICATION')
    pdf.setFont('Helvetica',8)
    pdf.rect((cx-p['w']/2)*mm,(210-cy-p['h']/2)*mm,p['w']*mm,p['h']*mm)
    for x,y,d in p['holes']: pdf.circle((cx+x)*mm,(210-cy+y)*mm,d/2*mm)
    for x,y,w,h in p['slots']: pdf.roundRect((cx+x-w/2)*mm,(210-cy+y-h/2)*mm,w*mm,h*mm,min(w,h)/2*mm)
    lines=[f"{p['material']} t={p['t']}mm; quantity {p['qty']}",f"Width {p['w']} x height {p['h']}mm",'Origin: centre; x right, y up.', 'Outer +/-0.25; holes +/-0.10mm.', 'Slot radius=min(width,height)/2.', 'Holes: x, y, diameter THRU']
    lines += [f'{i+1}: {x:.4f}, {y:.4f}, {d}' for i,(x,y,d) in enumerate(p['holes'])]
    lines += [f'S{i+1}: ({x},{y}) overall {w} x {h}' for i,(x,y,w,h) in enumerate(p['slots'])]
    for i,s in enumerate(lines): pdf.drawString(165*mm,(175-i*5)*mm,s)
    pdf.setFont('Helvetica',6);pdf.drawString(8*mm,10*mm,p['note']);pdf.showPage()
pdf.save()
print('Generated',len(parts),'SVG sheets + vector PDF + cut list; all study status.')
print('Study cut material mass:',round(sum(p['net_mass_g']*p['qty'] for p in parts),3),'g; NOT total aircraft mass.')
