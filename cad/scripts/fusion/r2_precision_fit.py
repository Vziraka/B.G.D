"""Inspect the routed native PCB and align acquired regulator CAD by drill datum."""
import hashlib
import json
from pathlib import Path
import adsk.core
import adsk.fusion
ROOT=Path(r'C:\Users\zvent\Downloads\B.G.D')
OUT=ROOT/'cad/engineering-r2-2026-09-10'
ELEC=ROOT/'docs/hardware/engineering-r2-2026-09-10'
def run(_context: str):
    app=adsk.core.Application.get()
    board=ELEC/'electrical-precision-carrier.step'
    label='R2_PRECISION_FIT_'+hashlib.sha256(board.read_bytes()).hexdigest()[:8]
    existing=[d for d in app.documents if d.name==label]
    assert len(existing)<=1
    doc=existing[0] if existing else app.importManager.importToNewDocument(app.importManager.createSTEPImportOptions(str(board)))
    doc.name=label;doc.activate()
    design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));root=design.rootComponent
    def bounds(obj):
        b=obj.boundingBox
        return {'min_mm':[v*10 for v in b.minPoint.asArray()],'max_mm':[v*10 for v in b.maxPoint.asArray()]}
    board_bb=bounds(root)
    assert all(abs((board_bb['max_mm'][i]-board_bb['min_mm'][i])-30)<.03 for i in (0,1))
    # KiCad's board-only STEP omits outer copper from its 1.6mm stackup.
    # Preserve a full 1.6mm finished-board reservation, not a false measured1.6.
    top=1.6
    assert not any(o.component.name=='MAKER_POLOLU_D24V7_REFERENCE_ONLY' for o in root.occurrences)
    group=root.occurrences.addNewComponent(adsk.core.Matrix3D.create());group.component.name='MAKER_POLOLU_D24V7_REFERENCE_ONLY'
    source=ELEC/'electrical-pololu-d24v7.step'
    assert app.importManager.importToTarget(app.importManager.createSTEPImportOptions(str(source)),group.component)
    tr=adsk.core.Matrix3D.create();tr.translation=adsk.core.Vector3D.create(.3682,-1.995,(top+1)/10)
    group.transform2=tr
    if design.snapshots.hasPendingSnapshot:design.snapshots.add()
    root.attributes.add('BGD','scope','Board-only native KiCad export plus maker regulator CAD. Not populated PCB, wire termination or mechanical-retention qualification.')
    assert design.computeAll()
    regulator_bb=bounds(group)
    # Read once more in a separate API invocation before accepting cached bounds.
    expected_pins=[[5.46,-18.68,top+2.016],[8,-18.68,top+2.016],[10.54,-18.68,top+2.016]]
    # The source's source-drill coordinates were measured independently in pololu-native-holes.json.
    r={'status':'NATIVE_BOARD_AND_MAKER_REGULATOR_DATUM_FIT_NOT_RELEASE','board_sha256':hashlib.sha256(board.read_bytes()).hexdigest(),
       'regulator_sha256':hashlib.sha256(source.read_bytes()).hexdigest(),'board_bounds_mm':board_bb,'regulator_bounds_mm':regulator_bb,
       'maker_to_kicad_native_translation_mm':[3.682,-19.95,top+1],'pin_centers_mm':expected_pins,
       'assembly_mapping':'KiCad native XY uses negative top-viewY. In main R2, rotate+90deg aboutZ, then translate boardcenter to(77,-42), boardbottom to-39.8. J2 positive then(82,-36,-38.2).',
       'wire_path':'J2 positive to trial TFmini entry(102,0,-50) is approximately43mm straight;100mm pair remains selected model cap. Actual sensor entry and terminal bend relief unverified;50mm not released.',
       'board_export_scope':'STEP core bbox includes0.01mm import tolerance per side,1.51mm bare core. Retain1.6mm finished-board design reservation; electrical native stackup evidence controls.',
       'holds':['Independent nonprinted regulator supports and final leadtrim retention must preserve1mm gap','Other PCB components remain electrical-footprint/height checks, not falsely imported populated geometry','Actual sensor connector entry and assembled routing remain conditional']}
    r['status']='PENDING_SEPARATE_NATIVE_BOUNDS_READ'
    (OUT/'precision-native-fit.json').write_text(json.dumps(r,indent=2)+'\n')
    print(json.dumps({'board':board_bb,'regulator':regulator_bb,'status':r['status']}))
