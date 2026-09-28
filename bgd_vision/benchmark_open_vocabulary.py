"""Measure an open-vocabulary model beside the live, loopback-only camera service."""

import argparse
import itertools
import json
import math
import statistics
import time
from urllib.request import urlopen

import cv2
import numpy as np
import psutil
import torch
from ultralytics import YOLOE


def fresh_frame(base_url, after):
    with urlopen(f"{base_url}/frame?after={after}", timeout=3) as response:
        metadata = json.loads(response.headers["X-Frame-Meta"])
        frame = cv2.imdecode(np.frombuffer(response.read(), np.uint8), cv2.IMREAD_COLOR)
    if frame is None:
        raise RuntimeError("Camera JPEG could not be decoded")
    return metadata["sequence"], frame


def percentile(values, fraction):
    ordered = sorted(values)
    return ordered[min(len(ordered) - 1, round((len(ordered) - 1) * fraction))]


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", required=True)
    parser.add_argument("--imgsz", type=int, required=True)
    parser.add_argument("--iterations", type=int, default=20)
    parser.add_argument("--seconds", type=float,
                        help="Run for this duration instead of a fixed iteration count")
    parser.add_argument("--url", default="http://127.0.0.1:8765")
    parser.add_argument("--classes", nargs="*")
    parser.add_argument("--prompt-profile")
    parser.add_argument("--confidence", type=float, default=.25)
    parser.add_argument("--torch-threads", type=int, choices=(1, 2, 3, 4),
                        help="CPU thread budget after Ultralytics initializes its predictor")
    parser.add_argument("--production-thread-budget", action="store_true",
                        help="Exercise the application's prediction callback instead of a manual budget")
    args = parser.parse_args()
    if args.iterations < 1:
        parser.error("iterations must be positive")
    if args.seconds is not None and (not math.isfinite(args.seconds) or args.seconds <= 0):
        parser.error("seconds must be positive and finite")
    if args.production_thread_budget and args.torch_threads is not None:
        parser.error("Choose the production budget or an explicit comparison budget")

    process = psutil.Process()
    sequence, frame = fresh_frame(args.url, 0)
    started = time.perf_counter()
    model = YOLOE(args.model)
    if args.production_thread_budget:
        from .open_vocabulary import _limit_cpu_threads
        model.add_callback("on_predict_start", _limit_cpu_threads)
    load_ms = (time.perf_counter() - started) * 1000
    prompt_ms = None
    if args.prompt_profile:
        started = time.perf_counter()
        model.load_prompt_embeddings(args.prompt_profile)
        prompt_ms = (time.perf_counter() - started) * 1000
    elif args.classes:
        started = time.perf_counter()
        model.set_classes(args.classes)
        prompt_ms = (time.perf_counter() - started) * 1000
    warm_started = time.perf_counter()
    model.predict(
        frame, imgsz=args.imgsz, conf=args.confidence, max_det=100, device="cpu", verbose=False
    )
    warmup_ms = (time.perf_counter() - warm_started) * 1000
    # Predictor initialization resets PyTorch's thread count; apply the comparison
    # budget afterward, otherwise the CLI setting silently measures the default.
    if args.torch_threads is not None:
        torch.set_num_threads(args.torch_threads)

    walls, inference, rss, labels, detection_frames = [], [], [], {}, {}
    loop_started = time.perf_counter()
    iterations = range(args.iterations) if args.seconds is None else itertools.count()
    for _ in iterations:
        sequence, frame = fresh_frame(args.url, sequence)
        started = time.perf_counter()
        result = model.predict(
            frame, imgsz=args.imgsz, conf=args.confidence, max_det=100, device="cpu", verbose=False
        )[0]
        walls.append((time.perf_counter() - started) * 1000)
        inference.append(float(result.speed["inference"]))
        rss.append(process.memory_info().rss / 1024 / 1024)
        seen = set()
        for identity, confidence in zip(result.boxes.cls, result.boxes.conf):
            label = model.names[int(identity)]
            labels[label] = max(labels.get(label, 0), round(float(confidence), 3))
            seen.add(label)
        for label in seen:
            detection_frames[label] = detection_frames.get(label, 0) + 1
        if args.seconds is not None and time.perf_counter() - loop_started >= args.seconds:
            break

    loop_seconds = time.perf_counter() - loop_started
    temperature = int(open("/sys/class/thermal/thermal_zone0/temp", encoding="ascii").read()) / 1000
    print(json.dumps({
        "model": args.model,
        "vocabulary": len(model.names),
        "classes": args.classes,
        "prompt_profile": args.prompt_profile,
        "image_size": args.imgsz,
        "confidence_threshold": args.confidence,
        "iterations": len(walls),
        "requested_duration_seconds": args.seconds,
        "torch_threads": torch.get_num_threads(),
        "requested_torch_threads": args.torch_threads,
        "production_thread_budget": args.production_thread_budget,
        "load_ms": round(load_ms, 1),
        "prompt_ms": round(prompt_ms, 1) if prompt_ms is not None else None,
        "warmup_ms": round(warmup_ms, 1),
        "wall_ms": {
            "median": round(statistics.median(walls), 1),
            "p95": round(percentile(walls, .95), 1),
            "min": round(min(walls), 1),
            "max": round(max(walls), 1),
        },
        "model_inference_ms": {
            "median": round(statistics.median(inference), 1),
            "p95": round(percentile(inference, .95), 1),
        },
        "sustained_fps": round(1000 / statistics.mean(walls), 2),
        "end_to_end_fps": round(len(walls) / loop_seconds, 2),
        "loop_seconds": round(loop_seconds, 2),
        "rss_mb": {"first": round(rss[0], 1), "peak": round(max(rss), 1)},
        "temperature_c": temperature,
        "detections": labels,
        "detection_frames": detection_frames,
        "images_retained": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
