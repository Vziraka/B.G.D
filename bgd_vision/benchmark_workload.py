"""Run a bounded workload and retain only numeric camera-service health evidence.

Example on the Pi: python -m bgd_vision.benchmark_workload --output run.json --
python -m bgd_vision.benchmark_open_vocabulary --model ... --imgsz 320
"""

import argparse
import json
import math
from pathlib import Path
import statistics
import subprocess
import tempfile
import time
from urllib.request import urlopen


LIMITS = {"minimum_fps": 15, "maximum_delay_ms": 300, "maximum_temperature_c": 80}


def sample_status(status):
    """Never persist camera frames, boxes, identity data, or command transcripts."""
    hardware, client = status.get("hardware", {}), status.get("client", {})
    sample = {key: status.get(key) for key in ("capture_fps", "vision_fps", "inference_ms")}
    sample.update({key: hardware.get(key) for key in
                   ("temperature_c", "memory_mb", "voltage_v", "throttled")})
    visible = client.get("available", True) and client.get("visible")
    sample.update(display_fps=client.get("display_fps") if visible else None,
                  browser_delay_p95_ms=client.get("latency_upper_p95_ms") if visible else None,
                  application_error=bool(status.get("error")))
    return sample


def assess(samples, returncode):
    failures, unavailable, metrics = [], [], {}
    if returncode != 0:
        failures.append("workload_failed")
    for key in ("capture_fps", "vision_fps", "display_fps", "browser_delay_p95_ms",
                "temperature_c", "memory_mb", "voltage_v", "inference_ms"):
        values = [s[key] for s in samples if type(s.get(key)) in (int, float) and math.isfinite(s[key])]
        if not values or len(values) != len(samples):
            unavailable.append(key)
        if values:
            metrics[key] = {"minimum": min(values), "maximum": max(values),
                            "mean": round(statistics.mean(values), 2), "samples": len(values)}
            if key.endswith("_fps") and min(values) < LIMITS["minimum_fps"]:
                failures.append(key + "_below_floor")
            if key == "browser_delay_p95_ms" and max(values) > LIMITS["maximum_delay_ms"]:
                failures.append("browser_delay_above_limit")
            if key == "temperature_c" and max(values) >= LIMITS["maximum_temperature_c"]:
                failures.append("temperature_above_limit")
    if any(s.get("application_error") or s.get("sample_error") for s in samples):
        failures.append("service_error")
    if any(s.get("throttled") not in (None, "0x0") for s in samples):
        failures.append("power_or_throttle_flag")
    if not samples or any(s.get("throttled") is None for s in samples):
        unavailable.append("throttled")
    return {"verdict": "fail" if failures else "incomplete" if unavailable else "pass",
            "failures": failures, "unavailable": unavailable, "metrics": metrics,
            "memory_note": "Range only; inspect time series for growth. Not an automatic memory qualification."}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--url", default="http://127.0.0.1:8765")
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--interval", type=float, default=1)
    parser.add_argument("--timeout", type=float, default=900)
    parser.add_argument("command", nargs=argparse.REMAINDER)
    args = parser.parse_args()
    command = args.command[1:] if args.command[:1] == ["--"] else args.command
    if not command or not math.isfinite(args.interval) or args.interval < .2 or not math.isfinite(args.timeout) or args.timeout <= 0:
        parser.error("Supply a command, interval >=0.2 seconds and positive finite timeout")
    samples, started, timed_out = [], time.monotonic(), False
    started_utc = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
    # Child output is kept separate from privacy-filtered service telemetry.
    with tempfile.TemporaryFile(mode="w+", encoding="utf-8") as output:
        process = subprocess.Popen(command, stdout=output, stderr=subprocess.STDOUT, text=True)
        try:
            while process.poll() is None:
                sample = {"elapsed_s": round(time.monotonic()-started, 3)}
                try:
                    with urlopen(args.url + "/status", timeout=3) as response:
                        sample.update(sample_status(json.load(response)))
                except Exception as error:
                    sample["sample_error"] = type(error).__name__
                samples.append(sample)
                if time.monotonic()-started >= args.timeout:
                    timed_out = True
                    process.terminate()
                    break
                time.sleep(args.interval)
        finally:
            if process.poll() is None:
                process.terminate()
                try:
                    process.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    process.kill()
            process.wait()
        output.seek(0)
        # Only retain the benchmark JSON, not arbitrary logs or error contents.
        benchmark = None
        for line in output:
            try:
                value = json.loads(line)
                if isinstance(value, dict) and value.get("images_retained") is False:
                    benchmark = value
            except ValueError:
                pass
    result = {"criteria": LIMITS, "elapsed_s": round(time.monotonic()-started, 2),
              "started_utc": started_utc,
              "finished_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
              "sample_interval_s": args.interval, "workload_returncode": process.returncode,
              "timed_out": timed_out, "benchmark": benchmark, "samples": samples,
              "assessment": assess(samples, -1 if timed_out else process.returncode), "images_retained": False}
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({"output": str(args.output), "assessment": result["assessment"],
                      "benchmark": benchmark}, sort_keys=True))
    return {"pass": 0, "fail": 1, "incomplete": 2}[result["assessment"]["verdict"]]


if __name__ == "__main__":
    raise SystemExit(main())
