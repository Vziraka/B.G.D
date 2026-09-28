import unittest

import numpy as np

from bgd_vision.enrollment import GuidedEnrollment


def observation(yaw=0.0, pitch=0.5, **changes):
    value = dict(face_count=1, confidence=.95, face_height=.5,
                 center_x=.5, center_y=.5, yaw=yaw, pitch=pitch,
                 feature=np.zeros((1, 128), dtype=np.float32))
    value.update(changes)
    return value


class GuidedEnrollmentTests(unittest.TestCase):
    def setUp(self):
        self.enrollment = GuidedEnrollment()
        self.enrollment.start()

    def accept(self, item):
        self.enrollment.update(item)
        self.enrollment.update(item)

    def test_guidance_rejects_missing_multiple_small_and_off_center_faces(self):
        cases = [
            (observation(face_count=0), "No face found"),
            (observation(face_count=2), "Only one face"),
            (observation(face_height=.2), "Move closer"),
            (observation(center_x=.8), "Center your face"),
        ]
        for item, message in cases:
            self.enrollment.update(item)
            self.assertIn(message, self.enrollment.snapshot()["feedback"])
            self.assertEqual(self.enrollment.snapshot()["completed"], 0)

    def test_each_pose_requires_two_consecutive_good_observations(self):
        self.enrollment.update(observation())
        self.assertEqual(self.enrollment.snapshot()["completed"], 0)
        self.enrollment.update(observation(face_count=0))
        self.enrollment.update(observation())
        self.assertEqual(self.enrollment.snapshot()["completed"], 0)
        self.enrollment.update(observation())
        self.assertEqual(self.enrollment.snapshot()["completed"], 1)

    def test_relative_pose_sequence_completes_without_exposing_features(self):
        self.accept(observation())
        self.enrollment.update(observation(yaw=-.02))
        self.assertEqual(self.enrollment.snapshot()["completed"], 1)
        self.accept(observation(yaw=-.05))
        self.accept(observation(yaw=.05))
        self.accept(observation(pitch=.44))
        self.accept(observation(pitch=.56))
        result = self.enrollment.snapshot()
        self.assertEqual(result["status"], "complete")
        self.assertEqual(result["completed"], 5)
        self.assertNotIn("features", result)

    def test_cancel_and_failure_discard_temporary_features(self):
        self.accept(observation())
        self.enrollment.cancel()
        self.assertEqual(self.enrollment.features, [])
        self.enrollment.start()
        self.accept(observation())
        self.enrollment.fail("model failed")
        self.assertEqual(self.enrollment.features, [])
        self.assertEqual(self.enrollment.snapshot()["status"], "error")

    def test_evaluation_requires_all_pose_matches_and_returns_no_features(self):
        with self.assertRaisesRegex(ValueError, "Complete guided enrollment"):
            self.enrollment.evaluate(np.zeros((1, 128)), lambda *_: 1)
        self.accept(observation())
        self.accept(observation(yaw=-.05))
        self.accept(observation(yaw=.05))
        self.accept(observation(pitch=.44))
        self.accept(observation(pitch=.56))
        scores = iter([.8, .7, .6, .5, .4])
        result = self.enrollment.evaluate(np.ones((1, 128)), lambda *_: next(scores))
        self.assertTrue(result["passed"])
        self.assertEqual(result["median"], .6)
        self.assertNotIn("features", result)
        result = self.enrollment.evaluate(np.ones((1, 128)), lambda *_: .2)
        self.assertFalse(result["passed"])


if __name__ == "__main__":
    unittest.main()
