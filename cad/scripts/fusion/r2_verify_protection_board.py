"""Inspect the actual KiCad board STEP in Fusion; no populated-board claim."""
import hashlib
import json
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT = Path(r'C:\Users\zvent\Downloads\B.G.D')
OUT = ROOT / 'cad/engineering-r2-2026-09-10'


def run(_context: str):
    source = ROOT / 'docs/hardware/engineering-r2-2026-09-10/electrical-protection-carrier.step'
    digest = hashlib.sha256(source.read_bytes()).hexdigest()
    app = adsk.core.Application.get()
    doc = app.importManager.importToNewDocument(app.importManager.createSTEPImportOptions(str(source)))
    assert doc
    doc.name = 'R2_PROTECTION_BOARD_' + digest[:8]
    design = adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    root = design.rootComponent
    bodies = list(root.bRepBodies)
    for occurrence in root.allOccurrences:
        bodies.extend(occurrence.bRepBodies)
    assert len(bodies) == 1, 'Board-only export required; audit any added component models separately'
    body = bodies[0]
    box = body.boundingBox
    lower = [v * 10 for v in box.minPoint.asArray()]
    upper = [v * 10 for v in box.maxPoint.asArray()]
    size = [b - a for a, b in zip(lower, upper)]
    assert all(abs(v - 30) < .03 for v in size[:2])
    assert 1.4 <= size[2] <= 1.62, 'Imported dielectric envelope must fit finished1.6mm reservation plus STEP tolerance'
    holes = []
    for face in body.faces:
        cylinder = adsk.core.Cylinder.cast(face.geometry)
        if cylinder and abs(cylinder.radius * 20 - 2.2) < .001:
            holes.append({'center_mm': [v * 10 for v in cylinder.origin.asArray()], 'diameter_mm': cylinder.radius * 20})
    positions = {(round(h['center_mm'][0], 3), round(h['center_mm'][1], 3)) for h in holes}
    assert positions == {(3., -3.), (27., -3.), (3., -27.), (27., -27.)}, positions
    volume = body.volume * 1000
    assert volume > 0
    archive = OUT / 'exports/R2_PROTECTION_BOARD_REFERENCE.f3d'
    assert design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(archive)))
    record = {
        'status': 'NATIVE_IMPORTED_BOARD_OUTLINE_AND_HOLES_PASS_NOT_RELEASE',
        'source_path': source.relative_to(ROOT).as_posix(), 'source_sha256': digest,
        'bounds_mm': {'min': lower, 'max': upper, 'size': size},
        'mount_holes': holes, 'volume_mm3': volume,
        'native_core_z_span_mm': size[2],
        'finished_board_reservation_mm': 1.6,
        'scope': 'Board-only KiCad STEP: copper/mask/populated parts, routing strain relief, insulation and thermal behavior are not represented. Four holes agree with the two existing30mm R2 carrier reservations. Imported dielectric thickness does not reduce finished-board allowance.',
        'archive': {'file': archive.name, 'bytes': archive.stat().st_size, 'sha256': hashlib.sha256(archive.read_bytes()).hexdigest()},
    }
    (OUT / 'protection-native-fit.json').write_text(json.dumps(record, indent=2) + '\n')
    print(json.dumps(record))
