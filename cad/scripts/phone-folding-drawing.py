"""Review-only orthographic SVG from the native captured world bounds."""
import html
import json
from pathlib import Path

ROOT=Path(__file__).resolve().parents[2]
OUT=ROOT/'cad/revision-r3'
data=json.loads((OUT/'phone-folding-final.json').read_text())
parts=data['parts']
svg=['<svg xmlns="http://www.w3.org/2000/svg" width="1600" height="1120" viewBox="0 0 1600 1120"><rect width="1600" height="1120" fill="#fff"/>',
     '<style>text{font-family:Arial,sans-serif;fill:#182434} .title{font-size:26px;font-weight:bold}.h{font-size:19px;font-weight:bold}.n{font-size:15px}.small{font-size:13px}</style>']
def text(x,y,s,cls='n'):svg.append(f'<text x="{x}" y="{y}" class="{cls}">{html.escape(s)}</text>')
def line(x1,y1,x2,y2,color='#789',dash=''):
    svg.append(f'<line x1="{x1}" y1="{y1}" x2="{x2}" y2="{y2}" stroke="{color}" stroke-width="1" stroke-dasharray="{dash}"/>')
def rect(x,y,w,h,color='#687d92',fill='none',dash=''):
    svg.append(f'<rect x="{x:.2f}" y="{y:.2f}" width="{w:.2f}" height="{h:.2f}" fill="{fill}" stroke="{color}" stroke-width="1.2" stroke-dasharray="{dash}"/>')
text(35,42,'B.G.D. / phone + folding 650 frame / native integration drawing','title')
text(35,70,'REVIEW STUDY ONLY — C4 outlines, frame attachments and loads unqualified. NOT A CUTTING OR DRILLING TEMPLATE.')
text(35,96,'Units: mm. Captured world-bound rectangles; analytic rotor circles. Native F3D holds actual bodies. No optical FOV implied.')

def view(x,y,scale,ax,ay,names,flip=True):
    for p in parts:
        if not names(p):continue
        lo=p['min_mm'];hi=p['max_mm'];kind=p['kind']
        assumed='C4' in kind or 'PENDING' in p['name']
        custom=kind.startswith('DESIGNED_PRINT')
        color='#a76a20' if assumed else '#127a77' if custom else '#40536e'
        rect(x+lo[ax]*scale,y-hi[ay]*scale if flip else y+lo[ay]*scale,(hi[ax]-lo[ax])*scale,(hi[ay]-lo[ay])*scale,color,'#f1f7f7' if custom else 'none','4 3' if assumed else '')

text(35,135,'PLAN: 650 diagonal / 406.7 propeller span','h')
cx,cy,s=420,445,.66
view(cx,cy,s,0,1,lambda p:p['name'].startswith(('TAROT_TOP','TAROT_TUBE','TL68','M4006','PIXEL7','VL49','NEXUS6')))
for sx,sy in [(1,1),(-1,1),(-1,-1),(1,-1)]:
    x,y=cx+sx*229.8097*s,cy-sy*229.8097*s
    svg.append(f'<circle cx="{x}" cy="{y}" r="{203.35*s}" fill="none" stroke="#667a8c" stroke-width="1"/>')
    svg.append(f'<circle cx="{x}" cy="{y}" r="{208.35*s}" fill="none" stroke="#af572e" stroke-width="1" stroke-dasharray="4 4"/>')
text(70,766,'Nominal neighbor tip gap: 52.919 mm; after two 5 mm radial reserves: 42.919 mm.')
text(70,790,'Dashed amber: provisional geometry or clearance reserve. Teal: designed printed part.')

text(880,135,'SIDE: payload positions and keepout height','h')
view(1200,465,1.4,1,2,lambda p:p['name'].startswith(('TAROT_TOP','TAROT_BOTTOM','PIXEL7','VL49','NEXUS6','PAYLOAD','PACK_CROSS','PHONE_POST','TFMINI_DOWN','GNSS','ADAFRUIT')) and 'RAY' not in p['name'])
rect(865,465-41*1.4,650,16*1.4,'#af572e','none','6 4')
text(880,506,'Rotor vertical reservation Z=25..41, not measured prop datum.')
text(880,531,'Phone center Z=110; lamp Z=107; pack bottom Z=41.')
text(880,556,'Pack 139 x 25 x 72; support top Z=40 plus 1 mm foam.')

text(880,611,'PHONE CLOSURE: front projection','h')
view(1195,950,2,0,2,lambda p:p['name'].startswith(('PIXEL7','PHONE_TOP_M3','PHONE_LEFT_NUT','PHONE_RIGHT_','PHONE_BOTTOM','PHONE_SCREEN','PHONE_REAR_CAPTURE')))
text(880,886,'Phone body 155.6 x 73.2 x 8.7; top bar 180 x 16 x 3.')
text(880,910,'Two clearance bores Ø3.2 at X=±84.5, Y=-94; spacing 169.')
text(880,934,'USB opening Z=97.5..122.5 (25 high); connector reserve 24 high.')
text(880,958,'DIN934 nut pocket 5.8 wide x 2.6 high, Z=143.8; screen-side entry.')

line(35,992,1565,992)
text(35,1022,'Source interfaces: motor M3 on Ø25; prop mounting M3 on Ø12; TL68B51 tube Ø16, outline 105 x 43, center opening Ø11.')
text(35,1048,'Exact frame plate/hinge/gear coordinates unavailable. Motor plate outline and clamp underside are reservations around sourced dimensions.')
text(35,1074,'Print volume estimate: 136.197 g at full-density PETG 1.27 g/cm³. Fasteners, straps and foam are separate allowances.')
svg.append('</svg>')
(OUT/'phone-folding-review.svg').write_text('\n'.join(svg),encoding='utf8')
print(OUT/'phone-folding-review.svg')
