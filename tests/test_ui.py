"""Small real Tk smoke path through the public desk workflow, no capture."""

import tempfile
import time
import tkinter as tk
import gc
import base64
from threading import Event, Thread
import unittest
from unittest.mock import patch
from pathlib import Path
from datetime import date

from pc_biometric.enrollment import References
from pc_biometric.capture import CaptureFeedback, ENROLLMENT_PHRASES, VoicePrompt
from pc_biometric.ui import DeskApp, enrollment_session_terms
from pc_biometric.workflow import Check, DeskWorkflow, MODELS, PACKAGES
from registry_fixture import Enrollment, authority_for


def wait_for_refresh(root: tk.Tk, app: DeskApp) -> None:
    deadline = time.monotonic() + 5
    while app.refresh_button.instate(["disabled"]) and time.monotonic() < deadline:
        root.update()
        time.sleep(0.01)


def ready_workflow(root: Path) -> DeskWorkflow:
    for _name, filename, _digest, members in MODELS:
        path = root / filename
        if members:
            for member in members:
                target = path / member
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(b"synthetic-model-fixture")
        else:
            path.write_bytes(b"synthetic-model-fixture")
    return DeskWorkflow(
        root,
        device_probe=lambda: (Check("Devices", "Synthetic interfaces", "Unverified",
                                    "No device opened by this system-boundary fixture."),),
        package_version=lambda package: PACKAGES[package],
        model_probe=lambda _path, _digest, _members: True,
        platform_probe=lambda: True,
    )


