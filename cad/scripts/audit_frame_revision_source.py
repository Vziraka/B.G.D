"""Preserve the pinned DXF's actual thickness labels, not extrusion defaults."""
import hashlib
import json
from pathlib import Path
from verify_source_one_frame import pairs, parse_relevant_entities

ROOT=Path(__file__).resolve().parents[2]
REF=ROOT/'cad/reference/source-one-v6-7in'
manifest=json.loads((REF/'source.json').read_text())
source=ROOT/manifest['local_cache']
assert hashlib.sha256(source.read_bytes()).hexdigest()==manifest['sha256']
header,texts,circles,polylines=parse_relevant_entities(source)
labels=[]
section=''
next_section=False
kind=None
entity=[]

def flush():
    if kind not in ('TEXT','MTEXT'):return
    value=''.join(v for k,v in entity if k in (1,3)).strip()
    d=dict(entity)
    labels.append({'entity_type':kind,'handle':d.get(5),'layer':d.get(8),'text':value,
                   'insert_raw_mm':[float(d.get(10,0)),float(d.get(20,0)),float(d.get(30,0))]})

for k,v in pairs(source):
    if k==0 and v in ('SECTION','ENDSEC'):
        if section=='ENTITIES':flush()
        kind=None;entity=[];section='';next_section=v=='SECTION'
        continue
    if next_section and k==2:section=v;next_section=False;continue
    if section!='ENTITIES':continue
    if k==0:flush();kind=v;entity=[]
    else:entity.append((k,v))
flush()
layout=[]
for layer,lo,hi in [('Draw13',250,330),('Draw3',390,470),('Draw14',590,670),('Camera-Holder',480,580),('Draw2',820,880)]:
    candidates=[p for p in polylines if p['layer']==layer and p['closed'] and lo<min(x for x,y in p['vertices'])<hi]
    if not candidates:continue
    p=max(candidates,key=lambda p:(max(x for x,y in p['vertices'])-min(x for x,y in p['vertices']))*(max(y for x,y in p['vertices'])-min(y for x,y in p['vertices'])))
    xs=[x for x,y in p['vertices']];ys=[y for x,y in p['vertices']]
    layout.append({'layer':layer,'vertex_bounds_raw_mm':[min(xs),min(ys),max(xs),max(ys)],
                   'nearby_thickness_text':[l for l in labels if l['text'].endswith('mm') and lo<l['insert_raw_mm'][0]<hi and abs(l['insert_raw_mm'][1]-1365.406704551222)<1]})
report={'source_sha256':manifest['sha256'],'drawing_identity':['Source One V6 - 7 in DC','2025-JUL-07'],
        'header_THICKNESS':header.get('$THICKNESS'),'header_INSUNITS':header.get('$INSUNITS'),
        'labels':labels,'manufacturing_layout_associations':layout,
        'interpretation':'2mm is explicit drawing text, not a 2mm DXF default extrusion: header $THICKNESS=0.0. Spatial layer/label association is derived from drawing layout, not a supplier-confirmed current part-role mapping.',
        'discrepancy_outcome':'documentation conflict remains unresolved'}
(REF/'source-label-audit.json').write_text(json.dumps(report,indent=2)+'\n',encoding='utf-8')
print(json.dumps({'default_thickness':header.get('$THICKNESS'),'labels':len(labels),'manufacturing_layout_associations':layout}))
