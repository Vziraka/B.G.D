"""Inspect installed native Simulation controls; no cloud save, solve or credits."""
import json
from pathlib import Path
import adsk.core

OUT=Path(r'C:\Users\zvent\Downloads\B.G.D\cad\engineering-r2-2026-09-10')
def run(_context: str):
    app=adsk.core.Application.get()
    doc=next(d for d in app.documents if d.name=='BGD_ISSUE11_R2');doc.activate()
    ui=app.userInterface
    commands=[{'id':c.id,'name':c.name,'description':c.tooltip} for c in ui.commandDefinitions if any(k in (c.id+' '+c.name).lower() for k in ('sim','stress','study','mesh','solve','constraint'))]
    sim=ui.workspaces.itemById('SimulationEnvironment')
    activated=sim.activate()
    result={'workspace_available':bool(sim),'activation_result':activated,'active_workspace':ui.activeWorkspace.id,
            'active_command':ui.activeCommand,'commands':commands,'solve_submitted':False,
            'boundary':'Installed command inventory only; no upload, cloud save, material/mesh/load validity or solved FEA is claimed'}
    (OUT/'simulation-workflow-audit.json').write_text(json.dumps(result,indent=2)+'\n')
    app.activeViewport.saveAsImageFile(str(OUT/'simulation-workspace.png'),1200,900)
    print(json.dumps({'activation':activated,'active_workspace':ui.activeWorkspace.id,'active_command':ui.activeCommand,'candidate_commands':len(commands)}))
