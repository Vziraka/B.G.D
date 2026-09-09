"""Deletion/rollback contracts with real isolated HKCU storage and synthetic data.

Machine ACL validation is separate; an HKCU fixture does not establish that ACL.
"""

import tempfile
import unittest
import uuid
import winreg
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from threading import Barrier, Event
from pathlib import Path
from unittest.mock import patch

from pc_biometric.enrollment import References
from registry_fixture import Enrollment, authority_for
from pc_biometric.authority import RegistryAuthority
from pc_biometric.enrollment import Enrollment as AppEnrollment


class OwnershipBoundaryTests(unittest.TestCase):
    def test_replacing_the_installation_while_saving_code_discards_pending_enrollment(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            authority = authority_for(root)
            workflow = AppEnrollment(root, authority=authority, account=lambda: "synthetic-owner",
                                     verify_windows=lambda: True,
                                     capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
            self.assertEqual(workflow.start(consented=True).state, "save-code")
            winreg.DeleteKeyEx(authority.hive, authority.key, winreg.KEY_WOW64_64KEY)
            authority.install("synthetic-owner")
            self.assertEqual(workflow.complete(code_saved=True).state, "unavailable")
            self.assertFalse(authority.read().profile)

    def test_publication_from_a_replaced_installation_cannot_commit(self):
        with tempfile.TemporaryDirectory() as directory:
            authority = authority_for(Path(directory))
            before = authority.read()
            winreg.DeleteKeyEx(authority.hive, authority.key, winreg.KEY_WOW64_64KEY)
            authority.install("synthetic-owner")
            with self.assertRaises(OSError):
                authority.commit("synthetic-owner", "a" * 32, "b" * 64, installation=before.installation)
            self.assertFalse(authority.read().profile)

    def test_case_aliases_of_one_registry_authority_share_the_writer_lock(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            authority = authority_for(root)
            alias = RegistryAuthority(key=authority.key.swapcase(), hive=authority.hive)
            entered, release = Event(), Event()
            real_write = winreg.SetValueEx

            def pause_write(*args):
                if not entered.is_set():
                    entered.set()
                    if not release.wait(timeout=5):
                        raise TimeoutError("Test did not release the first registry writer")
                real_write(*args)

            with patch("winreg.SetValueEx", side_effect=pause_write), ThreadPoolExecutor(max_workers=1) as pool:
                first = pool.submit(authority.commit, "synthetic-owner", "a" * 32, "b" * 64)
                try:
                    self.assertTrue(entered.wait(timeout=5))
                    with self.assertRaises(OSError):
                        alias.commit("synthetic-owner", "c" * 32, "d" * 64)
                finally:
                    release.set()
                first.result(timeout=5)
            self.assertEqual(authority.read().profile, "a" * 32)
            self.assertEqual(alias.read(), authority.read())

    def test_process_exit_at_each_publication_boundary_preserves_one_authoritative_state(self):
        program = r'''
import json, os, sys, winreg
from pathlib import Path
sys.path.insert(0, "tests")
from registry_fixture import Enrollment
from pc_biometric.enrollment import References
w = Enrollment(Path(sys.argv[1]), account=lambda: "synthetic-owner", verify_windows=lambda: True,
               capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
assert w.start(consented=True).state == "save-code"
replace, set_value = os.replace, winreg.SetValueEx
def stopped_replace(source, destination):
    replace(source, destination)
    name = Path(destination).name
    if (sys.argv[2] == "payload" and name.startswith("profile-")) or (
        sys.argv[2] == "control" and name == "ownership.bin"):
        os._exit(71)
def stopped_value(key, name, reserved, kind, data):
    set_value(key, name, reserved, kind, data)
    if sys.argv[2] == "authority" and json.loads(data)["profile"]:
        os._exit(71)
os.replace, winreg.SetValueEx = stopped_replace, stopped_value
w.complete(code_saved=True)
raise AssertionError("Expected interruption did not occur")
'''
        for phase in ("payload", "control", "authority"):
            with self.subTest(phase=phase), tempfile.TemporaryDirectory() as directory:
                restarted = Enrollment(Path(directory), account=lambda: "synthetic-owner", verify_windows=lambda: False,
                                       capture=lambda: References(b"", b""))
                result = subprocess.run([sys.executable, "-c", program, directory, phase], timeout=15)
                self.assertEqual(result.returncode, 71)
                expected = "enrolled" if phase == "authority" else "not-enrolled"
                self.assertEqual(restarted.status().state, expected)
                self.assertEqual(restarted.start(consented=True).state,
                                 "enrolled" if phase == "authority" else "denied")

    def test_competing_setup_writers_cannot_commit_two_identities(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            authority = authority_for(root)
            gate, saving = Barrier(2), Event()

            def account():
                if saving.is_set():
                    gate.wait(timeout=5)
                return "synthetic-owner"

            workflows = [AppEnrollment(root / name, authority=authority, account=account,
                                       verify_windows=lambda: True,
                                       capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
                         for name in ("first", "second")]
            for workflow in workflows:
                self.assertEqual(workflow.start(consented=True).state, "save-code")
            saving.set()
            with ThreadPoolExecutor(max_workers=2) as pool:
                outcomes = list(pool.map(lambda workflow: workflow.complete(code_saved=True).state, workflows))
            saving.clear()
            self.assertEqual(sorted(outcomes), ["enrolled", "unavailable"])
            self.assertEqual(sorted(workflow.status().state for workflow in workflows), ["damaged", "enrolled"])

    def test_invalid_authority_publication_preserves_pending_setup(self):
        with tempfile.TemporaryDirectory() as directory:
            authority = authority_for(Path(directory))
            workflow = AppEnrollment(Path(directory), authority=authority, account=lambda: "synthetic-owner",
                                     verify_windows=lambda: True,
                                     capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
            with self.assertRaises((OSError, ValueError)):
                authority.commit("synthetic-owner", "invalid-generation", "b" * 64)
            self.assertEqual(workflow.status().state, "not-enrolled")
            self.assertEqual(workflow.start(consented=True).state, "save-code")
            workflow.cancel()

    def test_missing_machine_authority_never_means_first_installation(self):
        with tempfile.TemporaryDirectory() as directory:
            authority = RegistryAuthority(hive=winreg.HKEY_CURRENT_USER,
                                          key="Software\\BGD.PCBiometricDesk.Tests\\" + uuid.uuid4().hex)
            calls = []
            workflow = AppEnrollment(Path(directory), authority=authority, account=lambda: "synthetic-owner",
                                     verify_windows=lambda: calls.append("windows"),
                                     capture=lambda: calls.append("capture"))
            self.assertEqual(workflow.status().state, "damaged")
            self.assertEqual(workflow.start(consented=True).state, "damaged")
            self.assertEqual(calls, [])
            with self.assertRaises(FileNotFoundError):
                authority.read()

    def test_installer_preserves_committed_owner_and_rejects_retargeting_or_damage(self):
        with tempfile.TemporaryDirectory() as directory:
            authority = authority_for(Path(directory))
            workflow = AppEnrollment(Path(directory), authority=authority, account=lambda: "synthetic-owner",
                                     verify_windows=lambda: True,
                                     capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
            self.assertEqual(workflow.start(consented=True).state, "save-code")
            self.assertEqual(workflow.complete(code_saved=True).state, "enrolled")
            authority.install("synthetic-owner")
            self.assertEqual(workflow.status().state, "enrolled")
            with self.assertRaises(OSError):
                authority.install("replacement-owner")
            self.assertEqual(workflow.status().state, "enrolled")
            with winreg.OpenKey(authority.hive, authority.key, 0,
                                winreg.KEY_SET_VALUE | winreg.KEY_WOW64_64KEY) as key:
                winreg.SetValueEx(key, "State", 0, winreg.REG_BINARY, b"damaged-test-authority")
            with self.assertRaises(OSError):
                authority.install("synthetic-owner")
            self.assertEqual(workflow.status().state, "damaged")

    def test_deleting_all_state_must_not_reopen_first_setup(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            workflow = Enrollment(root, account=lambda: "synthetic-owner", verify_windows=lambda: True,
                                  capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
            workflow.start(consented=True)
            self.assertEqual(workflow.complete(code_saved=True).state, "enrolled")
            for file in root.iterdir():
                file.unlink()
            restarted = Enrollment(root, account=lambda: "another-windows-account", verify_windows=lambda: True,
                                   capture=lambda: References(b"other-face", b"other-voice"))
            self.assertEqual(restarted.status().state, "damaged")

    def test_restoring_pre_enrollment_state_must_not_reopen_setup(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            workflow = Enrollment(root, account=lambda: "synthetic-owner", verify_windows=lambda: True,
                                  capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
            workflow.start(consented=True)
            reservation = (root / "ownership.bin").read_bytes()
            self.assertEqual(workflow.complete(code_saved=True).state, "enrolled")
            for file in root.iterdir():
                file.unlink()
            (root / "ownership.bin").write_bytes(reservation)
            restarted = Enrollment(root, account=lambda: "synthetic-owner", verify_windows=lambda: True,
                                   capture=lambda: References(b"other-face", b"other-voice"))
            self.assertEqual(restarted.status().state, "damaged")


if __name__ == "__main__":
    unittest.main()
