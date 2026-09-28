"""Bounded visual tracking for a user-selected, unnamed object region."""

import math
from pathlib import Path


class VitTracker:
    """OpenCV's model-backed single-object tracker with a meaningful loss score."""
    name = "OpenCV ViTTrack"

    def __init__(self, model):
        import cv2
        if not Path(model).is_file():
            raise RuntimeError("The ViTTrack model is unavailable")
        params = cv2.TrackerVit_Params()
        params.net = str(model)
        params.backend = cv2.dnn.DNN_BACKEND_OPENCV
        params.target = cv2.dnn.DNN_TARGET_CPU
        self.cv2 = cv2
        self.tracker = cv2.TrackerVit_create(params)

    def _bgr(self, frame):
        return self.cv2.cvtColor(frame, self.cv2.COLOR_RGB2BGR)

    def init(self, frame, box):
        return self.tracker.init(self._bgr(frame), box)

    def update(self, frame):
        return self.tracker.update(self._bgr(frame))

    def get_score(self):
        return float(self.tracker.getTrackingScore())


class TemplateTracker:
    """Fixed-size nearby template matching for a short user-selected target."""
    name = "Template fallback"
    scale = 0.5

    def _small(self, frame):
        import cv2
        return cv2.resize(frame, None, fx=self.scale, fy=self.scale, interpolation=cv2.INTER_AREA)

    def init(self, frame, box):
        import cv2
        x, y, width, height = box
        x, y, width, height = (round(value*self.scale) for value in box)
        frame = self._small(frame)
        self.box = (x, y, width, height)
        self.template = cv2.cvtColor(frame[y:y+height, x:x+width], cv2.COLOR_RGB2GRAY).copy()
        return bool(self.template.size)

    def update(self, frame):
        import cv2
        frame = self._small(frame)
        x, y, width, height = self.box
        frame_height, frame_width = frame.shape[:2]
        pad_x, pad_y = max(24, width//2), max(24, height//2)
        left, top = max(0, x-pad_x), max(0, y-pad_y)
        right, bottom = min(frame_width, x+width+pad_x), min(frame_height, y+height+pad_y)
        search = cv2.cvtColor(frame[top:bottom, left:right], cv2.COLOR_RGB2GRAY)
        best = (-1.0, None, None)
        for scale in (0.85, 1.0, 1.15):
            candidate_width = max(10, round(self.template.shape[1]*scale))
            candidate_height = max(10, round(self.template.shape[0]*scale))
            if search.shape[0] < candidate_height or search.shape[1] < candidate_width:
                continue
            candidate = cv2.resize(self.template, (candidate_width, candidate_height),
                                   interpolation=cv2.INTER_LINEAR)
            scores = cv2.matchTemplate(search, candidate, cv2.TM_CCOEFF_NORMED)
            _, score, _, location = cv2.minMaxLoc(scores)
            if math.isfinite(score) and score > best[0]:
                best = (score, location, candidate)
        score, location, candidate = best
        self.score = score
        if not math.isfinite(score) or score < 0.55:
            return False, self.box
        height, width = candidate.shape
        x, y = left+location[0], top+location[1]
        self.box = (x, y, width, height)
        current = cv2.cvtColor(frame[y:y+height, x:x+width], cv2.COLOR_RGB2GRAY)
        self.template = cv2.addWeighted(candidate, 0.95, current, 0.05, 0)
        return True, tuple(value/self.scale for value in self.box)

    def get_score(self):
        return float(getattr(self, "score", 1.0))


class GenericObjectTracker:
    def __init__(self, tracker_factory=None, max_duration=30, reacquire_duration=10,
                 wide_search_after=1.5, max_memory_views=4):
        self.tracker_factory = tracker_factory or self._opencv_tracker
        self.default_max_duration = max_duration
        self.reacquire_duration = reacquire_duration
        self.wide_search_after = wide_search_after
        self.max_memory_views = max_memory_views
        self.clear()

    @staticmethod
    def _opencv_tracker():
        return TemplateTracker()

    def clear(self):
        self.max_duration = self.default_max_duration
        self.tracker = None
        self.status = "idle"
        self.box = None
        self.started_at = None
        self.reason = "No object selected."
        self.method = None
        self.score = None
        self.initial_size = None
        self.category = None
        self.class_id = None
        self.last_box = None
        self.box_at = None
        self.lost_at = None
        self.velocity = (0.0, 0.0)
        self.reacquire_deadline = None
        self.reacquire_candidate = None
        self.reacquire_confirmations = 0
        self.visual_recovery = False
        self.memory = []
        self.memory_version = 0
        self.last_remembered_at = None

    def fail(self, reason):
        return self._finish("lost", reason)

    def associate_category(self, category, class_id):
        if self.status == "tracking":
            self.category = category
            self.class_id = class_id
            self.reason = f"Tracking selected {category} for up to {self.max_duration:g} seconds."

    def enable_visual_recovery(self):
        if self.status == "tracking":
            self.visual_recovery = True
            self.reason = "Learning several temporary views of the selected object while tracking."

    def select(self, frame, box, now):
        if not isinstance(box, list) or len(box) != 4 or not all(
            type(value) in (int, float) and math.isfinite(value) for value in box
        ):
            raise ValueError("Object selection requires four finite box coordinates")
        height, width = frame.shape[:2]
        x1, x2 = sorted((max(0, min(width, round(box[0]))), max(0, min(width, round(box[2])))))
        y1, y2 = sorted((max(0, min(height, round(box[1]))), max(0, min(height, round(box[3])))))
        if x2 - x1 < 20 or y2 - y1 < 20:
            raise ValueError("Select a region at least 20 pixels wide and high")
        tracker = self.tracker_factory()
        initialized = tracker.init(frame, (x1, y1, x2-x1, y2-y1))
        if initialized is False:
            raise RuntimeError("The object tracker could not initialize that region")
        self.clear()
        self.tracker = tracker
        self.method = getattr(tracker, "name", "Visual tracker")
        self.status = "tracking"
        self.box = [x1, y1, x2, y2]
        self.initial_size = (x2-x1, y2-y1)
        self.started_at = now
        self.box_at = now
        self.velocity = (0.0, 0.0)
        self.reason = f"Tracking the selected visual region for up to {self.max_duration:g} seconds."
        self._remember(frame, self.box, now, force=True)
        return self.snapshot(now)

    def _remember(self, frame, box, now, force=False):
        """Keep a few bounded in-memory views; never write target imagery to disk."""
        if not self.visual_recovery and not force:
            return
        if not force and self.last_remembered_at is not None and now-self.last_remembered_at < .75:
            return
        try:
            import numpy as np
            if not isinstance(frame, np.ndarray):
                return
            frame_height, frame_width = frame.shape[:2]
            x1, y1, x2, y2 = box
            pad_x, pad_y = round((x2-x1)*.2), round((y2-y1)*.2)
            left, top = max(0, x1-pad_x), max(0, y1-pad_y)
            right, bottom = min(frame_width, x2+pad_x), min(frame_height, y2+pad_y)
            crop = frame[top:bottom, left:right].copy()
            if crop.shape[0] < 20 or crop.shape[1] < 20:
                return
            target_box = [x1-left, y1-top, x2-left, y2-top]
            rows = np.linspace(0, crop.shape[0]-1, 32).astype(int)
            columns = np.linspace(0, crop.shape[1]-1, 32).astype(int)
            signature = crop[rows[:, None], columns]
            if self.memory:
                differences = [float(np.mean(np.abs(signature.astype(np.float32)-view["signature"]))) / 255
                               for view in self.memory]
                if max(differences) < .08:
                    return
            view = {"image": crop, "box": target_box, "signature": signature.astype(np.float32)}
            if len(self.memory) >= self.max_memory_views:
                self.memory.pop(1 if len(self.memory) > 1 else 0)
            self.memory.append(view)
            self.memory_version += 1
            self.last_remembered_at = now
        except (ImportError, ValueError, TypeError):
            return

    def visual_memory(self):
        return self.memory_version, [
            {"image": view["image"].copy(), "box": list(view["box"])} for view in self.memory
        ]

    def _lose_or_reacquire(self, now, reason):
        if not self.category and not self.visual_recovery:
            return self._finish("lost", reason)
        self.last_box = list(self.box)
        self.lost_at = now
        self.tracker = None
        self.status = "reacquiring"
        self.box = None
        self.score = None
        self.reacquire_deadline = min(self.started_at+self.max_duration, now+self.reacquire_duration)
        self.reacquire_candidate = None
        self.reacquire_confirmations = 0
        self.reason = f"Reacquiring the selected {self.category or 'object'}; no target box is trusted."
        return self.snapshot(now)

    def update(self, frame, now):
        current = self.snapshot(now)
        if current["status"] != "tracking":
            return current
        ok, (x, y, width, height) = self.tracker.update(frame)
        if hasattr(self.tracker, "get_score"):
            self.score = round(self.tracker.get_score(), 3)
        if not ok or not all(math.isfinite(value) for value in (x, y, width, height)):
            return self._lose_or_reacquire(now, "The selected object was lost. Select it again.")
        frame_height, frame_width = frame.shape[:2]
        previous_width = self.box[2]-self.box[0]
        previous_height = self.box[3]-self.box[1]
        initial_width, initial_height = self.initial_size
        if (width > previous_width*2 or height > previous_height*2
                or width > initial_width*4 or height > initial_height*4
                or width*height > frame_width*frame_height*.6):
            return self._lose_or_reacquire(
                now, "The selected object box expanded implausibly. Select the object again."
            )
        x1, y1 = max(0, round(x)), max(0, round(y))
        x2, y2 = min(frame_width, round(x+width)), min(frame_height, round(y+height))
        if x2-x1 < 10 or y2-y1 < 10:
            return self._lose_or_reacquire(now, "The selected object left the usable camera view.")
        new_box = [x1, y1, x2, y2]
        if self.box_at is not None and now > self.box_at:
            old_center = ((self.box[0]+self.box[2])/2, (self.box[1]+self.box[3])/2)
            new_center = ((x1+x2)/2, (y1+y2)/2)
            instant = tuple((new_center[index]-old_center[index])/(now-self.box_at)
                            for index in (0, 1))
            self.velocity = instant if self.velocity == (0.0, 0.0) else tuple(
                self.velocity[index]*.75+instant[index]*.25 for index in (0, 1)
            )
        self.box = new_box
        self.box_at = now
        if self.visual_recovery and (self.score is None or self.score >= .55):
            self._remember(frame, new_box, now)
        return self.snapshot(now)

    def correct(self, frame, detections, now):
        current = self.snapshot(now)
        if current["status"] != "tracking" or (not self.category and not self.visual_recovery):
            return current
        if len(detections) != 1 or detections[0].get("confidence", 0) < .3:
            return current
        candidate = detections[0].get("box")
        if (not isinstance(candidate, list) or len(candidate) != 4
                or not all(type(value) in (int, float) and math.isfinite(value) for value in candidate)):
            return current
        rounded = [round(value) for value in candidate]
        width, height = rounded[2]-rounded[0], rounded[3]-rounded[1]
        current_width, current_height = self.box[2]-self.box[0], self.box[3]-self.box[1]
        initial_width, initial_height = self.initial_size
        frame_height, frame_width = frame.shape[:2]
        distance = math.hypot(
            (rounded[0]+rounded[2]-self.box[0]-self.box[2])/2,
            (rounded[1]+rounded[3]-self.box[1]-self.box[3])/2,
        )
        plausible = (width >= 10 and height >= 10
                     and .5 <= width/current_width <= 2 and .5 <= height/current_height <= 2
                     and width <= initial_width*4 and height <= initial_height*4
                     and width*height <= frame_width*frame_height*.6
                     and distance <= max(current_width, current_height)*3)
        if not plausible:
            return current
        intersection = (max(0, min(self.box[2], rounded[2])-max(self.box[0], rounded[0]))
                        * max(0, min(self.box[3], rounded[3])-max(self.box[1], rounded[1])))
        if intersection/min(current_width*current_height, width*height) >= .6:
            self.reacquire_candidate = None
            self.reacquire_confirmations = 0
            return current
        if self.visual_recovery and not self.category:
            previous = self.reacquire_candidate
            if previous:
                prior_width, prior_height = previous[2]-previous[0], previous[3]-previous[1]
                confirmation_distance = math.hypot(
                    (rounded[0]+rounded[2]-previous[0]-previous[2])/2,
                    (rounded[1]+rounded[3]-previous[1]-previous[3])/2,
                )
                consistent = (confirmation_distance <= max(prior_width, prior_height)*.5
                              and .5 <= width/prior_width <= 2
                              and .5 <= height/prior_height <= 2)
            else:
                consistent = False
            self.reacquire_confirmations = self.reacquire_confirmations+1 if consistent else 1
            self.reacquire_candidate = rounded
            if self.reacquire_confirmations < 2:
                return current
        tracker = self.tracker_factory()
        try:
            initialized = tracker.init(frame, (rounded[0], rounded[1], width, height))
        except Exception:
            return self.fail(f"Could not safely correct tracking the selected {self.category or 'object'}.")
        if initialized is False:
            return self.fail(f"Could not safely correct tracking the selected {self.category or 'object'}.")
        self.tracker = tracker
        self.method = getattr(tracker, "name", "Visual tracker")
        self.box = rounded
        self.box_at = now
        self.score = None
        self.reacquire_candidate = None
        self.reacquire_confirmations = 0
        self.reason = f"Re-detection corrected tracking for the selected {self.category or 'object'}."
        return self.snapshot(now)

    def _expected_box(self, now):
        elapsed = min(.5, max(0, now-(self.lost_at or now)))
        limit = max(self.last_box[2]-self.last_box[0], self.last_box[3]-self.last_box[1])*3
        shift_x = max(-limit, min(limit, self.velocity[0]*elapsed))
        shift_y = max(-limit, min(limit, self.velocity[1]*elapsed))
        return [self.last_box[0]+shift_x, self.last_box[1]+shift_y,
                self.last_box[2]+shift_x, self.last_box[3]+shift_y]

    def reacquire(self, frame, detections, now):
        current = self.snapshot(now)
        if current["status"] != "reacquiring":
            return current
        if len(detections) != 1 or detections[0].get("confidence", 0) < .3:
            self.reacquire_candidate = None
            self.reacquire_confirmations = 0
            return self.snapshot(now)
        candidate = detections[0].get("box")
        if (not isinstance(candidate, list) or len(candidate) != 4
                or not all(type(value) in (int, float) and math.isfinite(value) for value in candidate)):
            return self.snapshot(now)
        x1, y1, x2, y2 = candidate
        width, height = x2-x1, y2-y1
        last_width = self.last_box[2]-self.last_box[0]
        last_height = self.last_box[3]-self.last_box[1]
        expected = self._expected_box(now)
        distance = min(
            math.hypot((x1+x2-expected[0]-expected[2])/2,
                       (y1+y2-expected[1]-expected[3])/2),
            math.hypot((x1+x2-self.last_box[0]-self.last_box[2])/2,
                       (y1+y2-self.last_box[1]-self.last_box[3])/2),
        )
        wide_search = now-(self.lost_at or now) >= self.wide_search_after
        plausible = (width >= 10 and height >= 10
                     and .4 <= width/last_width <= 2.5 and .4 <= height/last_height <= 2.5
                     and (wide_search or distance <= max(last_width, last_height)*3))
        if not plausible:
            self.reacquire_candidate = None
            self.reacquire_confirmations = 0
            return self.snapshot(now)
        rounded = [round(value) for value in candidate]
        previous = self.reacquire_candidate
        if previous:
            prior_width, prior_height = previous[2]-previous[0], previous[3]-previous[1]
            confirmation_distance = math.hypot(
                (rounded[0]+rounded[2]-previous[0]-previous[2])/2,
                (rounded[1]+rounded[3]-previous[1]-previous[3])/2,
            )
            consistent = (confirmation_distance <= max(prior_width, prior_height)*.5
                          and .5 <= width/prior_width <= 2
                          and .5 <= height/prior_height <= 2)
        else:
            consistent = False
        if consistent:
            self.reacquire_confirmations += 1
        else:
            self.reacquire_confirmations = 1
        self.reacquire_candidate = rounded
        if self.reacquire_confirmations < 2:
            return self.snapshot(now)
        tracker = self.tracker_factory()
        restart_box = (rounded[0], rounded[1], rounded[2]-rounded[0], rounded[3]-rounded[1])
        try:
            initialized = tracker.init(frame, restart_box)
        except Exception:
            return self.fail(f"Could not safely restart tracking the selected {self.category or 'object'}.")
        if initialized is False:
            return self.snapshot(now)
        self.tracker = tracker
        self.method = getattr(tracker, "name", "Visual tracker")
        self.status = "tracking"
        self.box = rounded
        self.box_at = now
        self.velocity = (0.0, 0.0)
        self.score = None
        target = self.category or "object"
        self.reason = f"Reacquired the selected {target} after two independent confirmations."
        return self.snapshot(now)

    def snapshot(self, now):
        if self.status == "reacquiring" and now >= self.reacquire_deadline:
            self._finish("lost", f"Could not safely reacquire the selected {self.category or 'object'}.")
        if self.status in {"tracking", "reacquiring"} and now-self.started_at >= self.max_duration:
            self._finish("complete", f"The {self.max_duration:g}-second prototype limit was reached. Select again to continue.")
        reason = self.reason
        search_scope = None
        if self.status == "reacquiring":
            wide = now-(self.lost_at or now) >= self.wide_search_after
            search_scope = "full_frame" if wide else "near_last_position"
            target = self.category or "object"
            reason = (f"Searching the entire view for the selected {target}; no target box is trusted."
                      if wide else
                      f"Searching near the last position for the selected {target}; no target box is trusted.")
        result = {"status": self.status, "box": self.box, "label": "Selected object", "reason": reason}
        if self.box is not None:
            result["box_age_ms"] = round((now-self.box_at)*1000, 1) if self.box_at is not None else None
        if self.category:
            result["category"] = self.category
            result["label"] = f"Selected {self.category}"
        if self.method:
            result["method"] = self.method
        if self.score is not None:
            result["score"] = self.score
        if self.visual_recovery:
            result["memory_views"] = len(self.memory)
        if search_scope:
            result["search_scope"] = search_scope
        return result

    def _finish(self, status, reason):
        self.tracker = None
        self.status = status
        self.box = None
        self.reason = reason
        self.reacquire_candidate = None
        self.reacquire_confirmations = 0
        return self.snapshot(self.started_at or 0)
