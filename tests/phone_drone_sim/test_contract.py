"""Observable contract and rejection tests; no devices or biometric data."""

from dataclasses import replace
import unittest

from phone_drone_sim import Phone, Simulator


def prepared():
    aircraft = Simulator()
    assert aircraft.connect()
    assert aircraft.maintenance_gesture(physical_radio=True)
    enrollment = aircraft.begin_enrollment()
    assert aircraft.inject_enrollment_result(enrollment, face_match=True, live=True)
    return aircraft, Phone(aircraft)


def launch(aircraft, phone):
    challenge = aircraft.issue_challenge()
    request = phone.request("launch_request", challenge_id=challenge.payload["challenge_id"],
                            hold_confirmed=True)
    assert aircraft.receive(request) is True
    result = aircraft.resolve_pending()
    assert result.payload["accepted"]
    assert phone.receive_result(result)
    return request, result


def verifying():
    aircraft, phone = prepared()
    launch(aircraft, phone)
    assert aircraft.arrive_at_pose()
    return aircraft, phone


def authorized():
    aircraft, phone = verifying()
    assert aircraft.inject_onboard_face_result(aircraft.verification_id, face_match=True, live=True)
    return aircraft, phone


class ContractTests(unittest.TestCase):
    def test_complete_success_separates_three_authorities(self):
        aircraft, phone = verifying()
        self.assertTrue(aircraft.airborne)
        self.assertFalse(aircraft.permission)
        self.assertTrue(aircraft.preview)
        self.assertIsNone(aircraft.open_speech_window())
        aircraft.inject_onboard_face_result(aircraft.verification_id, face_match=True, live=True)
        self.assertFalse(aircraft.preview)
        self.assertTrue(aircraft.permission)
        window = aircraft.open_speech_window()
        request = phone.request("command_request", command="inspect_once", window_id=window)
        self.assertIs(aircraft.receive(request), True)
        self.assertIsNone(aircraft.activity)
        result = aircraft.resolve_pending()
        self.assertTrue(phone.receive_result(result))
        self.assertEqual(aircraft.activity, "SIMULATED finite inspect_once")
        aircraft.manual_takeover()
        self.assertEqual(aircraft.state, "AIRBORNE_MANUAL")
        self.assertFalse(aircraft.permission)
        self.assertTrue(aircraft.armed)
        aircraft.land_and_disarm()
        self.assertFalse(aircraft.armed)
        self.assertFalse(aircraft.motor_inhibited is False)

    def test_all_readiness_failures_reject_and_consume_challenge(self):
        for requirement in prepared()[0].ready:
            with self.subTest(requirement=requirement):
                aircraft, phone = prepared()
                aircraft.ready[requirement] = False
                challenge = aircraft.issue_challenge().payload["challenge_id"]
                request = phone.request("launch_request", challenge_id=challenge, hold_confirmed=True)
                self.assertIs(aircraft.receive(request), True)
                self.assertFalse(aircraft.resolve_pending().payload["accepted"])
                aircraft.ready[requirement] = True
                replay = phone.request("launch_request", challenge_id=challenge, hold_confirmed=True)
                self.assertFalse(aircraft.receive(replay).payload["accepted"])
                self.assertFalse(aircraft.airborne)

    def test_phone_requires_hold_and_exact_challenge_deadline(self):
        for elapsed, held, accepted in [(14.999, True, True), (15, True, False),
                                        (15.001, True, False), (0, False, False)]:
            with self.subTest(elapsed=elapsed, held=held):
                aircraft, phone = prepared()
                challenge = aircraft.issue_challenge().payload["challenge_id"]
                aircraft.advance(elapsed)
                reply = aircraft.receive(phone.request("launch_request", challenge_id=challenge,
                                                       hold_confirmed=held))
                self.assertEqual(reply is True, accepted)
                if accepted:
                    self.assertTrue(aircraft.resolve_pending().payload["accepted"])

    def test_pending_launch_cannot_wait_past_challenge_deadline(self):
        aircraft, phone = prepared()
        challenge = aircraft.issue_challenge().payload["challenge_id"]
        aircraft.receive(phone.request("launch_request", challenge_id=challenge, hold_confirmed=True))
        aircraft.advance(15)
        self.assertFalse(aircraft.resolve_pending().payload["accepted"])
        self.assertFalse(aircraft.airborne)

    def test_radio_edges_are_independent_paired_deliberate_and_consumed(self):
        aircraft, _ = prepared()
        self.assertFalse(aircraft.radio_control(True, paired=False))
        self.assertFalse(aircraft.radio_control(True))
        aircraft.radio_control(False)
        aircraft.ready["prearm"] = False
        self.assertFalse(aircraft.radio_control(True))
        aircraft.ready["prearm"] = True
        self.assertFalse(aircraft.radio_control(True))
        aircraft.radio_control(False)
        self.assertTrue(aircraft.radio_control(True))
        self.assertFalse(aircraft.permission)
        aircraft.restart()
        aircraft.land_and_disarm()
        self.assertFalse(aircraft.radio_control(True))

    def test_binding_version_and_request_replays_fail_closed(self):
        changes = {"protocol_version": 2, "aircraft_id": "other", "configuration_id": "other",
                   "boot_epoch": "old", "session_id": "old", "sequence": 0,
                   "request_id": "", "payload": None}
        for key, value in changes.items():
            with self.subTest(key=key):
                aircraft, phone = prepared()
                request = phone.request("launch_request", challenge_id=aircraft.issue_challenge().payload["challenge_id"],
                                        hold_confirmed=True)
                self.assertFalse(aircraft.receive(replace(request, **{key: value})))
                self.assertFalse(aircraft.airborne)
        aircraft, phone = prepared()
        request, _ = launch(aircraft, phone)
        self.assertFalse(aircraft.receive(request))
        self.assertFalse(aircraft.receive(replace(request, sequence=request.sequence + 1)))

    def test_results_require_exact_pending_request_binding_order_and_local_deadline(self):
        aircraft, phone = prepared()
        _, result = launch(aircraft, phone)
        self.assertFalse(phone.receive_result(result))
        self.assertFalse(phone.receive_result(replace(result, sequence=result.sequence + 1)))
        for changed in [dict(boot_epoch="old"), dict(session_id="old"), dict(request_id="unknown"),
                        dict(kind="verification_status"), dict(payload=None)]:
            aircraft, phone = prepared()
            challenge = aircraft.issue_challenge().payload["challenge_id"]
            aircraft.receive(phone.request("launch_request", challenge_id=challenge, hold_confirmed=True))
            result = aircraft.resolve_pending()
            self.assertFalse(phone.receive_result(replace(result, **changed)))
            self.assertTrue(phone.receive_result(result))
        for elapsed, accepted in [(14.999, True), (15, False), (15.001, False)]:
            aircraft, phone = prepared()
            challenge = aircraft.issue_challenge().payload["challenge_id"]
            aircraft.receive(phone.request("launch_request", challenge_id=challenge, hold_confirmed=True))
            result = aircraft.resolve_pending()
            phone.advance(elapsed)  # Phone clock, not compared with aircraft timestamps.
            self.assertEqual(phone.receive_result(result), accepted)

    def test_out_of_order_results_cannot_acknowledge_older_request(self):
        aircraft, phone = authorized()
        responses = []
        for _ in range(2):
            window = aircraft.open_speech_window()
            aircraft.receive(phone.request("command_request", window_id=window, command="status"))
            responses.append(aircraft.resolve_pending())
        self.assertTrue(phone.receive_result(responses[1]))
        self.assertFalse(phone.receive_result(responses[0]))

    def test_client_biometrics_preview_and_liveness_cues_cannot_grant_permission(self):
        aircraft, phone = verifying()
        for kind in ("verification_status", "command_session", "face_result", "enrollment", "force_arm"):
            self.assertFalse(aircraft.receive(phone.request(kind, success=True, face_match=True, live=True)))
        aircraft.guidance = "SIMULATED perfect framing; advisory"
        self.assertFalse(aircraft.permission)
        self.assertFalse(aircraft.inject_onboard_face_result("stale", face_match=True, live=True))

    def test_face_and_liveness_fail_independently_and_retry_exhausts(self):
        for face, live in [(False, True), (True, False), (False, False), ("true", True)]:
            with self.subTest(face=face, live=live):
                aircraft, _ = verifying()
                first = aircraft.verification_id
                self.assertTrue(aircraft.inject_onboard_face_result(first, face_match=face, live=live))
                self.assertFalse(aircraft.permission)
                self.assertFalse(aircraft.inject_onboard_face_result(first, face_match=True, live=True))
                self.assertTrue(aircraft.retry_verification())
                self.assertFalse(aircraft.inject_onboard_face_result(first, face_match=True, live=True))
                aircraft.inject_onboard_face_result(aircraft.verification_id, face_match=False, live=False)
                self.assertEqual(aircraft.state, "PROTECTIVE_RECOVERY")
                self.assertFalse(aircraft.retry_verification())
                self.assertTrue(aircraft.armed)

    def test_retry_and_attempt_timeout_exact_boundaries(self):
        for elapsed, retry in [(29.999, True), (30, False), (30.001, False)]:
            aircraft, _ = verifying()
            aircraft.inject_onboard_face_result(aircraft.verification_id, face_match=False, live=True)
            aircraft.advance(elapsed)
            self.assertEqual(aircraft.retry_verification(), retry)
            if retry:
                aircraft.inject_onboard_face_result(aircraft.verification_id, face_match=True, live=True)
                self.assertTrue(aircraft.permission)
            else:
                self.assertEqual(aircraft.state, "PROTECTIVE_RECOVERY")
        for elapsed, expected in [(29.999, "VERIFYING"), (30, "PROTECTIVE_RECOVERY"),
                                  (30.001, "PROTECTIVE_RECOVERY")]:
            aircraft, _ = verifying()
            aircraft.advance(elapsed)
            self.assertEqual(aircraft.state, expected)

    def test_preview_loss_pose_loss_disconnect_and_restart_cancel_verification(self):
        for failure in [lambda a: a.lose_preview(), lambda a: a.set_pose_stable(False),
                        lambda a: a.disconnect(), lambda a: a.restart()]:
            aircraft, _ = verifying()
            old = aircraft.verification_id
            failure(aircraft)
            self.assertFalse(aircraft.preview)
            self.assertFalse(aircraft.permission)
            self.assertTrue(aircraft.armed)  # Auth failure never cuts airborne motors.
            aircraft.connect()
            self.assertFalse(aircraft.inject_onboard_face_result(old, face_match=True, live=True))
            self.assertEqual(aircraft.state, "PROTECTIVE_RECOVERY")

    def test_speech_one_command_deliberate_window_and_deadline(self):
        for elapsed, accepted in [(9.999, True), (10, False), (10.001, False)]:
            aircraft, phone = authorized()
            self.assertIsNone(aircraft.open_speech_window(deliberate=False))
            window = aircraft.open_speech_window()
            aircraft.advance(elapsed)
            reply = aircraft.receive(phone.request("command_request", command="status", window_id=window))
            self.assertEqual(reply is True, accepted)
            if accepted:
                self.assertTrue(aircraft.resolve_pending().payload["accepted"])
            self.assertFalse(aircraft.receive(phone.request("command_request", command="status",
                                                            window_id=window)).payload["accepted"])

    def test_pending_command_expires_before_execution(self):
        aircraft, phone = authorized()
        window = aircraft.open_speech_window()
        aircraft.receive(phone.request("command_request", command="status", window_id=window))
        aircraft.advance(10)
        self.assertFalse(aircraft.resolve_pending().payload["accepted"])
        self.assertIsNone(aircraft.activity)

    def test_lifecycle_closes_window_and_drops_queued_speech(self):
        reasons = ["headset removal", "call", "audio-route change", "locked", "background suspension",
                   "lost focus", "ambiguous speech", "release hold"]
        for reason in reasons:
            with self.subTest(reason=reason):
                aircraft, phone = authorized()
                window = aircraft.open_speech_window()
                aircraft.receive(phone.request("command_request", command="status", window_id=window))
                aircraft.interrupt_speech(reason)
                self.assertIsNone(aircraft.resolve_pending())
                self.assertIsNone(aircraft.activity)
                self.assertFalse(aircraft.receive(phone.request("command_request", command="status",
                                                                window_id=window)).payload["accepted"])
                self.assertIsNotNone(aircraft.open_speech_window())

    def test_unsupported_and_ambiguous_speech_never_executes(self):
        for command, ambiguous in [("release_cargo", False), ("force_arm", False), ("status", True)]:
            aircraft, phone = authorized()
            window = aircraft.open_speech_window()
            result = aircraft.receive(phone.request("command_request", command=command,
                                                    ambiguous=ambiguous, window_id=window))
            self.assertFalse(result.payload["accepted"])
            self.assertIsNone(aircraft.activity)

    def test_command_session_inactivity_and_accepted_command_refresh(self):
        for elapsed, permitted in [(299.999, True), (300, False), (300.001, False)]:
            aircraft, _ = authorized()
            aircraft.advance(elapsed)
            self.assertEqual(aircraft.permission, permitted)
        aircraft, phone = authorized()
        aircraft.advance(299)
        window = aircraft.open_speech_window()
        aircraft.receive(phone.request("command_request", command="status", window_id=window))
        aircraft.resolve_pending()
        aircraft.advance(299)
        self.assertTrue(aircraft.permission)
        aircraft.advance(1)
        self.assertFalse(aircraft.permission)

    def test_session_revocation_sources_do_not_replay_or_stop_airborne_motors(self):
        for revoke in [lambda a: a.stop(), lambda a: a.disconnect(),
                       lambda a: a.disconnect("app terminated"), lambda a: a.restart(),
                       lambda a: a.change_configuration("SIMULATED-new"), lambda a: a.safety_fault()]:
            aircraft, phone = authorized()
            window = aircraft.open_speech_window()
            request = phone.request("command_request", command="status", window_id=window)
            aircraft.receive(request)
            revoke(aircraft)
            self.assertFalse(aircraft.permission)
            self.assertFalse(aircraft.preview)
            self.assertIsNone(aircraft.resolve_pending())
            self.assertTrue(aircraft.armed)
            aircraft.connect()
            self.assertFalse(aircraft.receive(request))

    def test_new_flight_and_boot_invalidate_prior_permissions_and_results(self):
        aircraft, phone = authorized()
        old_binding = phone.binding
        aircraft.land_and_disarm()
        self.assertTrue(aircraft.connect())
        self.assertNotEqual(Phone(aircraft).binding, old_binding)
        self.assertIsNone(aircraft.open_speech_window())
        old_boot = aircraft.boot_epoch
        aircraft.restart()
        self.assertNotEqual(aircraft.boot_epoch, old_boot)
        self.assertFalse(aircraft.permission)
        self.assertFalse(aircraft.armed)

    def test_conditional_recovery_and_independent_manual_takeover(self):
        for unavailable in ("return_healthy", "return_reachable", "reserve_protected"):
            aircraft, _ = authorized()
            setattr(aircraft, unavailable, False)
            aircraft.disconnect()
            self.assertIn("UNQUALIFIED", aircraft.events[-1]["reason"])
            self.assertTrue(aircraft.manual_takeover())
            self.assertEqual(aircraft.state, "AIRBORNE_MANUAL")
        aircraft, _ = authorized()
        aircraft.return_healthy = False
        aircraft.degraded_policy_validated = True
        aircraft.disconnect()
        self.assertIn("degraded branch fixture", aircraft.events[-1]["reason"])
        aircraft, _ = authorized()
        aircraft.disconnect()
        self.assertIn("return-and-land branch", aircraft.events[-1]["reason"])

    def test_finite_work_may_finish_but_open_ended_updates_stop(self):
        for command, retained in [("inspect_once", True), ("observe_until_stopped", False)]:
            aircraft, phone = authorized()
            window = aircraft.open_speech_window()
            aircraft.receive(phone.request("command_request", command=command, window_id=window))
            aircraft.resolve_pending()
            aircraft.disconnect()
            self.assertEqual(aircraft.activity is not None, retained)
            self.assertFalse(aircraft.permission)

    def test_cancel_only_named_pending_request(self):
        aircraft, phone = prepared()
        challenge = aircraft.issue_challenge().payload["challenge_id"]
        request = phone.request("launch_request", challenge_id=challenge, hold_confirmed=True)
        aircraft.receive(request)
        self.assertFalse(aircraft.receive(phone.request("cancel_request", target_request_id="wrong")))
        reply = aircraft.receive(phone.request("cancel_request", target_request_id=request.request_id))
        self.assertTrue(phone.receive_result(reply))
        self.assertFalse(reply.payload["accepted"])
        self.assertEqual(aircraft.state, "GROUND_READY")
        self.assertIsNone(aircraft.resolve_pending())

    def test_enrollment_service_guards_timeout_and_old_reference_retention(self):
        aircraft = Simulator()
        self.assertIsNone(aircraft.begin_enrollment())
        self.assertFalse(aircraft.connect("unpaired"))
        aircraft.connect()
        self.assertFalse(aircraft.maintenance_gesture())
        self.assertIsNone(aircraft.begin_enrollment())
        aircraft.maintenance_gesture(physical_radio=True)
        aircraft.advance(120)
        self.assertIsNone(aircraft.begin_enrollment())
        aircraft.maintenance_gesture(physical_radio=True)
        reference = aircraft.begin_enrollment()
        self.assertTrue(aircraft.motor_inhibited)
        self.assertTrue(aircraft.preview)
        self.assertIsNone(aircraft.issue_challenge())
        self.assertFalse(aircraft.radio_control(True))
        aircraft.lose_preview()
        self.assertFalse(aircraft.inject_enrollment_result(reference, face_match=True, live=True))
        aircraft, _ = prepared()
        old = aircraft.reference_version
        aircraft.maintenance_gesture(physical_radio=True)
        self.assertIsNone(aircraft.begin_enrollment())
        reference = aircraft.begin_enrollment(current_reference_verified=True)
        self.assertFalse(aircraft.inject_enrollment_result(reference, face_match=True, live=False))
        self.assertEqual(aircraft.reference_version, old)
        aircraft.maintenance_gesture(physical_radio=True)
        reference = aircraft.begin_enrollment(recovery_authorized=True)
        aircraft.restart()
        self.assertFalse(aircraft.inject_enrollment_result(reference, face_match=True, live=True))
        self.assertEqual(aircraft.reference_version, old)
        self.assertFalse(aircraft.permission)
        self.assertFalse(aircraft.armed)

    def test_enrollment_fails_on_unhealthy_ownership_armed_or_noninhibited_state(self):
        for field, value in [("healthy", False), ("ownership_valid", False), ("armed", True),
                             ("airborne", True), ("motor_inhibited", False)]:
            aircraft, _ = prepared()
            aircraft.maintenance_gesture(physical_radio=True)
            setattr(aircraft, field, value)
            self.assertIsNone(aircraft.begin_enrollment(current_reference_verified=True))
        aircraft, _ = prepared()
        aircraft.maintenance_gesture(physical_radio=True)
        aircraft.begin_enrollment(current_reference_verified=True)
        aircraft.advance(120)
        self.assertFalse(aircraft.preview)
        self.assertIsNone(aircraft.enrollment_id)

    def test_every_observation_is_explicitly_simulated_and_clock_cannot_go_backwards(self):
        aircraft, _ = verifying()
        snapshot = aircraft.snapshot()
        for field in ("origin", "state", "guidance", "face_result", "permission"):
            self.assertIn("SIMULATED", snapshot[field])
        for value in (-1, float("nan"), float("inf"), True):
            with self.assertRaises(ValueError):
                aircraft.advance(value)

    def test_malformed_requests_and_results_do_not_throw_or_coerce_versions(self):
        for field, value in [("protocol_version", True), ("protocol_version", 1.0),
                             ("request_id", []), ("request_id", {}), ("sequence", True),
                             ("kind", []), ("payload", [])]:
            aircraft, phone = prepared()
            challenge = aircraft.issue_challenge().payload["challenge_id"]
            request = phone.request("launch_request", challenge_id=challenge, hold_confirmed=True)
            self.assertFalse(aircraft.receive(replace(request, **{field: value})))
            aircraft.receive(request)
            reply = aircraft.resolve_pending()
            self.assertFalse(phone.receive_result(replace(reply, **{field: value})))
            self.assertFalse(phone.receive_status(replace(reply, **{field: value})))
        aircraft, phone = authorized()
        window = aircraft.open_speech_window()
        result = aircraft.receive(phone.request("command_request", window_id=window, command=[]))
        self.assertFalse(result.payload["accepted"])

    def test_versioned_status_is_bound_ordered_and_verification_result_is_correlated(self):
        aircraft, phone = verifying()
        statuses = aircraft.status_messages()
        self.assertTrue(all(phone.receive_status(m) for m in statuses))
        self.assertFalse(phone.receive_status(statuses[0]))
        self.assertEqual(phone.display["command_session"]["permission"], "denied")
        old = aircraft.verification_id
        aircraft.inject_onboard_face_result(old, face_match=True, live=True)
        statuses = aircraft.status_messages()
        verification = next(m for m in statuses if m.kind == "verification_status")
        self.assertFalse(phone.receive_status(replace(verification, request_id="unrequested")))
        self.assertFalse(phone.receive_status(replace(verification, boot_epoch="prior")))
        self.assertTrue(all(phone.receive_status(m) for m in statuses))
        self.assertEqual(phone.display["command_session"]["permission"], "granted")
        self.assertFalse(phone.receive_status(replace(verification, sequence=9999)))
        phone.disconnect()
        self.assertEqual(phone.display, {})
        self.assertFalse(phone.receive_status(aircraft.status_messages()[0]))

    def test_phone_loss_and_stop_never_override_independent_manual_takeover(self):
        for event in [lambda a: a.disconnect(), lambda a: a.stop(), lambda a: a.restart(),
                      lambda a: a.safety_fault()]:
            aircraft, _ = authorized()
            aircraft.manual_takeover()
            event(aircraft)
            self.assertEqual(aircraft.state, "AIRBORNE_MANUAL")
            self.assertFalse(aircraft.permission)
            self.assertTrue(aircraft.armed)

    def test_two_consecutive_phone_flights_have_distinct_bindings(self):
        aircraft, first_phone = authorized()
        old = first_phone.binding
        aircraft.land_and_disarm()
        aircraft.connect()
        second_phone = Phone(aircraft)
        self.assertNotEqual(second_phone.binding, old)
        self.assertEqual(aircraft.state, "GROUND_READY")
        launch(aircraft, second_phone)
        self.assertFalse(aircraft.permission)
        self.assertFalse(aircraft.receive(first_phone.request("command_request", command="status")))

    def test_stop_cancels_ground_launch_and_enrollment_without_stuck_pending_state(self):
        aircraft, phone = prepared()
        challenge = aircraft.issue_challenge().payload["challenge_id"]
        aircraft.receive(phone.request("launch_request", challenge_id=challenge, hold_confirmed=True))
        aircraft.stop()
        self.assertEqual(aircraft.state, "GROUND_READY")
        self.assertIsNone(aircraft.resolve_pending())
        self.assertIsNotNone(aircraft.issue_challenge())
        aircraft.maintenance_gesture(physical_radio=True)
        aircraft.begin_enrollment(current_reference_verified=True)
        self.assertTrue(aircraft.cancel_enrollment())
        self.assertFalse(aircraft.preview)
        self.assertEqual(aircraft.reference_version, 1)
        self.assertIsNone(aircraft.begin_enrollment(current_reference_verified=True))
        aircraft.maintenance_gesture(physical_radio=True)
        aircraft.begin_enrollment(current_reference_verified=True)
        aircraft.stop()
        self.assertFalse(aircraft.preview)
        self.assertIsNone(aircraft.enrollment_id)
        aircraft.maintenance_gesture(physical_radio=True)
        aircraft.disconnect()
        aircraft.connect()
        self.assertIsNone(aircraft.begin_enrollment(current_reference_verified=True))

    def test_demo_traces_are_deterministic_and_show_required_scenarios(self):
        from phone_drone_sim.__main__ import PAGE, scenarios

        traces = scenarios()
        self.assertEqual(traces, scenarios())
        self.assertEqual(len(traces), 11)
        for frames in traces.values():
            self.assertTrue(any(frame["preview"] for frame in frames))
            self.assertTrue(all(frame["origin"] == "SIMULATED" for frame in frames))
        self.assertIn("__TRACES__", PAGE)
        for forbidden in ("getUserMedia", "WebSocket(", "fetch(", "XMLHttpRequest"):
            self.assertNotIn(forbidden, PAGE)


