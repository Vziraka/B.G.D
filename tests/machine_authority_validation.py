"""Explicit admin-run, NON-BIOMETRIC Windows ACL integration validation.

Only unique HKLM test keys are created; production installation is untouched.
No Windows verification request, camera or microphone API is invoked.
"""

from contextlib import contextmanager
import ctypes as ct
from ctypes import wintypes as wt
from pathlib import Path
import tempfile
import unittest
import uuid
import winreg
import subprocess
import os
from dataclasses import replace

from pc_biometric.authority import RegistryAuthority
from pc_biometric.enrollment import Enrollment, References
from pc_biometric.windows import _api, current_account
from pc_biometric.publication import publication_command
from pc_biometric.coordination import publication_lease


@contextmanager
def unelevated():
    """Use the actual unelevated coordinator's primary token, not an ACL mock.

    TokenLinkedToken produced invalid-impersonation-level errors on this target,
    not meaningful read/write access checks.
    The normal runner stays alive until this suite exits. Only its same-account,
    unelevated primary token may supply the test context.
    """
    coordinator = int(os.environ.get("BGD_VALIDATION_UNELEVATED_PID", "0"))
    process = _api("kernel32", "OpenProcess", wt.HANDLE, wt.DWORD, wt.BOOL, wt.DWORD)(0x1000, False, coordinator)
    if not process:
        raise RuntimeError("Start the validation runner unelevated; its coordinator must stay running.")
    token, own_token, size = wt.HANDLE(), wt.HANDLE(), wt.DWORD()
    try:
        open_token = _api("advapi32", "OpenProcessToken", wt.BOOL, wt.HANDLE, wt.DWORD, ct.POINTER(wt.HANDLE))
        if not open_token(process, 0xA, ct.byref(token)) or not open_token(
                _api("kernel32", "GetCurrentProcess", wt.HANDLE)(), 8, ct.byref(own_token)):
            raise RuntimeError("Cannot inspect the coordinator/validation tokens.")
        query = _api("advapi32", "GetTokenInformation", wt.BOOL, wt.HANDLE, ct.c_int,
                     ct.c_void_p, wt.DWORD, ct.POINTER(wt.DWORD))
        for kind, required in ((8, 1), (20, 0)):  # TokenPrimary, not elevated
            value = wt.DWORD()
            if not query(token, kind, ct.byref(value), ct.sizeof(value), ct.byref(size)) or value.value != required:
                raise RuntimeError("The coordinator must have a real unelevated primary token.")
        users = [ct.create_string_buffer(512), ct.create_string_buffer(512)]
        for handle, user in zip((token, own_token), users):
            if not query(handle, 1, user, len(user), ct.byref(size)):
                raise RuntimeError("Cannot compare validation accounts.")
        if not _api("advapi32", "EqualSid", wt.BOOL, ct.c_void_p, ct.c_void_p)(
                *(ct.cast(user, ct.POINTER(ct.c_void_p))[0] for user in users)):
            raise RuntimeError("Validation coordinator and administrator must use the same Windows account.")
        if not _api("advapi32", "ImpersonateLoggedOnUser", wt.BOOL, wt.HANDLE)(token):
            raise RuntimeError("Cannot enter the unelevated validation context.")
        try:
            if _api("shell32", "IsUserAnAdmin", wt.BOOL)():
                raise RuntimeError("Validation context is still elevated.")
            yield
        finally:
            if not _api("advapi32", "RevertToSelf", wt.BOOL)():
                raise RuntimeError("Cannot leave validation impersonation.")
    finally:
        close = _api("kernel32", "CloseHandle", wt.BOOL, wt.HANDLE)
        for handle in (token, own_token, process):
            if handle:
                close(handle)


