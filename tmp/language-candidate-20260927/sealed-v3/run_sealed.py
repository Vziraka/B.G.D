"""Run one newly sealed meaning trial against the frozen rev7 candidate."""

import hashlib
import http.client
import json
from pathlib import Path
import shutil
import subprocess
import sys
import time


HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
PROFILE = ROOT / "tmp/language-candidate-20260927/clause-accountable-rev7"
CORPUS = ROOT / "tests/vision/fixtures/conversation-heldout-20260927-v3.json"
MODEL = ROOT / "tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf"
SERVER = ROOT / "tmp/language-candidate-20260922/windows/llama-server.exe"
PORT = 8082
EXPECTED_CORPUS_SHA256 = "02befce4589624c66d5fcead0fae5aa53c1a07fb84ffcf4c7ed76fb2fe9c6574"
EXPECTED_SOURCE_SHA256 = "f471605b09b2af77476db890de5dce6311deb589946c64310aec47610b5fb297"
EXPECTED_PROFILE_LOCK_SHA256 = "3d3a613c0833be14a83db9faff0066fb7ee17698d895e2ee911c44338baceeed"


def sha256(path):
    digest = hashlib.sha256()
    with path.open("rb") as source:
        for block in iter(lambda: source.read(1024 * 1024), b""):
            digest.update(block)
    return digest.hexdigest()


def main():
    output = HERE / "sealed-results.json"
    raw = HERE / "sealed-raw.jsonl"
    for path in (output, raw, HERE / "run-lock.json", HERE / "evaluate.py",
                 HERE / "sealed-manifest.json"):
        if path.exists():
            raise FileExistsError(f"Refusing to overwrite prior evidence: {path}")
    if sha256(CORPUS) != EXPECTED_CORPUS_SHA256:
        raise RuntimeError("Sealed corpus hash changed")
    if sha256(PROFILE / "conversation-revision7.py") != EXPECTED_SOURCE_SHA256:
        raise RuntimeError("Frozen production source changed")
    if sha256(PROFILE / "run-lock.json") != EXPECTED_PROFILE_LOCK_SHA256:
        raise RuntimeError("Frozen candidate lock changed")
    source = (PROFILE / "evaluate.py").read_text(encoding="utf-8")
    original = '    "conversation-development-v2.json",\n}'
    replacement = ('    "conversation-development-v2.json",\n'
                   '    "conversation-heldout-20260927-v3.json",\n}')
    if source.count(original) != 1:
        raise RuntimeError("Unexpected rev7 evaluator; refusing unreviewed patch")
    (HERE / "evaluate.py").write_text(source.replace(original, replacement), encoding="utf-8")
    for name in ("system-prompt.txt", "schema.json"):
        shutil.copyfile(PROFILE / name, HERE / name)
    lock = json.loads((PROFILE / "run-lock.json").read_text(encoding="utf-8"))
    relative = CORPUS.relative_to(ROOT).as_posix()
    lock["files"][relative] = {"sha256": sha256(CORPUS), "bytes": CORPUS.stat().st_size}
    (HERE / "run-lock.json").write_text(json.dumps(lock, indent=2) + "\n", encoding="utf-8")

    arguments = [str(SERVER), "-m", str(MODEL), "--host", "127.0.0.1",
                 "--port", str(PORT), "-t", "2", "-tb", "2", "-c", "2048",
                 "-np", "1", "--jinja", "--no-webui"]
    started = time.perf_counter()
    with (HERE / "server.stdout.log").open("wb") as stdout, \
            (HERE / "server.stderr.log").open("wb") as stderr:
        process = subprocess.Popen(arguments, cwd=ROOT, stdout=stdout, stderr=stderr,
                                   creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
        try:
            ready = False
            while time.perf_counter() - started < 120:
                if process.poll() is not None:
                    raise RuntimeError(f"Model server exited at startup: {process.returncode}")
                try:
                    connection = http.client.HTTPConnection("127.0.0.1", PORT, timeout=2)
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
                raise TimeoutError("Model server did not become ready")
            ready_ms = round((time.perf_counter() - started) * 1000, 1)
            command = [sys.executable, str(HERE / "evaluate.py"), "--port", str(PORT),
                       "--timeout", "30", "--corpus", str(CORPUS),
                       "--output", str(output), "--raw-jsonl", str(raw)]
            with (HERE / "evaluation.log").open("w", encoding="utf-8") as log:
                evaluated = subprocess.run(command, cwd=ROOT, stdout=log,
                                           stderr=subprocess.STDOUT, timeout=900, check=False)
        finally:
            process.terminate()
            try:
                process.wait(timeout=10)
            except subprocess.TimeoutExpired:
                process.kill()
                process.wait(timeout=10)

    evidence = {
        "purpose": "One newly sealed PC text-meaning trial; not a release or Pi qualification",
        "server_ready_ms": ready_ms,
        "evaluation_exit_code": evaluated.returncode,
        "server_port": PORT,
        "server_arguments": arguments[1:],
        "inputs": {str(path.relative_to(ROOT)): sha256(path) for path in
                   (CORPUS, MODEL, SERVER, PROFILE / "conversation-revision7.py",
                    PROFILE / "run-lock.json", HERE / "evaluate.py")},
        "outputs": {path.name: sha256(path) for path in (output, raw)},
        "server_stopped": process.poll() is not None,
    }
    (HERE / "sealed-manifest.json").write_text(json.dumps(evidence, indent=2) + "\n",
                                               encoding="utf-8")
    print(json.dumps({"ready_ms": ready_ms, "exit_code": evaluated.returncode,
                      "passed": json.loads(output.read_text(encoding="utf-8"))["passed"],
                      "total": json.loads(output.read_text(encoding="utf-8"))["total"]}))


if __name__ == "__main__":
    main()
