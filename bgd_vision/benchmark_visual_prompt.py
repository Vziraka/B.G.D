"""Measure YOLOE visual prompting from the live selected-object box."""

import argparse
import json
import statistics
import time
from urllib.request import urlopen

import cv2
import numpy as np
import psutil
import torch
from ultralytics import YOLOE
from ultralytics.models.yolo.yoloe import YOLOEVPSegPredictor


def fresh_frame(base_url, after):
    with urlopen(f"{base_url}/frame?after={after}", timeout=3) as response:
        metadata = json.loads(response.headers["X-Frame-Meta"])
        frame = cv2.imdecode(np.frombuffer(response.read(), np.uint8), cv2.IMREAD_COLOR)
    if frame is None:
        raise RuntimeError("Camera JPEG could not be decoded")
    return metadata, frame


def iou(first, second):
    intersection = max(0, min(first[2], second[2]) - max(first[0], second[0])) * max(
        0, min(first[3], second[3]) - max(first[1], second[1])
    )
    first_area = max(0, first[2] - first[0]) * max(0, first[3] - first[1])
    second_area = max(0, second[2] - second[0]) * max(0, second[3] - second[1])
    union = first_area + second_area - intersection
    return intersection / union if union else 0


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", required=True)
    parser.add_argument("--imgsz", type=int, default=640)
    parser.add_argument("--iterations", type=int, default=10)
    parser.add_argument("--confidence", type=float, default=.05)
    parser.add_argument("--url", default="http://127.0.0.1:8765")
    parser.add_argument("--torch-threads", type=int, choices=(1, 2, 3, 4))
    args = parser.parse_args()
    if args.iterations < 1:
        parser.error("iterations must be positive")

    metadata, reference = fresh_frame(args.url, 0)
    reference_box = metadata.get("object_tracking", {}).get("box")
    if not reference_box:
        raise RuntimeError("Draw and retain a selected-object box before visual prompting")

    model = YOLOE(args.model)
    prompts = {"bboxes": np.array([reference_box], dtype=np.float32), "cls": np.array([0])}
    started = time.perf_counter()
    model.predict(
        reference,
        refer_image=reference,
        visual_prompts=prompts,
        predictor=YOLOEVPSegPredictor,
        imgsz=args.imgsz,
        conf=args.confidence,
        device="cpu",
        verbose=False,
    )
    prompt_ms = (time.perf_counter() - started) * 1000
    if args.torch_threads is not None:
        torch.set_num_threads(args.torch_threads)

    process = psutil.Process()
    sequence = metadata["sequence"]
    walls, confidences, overlaps, rss = [], [], [], []
    frames_with_detection = 0
    loop_started = time.perf_counter()
    for _ in range(args.iterations):
        metadata, frame = fresh_frame(args.url, sequence)
        sequence = metadata["sequence"]
        started = time.perf_counter()
        result = model.predict(
            frame, imgsz=args.imgsz, conf=args.confidence, max_det=20,
            device="cpu", verbose=False,
        )[0]
        walls.append((time.perf_counter() - started) * 1000)
        rss.append(process.memory_info().rss / 1024 / 1024)
        boxes = result.boxes.xyxy.tolist()
        if boxes:
            frames_with_detection += 1
            best = max(range(len(boxes)), key=lambda index: iou(reference_box, boxes[index]))
            overlaps.append(iou(reference_box, boxes[best]))
            confidences.append(float(result.boxes.conf[best]))

    loop_seconds = time.perf_counter() - loop_started
    print(json.dumps({
        "model": args.model,
        "image_size": args.imgsz,
        "iterations": args.iterations,
        "torch_threads": torch.get_num_threads(),
        "requested_torch_threads": args.torch_threads,
        "confidence_threshold": args.confidence,
        "reference_box": [round(value, 1) for value in reference_box],
        "prompt_ms": round(prompt_ms, 1),
        "frames_with_detection": frames_with_detection,
        "best_confidence": round(max(confidences), 3) if confidences else None,
        "iou_median": round(statistics.median(overlaps), 3) if overlaps else None,
        "iou_best": round(max(overlaps), 3) if overlaps else None,
        "wall_median_ms": round(statistics.median(walls), 1),
        "sustained_fps": round(1000 / statistics.mean(walls), 2),
        "end_to_end_fps": round(args.iterations / loop_seconds, 2),
        "loop_seconds": round(loop_seconds, 2),
        "rss_peak_mb": round(max(rss), 1),
        "images_retained": False,
    }, sort_keys=True))


if __name__ == "__main__":
    main()
