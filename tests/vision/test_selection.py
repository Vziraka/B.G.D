import unittest

from bgd_vision.selection import TargetSelection


def person(track_id=1, box=(0, 0, 10, 10)):
    return {"id": track_id, "box": list(box), "confidence": 0.9}


class TargetSelectionTests(unittest.TestCase):
    def setUp(self):
        self.selection = TargetSelection()
        self.selection.update([person()], 10)
        self.assertTrue(self.selection.select(1, 10))

    def test_missing_target_latches_loss_even_when_same_id_returns(self):
        self.selection.update([], 10.1)
        self.selection.update([person()], 10.2)
        state = self.selection.snapshot(10.2)
        self.assertEqual(state["status"], "Lost")
        self.assertEqual(state["selected_id"], 1)
        self.assertTrue(self.selection.select(1, 10.2))
        self.assertEqual(self.selection.snapshot(10.2)["status"], "Tracking")

    def test_stale_snapshot_latches_loss_and_rejects_selection(self):
        self.assertEqual(self.selection.snapshot(10.75)["status"], "Tracking")
        self.assertEqual(self.selection.snapshot(10.751)["status"], "Lost")
        self.assertFalse(self.selection.select(1, 10.751))
        self.selection.update([person()], 10.8)
        self.assertEqual(self.selection.snapshot(10.8)["status"], "Lost")

    def test_inference_gap_is_not_hidden_by_next_update(self):
        self.selection.update([person()], 11)
        self.assertEqual(self.selection.snapshot(11)["status"], "Lost")

    def test_crossing_latches_loss_and_prevents_ambiguous_selection(self):
        self.selection.update([person(), person(2, (4, 0, 14, 10))], 10.1)
        state = self.selection.snapshot(10.1)
        self.assertEqual(state["status"], "Lost")
        self.assertEqual(state["reason"], "Crossing ambiguity")
        self.assertFalse(self.selection.select(1, 10.1))
        self.assertFalse(self.selection.select(2, 10.1))
        self.selection.update([person(), person(2, (20, 0, 30, 10))], 10.2)
        self.assertEqual(self.selection.snapshot(10.2)["status"], "Lost")

    def test_separate_people_do_not_interrupt_tracking(self):
        self.selection.update([person(), person(2, (20, 0, 30, 10))], 10.1)
        self.assertEqual(self.selection.snapshot(10.1)["status"], "Tracking")
        self.assertTrue(self.selection.select(2, 10.1))
        self.assertEqual(self.selection.snapshot(10.1)["selected_id"], 2)

    def test_invalid_selection_and_clear(self):
        self.assertFalse(self.selection.select(99, 10.1))
        self.assertEqual(self.selection.snapshot(10.1)["selected_id"], 1)
        self.selection.clear()
        self.assertEqual(self.selection.snapshot(20), {
            "status": "No target selected", "selected_id": None, "reason": ""})
        self.assertFalse(TargetSelection().select(1, 0))

    def test_custom_freshness_limit(self):
        selection = TargetSelection(freshness_limit=0.1)
        selection.update([person()], 0)
        self.assertTrue(selection.select(1, 0))
        self.assertEqual(selection.snapshot(0.11)["status"], "Lost")


def appearance_person(track_id=1, appearance=(1.0, 0.0), box=(0, 0, 10, 10)):
    return dict(person(track_id, box), appearance=appearance)


