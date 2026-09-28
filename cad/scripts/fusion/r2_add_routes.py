"""Add honest cable keepouts with exact circular-bend input and bounded faceting."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\engineering-r2-2026-09-10')
def run(_context: str):
    app=adsk.core.Application.get()
    doc=next(d for d in app.documents if d.name=='BGD_ISSUE11_R2');doc.activate()
    design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    root=design.rootComponent
    assert not any(o.component.name=='R2_CABLE_KEEP_OUTS' for o in root.occurrences)
    group=root.occurrences.addNewComponent(adsk.core.Matrix3D.create());group.component.name='R2_CABLE_KEEP_OUTS'
    tm=adsk.fusion.TemporaryBRepManager.get()
    for route in json.loads((OUT/'routes.json').read_text())['routes']:
        occ=group.component.occurrences.addNewComponent(adsk.core.Matrix3D.create());comp=occ.component;comp.name=route['id']
        comp.attributes.add('BGD','status',route['status'])
        comp.attributes.add('BGD','mass','Keepout volume is not wire material/mass; use conductor length and exact supplier construction')
        bf=comp.features.baseFeatures.add();assert bf.startEdit()
        radius=route['od_mm']/20
        points=[adsk.core.Point3D.create(*[v/10 for v in p]) for p in route['points_mm']]
        for a,b in zip(points,points[1:]):assert comp.bRepBodies.add(tm.createCylinderOrCone(a,radius,b,radius),bf)
        for p in points:assert comp.bRepBodies.add(tm.createSphere(p,radius),bf)
        assert bf.finishEdit();occ.isLightBulbOn=False
    if design.snapshots.hasPendingSnapshot:design.snapshots.add()
    print('Four native3D route reservations created; main route endpoints/clamps remain explicit holds.')
