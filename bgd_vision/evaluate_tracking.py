"""Offline CAVIAR proxy association check; not a standard MOT benchmark."""

import argparse
from collections import Counter
import json
import hashlib
import time
import xml.etree.ElementTree as ET

from .selection import TargetSelection, _iou, _similarity


def annotations(path):
    frames = {}
    for frame in ET.parse(path).getroot().findall("frame"):
        people = {}
        for obj in frame.findall("objectlist/object"):
            box = obj.find("box")
            x, y, w, h = (float(box.get(key)) for key in ("xc", "yc", "w", "h"))
            people[int(obj.get("id"))] = [x-w/2, y-h/2, x+w/2, y+h/2]
        frames[int(frame.get("number"))] = people
    return frames


def match(people, tracks):
    """Greedy one-to-one IoU>=0.5 matching after excluding GT pair overlap>=0.3."""
    ambiguous = {a for a, box in people.items() for b, other in people.items()
                 if a != b and _iou(box, other) >= 0.3}
    eligible = {a: box for a, box in people.items() if a not in ambiguous}
    pairs = sorted(((_iou(box, track["box"]), a, index)
                    for a, box in eligible.items() for index, track in enumerate(tracks)), reverse=True)
    matches, used = {}, set()
    for overlap, person, index in pairs:
        if overlap >= 0.5 and person not in matches and index not in used:
            matches[person] = tracks[index]
            used.add(index)
    return matches, len(eligible), ambiguous


