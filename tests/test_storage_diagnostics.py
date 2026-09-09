"""Opt-in storage diagnostics stay secret-free and behavior-neutral."""

import json
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
from types import SimpleNamespace

from pc_biometric.authority import AuthorityState
from pc_biometric.enrollment import Enrollment, References
from pc_biometric.storage import ProfileStore
from registry_fixture import authority_for


class StorageDiagnosticsTests(unittest.TestCase):
    def test_trace_record_construction_failure_does_not_change_storage_result(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            authority = authority_for(root)
            with (patch.dict(os.environ, {"LOCALAPPDATA": str(root / "local"),
                                          "BGD_STORAGE_DIAGNOSTICS": "1"}),
                  patch("pc_biometric.storage.datetime") as clock):
                clock.now.side_effect = RuntimeError("diagnostic clock failed")
                enrollment = Enrollment(
                    root / "profile",
                    authority=authority,
                    account=lambda: "synthetic-owner",
                    verify_windows=lambda: True,
                    capture=lambda: References(b"face-reference", b"voice-reference"),
                )
                self.assertEqual(enrollment.start(consented=True).state, "save-code")
                self.assertEqual(enrollment.complete(code_saved=True).state, "enrolled")
                self.assertEqual(enrollment.status().state, "enrolled")

    def test_enabled_trace_records_only_sanitized_transitions_without_changing_commit(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            local = root / "local"
            with patch.dict(os.environ, {"LOCALAPPDATA": str(local), "BGD_STORAGE_DIAGNOSTICS": "1"}):
                authority = authority_for(root)
                enrollment = Enrollment(
                    root / "profile",
                    authority=authority,
                    account=lambda: "synthetic-owner",
                    verify_windows=lambda: True,
                    capture=lambda: References(b"face-reference", b"voice-reference"),
                )
                started = enrollment.start(consented=True)
                self.assertEqual(started.state, "save-code")
                self.assertEqual(enrollment.complete(code_saved=True).state, "enrolled")
                self.assertEqual(enrollment.status().state, "enrolled")
                self.assertIsNotNone(ProfileStore(root / "profile", authority).load())

                trace_path = local / "BGD" / "PCBiometricDesk" / "diagnostics" / "storage.jsonl"
                records = [json.loads(line) for line in trace_path.read_text(encoding="utf-8").splitlines()]
                outcomes = {(item["event"], item["result"]) for item in records}
                self.assertTrue({("reservation", "succeeded"), ("commit.publication", "succeeded"),
                                 ("commit", "succeeded")} <= outcomes)
                self.assertFalse(any(item["result"] == "failed" for item in records))
                allowed = {"schema", "timestamp_utc", "monotonic_ns", "process_id", "event", "result",
                           "error_type", "winerror", "errno"}
                self.assertTrue(all(set(item) <= allowed for item in records))
                self.assertTrue(all(item["schema"] == 1 for item in records))
                serialized = trace_path.read_text(encoding="utf-8")
                state = authority.read()
                for secret in ("synthetic-owner", "face-reference", "voice-reference", started.recovery_code,
                               state.installation, state.profile, state.digest, str(root)):
                    self.assertNotIn(secret, serialized)

    def test_disabled_trace_creates_no_diagnostic_artifact_and_commit_still_succeeds(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            local = root / "local"
            with patch.dict(os.environ, {"LOCALAPPDATA": str(local)}, clear=False):
                os.environ.pop("BGD_STORAGE_DIAGNOSTICS", None)
                authority = authority_for(root)
                enrollment = Enrollment(
                    root / "profile",
                    authority=authority,
                    account=lambda: "synthetic-owner",
                    verify_windows=lambda: True,
                    capture=lambda: References(b"face-reference", b"voice-reference"),
                )
                self.assertEqual(enrollment.start(consented=True).state, "save-code")
                self.assertEqual(enrollment.complete(code_saved=True).state, "enrolled")
                self.assertEqual(enrollment.status().state, "enrolled")
                self.assertFalse((local / "BGD" / "PCBiometricDesk" / "diagnostics").exists())

    def test_failed_publication_is_sanitized_and_stays_fail_closed(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            local = root / "local"
            authority = authority_for(root)

            def fail_publication(*_args):
                raise OSError(5, "secret diagnostic bait")

            with patch.dict(os.environ, {"LOCALAPPDATA": str(local), "BGD_STORAGE_DIAGNOSTICS": "1"}):
                enrollment = Enrollment(
                    root / "profile",
                    authority=authority,
                    publish=fail_publication,
                    account=lambda: "synthetic-owner",
                    verify_windows=lambda: True,
                    capture=lambda: References(b"face-reference", b"voice-reference"),
                )
                result = enrollment.start(consented=True)
                self.assertEqual(result.state, "save-code")
                self.assertEqual(enrollment.complete(code_saved=True).state, "unavailable")
                self.assertFalse(authority.read().profile)
                self.assertIsNone(ProfileStore(root / "profile", authority).load())

                trace_path = local / "BGD" / "PCBiometricDesk" / "diagnostics" / "storage.jsonl"
                records = [json.loads(line) for line in trace_path.read_text(encoding="utf-8").splitlines()]
                failures = {item["event"]: item for item in records if item["result"] == "failed"}
                self.assertIn("commit.publication", failures)
                self.assertEqual(failures["commit.publication"]["error_type"], "OSError")
                self.assertIn("commit", failures)
                self.assertNotIn(("commit", "succeeded"),
                                 {(item["event"], item["result"]) for item in records})
                self.assertNotIn("secret diagnostic bait", trace_path.read_text(encoding="utf-8"))

    def test_unwritable_diagnostic_destination_does_not_change_storage_result(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            blocked = root / "not-a-directory"
            blocked.write_text("occupied", encoding="utf-8")
            authority = authority_for(root)
            with patch.dict(os.environ, {"LOCALAPPDATA": str(blocked), "BGD_STORAGE_DIAGNOSTICS": "1"}):
                enrollment = Enrollment(
                    root / "profile",
                    authority=authority,
                    account=lambda: "synthetic-owner",
                    verify_windows=lambda: True,
                    capture=lambda: References(b"face-reference", b"voice-reference"),
                )
                self.assertEqual(enrollment.start(consented=True).state, "save-code")
                self.assertEqual(enrollment.complete(code_saved=True).state, "enrolled")
                self.assertEqual(enrollment.status().state, "enrolled")

    def test_enabled_and_disabled_tracing_produce_identical_durable_state(self):
        class Authority:
            def __init__(self):
                self.state = AuthorityState("a" * 32, "synthetic-owner")

            def read(self):
                return self.state

            def commit(self, owner, profile, digest, *, installation=None):
                self.state = AuthorityState(self.state.installation, owner, profile, digest)

        def run(root: Path, enabled: bool):
            authority = Authority()
            environment = {"LOCALAPPDATA": str(root / "local")}
            if enabled:
                environment["BGD_STORAGE_DIAGNOSTICS"] = "1"
            with (patch.dict(os.environ, environment, clear=False),
                  patch("pc_biometric.storage.uuid4", return_value=SimpleNamespace(hex="b" * 32)),
                  patch("pc_biometric.storage.protect", side_effect=lambda value, decrypt=False: value)):
                if not enabled:
                    os.environ.pop("BGD_STORAGE_DIAGNOSTICS", None)
                profile = {"owner": "synthetic-owner", "face": "face", "voice": "voice",
                           "code_verifier": "verifier"}
                store = ProfileStore(root / "profile", authority)  # type: ignore[arg-type]
                store.commit(profile, installation="a" * 32)
                self.assertEqual(store.load(), profile)
                files = {path.name: path.read_bytes() for path in (root / "profile").iterdir()
                         if path.name != "operation.lock"}
                return authority.read(), files

        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            self.assertEqual(run(root / "disabled", False), run(root / "enabled", True))


if __name__ == "__main__":
    unittest.main()