class UiSmokeTests(unittest.TestCase):
    def tearDown(self) -> None:
        gc.collect()

    def test_copy_cannot_start_a_second_completion_while_publication_is_pending(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            app = DeskApp(root, ready_workflow(Path(directory)))
            entered, release = Event(), Event()
            try:
                wait_for_refresh(root, app)
                target = Path(directory) / "profile"
                authority = authority_for(target)
                def publish(candidate, _lease):
                    entered.set()
                    if not release.wait(5):
                        raise TimeoutError("Synthetic publication wait expired")
                    authority.commit(candidate.owner, candidate.profile, candidate.digest,
                                     installation=candidate.installation)
                enrollment = Enrollment(target, account=lambda: "synthetic-owner",
                    verify_windows=lambda: True, capture=lambda: References(b"face", b"voice"), publish=publish)
                app.bind_enrollment(enrollment, session_terms="Synthetic fixtures only.")
                app.consent.set(True)
                app.start_setup()
                deadline = time.monotonic() + 3
                while not app.recovery_code and time.monotonic() < deadline:
                    root.update()
                    time.sleep(.01)
                app.copy_button.invoke()
                root.clipboard_clear()
                app.complete_button.invoke()
                self.assertTrue(entered.wait(2))
                app.copy_button.invoke()
                self.assertTrue(app.complete_button.instate(["disabled"]))
                app.complete_setup()
                release.set()
                self.assertTrue(app.wait_for_workers())
                deadline = time.monotonic() + .5
                while time.monotonic() < deadline:
                    root.update()
                    time.sleep(.01)
                self.assertEqual(enrollment.status().state, "enrolled")
                self.assertIn("enrollment saved", app.task_detail.cget("text"))
            finally:
                release.set()
                app.close()

    def test_waveform_and_phrase_are_visible_and_cleared_after_capture(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            app = DeskApp(root, ready_workflow(Path(directory)))
            try:
                wait_for_refresh(root, app)
                feedback = CaptureFeedback('Take 1/3 · Read: "synthetic phrase"', (.1, .5, .8) * 16)
                worker = Thread(target=lambda: app.report_feedback(feedback))
                worker.start()
                deadline = time.monotonic() + 2
                while worker.is_alive() and time.monotonic() < deadline:
                    root.update()
                    time.sleep(.01)
                worker.join(1)
                self.assertIn("synthetic phrase", app.task_detail.cget("text"))
                self.assertTrue(app.audio_canvas.winfo_ismapped())
                self.assertTrue(app.audio_canvas.find_all(), "Visible waveform must contain drawing items")
                idle = Thread(target=lambda: app.report_stage("idle"))
                idle.start()
                deadline = time.monotonic() + 2
                while idle.is_alive() and time.monotonic() < deadline:
                    root.update()
                    time.sleep(.01)
                idle.join(1)
                self.assertFalse(app.audio_canvas.winfo_ismapped())
                self.assertEqual(app.audio_canvas.find_all(), ())
            finally:
                app.close()

    def test_voice_hold_record_and_review_controls_are_deliberate(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            app = DeskApp(root, ready_workflow(Path(directory)))
            phrase = ENROLLMENT_PHRASES[0]

            def request(prompt):
                result = []
                app.voice_mode = "test-wait"
                worker = Thread(target=lambda: result.append(app.report_voice_state(prompt)))
                worker.start()
                deadline = time.monotonic() + 2
                while worker.is_alive() and app.voice_mode != prompt.state and time.monotonic() < deadline:
                    root.update()
                    time.sleep(.01)
                return worker, result

            try:
                wait_for_refresh(root, app)
                stage = Thread(target=lambda: app.report_stage("voice"))
                stage.start()
                deadline = time.monotonic() + 2
                while stage.is_alive() and time.monotonic() < deadline:
                    root.update()
                    time.sleep(.01)
                stage.join(1)
                self.assertIn("Stay quiet for room measurement", app.task_detail.cget("text"))
                self.assertIn("hold Record or Spacebar", app.task_detail.cget("text"))
                measuring, measuring_result = request(VoicePrompt("measuring", 1, 1, phrase))
                measuring.join(1)
                self.assertEqual(measuring_result, ["continue"])
                self.assertFalse(app.record_button.winfo_ismapped())
                ready, ready_result = request(VoicePrompt("ready", 1, 1, phrase))
                self.assertEqual(app.voice_phrase.cget("text"), phrase)
                self.assertTrue(app.record_button.instate(["!disabled"]))
                app.record_button.event_generate("<ButtonPress-1>")
                root.update()
                ready.join(1)
                self.assertEqual(ready_result, ["record_start"])

                recording, recording_result = request(VoicePrompt("recording", 1, 1, phrase, .25))
                recording.join(1)
                self.assertEqual(recording_result, ["continue"])
                app.record_button.event_generate("<ButtonRelease-1>")
                root.update()
                stopped, stopped_result = request(VoicePrompt("recording", 1, 1, phrase, .5))
                stopped.join(1)
                self.assertEqual(stopped_result, ["record_stop"])

                review, review_result = request(VoicePrompt("review", 1, 1, phrase, 2.0))
                self.assertTrue(app.playback_button.instate(["!disabled"]))
                app.playback_button.invoke()
                root.update()
                review.join(1)
                self.assertEqual(review_result, ["playback"])

                ready_again, ready_again_result = request(VoicePrompt("ready", 1, 1, phrase))
                app.record_button.event_generate("<ButtonPress-1>")
                root.update()
                ready_again.join(1)
                self.assertEqual(ready_again_result, ["record_start"])
                with patch.object(root, "focus_displayof", return_value=None):
                    app._discard_if_focus_lost()
                discarded, discarded_result = request(VoicePrompt("recording", 1, 1, phrase, .25))
                discarded.join(1)
                self.assertEqual(discarded_result, ["record_discard"])

                rejected, rejected_result = request(VoicePrompt("rejected", 1, 1, phrase, 2.0))
                self.assertEqual(app.record_button.cget("text"), "Try again")
                app.record_button.event_generate("<ButtonPress-1>")
                root.update()
                rejected.join(1)
                self.assertEqual(rejected_result, ["retry"])

                accepted, accepted_result = request(VoicePrompt("accepted", 1, 2, phrase, 2.0))
                self.assertEqual(app.record_button.cget("text"), "Continue")
                app.record_button.event_generate("<ButtonPress-1>")
                root.update()
                accepted.join(1)
                self.assertEqual(accepted_result, ["continue"])

                idle, idle_result = request(VoicePrompt("idle", 0, 0, ""))
                idle.join(1)
                self.assertEqual(idle_result, ["continue"])
                self.assertFalse(app.voice_panel.winfo_ismapped())
            finally:
                app.close()

    def test_spacebar_holds_and_releases_recording(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            app = DeskApp(root, ready_workflow(Path(directory)))
            try:
                wait_for_refresh(root, app)
                app.show("Setup")
                app.voice_mode = "ready"
                app.voice_panel.pack(fill="x")
                app.record_button.pack(anchor="w")
                app.record_button.state(["!disabled"])
                app.record_button.focus_force()
                root.update()
                app.record_button.event_generate("<KeyPress-space>", when="now")
                root.update()
                self.assertTrue(app.voice_holding.is_set())
                self.assertEqual(app.voice_actions.get_nowait(), "record_start")
                app.record_button.event_generate("<KeyRelease-space>", when="now")
                root.update()
                self.assertFalse(app.voice_holding.is_set())
                self.assertFalse(app.voice_discard.is_set())
                result = []
                worker = Thread(target=lambda: result.append(app.report_voice_state(
                    VoicePrompt("recording", 1, 1, ENROLLMENT_PHRASES[0], .5))))
                worker.start()
                deadline = time.monotonic() + 2
                while worker.is_alive() and time.monotonic() < deadline:
                    root.update()
                    time.sleep(.01)
                worker.join(1)
                self.assertEqual(result, ["record_stop"])
            finally:
                app.close()

    def test_voice_action_timeout_and_failed_grab_are_fail_closed_and_recoverable(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            app = DeskApp(root, ready_workflow(Path(directory)))
            phrase = ENROLLMENT_PHRASES[0]

            def request(prompt):
                result = []
                app.voice_mode = "test-wait"
                worker = Thread(target=lambda: result.append(app.report_voice_state(prompt)))
                worker.start()
                deadline = time.monotonic() + 2
                while worker.is_alive() and app.voice_mode != prompt.state and time.monotonic() < deadline:
                    root.update()
                    time.sleep(.01)
                return worker, result

            try:
                wait_for_refresh(root, app)
                self.assertEqual(VoicePrompt("ready", 1, 1, phrase).response_timeout_seconds, 60)
                started = time.monotonic()
                timed, timed_result = request(VoicePrompt("ready", 1, 1, phrase,
                                                          response_timeout_seconds=.05))
                while timed.is_alive() and time.monotonic() - started < .5:
                    root.update()
                    time.sleep(.01)
                timed.join(1)
                self.assertEqual(timed_result, ["timeout"])
                self.assertLess(time.monotonic() - started, .5)

                first, first_result = request(VoicePrompt("ready", 1, 1, phrase))
                with patch.object(app.record_button, "grab_set", side_effect=tk.TclError):
                    app._record_press()
                first.join(1)
                self.assertEqual(first_result, ["record_start"])
                self.assertFalse(app.voice_holding.is_set())
                self.assertTrue(app.voice_discard.is_set())
                discarded, discarded_result = request(VoicePrompt("recording", 1, 1, phrase, .25))
                discarded.join(1)
                self.assertEqual(discarded_result, ["record_discard"])

                second, second_result = request(VoicePrompt("ready", 1, 1, phrase))
                app._record_press()
                second.join(1)
                self.assertEqual(second_result, ["record_start"])
                self.assertTrue(app.voice_holding.is_set())
                app._record_release()
            finally:
                app.close()

    def test_five_minute_expiry_clears_a_displayed_recovery_code(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            app = DeskApp(root, ready_workflow(Path(directory)))
            enrollment = Enrollment(Path(directory) / "profile", account=lambda: "synthetic-owner",
                                    verify_windows=lambda: True,
                                    capture=lambda: References(b"face", b"voice"))
            try:
                wait_for_refresh(root, app)
                app.bind_enrollment(enrollment, session_terms="Synthetic test only.")
                app.setup_active = True
                app.recovery_code = "SYNTHETIC-CODE"
                app.code_value.configure(text="SYNTHETIC-CODE")
                app.code_panel.pack()
                enrollment.deadline = time.monotonic() - 1
                app.finish_enrollment()
                root.update()
                self.assertEqual(app.recovery_code, "")
                self.assertEqual(app.code_value.cget("text"), "")
                self.assertFalse(app.code_panel.winfo_ismapped())
                self.assertTrue(enrollment.cancelled.is_set())
            finally:
                app.close()

    def test_cancel_discards_queued_voice_feedback_and_waveform(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            app = DeskApp(root, ready_workflow(Path(directory)))
            try:
                wait_for_refresh(root, app)
                app.bind_enrollment(Enrollment(Path(directory) / "profile", account=lambda: "synthetic-owner",
                    verify_windows=lambda: True, capture=lambda: References(b"face", b"voice")))
                queued = Event()
                errors = []
                def report():
                    try:
                        app.report_feedback(CaptureFeedback("STALE phrase", (.5,) * 48), queued)
                    except TimeoutError:
                        errors.append("not displayed")
                worker = Thread(target=report)
                worker.start()
                self.assertTrue(queued.wait(1))
                app.cancel_setup()
                deadline = time.monotonic() + 2
                while worker.is_alive() and time.monotonic() < deadline:
                    root.update()
                    time.sleep(.01)
                worker.join(1)
                self.assertEqual(errors, ["not displayed"])
                self.assertNotIn("STALE", app.task_detail.cget("text"))
                self.assertFalse(app.audio_canvas.winfo_ismapped())
                self.assertEqual(app.audio_canvas.find_all(), ())
            finally:
                app.close()

    def test_memory_only_face_preview_is_visible_then_cleared_at_idle(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            try:
                app = DeskApp(root, ready_workflow(Path(directory)))
                wait_for_refresh(root, app)
                # 1x1 PNG; the fixture remains in memory and never touches disk.
                png = base64.b64decode(
                    "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=")
                worker = Thread(target=lambda: app.report_preview(png))
                worker.start()
                deadline = time.monotonic() + 2
                while worker.is_alive() and time.monotonic() < deadline:
                    root.update()
                    time.sleep(0.01)
                worker.join(1)
                self.assertTrue(app.preview_label.winfo_ismapped())
                self.assertNotEqual(app.preview_label.cget("image"), "")

                idle = Thread(target=lambda: app.report_stage("idle"))
                idle.start()
                deadline = time.monotonic() + 2
                while idle.is_alive() and time.monotonic() < deadline:
                    root.update()
                    time.sleep(0.01)
                idle.join(1)
                self.assertFalse(app.preview_label.winfo_ismapped())
                self.assertEqual(app.preview_label.cget("image"), "")
            finally:
                app.close()

    def test_real_session_terms_require_a_current_exact_deletion_date(self):
        terms = enrollment_session_terms("2027-01-01", today=date(2026, 9, 3))
        self.assertIn("January 1, 2027", terms)
        self.assertIn("current Windows account and local administrators", terms)
        self.assertIn("memory-only live face preview", terms)
        self.assertIn("memory-only voice recording may be played back", terms)
        self.assertIn("no raw media files are written", terms)
        with self.assertRaises(ValueError):
            enrollment_session_terms("2026-09-02", today=date(2026, 9, 3))
        with self.assertRaises(ValueError):
            enrollment_session_terms("next year", today=date(2026, 9, 3))

    def test_idle_session_notification_does_not_rewrite_the_current_page(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            try:
                app = DeskApp(root, ready_workflow(Path(directory)))
                wait_for_refresh(root, app)
                title = app.title.cget("text")
                detail = app.task_detail.cget("text")
                setup_enabled = not app.navigation["Setup"].instate(["disabled"])
                app.session_interrupted()
                root.update_idletasks()
                self.assertEqual(app.title.cget("text"), title)
                self.assertEqual(app.task_detail.cget("text"), detail)
                self.assertEqual(not app.navigation["Setup"].instate(["disabled"]), setup_enabled)
            finally:
                app.close()

    def test_interruption_never_acknowledges_or_displays_a_stale_capture_stage(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            try:
                app = DeskApp(root, ready_workflow(Path(directory)))
                wait_for_refresh(root, app)
                enrollment = Enrollment(
                    Path(directory) / "profile", account=lambda: "synthetic-owner",
                    verify_windows=lambda: True,
                    capture=lambda: References(b"synthetic-face", b"synthetic-voice"),
                )
                app.bind_enrollment(enrollment)
                errors: list[Exception] = []
                queued = Event()

                def report() -> None:
                    try:
                        app.report_stage("face", queued)
                    except Exception as error:
                        errors.append(error)

                worker = Thread(target=report)
                worker.start()
                self.assertTrue(queued.wait(1))
                app.cancel_setup()
                deadline = time.monotonic() + 2
                while worker.is_alive() and time.monotonic() < deadline:
                    root.update()
                    time.sleep(0.01)
                worker.join(2)
                self.assertEqual(app.capture_label.cget("text"), "Camera off\nMicrophone off")
                self.assertEqual(len(errors), 1)
                self.assertIsInstance(errors[0], TimeoutError)
            finally:
                for callback in root.tk.call("after", "info"):
                    root.after_cancel(callback)
                app.close()

    def test_real_setup_stays_blocked_without_session_specific_terms(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            try:
                app = DeskApp(root, ready_workflow(Path(directory)))
                wait_for_refresh(root, app)
                cancelled = Event()
                enrollment = Enrollment(
                    Path(directory) / "profile", account=lambda: "synthetic-owner",
                    verify_windows=lambda: True,
                    capture=lambda: References(b"synthetic-face", b"synthetic-voice"),
                    cancelled=cancelled,
                )
                app.bind_enrollment(enrollment)
                app.show("Setup")
                self.assertTrue(app.action_button.instate(["disabled"]))
                self.assertIn("retention", app.task_detail.cget("text").lower())
            finally:
                app.close()

    def test_cancel_signals_before_a_new_capture_stage_can_be_acknowledged(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            try:
                app = DeskApp(root, ready_workflow(Path(directory)))
                wait_for_refresh(root, app)
                cancelled = Event()
                enrollment = Enrollment(
                    Path(directory) / "profile", account=lambda: "synthetic-owner",
                    verify_windows=lambda: True,
                    capture=lambda: References(b"synthetic-face", b"synthetic-voice"),
                    cancelled=cancelled,
                )
                app.bind_enrollment(enrollment, session_terms="Synthetic test only.")
                app.cancel_setup()
                self.assertTrue(cancelled.is_set())
                errors: list[Exception] = []
                queued = Event()

                def report() -> None:
                    try:
                        app.report_stage("face", queued)
                    except Exception as error:
                        errors.append(error)

                worker = Thread(target=report)
                worker.start()
                self.assertTrue(queued.wait(1))
                deadline = time.monotonic() + 2
                while worker.is_alive() and time.monotonic() < deadline:
                    root.update()
                    time.sleep(0.01)
                worker.join(2)
                self.assertEqual(app.capture_label.cget("text"), "Camera off\nMicrophone off")
                self.assertEqual(len(errors), 1)
            finally:
                for callback in root.tk.call("after", "info"):
                    root.after_cancel(callback)
                app.close()

    def test_window_close_signals_cancellation_before_shutdown_callbacks(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            app = DeskApp(root, ready_workflow(Path(directory)))
            wait_for_refresh(root, app)
            cancelled = Event()
            enrollment = Enrollment(
                Path(directory) / "profile", account=lambda: "synthetic-owner",
                verify_windows=lambda: True,
                capture=lambda: References(b"synthetic-face", b"synthetic-voice"),
                cancelled=cancelled,
            )
            app.bind_enrollment(enrollment)
            cancellation_seen: list[bool] = []
            app.on_close(lambda: cancellation_seen.append(cancelled.is_set()))
            app.close()
            self.assertEqual(cancellation_seen, [True])

    def test_visible_missing_models_failed_devices_and_navigation(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            try:
                app = DeskApp(root, DeskWorkflow(Path(directory), device_probe=lambda: (
                    Check("Devices", "Camera", "Failed", "Camera inspection failed; check Windows settings."),
                )))
                deadline = time.monotonic() + 5
                while app.refresh_button.instate(["disabled"]) and time.monotonic() < deadline:
                    root.update()
                    time.sleep(0.01)
                self.assertFalse(app.refresh_button.instate(["disabled"]))
                root.update_idletasks()
                self.assertGreaterEqual(app.refresh_button.winfo_height(), app.refresh_button.winfo_reqheight())
                rows = [app.check_list.item(item, "values") for item in app.check_list.get_children()]
                self.assertTrue(any("Missing" in row for row in rows))
                self.assertTrue(any("Failed" in row for row in rows))
                for name in ("Setup", "Verify", "Account", "Recovery"):
                    app.navigation[name].invoke()
                    root.update()
                    self.assertTrue(app.action_button.instate(["disabled"]))
                    self.assertIn("development only" if name == "Verify" else "not available",
                                  app.task_detail.cget("text").lower())
                self.assertIn("Camera off", app.capture_label.cget("text"))
                self.assertIn("Microphone off", app.capture_label.cget("text"))
            finally:
                app.close()

    def test_guided_setup_requires_consent_and_saved_code_before_completion(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            try:
                app = DeskApp(root, ready_workflow(Path(directory)))
                wait_for_refresh(root, app)
                enrollment = Enrollment(
                    Path(directory) / "profile", account=lambda: "synthetic-owner",
                    verify_windows=lambda: True,
                    capture=lambda: References(b"synthetic-face", b"synthetic-voice"),
                )
                app.bind_enrollment(enrollment, session_terms="Synthetic test: no real participant or retained data.")
                app.navigation["Setup"].invoke()
                root.update()
                self.assertFalse(app.action_button.instate(["disabled"]))
                app.action_button.invoke()
                root.update()
                self.assertIn("agree", app.task_detail.cget("text").lower())
                self.assertEqual(enrollment.status().state, "not-enrolled")

                app.consent.set(True)
                app.action_button.invoke()
                deadline = time.monotonic() + 5
                while not app.code_panel.winfo_ismapped() and time.monotonic() < deadline:
                    root.update()
                    time.sleep(0.01)
                self.assertTrue(app.code_panel.winfo_ismapped())
                self.assertNotEqual(app.code_value.cget("text"), "")
                self.assertNotEqual(enrollment.status().state, "enrolled")
                self.assertTrue(app.complete_button.instate(["disabled"]))
                masked = app.code_value.cget("text")
                app.reveal_button.invoke()
                code = app.code_value.cget("text")
                self.assertNotEqual(masked, code)
                app.reveal_button.invoke()
                self.assertEqual(app.code_value.cget("text"), masked)
                app.navigation["Account"].invoke()
                root.update()
                self.assertEqual(app.code_value.cget("text"), masked)
                self.assertTrue(app.code_panel.winfo_ismapped())
                self.assertEqual(app.title.cget("text"), "Deliberate owner setup")
                self.assertIn("recovery code", app.code_panel.winfo_children()[0].cget("text").lower())

                app.complete_setup()
                root.update()
                self.assertIn("copy", app.task_detail.cget("text").lower())
                with patch.object(root, "clipboard_append", side_effect=tk.TclError("fixture failure")):
                    app.copy_button.invoke()
                self.assertTrue(app.complete_button.instate(["disabled"]))
                app.copy_button.invoke()
                self.assertEqual(root.clipboard_get(), code)
                self.assertFalse(app.complete_button.instate(["disabled"]))
                # Only the synthetic fixture code is cleared by this test.
                root.clipboard_clear()
                app.complete_button.invoke()
                deadline = time.monotonic() + 5
                while (enrollment.status().state != "enrolled" or app.code_value.cget("text")) and time.monotonic() < deadline:
                    root.update()
                    time.sleep(0.01)
                self.assertEqual(enrollment.status().state, "enrolled")
                self.assertEqual(app.code_value.cget("text"), "")
                self.assertIn("Camera off", app.capture_label.cget("text"))
            finally:
                app.close()

    def test_session_interruption_clears_the_displayed_recovery_code(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            try:
                app = DeskApp(root, ready_workflow(Path(directory)))
                wait_for_refresh(root, app)
                enrollment = Enrollment(
                    Path(directory) / "profile", account=lambda: "synthetic-owner",
                    verify_windows=lambda: True,
                    capture=lambda: References(b"synthetic-face", b"synthetic-voice"),
                )
                app.bind_enrollment(enrollment, session_terms="Synthetic test: no real participant or retained data.")
                app.consent.set(True)
                app.start_setup()
                deadline = time.monotonic() + 5
                while not app.code_value.cget("text") and time.monotonic() < deadline:
                    root.update()
                    time.sleep(0.01)
                self.assertTrue(app.code_value.cget("text"))
                app.session_interrupted()
                app.reveal_button.invoke()
                app.copy_button.invoke()
                self.assertEqual(app.recovery_code, "")
                self.assertTrue(app.complete_button.instate(["disabled"]))
                deadline = time.monotonic() + 5
                while app.code_value.cget("text") and time.monotonic() < deadline:
                    root.update()
                    time.sleep(0.01)
                self.assertEqual(app.code_value.cget("text"), "")
                self.assertEqual(enrollment.status().state, "not-enrolled")
                self.assertIn("interrupted", app.task_detail.cget("text").lower())
            finally:
                app.close()

    def test_session_interruption_discards_a_queued_recovery_code_result(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            try:
                app = DeskApp(root, ready_workflow(Path(directory)))
                wait_for_refresh(root, app)
                enrollment = Enrollment(
                    Path(directory) / "profile", account=lambda: "synthetic-owner",
                    verify_windows=lambda: True,
                    capture=lambda: References(b"synthetic-face", b"synthetic-voice"),
                )
                app.bind_enrollment(enrollment, session_terms="Synthetic test: no real participant or retained data.")
                app.show("Setup")
                app.consent.set(True)
                app.start_setup()
                self.assertTrue(app.wait_for_workers())  # Deliberately do not let Tk consume the queued result.
                app.session_interrupted()
                deadline = time.monotonic() + 5
                while time.monotonic() < deadline:
                    root.update()
                    if not app.cancel_button.winfo_ismapped():
                        break
                    time.sleep(0.01)
                self.assertEqual(app.code_value.cget("text"), "")
                self.assertFalse(app.code_panel.winfo_ismapped())
                self.assertNotEqual(enrollment.status().state, "enrolled")
            finally:
                enrollment.cancel()
                app.close()


if __name__ == "__main__":
    unittest.main()
