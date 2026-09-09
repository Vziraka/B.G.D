"""Inspect omitted source layers before inferring a complete frame stack."""
import json
from pathlib import Path
import adsk.core
import adsk.fusion


def run(_context: str):
    app=adsk.core.Application.get()
    assert app.activeDocument.name=='BGD_MASTER'
    design=adsk.fusion.Design.cast(app.activeProduct)
    root=design.rootComponent
    assert not any(o.component.name=='00_ADDITIONAL_SOURCE_LAYERS' for o in root.occurrences)
    occ=root.occurrences.addNewComponent(adsk.core.Matrix3D.create())
    comp=occ.component
    comp.name='00_ADDITIONAL_SOURCE_LAYERS'
    opts=app.importManager.createDXF2DImportOptions(r'C:\Users\zvent\Downloads\B.G.D\.scratch\hardware-artifacts\frame.dxf',comp.xYConstructionPlane)
    opts.layers=['Frame-Top','Camera-Holder','Draw2','Draw6','Draw']
    opts.isSingleSketchResult=False
    app.importManager.importToTarget2(opts,comp)
    profiles=[]
    for s in comp.sketches:
        for j,p in enumerate(s.profiles):
            props=p.areaProperties(adsk.fusion.CalculationAccuracy.HighCalculationAccuracy)
            c=props.centroid
            if props.area*100<50:continue
            b=p.boundingBox
            profiles.append({'layer':s.name,'index':j,'area_mm2':props.area*100,'loops':p.profileLoops.count,
                             'center_mm':[c.x*10,c.y*10],
                             'min_mm':[b.minPoint.x*10,b.minPoint.y*10],
                             'max_mm':[b.maxPoint.x*10,b.maxPoint.y*10]})
    occ.isLightBulbOn=False
    path=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\reference\source-one-v6-7in\fusion-additional-profiles.json')
    with path.open('x',encoding='utf-8') as f:json.dump(profiles,f,indent=2)
    print(json.dumps({'count':len(profiles),'near_frame':[p for p in profiles if abs(p['center_mm'][0]-1518.565263)<250 and abs(p['center_mm'][1]-1461.258462)<250]}))
