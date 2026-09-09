"""Synthetic evidence through real workflow/storage/Tk seams; no biometric devices."""

import base64
import json
from dataclasses import replace
from pathlib import Path
import struct
import tempfile
from threading import Event, Thread, Timer
import time
import tkinter as tk
import unittest
from types import SimpleNamespace
from unittest.mock import patch

from pc_biometric.capture import CaptureDiagnostic, CaptureError, EnrollmentCapture
from pc_biometric.enrollment import References
from pc_biometric.ui import DeskApp
from pc_biometric.verification import (
    Verification, VerificationEvidence, VerificationRequest, VerificationRejected, matches, valid_challenge,
)
from registry_fixture import Enrollment, authority_for
import test_capture
from test_ui import ready_workflow, wait_for_refresh


def references(face=1.0, voice=1.0):
    return References(b"SFACE1\0" + struct.pack("<I128f", 128, *([face] * 128)),
                      b"VOSKSPK1\0" + struct.pack("<I128f", 128, *([voice] * 128)))


def enroll(directory):
    enrollment = Enrollment(directory, account=lambda: "synthetic-owner",
                            verify_windows=lambda: True, capture=references)
    assert enrollment.start(consented=True).state == "save-code"
    assert enrollment.complete(code_saved=True).state == "enrolled"
    return enrollment


