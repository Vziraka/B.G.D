"""Separate post-import BRep bounds verification and local native archive."""
import hashlib
import json
from pathlib import Path
import adsk.core
import adsk.fusion
OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\engineering-r2-2026-09-10')
def run(_context: str):
    a=adsk.core.Application.get();doc=a.activeDocument
    assert doc.name.startswith('R2_PRECISION_FIT_')
    d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    o=next(o for o in d.rootComponent.occurrences if o.component.name=='MAKER_POLOLU_D24V7_REFERENCE_ONLY')
    b=o.boundingBox;lo=[v*10 for v in b.minPoint.asArray()];hi=[v*10 for v in b.maxPoint.asArray()]
    assert lo[2]>=2.58 and hi[2]<8
    r=json.loads((OUT/'precision-native-fit.json').read_text())
    r['regulator_bounds_mm']={'min_mm':lo,'max_mm':hi}
    r['status']='POST_IMPORT_NATIVE_BOARD_AND_REGULATOR_DATUM_FIT_NOT_RELEASE'
    r['board_export_scope']='KiCad10.0.6 default1.6mm finished stack includes2x.035mm copper and2x.01mm mask, leaving1.51mm core. STEP board-body omits copper/mask. Retain1.6mm finished-board reservation.'
    path=OUT/'exports/R2_PRECISION_BOARD_REGULATOR_FIT_CONDITIONAL.f3d'
    assert d.exportManager.execute(d.exportManager.createFusionArchiveExportOptions(str(path)))
    r['archive']={'file':path.name,'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'bytes':path.stat().st_size}
    (OUT/'precision-native-fit.json').write_text(json.dumps(r,indent=2)+'\n')
    print(json.dumps({'bounds':r['regulator_bounds_mm'],'archive':r['archive']}))
