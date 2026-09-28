"""Build candidate C1 in a NEW Fusion document from cad/candidate-c1/assembly-inputs.json.

Creates BGD_ISSUE11_C1 only. Never touches another open document. Purchased
parts are dimensioned envelopes; printed parts are native sketch+extrude bodies
with reviewable sketch dimensions. A partial build is left inspectable.
"""
import hashlib
import json
import math
from pathlib import Path
import adsk.core
import adsk.fusion

ROOT = Path(r'C:\Users\zvent\Downloads\B.G.D')
OUT = ROOT / 'cad/candidate-c1'
DOC_NAME = 'BGD_ISSUE11_C1B_BRANCH_FUSE'


def run(_context: str):
    app = adsk.core.Application.get()
    assert not [d for d in app.documents if d.name == DOC_NAME], 'C1 document already open: inspect or close it first'
    doc = app.documents.add(adsk.core.DocumentTypes.FusionDesignDocumentType)
    doc.name = DOC_NAME
    doc.activate()
    design = adsk.fusion.Design.cast(app.activeProduct)
    root = design.rootComponent
    raw = (OUT / 'assembly-inputs.json').read_bytes()
    data = json.loads(raw.decode('utf8'))
    digest = hashlib.sha256(raw).hexdigest()
    root.attributes.add('BGD', 'revision', 'ISSUE11_C1_' + data['revision'] + '_NOT_PHYSICALLY_QUALIFIED')
    root.attributes.add('BGD', 'input_sha256', digest)
    root.attributes.add('BGD', 'frame', data['frame'])
    for name, value in data['parameters'].items():
        pname = 'C1_' + name
        if not design.userParameters.itemByName(pname):
            design.userParameters.add(pname, adsk.core.ValueInput.createByString('%s mm' % value), 'mm',
                                      'C1 layout parameter; placement regenerates from assembly.py')
    records = []
    for p in data['parts']:
        if p['shape'] == 'none':
            continue
        tr = adsk.core.Matrix3D.create()
        if p.get('tilt'):
            ty = adsk.core.Matrix3D.create()
            ty.setToRotation(math.radians(p['tilt']), adsk.core.Vector3D.create(0, 1, 0), adsk.core.Point3D.create(0, 0, 0))
            tr.transformBy(ty)
        if p.get('angle'):
            tz = adsk.core.Matrix3D.create()
            tz.setToRotation(math.radians(p['angle']), adsk.core.Vector3D.create(0, 0, 1), adsk.core.Point3D.create(0, 0, 0))
            tr.transformBy(tz)
        cx, cy, cz = p['center']
        tr.translation = adsk.core.Vector3D.create(cx / 10, cy / 10, cz / 10)
        occ = root.occurrences.addNewComponent(tr)
        comp = occ.component
        comp.name = p['name']
        comp.attributes.add('BGD', 'kind', p['kind'])
        comp.attributes.add('BGD', 'material_basis', p['material'])
        comp.attributes.add('BGD', 'mass_g', str(p['mass_g']) + ' ' + p['mass_basis'])
        comp.attributes.add('BGD', 'hold', p['hold'] or 'Conditional engineering geometry; no physical qualification')
        w, h, t = p['size']
        sketch = comp.sketches.add(comp.xYConstructionPlane)
        sketch.name = p['name'] + '_profile'
        if p['shape'] == 'cylinder':
            sketch.sketchCurves.sketchCircles.addByCenterRadius(adsk.core.Point3D.create(0, 0, 0), w / 20)
            area = math.pi * w * w / 4
        elif p['shape'] == 'hex':
            radius = w / (10 * math.sqrt(3))
            vertices = [adsk.core.Point3D.create(radius*math.cos(math.radians(30+60*i)),
                                                radius*math.sin(math.radians(30+60*i)),0) for i in range(6)]
            for i in range(6):
                sketch.sketchCurves.sketchLines.addByTwoPoints(vertices[i],vertices[(i+1)%6])
            area = math.sqrt(3)*w*w/2
        else:
            lines = sketch.sketchCurves.sketchLines.addTwoPointRectangle(
                adsk.core.Point3D.create(-w / 20, -h / 20, 0), adsk.core.Point3D.create(w / 20, h / 20, 0))
            area = w * h
            if p['kind'] in ('printed_secondary', 'printed_tool'):
                dims = sketch.sketchDimensions
                dims.addDistanceDimension(lines.item(0).startSketchPoint, lines.item(0).endSketchPoint,
                                          adsk.fusion.DimensionOrientations.HorizontalDimensionOrientation,
                                          adsk.core.Point3D.create(0, -h / 20 - 0.5, 0))
                dims.addDistanceDimension(lines.item(1).startSketchPoint, lines.item(1).endSketchPoint,
                                          adsk.fusion.DimensionOrientations.VerticalDimensionOrientation,
                                          adsk.core.Point3D.create(w / 20 + 0.5, 0, 0))
        for hx, hy, d in p.get('holes', []):
            sketch.sketchCurves.sketchCircles.addByCenterRadius(adsk.core.Point3D.create(hx / 10, hy / 10, 0), d / 20)
            area -= math.pi * d * d / 4
        for hx, hy, sw, sh in p.get('slots', []):
            sketch.sketchCurves.sketchLines.addTwoPointRectangle(
                adsk.core.Point3D.create((hx-sw/2)/10, (hy-sh/2)/10, 0),
                adsk.core.Point3D.create((hx+sw/2)/10, (hy+sh/2)/10, 0))
            area -= sw * sh
        loop_count = 1 + len(p.get('holes', [])) + len(p.get('slots', []))
        candidates = [q for q in sketch.profiles if q.profileLoops.count == loop_count
                      and abs(q.areaProperties().area * 100 - area) < 0.01 * area + 0.001]
        assert len(candidates) == 1, (p['name'], 'ambiguous material profile', len(candidates))
        ext = comp.features.extrudeFeatures.createInput(candidates[0], adsk.fusion.FeatureOperations.NewBodyFeatureOperation)
        ext.setSymmetricExtent(adsk.core.ValueInput.createByString('%s mm' % t), True)
        feature = comp.features.extrudeFeatures.add(ext)
        feature.name = p['name'] + '_thickness'
        feature.bodies.item(0).name = p['name']
        sketch.isVisible = False
        for wx,wz,ww,wh in p.get('side_windows_xz',[]):
            window=comp.sketches.add(comp.xZConstructionPlane)
            window.name=p['name']+'_USB_access_XZ'
            one=window.modelToSketchSpace(adsk.core.Point3D.create((wx-ww/2)/10,0,(wz-wh/2)/10))
            two=window.modelToSketchSpace(adsk.core.Point3D.create((wx+ww/2)/10,0,(wz+wh/2)/10))
            window.sketchCurves.sketchLines.addTwoPointRectangle(one,two)
            cut=comp.features.extrudeFeatures.createInput(window.profiles.item(0),adsk.fusion.FeatureOperations.CutFeatureOperation)
            cut.setSymmetricExtent(adsk.core.ValueInput.createByString(f'{h+2} mm'),True)
            comp.features.extrudeFeatures.add(cut);window.isVisible=False
        if p.get('blind_depth_mm'):
            # Thread major-diameter clearance only; no cosmetic helix or strength
            # credit. Two10mm cavities preserve the10mm solid middle web.
            for side in (-1,1):
                plane_input = comp.constructionPlanes.createInput()
                plane_input.setByOffset(comp.xYConstructionPlane, adsk.core.ValueInput.createByString(f'{side*t/2} mm'))
                plane = comp.constructionPlanes.add(plane_input)
                bore = comp.sketches.add(plane)
                bore.sketchCurves.sketchCircles.addByCenterRadius(adsk.core.Point3D.create(0,0,0),.16)
                cut = comp.features.extrudeFeatures.createInput(bore.profiles.item(0),adsk.fusion.FeatureOperations.CutFeatureOperation)
                cut.setDistanceExtent(False,adsk.core.ValueInput.createByString(f'{-side*p["blind_depth_mm"]} mm'))
                comp.features.extrudeFeatures.add(cut)
                bore.isVisible = False
                plane.isLightBulbOn = False
        occ.isLightBulbOn = p['name'] not in ('LASER_PLANE_BAND', 'BATTERY_MAX_ENVELOPE', 'TEMP_MAX_POSITION', 'FC_COMPONENT_KEEP_OUT')
        bb = occ.boundingBox
        records.append({'name': p['name'], 'kind': p['kind'], 'material_basis': p['material'], 'hold': p['hold'],
                        'volume_mm3': sum(b.volume for b in comp.bRepBodies) * 1000,
                        'min_mm': [v * 10 for v in bb.minPoint.asArray()], 'max_mm': [v * 10 for v in bb.maxPoint.asArray()],
                        'visible': occ.isLightBulbOn})
        if len(records) % 15 == 0:
            (OUT / 'fusion-build-progress.json').write_text(json.dumps({'status': 'PARTIAL', 'records': records}, indent=2) + '\n')
    # Preserve review sub-volumes hidden, export one connected structural part.
    belly_names = ['BELLY_TRAY_PLATE','PHONE_WING_L','PHONE_WING_R','PHONE_CHEEK_L','PHONE_CHEEK_R',
                   'PHONE_LIP','DOWNRANGE_MOUNT_BOSS','BATTERY_RAIL_L','BATTERY_RAIL_R','FRONT_RIB_L','FRONT_RIB_R','LAMP_BRACKET','PACK_PAD_PEDESTAL_-1','PACK_PAD_PEDESTAL_1']
    items = {o.component.name:o for o in root.occurrences}
    joined_occ = root.occurrences.addNewComponent(adsk.core.Matrix3D.create())
    joined = joined_occ.component
    joined.name = 'BELLY_CARRIER_UNION'
    bodies = [items[n].bRepBodies.item(0).copyToComponent(joined_occ) for n in belly_names]
    assert all(b is not None for b in bodies)
    tool_bodies = adsk.core.ObjectCollection.create()
    for b in bodies[1:]: tool_bodies.add(b)
    join_input = joined.features.combineFeatures.createInput(bodies[0], tool_bodies)
    join_input.operation = adsk.fusion.FeatureOperations.JoinFeatureOperation
    join_input.isKeepToolBodies = False
    join = joined.features.combineFeatures.add(join_input)
    assert joined.bRepBodies.count == 1 and joined.bRepBodies.item(0).isSolid, 'disconnected belly carrier'
    joined.bRepBodies.item(0).name = 'BELLY_CARRIER_UNION'
    for n in belly_names: items[n].isLightBulbOn = False
    assert design.computeAll()
    joined_occ.isLightBulbOn = True
    joined.bRepBodies.item(0).isVisible = True
    bb = joined.bRepBodies.item(0).boundingBox
    union_record = {'name':joined.name,'subvolumes':belly_names,'solid_body_count':joined.bRepBodies.count,
                    'volume_mm3':joined.bRepBodies.item(0).volume*1000,
                    'min_mm':[v*10 for v in bb.minPoint.asArray()], 'max_mm':[v*10 for v in bb.maxPoint.asArray()],
                    'summed_volume_mm3':sum(r['volume_mm3'] for r in records if r['name'] in belly_names),
                    'health':int(join.healthState),'message':join.errorOrWarningMessage}
    avionics_names=['AVIONICS_CARRIER','POWER_BRIDGE_ROOF','POWER_BRIDGE_LEG_-1','POWER_BRIDGE_LEG_1','CARRIER_STIFFENER_-1','CARRIER_STIFFENER_1','BRANCH_SUPPORT_0','BRANCH_SUPPORT_1']
    joined_occ = root.occurrences.addNewComponent(adsk.core.Matrix3D.create())
    joined = joined_occ.component
    joined.name = 'AVIONICS_POWER_CARRIER_UNION'
    bodies = [items[n].bRepBodies.item(0).copyToComponent(joined_occ) for n in avionics_names]
    assert all(b is not None for b in bodies)
    tool_bodies = adsk.core.ObjectCollection.create()
    for b in bodies[1:]: tool_bodies.add(b)
    join_input = joined.features.combineFeatures.createInput(bodies[0], tool_bodies)
    join_input.operation = adsk.fusion.FeatureOperations.JoinFeatureOperation
    join_input.isKeepToolBodies = False
    join = joined.features.combineFeatures.add(join_input)
    assert joined.bRepBodies.count == 1 and joined.bRepBodies.item(0).isSolid, 'disconnected avionics power carrier'
    joined.bRepBodies.item(0).name = 'AVIONICS_POWER_CARRIER_UNION'
    for n in avionics_names: items[n].isLightBulbOn = False
    assert design.computeAll()
    joined_occ.isLightBulbOn = True
    joined.bRepBodies.item(0).isVisible = True
    bb = joined.bRepBodies.item(0).boundingBox
    avionics_record = {'name':joined.name,'subvolumes':avionics_names,'solid_body_count':joined.bRepBodies.count,
                    'volume_mm3':joined.bRepBodies.item(0).volume*1000,
                    'min_mm':[v*10 for v in bb.minPoint.asArray()], 'max_mm':[v*10 for v in bb.maxPoint.asArray()],
                    'summed_volume_mm3':sum(r['volume_mm3'] for r in records if r['name'] in avionics_names),
                    'health':int(join.healthState),'message':join.errorOrWarningMessage}
    if design.snapshots.hasPendingSnapshot:
        design.snapshots.add()
    assert design.computeAll()
    app.activeViewport.refresh()
    health = []
    for comp in design.allComponents:
        for feature in comp.features.extrudeFeatures:
            if int(feature.healthState) != 0:
                health.append({'name': feature.name, 'health': int(feature.healthState), 'message': feature.errorOrWarningMessage})
    manifest = {'status': 'BUILD_COMPLETE_NOT_RELEASED', 'document': DOC_NAME, 'fusion_version': app.version,
                'input_sha256': digest, 'parts': records, 'timeline_health': health, 'belly_union': union_record, 'avionics_union': avionics_record,
                'native_default_mass': 'INVALID; masses live in cad/candidate-c1/layout-checks.json (sourced component masses plus PETG volumes)'}
    (OUT / 'fusion-build.json').write_text(json.dumps(manifest, indent=2) + '\n')
    print(json.dumps({'status': manifest['status'], 'parts': len(records), 'health_issues': len(health)}))
