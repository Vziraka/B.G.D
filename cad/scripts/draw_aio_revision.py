"""Dimension the screened adapter blank without altering historical R1 studies."""
import json
from pathlib import Path
from xml.sax.saxutils import escape

ROOT=Path(__file__).resolve().parents[2]
part=json.loads((ROOT/'docs/hardware/baseline-r1/mechanical-parts.json').read_text())[0]
screen=json.loads((ROOT/'cad/components/aio-screen.json').read_text())
candidate=next(p for p in screen['adapter_candidates'] if p['side_mm']==48)
assert candidate['interferences_with_standoffs']==0
part.update(w=48,h=48,id='M01-R2',net_mass_g=candidate['mass_g_at_assumed_FR4_1_85'],
            note='STUDY ONLY: H01 remains. Fasteners, dampers, services and frame revision unresolved.')
out=ROOT/'cad/drawings'
(out/'M01-R2-study.json').write_text(json.dumps(part,indent=2)+'\n')
def text(x,y,s,size=3.2):return f'<text x="{x}" y="{y}" font-size="{size}">{escape(s)}</text>'
items=['<svg xmlns="http://www.w3.org/2000/svg" width="297mm" height="210mm" viewBox="0 0 297 210">',
       '<rect width="297" height="210" fill="white"/><g font-family="Arial" fill="#17212b">',
       text(10,15,'M01-R2 / 48 mm AIO adapter blank',6),
       text(10,25,'ENGINEERING STUDY — NOT RELEASED FOR FABRICATION',4),
       '<rect x="51" y="71" width="48" height="48" stroke="black" stroke-width="0.2" fill="#eef3f7"/>']
for i,(x,y,d) in enumerate(part['holes']):
    items.append(f'<circle cx="{75+x}" cy="{95-y}" r="{d/2}" fill="white" stroke="black" stroke-width="0.2"/>')
    items.append(text(150,82+i*6,f'{i+1}: {x:+.5f}, {y:+.5f}, diameter {d} THRU'))
items += [text(51,65,'48 mm'),text(103,96,'48 mm'),
          text(150,48,'Material: FR4, thickness 1.6 mm. Quantity 1.'),
          text(150,56,'All dimensions mm; part-centre datum.'),
          text(150,64,'Table: local X, local Y, hole diameter.'),
          text(10,145,'Frame pattern: 30.5 x 30.5. AIO pattern: 25.5 x 25.5, rotated 45 degrees.'),
          text(10,154,'Nominal standoff clearance: 1.3833 mm. Tolerance stack and mount loads NOT qualified.'),
          text(10,163,'Calculated FR4 blank mass: 6.6294 g at assumed density 1.85 g/cm3; no hardware included.'),
          text(10,172,'Hole locations match the R1 study. The 55 mm outer blank is reduced to resolve four modeled collisions.'),
          text(10,181,'No carbon-frame drilling. No fabrication tolerance or screw length released by this drawing.'),
          text(10,190,part['note']),'</g></svg>']
(out/'M01-R2-study.svg').write_text('\n'.join(items),encoding='utf-8')
print('Wrote M01-R2 study JSON/SVG; historical R1 unchanged.')