class MachineAuthorityTests(unittest.TestCase):
    def setUp(self):
        if not _api("shell32", "IsUserAnAdmin", wt.BOOL)():
            self.fail("Run this explicit non-biometric suite elevated; no security test is skipped.")
        self.key = "SOFTWARE\\BGD.PCBiometricDesk.Validation." + uuid.uuid4().hex
        self.authority = RegistryAuthority(key=self.key)
        self.owner = current_account()
        # This is normal app data, so create it with the normal user's token.
        with unelevated():
            self.directory = tempfile.TemporaryDirectory()
        self.addCleanup(self.directory.cleanup)
        def remove_test_key():
            try:
                winreg.DeleteKeyEx(winreg.HKEY_LOCAL_MACHINE, self.key, winreg.KEY_WOW64_64KEY)
            except FileNotFoundError:
                pass
        self.addCleanup(remove_test_key)
        self.authority.install(self.owner)

    def workflow(self):
        return Enrollment(Path(self.directory.name), authority=self.authority, publish=self.publish,
                          account=lambda: self.owner, verify_windows=lambda: True,
                          capture=lambda: References(b"synthetic-face-only", b"synthetic-voice-only"))

    def publish(self, candidate, lease):
        result = subprocess.run(["powershell.exe", *publication_command(candidate, lease, key=self.key).split()],
                                capture_output=True, text=True, timeout=15,
                                creationflags=subprocess.CREATE_NO_WINDOW)
        if result.returncode != 0:
            raise OSError("Validation helper rejected publication")
        self.assertEqual(result.stdout, "")
        self.assertEqual(result.stderr, "")

    def test_system_publication_commits_exact_candidate_and_refuses_stale_or_repeated_requests(self):
        before = self.authority.read()
        invalid = replace(before, profile="b" * 32, digest="c" * 64)
        winreg.DeleteKeyEx(winreg.HKEY_LOCAL_MACHINE, self.key, winreg.KEY_WOW64_64KEY)
        self.authority.install(self.owner)
        replacement = self.authority.read()
        with publication_lease(before.installation) as lease, self.assertRaises(OSError):
            self.publish(invalid, lease)
        self.assertTrue(self.authority.read() == replacement)
        # The process is elevated for this explicit suite. Thread impersonation
        # uses the actual coordinator token for normal enrollment/storage;
        # the separate PowerShell child runs with the process's admin token.
        with unelevated():
            workflow = self.workflow()
            self.assertEqual(workflow.start(consented=True).state, "save-code")
            self.assertEqual(workflow.complete(code_saved=True).state, "enrolled")
            self.assertEqual(workflow.status().state, "enrolled")
        committed = self.authority.read()
        with publication_lease(committed.installation) as lease, self.assertRaises(OSError):
            self.publish(committed, lease)
        self.assertTrue(self.authority.read() == committed)

    def test_unelevated_reads_work_but_authority_changes_and_deletion_are_denied(self):
        before = self.authority.read()
        with unelevated():
            self.assertEqual(self.workflow().status().state, "not-enrolled")
            for right in (winreg.KEY_SET_VALUE, 0x10000, 0x40000, 0x80000):
                with self.subTest(right=right), self.assertRaises(PermissionError):
                    winreg.OpenKey(winreg.HKEY_LOCAL_MACHINE, self.key, 0,
                                   right | winreg.KEY_WOW64_64KEY)
            with self.assertRaises(PermissionError):
                winreg.DeleteKeyEx(winreg.HKEY_LOCAL_MACHINE, self.key, winreg.KEY_WOW64_64KEY)
            with self.assertRaises(OSError):
                self.authority.commit(self.owner, "a" * 32, "b" * 64)
        self.assertTrue(self.authority.read() == before)

    def test_deleted_and_rolled_back_user_state_cannot_reopen_real_machine_authority(self):
        workflow = self.workflow()
        root = Path(self.directory.name)
        with unelevated():
            self.assertEqual(workflow.start(consented=True).state, "save-code")
            reservation = (root / "ownership.bin").read_bytes()
            self.assertEqual(workflow.complete(code_saved=True).state, "enrolled")
            self.assertEqual(self.workflow().status().state, "enrolled")
            for file in root.iterdir():
                file.unlink()
            self.assertEqual(self.workflow().start(consented=True).state, "damaged")
            (root / "ownership.bin").write_bytes(reservation)
            self.assertEqual(self.workflow().start(consented=True).state, "damaged")
        self.authority.install(self.owner)
        self.assertTrue(self.authority.read().profile)
        self.assertEqual(self.workflow().status().state, "damaged")


if __name__ == "__main__":
    unittest.main()
