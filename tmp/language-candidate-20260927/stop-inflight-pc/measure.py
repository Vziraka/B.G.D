"""One-run PC check that Stop outruns a real local-model interpretation."""

import hashlib
import http.client
import json
from pathlib import Path
import subprocess
import sys
import threading
import time

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(ROOT))

from bgd_vision import conversation

MODEL = ROOT / "tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf"
SERVER = ROOT / "tmp/language-candidate-20260922/windows/llama-server.exe"
SOURCE = ROOT / "bgd_vision/conversation.py"
PORT = 8085
REQUEST = "Shadow the blue bottle"


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main():
    output = HERE / "result.json"
    if output.exists():
        raise FileExistsError("Refusing to overwrite one-run evidence")
    if (conversation._request_policy_result(REQUEST) is not None
            or conversation._source_grounded_plan(REQUEST) is not None):
        raise RuntimeError("Request no longer exercises the real model")
    source_hash = sha256(SOURCE)
    arguments = [str(SERVER), "-m", str(MODEL), "--host", "127.0.0.1",
                 "--port", str(PORT), "-t", "2", "-tb", "2", "-c", "2048",
                 "-np", "1", "--jinja", "--no-webui"]
    started = time.perf_counter()
    with (HERE / "server.stdout.log").open("wb") as stdout, \
            (HERE / "server.stderr.log").open("wb") as stderr:
        process = subprocess.Popen(arguments, cwd=ROOT, stdout=stdout, stderr=stderr,
                                   creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        try:
            while time.perf_counter() - started < 120:
                if process.poll() is not None:
                    raise RuntimeError(f"Model server exited: {process.returncode}")
                try:
                    connection = http.client.HTTPConnection("127.0.0.1", PORT, timeout=2)
                    connection.request("GET", "/health")
                    response = connection.getresponse()
                    response.read()
                    connection.close()
                    if response.status == 200:
                        break
                except OSError:
                    pass
                time.sleep(0.5)
            else:
                raise TimeoutError("Model server did not become ready")

            ready_ms = round((time.perf_counter() - started) * 1000, 1)
            interpreter = conversation.LocalSemanticInterpreter(PORT, timeout=8)
            dialog = conversation.Conversation(interpreter=interpreter)
            holder = {}

            def interpret():
                begun = time.perf_counter()
                holder["request_result"] = dialog.propose(REQUEST)
                holder["request_elapsed_ms"] = round((time.perf_counter() - begun) * 1000, 1)

            worker = threading.Thread(target=interpret, daemon=True)
            worker.start()
            deadline = time.perf_counter() + 5
            while not interpreter.busy.locked() and time.perf_counter() < deadline:
                time.sleep(0.005)
            if not interpreter.busy.locked():
                raise RuntimeError("Interpretation never entered model call")
            time.sleep(0.5)  # Let the HTTP request reach the active model server.
            stop_started = time.perf_counter()
            stopped = dialog.propose("Stop")
            stop_ms = round((time.perf_counter() - stop_started) * 1000, 1)
            worker.join(timeout=35)
            if worker.is_alive():
                raise TimeoutError("Model request did not return after Stop")
            snapshot = dialog.snapshot()
            result = {
                "purpose": "One real PC model-in-flight Stop check; no Pi/flight claim",
                "request": REQUEST,
                "server_ready_ms": ready_ms,
                "stop_elapsed_ms": stop_ms,
                "stop_status": stopped["status"],
                "late_request_elapsed_ms": holder["request_elapsed_ms"],
                "late_request_status": holder["request_result"]["status"],
                "pending_after_stop": snapshot["status"],
                "model_diagnostic": interpreter.last_diagnostic,
                "source_sha256": source_hash,
                "model_sha256": sha256(MODEL),
                "server_sha256": sha256(SERVER),
                "server_arguments": arguments[1:],
                "pass": (stopped["status"] == "stopped" and stop_ms < 500
                         and holder["request_result"]["status"] == "superseded"
                         and snapshot["status"] == "idle"),
            }
            output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
            print(json.dumps({key: value for key, value in result.items()
                              if key != "model_diagnostic"}), flush=True)
        finally:
            process.terminate()
            try:
                process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait(timeout=10)
    if sha256(SOURCE) != source_hash:
        raise RuntimeError("Source changed during Stop check")


if __name__ == "__main__":
    main()