class AppearanceRecoveryTests(unittest.TestCase):
    def setUp(self):
        self.selection = TargetSelection(recovery_enabled=True, recovery_window=0.9)
        self.selection.update([appearance_person(), appearance_person(2, (0., 1.), (30, 0, 40, 10))], 0)
        self.assertTrue(self.selection.select(1, 0))

    def test_live_default_disables_recovery_even_for_perfect_match(self):
        selection = TargetSelection()
        selection.update([appearance_person()], 0)
        self.assertTrue(selection.select(1, 0))
        selection.update([appearance_person(2, box=(2, 0, 12, 10))], 0.1)
        for now in (0.2, 0.3, 0.4):
            selection.update([appearance_person(2)], now)
        self.assertEqual(selection.status, "Lost")
        self.assertEqual(selection.selected_id, 1)

    def overlap(self):
        self.selection.update([
            appearance_person(),
            appearance_person(2, (0.0, 1.0), (4, 0, 14, 10)),
        ], 0.1)
        self.assertEqual(self.selection.snapshot(0.1)["status"], "Temporarily hidden")

    def test_dropped_id_during_crossing_can_recover_without_prior_overlap(self):
        self.selection.update([appearance_person(2, (0., 1.), (2, 0, 12, 10))], 0.1)
        self.assertEqual(self.selection.status, "Temporarily hidden")
        for now in (0.2, 0.3, 0.4):
            self.selection.update([appearance_person(), appearance_person(2, (0., 1.), (30, 0, 40, 10))], now)
        self.assertEqual(self.selection.status, "Tracking")
        self.assertEqual(self.selection.selected_id, 1)

    def test_dropped_id_cannot_select_occluder_and_timeout_explains_rejection(self):
        occluder = appearance_person(2, (0., 1.), (2, 0, 12, 10))
        for now in (0.1, 0.2, 0.4, 0.6, 0.8, 1.0):
            self.selection.update([occluder], now)
        self.assertEqual(self.selection.status, "Lost")
        self.assertIn("waiting for both people", self.selection.reason)
        self.assertEqual(self.selection.selected_id, 1)
        self.assertNotIn("appearance", self.selection.diagnostics)

    def test_exit_without_nearby_occluder_still_latches_immediately(self):
        self.selection.update([appearance_person(2, (0., 1.), (30, 0, 40, 10))], 0.1)
        self.assertEqual(self.selection.status, "Lost")
        self.selection.update([appearance_person()], 0.2)
        self.assertEqual(self.selection.status, "Lost")

    def test_original_id_recovers_after_both_people_separate(self):
        self.overlap()
        for now in (0.2, 0.3):
            self.selection.update([appearance_person(), appearance_person(2, (0., 1.), (30, 0, 40, 10))], now)
            self.assertEqual(self.selection.snapshot(now)["status"], "Temporarily hidden")
        self.selection.update([appearance_person(), appearance_person(2, (0., 1.), (30, 0, 40, 10))], 0.4)
        self.assertEqual(self.selection.snapshot(0.4)["status"], "Tracking")
        self.assertEqual(self.selection.snapshot(0.4)["selected_id"], 1)

    def test_three_fast_frames_do_not_bypass_minimum_duration(self):
        self.overlap()
        for now in (0.2, 0.21, 0.22):
            self.selection.update([appearance_person(), appearance_person(2, (0., 1.), (30, 0, 40, 10))], now)
        self.assertEqual(self.selection.snapshot(0.22)["status"], "Temporarily hidden")

    def test_wrong_appearance_and_similar_alternative_veto_recovery(self):
        self.overlap()
        for now in (0.2, 0.3, 0.4):
            self.selection.update([appearance_person(1, (0.85, 0.527)),
                                   appearance_person(2, (0., 1.), (30, 0, 40, 10))], now)
        self.assertEqual(self.selection.snapshot(0.4)["status"], "Temporarily hidden")
        self.assertEqual(self.selection.diagnostics["gate"], "appearance mismatch")
        for now in (0.5, 0.6, 0.7):
            self.selection.update([
                appearance_person(1),
                appearance_person(8, (0.99, 0.01), (30, 0, 40, 10)),
            ], now)
        self.assertEqual(self.selection.snapshot(0.7)["status"], "Temporarily hidden")
        self.assertEqual(self.selection.diagnostics["gate"], "people look too similar")

    def test_matching_but_distant_candidate_does_not_recover(self):
        self.overlap()
        for now in (0.2, 0.3, 0.4):
            self.selection.update([appearance_person(1, box=(100, 0, 110, 10)),
                                   appearance_person(2, (0., 1.), (30, 0, 40, 10))], now)
        self.assertEqual(self.selection.snapshot(0.4)["status"], "Temporarily hidden")
        self.assertEqual(self.selection.diagnostics["gate"], "candidate too far away")

    def test_timeout_is_absolute_despite_new_candidates_and_never_revives(self):
        self.overlap()
        for index, now in enumerate((0.2, 0.4, 0.6, 0.8)):
            self.selection.update([appearance_person(10 + index)], now)
        self.assertEqual(self.selection.snapshot(1.0)["status"], "Lost")
        for now in (1.1, 1.2, 1.3):
            self.selection.update([appearance_person(), appearance_person(2, (0., 1.), (30, 0, 40, 10))], now)
        self.assertEqual(self.selection.snapshot(1.3)["status"], "Lost")

    def test_stale_checking_latches_loss(self):
        self.overlap()
        self.assertEqual(self.selection.snapshot(0.851)["status"], "Lost")
        for now in (0.9, 1.0, 1.1):
            self.selection.update([appearance_person(), appearance_person(2, (0., 1.), (30, 0, 40, 10))], now)
        self.assertEqual(self.selection.snapshot(1.1)["status"], "Lost")

    def test_same_id_with_wrong_appearance_cannot_stay_green(self):
        self.selection.update([appearance_person(1, (0.0, 1.0))], 0.1)
        self.assertEqual(self.selection.snapshot(0.1)["status"], "Temporarily hidden")

    def test_single_visible_lookalike_never_recovers(self):
        self.overlap()
        for now in (0.2, 0.3, 0.4):
            self.selection.update([appearance_person(1, (0.939, 0.344))], now)
        self.assertEqual(self.selection.status, "Temporarily hidden")
        self.assertEqual(self.selection.diagnostics["gate"], "waiting for both people to separate")

    def test_same_id_swap_is_vetoed_against_remembered_other_before_overlap(self):
        self.selection.update([appearance_person(), appearance_person(2, (0.939, 0.344), (30, 0, 40, 10))], 0.01)
        self.selection.select(1, 0.01)
        self.selection.update([appearance_person(1, (0.939, 0.344))], 0.1)
        self.assertEqual(self.selection.status, "Temporarily hidden")

    def test_changed_id_can_recover_only_with_positive_and_competitor_evidence(self):
        self.overlap()
        for now in (0.2, 0.3, 0.4):
            self.selection.update([appearance_person(7), appearance_person(2, (0., 1.), (30, 0, 40, 10))], now)
        self.assertEqual(self.selection.status, "Tracking")
        self.assertEqual(self.selection.selected_id, 7)

    def test_approved_three_second_window_recovers_after_longer_blockage(self):
        selection = TargetSelection(recovery_enabled=True)
        separated = [appearance_person(), appearance_person(2, (0., 1.), (30, 0, 40, 10))]
        selection.update(separated, 0)
        selection.select(1, 0)
        selection.update([appearance_person(2, (0., 1.), (2, 0, 12, 10))], 0.1)
        for now in (0.5, 1., 1.5, 2.):
            selection.update([], now)
            self.assertEqual(selection.status, "Temporarily hidden")
        for now in (2.1, 2.2, 2.3):
            selection.update(separated, now)
        self.assertEqual(selection.status, "Tracking")

    def test_three_second_window_expires_even_with_fresh_occluder(self):
        selection = TargetSelection(recovery_enabled=True)
        selection.update([appearance_person()], 0)
        selection.select(1, 0)
        occluder = [appearance_person(2, (0., 1.), (2, 0, 12, 10))]
        for now in (0.1, 0.5, 1., 1.5, 2., 2.5, 3., 3.11):
            selection.update(occluder, now)
        self.assertEqual(selection.status, "Lost")
        selection.update([appearance_person()], 3.2)
        self.assertEqual(selection.status, "Lost")

    def test_recovery_requires_pre_crossing_competitor_reference(self):
        selection = TargetSelection(recovery_enabled=True)
        selection.update([appearance_person()], 0)
        selection.select(1, 0)
        selection.update([appearance_person(), appearance_person(2, (0., 1.), (2, 0, 12, 10))], 0.1)
        for now in (0.2, 0.3, 0.4):
            selection.update([appearance_person(7), appearance_person(2, (0., 1.), (30, 0, 40, 10))], now)
        self.assertEqual(selection.status, "Temporarily hidden")
        self.assertEqual(selection.diagnostics["gate"], "no pre-crossing comparison available")

    def test_remembered_competitor_rejects_swapped_id_with_similar_appearance(self):
        other = appearance_person(2, (0.939, 0.344), (30, 0, 40, 10))
        self.selection.update([appearance_person(), other], 0.01)
        self.selection.select(1, 0.01)
        self.overlap()
        for now in (0.2, 0.3, 0.4):
            self.selection.update([appearance_person(1, (0.939, 0.344)),
                                   appearance_person(3, (0., 1.), (30, 0, 40, 10))], now)
        self.assertEqual(self.selection.status, "Temporarily hidden")
        self.assertEqual(self.selection.diagnostics["gate"], "candidate resembles another person")

    def test_overlap_does_not_contaminate_reference(self):
        reference = list(self.selection.reference)
        self.selection.update([
            appearance_person(1, (0.6, 0.8)),
            appearance_person(2, (0.0, 1.0), (4, 0, 14, 10)),
        ], 0.1)
        self.assertEqual(self.selection.reference, reference)
        self.selection.update([appearance_person(7, (0.0, 1.0))], 0.2)
        self.assertEqual(self.selection.reference, reference)

    def test_candidate_switch_resets_stability_count(self):
        self.overlap()
        for now in (0.2, 0.3):
            self.selection.update([appearance_person(),
                                   appearance_person(2, (0., 1.), (30, 0, 40, 10))], now)
        self.assertEqual(self.selection.candidate_frames, 2)
        self.selection.update([appearance_person(7),
                               appearance_person(2, (0., 1.), (30, 0, 40, 10))], 0.4)
        self.assertEqual(self.selection.candidate_frames, 1)
        for now in (0.5, 0.6):
            self.selection.update([appearance_person(),
                                   appearance_person(2, (0., 1.), (30, 0, 40, 10))], now)
        self.assertEqual(self.selection.snapshot(0.6)["status"], "Temporarily hidden")

    def test_invalid_numeric_descriptors_do_not_recover(self):
        self.overlap()
        for appearance in (None, [], [0, 0], [float("nan"), 0], [float("inf"), 0], [1]):
            with self.subTest(appearance=appearance):
                self.selection.update([appearance_person(1, appearance),
                                       appearance_person(2, None, (30, 0, 40, 10))], 0.2)
                self.assertEqual(self.selection.snapshot(0.2)["status"], "Temporarily hidden")
                self.assertEqual(self.selection.diagnostics["gate"], "appearance mismatch")

    def test_invalid_reference_keeps_no_appearance_crossing_conservative(self):
        for appearance in (None, [], [0, 0], [float("nan"), 0], [float("inf"), 0]):
            with self.subTest(appearance=appearance):
                selection = TargetSelection()
                selection.update([appearance_person(1, appearance)], 0)
                self.assertTrue(selection.select(1, 0))
                selection.update([appearance_person(1, appearance), person(2, (4, 0, 14, 10))], 0.1)
                self.assertEqual(selection.snapshot(0.1)["status"], "Lost")


