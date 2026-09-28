from pathlib import Path
from types import SimpleNamespace
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from bgd_vision.server import Application, Handler, ThreadingHTTPServer
app=Application(SimpleNamespace(model="Design preview",imgsz=320,log=Path("tmp/preview-unused")))
server=ThreadingHTTPServer(("127.0.0.1",8767),Handler)
server.app=app
server.serve_forever()
