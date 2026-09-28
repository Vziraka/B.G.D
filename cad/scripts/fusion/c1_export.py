"""Export C1 native/STEP/STL, run selected interference pairs and save a preview.

Runs against the open BGD_ISSUE11_C1 document only. Local files only; no cloud
save. Exports are review artefacts, NOT FOR FABRICATION until the package review
releases them.
"""
import hashlib
import json
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT = Path(r'C:\Users\zvent\Downloads\B.G.D')
OUT = ROOT / 'cad/candidate-c1'
DOC_NAME = 'BGD_ISSUE11_C1B_BRANCH_FUSE'
PAIRS = [('PHONE_PIXEL6A', 'BELLY_TRAY_PLATE'), ('PHONE_PIXEL6A', 'PHONE_CHEEK_L'), ('PHONE_PIXEL6A', 'PHONE_CHEEK_R'),
         ('PHONE_PIXEL6A', 'PHONE_LIP'), ('BATTERY_CNHL_6S', 'BELLY_TRAY_PLATE'), ('BATTERY_CNHL_6S', 'BATTERY_RAIL_L'),
         ('BATTERY_CNHL_6S', 'BATTERY_RAIL_R'), ('BATTERY_CNHL_6S', 'PHONE_PIXEL6A'), ('FC_AIO', 'AVIONICS_CARRIER'),
         ('FC_AIO', 'LIDAR_DECK'), ('FC_AIO', 'SECURE_ATECC'), ('LIDAR_BASE', 'LIDAR_DECK'), ('GPS_M10G', 'LASER_PLANE_BAND'),
         ('GPS_POST', 'LASER_PLANE_BAND'), ('LIDAR_DECK', 'LASER_PLANE_BAND'), ('LED_BAR', 'PHONE_PIXEL6A'),
         ('LED_BAR', 'LAMP_BRACKET'), ('BUCK_LM2596', 'BELLY_TRAY_PLATE'), ('LAMP_MOSFET', 'BELLY_TRAY_PLATE'),
         ('VL53L1X_DOWN', 'PHONE_LIP'), ('PROP_DISC_1', 'LIDAR_DECK'), ('PROP_DISC_1', 'GPS_M10G'), ('PROP_DISC_1', 'LED_BAR'),
         ('PROP_DISC_1', 'PHONE_PIXEL6A'), ('PROP_DISC_2', 'PHONE_PIXEL6A'), ('PROP_DISC_1', 'LEG_1'), ('PROP_DISC_1', 'MOTOR_1'),
         ('BELLY_TRAY_PLATE', 'BOTTOM_PDB_PLATE'), ('AVIONICS_CARRIER', 'TOP_PLATE'), ('GPS_POST', 'TOP_PLATE'),
         ('PHONE_PIXEL6A', 'LEG_1'), ('PHONE_PIXEL6A', 'LEG_2')]
PRINTED = ['AVIONICS_POWER_CARRIER_UNION', 'LIDAR_DECK', 'GPS_POST', 'BELLY_CARRIER_UNION', 'MOTOR_DRILL_JIG', 'FRAME_SPACER_LOWER_-1_-1', 'FC_COLUMN_0']