class TemporalRecoveryTests(unittest.TestCase):
    def setUp(self):
        self.selection = TargetSelection(recovery_enabled=True)
        self.other = appearance_person(2, (0., 1.), (30, 0, 40, 10))
        self.selection.update([appearance_person(), self.other], 0)
        self.selection.select(1, 0)
        self.selection.update([appearance_person(),
                               appearance_person(2, (0., 1.), (4, 0, 14, 10))], 0.1)

    def update(self, now, score=1., identity=1):
        self.selection.update([appearance_person(identity, (score, (1-score**2)**0.5)), self.other], now)

    def test_one_soft_crop_does_not_count_or_finish_but_preserves_strong_evidence(self):
        self.update(0.2)
        self.update(0.3)
        self.update(0.4, 0.85)
        self.assertEqual(self.selection.status, "Temporarily hidden")
        self.assertEqual(self.selection.candidate_frames, 2)
        self.update(0.45)
        self.assertEqual(self.selection.status, "Tracking")

    def test_soft_only_candidate_never_recovers(self):
        for now in (0.2, 0.3, 0.4, 0.5, 0.6):
            self.update(now, 0.85)
        self.assertEqual(self.selection.status, "Temporarily hidden")
        self.assertEqual(self.selection.candidate_frames, 0)

    def test_second_soft_crop_resets_confirmation(self):
        self.update(0.2)
        self.update(0.3, 0.85)
        self.update(0.4, 0.85)
        self.assertEqual(self.selection.candidate_frames, 0)
        self.update(0.5)
        self.update(0.6)
        self.assertEqual(self.selection.status, "Temporarily hidden")

    def test_hard_mismatch_resets_confirmation(self):
        self.update(0.2)
        self.update(0.3)
        self.update(0.4, 0.75)
        self.update(0.5)
        self.assertEqual(self.selection.candidate_frames, 1)
        self.assertEqual(self.selection.status, "Temporarily hidden")

    def test_evidence_older_than_half_second_cannot_finish(self):
        self.update(0.2)
        self.update(0.3)
        self.update(0.71)
        self.assertEqual(self.selection.candidate_frames, 1)
        self.assertEqual(self.selection.status, "Temporarily hidden")

    def test_soft_crop_does_not_bypass_other_gates(self):
        self.update(0.2)
        self.update(0.3)
        self.selection.update([appearance_person(1, (.85, .527)),
                               appearance_person(2, (0., 1.), (4, 0, 14, 10))], 0.4)
        self.assertEqual(self.selection.diagnostics["gate"], "people still overlap")
        self.assertEqual(self.selection.candidate_frames, 0)


