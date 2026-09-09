"""Report actual interference pairs; do not treat an aggregate count as a pass."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion


def run(_context: str):
    app=adsk.core.Application.get()
    assert app.activeDocument.name=='BGD_MASTER'
    design=adsk.fusion.Design.cast(app.activeProduct)
    entities=adsk.core.ObjectCollection.create()
    for occ in design.rootComponent.occurrences:
        if occ.component.name.startswith(('00_','M01_55')):continue
        entities.add(occ)
    result=design.analyzeInterference(design.createInterferenceInput(entities))
    pairs=[]
    for r in result:
        pairs.append({'one':r.entityOne.name,'two':r.entityTwo.name,'volume_mm3':r.interferenceBody.volume*1000})
    p=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\reference\source-one-v6-7in\fusion-interference-pairs.json')
    with p.open('x',encoding='utf-8') as f:json.dump(pairs,f,indent=2)
    print(json.dumps(pairs))
