"""Real process death and Windows marker handles; synthetic HKCU publication.

The external helper fixture represents the privileged OS outcome. It is never
elevated and invokes no capture or Windows verification API.
"""

import subprocess
import sys
import tempfile
import time
import unittest
from pathlib import Path

from pc_biometric.enrollment import Enrollment, References
from registry_fixture import authority_for


HELPER = r'''
import json, sys, time, winreg
from pathlib import Path
from ctypes import wintypes as wt
from pc_biometric.authority import RegistryAuthority
from pc_biometric.windows import _api
root, request = Path(sys.argv[1]), json.loads(sys.argv[2])
handles, outcome = [], "rejected"
try:
    if request["phase"] == "before-handoff":
        (root / "helper-ready").touch()
        deadline = time.monotonic() + 8
        while not (root / "release-helper").exists() and time.monotonic() < deadline:
            time.sleep(.01)
    for name in request["markers"]:
        handle = _api("kernel32", "OpenEventW", wt.HANDLE, wt.DWORD, wt.BOOL, wt.LPCWSTR)(
            0x100000, False, name)
        if not handle:
            raise OSError("Original operation has ended")
        handles.append(handle)
    (root / "helper-ready").touch()
    deadline = time.monotonic() + 8
    while not (root / "release-helper").exists() and time.monotonic() < deadline:
        time.sleep(.01)
    if not (root / "release-helper").exists():
        raise TimeoutError("Test did not release helper")
    candidate = request["candidate"]
    RegistryAuthority(key=request["key"], hive=winreg.HKEY_CURRENT_USER).commit(
        candidate["owner"], candidate["profile"], candidate["digest"], installation=candidate["installation"])
    outcome = "committed"
except Exception:
    pass
finally:
    for handle in reversed(handles):
        _api("kernel32", "CloseHandle", wt.BOOL, wt.HANDLE)(handle)
    (root / "helper-outcome").write_text(outcome)
'''

PARENT = r'''
import json, os, subprocess, sys, time
from pathlib import Path
from dataclasses import asdict
sys.path.insert(0, "tests")
from registry_fixture import authority_for
from pc_biometric.enrollment import Enrollment, References
from pc_biometric.coordination import marker_names
root = Path(sys.argv[1])
authority = authority_for(root)
def publish(candidate, lease):
    request = {"candidate": asdict(candidate), "key": authority.key,
               "markers": marker_names(candidate.installation, lease), "phase": sys.argv[2]}
    subprocess.Popen([sys.executable, "-c", sys.argv[3], str(root), json.dumps(request)],
                     stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                     creationflags=subprocess.CREATE_NO_WINDOW)
    deadline = time.monotonic() + 5
    while not (root / "helper-ready").exists() and time.monotonic() < deadline:
        time.sleep(.01)
    if not (root / "helper-ready").exists():
        raise TimeoutError("Helper did not start")
    os._exit(71)
workflow = Enrollment(root, authority=authority, publish=publish, account=lambda: "synthetic-owner",
                      verify_windows=lambda: True, capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
assert workflow.start(consented=True).state == "save-code"
workflow.complete(code_saved=True)
raise AssertionError("Parent should have exited")
'''


class PublicationCrashTests(unittest.TestCase):
    def test_parent_death_before_or_after_helper_handoff_cannot_publish_over_a_new_setup(self):
        for phase in ("before-handoff", "after-handoff"):
            with self.subTest(phase=phase), tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                authority = authority_for(root)
                restarted = Enrollment(root, authority=authority, account=lambda: "synthetic-owner",
                                       verify_windows=lambda: True,
                                       capture=lambda: References(b"new-synthetic-face", b"new-synthetic-voice"))
                try:
                    parent = subprocess.run([sys.executable, "-c", PARENT, directory, phase, HELPER], timeout=10,
                                            creationflags=subprocess.CREATE_NO_WINDOW)
                    self.assertEqual(parent.returncode, 71)
                    state = restarted.start(consented=True).state
                    self.assertEqual(state, "save-code" if phase == "before-handoff" else "busy")
                    (root / "release-helper").touch()
                    deadline = time.monotonic() + 5
                    while not (root / "helper-outcome").exists() and time.monotonic() < deadline:
                        time.sleep(.01)
                    outcome = (root / "helper-outcome").read_text()
                    self.assertEqual(outcome, "rejected" if phase == "before-handoff" else "committed")
                    if phase == "before-handoff":
                        self.assertEqual(restarted.complete(code_saved=True).state, "enrolled")
                    self.assertEqual(restarted.status().state, "enrolled")
                finally:
                    (root / "release-helper").touch()
                    restarted.cancel()


if __name__ == "__main__":
    unittest.main()