class IsolatedPoseRecoveryTests(unittest.TestCase):
    def setUp(self):
        self.selection = TargetSelection(recovery_enabled=True)
        self.selection.update([appearance_person()], 0)
        self.selection.select(1, 0)

    def turn(self):
        self.selection.update([appearance_person(1, (0.6, 0.8))], 0.1)
        self.assertEqual(self.selection.status, "Temporarily hidden")

    def strong_return(self):
        for now in (0.3, 0.4, 0.5):
            self.selection.update([appearance_person(1, (.97, .243))], now)

    def test_lone_continuously_visible_selected_id_recovers_after_pose_change(self):
        self.turn()
        self.assertEqual(self.selection.diagnostics["trigger"], "isolated appearance change")
        reference = list(self.selection.reference)
        self.selection.update([appearance_person()], 0.2)
        self.assertEqual(self.selection.status, "Temporarily hidden")
        self.assertEqual(self.selection.reference, reference)
        self.strong_return()
        self.assertEqual(self.selection.status, "Tracking")
        self.assertEqual(self.selection.selected_id, 1)

    def test_missing_changed_id_or_second_person_permanently_revokes_pose_exception(self):
        interruptions = ([], [appearance_person(7)],
                         [appearance_person(), appearance_person(2, (0., 1.), (30, 0, 40, 10))])
        for tracks in interruptions:
            with self.subTest(tracks=tracks):
                self.setUp()
                self.turn()
                self.selection.update(tracks, 0.2)
                self.strong_return()
                self.assertNotEqual(self.selection.status, "Tracking")

    def test_previous_competitor_with_missing_descriptor_still_disqualifies(self):
        self.selection.update([appearance_person(), person(2, (30, 0, 40, 10))], 0.05)
        self.turn()
        self.strong_return()
        self.assertNotEqual(self.selection.status, "Tracking")

    def test_pose_candidate_must_remain_spatially_continuous(self):
        self.turn()
        self.selection.update([appearance_person(1, box=(100, 0, 110, 10))], 0.2)
        self.strong_return()
        self.assertNotEqual(self.selection.status, "Tracking")

    def test_pose_return_cannot_use_wrong_or_only_weak_appearance(self):
        self.turn()
        for now, appearance in ((0.2, (0., 1.)), (0.3, (.85, .527)), (0.4, (.85, .527))):
            self.selection.update([appearance_person(1, appearance)], now)
        self.assertEqual(self.selection.status, "Temporarily hidden")

    def test_pose_exception_does_not_change_stale_or_terminal_timeout(self):
        self.turn()
        self.selection.snapshot(0.9)
        for now in (1., 1.1, 1.2):
            self.selection.update([appearance_person()], now)
        self.assertEqual(self.selection.status, "Lost")
        self.setUp()
        self.turn()
        for now in (0.5, 1., 1.5, 2., 2.5, 3.11):
            self.selection.update([appearance_person(1, (.6, .8))], now)
        self.assertEqual(self.selection.status, "Lost")

    def test_exit_and_reentry_cannot_start_pose_exception(self):
        self.selection.update([], .1)
        self.strong_return()
        self.assertEqual(self.selection.status, "Lost")


