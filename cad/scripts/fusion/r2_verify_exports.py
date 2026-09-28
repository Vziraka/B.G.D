"""Reopen local exports and compare native detail geometry, without cloud save."""
import hashlib
import json
import re
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT=Path(r'C:\Users\zvent\Downloads\B.G.D')
OUT=ROOT/'cad/engineering-r2-2026-09-10'
def run(_context: str):
    app=adsk.core.Application.get()
    source=ROOT/'cad/exports/reference-r1/BGD_MASTER_reference-r1.f3d'
    assert hashlib.sha256(source.read_bytes()).hexdigest()=='5e1ea3d2db1f6c342e910491038f75ac437636d2299e4224914ade8aa7cec78d'
    expected=json.loads((OUT/'fusion-build.json').read_text())
    manifest=json.loads((OUT/'export-manifest.json').read_text())
    reports=[]
    for suffix,filename in [('F3D','BGD_ISSUE11_R2_CONDITIONAL.f3d'),('STEP','BGD_ISSUE11_R2_VISIBLE_ASSEMBLY_NOT_FOR_FABRICATION.step')]:
        path=OUT/'exports'/filename
        label='R2_ROUNDTRIP_'+suffix+'_'+hashlib.sha256(path.read_bytes()).hexdigest()[:8]
        assert not any(d.name==label for d in app.documents),'This exact export already has a verification document; inspect before repeating'
        options=app.importManager.createFusionArchiveImportOptions(str(path)) if suffix=='F3D' else app.importManager.createSTEPImportOptions(str(path))
        doc=app.importManager.importToNewDocument(options);assert doc;doc.name=label
        design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
        root=design.rootComponent
        group=next(o for o in root.occurrences if o.component.name.startswith('R2_DETAIL_R2D'))
        items={re.sub(r' \(\d+\)$','',o.component.name):o.createForAssemblyContext(group) for o in group.component.occurrences}
        checked=[]
        for p in expected['parts']:
            # STEP intentionally excludes hidden keepouts and interface axes.
            if suffix=='STEP' and not p['visible']:continue
            assert p['name'] in items,p['name']
            bodies=list(items[p['name']].bRepBodies)
            assert len(bodies)==p['bodies'],p['name']
            lo=[min(b.boundingBox.minPoint.asArray()[i]*10 for b in bodies) for i in range(3)]
            hi=[max(b.boundingBox.maxPoint.asArray()[i]*10 for b in bodies) for i in range(3)]
            error=max(abs(a-b) for a,b in zip(lo+hi,p['min_mm']+p['max_mm']))
            volume=sum(b.volume for b in bodies)*1000
            assert error<0.002,(p['name'],error)
            assert abs(volume-p['volume_mm3'])<max(.01,p['volume_mm3']*1e-6),(p['name'],volume)
            checked.append({'name':p['name'],'max_bbox_difference_mm':error,'volume_difference_mm3':volume-p['volume_mm3']})
        roots=[{'name':o.component.name,'visible':o.isLightBulbOn} for o in root.occurrences]
        if suffix=='STEP':
            assert not any(x['name'].startswith(('R2_DETAIL_R2A','R2_DETAIL_R2B','R2_DETAIL_R2C','R2_CABLE_KEEP_OUTS')) for x in roots)
        reports.append({'file':filename,'sha256':hashlib.sha256(path.read_bytes()).hexdigest(),'checked_parts':checked,'root_occurrences':roots})
        # Persist each completed verification even if the later import fails.
        (OUT/'roundtrip-verification.json').write_text(json.dumps({'status':'NATIVE_REOPEN_GEOMETRY_CHECKS','reports':reports},indent=2)+'\n')
    manifest['reopen_verification']='Both F3D and visible STEP reopened in Fusion; per-part BRep volume/bounds checked against post-recompute assembly. STEP hidden-history exclusion checked. See roundtrip-verification.json; no physical fit claim.'
    (OUT/'export-manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    next(d for d in app.documents if d.name=='BGD_ISSUE11_R2').activate()
    print(json.dumps({'roundtrips':[(r['file'],len(r['checked_parts'])) for r in reports]}))
