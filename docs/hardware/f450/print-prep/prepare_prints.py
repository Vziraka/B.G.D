"""Reproduce local prototype slicing with the pinned portable OrcaSlicer.

No printer connection or job submission. Profiles derive from OrcaSlicer 2.4.2
bundled BBL presets (AGPL-3.0); see README.md for assumptions and attribution.
"""
import argparse
import json
from pathlib import Path
import shutil
import subprocess
import xml.etree.ElementTree as ET
from zipfile import ZipFile, ZIP_DEFLATED

HERE = Path(__file__).resolve().parent
CAD = HERE.parent
REPO = HERE.parents[3]
ORCA = REPO / 'tmp/slicer-tools/orca'
PROFILES = ORCA / 'resources/profiles/BBL'
PARTS = ['pi-carrier-core-draft', 'camera-bracket', 'forward-depth-bracket',
         'battery-end-stops', 'electronics-stack-adapter', 'electronics-flow-support']


def resolve(kind, name):
    data = json.loads((PROFILES / kind / (name + '.json')).read_text(encoding='utf-8'))
    parent = data.get('inherits')
    return (resolve(kind, parent) if parent else {}) | data


def save(name, data):
    path = HERE / 'profiles' / (name + '.json')
    path.parent.mkdir(exist_ok=True)
    path.write_text(json.dumps(data, indent=2) + '\n', encoding='utf-8')
    return path