class BoundedSearchTests(unittest.TestCase):
    def setUp(self):
        self.selection = TargetSelection(recovery_enabled=True, search_window=10.0)
        self.selection.update([appearance_person()], 0)
        self.selection.select(1, 0)
        self.selection.update([], 0.1)
        self.assertEqual(self.selection.status, "Searching")

    def wait_until_four_seconds(self):
        for step in range(1, 9):
            self.selection.update([], step * 0.5)
            self.assertEqual(self.selection.status, "Searching")

    def confirm(self, *, appearance=(1., 0.), tracks=None):
        for now in (4.1, 4.2, 4.3, 4.4):
            self.selection.update(tracks or [appearance_person(7, appearance)], now)
            self.assertEqual(self.selection.status, "Searching")
        self.selection.update(tracks or [appearance_person(7, appearance)], 4.5)

    def test_solo_return_after_four_seconds_requires_five_fresh_strong_observations(self):
        reference = list(self.selection.reference)
        self.wait_until_four_seconds()
        self.confirm()
        self.assertEqual(self.selection.status, "Tracking")
        self.assertEqual(self.selection.selected_id, 7)
        self.assertEqual(self.selection.reference, reference)
        self.assertIn("bounded search", self.selection.reason)

    def test_search_preserves_stricter_appearance_spatial_and_size_requirements(self):
        candidates = [appearance_person(7, (.94, .341)),
                      appearance_person(7, box=(100, 0, 110, 10)),
                      appearance_person(7, box=(0, 0, 10, 100)),
                      appearance_person(7, (float("nan"), 0.))]
        for candidate in candidates:
            with self.subTest(candidate=candidate):
                self.setUp()
                self.wait_until_four_seconds()
                self.confirm(tracks=[candidate])
                self.assertEqual(self.selection.status, "Searching")

    def test_two_plausible_candidates_revoke_solo_return_and_require_selection(self):
        self.wait_until_four_seconds()
        self.confirm(tracks=[appearance_person(7), appearance_person(8, box=(30, 0, 40, 10))])
        self.assertEqual(self.selection.status, "Searching")
        for now in (4.6, 4.7, 4.8, 4.9, 5.):
            self.selection.update([appearance_person(7)], now)
        self.assertEqual(self.selection.status, "Searching")
        self.assertEqual(self.selection.diagnostics["gate"], "waiting for both people to separate")

    def test_short_occlusion_transitions_to_search_without_restarting_deadline(self):
        selection = TargetSelection(recovery_enabled=True, search_window=10.0)
        separated = [appearance_person(), appearance_person(2, (0., 1.), (30, 0, 40, 10))]
        selection.update(separated, 0)
        selection.select(1, 0)
        selection.update([appearance_person(2, (0., 1.), (2, 0, 12, 10))], 0.1)
        self.assertEqual(selection.status, "Temporarily hidden")
        for step in range(1, 9):
            selection.update([], step * 0.5)
        self.assertEqual(selection.status, "Searching")
        self.assertEqual(selection.checking_at, 0.1)
        for now in (4.1, 4.2, 4.3, 4.4, 4.5):
            selection.update(separated, now)
        self.assertEqual(selection.status, "Tracking")

    def test_known_competitor_alone_never_recovers_even_with_matching_appearance(self):
        selection = TargetSelection(recovery_enabled=True, search_window=10.0)
        selection.update([appearance_person(), appearance_person(2, (.939, .344), (30, 0, 40, 10))], 0)
        selection.select(1, 0)
        selection.update([], .1)
        for step in range(1, 10):
            selection.update([appearance_person(7)], step * .5)
        self.assertEqual(selection.status, "Searching")
        # Even with another visible person, remembered appearance veto remains.
        for now in (4.6, 4.7, 4.8, 4.9, 5.):
            selection.update([appearance_person(7), appearance_person(3, (0., 1.), (30, 0, 40, 10))], now)
        self.assertEqual(selection.status, "Searching")
        self.assertEqual(selection.diagnostics["gate"], "candidate resembles another person")

    def test_timeout_is_absolute_and_latched_despite_new_perfect_candidates(self):
        for step in range(1, 21):
            self.selection.update([appearance_person(100 + step)], step * .5)
        self.assertEqual(self.selection.status, "Searching")
        self.selection.update([appearance_person(7)], 10.1)
        self.assertEqual(self.selection.status, "Lost")
        self.assertIsNone(self.selection.reference)
        self.assertIn("select again", self.selection.reason)
        for now in (10.2, 10.3, 10.4, 10.5, 10.6):
            self.selection.update([appearance_person(7)], now)
        self.assertEqual(self.selection.status, "Lost")

    def test_search_still_loses_after_camera_or_inference_gap(self):
        self.selection.update([appearance_person(7)], 0.86)
        self.assertEqual(self.selection.status, "Lost")
        self.assertEqual(self.selection.reason, "Tracking updates are stale")

    def test_duplicate_exposure_timestamps_do_not_supply_extra_confirmations(self):
        for now in (0.2, 0.2, 0.2, 0.2, 0.2, 0.6):
            self.selection.update([appearance_person(7)], now)
        self.assertEqual(self.selection.status, "Searching")
        self.assertEqual(self.selection.candidate_frames, 2)

    def test_same_id_jumping_between_nearby_boxes_restarts_search_confirmation(self):
        for now in (.2, .3, .4, .5):
            self.selection.update([appearance_person(7, box=(-8, 0, 2, 10))], now)
        self.selection.update([appearance_person(7, box=(8, 0, 18, 10))], .6)
        self.assertEqual(self.selection.status, "Searching")
        self.assertEqual(self.selection.candidate_frames, 1)

    def test_clear_discards_search_and_reselection_uses_new_target(self):
        self.selection.clear()
        self.selection.update([appearance_person(7)], .2)
        self.assertEqual(self.selection.status, "No target selected")
        self.assertIsNone(self.selection.reference)
        self.assertTrue(self.selection.select(7, .2))
        self.assertEqual(self.selection.status, "Tracking")

    def test_search_deadline_must_be_finite_and_not_shorter_than_brief_recovery(self):
        for duration in (float("inf"), float("nan"), 2., 0.):
            with self.subTest(duration=duration), self.assertRaises(ValueError):
                TargetSelection(recovery_enabled=True, search_window=duration)


