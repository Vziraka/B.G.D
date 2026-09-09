"""Reopen the exported archive in Fusion and compare geometry, then close only that test copy."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion


def run(_context: str):
    app=adsk.core.Application.get()
    original=app.activeDocument
    assert original.name=='BGD_MASTER'
    rootpath=Path(r'C:\Users\zvent\Downloads\B.G.D')
    manifest=json.loads((rootpath/'cad/assemblies/reference-r1-manifest.json').read_text())
    output=rootpath/'cad/assemblies/reference-r1-reopen.json'
    assert not output.exists()
    options=app.importManager.createFusionArchiveImportOptions(str(rootpath/'cad/exports/reference-r1/BGD_MASTER_reference-r1.f3d'))
    doc=app.importManager.importToNewDocument(options)
    assert doc is not None and doc!=original
    doc.name='BGD_ARCHIVE_REOPEN_CHECK_ONLY'
    design=adsk.fusion.Design.cast(app.activeProduct)
    root=design.rootComponent
    assert root.attributes.itemByName('BGD','source_sha256').value==manifest['source_sha256']
    expected={b['component']:b for b in manifest['visible_bodies']}
    checked=[]
    for occ in root.occurrences:
        if occ.component.name not in expected:continue
        b=occ.bRepBodies.item(0)
        e=expected[occ.component.name]
        assert abs(b.volume*1000-e['volume_mm3'])<.02
        bounds=b.boundingBox
        for p,key in [(bounds.minPoint,'min_mm'),(bounds.maxPoint,'max_mm')]:
            assert max(abs(v*10-w) for v,w in zip((p.x,p.y,p.z),e[key]))<.001
        checked.append(occ.component.name)
    assert len(checked)==16
    doc.close(False)
    original.activate()
    result={'result':'PASS','verified_bodies':checked,'archive_sha256':manifest['artifacts'][0]['sha256'],
            'checks':['Fusion native reopen','source provenance attribute','16 body volumes within0.02mm3','assembly bounds within0.001mm'],
            'limits':'Confirms export round trip only, not frame identity or physical compatibility'}
    with output.open('x',encoding='utf-8') as f:json.dump(result,f,indent=2)
    print(json.dumps(result))
