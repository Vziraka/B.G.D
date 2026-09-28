"""Read native assembly health after imported camera placement repair."""
import json
import adsk.core,adsk.fusion
def run(_context:str):
    app=adsk.core.Application.get();doc=next(d for d in app.documents if d.name=='BGD_R3_HYBRID');doc.activate()
    d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent
    rec=[]
    for o in r.occurrences:
        if not o.component.name.startswith(('606','OAK_EXACT')):continue
        b=o.boundingBox
        rec.append({'name':o.component.name,'grounded':o.isGrounded,'groundparent':getattr(o,'isGroundToParent',None),
        'bodies':o.component.bRepBodies.count,'bbox':[[q*10 for q in p.asArray()] for p in [b.minPoint,b.maxPoint]],
        'bodyboxes':[{'name':a.name,'min':[q*10 for q in a.boundingBox.minPoint.asArray()],'max':[q*10 for q in a.boundingBox.maxPoint.asArray()]} for a in o.component.bRepBodies]})
    print(json.dumps({'type':str(d.designType),'timeline':d.timeline.count,'marker':d.timeline.markerPosition,'records':rec}))
