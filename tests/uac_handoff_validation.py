"""Explicit NON-BIOMETRIC test of the real unelevated-to-UAC publisher path.

Run `python tests/uac_handoff_validation.py` from a normal shell. Two UAC
approvals are needed: temporary machine fixture setup/cleanup, then publication.
Windows verification and references are synthetic; capture is never imported.
No production authority is created. The fixture exits after cleanup or 180 s.
"""

import ctypes as ct
from ctypes import wintypes as wt
from functools import partial
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import time
import unittest
import uuid
import winreg

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT))

from pc_biometric.authority import RegistryAuthority, is_elevated
from pc_biometric.enrollment import Enrollment, References
from pc_biometric.publication import ShellExecuteInfo, publish_elevated
from pc_biometric.windows import _api, current_account


def fixture(directory, key):
    if not is_elevated() or not re.fullmatch(r"SOFTWARE\\BGD\.PCBiometricDesk\.Validation\.[0-9a-f]{32}", key):
        raise RuntimeError("Only an elevated, unique validation fixture is allowed")
    try:
        RegistryAuthority(key=key).install(current_account())
        deadline = time.monotonic() + 180
        while time.monotonic() < deadline and not (Path(directory) / "fixture-done").exists():
            time.sleep(.05)
    finally:
        try:
            winreg.DeleteKeyEx(winreg.HKEY_LOCAL_MACHINE, key, winreg.KEY_WOW64_64KEY)
        except FileNotFoundError:
            pass


class ActualUacHandoffTests(unittest.TestCase):
    def test_normal_process_enrollment_publishes_through_real_uac_and_resists_user_state_replay(self):
        self.assertFalse(is_elevated(), "Start this explicit test from a normal shell")
        key = "SOFTWARE\\BGD.PCBiometricDesk.Validation." + uuid.uuid4().hex
        authority = RegistryAuthority(key=key)
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            parameters = subprocess.list2cmdline(["-I", str(Path(__file__).resolve()), "--fixture", directory, key])
            info = ShellExecuteInfo(size=ct.sizeof(ShellExecuteInfo), mask=0x140, verb="runas",
                                    file=sys.executable, parameters=parameters, directory=str(ROOT), show=0)
            initialized = _api("ole32", "CoInitializeEx", wt.LONG, ct.c_void_p, wt.DWORD)(None, 2)
            self.assertGreaterEqual(initialized, 0)
            try:
                launched = _api("shell32", "ShellExecuteExW", wt.BOOL, ct.POINTER(ShellExecuteInfo))(ct.byref(info))
                self.assertTrue(launched and info.process, "Temporary fixture UAC was canceled or unavailable")
                try:
                    deadline = time.monotonic() + 15
                    while True:
                        try:
                            authority.read()
                            break
                        except FileNotFoundError:
                            if time.monotonic() >= deadline:
                                self.fail("Temporary machine fixture did not start")
                            time.sleep(.05)
                    workflow = Enrollment(root, authority=authority, account=current_account,
                                          verify_windows=lambda: True,
                                          capture=lambda: References(b"synthetic-face-only", b"synthetic-voice-only"),
                                          publish=partial(publish_elevated, key=key))
                    self.assertEqual(workflow.start(consented=True).state, "save-code")
                    reservation = (root / "ownership.bin").read_bytes()
                    self.assertEqual(workflow.complete(code_saved=True).state, "enrolled")
                    self.assertFalse(is_elevated(), "Normal enrollment process must never become elevated")
                    self.assertEqual(workflow.status().state, "enrolled")
                    for file in root.iterdir():
                        file.unlink()
                    self.assertEqual(workflow.start(consented=True).state, "damaged")
                    (root / "ownership.bin").write_bytes(reservation)
                    self.assertEqual(workflow.start(consented=True).state, "damaged")
                finally:
                    (root / "fixture-done").touch()
                    try:
                        waited = _api("kernel32", "WaitForSingleObject", wt.DWORD, wt.HANDLE, wt.DWORD)(
                            info.process, 10000)
                        self.assertEqual(waited, 0, "Temporary administrator fixture has not exited")
                        code = wt.DWORD()
                        self.assertTrue(_api("kernel32", "GetExitCodeProcess", wt.BOOL, wt.HANDLE,
                                             ct.POINTER(wt.DWORD))(info.process, ct.byref(code)))
                        self.assertEqual(code.value, 0, "Temporary administrator fixture cleanup failed")
                    finally:
                        _api("kernel32", "CloseHandle", wt.BOOL, wt.HANDLE)(info.process)
                with self.assertRaises(FileNotFoundError):
                    authority.read()
            finally:
                _api("ole32", "CoUninitialize", None)()


if __name__ == "__main__":
    if len(sys.argv) == 4 and sys.argv[1] == "--fixture":
        fixture(sys.argv[2], sys.argv[3])
    else:
        unittest.main(verbosity=2)
