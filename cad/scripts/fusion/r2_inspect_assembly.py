"""Read native placements and specific fit risks; no false whole-aircraft pass."""
import json
import re
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT=Path(r'C:\Users\zvent\Downloads\B.G.D')
OUT=ROOT/'cad/engineering-r2-2026-09-10'
def run(_context: str):
    app=adsk.core.Application.get()
    doc=next(d for d in app.documents if d.name=='BGD_ISSUE11_R2');doc.activate()
    design=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    root=design.rootComponent
    revision=json.loads((OUT/'assembly-inputs.json').read_text())['revision']
    assembly=next(o for o in root.occurrences if o.component.name=='R2_DETAIL_'+revision)
    items={re.sub(r' \(\d+\)$','',o.component.name):o.createForAssemblyContext(assembly) for o in assembly.component.occurrences}
    fan=next(o for o in root.occurrences if o.component.name=='R2_NOCTUA_MANUFACTURER_REFERENCE')
    pairs=[]
    tests=[('FAN_SECONDARY_BRIDGE','PI4_GPIO_HAT_RESERVATION'),('PI4_PORTS_RESERVED','PI4_GPIO_HAT_RESERVATION'),
           ('AIO_BODY_MAX_ENVELOPE','AIO_45_FR4_ADAPTER'),('BATTERY_PACK_NOMINAL','D500_SENSOR_ENVELOPE'),
           ('BUS_SECONDARY_GUARD','AIO_BODY_MAX_ENVELOPE'),('PI4_USB_SERVICE','HOLDER_RESERVED'),
           ('FAN_INLET_CLEARANCE','AIO_45_FR4_ADAPTER')]
    for a,b in tests:
        coll=adsk.core.ObjectCollection.create();coll.add(items[a]);coll.add(items[b])
        results=design.analyzeInterference(design.createInterferenceInput(coll))
        pairs.append({'one':a,'two':b,'overlap_mm3':sum(r.interferenceBody.volume*1000 for r in results),
                      'meaning':'Envelope overlap is a design warning; it is not proof of solid purchased-part collision'})
    for b in ('PI4_GPIO_HAT_RESERVATION','FAN_SECONDARY_BRIDGE','PI4_PORTS_RESERVED'):
        coll=adsk.core.ObjectCollection.create();coll.add(fan);coll.add(items[b])
        results=design.analyzeInterference(design.createInterferenceInput(coll))
        pairs.append({'one':'NOCTUA_MAKER_CAD','two':b,'overlap_mm3':sum(r.interferenceBody.volume*1000 for r in results),
                      'meaning':'Acquired maker CAD checked in common root assembly context; exact purchased revision still controls.'})
    fan_child=fan.component.occurrences.item(0)
    cylinders=[]
    def scan(comp):
        for body in comp.bRepBodies:
            for face in body.faces:
                cy=adsk.core.Cylinder.cast(face.geometry)
                if cy and 1.5<cy.radius*10<3:
                    cylinders.append({'radius_mm':cy.radius*10,'origin_mm':[x*10 for x in cy.origin.asArray()],'axis':cy.axis.asArray()})
        for o in comp.occurrences:scan(o.component)
    scan(fan_child.component)
    camera=app.activeViewport.camera
    camera.eye=adsk.core.Point3D.create(38,-48,31);camera.target=adsk.core.Point3D.create(0,0,2)
    camera.upVector=adsk.core.Vector3D.create(0,0,1);camera.viewExtents=48;camera.isFitView=False
    app.activeViewport.camera=camera;app.activeViewport.refresh()
    preview=OUT/('assembly-'+revision+'.png');assert app.activeViewport.saveAsImageFile(str(preview),1600,1200)
    report={'status':'NATIVE_GEOMETRY_INSPECTION_NOT_QUALIFICATION','revision':revision,'selected_pairs':pairs,
            'fan_local_cylinders':cylinders,'preview':str(preview.relative_to(ROOT))}
    (OUT/('inspection-'+revision+'.json')).write_text(json.dumps(report,indent=2)+'\n')
    print(json.dumps({'pairs':pairs,'fan_candidate_cylinder_faces':len(cylinders),'preview':str(preview)}))
