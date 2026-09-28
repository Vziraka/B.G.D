import importlib.util
import os
from pathlib import Path
import unittest

import numpy as np

from bgd_vision.generic_object import GenericObjectTracker, VitTracker


class Frame:
    shape = (100, 200, 3)


class WideFrame:
    shape = (100, 400, 3)


class SquareFrame:
    shape = (400, 400, 3)


class FakeTracker:
    def __init__(self, updates):
        self.updates = iter(updates)
        self.initial_box = None

    def init(self, frame, box):
        self.initial_box = box

    def update(self, frame):
        return next(self.updates)


class TrackerFactory:
    def __init__(self, *trackers):
        self.trackers = iter(trackers)

    def __call__(self):
        return next(self.trackers)


class GenericObjectTrackerTests(unittest.TestCase):
    def test_box_age_tracks_observation_time_and_clear_removes_it(self):
        tracker = GenericObjectTracker(lambda: FakeTracker([(True, (21, 12, 40, 30))]))
        tracker.select(Frame(), [20, 10, 60, 40], now=5)
        self.assertEqual(tracker.snapshot(5.8)['box_age_ms'], 800.)
        tracker.update(Frame(), now=6)
        self.assertEqual(tracker.snapshot(6.1)['box_age_ms'], 100.)
        tracker.clear()
        self.assertNotIn('box_age_ms', tracker.snapshot(7))

    def test_tracks_an_unknown_selected_region_without_a_category(self):
        backend = FakeTracker([(True, (21, 12, 40, 30))])
        tracker = GenericObjectTracker(lambda: backend, max_duration=30)

        tracker.select(Frame(), [20, 10, 60, 40], now=5)
        self.assertEqual(backend.initial_box, (20, 10, 40, 30))
        self.assertEqual(tracker.update(Frame(), now=5.1)['box'], [21, 12, 61, 42])
        self.assertEqual(tracker.snapshot(5.1)['status'], 'tracking')
        self.assertEqual(tracker.snapshot(5.1)['label'], 'Selected object')

    def test_rejects_tiny_regions_and_latches_loss_or_timeout(self):
        tracker = GenericObjectTracker(lambda: FakeTracker([(False, (0, 0, 0, 0))]), max_duration=30)
        with self.assertRaisesRegex(ValueError, 'at least 20 pixels'):
            tracker.select(Frame(), [1, 1, 10, 10], now=1)

        tracker.select(Frame(), [20, 10, 60, 40], now=2)
        self.assertEqual(tracker.update(Frame(), now=2.1)['status'], 'lost')
        self.assertIn('lost', tracker.snapshot(2.1)['reason'].lower())

        tracker = GenericObjectTracker(lambda: FakeTracker([]), max_duration=30)
        tracker.select(Frame(), [20, 10, 60, 40], now=3)
        self.assertEqual(tracker.snapshot(33.1)['status'], 'complete')
        self.assertIn('30-second', tracker.snapshot(33.1)['reason'])

    def test_rejects_gradual_growth_into_a_full_frame_box(self):
        backend = FakeTracker([
            (True, (0, 0, 60, 45)),
            (True, (0, 0, 90, 67)),
            (True, (0, 0, 135, 90)),
            (True, (0, 0, 190, 100)),
        ])
        tracker = GenericObjectTracker(lambda: backend)
        tracker.select(Frame(), [20, 10, 60, 40], now=1)

        self.assertEqual(tracker.update(Frame(), now=1.1)['status'], 'tracking')
        self.assertEqual(tracker.update(Frame(), now=1.2)['status'], 'tracking')
        result = tracker.update(Frame(), now=1.3)

        self.assertEqual(result['status'], 'lost')
        self.assertIsNone(result['box'])
        self.assertIn('expanded', result['reason'].lower())

    def test_clamps_selection_and_clear_discards_the_tracker(self):
        backend = FakeTracker([])
        tracker = GenericObjectTracker(lambda: backend)
        tracker.select(Frame(), [-5, -4, 240, 120], now=1)
        self.assertEqual(backend.initial_box, (0, 0, 200, 100))
        tracker.clear()
        self.assertEqual(tracker.snapshot(2), {'status':'idle', 'box':None,
                                               'label':'Selected object',
                                               'reason':'No object selected.'})

    def test_new_selection_discards_previous_category_and_visual_memory(self):
        frame = np.zeros((100, 200, 3), dtype=np.uint8)
        tracker = GenericObjectTracker(TrackerFactory(FakeTracker([]), FakeTracker([])))
        tracker.select(frame, [20, 10, 60, 40], now=1)
        tracker.associate_category('bottle', 39)
        tracker.enable_visual_recovery()

        result = tracker.select(frame, [80, 20, 120, 60], now=2)

        self.assertNotIn('category', result)
        self.assertFalse(tracker.visual_recovery)
        self.assertEqual(len(tracker.visual_memory()[1]), 1)

    def test_known_bottle_reacquires_only_after_two_near_detector_confirmations(self):
        first = FakeTracker([(False, (20, 10, 40, 30))])
        recovered = FakeTracker([])
        tracker = GenericObjectTracker(TrackerFactory(first, recovered))
        tracker.select(Frame(), [20, 10, 60, 40], now=1)
        tracker.associate_category('bottle', 39)

        lost = tracker.update(Frame(), now=1.1)
        self.assertEqual(lost['status'], 'reacquiring')
        self.assertIsNone(lost['box'])
        self.assertEqual(lost['category'], 'bottle')

        detection = {'box':[22, 11, 62, 41], 'confidence':.88}
        self.assertEqual(tracker.reacquire(Frame(), [detection], now=1.2)['status'], 'reacquiring')
        result = tracker.reacquire(
            Frame(), [{'box':[23.2, 12.1, 63.4, 42.2], 'confidence':.86}], now=1.4
        )

        self.assertEqual(result['status'], 'tracking')
        self.assertEqual(result['box'], [23, 12, 63, 42])
        self.assertTrue(all(type(value) is int for value in recovered.initial_box))
        self.assertEqual(recovered.initial_box, (23, 12, 40, 30))
        self.assertIn('reacquired', result['reason'].lower())

    def test_bottle_reacquisition_rejects_ambiguity_distance_and_timeout(self):
        tracker = GenericObjectTracker(
            TrackerFactory(FakeTracker([(False, (20, 10, 40, 30))])),
            reacquire_duration=2,
        )
        tracker.select(Frame(), [20, 10, 60, 40], now=1)
        tracker.associate_category('bottle', 39)
        tracker.update(Frame(), now=1.1)
        near = {'box':[22, 11, 62, 41], 'confidence':.9}
        far = {'box':[140, 60, 180, 90], 'confidence':.9}
        weak = {'box':[22, 11, 62, 41], 'confidence':.29}

        self.assertEqual(tracker.reacquire(Frame(), [near, far], now=1.2)['status'], 'reacquiring')
        self.assertEqual(tracker.reacquire(Frame(), [far], now=1.3)['status'], 'reacquiring')
        self.assertEqual(tracker.reacquire(Frame(), [weak], now=1.4)['status'], 'reacquiring')
        result = tracker.reacquire(Frame(), [near], now=3.2)

        self.assertEqual(result['status'], 'lost')
        self.assertIsNone(result['box'])
        self.assertIn('reacquire', result['reason'].lower())

    def test_detector_correction_restarts_a_drifting_known_bottle_but_rejects_full_frame(self):
        original, corrected = FakeTracker([]), FakeTracker([])
        tracker = GenericObjectTracker(TrackerFactory(original, corrected))
        tracker.select(Frame(), [20, 10, 60, 40], now=1)
        tracker.associate_category('bottle', 39)

        unsafe = {'box':[0, 0, 200, 100], 'confidence':.9}
        self.assertEqual(tracker.correct(Frame(), [unsafe], now=1.1)['box'], [20, 10, 60, 40])
        weak = {'box':[45, 12, 85, 42], 'confidence':.29}
        self.assertEqual(tracker.correct(Frame(), [weak], now=1.1)['box'], [20, 10, 60, 40])
        self.assertEqual(tracker.correct(Frame(), [weak, unsafe], now=1.1)['box'], [20, 10, 60, 40])
        detection = {'box':[45.2, 11.7, 85.4, 42.1], 'confidence':.8}
        result = tracker.correct(Frame(), [detection], now=1.2)

        self.assertEqual(result['status'], 'tracking')
        self.assertEqual(result['box'], [45, 12, 85, 42])
        self.assertEqual(corrected.initial_box, (45, 12, 40, 30))
        self.assertIn('corrected', result['reason'].lower())

    def test_visual_correction_requires_two_consistent_confirmations(self):
        original, corrected = FakeTracker([]), FakeTracker([])
        tracker = GenericObjectTracker(TrackerFactory(original, corrected))
        tracker.select(Frame(), [20, 10, 60, 40], now=1)
        tracker.enable_visual_recovery()
        detection = {'box':[45, 12, 85, 42], 'confidence':.9}

        first = tracker.correct(Frame(), [detection], now=1.1)
        result = tracker.correct(Frame(), [detection], now=1.2)

        self.assertEqual(first['box'], [20, 10, 60, 40])
        self.assertEqual(result['box'], [45, 12, 85, 42])
        self.assertEqual(corrected.initial_box, (45, 12, 40, 30))

    def test_reacquisition_uses_recent_motion_to_accept_a_fast_near_path_candidate(self):
        moving = FakeTracker([(True, (60, 10, 40, 30)), (False, (60, 10, 40, 30))])
        recovered = FakeTracker([])
        tracker = GenericObjectTracker(TrackerFactory(moving, recovered))
        tracker.select(WideFrame(), [20, 10, 60, 40], now=1)
        tracker.associate_category('bottle', 39)
        tracker.update(WideFrame(), now=1.1)
        self.assertEqual(tracker.update(WideFrame(), now=1.2)['status'], 'reacquiring')
        candidate = {'box':[230, 10, 270, 40], 'confidence':.8}

        self.assertEqual(tracker.reacquire(WideFrame(), [candidate], now=1.5)['status'], 'reacquiring')
        result = tracker.reacquire(WideFrame(), [candidate], now=1.7)

        self.assertEqual(result['status'], 'tracking')
        self.assertEqual(recovered.initial_box, (230, 10, 40, 30))

    def test_reacquisition_also_accepts_return_to_last_box_when_prediction_points_away(self):
        moving = FakeTracker([(True, (280, 280, 40, 40)), (False, (280, 280, 40, 40))])
        recovered = FakeTracker([])
        tracker = GenericObjectTracker(TrackerFactory(moving, recovered))
        tracker.select(SquareFrame(), [20, 20, 60, 60], now=1)
        tracker.associate_category('bottle', 39)
        tracker.update(SquareFrame(), now=1.1)
        tracker.update(SquareFrame(), now=1.2)
        returned = {'box':[280, 280, 320, 320], 'confidence':.8}

        tracker.reacquire(SquareFrame(), [returned], now=1.5)
        result = tracker.reacquire(SquareFrame(), [returned], now=1.7)

        self.assertEqual(result['status'], 'tracking')
        self.assertEqual(recovered.initial_box, (280, 280, 40, 40))

    def test_default_recovery_window_widens_then_stays_bounded(self):
        tracker = GenericObjectTracker(lambda: FakeTracker([(False, (20, 10, 40, 30))]))
        tracker.select(Frame(), [20, 10, 60, 40], now=1)
        tracker.associate_category('bottle', 39)
        tracker.update(Frame(), now=1.1)

        self.assertEqual(tracker.snapshot(3.2)['status'], 'reacquiring')
        self.assertEqual(tracker.snapshot(3.2)['search_scope'], 'full_frame')
        self.assertEqual(tracker.snapshot(11.2)['status'], 'lost')

    def test_full_frame_stage_can_recover_far_target_but_near_stage_cannot(self):
        first = FakeTracker([(False, (20, 10, 40, 30))])
        recovered = FakeTracker([])
        tracker = GenericObjectTracker(TrackerFactory(first, recovered))
        tracker.select(WideFrame(), [20, 10, 60, 40], now=1)
        tracker.enable_visual_recovery()
        tracker.update(WideFrame(), now=1.1)
        far = {'box':[300, 20, 340, 50], 'confidence':.9}

        self.assertEqual(tracker.reacquire(WideFrame(), [far], now=1.5)['status'], 'reacquiring')
        self.assertEqual(tracker.reacquire_confirmations, 0)
        tracker.reacquire(WideFrame(), [far], now=2.7)
        result = tracker.reacquire(WideFrame(), [far], now=2.9)

        self.assertEqual(result['status'], 'tracking')
        self.assertEqual(recovered.initial_box, (300, 20, 40, 30))

    def test_visual_memory_keeps_diverse_temporary_views_only(self):
        frame = np.zeros((100, 200, 3), dtype=np.uint8)
        frame[10:40, 20:60] = (20, 80, 220)
        moved = frame.copy()
        moved[10:40, 20:60] = (220, 80, 20)
        tracker = GenericObjectTracker(lambda: FakeTracker([]))
        tracker.select(frame, [20, 10, 60, 40], now=1)
        tracker.enable_visual_recovery()

        tracker._remember(frame, [20, 10, 60, 40], now=2)
        tracker._remember(moved, [20, 10, 60, 40], now=3)
        version, views = tracker.visual_memory()

        self.assertEqual(version, 2)
        self.assertEqual(len(views), 2)
        self.assertNotIn('signature', views[0])

    @unittest.skipUnless(importlib.util.find_spec('cv2'), 'OpenCV runs on the Pi runtime')
    def test_default_template_tracker_follows_a_textured_unknown_region(self):
        texture = np.random.default_rng(4).integers(0, 256, (30, 40, 3), dtype=np.uint8)
        first = np.zeros((100, 160, 3), dtype=np.uint8)
        moved = first.copy()
        first[20:50, 30:70] = texture
        moved[26:56, 42:82] = texture
        tracker = GenericObjectTracker(max_duration=30)
        tracker.select(first, [30, 20, 70, 50], now=1)
        self.assertEqual(tracker.update(moved, now=1.1)['box'], [42, 26, 82, 56])

    @unittest.skipUnless(importlib.util.find_spec('cv2'), 'OpenCV runs on the Pi runtime')
    def test_unknown_region_survives_a_small_toward_camera_scale_change(self):
        import cv2
        texture = np.random.default_rng(7).integers(0, 256, (40, 50, 3), dtype=np.uint8)
        first = np.zeros((140, 220, 3), dtype=np.uint8)
        closer = first.copy()
        first[45:85, 70:120] = texture
        grown = cv2.resize(texture, (58, 46), interpolation=cv2.INTER_LINEAR)
        closer[42:88, 66:124] = grown
        tracker = GenericObjectTracker(max_duration=30)
        tracker.select(first, [70, 45, 120, 85], now=1)

        result = tracker.update(closer, now=1.1)

        self.assertEqual(result['status'], 'tracking')
        self.assertGreaterEqual(result['box'][2]-result['box'][0], 55,
                                'Moving closer must grow the tracked box instead of using a fixed-size template')

    @unittest.skipUnless(
        importlib.util.find_spec('cv2') and Path(os.environ.get('BGD_VITTRACK_MODEL', 'missing')).is_file(),
        'ViTTrack integration runs with the candidate model on the Pi',
    )
    def test_vittrack_backend_handles_scale_change_and_reports_confidence(self):
        import cv2
        model = Path(os.environ['BGD_VITTRACK_MODEL'])
        first = np.full((300, 500, 3), 160, np.uint8)
        closer = first.copy()
        target = np.full((120, 70, 3), (190, 120, 60), np.uint8)
        cv2.rectangle(target, (5, 5), (64, 114), (30, 220, 220), 4)
        cv2.circle(target, (35, 38), 20, (220, 40, 80), -1)
        cv2.putText(target, 'BGD', (8, 95), cv2.FONT_HERSHEY_SIMPLEX, .7, (255, 255, 255), 2)
        first[90:210, 180:250] = target
        closer[80:218, 170:250] = cv2.resize(target, (80, 138))
        tracker = GenericObjectTracker(lambda: VitTracker(model))
        tracker.select(first, [180, 90, 250, 210], now=1)

        result = tracker.update(closer, now=1.1)

        self.assertEqual(result['status'], 'tracking')
        self.assertGreaterEqual(result['box'][2]-result['box'][0], 75)
        self.assertGreater(result['score'], .5)
        self.assertEqual(result['method'], 'OpenCV ViTTrack')

    @unittest.skipUnless(
        importlib.util.find_spec('cv2') and Path(os.environ.get('BGD_VITTRACK_MODEL', 'missing')).is_file(),
        'ViTTrack integration runs with the candidate model on the Pi',
    )
    def test_vittrack_backend_handles_fast_translation_with_intermediate_frames(self):
        import cv2
        model = Path(os.environ['BGD_VITTRACK_MODEL'])
        target = np.full((120, 70, 3), (190, 120, 60), np.uint8)
        cv2.rectangle(target, (5, 5), (64, 114), (30, 220, 220), 4)
        cv2.circle(target, (35, 38), 20, (220, 40, 80), -1)
        cv2.putText(target, 'BGD', (8, 95), cv2.FONT_HERSHEY_SIMPLEX, .7, (255, 255, 255), 2)

        def frame(x):
            image = np.full((300, 600, 3), 160, np.uint8)
            image[90:210, x:x+70] = target
            return image

        tracker = GenericObjectTracker(lambda: VitTracker(model))
        tracker.select(frame(100), [100, 90, 170, 210], now=1)
        result = None
        for index in range(1, 7):
            result = tracker.update(frame(100+25*index), now=1+index/30)

        self.assertEqual(result['status'], 'tracking')
        self.assertGreater(result['score'], .7)
        self.assertGreaterEqual(result['box'][0], 240)


if __name__ == '__main__':
    unittest.main()
