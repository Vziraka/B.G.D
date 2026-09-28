"""Inspect generated extrusion paths and render critical layers, not printer QA."""
from collections import defaultdict
import json
import math
from pathlib import Path
import re
import xml.etree.ElementTree as ET
from zipfile import ZipFile
from PIL import Image, ImageDraw, ImageFont

HERE = Path(__file__).resolve().parent
LAYERS = {
    'pi-carrier-core-draft': [0.2, 4.4, 4.8, 8.0, 9.2],
    'camera-bracket': [0.2, 14.0, 16.0, 26.4, 28.4],
    'forward-depth-bracket': [0.2, 15.8, 16.2, 18.0, 19.2],
    'battery-end-stops': [0.2, 2.4, 3.0, 10.0, 17.6],
    'electronics-stack-adapter': [0.2, 2.4, 2.6, 4.0, 5.8],
    'electronics-flow-support': [0.2, 2.4, 2.6, 4.0, 5.4],
}
COLORS = {'Support': '#e68a2e', 'Support interface': '#ad5500',
          'Outer wall': '#1763a6', 'Inner wall': '#4797cc',
          'Bridge': '#ad4fa4', 'Internal Bridge': '#ad4fa4',
          'Skirt': '#aaaaaa', 'Brim': '#aaaaaa'}


def read_paths(text, transform):
    layers = defaultdict(list)
    x = y = z = e = 0.0
    feature = 'Custom'
    relative_e = True
    width = 0.42
    for line in text.splitlines():
        if line.startswith('; FEATURE: '):
            feature = line.split(': ', 1)[1]
        if line.startswith('; LINE_WIDTH: '):
            width = float(line.split(': ', 1)[1])
        code = line.split(';')[0].strip()
        if code == 'M83': relative_e = True
        if code == 'M82': relative_e = False
        if not re.match(r'G(?:0|1|2|3|92)\s', code): continue
        args = {k: float(v) for k, v in re.findall(r'([XYZE])([-+\d.]+)', code)}
        if code.startswith('G92 '):
            e = args.get('E', e)
            continue
        nx, ny, nz = args.get('X', x), args.get('Y', y), args.get('Z', z)
        de = args.get('E', 0) if relative_e else args.get('E', e) - e
        if de > 0 and (nx != x or ny != y) and feature != 'Custom':
            assert code.startswith(('G0 ', 'G1 ')), 'Extruding arc requires arc-aware inspection'
            def local(gx, gy):
                dx, dy = gx-transform[9], gy-transform[10]
                # The component transform already restores the STL source center.
                return (transform[0]*dx+transform[1]*dy,
                        transform[3]*dx+transform[4]*dy)
            layers[round(nz, 3)].append((*local(x,y), *local(nx,ny), feature, de, width))
        x, y, z = nx, ny, nz
        e = e + args.get('E', 0) if relative_e else args.get('E', e)
    return layers


def support_inside(part, layers):
    hits = []
    for z, paths in layers.items():
        for x, y, nx, ny, feature, _, width in paths:
            if not feature.startswith('Support'): continue
            steps = max(1, math.ceil(math.hypot(nx-x, ny-y)/0.2))
            for i in range(steps+1):
                px, py = x+(nx-x)*i/steps, y+(ny-y)*i/steps
                # Conservative swept half-width in XY; layer-top Z recorded.
                r = width/2
                if part == 'pi-carrier-core-draft':
                    inside = 7.05 < z < 8.95 and any(abs(px-cx)<2+r for cx in [-9,9]) and 25-r < abs(py) < 39+r
                elif part in ['camera-bracket', 'forward-depth-bracket']:
                    centers = [(xx, zz) for xx in ([-10.5,10.5] if part=='camera-bracket' else [-6.35,6.35])
                               for zz in ([16,28.5] if part=='camera-bracket' else [18])]
                    inside = -3-r < py < 2.5+r and any(math.hypot(px-cx,z-cz)<1.15+r for cx,cz in centers)
                else: inside = False
                if inside:
                    hits.append({'z':z, 'xy':[round(px,2),round(py,2)],'feature':feature})
                    break
    return hits


