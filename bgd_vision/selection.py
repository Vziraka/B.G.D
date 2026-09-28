"""Bounded target recovery. Callers serialize access and use exposure timestamps."""

import math
from collections import deque


def _similarity(a, b):
    if not a or not b or len(a) != len(b):
        return -1
    if not all(math.isfinite(v) for v in (*a, *b)):
        return -1
    denominator = math.sqrt(sum(v*v for v in a) * sum(v*v for v in b))
    return sum(x*y for x, y in zip(a, b)) / denominator if denominator else -1


def _iou(a, b):
    intersection = max(0, min(a[2], b[2]) - max(a[0], b[0])) * max(
        0, min(a[3], b[3]) - max(a[1], b[1])
    )
    union = ((a[2] - a[0]) * (a[3] - a[1])
             + (b[2] - b[0]) * (b[3] - b[1]) - intersection)
    return intersection / union if union > 0 else 0


class TargetSelection:
    """A tracker ID is a tentative association, never a person's identity."""

    def __init__(self, freshness_limit=0.75, *, recovery_enabled=False, recovery_window=3.0,
                 search_window=None):
        if freshness_limit <= 0:
            raise ValueError("freshness_limit must be positive")
        self.freshness_limit = freshness_limit
        # Explicit opt-in; default callers remain conservative.
        self.recovery_enabled = recovery_enabled
        if recovery_window <= 0:
            raise ValueError("recovery_window must be positive")
        self.recovery_window = recovery_window
        if search_window is not None and (not math.isfinite(search_window) or search_window < recovery_window):
            raise ValueError("search_window must be finite and at least recovery_window")
        self.search_window = search_window
        self.tracks = []
        self.latest_at = None
        self.clear()

    def clear(self):
        self.selected_id = None
        self.status = "No target selected"
        self.reason = ""
        self.reference = None
        self.last_box = None
        self.checking_at = None
        self.candidate_id = None
        self.candidate_at = None
        self.candidate_frames = 0
        self.candidate_soft_frames = 0
        self.candidate_last_at = None
        self.candidate_box = None
        self.solo_search = False
        self.diagnostics = {}
        self.other_references = {}
        self.motion = deque(maxlen=8)
        self.isolated_since_selection = False
        self.isolated_pose = False
        self.isolated_box = None

    def _lose(self, reason):
        self.status = "Lost"
        self.reason = reason
        self.reference = None
        self.other_references = {}
        self.isolated_pose = False
        self.diagnostics = {**self.diagnostics, "outcome": "lost", "loss_reason": reason}

    def _fresh(self, now):
        return self.latest_at is not None and 0 <= now - self.latest_at <= self.freshness_limit

    def _expire(self, now):
        if self.status in {"Tracking", "Temporarily hidden", "Searching"} and not self._fresh(now):
            self._lose("Tracking updates are stale")
        elif self.status in {"Temporarily hidden", "Searching"}:
            elapsed = now - self.checking_at
            if elapsed >= (self.search_window or self.recovery_window):
                self._lose("Recovery timed out: " + self.diagnostics.get("gate", "no confirmed match") + "; select again")
            elif self.status == "Temporarily hidden" and elapsed >= self.recovery_window:
                self.status = "Searching"
                self.isolated_pose = False
                self.candidate_id = None
                self.candidate_frames = 0
                self.reason = "Searching for the selected person; waiting for a clear match"

    def _ambiguous(self, track):
        return any(other["id"] != track["id"] and _iou(track["box"], other["box"]) >= 0.3
                   for other in self.tracks)

    def _near(self, track):
        a, b = self.last_box, track["box"]
        width, height = max(1, a[2]-a[0]), max(1, a[3]-a[1])
        offset = [0.0, 0.0]
        uncertainty = [0.0, 0.0]
        if len(self.motion) >= 3 and self.motion[-1][0] - self.motion[0][0] >= 0.15:
            times = [sample[0] - self.motion[-1][0] for sample in self.motion]
            mean_time = sum(times) / len(times)
            variance = sum((t-mean_time)**2 for t in times)
            elapsed = max(0, self.latest_at-self.motion[-1][0])
            for axis, scale in enumerate((width, height/2)):
                values = [sample[axis+1] for sample in self.motion]
                mean_value = sum(values)/len(values)
                speed = sum((t-mean_time)*(v-mean_value) for t, v in zip(times, values))/variance
                # Bound prediction to two base radii, at most two radii/second.
                speed = max(-2*scale, min(2*scale, speed))
                offset[axis] = max(-2*scale, min(2*scale, speed*elapsed))
                residual = math.sqrt(sum((v-mean_value-speed*(t-mean_time))**2
                                         for t, v in zip(times, values))/len(values))
                uncertainty[axis] = min(0.25*scale, 2*residual)
        return (abs((a[0]+a[2]-b[0]-b[2])/2 + offset[0]) <= width + uncertainty[0]
                and abs((a[1]+a[3]-b[1]-b[3])/2 + offset[1]) <= height/2 + uncertainty[1]
                and 0.5 <= (b[3]-b[1])/height <= 2)

    def _observe_motion(self, box, now, *, reset=False):
        if reset:
            self.motion.clear()
        if self.motion and now <= self.motion[-1][0]:
            return
        self.motion.append((now, (box[0]+box[2])/2, (box[1]+box[3])/2))
        while self.motion and now-self.motion[0][0] > self.freshness_limit:
            self.motion.popleft()

    def _remember_others(self):
        # Keep pre-crossing competitors even while they are hidden; never overwrite
        # their templates using possibly switched tracker IDs during a crossing.
        for other in self.tracks:
            feature = other.get("appearance")
            if (other["id"] != self.selected_id and not self._ambiguous(other)
                    and len(self.other_references) < 32
                    and _similarity(feature, feature) > 0.99):
                self.other_references.setdefault(other["id"], list(feature))

    def _check(self, now, trigger="overlap or appearance change", *, solo_search=False):
        if not self.recovery_enabled:
            self.diagnostics = {"trigger": trigger, "gate": "automatic recovery disabled"}
            self._lose("Target uncertain; automatic recovery paused. Select the person again.")
            return
        self.status = "Temporarily hidden"
        self.reason = "Brief overlap or appearance change; checking the selected person"
        self.checking_at = now
        self.candidate_id = None
        self.candidate_frames = 0
        self.candidate_soft_frames = 0
        self.solo_search = solo_search
        self.isolated_pose = (trigger == "appearance change"
                              and self.isolated_since_selection and not self.other_references
                              and self._near(self.tracks[0])
                              and _iou(self.last_box, self.tracks[0]["box"]) >= 0.1)
        self.isolated_box = list(self.tracks[0]["box"]) if self.isolated_pose else None
        if self.isolated_pose:
            trigger = "isolated appearance change"
            self.reason = "Selected person changed appearance; checking continuous movement"
        self.diagnostics = {"trigger": trigger, "gate": "waiting for a clear match", "outcome": "checking"}
        if trigger == "selected person left view":
            self.status = "Searching"
            self.reason = "Searching for the selected person; no confirmed match"

    def _recover(self, now):
        searching = self.status == "Searching"
        if len(self.tracks) > 1:
            # A newly seen competitor has no trusted pre-disappearance reference.
            self.solo_search = False
        if self.isolated_pose:
            continuous = (self.isolated_since_selection and len(self.tracks) == 1
                          and self.tracks[0]["id"] == self.selected_id
                          and self._near(self.tracks[0])
                          and _iou(self.isolated_box, self.tracks[0]["box"]) >= 0.1)
            if not continuous:
                # This exception cannot turn a disappearance/crossing into pose recovery.
                self.isolated_pose = False
                self.isolated_since_selection = False
            else:
                self.isolated_box = list(self.tracks[0]["box"])
        # Compare against every visible person: a similar alternative vetoes recovery.
        ranked = sorted(((_similarity(self.reference, t.get("appearance")), t)
                         for t in self.tracks), key=lambda item: item[0], reverse=True)
        candidate = ranked[0][1] if ranked else None
        score = ranked[0][0] if ranked else -1
        margin = ranked[0][0] - ranked[1][0] if len(ranked) > 1 else None
        competitor = max((_similarity(candidate.get("appearance"), reference)
                          for reference in self.other_references.values()), default=-1) if candidate else -1
        remembered_margin = score - competitor
        gate = ("no candidate" if candidate is None else
                "waiting for both people to separate" if len(ranked) < 2 and not (self.isolated_pose or self.solo_search) else
                "no pre-crossing comparison available" if not self.other_references and not (self.isolated_pose or self.solo_search) else
                "appearance mismatch" if score < 0.80 else
                "candidate resembles another person" if remembered_margin < 0.08 else
                "people look too similar" if margin is not None and margin < 0.08 else
                "candidate too far away" if not self._near(candidate) else
                "people still overlap" if self._ambiguous(candidate) else
                "appearance mismatch" if score < (0.95 if searching else 0.90) else "confirming stable match")
        self.diagnostics.update(gate=gate, similarity=round(score, 3),
                                margin=round(margin, 3) if margin is not None else None,
                                elapsed_ms=round((now-self.checking_at)*1000),
                                visible_people=len(self.tracks))
        self.diagnostics["remembered_margin"] = round(remembered_margin, 3)
        self.reason = self.status + ": " + gate
        if gate != "confirming stable match":
            # One borderline crop may interrupt strong evidence, but is never
            # positive evidence itself. Every spatial/competitor gate still applies.
            if (not searching and gate == "appearance mismatch" and 0.80 <= score < 0.90
                    and candidate["id"] == self.candidate_id
                    and self.candidate_at is not None and now-self.candidate_at <= 0.5
                    and self.candidate_soft_frames == 0):
                self.candidate_soft_frames = 1
                return
            self.candidate_id = None
            self.candidate_frames = 0
            self.candidate_soft_frames = 0
            return
        if (self.candidate_id != candidate["id"] or now-self.candidate_at > 0.5
                or (searching and self.candidate_box is not None
                    and _iou(self.candidate_box, candidate["box"]) < 0.1)):
            self.candidate_id = candidate["id"]
            self.candidate_at = now
            self.candidate_frames = 0
            self.candidate_soft_frames = 0
            self.candidate_last_at = None
        if self.candidate_last_at is not None and now <= self.candidate_last_at:
            return
        self.candidate_last_at = now
        self.candidate_box = list(candidate["box"])
        self.candidate_frames += 1
        if self.candidate_frames >= (5 if searching else 3) and now - self.candidate_at >= (0.35 if searching else 0.15):
            self.selected_id = candidate["id"]
            self.last_box = list(candidate["box"])
            self._observe_motion(candidate["box"], now, reset=True)
            self.status = "Tracking"
            self.reason = "Selected person recovered after " + ("bounded search" if searching else "a brief interruption")
            self.diagnostics.update(outcome="recovered", gate="confirmed")

    def update(self, tracks, now):
        self._expire(now)
        solo_departure = self.isolated_since_selection and not tracks
        self.tracks = [{**track, "box": list(track["box"])} for track in tracks]
        self.latest_at = now
        if len(self.tracks) != 1 or self.tracks[0]["id"] != self.selected_id:
            self.isolated_since_selection = False
        if self.status in {"Temporarily hidden", "Searching"}:
            self._recover(now)
            return
        if self.status != "Tracking":
            return
        track = next((t for t in self.tracks if t["id"] == self.selected_id), None)
        if track is None:
            # A merged detection can drop the selected ID before two boxes overlap.
            # Only a nearby overlapping person permits this bounded recovery attempt.
            if self.reference and any(_iou(self.last_box, t["box"]) >= 0.1 and self._near(t)
                                      for t in self.tracks):
                self._check(now, "selected ID disappeared behind a nearby person")
            elif self.reference and self.search_window is not None:
                self._check(now, "selected person left view", solo_search=solo_departure)
            else:
                self._lose("Selected target is no longer visible")
        elif self._ambiguous(track):
            if self.reference:
                self._check(now)
            else:
                self._lose("Crossing ambiguity")
        elif self.reference and _similarity(self.reference, track.get("appearance")) < 0.80:
            self._check(now, "appearance change")
        elif self.reference and any(
                _similarity(self.reference, track.get("appearance")) -
                _similarity(other, track.get("appearance")) < 0.08
                for other in self.other_references.values()):
            self._check(now, "selected ID resembles a remembered other person")
        else:
            self.last_box = list(track["box"])
            self._observe_motion(track["box"], now)
            # Slowly adapt only on clear, matching frames; freeze during uncertainty.
            if self.reference and track.get("appearance"):
                self.reference = [0.95*a + 0.05*b for a, b in zip(self.reference, track["appearance"])]
            self._remember_others()

    def select(self, track_id, now):
        self._expire(now)
        track = next((t for t in self.tracks if t["id"] == track_id), None)
        if not self._fresh(now) or track is None or self._ambiguous(track):
            return False
        self.selected_id = track_id
        self.status = "Tracking"
        self.reason = ""
        appearance = track.get("appearance")
        self.reference = list(appearance) if _similarity(appearance, appearance) > 0.99 else None
        self.last_box = list(track["box"])
        self._observe_motion(track["box"], self.latest_at, reset=True)
        self.diagnostics = {}
        self.other_references = {}
        self.isolated_since_selection = len(self.tracks) == 1
        self.isolated_pose = False
        self.isolated_box = None
        self._remember_others()
        return True

    def snapshot(self, now):
        self._expire(now)
        return {"status": self.status, "selected_id": self.selected_id, "reason": self.reason}
