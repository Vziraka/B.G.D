"""In-memory guided face enrollment; never an authorization or liveness result."""

from statistics import median


class GuidedEnrollment:
    demo_match_threshold = 0.363
    stages = (
        ("center", "Look straight at the camera"),
        ("left", "Turn toward the left side of the video"),
        ("right", "Turn toward the right side of the video"),
        ("up", "Tilt your face slightly up"),
        ("down", "Tilt your face slightly down"),
    )

    def __init__(self):
        self.cancel()

    def start(self):
        self.active = True
        self.complete = False
        self.error = None
        self.index = 0
        self.streak = 0
        self.feedback = "Center one face inside the guide"
        self.neutral = None
        self.features = []

    def cancel(self):
        self.active = False
        self.complete = False
        self.error = None
        self.index = 0
        self.streak = 0
        self.feedback = "Enrollment has not started"
        self.neutral = None
        self.features = []

    def fail(self, message):
        self.active = False
        self.complete = False
        self.error = str(message)
        self.feedback = self.error
        self.features = []

    def snapshot(self):
        stage, prompt = self.stages[min(self.index, len(self.stages) - 1)]
        status = "error" if self.error else "complete" if self.complete else "active" if self.active else "idle"
        return {
            "status": status,
            "stage": stage if self.active else None,
            "prompt": "Enrollment complete" if self.complete else prompt if self.active else "Start guided enrollment when ready",
            "feedback": self.feedback,
            "completed": len(self.features),
            "total": len(self.stages),
        }

    def update(self, observation):
        if not self.active:
            return
        count = observation.get("face_count", 0)
        if count != 1:
            self.streak = 0
            self.feedback = "No face found" if count == 0 else "Only one face may be visible"
            return
        if observation.get("confidence", 0) < 0.9:
            self.streak = 0
            self.feedback = "Hold still until your face is clear"
            return
        if observation.get("face_height", 0) < 0.30:
            self.streak = 0
            self.feedback = "Move closer"
            return
        if observation.get("face_height", 1) > 0.75:
            self.streak = 0
            self.feedback = "Move back"
            return
        if abs(observation.get("center_x", 0) - 0.5) > 0.20 or abs(observation.get("center_y", 0) - 0.5) > 0.20:
            self.streak = 0
            self.feedback = "Center your face inside the guide"
            return

        stage = self.stages[self.index][0]
        yaw, pitch = observation["yaw"], observation["pitch"]
        if stage == "center":
            pose_ok = True
        else:
            base_yaw, base_pitch = self.neutral
            pose_ok = {
                "left": yaw <= base_yaw - 0.035,
                "right": yaw >= base_yaw + 0.035,
                "up": pitch <= base_pitch - 0.05,
                "down": pitch >= base_pitch + 0.05,
            }[stage]
        if not pose_ok:
            self.streak = 0
            self.feedback = self.stages[self.index][1]
            return

        self.streak += 1
        self.feedback = "Hold that position"
        if self.streak < 2:
            return
        if stage == "center":
            self.neutral = (yaw, pitch)
        self.features.append(observation["feature"].copy())
        self.index += 1
        self.streak = 0
        if self.index == len(self.stages):
            self.active = False
            self.complete = True
            self.feedback = "Five temporary faceprints captured in memory"
        else:
            self.feedback = self.stages[self.index][1]

    def evaluate(self, query_feature, compare):
        """Compare one transient query to every enrolled pose; never authorize."""
        if not self.complete or len(self.features) != len(self.stages):
            raise ValueError("Complete guided enrollment before checking a face")
        scores = [float(compare(reference, query_feature)) for reference in self.features]
        return {
            "minimum": round(min(scores), 3),
            "median": round(median(scores), 3),
            "maximum": round(max(scores), 3),
            "threshold": self.demo_match_threshold,
            "passed": all(score >= self.demo_match_threshold for score in scores),
        }