class MotionRecoveryTests(unittest.TestCase):
    def setUp(self):
        self.selection = TargetSelection(recovery_enabled=True)
        self.other = appearance_person(2, (0., 1.), (100, 0, 110, 10))
        self.selection.update([appearance_person(), self.other], 0)
        self.selection.select(1, 0)
        for now, x in ((0.1, 2), (0.2, 4)):
            self.selection.update([appearance_person(box=(x, 0, x+10, 10)), self.other], now)
        self.selection.update([appearance_person(box=(4, 0, 14, 10)),
                               appearance_person(2, (0., 1.), (8, 0, 18, 10))], 0.3)

    def test_clear_motion_recovers_person_beyond_last_static_box(self):
        for now, x in ((0.8, 16), (0.9, 18), (1.0, 20)):
            self.selection.update([appearance_person(7, box=(x, 0, x+10, 10)), self.other], now)
        self.assertEqual(self.selection.status, "Tracking")
        self.assertEqual(self.selection.selected_id, 7)

    def test_uncertain_boxes_do_not_change_velocity_and_reverse_candidate_fails(self):
        history = list(self.selection.motion)
        for now in (0.8, 0.9, 1.0):
            self.selection.update([appearance_person(7, box=(-20, 0, -10, 10)), self.other], now)
        self.assertEqual(list(self.selection.motion), history)
        self.assertEqual(self.selection.diagnostics["gate"], "candidate too far away")

    def test_extrapolation_is_bounded_during_long_hidden_interval(self):
        for now in (0.8, 1.3, 1.8, 2.3):
            self.selection.update([self.other], now)
        self.selection.update([appearance_person(7, box=(1000, 0, 1010, 10)), self.other], 2.4)
        self.assertEqual(self.selection.diagnostics["gate"], "candidate too far away")

    def test_reselection_discards_old_motion(self):
        self.selection.update([appearance_person(7, box=(70, 0, 80, 10)), self.other], 0.4)
        self.assertTrue(self.selection.select(7, 0.4))
        self.assertEqual(len(self.selection.motion), 1)
        self.assertEqual(self.selection.motion[0], (0.4, 75, 5))


if __name__ == "__main__":
    unittest.main()
