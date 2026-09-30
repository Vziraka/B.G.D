"""Separate frozen owner-approved text trial; no acceptance threshold."""

import json
import statistics
import subprocess
import time
from datetime import datetime, timezone
from pathlib import Path

import measure_bare as trial


def main():
    source = Path(__file__).resolve().parent / "owner-approved-commands-20260930.json"
    output = source.parent / "owner-text-20260930"
    output.mkdir(exist_ok=False)
    fixture = json.loads(source.read_text(encoding="utf-8"))
    cases = fixture["semantic_cases"]
    rev13 = trial.frozen_module()
    model = trial.ROOT / "tmp/language-candidate-20260926/qwen35-4b-q4_k_m.gguf"
    server = trial.ROOT / "tmp/language-candidate-20260922/windows/llama-server.exe"
    inputs = [source, Path(__file__), Path(trial.__file__), model, server,
              trial.ROOT / "bgd_vision/conversation.py",
              trial.ROOT / "tmp/language-candidate-20260927/boundary-v14-baseline/rev13-conversation.py"]
    manifest = {
        "purpose": "Owner-approved agent-seeded text trial with old frozen prompt; no tuning, sealed/spoken/Pi qualification, or numeric gate.",
        "started_utc": datetime.now(timezone.utc).isoformat(),
        "inputs": {str(path): trial.sha(path) for path in inputs},
        "prompt_sha256": trial.hashlib.sha256(trial.live.SYSTEM_PROMPT.encode()).hexdigest(),
        "profiles": trial.PROFILES, "overlaps_step0_pc_run": True,
        "timing_limit": "Separate two-thread processes may overlap on this 16-core PC. Times are actual durations, not a controlled latency comparison.",
        "summaries": {}, "server_runs": [],
    }
    trial.write(output / "manifest-before.json", manifest)
    for profile_name, profile in trial.PROFILES.items():
        args = [str(server), "-m", str(model), "--host", "127.0.0.1", "--port", "8086",
                "-t", "2", "-tb", "2", "-c", "2048", "-np", "1", "--jinja", "--no-webui"]
        with (output / f"{profile_name}-server.stdout.log").open("wb") as stdout, \
                (output / f"{profile_name}-server.stderr.log").open("wb") as stderr:
            process = subprocess.Popen(args, cwd=trial.ROOT, stdout=stdout, stderr=stderr,
                                       creationflags=getattr(subprocess, "CREATE_NO_WINDOW", 0))
            run = {"profile": profile_name, "pid": process.pid, "arguments": args[1:]}
            manifest["server_runs"].append(run)
            started = time.perf_counter()
            try:
                while time.perf_counter() - started < 120:
                    if process.poll() is not None:
                        raise RuntimeError("Owner trial model server exited before readiness")
                    connection = trial.http.client.HTTPConnection("127.0.0.1", 8086, timeout=2)
                    try:
                        connection.request("GET", "/health")
                        response = connection.getresponse()
                        response.read()
                        if response.status == 200:
                            break
                    except OSError:
                        pass
                    finally:
                        connection.close()
                    time.sleep(.5)
                else:
                    raise TimeoutError("Owner trial server readiness exceeded 120 seconds")
                run["health_ready_ms"] = round((time.perf_counter() - started) * 1000, 3)
                rows = []
                with (output / f"{profile_name}-raw.jsonl").open("x", encoding="utf-8") as raw:
                    for case in cases:
                        row = trial.infer(8086, case, profile)
                        row.update(id=case["id"], text=case["text"], context=case.get("context"),
                                   expected_statuses=case["statuses"], expected_steps=case["steps"], in_reduced_scope=True)
                        completion = row["completion"] if row.get("finish_reason") == "stop" else None
                        row["rev13_counterfactual"] = trial.replay(rev13, case, completion)
                        row["rev14_counterfactual"] = trial.replay(trial.live, case, completion)
                        rows.append(row)
                        raw.write(json.dumps(row, ensure_ascii=False) + "\n")
                        raw.flush()
                summary = trial.summarize(rows)
                manifest["summaries"][profile_name] = summary
                trial.write(output / f"{profile_name}-summary.json", summary)
                print(json.dumps({"profile": profile_name, "owner_text_summary": summary}), flush=True)
            finally:
                process.terminate()
                try:
                    process.wait(timeout=10)
                except subprocess.TimeoutExpired:
                    process.kill()
                    process.wait(timeout=10)
                run.update(stopped=process.poll() is not None, exit_code=process.returncode)
                trial.write(output / "manifest-progress.json", manifest)
    stop_rows = []
    for case in fixture["stop_cases"]:
        calls = []
        def forbidden_model(text, context):
            calls.append(text)
            raise AssertionError("Stop must bypass the interpreter")
        dialog = trial.live.Conversation(forbidden_model)
        samples = []
        for _ in range(1000):
            started = time.perf_counter_ns()
            result = dialog.propose(case["text"])
            samples.append((time.perf_counter_ns() - started) / 1_000_000)
            if result["status"] != "stopped" or calls:
                raise AssertionError("Owner Stop did not bypass the model")
        samples.sort()
        stop_rows.append({"id": case["id"], "text": case["text"], "passed": True, "model_calls": len(calls),
                          "calls": len(samples), "median_ms": statistics.median(samples), "p95_ms": samples[949]})
    manifest["stop_bypass"] = stop_rows
    manifest["finished_utc"] = datetime.now(timezone.utc).isoformat()
    manifest["inputs_unchanged"] = all(trial.sha(path) == manifest["inputs"][str(path)] for path in inputs)
    manifest["outputs"] = {path.name: trial.sha(path) for path in output.iterdir() if path.is_file()}
    trial.write(output / "manifest-final.json", manifest)
    print(json.dumps({"owner_text_finished": True, "inputs_unchanged": manifest["inputs_unchanged"], "stop_bypass": stop_rows}), flush=True)


if __name__ == "__main__":
    main()