class IntegrationRegressionTests(unittest.TestCase):
    def test_resequenced_status_cannot_restore_revoked_permission(self):
        aircraft, phone = authorized()
        grant = aircraft.status_messages()[-1]
        self.assertTrue(phone.receive_status(grant))
        aircraft.stop()
        denial = aircraft.status_messages()[-1]
        self.assertTrue(phone.receive_status(denial))
        self.assertFalse(phone.receive_status(replace(grant, sequence=denial.sequence + 1)))
        self.assertEqual(phone.display["command_session"]["permission"], "denied")

    def test_finite_activity_is_canceled_if_recovery_is_not_safe(self):
        for condition in ("return_healthy", "return_reachable", "reserve_protected"):
            with self.subTest(condition=condition):
                aircraft, phone = authorized()
                window = aircraft.open_speech_window()
                aircraft.receive(phone.request("command_request", command="inspect_once", window_id=window))
                aircraft.resolve_pending()
                setattr(aircraft, condition, False)
                aircraft.disconnect()
                self.assertIsNone(aircraft.activity)
                self.assertTrue(aircraft.armed)

    def test_pending_request_and_display_own_validated_payloads(self):
        for mutation in ("release_cargo", [], None):
            aircraft, phone = authorized()
            window = aircraft.open_speech_window()
            request = phone.request("command_request", command="inspect_once", window_id=window)
            self.assertIs(aircraft.receive(request), True)
            request.payload["command"] = mutation
            self.assertTrue(aircraft.resolve_pending().payload["accepted"])
            self.assertEqual(aircraft.activity, "SIMULATED finite inspect_once")
        status = aircraft.status_messages()[-1]
        self.assertTrue(phone.receive_status(status))
        status.payload["permission"] = "forged"
        self.assertEqual(phone.display["command_session"]["permission"], "granted")

    def test_malformed_result_fields_do_not_consume_valid_correlation(self):
        for bad in (None, "false", [], 0):
            aircraft, phone = prepared()
            challenge = aircraft.issue_challenge().payload["challenge_id"]
            aircraft.receive(phone.request("launch_request", challenge_id=challenge, hold_confirmed=True))
            result = aircraft.resolve_pending()
            self.assertFalse(phone.receive_result(replace(result, payload={"origin": "SIMULATED", "accepted": bad})))
            self.assertTrue(phone.receive_result(result))
        aircraft, phone = verifying()
        pending = aircraft.status_messages()[1]
        self.assertTrue(phone.receive_status(pending))
        aircraft.inject_onboard_face_result(aircraft.verification_id, face_match=True, live=True)
        terminal = aircraft.status_messages()[1]
        self.assertFalse(phone.receive_status(replace(terminal, payload={**terminal.payload, "status": "banana"})))
        self.assertTrue(phone.receive_status(terminal))
        self.assertFalse(phone.receive_status(replace(terminal, sequence=terminal.sequence + 1)))
        grant = aircraft.status_messages()[-1]
        self.assertFalse(phone.receive_status(replace(grant, payload={"origin": "SIMULATED", "permission": []})))
        self.assertTrue(phone.receive_status(grant))


if __name__ == "__main__":
    unittest.main()
