"""Inspect the observed connector-reservation intersection before repair."""
import json
import adsk.core
import adsk.fusion
def run(_context:str):
 a=adsk.core.Application.get();doc=next(d for d in a.documents if d.name=='BGD_ISSUE11_R3_PHONE_D500_2P');d=adsk.fusion.Design.cast(doc.products.itemByProductType('DesignProductType'));r=d.rootComponent
 c=next(o for o in r.occurrences if o.component.name=='PHONE_UP10_CONTINUOUS_CARRIER');u=next(o for o in r.occurrences if o.component.name=='PIXEL_USB_PLUG_AND_BEND');g=adsk.core.ObjectCollection.create();g.add(c);g.add(u)
 out=[]
 for h in d.analyzeInterference(d.createInterferenceInput(g)):
  b=h.interferenceBody.boundingBox;out.append({'min':[v*10 for v in b.minPoint.asArray()],'max':[v*10 for v in b.maxPoint.asArray()],'mm3':h.interferenceBody.volume*1000})
 print(json.dumps(out))