def run(_context: str):
    app = adsk.core.Application.get()
    doc = next(d for d in app.documents if d.name == DOC_NAME)
    doc.activate()
    design = adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'))
    root = design.rootComponent
    items = {o.component.name: o for o in root.occurrences}
    pairs = []
    pairs_to_check = list(PAIRS)
    # Maximum pack body against every other physical envelope; nominal board
    # follows pack width, so its separate maximum position is checked instead.
    data = json.loads((OUT / 'assembly-inputs.json').read_text())
    for p in data['parts']:
        n = p['name']
        if p['shape'] != 'none' and n not in ('BATTERY_CNHL_6S', 'BATTERY_MAX_ENVELOPE', 'TEMP_TMP117', 'MOTOR_DRILL_JIG', 'LASER_PLANE_BAND'):
            pairs_to_check.append(('BATTERY_MAX_ENVELOPE', n))
    for n in ('PHONE_PIXEL6A','BATTERY_CNHL_6S','BATTERY_MAX_ENVELOPE','TEMP_TMP117','TEMP_MAX_POSITION','BOTTOM_PDB_PLATE','LED_BAR','VL53L1X_DOWN'):
        pairs_to_check.append(('BELLY_CARRIER_UNION', n))
    for p in data['parts']:
        if p['name'].startswith(('TOWER_STANDOFF_','FC_COLUMN_')):
            for n in ('FC_AIO','LIDAR_DECK','AVIONICS_CARRIER','SECURE_ATECC'):
                pairs_to_check.append((p['name'],n))
    fasteners = [p['name'] for p in data['parts'] if p['name'].startswith(('INNER_SCREW_','INNER_HEAD_','TOWER_SCREW_','TOWER_HEAD_','FC_SCREW_','FC_HEAD_','FC_NUT_','FC_SLEEVE_'))]
    for n in fasteners:
        for other in ('BELLY_CARRIER_UNION','TOP_PLATE','BOTTOM_PDB_PLATE','AVIONICS_CARRIER','FC_AIO','PACK_PAD_-1','PACK_PAD_1','ARM_1','ARM_2','ARM_3','ARM_4','LIDAR_DECK','LIDAR_BASE'):
            pairs_to_check.append((n,other))
    for p in data['parts']:
        if p['name'].startswith(('FRAME_SPACER_','INNER_SPACER_')):
            for other in ('TOP_PLATE','BOTTOM_PDB_PLATE','AVIONICS_CARRIER','FC_AIO','ARM_1','ARM_2','ARM_3','ARM_4'):
                pairs_to_check.append((p['name'],other))
    pairs_to_check.extend([('TEMP_TMP117', 'BATTERY_CNHL_6S'), ('TEMP_TMP117', 'BATTERY_RAIL_L'), ('TEMP_MAX_POSITION', 'BATTERY_RAIL_L')])
    for p in data['parts']:
        if p['shape']!='none' and p['name'] not in ('POWER_HOLDER_FHJC1002G','LASER_PLANE_BAND','FC_COMPONENT_KEEP_OUT'):
            pairs_to_check.append(('POWER_HOLDER_FHJC1002G',p['name']))
    for n in ('FC_AIO','SECURE_ATECC','GPS_POST','GPS_M10G','LIDAR_DECK','POWER_HOLDER_FHJC1002G','TOP_PLATE','BOTTOM_PDB_PLATE','ARM_1','ARM_2','ARM_3','ARM_4'):
        pairs_to_check.append(('AVIONICS_POWER_CARRIER_UNION',n))
    for head in ('USB_PHONE_RA_STEM','USB_PHONE_RA_BAR','USB_FC_STRAIGHT_HEAD'):
        for p in data['parts']:
            n=p['name']
            if p['shape']!='none' and not n.startswith('USB_') and p['kind'] not in ('printed_tool','keepout'):
                pairs_to_check.append((head,n))
        pairs_to_check.append((head,'BELLY_CARRIER_UNION'))
        pairs_to_check.append((head,'AVIONICS_POWER_CARRIER_UNION'))
    for p in data['parts']:
        if p['shape']!='none' and p['name']!='LAMP_BRANCH_FUSE' and p['kind'] not in ('printed_tool','keepout'):
            pairs_to_check.append(('LAMP_BRANCH_FUSE',p['name']))
    pairs_to_check.append(('LAMP_BRANCH_FUSE','AVIONICS_POWER_CARRIER_UNION'))
    for a, b in pairs_to_check:
        coll = adsk.core.ObjectCollection.create()
        coll.add(items[a])
        coll.add(items[b])
        results = design.analyzeInterference(design.createInterferenceInput(coll))
        pairs.append({'one': a, 'two': b, 'overlap_mm3': round(sum(r.interferenceBody.volume * 1000 for r in results), 4)})
    export = OUT / 'exports'
    export.mkdir(exist_ok=True)
    paths = []
    native = export / 'BGD_ISSUE11_C1B_CONDITIONAL.f3d'
    assert design.exportManager.execute(design.exportManager.createFusionArchiveExportOptions(str(native)))
    paths.append(native)
    step = export / 'BGD_ISSUE11_C1B_VISIBLE_ASSEMBLY_NOT_FOR_FABRICATION.step'
    options = design.exportManager.createSTEPExportOptions(str(step), root)
    options.isIncludingInvisibleBodies = False
    options.isIncludingInvisibleComponents = False
    assert design.exportManager.execute(options)
    paths.append(step)
    for name in PRINTED:
        comp = items[name].component
        stl = export / (name + '_NOT_FOR_FABRICATION.stl')
        opt = design.exportManager.createSTLExportOptions(comp, str(stl))
        opt.sendToPrintUtility = False
        opt.isBinaryFormat = True
        assert design.exportManager.execute(opt)
        paths.append(stl)
        stp = export / (name + '_NOT_FOR_FABRICATION.step')
        assert design.exportManager.execute(design.exportManager.createSTEPExportOptions(str(stp), comp))
        paths.append(stp)
    camera = app.activeViewport.camera
    camera.eye = adsk.core.Point3D.create(60, -70, 45)
    camera.target = adsk.core.Point3D.create(0, 0, -5)
    camera.upVector = adsk.core.Vector3D.create(0, 0, 1)
    camera.viewExtents = 70
    camera.isFitView = False
    app.activeViewport.camera = camera
    app.activeViewport.refresh()
    preview = OUT / 'assembly-C1B.png'
    assert app.activeViewport.saveAsImageFile(str(preview), 1600, 1200)
    camera = app.activeViewport.camera
    camera.eye = adsk.core.Point3D.create(0.01, -120, 0)
    camera.target = adsk.core.Point3D.create(0, 0, -5)
    camera.upVector = adsk.core.Vector3D.create(0, 0, 1)
    camera.viewExtents = 60
    camera.isFitView = False
    app.activeViewport.camera = camera
    app.activeViewport.refresh()
    side = OUT / 'assembly-C1B-side.png'
    assert app.activeViewport.saveAsImageFile(str(side), 1600, 900)
    saved_visibility={n:o.isLightBulbOn for n,o in items.items()}
    for n,o in items.items(): o.isLightBulbOn=n=='BELLY_CARRIER_UNION'
    camera=app.activeViewport.camera
    camera.eye=adsk.core.Point3D.create(35,-45,-35)
    camera.target=adsk.core.Point3D.create(0,0,-6)
    camera.upVector=adsk.core.Vector3D.create(0,0,1)
    camera.viewExtents=30
    camera.isFitView=False
    app.activeViewport.camera=camera
    app.activeViewport.refresh()
    belly=OUT/'belly-carrier-C1B.png'
    assert app.activeViewport.saveAsImageFile(str(belly),1600,1000)
    for n,o in items.items():o.isLightBulbOn=saved_visibility[n]
    app.activeViewport.refresh()
    manifest = {'status': 'CONDITIONAL_DESIGN_ARTIFACTS_NOT_MANUFACTURING_RELEASE', 'fusion_version': app.version,
                'document': DOC_NAME, 'interference_pairs': pairs,
                'artifacts': [{'path': p.relative_to(ROOT).as_posix(), 'bytes': p.stat().st_size,
                               'sha256': hashlib.sha256(p.read_bytes()).hexdigest()} for p in paths],
                'previews': [preview.relative_to(ROOT).as_posix(), side.relative_to(ROOT).as_posix(),belly.relative_to(ROOT).as_posix()],
                'note': 'Visible STEP excludes the hidden laser band keepout. STL is unitless millimetres; review meshes, not slicer jobs.'}
    (OUT / 'export-manifest.json').write_text(json.dumps(manifest, indent=2) + '\n')
    print(json.dumps({'pairs_with_overlap': [p for p in pairs if p['overlap_mm3'] > 0], 'artifacts': len(paths)}))
