"""Ticket 02: public enrollment with synthetic references and controlled Windows outcomes."""

import tempfile
import os
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from threading import Event
import unittest
from pathlib import Path
from unittest.mock import patch

from pc_biometric.enrollment import References
from registry_fixture import Enrollment


class EnrollmentTests(unittest.TestCase):
    def test_five_minute_enrollment_timeout_cancels_pending_code(self):
        timers = []

        class FakeTimer:
            def __init__(self, interval, function):
                self.interval = interval
                self.function = function
                self.daemon = False
                self.cancelled = False
                timers.append(self)

            def start(self):
                pass

            def cancel(self):
                self.cancelled = True

        with tempfile.TemporaryDirectory() as directory, \
                patch("pc_biometric.enrollment.Timer", FakeTimer):
            workflow = Enrollment(Path(directory), account=lambda: "synthetic-owner",
                                  verify_windows=lambda: True,
                                  capture=lambda: References(b"face", b"voice"))
            self.assertEqual(workflow.start(consented=True).state, "save-code")
            self.assertEqual(timers[0].interval, 300)
            timers[0].function()
            self.assertEqual(workflow.complete(code_saved=True).state, "cancelled")
            self.assertTrue(timers[0].cancelled)
            self.assertEqual(workflow.status().state, "not-enrolled")

    def test_deadline_expiring_during_final_account_check_cannot_publish(self):
        clock = [0.0]
        completing = Event()

        def account():
            if completing.is_set():
                clock[0] = 301.0
            return "synthetic-owner"

        with tempfile.TemporaryDirectory() as directory, \
                patch("pc_biometric.enrollment.time.monotonic", side_effect=lambda: clock[0]):
            workflow = Enrollment(Path(directory), account=account, verify_windows=lambda: True,
                                  capture=lambda: References(b"face", b"voice"))
            self.assertEqual(workflow.start(consented=True).state, "save-code")
            completing.set()
            self.assertEqual(workflow.complete(code_saved=True).state, "cancelled")
            self.assertEqual(workflow.status().state, "not-enrolled")


    def test_session_invalidation_queued_before_start_is_not_erased(self):
        with tempfile.TemporaryDirectory() as directory:
            cancelled = Event()
            cancelled.set()
            calls: list[str] = []
            workflow = Enrollment(Path(directory), account=lambda: "synthetic-owner",
                                  verify_windows=lambda: calls.append("verify") or True,
                                  capture=lambda: calls.append("capture") or References(b"f", b"v"),
                                  cancelled=cancelled)

            self.assertEqual(workflow.start(consented=True).state, "cancelled")
            self.assertEqual(calls, [])

    def test_cancelled_account_precheck_never_opens_windows_verification(self):
        with tempfile.TemporaryDirectory() as directory:
            prompts = []

            def account():
                workflow.cancel()
                return "synthetic-owner"

            workflow = Enrollment(Path(directory), account=account,
                                  verify_windows=lambda: prompts.append(True) or True,
                                  capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
            self.assertEqual(workflow.start(consented=True).state, "cancelled")
            self.assertEqual(prompts, [])

    def test_session_cancellation_during_final_account_check_prevents_commit(self):
        with tempfile.TemporaryDirectory() as directory:
            cancelled = Event()
            saving = Event()

            def account():
                if saving.is_set():
                    cancelled.set()
                return "synthetic-owner"

            workflow = Enrollment(Path(directory), account=account, verify_windows=lambda: True,
                                  capture=lambda: References(b"synthetic-face", b"synthetic-voice"),
                                  cancelled=cancelled)
            self.assertEqual(workflow.start(consented=True).state, "save-code")
            saving.set()
            self.assertEqual(workflow.complete(code_saved=True).state, "cancelled")
            self.assertEqual(workflow.status().state, "not-enrolled")

    def test_session_cancellation_while_saving_code_discards_pending_enrollment(self):
        with tempfile.TemporaryDirectory() as directory:
            cancelled = Event()
            workflow = Enrollment(Path(directory), account=lambda: "synthetic-owner", verify_windows=lambda: True,
                                  capture=lambda: References(b"synthetic-face", b"synthetic-voice"),
                                  cancelled=cancelled)
            self.assertEqual(workflow.start(consented=True).state, "save-code")
            cancelled.set()
            self.assertEqual(workflow.complete(code_saved=True).state, "cancelled")
            self.assertEqual(workflow.complete(code_saved=True).state, "denied")
            restarted = Enrollment(Path(directory), account=lambda: "synthetic-owner", verify_windows=lambda: False,
                                   capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
            self.assertEqual(restarted.status().state, "not-enrolled")
            self.assertEqual(restarted.start(consented=True).state, "denied")

    def test_unavailable_account_status_is_sanitized_and_does_not_reopen_setup(self):
        with tempfile.TemporaryDirectory() as directory:
            owner = Enrollment(Path(directory), account=lambda: "synthetic-owner", verify_windows=lambda: True,
                               capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
            self.assertEqual(owner.start(consented=True).state, "save-code")
            self.assertEqual(owner.complete(code_saved=True).state, "enrolled")

            def unavailable_account():
                raise RuntimeError("private-provider-details")

            restarted = Enrollment(Path(directory), account=unavailable_account, verify_windows=lambda: True,
                                   capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
            status = restarted.status()
            self.assertEqual(status.state, "unavailable")
            self.assertNotIn("private-provider-details", repr(status))
            self.assertEqual(restarted.start(consented=True).state, "unavailable")
            self.assertEqual(owner.status().state, "enrolled")

    def test_cancellation_during_windows_account_confirmation_never_starts_capture(self):
        with tempfile.TemporaryDirectory() as directory:
            account_checks, captures = [], []

            def account():
                account_checks.append(1)
                if len(account_checks) == 2:
                    workflow.cancel()
                return "synthetic-owner"

            def capture():
                captures.append(1)
                return References(b"synthetic-face", b"synthetic-voice")

            workflow = Enrollment(Path(directory), account=account, verify_windows=lambda: True, capture=capture)
            self.assertEqual(workflow.start(consented=True).state, "cancelled")
            self.assertEqual(captures, [])

    def test_process_crash_releases_lock_but_not_owner_reservation(self):
        with tempfile.TemporaryDirectory() as directory:
            program = """
import os, sys
from pathlib import Path
from pc_biometric.enrollment import References
sys.path.insert(0, 'tests')
from registry_fixture import Enrollment
w = Enrollment(Path(sys.argv[1]), account=lambda: 'synthetic-owner', verify_windows=lambda: True,
               capture=lambda: References(b'synthetic-face', b'synthetic-voice'))
assert w.start(consented=True).state == 'save-code'
os._exit(0)
"""
            subprocess.run([sys.executable, "-c", program, directory], check=True, timeout=10)
            restarted = Enrollment(Path(directory), account=lambda: "synthetic-owner",
                                   verify_windows=lambda: False, capture=lambda: References(b"", b""))
            self.assertEqual(restarted.start(consented=True).state, "denied")
            other = Enrollment(Path(directory), account=lambda: "different-account",
                               verify_windows=lambda: True, capture=lambda: References(b"face", b"voice"))
            self.assertEqual(other.start(consented=True).state, "denied")

    def test_cancel_cannot_release_an_operation_while_commit_is_in_progress(self):
        with tempfile.TemporaryDirectory() as directory:
            def create():
                return Enrollment(Path(directory), account=lambda: "synthetic-owner", verify_windows=lambda: True,
                                  capture=lambda: References(b"synthetic-face", b"synthetic-voice"))

            first, second = create(), create()
            first.start(consented=True)
            entered, proceed, cancel_returned = Event(), Event(), Event()
            replace = os.replace

            def pause_commit(source, destination):
                if Path(destination).name == "ownership.bin":
                    entered.set()
                    if not proceed.wait(5):
                        raise TimeoutError("test commit gate")
                return replace(source, destination)

            def cancel():
                result = first.cancel()
                cancel_returned.set()
                return result

            with ThreadPoolExecutor(max_workers=2) as pool, patch("os.replace", side_effect=pause_commit):
                completing = pool.submit(first.complete, code_saved=True)
                try:
                    self.assertTrue(entered.wait(3))
                    cancelling = pool.submit(cancel)
                    self.assertFalse(cancel_returned.wait(0.1))
                    self.assertEqual(second.start(consented=True).state, "busy")
                finally:
                    proceed.set()
                self.assertEqual(completing.result(3).state, "enrolled")
                self.assertEqual(cancelling.result(3).state, "enrolled")
            self.assertEqual(second.status().state, "enrolled")

    def test_late_account_callback_cannot_resurrect_cancelled_setup(self):
        with tempfile.TemporaryDirectory() as directory:
            captured = [False]

            def account():
                if captured[0]:
                    workflow.cancel()
                return "synthetic-owner"

            def capture():
                captured[0] = True
                return References(b"synthetic-face", b"synthetic-voice")

            workflow = Enrollment(Path(directory), account=account, verify_windows=lambda: True, capture=capture)
            self.assertEqual(workflow.start(consented=True).state, "cancelled")
            self.assertEqual(workflow.complete(code_saved=True).state, "denied")

    def test_missing_or_tampered_payload_or_ownership_never_reopens_setup(self):
        for target in ("profile", "ownership"):
            for damage in ("delete", "corrupt"):
                with self.subTest(target=target, damage=damage), tempfile.TemporaryDirectory() as directory:
                    root = Path(directory)
                    workflow = Enrollment(root, account=lambda: "synthetic-owner", verify_windows=lambda: True,
                                          capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
                    workflow.start(consented=True)
                    workflow.complete(code_saved=True)
                    path = next(root.glob("profile-*.bin")) if target == "profile" else root / "ownership.bin"
                    if damage == "delete":
                        path.unlink()
                    else:
                        path.write_bytes(b"damaged synthetic fixture")
                    restarted = Enrollment(root, account=lambda: "synthetic-owner", verify_windows=lambda: True,
                                           capture=lambda: References(b"different", b"different"))
                    self.assertEqual(restarted.status().state, "damaged")
                    self.assertEqual(restarted.start(consented=True).state, "damaged")

    def test_interrupted_commit_keeps_setup_reserved_and_requires_a_fresh_check(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            workflow = Enrollment(root, account=lambda: "synthetic-owner", verify_windows=lambda: True,
                                  capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
            self.assertEqual(workflow.start(consented=True).state, "save-code")
            with patch("os.replace", side_effect=OSError("disk failed")):
                self.assertEqual(workflow.complete(code_saved=True).state, "unavailable")
            self.assertEqual(workflow.complete(code_saved=True).state, "denied")
            self.assertEqual(workflow.status().state, "not-enrolled")
            restarted = Enrollment(root, account=lambda: "synthetic-owner", verify_windows=lambda: False,
                                   capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
            self.assertEqual(restarted.start(consented=True).state, "denied")

    def test_cancel_discards_pending_and_late_capture_results(self):
        with tempfile.TemporaryDirectory() as directory:
            workflow = None

            def capture():
                workflow.cancel()
                return References(b"synthetic-face", b"synthetic-voice")

            workflow = Enrollment(Path(directory), account=lambda: "synthetic-owner",
                                  verify_windows=lambda: True, capture=capture)
            self.assertEqual(workflow.start(consented=True).state, "cancelled")
            self.assertEqual(workflow.complete(code_saved=True).state, "denied")
            self.assertEqual(workflow.status().state, "not-enrolled")

    def test_parallel_instances_cannot_collect_competing_profiles(self):
        with tempfile.TemporaryDirectory() as directory:
            def create():
                return Enrollment(Path(directory), account=lambda: "synthetic-owner",
                                  verify_windows=lambda: True,
                                  capture=lambda: References(b"synthetic-face", b"synthetic-voice"))

            first, second = create(), create()
            self.assertEqual(first.start(consented=True).state, "save-code")
            self.assertEqual(second.start(consented=True).state, "busy")
            self.assertEqual(first.start(consented=True).state, "busy")
            self.assertEqual(first.complete(code_saved=True).state, "enrolled")
            self.assertEqual(second.start(consented=True).state, "enrolled")

    def test_invalid_references_or_unavailable_windows_do_not_create_enrollment(self):
        with tempfile.TemporaryDirectory() as directory:
            workflow = Enrollment(Path(directory), account=lambda: "synthetic-owner",
                                  verify_windows=lambda: True,
                                  capture=lambda: References(b"", b"synthetic-voice"))
            self.assertEqual(workflow.start(consented=True).state, "denied")
            self.assertEqual(workflow.complete(code_saved=True).state, "denied")

            def unavailable():
                raise RuntimeError("private account detail")

            unavailable_workflow = Enrollment(Path(directory), account=lambda: "synthetic-owner",
                                             verify_windows=unavailable,
                                             capture=lambda: References(b"face", b"voice"))
            result = unavailable_workflow.start(consented=True)
            self.assertEqual(result.state, "unavailable")
            self.assertNotIn("private", str(result))
            self.assertEqual(unavailable_workflow.status().state, "not-enrolled")

    def test_account_switch_during_any_setup_stage_cannot_commit(self):
        for stage in ("windows", "capture", "save"):
            with self.subTest(stage=stage), tempfile.TemporaryDirectory() as directory:
                current = ["synthetic-owner"]

                def verify():
                    if stage == "windows":
                        current[0] = "different-account"
                    return True

                def capture():
                    if stage == "capture":
                        current[0] = "different-account"
                    return References(b"synthetic-face", b"synthetic-voice")

                workflow = Enrollment(Path(directory), account=lambda: current[0],
                                      verify_windows=verify, capture=capture)
                result = workflow.start(consented=True)
                if stage == "save":
                    current[0] = "different-account"
                    result = workflow.complete(code_saved=True)
                self.assertEqual(result.state, "denied")
                current[0] = "synthetic-owner"
                self.assertEqual(workflow.status().state, "not-enrolled")

    def test_both_references_and_saved_code_are_required_before_durable_enrollment(self):
        with tempfile.TemporaryDirectory() as directory:
            workflow = Enrollment(Path(directory), account=lambda: "synthetic-owner",
                                  verify_windows=lambda: True,
                                  capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
            prepared = workflow.start(consented=True)
            self.assertEqual(prepared.state, "save-code")
            self.assertIsNotNone(prepared.recovery_code)
            self.assertNotIn(prepared.recovery_code, repr(prepared))
            self.assertEqual(workflow.complete(code_saved=False).state, "save-code")
            completed = workflow.complete(code_saved=True)
            self.assertEqual(completed.state, "enrolled")
            restarted = Enrollment(Path(directory), account=lambda: "synthetic-owner",
                                   verify_windows=lambda: False, capture=lambda: References(b"", b""))
            self.assertEqual(restarted.status().state, "enrolled")
            self.assertEqual(restarted.start(consented=True).state, "enrolled")
            for file in Path(directory).rglob("*"):
                if file.is_file():
                    data = file.read_bytes()
                    self.assertNotIn(b"synthetic-face", data)
                    self.assertNotIn(b"synthetic-voice", data)
                    self.assertNotIn(prepared.recovery_code.encode(), data)

    def test_setup_requires_fresh_windows_verification_before_capture(self):
        with tempfile.TemporaryDirectory() as directory:
            calls = []

            def capture():
                calls.append("capture")
                return References(b"synthetic-face", b"synthetic-voice")

            workflow = Enrollment(Path(directory), account=lambda: "synthetic-owner",
                                  verify_windows=lambda: False, capture=capture)
            result = workflow.start(consented=True)
            self.assertEqual(result.state, "denied")
            self.assertEqual(calls, [])
            self.assertEqual(workflow.status().state, "not-enrolled")


if __name__ == "__main__":
    unittest.main()
