"""One camera, latest-frame inference, and a loopback-only browser interface."""

import argparse
from collections import deque
import copy
import json
import math
import os
from pathlib import Path
import re
import secrets
import signal
import socket
from statistics import median
import subprocess
import threading
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import parse_qs, urlsplit

from .commands import interpret_command
from .conversation import (Conversation, LocalSemanticInterpreter, CONFIRM_COMMANDS, clean_text,
                           is_described_human_target, is_stop_command, MANUAL_PERSON_MESSAGE)
from .enrollment import GuidedEnrollment
from .generic_object import GenericObjectTracker, VitTracker
from .selection import TargetSelection


OBJECT_ALIASES = {
    "phone": "cell phone", "mobile phone": "cell phone", "smartphone": "cell phone",
    "ball": "sports ball", "bike": "bicycle", "bikes": "bicycle", "bicycles": "bicycle",
}
REACQUIRE_INTERVAL = 0.2
VISUAL_REDETECT_INTERVAL = 1.0
KNOWN_OBJECT_CONFIDENCE = 0.3


class Application:
    def __init__(self, args):
        self.args = args
        self.condition = threading.Condition()
        self.stop = threading.Event()
        self.token = secrets.token_urlsafe(32)
        self.selection = TargetSelection(recovery_enabled=True, recovery_window=3.0, search_window=10.0)
        self.enrollment = GuidedEnrollment()
        self.face_encoder = None
        self.face_lock = threading.Lock()
        self.liveness_scorer = None
        self.liveness_lock = threading.Lock()
        self.speech_recognizer = None
        self.speech_lock = threading.Lock()
        # One owner-attended desk session; this is not aircraft authentication.
        language_port = getattr(args, "language_model_port", None)
        self.conversation = Conversation(LocalSemanticInterpreter(language_port) if language_port else None)
        self.mission_epoch = 0
        self.detector = None
        self.detector_names = {}
        self.detector_lock = threading.Lock()
        self.open_vocabulary = None
        self.open_vocabulary_lock = threading.Lock()
        self.center_prompt_until = 0.0
        object_tracker_model = getattr(args, "object_tracker_model", None)
        tracker_factory = (lambda: VitTracker(object_tracker_model)) if object_tracker_model else None
        self.generic_object = GenericObjectTracker(tracker_factory)
        self.generic_object_lock = threading.Lock()
        self.object_generation = 0
        self.frame = None
        self.jpeg = None
        self.sequence = 0
        self.captured_at = 0.0
        self.vision_at = 0.0
        self.tracks = []
        self.capture_times = deque(maxlen=120)
        self.vision_times = deque(maxlen=60)
        self.inference_ms = 0.0
        self.error = None
        self.hardware = {}
        self.client = {}
        self.client_at = 0.0
        self.range_samples = []
        self.face_range_log = args.log.with_name("face-range.jsonl")
        self.face_range_log_lock = threading.Lock()
        self.object_range_log = args.log.with_name("object-range.jsonl")
        self.object_range_log_lock = threading.Lock()
        self.object_range_calibration = None
        self.started = time.monotonic()
        self.mission = self._mission_result("idle", "No simulated mission is active.")

    @staticmethod
    def _mission_result(status, message, **details):
        return {
            "status": status,
            "message": message,
            "actuator_output": False,
            "authority": "SIMULATION_ONLY",
            **details,
        }

    @staticmethod
    def rate(times):
        return round((len(times) - 1) / (times[-1] - times[0]), 1) if len(times) > 1 and times[-1] > times[0] and time.monotonic()-times[-1] < 1 else 0

    def snapshot(self):
        # Caller holds condition, including all selection-state transitions.
        now = time.monotonic()
        target = self.selection.snapshot(now)
        fresh = now - self.vision_at <= 0.75 and not self.error
        with self.generic_object_lock:
            object_tracking = self.generic_object.snapshot(now)
        return dict(target, sequence=self.sequence, tracks=self.tracks if fresh else [],
                    object_tracking=object_tracking,
                    mission=self.mission,
                    language={"mode": "local_model" if self.conversation.interpreter else "limited_commands",
                              "experimental": bool(self.conversation.interpreter), "online_enabled": False},
                    enrollment=self.enrollment.snapshot(),
                    recovery_diagnostics=dict(self.selection.diagnostics),
                    capture_age_ms=round((now - self.captured_at) * 1000, 1) if self.captured_at else None,
                    vision_age_ms=round((now - self.vision_at) * 1000, 1) if self.vision_at else None,
                    capture_fps=self.rate(self.capture_times), vision_fps=self.rate(self.vision_times),
                    inference_ms=round(self.inference_ms, 1), error=self.error,
                    hardware=self.hardware, client=self.client if now-self.client_at < 10 else {"visible": False, "available": False}, uptime_s=round(now-self.started),
                    model=Path(self.args.model).name, image_size=self.args.imgsz)

    def _conversation_status(self, interpretation):
        """Answer authenticated status questions with current camera and tracker state."""
        with self.condition:
            now = time.monotonic()
            capture_age = now-self.captured_at if self.captured_at else None
            vision_age = now-self.vision_at if self.vision_at else None
            camera_fresh = bool(self.frame is not None and capture_age is not None
                                and vision_age is not None and capture_age <= .75
                                and vision_age <= .75 and not self.error)
            camera_error = self.error
            camera_freshness = "fresh" if camera_fresh else (
                "stale" if self.frame is not None or self.captured_at or self.vision_at else "unavailable")
            person = self.selection.snapshot(now)
            person_tracking = {**person,
                "freshness": "fresh" if camera_fresh else camera_freshness,
                "visible_count": len(self.tracks) if camera_fresh else None}
            with self.generic_object_lock:
                object_tracking = self.generic_object.snapshot(now)
            box_age = object_tracking.get("box_age_ms")
            if object_tracking.get("status") == "reacquiring":
                object_freshness = "searching"
            elif object_tracking.get("status") == "tracking":
                object_freshness = ("fresh" if camera_fresh and box_age is not None and box_age <= 750
                                    else "stale")
            elif object_tracking.get("status") == "lost":
                object_freshness = "lost"
            else:
                object_freshness = "not_tracking"
            box_trusted = object_freshness == "fresh"
            object_tracking["freshness"] = object_freshness
            object_tracking["box_trusted"] = box_trusted
            if not box_trusted:
                object_tracking["box"] = None
            last_mission = copy.deepcopy(self.mission)
            pending = copy.deepcopy(interpretation.get("pending_proposal"))

        person_label = person_tracking["status"]
        object_label = object_tracking["status"]
        person_reason = person_tracking.get("reason") or "no person is selected"
        object_reason = object_tracking.get("reason") or "no object is selected"
        object_trust = "; no target box is trusted" if object_label == "reacquiring" else ""
        message = (f"Camera view is {camera_freshness}. Person tracking is {person_label}. "
                   f"Person tracker detail: {person_reason}. "
                   f"Object tracking is {object_label} ({object_tracking['freshness']}{object_trust}). "
                   f"Object tracker detail: {object_reason}. "
                   f"Last mission: {last_mission['status']} — {last_mission['message']}")
        if pending:
            message += " An exact proposal is still awaiting your confirmation."
        result = self._mission_result("status", message, command="status",
            interpretation=copy.deepcopy(interpretation.get("interpretation")),
            camera={"freshness": camera_freshness,
                    "capture_age_ms": round(max(0, capture_age)*1000, 1) if capture_age is not None else None,
                    "vision_age_ms": round(max(0, vision_age)*1000, 1) if vision_age is not None else None,
                    "error": camera_error},
            person_tracking=person_tracking, object_tracking=object_tracking,
            last_mission=last_mission)
        if pending:
            result["pending_proposal"] = pending
        return result

    def fail(self, error):
        with self.condition:
            self.error = str(error)
            self.selection.update([], time.monotonic())
            self.condition.notify_all()

    def capture(self):
        import cv2
        from picamera2 import Picamera2
        camera = None
        try:
            cv2.setNumThreads(1)
            camera = Picamera2()
            camera.configure(camera.create_video_configuration(
                main={"size": (960, 540), "format": "RGB888"},
                # The auto-selected 1536x864 sensor mode crops the IMX708 sensor.
                sensor={"output_size": (2304, 1296), "bit_depth": 10},
                controls={"FrameRate": 30}, buffer_count=4, queue=False))
            camera.start()
            while not self.stop.is_set():
                request = camera.capture_request()
                try:
                    frame = request.make_array("main")
                    metadata = request.get_metadata()
                finally:
                    request.release()
                # libcamera SensorTimestamp uses CLOCK_BOOTTIME (first-row exposure).
                # Translate its age to this process's monotonic time, not wall clocks.
                sensor = metadata.get("SensorTimestamp")
                if sensor is None:
                    raise RuntimeError("Camera did not provide SensorTimestamp")
                age = time.clock_gettime(time.CLOCK_BOOTTIME) - sensor / 1e9
                if not 0 <= age < 5:
                    raise RuntimeError("Camera timestamp is outside the expected clock range")
                captured = time.monotonic() - age
                ok, encoded = cv2.imencode(".jpg", frame, [cv2.IMWRITE_JPEG_QUALITY, 75])
                if not ok:
                    raise RuntimeError("Camera JPEG encoding failed")
                with self.condition:
                    self.frame = frame
                    self.jpeg = encoded.tobytes()
                    self.captured_at = captured
                    self.sequence += 1
                    self.capture_times.append(time.monotonic())
                    self.condition.notify_all()
        except Exception as exc:
            self.fail(f"Camera: {exc}")
        finally:
            if camera is not None:
                camera.stop()
                camera.close()

    def infer(self):
        try:
            from .appearance import AppearanceEncoder
            from .detector import load_detector
            from .tracking import PersonTracker
            model = load_detector(self.args.model, self.args.imgsz)
            with self.condition:
                self.detector = model
                self.detector_names = dict(model.names)
            appearance = AppearanceEncoder(self.args.appearance_model)
            tracker = PersonTracker(appearance)
            last = 0
            while not self.stop.is_set():
                with self.condition:
                    self.condition.wait_for(lambda: self.sequence != last or self.stop.is_set(), timeout=1)
                    if self.stop.is_set():
                        return
                    if self.frame is None or self.sequence == last:
                        continue
                    last = self.sequence
                    frame, captured = self.frame, self.captured_at
                start = time.monotonic()
                with self.detector_lock:
                    result = model.predict(frame, imgsz=self.args.imgsz, classes=[0], conf=0.15,
                                           device="cpu", max_det=10, verbose=False)[0]
                tracks = tracker.update(result, frame)
                with self.condition:
                    self.inference_ms = (time.monotonic() - start) * 1000
                    self.vision_at = captured
                    # Appearance stays in RAM in the selector, never in HTTP or logs.
                    self.tracks = [{key: t[key] for key in ("id", "box", "confidence")} for t in tracks]
                    # Freshness is measured from camera exposure, not inference completion.
                    self.selection.update(tracks, captured)
                    self.vision_times.append(time.monotonic())
        except Exception as exc:
            self.fail(f"Vision: {exc}")

    def enroll(self):
        """Analyze a bounded latest-frame stream only while guided enrollment is active."""
        last = 0
        while not self.stop.is_set():
            with self.condition:
                self.condition.wait_for(
                    lambda: self.stop.is_set() or (
                        self.enrollment.active and self.frame is not None and self.sequence != last
                    ), timeout=1)
                if self.stop.is_set():
                    return
                if not self.enrollment.active or self.frame is None or self.sequence == last:
                    continue
                last = self.sequence
                frame = self.frame
            try:
                with self.face_lock:
                    if self.face_encoder is None:
                        from .face import FaceEncoder
                        self.face_encoder = FaceEncoder(
                            self.args.face_detector_model, self.args.face_recognizer_model
                        )
                    observation = self.face_encoder.observe(frame)
                with self.condition:
                    self.enrollment.update(observation)
                    self.condition.notify_all()
            except Exception as exc:
                with self.condition:
                    self.enrollment.fail(f"Face enrollment: {exc}")
                    self.condition.notify_all()
            # Face guidance is intentionally low-rate so the working tracker keeps priority.
            self.stop.wait(0.30)

    def select_generic_object(self, box):
        self.object_range_calibration = None
        self.conversation.cancel()
        with self.condition:
            if not self.captured_at or time.monotonic()-self.captured_at > 0.75 or self.error or self.frame is None:
                raise RuntimeError("A fresh camera frame is required before selecting an object")
            frame = self.frame.copy()
            # Manual selection supersedes any slower confirmed target request.
            self.mission_epoch += 1
            request_epoch = self.mission_epoch
            with self.generic_object_lock:
                self.object_generation += 1
                request_generation = self.object_generation
                candidate = copy.copy(self.generic_object)
        # Tracker creation and detector inference can be slow. Build a private
        # candidate so Clear and Stop never wait for either operation.
        selected = candidate.select(frame, box, time.monotonic())
        matches = [detection for detection in self.detect_categories(frame)
                   if self.overlap_smaller(selected["box"], detection["box"]) >= .5]
        if len(matches) == 1:
            match = matches[0]
            candidate.associate_category(match["label"], match["class_id"])
        else:
            candidate.enable_visual_recovery()
        with self.condition:
            if self.mission_epoch != request_epoch:
                return self._superseded_object_selection()
            with self.generic_object_lock:
                if self.object_generation != request_generation:
                    return self._superseded_object_selection()
                self.generic_object = candidate
                return candidate.snapshot(time.monotonic())

    @staticmethod
    def _superseded_object_selection():
        return {
            "status": "superseded", "box": None, "label": "Selected object",
            "reason": "A newer selection, Clear, or Stop cancelled this selection.",
        }

    def clear_generic_object(self):
        self.object_range_calibration = None
        self.conversation.cancel()
        with self.condition:
            # Clear invalidates both manual selection and confirmed mission work.
            self.mission_epoch += 1
            with self.generic_object_lock:
                self.generic_object.clear()
                self.object_generation += 1
                return self.generic_object.snapshot(time.monotonic())

    def track_generic_object(self):
        """Update the visual tracker and periodically correct a known category."""
        last_sequence = 0
        next_detection_at = 0.0
        while not self.stop.is_set():
            with self.condition:
                self.condition.wait_for(
                    lambda: self.stop.is_set() or self.sequence != last_sequence, timeout=1
                )
                if self.stop.is_set():
                    return
                if self.frame is None or self.sequence == last_sequence:
                    continue
                last_sequence = self.sequence
                now = time.monotonic()
                frame = self.frame.copy()
            detection_request = None
            with self.generic_object_lock:
                state = self.generic_object.snapshot(now)
                if state["status"] == "tracking":
                    try:
                        state = self.generic_object.update(frame, now)
                    except Exception:
                        state = self.generic_object.fail(
                            "The object tracker stopped unexpectedly. Select the object again."
                        )
                if (state["status"] in {"tracking", "reacquiring"}
                        and self.generic_object.class_id is not None and now >= next_detection_at):
                    detection_request = (state["status"], self.generic_object.class_id,
                                         self.generic_object.category, self.generic_object,
                                         self.object_generation)
                    next_detection_at = now + REACQUIRE_INTERVAL
            if detection_request:
                mode, class_id, category, requested_tracker, target_generation = detection_request
                detections = self.detect_objects(
                    frame, class_id, category,
                    confidence=KNOWN_OBJECT_CONFIDENCE, max_det=3,
                )
                with self.generic_object_lock:
                    if self.generic_object is not requested_tracker or self.object_generation != target_generation:
                        continue
                    if mode == "tracking":
                        self.generic_object.correct(frame, detections, now)
                    else:
                        self.generic_object.reacquire(frame, detections, now)
            with self.condition:
                self.condition.notify_all()

    def redetect_visual_object(self):
        """Run slower YOLOE visual re-detection without starving full-rate ViTTrack updates."""
        next_detection_at = 0.0
        last_prompt_generation = None
        while not self.stop.wait(.1):
            now = time.monotonic()
            with self.generic_object_lock:
                state = self.generic_object.snapshot(now)
                eligible = (self.generic_object.visual_recovery
                            and self.generic_object.class_id is None
                            and state["status"] in {"tracking", "reacquiring"})
                if not eligible or now < next_detection_at:
                    continue
                version, views = self.generic_object.visual_memory()
                mode = state["status"]
                requested_tracker = self.generic_object
                target_generation = self.object_generation
            with self.condition:
                if (self.frame is None or not self.captured_at
                        or now-self.captured_at > .75 or self.error):
                    continue
                frame = self.frame.copy()
                frame_captured_at = self.captured_at
            next_detection_at = now + (.6 if mode == "reacquiring" else VISUAL_REDETECT_INTERVAL)
            try:
                detections = self.detect_visual_target(
                    frame, views, (target_generation, version),
                    refresh=mode == "reacquiring" or last_prompt_generation != target_generation
                )
                last_prompt_generation = target_generation
                detections = [candidate for candidate in detections
                              if candidate.get("confidence", 0) >= KNOWN_OBJECT_CONFIDENCE]
                commit_at = time.monotonic()
                if commit_at-frame_captured_at > .75:
                    continue
                with self.generic_object_lock:
                    if self.generic_object is not requested_tracker or self.object_generation != target_generation:
                        continue
                    # Enforce the absolute tracker/reacquisition deadlines at
                    # commit time, even though the accepted box is stamped with
                    # the camera exposure time that produced it.
                    self.generic_object.snapshot(commit_at)
                    if mode == "tracking":
                        self.generic_object.correct(frame, detections, frame_captured_at)
                    else:
                        self.generic_object.reacquire(frame, detections, frame_captured_at)
            except Exception as exc:
                with self.generic_object_lock:
                    if (self.generic_object is requested_tracker and self.object_generation == target_generation
                            and self.generic_object.status in {"tracking", "reacquiring"}):
                        self.generic_object.reason = f"Visual re-detection is temporarily unavailable: {exc}"
            with self.condition:
                self.condition.notify_all()

    @staticmethod
    def overlap_smaller(first, second):
        left, top = max(first[0], second[0]), max(first[1], second[1])
        right, bottom = min(first[2], second[2]), min(first[3], second[3])
        intersection = max(0, right-left) * max(0, bottom-top)
        first_area = max(0, first[2]-first[0]) * max(0, first[3]-first[1])
        second_area = max(0, second[2]-second[0]) * max(0, second[3]-second[1])
        return intersection/min(first_area, second_area) if min(first_area, second_area) else 0

    def detect_objects(self, frame, class_id, label, confidence=.25, max_det=10):
        with self.condition:
            detector = self.detector
        if detector is None:
            return []
        with self.detector_lock:
            result = detector.predict(frame, imgsz=self.args.imgsz, classes=[class_id], conf=confidence,
                                      device="cpu", max_det=max_det, verbose=False)[0]
        return [
            {"label": label, "confidence": round(float(score), 3),
             "box": [round(float(coordinate), 1) for coordinate in box]}
            for score, box in zip(result.boxes.conf, result.boxes.xyxy)
        ]

    def detect_categories(self, frame):
        """Return confident non-person categories for one selected-object frame."""
        with self.condition:
            detector = self.detector
            names = dict(self.detector_names)
        if detector is None:
            return []
        with self.detector_lock:
            result = detector.predict(
                frame, imgsz=self.args.imgsz, conf=KNOWN_OBJECT_CONFIDENCE,
                device="cpu", max_det=20, verbose=False,
            )[0]
        detections = []
        for identity, score, box in zip(result.boxes.cls, result.boxes.conf, result.boxes.xyxy):
            class_id = int(identity)
            label = names.get(class_id)
            if label and label != "person":
                detections.append({
                    "class_id": class_id,
                    "label": label,
                    "confidence": round(float(score), 3),
                    "box": [round(float(coordinate), 1) for coordinate in box],
                })
        return detections

    def check_face(self):
        """Evaluate one fresh frame against temporary enrollment without granting access."""
        with self.condition:
            if not self.enrollment.complete:
                raise ValueError("Complete guided enrollment before checking a face")
            if self.frame is None or time.monotonic() - self.captured_at > 1:
                raise ValueError("Waiting for a fresh camera frame")
            frame = self.frame
        with self.face_lock:
            observation = self.face_encoder.observe(frame)
            if observation.get("face_count") != 1:
                raise ValueError("Exactly one clear face is required")
            with self.condition:
                return self.enrollment.evaluate(
                    observation["feature"], self.face_encoder.compare
                )

    def estimate_face_range(self):
        """Estimate face distance and retain only a privacy-safe numeric observation."""
        with self.condition:
            if not self.enrollment.complete:
                raise ValueError("Complete temporary face enrollment before starting the range guide")
            if self.frame is None or not self.captured_at or time.monotonic()-self.captured_at > .75:
                raise RuntimeError("A fresh camera frame is required")
            frame = self.frame
        with self.face_lock:
            observation = self.face_encoder.observe(frame)
            if observation.get("face_count") != 1:
                return self._record_face_range({"quality": "poor", "message": "Show exactly one clear face", "face_count": observation.get("face_count", 0)})
            match = self.enrollment.evaluate(observation["feature"], self.face_encoder.compare)
        height, width = frame.shape[:2]
        box = observation["box"]
        face_width = box[2]-box[0]
        face_height = box[3]-box[1]
        # Camera Module 3 standard is approximately 66° horizontal; 145 mm is an adult-face estimate.
        focal_px = width/(2*math.tan(math.radians(66/2)))
        distance = focal_px*.145/face_width
        confidence = float(observation["confidence"])
        if match["passed"] and confidence >= .85 and face_height >= 50:
            quality, message = "good", "Reliable face match"
        elif match["minimum"] >= match["threshold"]*.9 and confidence >= .65 and face_height >= 35:
            quality, message = "marginal", "Marginal—move closer or face the camera"
        else:
            quality, message = "poor", "Face is not reliable at this view"
        return self._record_face_range({
            "quality": quality, "message": message,
            "estimated_distance_m": round(distance, 1),
            "box": [round(float(value), 1) for value in box],
            "width_px": round(face_width), "height_px": round(face_height),
            "confidence": round(confidence, 3), "match_minimum": match["minimum"],
            "match_threshold": match["threshold"], "passed": match["passed"],
            "estimate_basis": "145 mm assumed face width; 66 degree horizontal field of view",
        })

    def _record_face_range(self, result):
        allowed = ("quality", "message", "face_count", "estimated_distance_m",
                   "width_px", "height_px", "confidence", "match_minimum",
                   "match_threshold", "passed", "estimate_basis")
        sample = {key: result[key] for key in allowed if key in result}
        self._append_range_log(self.face_range_log, self.face_range_log_lock, sample)
        return result

    @staticmethod
    def _append_range_log(path, lock, sample):
        sample = dict(sample, utc=time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()))
        path.parent.mkdir(parents=True, exist_ok=True)
        with lock, path.open("a", encoding="utf-8") as log:
            log.write(json.dumps(sample) + "\n")

    def calibrate_object_range(self):
        """Calibrate a tracked object's apparent size beside one reliable enrolled face."""
        face = self.estimate_face_range()
        if face["quality"] != "good":
            raise ValueError("Show one reliable enrolled face with the object beside it")
        now = time.monotonic()
        with self.generic_object_lock:
            state = self.generic_object.snapshot(now)
            if state["status"] != "tracking" or not state.get("box"):
                raise ValueError("Select and track one object before calibration")
            x1, y1, x2, y2 = state["box"]
            width, height = x2-x1, y2-y1
            self.generic_object.max_duration = max(self.generic_object.max_duration, 120)
            self.generic_object.started_at = now
            session = self.generic_object.started_at
        calibration = {
            "session": session, "distance_m": face["estimated_distance_m"],
            "scale_px": math.sqrt(width*height), "label": state["label"],
        }
        self.object_range_calibration = calibration
        result = {
            "event": "calibration", "quality": "good",
            "message": "Calibrated beside the enrolled face; keep the object facing the camera",
            "estimated_distance_m": calibration["distance_m"],
            "width_px": width, "height_px": height, "label": state["label"],
            "estimate_basis": "face-range calibration plus inverse object pixel scale",
        }
        self._record_object_range(result)
        return result

    def estimate_object_range(self):
        calibration = self.object_range_calibration
        if not calibration:
            raise ValueError("Calibrate the selected object beside the enrolled face first")
        now = time.monotonic()
        with self.generic_object_lock:
            state = self.generic_object.snapshot(now)
            session = self.generic_object.started_at
        result = {"event": "sample", "quality": "poor", "message": state["reason"],
                  "tracking_status": state["status"], "label": state["label"]}
        if session != calibration["session"]:
            result["message"] = "The selected object changed; calibrate again"
        elif state["status"] == "tracking" and state.get("box"):
            x1, y1, x2, y2 = state["box"]
            width, height = x2-x1, y2-y1
            scale = math.sqrt(width*height)
            result.update(
                quality="good", message="Object tracking is reliable at this view",
                estimated_distance_m=round(calibration["distance_m"]*calibration["scale_px"]/scale, 1),
                width_px=width, height_px=height, score=state.get("score"),
                estimate_basis="face-range calibration plus inverse object pixel scale",
            )
        elif state["status"] == "reacquiring":
            result.update(quality="marginal", message="Searching; no object box is trusted")
        self._record_object_range(result)
        return result

    def _record_object_range(self, result):
        allowed = ("event", "quality", "message", "tracking_status", "label",
                   "estimated_distance_m", "width_px", "height_px", "score",
                   "estimate_basis")
        self._append_range_log(
            self.object_range_log, self.object_range_log_lock,
            {key: result[key] for key in allowed if key in result},
        )

    def measure_range(self, target, distance_m):
        """Record one user-positioned range sample without retaining imagery or features."""
        if target not in {"face", "object"}:
            raise ValueError("Range target must be face or object")
        if type(distance_m) not in (int, float) or not math.isfinite(distance_m) or not .1 <= distance_m <= 100:
            raise ValueError("Distance must be between 0.1 and 100 metres")
        with self.condition:
            if self.frame is None or not self.captured_at or time.monotonic()-self.captured_at > .75:
                raise RuntimeError("A fresh camera frame is required")
            frame = self.frame
            performance = {
                "capture_fps": self.rate(self.capture_times),
                "vision_fps": self.rate(self.vision_times),
                "inference_ms": round(self.inference_ms, 1),
                "display_fps": self.client.get("display_fps") if time.monotonic()-self.client_at < 10 else None,
                "latency_p95_ms": self.client.get("latency_upper_p95_ms") if time.monotonic()-self.client_at < 10 else None,
                **self.hardware,
            }
        if target == "face":
            if not self.enrollment.complete:
                raise ValueError("Complete temporary face enrollment before measuring face range")
            with self.face_lock:
                observation = self.face_encoder.observe(frame)
                result = {"face_count": observation.get("face_count", 0), "passed": False}
                if observation.get("face_count") == 1:
                    match = self.enrollment.evaluate(observation["feature"], self.face_encoder.compare)
                    height, width = frame.shape[:2]
                    box = observation["box"]
                    result.update(
                        confidence=round(observation["confidence"], 3),
                        width_px=round(box[2]-box[0]), height_px=round(box[3]-box[1]),
                        width_ratio=round((box[2]-box[0])/width, 3),
                        height_ratio=round((box[3]-box[1])/height, 3),
                        match_minimum=match["minimum"], passed=match["passed"],
                    )
        else:
            with self.generic_object_lock:
                state = self.generic_object.snapshot(time.monotonic())
            result = {"tracking_status": state["status"], "passed": False,
                      "memory_views": state.get("memory_views", 0)}
            if state["status"] == "tracking" and state.get("box"):
                height, width = frame.shape[:2]
                box = state["box"]
                result.update(
                    width_px=box[2]-box[0], height_px=box[3]-box[1],
                    width_ratio=round((box[2]-box[0])/width, 3),
                    height_ratio=round((box[3]-box[1])/height, 3), passed=True,
                )
        sample = {"target": target, "distance_m": round(float(distance_m), 2),
                  **result, "performance": performance}
        with self.condition:
            self.range_samples = (self.range_samples + [sample])[-20:]
        return sample

    def check_liveness(self):
        """Score five fresh frames without persisting images or granting access."""
        with self.condition:
            if not self.enrollment.complete:
                raise ValueError("Complete guided enrollment before checking liveness")
        with self.liveness_lock:
            if self.liveness_scorer is None:
                from .liveness import MiniFasLiveness
                self.liveness_scorer = MiniFasLiveness(
                    self.args.liveness_source, self.args.liveness_model_dir
                )
            results, last = [], -1
            for _ in range(5):
                with self.condition:
                    self.condition.wait_for(
                        lambda: self.sequence > last or self.error or self.stop.is_set(), timeout=2
                    )
                    if self.error or self.stop.is_set() or self.frame is None or self.sequence <= last:
                        raise ValueError(self.error or "Waiting for a fresh camera frame")
                    last, frame = self.sequence, self.frame
                with self.face_lock:
                    if self.face_encoder is None:
                        from .face import FaceEncoder
                        self.face_encoder = FaceEncoder(
                            self.args.face_detector_model, self.args.face_recognizer_model
                        )
                    faces = self.face_encoder.detect(frame)
                if len(faces) != 1:
                    raise ValueError("Exactly one clear face is required in every frame")
                results.append(self.liveness_scorer.score(frame, faces[0]))
            probabilities = [result["real_probability"] for result in results]
            real_labels = sum(result["is_live_label"] for result in results)
            return {
                "frames": len(results),
                "real_labels": real_labels,
                "minimum": round(min(probabilities), 4),
                "median": round(median(probabilities), 4),
                "maximum": round(max(probabilities), 4),
                "passed": real_labels == len(results),
            }

    def transcribe_audio(self, audio, media_type):
        """Transcribe one bounded recording without retaining audio or granting access."""
        with self.speech_lock:
            if self.speech_recognizer is None:
                from .speech_prototype import OfflineSpeechPrototype
                self.speech_recognizer = OfflineSpeechPrototype(
                    self.args.speech_runtime, self.args.speech_model
                )
            return self.speech_recognizer.transcribe(audio, media_type)

    def object_categories(self):
        with self.condition:
            return sorted(name for name in self.detector_names.values() if name != "person")

    def find_object(self, target):
        """Run one bounded, read-only object check against the latest camera frame."""
        target = OBJECT_ALIASES.get(target, target)
        with self.condition:
            fresh = bool(self.captured_at and time.monotonic() - self.captured_at <= 0.75 and not self.error)
            detector = self.detector
            names = dict(self.detector_names)
            frame = self.frame.copy() if fresh and self.frame is not None else None
        if detector is None or not names:
            return {"status": "unavailable", "message": "The object detector is not ready yet."}
        categories = {name for name in names.values() if name != "person"}
        if target not in categories:
            return {"status": "unsupported",
                    "message": "That target is not in the installed model category list. Open the category list below."}
        if frame is None:
            return {"status": "unavailable", "message": "A fresh camera frame is required before checking objects."}
        class_id = next((int(identity) for identity, name in names.items() if name == target), None)
        if class_id is None:
            return {"status": "unavailable", "message": f"The installed model does not contain the {target} category."}
        detections = self.detect_objects(frame, class_id, target)
        count = len(detections)
        noun = target if count == 1 else target + "s"
        highlight = " Highlighted on the camera for 3 seconds." if count else ""
        return {"status": "observed", "value": count, "target": target,
                "detections": detections,
                "message": f"Currently visible: {count} {noun}.{highlight}"}

    def detect_open_target(self, frame, target):
        """Use the measured YOLOE prompt profile only when the fixed detector lacks a label."""
        with self.open_vocabulary_lock:
            if self.open_vocabulary is None:
                model = getattr(self.args, "open_vocabulary_model", None)
                profile = getattr(self.args, "open_vocabulary_profile", None)
                if not model or not profile or not Path(model).is_file() or not Path(profile).is_file():
                    return None
                from .open_vocabulary import OpenVocabularyDetector
                self.open_vocabulary = OpenVocabularyDetector(model, profile)
            return self.open_vocabulary.detect(frame, target)

    def ground_centered_target(self, frame, box):
        with self.open_vocabulary_lock:
            if self.open_vocabulary is None:
                model = getattr(self.args, "open_vocabulary_model", None)
                profile = getattr(self.args, "open_vocabulary_profile", None)
                if not model or not profile or not Path(model).is_file() or not Path(profile).is_file():
                    return None
                from .open_vocabulary import OpenVocabularyDetector
                self.open_vocabulary = OpenVocabularyDetector(model, profile)
            return self.open_vocabulary.ground(frame, box)

    def detect_visual_target(self, frame, views, version, refresh=False):
        with self.open_vocabulary_lock:
            if self.open_vocabulary is None:
                model = getattr(self.args, "open_vocabulary_model", None)
                profile = getattr(self.args, "open_vocabulary_profile", None)
                if not model or not profile or not Path(model).is_file() or not Path(profile).is_file():
                    return []
                from .open_vocabulary import OpenVocabularyDetector
                self.open_vocabulary = OpenVocabularyDetector(model, profile)
            return self.open_vocabulary.detect_visual(frame, views, version, refresh)

    def diagnose_command(self, text):
        """Attach bounded current-camera observations without executing a mission."""
        interpretation = interpret_command(text)
        observations = []
        if interpretation["status"] == "planned":
            with self.condition:
                fresh = bool(self.vision_at and time.monotonic() - self.vision_at <= 0.75 and not self.error)
                visible_people = len(self.tracks) if fresh else None
            for position, step in enumerate(interpretation["steps"], 1):
                if step["action"] == "count":
                    if step.get("target") not in {"people", "person", "persons"}:
                        observation = {"status": "unavailable", "message": "This desk detector can count only currently visible people."}
                    elif visible_people is None:
                        observation = {"status": "unavailable", "message": "A fresh camera result is required before counting."}
                    else:
                        noun = "person" if visible_people == 1 else "people"
                        observation = {"status": "observed", "value": visible_people,
                                       "message": f"Currently visible: {visible_people} {noun}."}
                elif step["action"] == "scout":
                    observation = {"status": "unavailable", "message": "The fixed desk camera cannot scout or survey an area."}
                elif step["action"] == "find_object":
                    observation = self.find_object(step["target"])
                else:
                    observation = {"status": "not_evaluated", "message": "This action is interpreted but not performed by the desk diagnostic."}
                observations.append(dict(observation, step=position, action=step["action"]))
        return {"interpretation": interpretation, "observations": observations,
                "executable": False, "authority": "DIAGNOSTIC_ONLY"}

    @staticmethod
    def _object_target(target):
        target = re.sub(r"^(?:this|that|the|an?|my)\s+", "", target)
        return OBJECT_ALIASES.get(target, target[:-1] if target.endswith("s") else target)

    def _mission_frame(self):
        with self.condition:
            fresh = (self.frame is not None and self.captured_at
                     and time.monotonic() - self.captured_at <= .75 and not self.error)
            return self.frame.copy() if fresh else None, dict(self.detector_names)

    def _mission_detections(self, frame, names, target):
        class_id = next((int(identity) for identity, name in names.items() if name == target), None)
        if class_id is not None:
            return "fixed_category", class_id, self.detect_objects(frame, class_id, target)
        detections = self.detect_open_target(frame, target)
        return ("open_vocabulary", None, detections) if detections is not None else (None, None, None)

    def _mission_current(self, epoch, generation):
        return self.mission_epoch == epoch and (generation is None or self.conversation.is_current(generation))

    def _superseded_mission(self):
        return self._mission_result("superseded", "A newer request or Stop cancelled this result.")

    def conversation_request(self, text, proposal_id=None):
        text = clean_text(text)
        if text.casefold() in CONFIRM_COMMANDS:
            return self.confirm_conversation(proposal_id)
        result = self.conversation.propose(text)
        if result["status"] == "stopped":
            return self.run_mission("stop")
        if result["status"] == "status":
            return self._conversation_status(result)
        # Proposals and their confirmation IDs remain in the authenticated reply;
        # public frame/status metadata and persistent telemetry do not retain them.
        return result

    def confirm_conversation(self, proposal_id):
        result = self.conversation.confirm(proposal_id)
        if result["status"] != "confirmed":
            return result
        return self.run_mission(result["command"], generation=result["generation"])

    def cancel_conversation(self):
        self.conversation.cancel()
        with self.condition:
            self.mission_epoch += 1
        return self._mission_result("cancelled", "Proposal discarded. Existing tracking is unchanged.")

    def run_mission(self, text, generation=None):
        """Internal executor; HTTP callers must pass the conversation confirmation gate."""
        stopping = is_stop_command(text)
        if stopping:
            self.conversation.cancel()
        with self.condition:
            if generation is not None and not self.conversation.is_current(generation):
                return self._superseded_mission()
            self.mission_epoch += 1
            epoch = self.mission_epoch
        result = self._run_mission("stop" if stopping else text, epoch, generation)
        with self.condition:
            if not self._mission_current(epoch, generation):
                return self._superseded_mission()
            self.mission = result
        return result

    def _commit_object_target(self, frame, box, epoch, generation, category=None):
        # Initialize independently so Stop need not wait for model creation/inference.
        with self.condition:
            if not self._mission_current(epoch, generation):
                return False
        with self.generic_object_lock:
            candidate = copy.copy(self.generic_object)
        candidate.select(frame, box, time.monotonic())
        if category:
            candidate.associate_category(*category)
        else:
            candidate.enable_visual_recovery()
        with self.condition:
            if not self._mission_current(epoch, generation):
                return False
            with self.generic_object_lock:
                self.generic_object = candidate
                self.object_generation += 1
            self.selection.clear()
        return True

    def _run_mission(self, text, epoch, generation):
        """Run one desk-only mission command without producing actuator output."""
        interpretation = interpret_command(text)
        if interpretation["status"] != "planned":
            result = self._mission_result(
                interpretation["status"], interpretation["message"], interpretation=interpretation
            )
            return result
        steps = interpretation["steps"]
        if len(steps) > 1:
            diagnostic = self.diagnose_command(text)
            result = self._mission_result(
                "partial", "The fixed desk evaluated each step but cannot perform an area mission.",
                observations=diagnostic["observations"], interpretation=interpretation,
            )
            return result
        step = steps[0]
        if step["action"] == "stop":
            with self.condition:
                with self.generic_object_lock:
                    self.generic_object.clear()
                    self.object_generation += 1
                self.selection.clear()
                self.center_prompt_until = 0
            result = self._mission_result(
                "stopped", "The simulated mission and both target trackers are stopped.",
                interpretation=interpretation,
            )
            return result
        if step["action"] == "status":
            return self.mission
        if step["action"] == "scout":
            result = self._mission_result(
                "unavailable", "The fixed desk camera cannot scout or survey an area.",
                interpretation=interpretation,
            )
            return result
        if step == {"action": "follow", "target": "me"}:
            return self._follow_enrolled_owner(interpretation, epoch, generation)
        if is_described_human_target(step["action"], step.get("target", "")):
            return self._mission_result(
                "clarification_required", MANUAL_PERSON_MESSAGE, interpretation=interpretation,
            )
        if step["action"] == "follow" and step["target"] in {
            "this", "this object", "this item", "object", "item"
        }:
            return self._follow_centered_object(interpretation, epoch, generation)
        if step["action"] == "count" and step["target"] in {"people", "person", "persons"}:
            with self.condition:
                fresh = self.vision_at and time.monotonic() - self.vision_at <= .75 and not self.error
                count = len(self.tracks) if fresh else None
            if count is None:
                result = self._mission_result(
                    "unavailable", "A fresh camera result is required before counting people.",
                    interpretation=interpretation,
                )
            else:
                result = self._mission_result(
                    "complete", f"Currently visible: {count} {'person' if count == 1 else 'people'}.",
                    value=count, target={"kind": "person"}, interpretation=interpretation,
                )
            return result
        if step["action"] not in {"follow", "find_object", "count"}:
            result = self._mission_result(
                "unavailable", "That simulated mission is not available on the fixed desk.",
                interpretation=interpretation,
            )
            return result

        target = self._object_target(step["target"])
        frame, names = self._mission_frame()
        if frame is None:
            result = self._mission_result(
                "unavailable", "A fresh camera frame is required before finding an object.",
                interpretation=interpretation,
            )
            return result
        source, class_id, detections = self._mission_detections(frame, names, target)
        if detections is None:
            result = self._mission_result(
                "unsupported", "That target is not available in either local detector vocabulary.",
                target={"kind": "object", "label": target}, interpretation=interpretation,
            )
            return result
        if step["action"] == "follow":
            if len(detections) != 1:
                message = (f"I cannot currently see a {target}." if not detections else
                           f"I can see {len(detections)} {target}s. Put only one in view or describe which one.")
                result = self._mission_result(
                    "clarification_required", message, detections=detections,
                    target={"kind": "object", "label": target}, source=source,
                    interpretation=interpretation,
                )
                return result
            if not self._commit_object_target(frame, detections[0]["box"], epoch, generation,
                                              (target, class_id) if class_id is not None else None):
                return self._superseded_mission()
            result = self._mission_result(
                "tracking", f"Simulating follow of the visible {target}.",
                target={"kind": "object", "label": target}, source=source,
                detections=detections, interpretation=interpretation,
            )
            return result
        count = len(detections)
        result = self._mission_result(
            "complete", f"Currently visible: {count} {target if count == 1 else target + 's'}.",
            value=count, target={"kind": "object", "label": target},
            source=source, detections=detections, interpretation=interpretation,
        )
        return result

    def _follow_enrolled_owner(self, interpretation, epoch, generation):
        if not self.enrollment.complete:
            result = self._mission_result(
                "clarification_required",
                "Complete temporary owner face enrollment before asking me to follow you.",
                interpretation=interpretation,
            )
            return result
        with self.condition:
            fresh = (self.frame is not None and self.captured_at
                     and time.monotonic() - self.captured_at <= .75
                     and self.vision_at and time.monotonic() - self.vision_at <= .75
                     and not self.error)
            frame = self.frame.copy() if fresh else None
            tracks = list(self.tracks) if fresh else []
        if frame is None:
            result = self._mission_result(
                "unavailable", "A fresh camera view is required to find the enrolled owner.",
                interpretation=interpretation,
            )
            return result
        with self.face_lock:
            observation = self.face_encoder.observe(frame)
            if observation.get("face_count") != 1:
                result = self._mission_result(
                    "clarification_required", "Show exactly one clear face to the camera.",
                    interpretation=interpretation,
                )
                return result
            match = self.enrollment.evaluate(observation["feature"], self.face_encoder.compare)
        if not match["passed"]:
            result = self._mission_result(
                "clarification_required", "The visible face does not match the enrolled owner.",
                interpretation=interpretation,
            )
            return result
        x1, y1, x2, y2 = observation["box"]
        center = ((x1 + x2) / 2, (y1 + y2) / 2)
        candidates = [track for track in tracks if (
            track["box"][0] <= center[0] <= track["box"][2]
            and track["box"][1] <= center[1] <= track["box"][3]
        )]
        with self.condition:
            if not self._mission_current(epoch, generation):
                return self._superseded_mission()
            selected = len(candidates) == 1 and self.selection.select(candidates[0]["id"], time.monotonic())
            if selected:
                with self.generic_object_lock:
                    self.generic_object.clear()
                    self.object_generation += 1
        if not selected:
            result = self._mission_result(
                "clarification_required",
                "I matched the owner face but could not associate it with exactly one current person.",
                interpretation=interpretation,
            )
            return result
        track_id = candidates[0]["id"]
        result = self._mission_result(
            "tracking", "Simulating follow of the enrolled owner.",
            target={"kind": "person", "track_id": track_id, "identity": "enrolled_owner"},
            interpretation=interpretation,
        )
        return result

    def _follow_centered_object(self, interpretation, epoch, generation):
        frame, _ = self._mission_frame()
        if frame is None:
            result = self._mission_result(
                "unavailable", "A fresh camera frame is required before grounding an object.",
                interpretation=interpretation,
            )
            return result
        height, width = frame.shape[:2]
        guide = [round(width * .35), round(height * .25), round(width * .65), round(height * .75)]
        now = time.monotonic()
        with self.condition:
            if not self._mission_current(epoch, generation):
                return self._superseded_mission()
            needs_guidance = now > self.center_prompt_until
            self.center_prompt_until = now + 20 if needs_guidance else 0
        if needs_guidance:
            result = self._mission_result(
                "clarification_required",
                "Place one complete object inside the blue guide, hold it still, then say ‘follow this object’ again.",
                prompt={"kind": "center_target", "box": guide, "expires_in_s": 20},
                interpretation=interpretation,
            )
            return result
        detections = self.ground_centered_target(frame, guide)
        candidates = [detection for detection in detections or []
                      if self.overlap_smaller(guide, detection["box"]) >= .5]
        if len(candidates) != 1:
            result = self._mission_result(
                "clarification_required",
                "I could not ground exactly one clear object in the guide. Center one object and try again.",
                prompt={"kind": "center_target", "box": guide, "expires_in_s": 20},
                interpretation=interpretation,
            )
            return result
        best = candidates[0]
        if not self._commit_object_target(frame, best["box"], epoch, generation):
            return self._superseded_mission()
        result = self._mission_result(
            "tracking", "Simulating follow of the visually grounded object.",
            target={"kind": "object", "label": "visually prompted object"},
            source="visual_prompt", detections=[best], interpretation=interpretation,
        )
        return result

    def monitor(self):
        import psutil
        process = psutil.Process()
        self.args.log.parent.mkdir(parents=True, exist_ok=True)
        with self.args.log.open("a", encoding="utf-8") as log:
            while not self.stop.is_set():
                try:
                    def command(*args):
                        return subprocess.check_output(["vcgencmd", *args], text=True, timeout=3).strip()
                    hardware = {"temperature_c": float(command("measure_temp").split("=")[1].split("'")[0]),
                                "throttled": command("get_throttled").split("=")[1],
                                "voltage_v": float(command("pmic_read_adc", "EXT5V_V").split("=")[1].rstrip("V")),
                                "memory_mb": round(process.memory_info().rss / 2**20, 1)}
                    with self.condition:
                        self.hardware = hardware
                        summary = self.snapshot()
                    # No images, boxes, or target IDs on disk. Metrics only.
                    for key in ("tracks", "selected_id", "sequence"):
                        summary.pop(key, None)
                    summary["utc"] = time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())
                    log.write(json.dumps(summary) + "\n")
                    log.flush()
                except Exception as exc:
                    with self.condition:
                        self.hardware = {"error": str(exc)}
                self.stop.wait(5)


