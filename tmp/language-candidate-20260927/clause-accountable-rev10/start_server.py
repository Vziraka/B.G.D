"""Start the pinned local llama.cpp runtime without opening a console window."""

import http.client
import json
import subprocess
import argparse
import time
from pathlib import Path

ROOT = Path(__file__).resolve().parents[3]
HERE = Path(__file__).resolve().parent
exe = ROOT / "tmp/language-candidate-20260922/windows/llama-server.exe"
model = ROOT / "tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf"

parser = argparse.ArgumentParser()
parser.add_argument("--label", choices=("candidate-frozen30", "candidate-development-v2",
                                         "candidate-open-rev10"), required=True)
label = parser.parse_args().label
stdout_path = HERE / f"{label}-server.stdout.log"
stderr_path = HERE / f"{label}-server.stderr.log"
args = [str(exe), "-m", str(model), "--host", "127.0.0.1", "--port", "8084",
        "-t", "2", "-tb", "2", "-c", "2048", "-np", "1", "--jinja", "--no-webui"]

with stdout_path.open("wb") as stdout, stderr_path.open("wb") as stderr:
    process = subprocess.Popen(args, cwd=ROOT, stdout=stdout, stderr=stderr,
                               creationflags=subprocess.CREATE_NO_WINDOW)
pid_file = HERE / f"{label}-server.pid"
pid_file.write_text(str(process.pid), encoding="ascii")
started = time.perf_counter()
ready = False
for _ in range(240):
    if process.poll() is not None:
        raise RuntimeError(f"llama-server exited during startup with code {process.returncode}")
    try:
        connection = http.client.HTTPConnection("127.0.0.1", 8084, timeout=2)
        connection.request("GET", "/health")
        response = connection.getresponse()
        response.read()
        connection.close()
        if response.status == 200:
            ready = True
            break
    except OSError:
        pass
    time.sleep(0.5)
if not ready:
    process.terminate()
    raise TimeoutError("llama-server did not become healthy within 120 seconds")
ready_ms = round((time.perf_counter() - started) * 1000, 1)
(HERE / f"{label}-server-ready.json").write_text(json.dumps({
    "pid": process.pid,
    "host": "127.0.0.1",
    "port": 8084,
    "ready_ms": ready_ms,
    "arguments": args[1:],
}, indent=2) + "\n", encoding="utf-8")
print(json.dumps({"pid": process.pid, "ready_ms": ready_ms}))