def main():
    import cv2
    import numpy as np
    from pathlib import Path
    from ultralytics.trackers.byte_tracker import BYTETracker
    from ultralytics.utils import YAML, IterableSimpleNamespace
    from .appearance import AppearanceEncoder
    from .detector import load_detector
    from .tracking import PersonTracker, association_probe

    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--video", required=True)
    parser.add_argument("--xml", required=True)
    parser.add_argument("--detector", required=True)
    parser.add_argument("--appearance", required=True)
    parser.add_argument("--frames", type=int, default=400)
    parser.add_argument("--target-gt", type=int, default=0)
    parser.add_argument("--trace-start", type=int, default=-1)
    parser.add_argument("--trace-end", type=int, default=-1)
    parser.add_argument("--confidence", type=float, default=0.15)
    parser.add_argument("--max-detections", type=int, default=10)
    parser.add_argument("--output", required=True)
    args = parser.parse_args()
    source_hashes = {path.name: hashlib.sha256(path.read_bytes()).hexdigest()
                     for path in Path(__file__).parent.glob("*.py")}
    cv2.setNumThreads(1)
    probe = association_probe()
    truth = annotations(args.xml)
    detector = load_detector(args.detector)
    baseline = BYTETracker(IterableSimpleNamespace(**YAML.load(Path(__file__).with_name("bytetrack.yaml"))))
    candidate = PersonTracker(AppearanceEncoder(args.appearance))
    backend_name = type(candidate.tracker).__module__ + "." + type(candidate.tracker).__name__
    selection = TargetSelection(recovery_enabled=True)
    cap = cv2.VideoCapture(args.video)
    if not cap.isOpened():
        raise RuntimeError("Cannot decode public video")
    fps = cap.get(cv2.CAP_PROP_FPS)
    if not fps > 0:
        raise RuntimeError("Video has no valid frame rate")
    stats = {name: Counter() for name in ("bytetrack", "deepocsort_osnet")}
    previous = {name: {} for name in stats}
    timings = {name: [] for name in ("detect", *stats)}
    selected = False
    selector = Counter()
    transitions = []
    old_status = None
    overlaps = {}
    trace = []
    started = time.perf_counter()
    count = 0
    for number in range(args.frames):
        ok, frame = cap.read()
        if not ok:
            break
        people = truth.get(number, {})
        for a, box in people.items():
            for b, other in people.items():
                if a < b and _iou(box, other) >= 0.3:
                    overlaps.setdefault(f"{a},{b}", []).append(number)
        t = time.perf_counter()
        result = detector.predict(frame, imgsz=320, classes=[0], conf=args.confidence,
                                  max_det=args.max_detections, verbose=False, device="cpu")[0]
        timings["detect"].append(time.perf_counter()-t)
        t = time.perf_counter()
        rows = baseline.update(result.boxes.cpu().numpy(), frame)
        base_tracks = [{"id": int(row[4]), "box": row[:4].tolist()} for row in rows]
        timings["bytetrack"].append(time.perf_counter()-t)
        t = time.perf_counter()
        candidate_tracks = candidate.update(result, frame)
        timings["deepocsort_osnet"].append(time.perf_counter()-t)
        candidate_matches = {}
        for name, tracks in (("bytetrack", base_tracks), ("deepocsort_osnet", candidate_tracks)):
            matched, eligible, ambiguous = match(people, tracks)
            stats[name]["eligible_gt_observations"] += eligible
            stats[name]["matches"] += len(matched)
            stats[name]["missing"] += eligible-len(matched)
            for identity, track in matched.items():
                if identity in previous[name] and previous[name][identity] != track["id"]:
                    stats[name]["matched_id_changes"] += 1
                previous[name][identity] = track["id"]
            if name == "deepocsort_osnet":
                candidate_matches = matched
        now = number / fps  # evaluate policy against video time, not slow offline processing
        selection.update(candidate_tracks, now)
        if not selected and args.target_gt in candidate_matches:
            selected = selection.select(candidate_matches[args.target_gt]["id"], now)
            if selected:
                selector["selected_frame"] = number
        if selected:
            status = selection.snapshot(now)["status"]
            selector[status] += 1
            if status != old_status:
                transitions.append({"frame": number, "status": status, "reason": selection.reason})
                if old_status == "Temporarily hidden" and status == "Tracking":
                    selector["recoveries"] += 1
                old_status = status
            _, _, ambiguous = match(people, candidate_tracks)
            if args.target_gt in people and args.target_gt not in ambiguous:
                selector["eligible_target_frames"] += 1
                if status == "Tracking":
                    tracked_gt = next((identity for identity, track in candidate_matches.items()
                                       if track["id"] == selection.selected_id), None)
                    if tracked_gt == args.target_gt:
                        selector["correct_tracking_frames"] += 1
                    elif tracked_gt is not None:
                        selector["wrong_tracking_frames"] += 1
                    else:
                        selector["unmatched_tracking_frames"] += 1
        if args.trace_start <= number <= args.trace_end:
            detections = [{"id": index, "box": box} for index, box in enumerate(result.boxes.xyxy.tolist())]
            detector_matches, _, _ = match(people, detections)
            ranked = sorted(candidate_tracks, key=lambda track: _similarity(
                selection.reference, track.get("appearance")), reverse=True)
            top = ranked[0] if ranked else None
            top_gt = max(people, key=lambda identity: _iou(people[identity], top["box"])) if top and people else None
            trace.append({"frame": number, "detection_count": len(detections),
                          "detector_gt_matches": sorted(detector_matches),
                          "candidate_gt_matches": {identity: track["id"] for identity, track in candidate_matches.items()},
                          "candidate_count": len(candidate_tracks), "status": selection.status,
                          "diagnostics": dict(selection.diagnostics), "top_candidate_gt": top_gt,
                          "top_candidate_gt_iou": _iou(people[top_gt], top["box"]) if top_gt is not None else None})
        count += 1
        if count % 100 == 0:
            print(f"Processed {count} public frames", flush=True)
    cap.release()
    elapsed = time.perf_counter()-started
    report = {"qualification": "Proxy IoU association on one public clip, not MOT-standard or live acceptance",
              "frames": count, "video_fps": fps, "wall_seconds": elapsed,
              "target_gt": args.target_gt,
              "candidate_backend": backend_name, "source_hashes_before_run": source_hashes,
              "detector_settings": {"imgsz": 320, "conf": args.confidence, "max_det": args.max_detections},
              "combined_offline_fps": count/elapsed, "association_probe": probe,
              "matching": "Greedy one-to-one IoU>=0.5; GT pair overlaps>=0.3 excluded; ID changes persist across gaps",
              "overlap_frames": overlaps, "association": stats,
              "selector": selector, "selector_transitions": transitions,
              "public_frame_trace": trace,
              "milliseconds": {name: {"median": float(np.median(values)*1000),
                                        "p95": float(np.percentile(values, 95)*1000)}
                               for name, values in timings.items()}}
    denominator = selector["eligible_target_frames"]
    report["selector_exercised"] = selected
    report["selector_correct_coverage"] = selector["correct_tracking_frames"]/denominator if denominator else None
    report["selector_wrong_fraction"] = selector["wrong_tracking_frames"]/denominator if denominator else None
    Path(args.output).write_text(json.dumps(report, indent=2))
    print(json.dumps(report, indent=2))


if __name__ == "__main__":
    main()
