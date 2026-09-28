"""Read native Rev2 frame interfaces and camera/propeller coordinates."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion

OUT = Path(r'C:\Users\zvent\Downloads\B.G.D\cad\revision-r3')


def run(_context: str):
    app = adsk.core.Application.get()
    doc = next(d for d in app.documents if d.name == 'BGD_ISSUE11_R3_STARLING')
    doc.activate()
    design = adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    rows = []
    for o in design.rootComponent.allOccurrences:
        name = o.component.name
        if not any(k in name.lower() for k in ('thicker frame', 'cam bezel', 'lepton mount', 'battery clip', 'm7 lens_default', 'm12 lens with mount', 't-motor f2203.5')):
            continue
        faces = []
        for body in o.bRepBodies:
            for face in body.faces:
                cyl = adsk.core.Cylinder.cast(face.geometry)
                if cyl:
                    faces.append({'type':'cylinder', 'origin_mm':[v*10 for v in cyl.origin.asArray()],
                                  'axis':cyl.axis.asArray(), 'radius_mm':cyl.radius*10,
                                  'area_mm2':face.area*100})
                plane = adsk.core.Plane.cast(face.geometry)
                if plane and face.area*100 > 25:
                    faces.append({'type':'plane', 'origin_mm':[v*10 for v in plane.origin.asArray()],
                                  'normal':plane.normal.asArray(), 'area_mm2':face.area*100})
        b = o.preciseBoundingBox
        rows.append({'path':o.fullPathName, 'name':name,
                     'min_mm':[v*10 for v in b.minPoint.asArray()],
                     'max_mm':[v*10 for v in b.maxPoint.asArray()], 'faces':faces})
    (OUT/'starling-source-interfaces.json').write_text(json.dumps(rows,indent=2)+'\n')
    cam = app.activeViewport.camera
    cam.viewOrientation = adsk.core.ViewOrientations.TopViewOrientation
    app.activeViewport.camera = cam
    app.activeViewport.fit()
    app.activeViewport.saveAsImageFile(str(OUT/'starling-rev2-top.png'),1400,1000)
    print(json.dumps({'inspected_occurrences':len(rows), 'faces':sum(len(r['faces']) for r in rows)}))