def block_screw_bores(project, target, part):
    """Add slicer support-blocker volumes; never modify the printable mesh."""
    core = 'http://schemas.microsoft.com/3dmanufacturing/core/2015/02'
    production = 'http://schemas.microsoft.com/3dmanufacturing/production/2015/06'
    ET.register_namespace('', core)
    ET.register_namespace('p', production)
    tag = lambda name: '{' + core + '}' + name
    with ZipFile(project) as archive:
        files = {name: archive.read(name) for name in archive.namelist()}
    root = ET.fromstring(files['3D/3dmodel.model'])
    components = root.find('.//' + tag('components'))
    mesh_path = components[0].get('{' + production + '}path').lstrip('/')
    meshes = ET.fromstring(files[mesh_path])
    resources = meshes.find(tag('resources'))
    config = ET.fromstring(files['Metadata/model_settings.config'])
    object_config = config.find('object')
    xs = [-10.5, 10.5] if part == 'camera-bracket' else [-6.35, 6.35]
    zs = [16, 28.5] if part == 'camera-bracket' else [18]
    faces = [(0,2,1),(0,3,2),(4,5,6),(4,6,7),(0,1,5),(0,5,4),
             (1,2,6),(1,6,5),(2,3,7),(2,7,6),(3,0,4),(3,4,7)]
    for index, (x,z) in enumerate(((x,z) for x in xs for z in zs), start=3):
        mesh_object = ET.SubElement(resources, tag('object'), id=str(index), type='model')
        mesh = ET.SubElement(mesh_object, tag('mesh'))
        vertices = ET.SubElement(mesh, tag('vertices'))
        coords = [(x-1.5,-3.5,z-1.5),(x+1.5,-3.5,z-1.5),
                  (x+1.5,3,z-1.5),(x-1.5,3,z-1.5),
                  (x-1.5,-3.5,z+1.5),(x+1.5,-3.5,z+1.5),
                  (x+1.5,3,z+1.5),(x-1.5,3,z+1.5)]
        for vx,vy,vz in coords:
            ET.SubElement(vertices,tag('vertex'),x=str(vx),y=str(vy),z=str(vz))
        triangles=ET.SubElement(mesh,tag('triangles'))
        for a,b,c in faces: ET.SubElement(triangles,tag('triangle'),v1=str(a),v2=str(b),v3=str(c))
        ET.SubElement(components,tag('component'),{
            '{'+production+'}path':'/'+mesh_path,'objectid':str(index),
            'transform':'1 0 0 0 1 0 0 0 1 0 0 0'})
        entry=ET.SubElement(object_config,'part',id=str(index),subtype='support_blocker')
        ET.SubElement(entry,'metadata',key='name',value=f'Screw bore support blocker {index-2}')
        ET.SubElement(entry,'metadata',key='matrix',value='1 0 0 0 0 1 0 0 0 0 1 0 0 0 0 1')
    files['3D/3dmodel.model']=ET.tostring(root,encoding='utf-8',xml_declaration=True)
    files[mesh_path]=ET.tostring(meshes,encoding='utf-8',xml_declaration=True)
    files['Metadata/model_settings.config']=ET.tostring(config,encoding='utf-8',xml_declaration=True)
    with ZipFile(target,'w',ZIP_DEFLATED) as archive:
        for name,data in files.items(): archive.writestr(name,data)


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('parts', nargs='*', help='Optional part stems; omit for all six.')
    args = parser.parse_args()
    if any(part not in PARTS for part in args.parts): parser.error('Unknown part name')
    machine = resolve('machine', 'Bambu Lab X1E 0.4 nozzle')
    machine['inherits'] = ''  # Flatten inheritance for the CLI.
    machine_path = save('x1e-0.4', machine)
    process = resolve('process', '0.20mm Standard @BBL X1C')
    process.update(name='BGD PETG fit prototype 0.20', inherits='', **{
        'wall_loops': '4', 'sparse_infill_density': '30%',
        'sparse_infill_pattern': 'gyroid', 'top_shell_layers': '5',
        'bottom_shell_layers': '5', 'outer_wall_speed': ['40'],
        'inner_wall_speed': ['60'], 'sparse_infill_speed': ['70'],
        'internal_solid_infill_speed': ['60'], 'top_surface_speed': ['40'],
        'initial_layer_speed': ['20'], 'initial_layer_infill_speed': ['30'],
        'bridge_speed': ['25'], 'support_speed': ['50'],
        'support_interface_speed': ['30'], 'enable_support': '0',
        'support_type': 'normal(auto)', 'support_style': 'grid',
        'support_threshold_angle': '30', 'support_top_z_distance': '0.2',
        'support_object_xy_distance': '0.4', 'support_on_build_plate_only': '0',
        'bridge_no_support': '0', 'brim_type': 'outer_only', 'brim_width': '3',
        'brim_object_gap': '0.2', 'enable_prime_tower': '0', 'enable_arc_fitting': '0',
    })
    filament = resolve('filament', 'Generic PETG')
    filament.update(name='BGD Polymaker PETG provisional', inherits='', **{
        'nozzle_temperature': ['250'], 'nozzle_temperature_initial_layer': ['250'],
        'textured_plate_temp': ['65'], 'textured_plate_temp_initial_layer': ['65'],
        'filament_density': ['1.3'], 'filament_max_volumetric_speed': ['8'],
        'fan_min_speed': ['20'], 'fan_max_speed': ['60'],
        'overhang_fan_speed': ['60'], 'additional_cooling_fan_speed': ['0'],
        'chamber_temperature': ['0'], 'activate_chamber_temp_control': ['0'],
    })
    filament_path = save('polymaker-petg-provisional', filament)
    (HERE / 'models').mkdir(exist_ok=True)
    for part in args.parts or PARTS:
        model = HERE / 'models' / (part + '.stl')
        if part == 'electronics-stack-adapter':
            # Exact rigid transform: X180, Z+6. Preserves triangle ordering.
            lines = []
            for line in (CAD / (part + '.stl')).read_text().splitlines():
                fields = line.split()
                if fields[:2] == ['facet', 'normal']:
                    x, y, z = map(float, fields[2:])
                    line = f'facet normal {x} {-y} {-z}'
                elif fields[:1] == ['vertex']:
                    x, y, z = map(float, fields[1:])
                    line = f'vertex {x} {-y} {6-z}'
                lines.append(line)
            model.write_text('\n'.join(lines) + '\n')
        else:
            shutil.copyfile(CAD / (part + '.stl'), model)
        settings = process.copy()
        settings['enable_support'] = '1' if part in PARTS[:3] else '0'
        if part == 'pi-carrier-core-draft':
            # Ring support starts on bed; do not seed support on tunnel floors.
            settings['support_on_build_plate_only'] = '1'
        if part in ['camera-bracket', 'forward-depth-bracket']:
            settings['bridge_no_support'] = '1'
        if part == 'camera-bracket':
            settings['support_type'] = 'tree(auto)'
            settings['support_style'] = 'organic'
        process_path = save(part, settings)
        output = HERE / part
        output.mkdir(exist_ok=True)
        command = [str(ORCA / 'orca-slicer.exe'), '--load-settings',
                   str(machine_path) + ';' + str(process_path),
                   '--load-filaments', str(filament_path),
                   '--curr-bed-type', 'Textured PEI Plate',
                   '--arrange', '1', '--ensure-on-bed', '--slice', '0',
                   '--outputdir', str(output), '--export-3mf', part + '.3mf',
                   str(model)]
        result = subprocess.run(command, capture_output=True, creationflags=subprocess.CREATE_NO_WINDOW)
        (output / 'slice.log').write_bytes(result.stdout + result.stderr)
        print(part, 'exit', result.returncode, flush=True)
        if result.returncode:
            raise SystemExit(result.returncode)
        if part in ['camera-bracket', 'forward-depth-bracket']:
            blocked = HERE / 'models' / (part + '-with-blockers.3mf')
            block_screw_bores(output / (part + '.3mf'), blocked, part)
            command[-1] = str(blocked)
            result = subprocess.run(command, capture_output=True, creationflags=subprocess.CREATE_NO_WINDOW)
            (output / 'slice.log').write_bytes(result.stdout + result.stderr)
            print(part, 'with bore blockers exit', result.returncode, flush=True)
            if result.returncode: raise SystemExit(result.returncode)


if __name__ == '__main__':
    main()