class VerificationTests(unittest.TestCase):
    def test_voice_study_compares_fresh_samples_without_authorization_or_profile_update(self):
        with tempfile.TemporaryDirectory() as folder:
            directory = Path(folder)
            enrollment = enroll(directory)
            before = enrollment.store.load()
            requests = []
            def capture(request):
                requests.append(request)
                self.assertEqual(request.microphone, 1)
                return VerificationEvidence(request, references(1, -1))
            check = Verification(directory, account=lambda: "synthetic-owner", capture=capture,
                                 authority=enrollment.store.authority, diagnostics=True,
                                 voice_study=True, microphone=1)
            try:
                for count in range(1, 4):
                    result = check.start(consented=True)
                    self.assertEqual(result.state, "measured")
                    self.assertIn(f"Study samples: {count}/3", result.diagnostics)
                    self.assertIn(f"Sample {count} vs enrolled voice: -1.0000", result.diagnostics)
                self.assertIn("Samples 1 vs 2: 1.0000", result.diagnostics)
                self.assertIn("Samples 1 vs 3: 1.0000", result.diagnostics)
                self.assertIn("Samples 2 vs 3: 1.0000", result.diagnostics)
                self.assertEqual(check._study_samples, [])
                self.assertEqual(check.start(consented=True).state, "study-complete")
                self.assertEqual(len(requests), 3)
                self.assertEqual(before, enrollment.store.load())
                check.reset_study()
                check.capture = lambda request: VerificationEvidence(request, references())
                self.assertEqual(check.start(consented=True).state, "measured")
            finally:
                check.reset_study()

    def test_voice_study_requires_explicit_diagnostics_device_and_clears_on_cancel(self):
        with tempfile.TemporaryDirectory() as folder:
            directory = Path(folder)
            authority = enroll(directory).store.authority
            options = dict(account=lambda: "synthetic-owner", capture=lambda request: VerificationEvidence(request, references()),
                           authority=authority, voice_study=True)
            for extra in ({}, {"diagnostics": True}, {"diagnostics": True, "microphone": -1}):
                with self.assertRaises(ValueError):
                    Verification(directory, **options, **extra)
            check = Verification(directory, **options, diagnostics=True, microphone=1)
            try:
                check.start(consented=True)
                self.assertEqual(len(check._study_samples), 1)
                def cancelled_capture(request):
                    check.request_cancel()
                    return VerificationEvidence(request, references())
                check.capture = cancelled_capture
                result = check.start(consented=True)
                self.assertEqual(result.state, "cancelled")
                self.assertEqual(result.diagnostics, "")
                self.assertEqual(check._study_samples, [])
            finally:
                check.reset_study()

    def test_voice_study_tk_keeps_only_consented_samples_and_navigation_clears_them(self):
        with tempfile.TemporaryDirectory() as folder:
            directory = Path(folder)
            root = tk.Tk()
            app = DeskApp(root, ready_workflow(directory))
            target = directory / "profile"
            authority = enroll(target).store.authority
            check = Verification(target, account=lambda: "synthetic-owner",
                                 capture=lambda request: VerificationEvidence(request, references()),
                                 authority=authority, diagnostics=True, voice_study=True, microphone=1)
            try:
                wait_for_refresh(root, app)
                app.bind_verification(check, session_terms="Synthetic memory-only three-sample study.")
                app.show("Verify")
                self.assertEqual(app.title.cget("text"), "Voice consistency study")
                for count in (1, 2):
                    app.action_button.invoke()
                    self.assertEqual(len(check._study_samples), count - 1)
                    app.consent.set(True)
                    app.action_button.invoke()
                    deadline = time.monotonic() + 3
                    while app.verification_active and time.monotonic() < deadline:
                        root.update()
                        time.sleep(.01)
                    self.assertFalse(app.verification_active)
                    self.assertIn("No action authorized", app.task_detail.cget("text"))
                    self.assertIn(f"Study samples: {count}/3", app.diagnostic_text)
                    self.assertEqual(len(check._study_samples), count)
                app.show("Readiness")
                self.assertEqual(check._study_samples, [])
                self.assertEqual(app.diagnostic_text, "")
                self.assertIsNone(check._study_timer)
            finally:
                app.close()

    def test_voice_study_five_minute_cleanup_drops_temporary_vectors(self):
        callbacks = []
        def timer(seconds, callback):
            if seconds != 300:
                return Timer(seconds, callback)
            callbacks.append(callback)
            return SimpleNamespace(daemon=False, start=lambda: None, cancel=lambda: None)
        with tempfile.TemporaryDirectory() as folder:
            directory = Path(folder)
            authority = enroll(directory).store.authority
            check = Verification(directory, account=lambda: "synthetic-owner",
                                 capture=lambda request: VerificationEvidence(request, references()),
                                 authority=authority, diagnostics=True, voice_study=True, microphone=1)
            try:
                with patch("pc_biometric.verification.Timer", side_effect=timer):
                    self.assertEqual(check.start(consented=True).state, "measured")
                self.assertEqual(len(check._study_samples), 1)
                self.assertEqual(len(callbacks), 1)
                callbacks[0]()
                self.assertEqual(check._study_samples, [])
                self.assertEqual(check._study_lines, [])
                self.assertIsNone(check._study_timer)
            finally:
                check.reset_study()

    def test_fresh_checks_create_distinct_receipts_without_modifying_profile(self):
        with tempfile.TemporaryDirectory() as folder:
            directory = Path(folder)
            enrollment = enroll(directory)
            before = enrollment.store.load()
            requests = []
            clock = [10.0]
            def capture(request):
                requests.append(request)
                clock[0] += 4
                return VerificationEvidence(request, references())
            check = Verification(directory, account=lambda: "synthetic-owner", capture=capture,
                                 authority=enrollment.store.authority, clock=lambda: clock[0])
            self.assertEqual(check.start(consented=False).state, "consent-required")
            first = check.start(consented=True, requested_at=8)
            second = check.start(consented=True)
            self.assertEqual((first.state, second.state), ("authorized", "authorized"))
            self.assertEqual(first.elapsed_seconds, 6)
            self.assertEqual(first.diagnostics, "")
            self.assertNotEqual(first.request_id, second.request_id)
            self.assertTrue(all(valid_challenge(request.phrase) for request in requests))
            self.assertEqual(before, enrollment.store.load())
            self.assertFalse(check.active)
            self.assertEqual(check.deadline, 0)

    def test_opt_in_diagnostics_identify_each_mismatch_without_changing_decisions(self):
        with tempfile.TemporaryDirectory() as folder:
            directory = Path(folder)
            enrollment = enroll(directory)
            before = enrollment.store.load()
            for face, voice, state in ((1, 1, "authorized"), (-1, 1, "rejected"), (1, -1, "rejected")):
                with self.subTest(face=face, voice=voice):
                    def capture(request):
                        self.assertTrue(request.diagnostics)
                        return VerificationEvidence(request, references(face, voice))
                    check = Verification(directory, account=lambda: "synthetic-owner", capture=capture,
                                         authority=enrollment.store.authority, diagnostics=True)
                    result = check.start(consented=True)
                    self.assertEqual(result.state, state)
                    self.assertIn(f"Face identity: {'PASS' if face > 0 else 'FAIL'}; similarity", result.diagnostics)
                    self.assertIn(f"Voice identity: {'PASS' if voice > 0 else 'FAIL'}; similarity", result.diagnostics)
                    self.assertNotIn("similarity", repr(result))
                    self.assertNotIn("SFACE1", result.diagnostics)
            self.assertEqual(enrollment.store.load(), before)

    def test_cancelled_and_stale_evidence_does_not_expose_scores(self):
        with tempfile.TemporaryDirectory() as folder:
            directory = Path(folder)
            authority = enroll(directory).store.authority
            for cancelled in (False, True):
                def capture(request):
                    if cancelled:
                        check.request_cancel()
                    return VerificationEvidence(replace(request, request_id="b" * 32), references())
                check = Verification(directory, account=lambda: "synthetic-owner", capture=capture,
                                     authority=authority, diagnostics=True)
                result = check.start(consented=True)
                self.assertNotEqual(result.state, "authorized")
                self.assertNotIn("similarity", result.diagnostics)
                if cancelled:
                    self.assertEqual(result.diagnostics, "")
                else:
                    self.assertIn("Face identity: not evaluated", result.diagnostics)

    def test_diagnostics_measure_selected_speaker_segment_and_bind_both_streams(self):
        class SegmentedSpeech(test_capture.SpeechRecognizer):
            instances = 0

            def __init__(self, *args):
                super().__init__(*args)
                type(self).instances += 1
                self.first = type(self).instances == 1

            def Result(self):
                return json.dumps({"text": "please say" if self.first else "one two three four",
                                   "spk": [0.1 if self.first else -0.1] * 128,
                                   "spk_frames": 77 if self.first else 130})

        with tempfile.TemporaryDirectory() as folder:
            request = VerificationRequest("a" * 32, authority_for(Path(folder)).read(),
                                          "please say one two three four", diagnostics=True)
            with test_capture.CaptureTests().voice_fixture(speech_type=SegmentedSpeech) as (models, _events, feedback):
                import sounddevice
                devices = []
                def stream(**options):
                    devices.append(options["device"])
                    result = test_capture.AudioStream()
                    result.samplerate = 16000
                    return result
                def control(prompt):
                    if prompt.state == "recording":
                        return "record_stop" if prompt.elapsed_seconds >= 3 else "continue"
                    return EnrollmentCapture._automatic_voice_control(prompt)
                diagnostics = []
                capture = EnrollmentCapture(models, Event(), validate_models=lambda _root: True,
                                            feedback=feedback, voice_control=control, diagnostic=diagnostics.append,
                                            isolated=False)
                with patch.object(sounddevice, "query_devices", side_effect=[
                        {"index": 7, "name": "Bound microphone", "hostapi": 0},
                        {"index": 9, "name": "Changed default", "hostapi": 0}]) as query, \
                        patch.object(sounddevice, "RawInputStream", side_effect=stream):
                    evidence = capture.capture_verification(request)
                self.assertEqual(query.call_count, 1)
                self.assertEqual(devices, [7, 7])
                self.assertTrue(matches(references(), evidence.references))
                self.assertEqual([item.stage for item in diagnostics], ["face", "voice", "voice"])
                self.assertTrue(all(item.valid() and item.request_id == request.request_id for item in diagnostics))
                report = diagnostics[-1].details
                for expected in ("Microphone: Bound microphone", "Opened stream Hz: 16000.0",
                                 "Recognized words match: True", "Recognizer segments: 2",
                                 "Selected speaker segment: 1", "Selected segment audio seconds: 2.0",
                                 "Selected speaker nonsilence frames: 77", "Audio quality gates passed: True"):
                    self.assertIn(expected, report)
                self.assertNotIn(request.phrase, report)
                self.assertNotIn("Bound microphone", repr(diagnostics[-1]))

    def test_either_channel_mismatch_and_invalid_formats_deny(self):
        for observed in (references(-1, 1), references(1, -1), references(-1, -1)):
            self.assertFalse(matches(references(), observed))
        for blob in (b"", b"SFACE1\0", references().face + b"x", references(0).face,
                     references(float("nan")).face, references(float("inf")).face):
            with self.subTest(blob_length=len(blob)), self.assertRaises(ValueError):
                matches(references(), References(blob, references().voice))
        short_voice = b"VOSKSPK1\0" + struct.pack("<I64f", 64, *([1.] * 64))
        self.assertFalse(matches(references(), References(references().face, short_voice)))

    def test_replayed_wrong_request_policy_and_missing_evidence_deny(self):
        with tempfile.TemporaryDirectory() as folder:
            directory = Path(folder)
            authority = enroll(directory).store.authority
            captured = []
            def capture(request):
                captured.append(VerificationEvidence(request, references()))
                return captured[-1]
            check = Verification(directory, account=lambda: "synthetic-owner", capture=capture, authority=authority)
            self.assertEqual(check.start(consented=True).state, "authorized")
            for evidence in (captured[0], None,
                             replace(captured[0], request=replace(captured[0].request, policy="obsolete"))):
                check.capture = lambda _request: evidence
                self.assertEqual(check.start(consented=True).state, "rejected")
            restarted = Verification(directory, account=lambda: "synthetic-owner",
                                     capture=lambda _request: captured[0], authority=authority)
            self.assertEqual(restarted.start(consented=True).state, "rejected")

    def test_account_profile_deletion_and_revision_changes_after_capture_deny(self):
        for mutation in ("account", "payload", "index", "authority"):
            with self.subTest(mutation=mutation), tempfile.TemporaryDirectory() as folder:
                directory = Path(folder)
                enrollment = enroll(directory)
                account = ["synthetic-owner"]
                def capture(request):
                    if mutation == "account":
                        account[0] = "different-owner"
                    elif mutation == "payload":
                        next(directory.glob("profile-*.bin")).unlink()
                    elif mutation == "index":
                        enrollment.store.control.unlink()
                    else:
                        old_read = enrollment.store.authority.read
                        enrollment.store.authority.read = lambda: replace(old_read(), installation="a" * 32)
                    return VerificationEvidence(request, references())
                check = Verification(directory, account=lambda: account[0], capture=capture,
                                     authority=enrollment.store.authority)
                self.assertNotEqual(check.start(consented=True).state, "authorized")

    def test_damaged_or_foreign_profile_never_starts_capture(self):
        for mutation in ("vector", "owner", "missing"):
            with self.subTest(mutation=mutation), tempfile.TemporaryDirectory() as folder:
                directory = Path(folder)
                enrollment = enroll(directory)
                calls = []
                check = Verification(directory, account=lambda: "foreign" if mutation == "owner" else "synthetic-owner",
                                     capture=lambda request: calls.append(request), authority=enrollment.store.authority)
                if mutation == "missing":
                    enrollment.store.control.unlink()
                if mutation == "vector":
                    profile = enrollment.store.load()
                    profile["face"] = base64.b64encode(b"invalid").decode()
                    check.store.load = lambda: profile
                self.assertNotEqual(check.start(consented=True).state, "authorized")
                self.assertEqual(calls, [])

    def test_cancel_timeout_device_failure_and_concurrency_release_only_after_worker(self):
        for outcome in ("cancel", "timeout", "device"):
            with self.subTest(outcome=outcome), tempfile.TemporaryDirectory() as folder:
                directory = Path(folder)
                authority = enroll(directory).store.authority
                entered, release = Event(), Event()
                clock = [1.]
                def capture(request):
                    entered.set()
                    if not release.wait(3):
                        raise TimeoutError
                    if outcome == "device":
                        raise OSError("synthetic sensitive exception must not reach UI")
                    return VerificationEvidence(request, references())
                check = Verification(directory, account=lambda: "synthetic-owner", capture=capture,
                                     authority=authority, clock=lambda: clock[0])
                results = []
                worker = Thread(target=lambda: results.append(check.start(consented=True)))
                worker.start()
                try:
                    self.assertTrue(entered.wait(2))
                    self.assertEqual(check.start(consented=True).state, "busy")
                    self.assertFalse(check.rearm())
                    other = Verification(directory, account=lambda: "synthetic-owner", capture=capture, authority=authority)
                    self.assertEqual(other.start(consented=True).state, "busy")
                    if outcome == "cancel":
                        check.request_cancel()
                    elif outcome == "timeout":
                        clock[0] = 61
                    self.assertEqual(other.start(consented=True).state, "busy")
                finally:
                    release.set()
                    worker.join(3)
                self.assertFalse(worker.is_alive())
                self.assertEqual(results[0].state, {"cancel": "cancelled", "timeout": "expired", "device": "unavailable"}[outcome])
                self.assertNotIn("sensitive", results[0].message)
                self.assertTrue(check.rearm())

    def test_public_capture_runs_one_quality_face_and_one_exact_spoken_challenge(self):
        fixture = test_capture.CaptureTests()
        with tempfile.TemporaryDirectory() as folder:
            identity = authority_for(Path(folder)).read()
            request = VerificationRequest("a" * 32, identity, "please say one two three four")
            with fixture.voice_fixture() as (models, events, feedback):
                states = []
                def control(prompt):
                    states.append(prompt.state)
                    return EnrollmentCapture._automatic_voice_control(prompt)
                capture = EnrollmentCapture(models, Event(), validate_models=lambda _root: True,
                                            feedback=feedback, voice_control=control, isolated=False)
                evidence = capture.capture_verification(request)
                self.assertEqual(evidence.request, request)
                self.assertEqual(states.count("ready"), 1)
                self.assertNotIn("review", states)
                self.assertNotIn("accepted", states)
                self.assertTrue(any("1/1" in item.message for item in events))
                self.assertTrue(matches(evidence.references, evidence.references))

    def test_wrong_words_end_the_request_without_voice_retries(self):
        class WrongWords(test_capture.SpeechRecognizer):
            def Result(self):
                return '{"text":"old recorded phrase", "spk":' + str([.1] * 128) + '}'
        fixture = test_capture.CaptureTests()
        with tempfile.TemporaryDirectory() as folder:
            request = VerificationRequest("a" * 32, authority_for(Path(folder)).read(), "please say one two three four")
            with fixture.voice_fixture(speech_type=WrongWords) as (models, events, feedback):
                capture = EnrollmentCapture(models, Event(), validate_models=lambda _root: True,
                                            feedback=feedback, isolated=False)
                with self.assertRaisesRegex(VerificationRejected, "displayed phrase was not recognized exactly"):
                    capture.capture_verification(request)
                self.assertEqual(sum("Stay quiet" in item.message for item in events), 1)

    def test_brief_soft_speech_does_not_reject_an_otherwise_usable_take(self):
        for weak_block in (1, 4, 8):
            class SpeechWithSoftBlock(test_capture.AudioStream):
                streams = 0

                def __init__(self):
                    super().__init__()
                    SpeechWithSoftBlock.streams += 1
                    self.measuring = SpeechWithSoftBlock.streams % 2 == 1

                def read(self, _frames):
                    self.blocks += 1
                    volume = 50 if self.measuring else 500 if self.blocks == weak_block else 4000
                    return (test_capture.np.sin(test_capture.np.arange(4000) * .08) * volume).astype("<i2").tobytes(), False

            with self.subTest(weak_block=weak_block), tempfile.TemporaryDirectory() as folder:
                request = VerificationRequest("a" * 32, authority_for(Path(folder)).read(), "please say one two three four")
                with test_capture.CaptureTests().voice_fixture(stream_type=SpeechWithSoftBlock) as (models, _events, feedback):
                    capture = EnrollmentCapture(models, Event(), validate_models=lambda _root: True,
                                                feedback=feedback, isolated=False)
                    result = capture.capture_verification(request)
                    self.assertEqual(result.request, request)
                    enrolled = capture.capture()
                    self.assertTrue(enrolled.voice.startswith(b"VOSKSPK1\0"))

    def test_consistently_quiet_verification_still_rejects(self):
        class QuietSpeech(test_capture.AudioStream):
            def read(self, _frames):
                self.blocks += 1
                volume = 50 if self.blocks <= 2 else 500
                return (test_capture.np.sin(test_capture.np.arange(4000) * .08) * volume).astype("<i2").tobytes(), False

        with tempfile.TemporaryDirectory() as folder:
            request = VerificationRequest("a" * 32, authority_for(Path(folder)).read(), "please say one two three four")
            with test_capture.CaptureTests().voice_fixture(stream_type=QuietSpeech) as (models, _events, feedback):
                capture = EnrollmentCapture(models, Event(), validate_models=lambda _root: True,
                                            feedback=feedback, isolated=False)
                with self.assertRaisesRegex(VerificationRejected, "Voice is too quiet"):
                    capture.capture_verification(request)

    def test_spoken_rejection_reason_survives_worker_and_workflow_without_untrusted_text(self):
        guidance = "The displayed phrase was not recognized exactly. Read every word once at a normal pace."
        with tempfile.TemporaryDirectory() as folder:
            directory = Path(folder)
            authority = enroll(directory).store.authority
            for transmitted, expected in ((guidance, guidance),
                                           ("private transcript or device exception", "Spoken challenge did not pass.")):
                with self.subTest(expected=expected):
                    messages = [("rejected", transmitted)]
                    parent = SimpleNamespace(close=lambda: None, poll=lambda *_args: bool(messages),
                                             recv=lambda: messages.pop(0))
                    process = SimpleNamespace(start=lambda: None, is_alive=lambda: False, join=lambda *_args: None)
                    context = SimpleNamespace(Pipe=lambda **_kwargs: (parent, SimpleNamespace(close=lambda: None)),
                                              Process=lambda **_kwargs: process)
                    capture = EnrollmentCapture(directory, Event())
                    check = Verification(directory, account=lambda: "synthetic-owner",
                                         capture=capture.capture_verification, authority=authority)
                    with patch("pc_biometric.capture.multiprocessing.get_context", return_value=context):
                        result = check.start(consented=True)
                    self.assertEqual(result.state, "rejected")
                    self.assertIn(expected, result.message)
                    self.assertNotIn("private transcript", result.message)

    def test_disposable_worker_protocol_requires_matching_request_and_preserves_rejection(self):
        with tempfile.TemporaryDirectory() as folder:
            request = VerificationRequest("a" * 32, authority_for(Path(folder)).read(), "please say one two three four")
            for value, expected in ((VerificationEvidence(request, references()), None),
                                    (references(), CaptureError),
                                    (VerificationEvidence(replace(request, request_id="b" * 32), references()), CaptureError),
                                    (None, VerificationRejected)):
                with self.subTest(expected=expected):
                    messages = [("rejected" if value is None else "result", value)]
                    parent = SimpleNamespace(close=lambda: None, poll=lambda *_args: bool(messages),
                                             recv=lambda: messages.pop(0))
                    process = SimpleNamespace(start=lambda: None, is_alive=lambda: False, join=lambda *_args: None)
                    context = SimpleNamespace(Pipe=lambda **_kwargs: (parent, SimpleNamespace(close=lambda: None)),
                                              Process=lambda **_kwargs: process)
                    with patch("pc_biometric.capture.multiprocessing.get_context", return_value=context):
                        capture = EnrollmentCapture(Path(folder), Event())
                        if expected is None:
                            self.assertEqual(capture.capture_verification(request), value)
                        else:
                            with self.assertRaises(expected):
                                capture.capture_verification(request)

    def test_worker_diagnostics_require_opt_in_and_matching_request(self):
        with tempfile.TemporaryDirectory() as folder:
            request = VerificationRequest("a" * 32, authority_for(Path(folder)).read(),
                                          "please say one two three four", diagnostics=True)
            for enabled, identifier in ((True, "a" * 32), (False, "a" * 32), (True, "b" * 32)):
                with self.subTest(enabled=enabled, identifier=identifier):
                    current = replace(request, diagnostics=enabled)
                    diagnostic = CaptureDiagnostic(identifier, "voice", "Synthetic measurement")
                    messages = [("diagnostic", diagnostic), ("result", VerificationEvidence(current, references()))]
                    acks, received = [], []
                    parent = SimpleNamespace(close=lambda: None, poll=lambda *_args: bool(messages),
                                             recv=lambda: messages.pop(0), send=acks.append)
                    process = SimpleNamespace(start=lambda: None, is_alive=lambda: False, join=lambda *_args: None)
                    context = SimpleNamespace(Pipe=lambda **_kwargs: (parent, SimpleNamespace(close=lambda: None)),
                                              Process=lambda **_kwargs: process)
                    capture = EnrollmentCapture(Path(folder), Event(), diagnostic=received.append)
                    with patch("pc_biometric.capture.multiprocessing.get_context", return_value=context):
                        if enabled and identifier == current.request_id:
                            self.assertEqual(capture.capture_verification(current).request, current)
                            self.assertEqual(received, [diagnostic])
                            self.assertEqual(acks, ["displayed"])
                        else:
                            with self.assertRaises(CaptureError):
                                capture.capture_verification(current)
                            self.assertEqual(received, [])

    def test_real_tk_receipt_is_one_shot_and_default_capture_stays_closed(self):
        with tempfile.TemporaryDirectory() as folder:
            directory = Path(folder)
            root = tk.Tk()
            app = DeskApp(root, ready_workflow(directory))
            target = directory / "profile"
            authority = enroll(target).store.authority
            calls = []
            def capture(request):
                calls.append(request)
                return VerificationEvidence(request, references())
            check = Verification(target, account=lambda: "synthetic-owner", capture=capture, authority=authority)
            try:
                wait_for_refresh(root, app)
                app.bind_verification(check)
                app.show("Verify")
                app.action_button.invoke()
                self.assertTrue(app.action_button.instate(["disabled"]))
                self.assertEqual(calls, [])
                app.bind_verification(check, session_terms="Synthetic fixture only; no device opens.")
                app.show("Verify")
                app.action_button.invoke()
                self.assertEqual(calls, [])
                app.consent.set(True)
                app.action_button.invoke()
                deadline = time.monotonic() + 3
                while app.verification_active and time.monotonic() < deadline:
                    root.update()
                    time.sleep(.01)
                self.assertFalse(app.verification_active)
                self.assertEqual(len(calls), 1)
                self.assertIn("desktop request is authorized", app.task_detail.cget("text"))
                self.assertIn("Elapsed:", app.task_detail.cget("text"))
                self.assertEqual(app.diagnostic_text, "")
                self.assertIsNone(app.diagnostic_window)
                self.assertFalse(app.consent.get())
                app.action_button.invoke()
                self.assertEqual(len(calls), 1)
                app.show("Readiness")
                app.show("Verify")
                self.assertNotIn(calls[0].request_id, app.task_detail.cget("text"))
            finally:
                app.close()

    def test_synthetic_devices_drive_real_tk_random_phrase_and_hold_release(self):
        class UiSpeechRecognizer(test_capture.SpeechRecognizer):
            def FinalResult(self):
                return self.Result() if self.blocks >= 6 else "{}"
        fixture = test_capture.CaptureTests()
        real_clock = time.monotonic
        with fixture.voice_fixture(speech_type=UiSpeechRecognizer) as (models, _events, feedback), \
                patch("time.monotonic", real_clock):
            root = tk.Tk()
            app = DeskApp(root, ready_workflow(models))
            target = models / "profile"
            authority = enroll(target).store.authority
            cancelled = Event()
            def report(value):
                feedback(value)
                app.report_feedback(value)
            capture = EnrollmentCapture(models, cancelled, app.report_stage, lambda _root: True,
                                        feedback=report, preview=app.report_preview,
                                        voice_control=app.report_voice_state, diagnostic=app.report_diagnostic,
                                        isolated=False)
            check = Verification(target, account=lambda: "synthetic-owner", capture=capture.capture_verification,
                                 cancelled=cancelled, authority=authority, diagnostics=True)
            try:
                wait_for_refresh(root, app)
                app.bind_verification(check, session_terms="Synthetic fixture only.")
                app.show("Verify")
                app.consent.set(True)
                app.action_button.invoke()
                phrase = ""
                deadline = time.monotonic() + 8
                while app.verification_active and time.monotonic() < deadline:
                    root.update()
                    if app.voice_mode == "ready":
                        phrase = app.voice_phrase.cget("text")
                        self.assertEqual(app.voice_progress.cget("text"), "One fresh spoken challenge")
                        app._record_press()
                        self.assertIn("Opening microphone", app.record_button.cget("text"))
                    elif app.voice_mode == "recording" and "2.0 seconds" in app.voice_status.cget("text"):
                        app._record_release()
                    time.sleep(.005)
                self.assertFalse(app.verification_active)
                self.assertTrue(valid_challenge(phrase))
                self.assertIn("desktop request is authorized", app.task_detail.cget("text"),
                              [item.message for item in _events[-3:]])
                self.assertGreater(app.verification_elapsed, 0)
                self.assertIsNone(app.preview_image)
                self.assertEqual(app.voice_mode, "idle")
                self.assertEqual(app.capture_label.cget("text"), "Camera off\nMicrophone off")
                self.assertIn("Face identity: PASS", app.diagnostic_text)
                self.assertIn("Voice identity: PASS", app.diagnostic_text)
                self.assertIn("Microphone: Synthetic microphone", app.diagnostic_text)
                self.assertIn("Audio quality gates passed: True", app.diagnostic_text)
                self.assertNotIn(phrase, app.diagnostic_text)
                self.assertIsNotNone(app.diagnostic_window)
                app.show("Readiness")
                self.assertEqual(app.diagnostic_text, "")
                self.assertIsNone(app.diagnostic_window)
                self.assertTrue(app.diagnostic_events.empty())
            finally:
                app.close()

    def test_session_interruption_suppresses_late_positive_result_in_ui(self):
        with tempfile.TemporaryDirectory() as folder:
            directory = Path(folder)
            root = tk.Tk()
            app = DeskApp(root, ready_workflow(directory))
            target = directory / "profile"
            authority = enroll(target).store.authority
            entered, release = Event(), Event()
            def capture(request):
                app.report_diagnostic(CaptureDiagnostic(request.request_id, "voice", "Synthetic measurement"))
                entered.set()
                release.wait(3)
                return VerificationEvidence(request, references())
            check = Verification(target, account=lambda: "synthetic-owner", capture=capture, authority=authority,
                                 diagnostics=True)
            try:
                wait_for_refresh(root, app)
                app.bind_verification(check, session_terms="Synthetic fixture only.")
                app.show("Verify")
                app.consent.set(True)
                app.action_button.invoke()
                self.assertTrue(entered.wait(2))
                app.session_interrupted()
                self.assertTrue(check.cancelled.is_set())
                self.assertTrue(app.action_button.instate(["disabled"]))
                release.set()
                deadline = time.monotonic() + 3
                while app.verification_active and time.monotonic() < deadline:
                    root.update()
                    time.sleep(.01)
                self.assertFalse(app.verification_active)
                self.assertIn("Check interrupted", app.task_detail.cget("text"))
                self.assertNotIn("request is authorized", app.task_detail.cget("text"))
                self.assertEqual(app.diagnostic_text, "")
                self.assertIsNone(app.diagnostic_window)
                self.assertTrue(app.diagnostic_events.empty())
            finally:
                release.set()
                app.close()


if __name__ == "__main__":
    unittest.main()