def render(part, layers):
    points = [(v[i], v[i+1]) for paths in layers.values() for v in paths for i in [0,2]]
    x0,y0 = min(p[0] for p in points)-2, min(p[1] for p in points)-2
    x1,y1 = max(p[0] for p in points)+2, max(p[1] for p in points)+2
    scale=min(390/(x1-x0),380/(y1-y0))
    im=Image.new('RGB',(2200,520),'white'); d=ImageDraw.Draw(im)
    font=ImageFont.truetype('C:/Windows/Fonts/arial.ttf',18)
    d.text((20,10),part+' | actual extrusion paths | blue: walls, teal: fill, orange: supports, purple: bridges',font=font,fill='#182b41')
    for panel,target in enumerate(LAYERS[part]):
        z=min(layers,key=lambda zz:abs(zz-target))
        ox=panel*440+25; oy=65
        d.text((ox,40),f'Layer Z {z:g} mm',font=font,fill='#182b41')
        for x,y,nx,ny,feature,_,width in layers[z]:
            coords=[ox+(x-x0)*scale,oy+(y1-y)*scale,ox+(nx-x0)*scale,oy+(y1-ny)*scale]
            d.line(coords,fill=COLORS.get(feature,'#208c83'),width=max(1,round(width*scale)))
    im.save(HERE/part/'critical-layers.png')


def main():
    summaries=[]
    for part in LAYERS:
        with ZipFile(HERE/part/(part+'.3mf')) as zf:
            config=ET.fromstring(zf.read('Metadata/model_settings.config'))
            model=ET.fromstring(zf.read('3D/3dmodel.model'))
            ns={'m':'http://schemas.microsoft.com/3dmanufacturing/core/2015/02'}
            normal_id=config.find('.//part[@subtype="normal_part"]').get('id')
            component=next(c for c in model.findall('.//m:component',ns) if c.get('objectid')==normal_id)
            meshpath=component.get('{http://schemas.microsoft.com/3dmanufacturing/production/2015/06}path').lstrip('/')
            meshfile=ET.fromstring(zf.read(meshpath))
            mesh=meshfile.find(f'.//m:object[@id="{normal_id}"]',ns)
            ct=list(map(float,component.get('transform').split()))
            mesh_vertices=[]
            for v in mesh.findall('.//m:vertex',ns):
                x,y,z=map(float,(v.get('x'),v.get('y'),v.get('z')))
                mesh_vertices.append(tuple(x*ct[i]+y*ct[i+3]+z*ct[i+6]+ct[i+9] for i in range(3)))
            original=set(tuple(float(n) for n in values) for values in re.findall(
                r'vertex\s+([-\d.eE+]+)\s+([-\d.eE+]+)\s+([-\d.eE+]+)',(HERE/'models'/(part+'.stl')).read_text()))
            rounded_original={tuple(round(n,3) for n in v) for v in original}
            assert len(mesh_vertices)==len(original), (part,'Vertex count changed')
            assert all(tuple(round(n,3) for n in v) in rounded_original or
                       any(max(abs(a-b) for a,b in zip(v,o))<0.001 for o in original)
                       for v in mesh_vertices), (part,'Export changed printable mesh')
            transform=list(map(float,model.find('m:build/m:item',ns).get('transform').split()))
            assert transform[2]==transform[5]==transform[6]==transform[7]==0 and transform[8]==1, 'Unexpected tilt'
            info=ET.fromstring(zf.read('Metadata/slice_info.config'))
            warnings=[n.attrib for n in info.findall('.//warning')]
            text=zf.read('Metadata/plate_1.gcode').decode()
        layers=read_paths(text,transform)
        feature_e=defaultdict(float)
        for paths in layers.values():
            for *_,feature,e,width in paths: feature_e[feature]+=e
        factor=math.pi*(1.75/2)**2 * 1.3 / 1000
        summary={'part':part,'layers':len(layers),'warnings':warnings,'printable_mesh_matches_source_to_0_001_mm':True,
                 'total_slicer_filament_g':float(re.search(r'; filament used \[g\] = ([\d.]+)',text)[1]),
                 'time':re.search(r'; model printing time: ([^\r\n]+)',text)[1],
                 'extrusion_g_by_feature':{k:round(v*factor,3) for k,v in feature_e.items()},
                 'support_in_functional_openings':support_inside(part,layers)}
        render(part,layers); summaries.append(summary)
        print(part,summary['total_slicer_filament_g'],'g',summary['time'],
              'opening support hits:',len(summary['support_in_functional_openings']),'warnings:',warnings)
    (HERE/'slice-review.json').write_text(json.dumps(summaries,indent=2)+'\n')
    assert all(not s['warnings'] and not s['support_in_functional_openings'] for s in summaries), 'Review unresolved warnings/opening support'


if __name__=='__main__': main()
