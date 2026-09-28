"""Native lamp envelope/rotor reservation study; no invented lamp CAD or mounts."""
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
    root = design.rootComponent
    label = 'STARLING_REV2_LAMP_LAYOUT_01'
    assert not any(o.component.name == label for o in root.occurrences), 'Inspect partial layout before retry'
    source = [o for o in root.allOccurrences if o.component.bRepBodies.count]
    parent = root.occurrences.addNewComponent(adsk.core.Matrix3D.create())
    parent.component.name = label
    parent.component.attributes.add('BGD','status','Conditional source Rev2 envelope study; C29 applicability and positive-retention attachment unresolved')
    for name, value, basis in (
            ('lamp_width',90,'Conservative lamp envelope, not manufacturer CAD'),
            ('lamp_height',80,'Conservative lamp envelope, not manufacturer CAD'),
            ('lamp_depth',35,'Conservative lamp envelope, not manufacturer CAD'),
            ('front_lamp_base_y',45,'Avoid Rev2 rotor vertical sweep through33.34mm'),
            ('rotor_radial_allowance',5,'Provisional clearance allowance; physical deflection unmeasured')):
        assert not design.userParameters.itemByName('Starling_'+name)
        design.userParameters.add('Starling_'+name,adsk.core.ValueInput.createByString(str(value)+' mm'),'mm',basis+'; regenerate after changes')
    tm = adsk.fusion.TemporaryBRepManager.get()
    def point(vals):
        return adsk.core.Point3D.create(*[v/10 for v in vals])
    lamps = []
    for name, center, size, normal in (
            ('VL49RGB_FRONT_ENVELOPE_NOT_MAKER_GEOMETRY',[0,85,54.5],[90,80,35],[0,0,1]),
            ('VL49RGB_DOWN_ENVELOPE_NOT_MAKER_GEOMETRY',[0,-40,75],[90,35,80],[0,-1,0])):
        occ = parent.component.occurrences.addNewComponent(adsk.core.Matrix3D.create())
        comp = occ.component
        comp.name = name
        comp.attributes.add('BGD','representation','90x80x35mm reserved volume only; no physical lamp mass from CAD volume')
        bf = comp.features.baseFeatures.add()
        assert bf.startEdit()
        box = adsk.core.OrientedBoundingBox3D.create(point(center),adsk.core.Vector3D.create(1,0,0),adsk.core.Vector3D.create(0,1,0),*[v/10 for v in size])
        assert comp.bRepBodies.add(tm.createBox(box),bf)
        assert bf.finishEdit()
        lamps.append((occ.createForAssemblyContext(parent),{'name':name,'center_mm':center,'size_mm':size,'illumination_normal':normal}))
    rotors = []
    for x,z in ((130,95),(-130,95),(130,-95),(-130,-95)):
        occ = parent.component.occurrences.addNewComponent(adsk.core.Matrix3D.create())
        comp = occ.component
        comp.name = 'REV2_ROTOR_SWEEP_PLUS_5MM_'+str(x)+'_'+str(z)
        bf = comp.features.baseFeatures.add()
        assert bf.startEdit()
        assert comp.bRepBodies.add(tm.createCylinderOrCone(point([x,8.86,z]),9.5,point([x,38.34,z]),9.5),bf)
        assert bf.finishEdit()
        rotors.append(occ.createForAssemblyContext(parent))
        occ.isLightBulbOn = False
    checks = []
    for lamp, record in lamps:
        overlaps = []
        for other in source + rotors:
            if not lamp.boundingBox.intersects(other.boundingBox):
                continue
            coll = adsk.core.ObjectCollection.create()
            coll.add(lamp); coll.add(other)
            results = design.analyzeInterference(design.createInterferenceInput(coll))
            volume = sum(r.interferenceBody.volume*1000 for r in results)
            if volume > .001:
                overlaps.append({'part':other.fullPathName,'overlap_mm3':volume})
        record['native_intersections'] = overlaps
        checks.append(record)
    report = {'status':'NATIVE_REV2_ENVELOPE_STUDY_NOT_EXACT_C29_OR_ATTACHMENT_RELEASE',
              'source_sha256':'5f961e7589284bfc9dcd26bd3b9be799fc679dde8cd9555f849f83ad83718f83',
              'axes':'X lateral; Y up; Z forward','lamps':checks,
              'front_static_prop_vertical_clearance_mm':45-33.33916624459579,
              'down_static_level_ground_clearance_mm':-57.5-(-67.6329963126733),
              'attachment':'No attachment solid fabricated from unverified screw engagement or lamp shoe dimensions'}
    (OUT/'starling-layout-rev2.json').write_text(json.dumps(report,indent=2)+'\n')
    cam = app.activeViewport.camera
    cam.eye = point([500,360,500]); cam.target = point([0,20,0]); cam.upVector = adsk.core.Vector3D.create(0,1,0)
    cam.isFitView = True
    app.activeViewport.camera = cam
    app.activeViewport.fit()
    assert app.activeViewport.saveAsImageFile(str(OUT/'starling-layout-rev2.png'),1600,1200)
    archive = OUT/'starling-layout-rev2.f3d'
    assert not archive.exists()
    assert design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(archive)))
    print(json.dumps(report))