class Handler(BaseHTTPRequestHandler):
    protocol_version = "HTTP/1.1"

    def setup(self):
        super().setup()
        self.connection.setsockopt(socket.IPPROTO_TCP, socket.TCP_NODELAY, 1)
        self.connection.settimeout(5)

    @property
    def app(self):
        return self.server.app

    def log_message(self, *_):
        pass

    def send(self, code, body, content_type="application/json", extra=None):
        if not isinstance(body, bytes):
            body = json.dumps(body).encode()
        self.send_response(code)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Cache-Control", "no-store")
        self.send_header("X-Content-Type-Options", "nosniff")
        self.send_header("Permissions-Policy", "microphone=(self)")
        self.send_header("Content-Security-Policy", "default-src 'self'; script-src 'self'; style-src 'self'; img-src 'self' blob:; connect-src 'self'; frame-ancestors 'none'")
        if extra:
            for key, value in extra.items():
                self.send_header(key, value)
        self.end_headers()
        try:
            self.wfile.write(body)
        except (BrokenPipeError, ConnectionResetError):
            pass

    def local_host(self):
        # Reject DNS rebinding; the launcher uses the same local and remote port.
        return self.headers.get("Host") in {f"127.0.0.1:{self.server.server_port}", f"localhost:{self.server.server_port}"}

    def do_GET(self):
        if not self.local_host():
            self.send(403, {"error": "Use the local SSH tunnel address"})
            return
        path = urlsplit(self.path)
        if path.path == "/":
            page = Path(__file__).with_name("index.html").read_text(encoding="utf-8")
            self.send(200, page.replace("__TOKEN__", self.app.token).encode(), "text/html; charset=utf-8")
        elif path.path in {"/app.js", "/style.css"}:
            mime = "text/javascript" if path.path.endswith(".js") else "text/css"
            self.send(200, Path(__file__).with_name(path.path[1:]).read_bytes(), mime)
        elif path.path == "/status":
            with self.app.condition:
                status = self.app.snapshot()
            self.send(200, status)
        elif path.path == "/frame":
            try:
                after = int(parse_qs(path.query).get("after", ["0"])[0])
            except ValueError:
                self.send(400, {"error": "Invalid frame number"})
                return
            with self.app.condition:
                self.app.condition.wait_for(lambda: self.app.sequence > after or self.app.error, timeout=1)
                if self.app.error or not self.app.jpeg or self.app.sequence <= after or time.monotonic()-self.app.captured_at > 1:
                    self.send(503, {"error": self.app.error or "Waiting for fresh camera frames"})
                    return
                jpeg, status = self.app.jpeg, self.app.snapshot()
            self.send(200, jpeg, "image/jpeg", {"X-Frame-Meta": json.dumps(status)})
        else:
            self.send(404, {"error": "Not found"})

    def do_POST(self):
        if not self.local_host() or self.headers.get("X-Session-Token") != self.app.token:
            self.close_connection = True
            self.send(403, {"error": "Invalid session"})
            return
        origin = self.headers.get("Origin")
        if origin and origin != "http://" + self.headers.get("Host", ""):
            self.close_connection = True
            self.send(403, {"error": "Invalid origin"})
            return
        try:
            length = int(self.headers.get("Content-Length", "0"))
            if self.path == "/speech/transcribe":
                if not 0 < length <= 2_000_000:
                    raise ValueError("Invalid audio size")
                media_type = self.headers.get("Content-Type", "").split(";", 1)[0].strip().casefold()
                if media_type not in {"audio/mp4", "audio/ogg", "audio/wav", "audio/webm"}:
                    raise ValueError("Use WAV, WebM, Ogg, or MP4 audio")
                started = time.monotonic()
                generation = self.app.conversation.snapshot()["generation"]
                transcript = self.app.transcribe_audio(self.rfile.read(length), media_type)
                transcription_ms = round((time.monotonic() - started) * 1000, 1)
                mission = (self.app.conversation_request(transcript, self.headers.get("X-Proposal-Id"))
                           if self.app.conversation.is_current(generation) else self.app._superseded_mission())
                self.send(200, {
                    "transcript": transcript,
                    "transcription_ms": transcription_ms,
                    "interpretation": mission.get("interpretation"),
                    "mission": mission,
                })
                return
            if not 0 < length <= 2048:
                raise ValueError("Invalid body size")
            data = json.loads(self.rfile.read(length))
            if not isinstance(data, dict):
                raise ValueError("Expected an object")
            if self.path == "/face/check":
                if data:
                    raise ValueError("Face check takes no options")
                self.send(200, self.app.check_face())
                return
            if self.path == "/range/estimate-face":
                if data:
                    raise ValueError("Face range estimate takes no options")
                self.send(200, self.app.estimate_face_range())
                return
            if self.path == "/range/calibrate-object":
                if data:
                    raise ValueError("Object range calibration takes no options")
                self.send(200, self.app.calibrate_object_range())
                return
            if self.path == "/range/estimate-object":
                if data:
                    raise ValueError("Object range estimate takes no options")
                self.send(200, self.app.estimate_object_range())
                return
            if self.path == "/liveness/check":
                if data:
                    raise ValueError("Liveness check takes no options")
                self.send(200, self.app.check_liveness())
                return
            if self.path == "/command/interpret":
                if set(data) != {"text"}:
                    raise ValueError("Command interpretation requires only text")
                self.send(200, interpret_command(data["text"]))
                return
            if self.path == "/command/diagnose":
                if set(data) != {"text"}:
                    raise ValueError("Command diagnosis requires only text")
                self.send(200, self.app.diagnose_command(data["text"]))
                return
            if self.path in {"/conversation", "/mission/run"}:
                if not {"text"} <= set(data) <= {"text", "proposal_id"}:
                    raise ValueError("Conversation requires text and an optional proposal ID")
                if data.get("proposal_id") is not None and not isinstance(data["proposal_id"], str):
                    raise ValueError("Invalid proposal ID")
                self.send(200, self.app.conversation_request(data["text"], data.get("proposal_id")))
                return
            if self.path == "/conversation/confirm":
                if set(data) != {"proposal_id"} or not isinstance(data["proposal_id"], str):
                    raise ValueError("Confirmation requires the exact proposal ID")
                self.send(200, self.app.confirm_conversation(data["proposal_id"]))
                return
            if self.path == "/conversation/cancel":
                if data:
                    raise ValueError("Cancel takes no options")
                self.send(200, self.app.cancel_conversation())
                return
            if self.path == "/object/select":
                if set(data) != {"box"}:
                    raise ValueError("Object selection requires only a box")
                self.send(200, self.app.select_generic_object(data["box"]))
                return
            if self.path == "/object/categories":
                if data:
                    raise ValueError("Object categories takes no options")
                self.send(200, {"categories": self.app.object_categories()})
                return
            if self.path == "/object/clear":
                if data:
                    raise ValueError("Object clear takes no options")
                self.send(200, self.app.clear_generic_object())
                return
            if self.path == "/range/sample":
                if set(data) != {"target", "distance_m"}:
                    raise ValueError("Range sample requires target and distance_m")
                self.send(200, self.app.measure_range(data["target"], data["distance_m"]))
                return
            if self.path == "/range/results":
                if data:
                    raise ValueError("Range results takes no options")
                with self.app.condition:
                    samples = list(self.app.range_samples)
                self.send(200, {"samples": samples})
                return
            if self.path == "/range/clear":
                if data:
                    raise ValueError("Range clear takes no options")
                with self.app.condition:
                    self.app.range_samples = []
                self.send(200, {"samples": []})
                return
            if self.path in {"/select", "/clear"}:
                self.app.conversation.cancel()
            with self.app.condition:
                if self.path == "/select":
                    identity = data.get("id")
                    if type(identity) is not int or not self.app.selection.select(identity, time.monotonic()):
                        self.send(409, {"error": "That target is no longer clear and current. Select again."})
                        return
                    self.app.mission_epoch += 1
                elif self.path == "/clear":
                    self.app.selection.clear()
                    self.app.mission_epoch += 1
                elif self.path == "/enrollment/start":
                    if data:
                        raise ValueError("Enrollment start takes no options")
                    self.app.enrollment.start()
                    self.app.condition.notify_all()
                elif self.path == "/enrollment/cancel":
                    if data:
                        raise ValueError("Enrollment cancel takes no options")
                    self.app.enrollment.cancel()
                elif self.path == "/telemetry":
                    allowed = {"display_fps", "latency_upper_p95_ms", "samples", "visible"}
                    if set(data) != allowed or not all(type(v) in (int, float, bool) and math.isfinite(v) and 0 <= v <= 1e6 for v in data.values()):
                        raise ValueError("Invalid display measurements")
                    self.app.client = dict(data, received_uptime_s=round(time.monotonic()-self.app.started))
                    self.app.client_at = time.monotonic()
                else:
                    self.send(404, {"error": "Not found"})
                    return
                status = self.app.snapshot()
            self.send(200, status)
        except (ValueError, TypeError, RuntimeError, json.JSONDecodeError) as exc:
            self.close_connection = True
            self.send(400, {"error": str(exc)})


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--model", required=True)
    parser.add_argument("--appearance-model", type=Path,
                        default=Path.home()/"bgd-vision/models/osnet_x0_25_msmt17")
    parser.add_argument("--face-detector-model", type=Path,
                        default=Path.home()/"bgd-vision/models/opencv_face/yunet.onnx")
    parser.add_argument("--face-recognizer-model", type=Path,
                        default=Path.home()/"bgd-vision/models/opencv_face/sface.onnx")
    parser.add_argument("--liveness-source", type=Path,
                        default=Path.home()/"bgd-vision/candidates/Silent-Face-Anti-Spoofing")
    parser.add_argument("--liveness-model-dir", type=Path,
                        default=Path.home()/"bgd-vision/candidates/Silent-Face-Anti-Spoofing/resources/anti_spoof_models")
    parser.add_argument("--speech-model", type=Path,
                        default=Path.home()/"bgd-vision/candidates/vosk-model-small-en-us-0.15")
    parser.add_argument("--speech-runtime", type=Path,
                        default=Path.home()/"bgd-vision/candidates/vosk-0.3.45")
    parser.add_argument("--language-model-port", type=int,
                        help="Optional local llama.cpp port; disabled until candidate qualification")
    parser.add_argument("--object-tracker-model", type=Path,
                        default=Path.home()/"bgd-vision/candidates/opencv-vittrack/object_tracking_vittrack_2023sep.onnx")
    parser.add_argument("--open-vocabulary-model", type=Path,
                        default=Path.home()/"bgd-vision/candidates/yoloe26/yoloe-26n-seg.pt")
    parser.add_argument("--open-vocabulary-profile", type=Path,
                        default=Path.home()/"bgd-vision/candidates/yoloe26/bgd-targets-yoloe26n.npz")
    parser.add_argument("--imgsz", type=int, default=320)
    parser.add_argument("--port", type=int, default=8765)
    parser.add_argument("--log", type=Path, default=Path.home()/"bgd-vision/logs/metrics.jsonl")
    args = parser.parse_args()
    if not Path(args.model).is_dir():
        parser.error("An exported local NCNN model directory is required")
    if not args.appearance_model.is_dir():
        parser.error("The local appearance NCNN model directory is required")
    if not args.liveness_source.is_dir() or not args.liveness_model_dir.is_dir():
        parser.error("The local liveness source and model directories are required")
    if not args.speech_runtime.is_dir() or not args.speech_model.is_dir():
        parser.error("The isolated speech runtime and model directories are required")
    if not args.object_tracker_model.is_file():
        parser.error("The local ViTTrack model file is required")
    os.environ.setdefault("YOLO_AUTOINSTALL", "false")
    app = Application(args)
    server = ThreadingHTTPServer(("127.0.0.1", args.port), Handler)
    server.app = app
    def shutdown(*_):
        app.stop.set()
        with app.condition:
            app.condition.notify_all()
        threading.Thread(target=server.shutdown, daemon=True).start()
    signal.signal(signal.SIGTERM, shutdown)
    signal.signal(signal.SIGINT, shutdown)
    threads = [threading.Thread(target=job, daemon=True)
               for job in (app.capture, app.infer, app.enroll, app.track_generic_object,
                           app.redetect_visual_object, app.monitor)]
    for thread in threads:
        thread.start()
    print(f"Desk vision listening on 127.0.0.1:{args.port}; recording OFF", flush=True)
    try:
        server.serve_forever()
    finally:
        app.stop.set()
        for thread in threads:
            thread.join(timeout=4)
        server.server_close()
