"""Open a checked copy of the preserved frame and audit available Fusion workflows."""
import hashlib
import json
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT = Path(r'C:\Users\zvent\Downloads\B.G.D')

def run(_context: str):
    app = adsk.core.Application.get()
    existing = [d for d in app.documents if d.name == 'BGD_ISSUE11_R2']
    assert len(existing) <= 1
    manifest = json.loads((ROOT/'cad/assemblies/reference-r1-manifest.json').read_text())
    record = next(a for a in manifest['artifacts'] if a['path'].endswith('.f3d'))
    source = ROOT/record['path']
    assert hashlib.sha256(source.read_bytes()).hexdigest() == record['sha256']
    doc = existing[0] if existing else app.importManager.importToNewDocument(app.importManager.createFusionArchiveImportOptions(str(source)))
    assert doc
    doc.activate()
    doc.name = 'BGD_ISSUE11_R2'
    design = adsk.fusion.Design.cast(app.activeProduct)
    root = design.rootComponent
    assert root.attributes.itemByName('BGD','source_sha256').value == manifest['source_sha256']
    root.attributes.add('BGD','revision','ISSUE11_R2_DETAILED_DESIGN_NOT_PHYSICALLY_QUALIFIED')
    audit = {'fusion_version':app.version,'source_archive':record,'native_execute':'PASS',
             'supported_products':list(app.supportedProductTypes),
             'workspaces':[{'id':w.id,'name':w.name} for w in app.userInterface.workspaces],
             'components':[{'name':o.component.name,'bodies':o.component.bRepBodies.count,
                            'visible':o.isLightBulbOn} for o in root.occurrences],
             'scope':'Copy imported locally; original archive unchanged; no cloud save, hardware or account operation'}
    out = ROOT/'cad/engineering-r2-2026-09-10'
    out.mkdir(exist_ok=True)
    (out/'fusion-audit.json').write_text(json.dumps(audit,indent=2)+'\n')
    print(json.dumps(audit))
