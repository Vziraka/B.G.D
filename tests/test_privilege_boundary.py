"""No elevation or credential dialogs: controlled native privilege query only."""

from contextlib import redirect_stdout
from io import StringIO
from types import SimpleNamespace
from unittest.mock import MagicMock, patch
import unittest
import tempfile
from pathlib import Path
import ctypes as ct
import base64
import json
import subprocess
from functools import partial
from ctypes import wintypes as wt

from pc_biometric.enrollment import Enrollment, References
from registry_fixture import authority_for
from pc_biometric.authority import AuthorityState
from pc_biometric.windows import _api

from pc_biometric.__main__ import main


class PrivilegeBoundaryTests(unittest.TestCase):
    def test_timed_out_live_publisher_keeps_new_setup_closed_until_its_result_is_known(self):
        from pc_biometric.coordination import marker_names
        retained = []
        proposal = []
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            authority = authority_for(root)

            def timed_out(candidate, lease):
                for name in marker_names(candidate.installation, lease):
                    handle = _api("kernel32", "OpenEventW", wt.HANDLE, wt.DWORD, wt.BOOL, wt.LPCWSTR)(
                        0x100000, False, name)
                    self.assertTrue(handle)
                    retained.append(handle)
                proposal.append(candidate)
                raise TimeoutError("Controlled external helper remains running")

            workflow = Enrollment(root, authority=authority, publish=timed_out,
                                  account=lambda: "synthetic-owner", verify_windows=lambda: True,
                                  capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
            self.assertEqual(workflow.start(consented=True).state, "save-code")
            self.assertEqual(workflow.complete(code_saved=True).state, "unavailable")
            try:
                self.assertEqual(workflow.start(consented=True).state, "busy")
                candidate = proposal[0]
                authority.commit(candidate.owner, candidate.profile, candidate.digest,
                                 installation=candidate.installation)
            finally:
                for handle in reversed(retained):
                    _api("kernel32", "CloseHandle", wt.BOOL, wt.HANDLE)(handle)
            self.assertEqual(workflow.status().state, "enrolled")

    def test_system_helper_rejects_wrong_account_without_any_elevation_request(self):
        from pc_biometric.publication import publication_command
        candidate = AuthorityState("a" * 32, "deliberately-unmatched-account", "b" * 32, "c" * 64)
        result = subprocess.run(["powershell.exe", *publication_command(candidate, "d" * 32).split()],
                                capture_output=True, text=True, timeout=15,
                                creationflags=subprocess.CREATE_NO_WINDOW)
        self.assertEqual(result.returncode, 1)
        self.assertEqual(result.stdout, "")
        self.assertEqual(result.stderr, "")

    def test_native_publication_keeps_enrollment_unelevated_and_rejects_uac_cancellation(self):
        from pc_biometric.publication import publish_elevated, ShellExecuteInfo
        real_dll = ct.WinDLL
        for accepted in (False, True):
            with self.subTest(accepted=accepted), tempfile.TemporaryDirectory() as directory:
                root = Path(directory)
                authority = authority_for(root)
                observed = []
                validation_key = "SOFTWARE\\BGD.PCBiometricDesk.Validation." + "f" * 32

                def launch(pointer):
                    info = ct.cast(pointer, ct.POINTER(ShellExecuteInfo)).contents
                    self.assertEqual(info.verb, "runas")
                    self.assertTrue(Path(info.file).is_absolute())
                    self.assertEqual(info.show, 0)
                    command = base64.b64decode(info.parameters.split()[-1]).decode("utf-16-le")
                    self.assertIn(validation_key, command)
                    # Only the four public registry metadata fields cross this OS boundary.
                    candidate = json.loads(base64.b64decode(command.split("'")[1]))
                    observed.append(candidate)
                    self.assertNotIn("synthetic-face", command)
                    self.assertNotIn("synthetic-voice", command)
                    if accepted:
                        authority.commit(candidate["owner"], candidate["profile"], candidate["digest"],
                                         installation=candidate["installation"])
                        info.process = 123
                        return 1
                    return 0

                shell = MagicMock()
                shell.IsUserAnAdmin.return_value = 0
                shell.ShellExecuteExW.side_effect = launch
                ole = real_dll("ole32", use_last_error=True)
                fake_ole = MagicMock()
                fake_ole.CoInitializeEx = ole.CoInitializeEx
                fake_ole.CoUninitialize = ole.CoUninitialize
                fake_ole.CoWaitForMultipleHandles.return_value = 0
                kernel = real_dll("kernel32", use_last_error=True)
                fake_kernel = MagicMock(wraps=kernel)
                kernel.WaitForSingleObject.argtypes = [wt.HANDLE, wt.DWORD]
                kernel.WaitForSingleObject.restype = wt.DWORD
                fake_kernel.WaitForSingleObject.side_effect = lambda handle, timeout: (
                    0 if handle == 123 else kernel.WaitForSingleObject(handle, timeout))
                def exit_code(handle, pointer):
                    ct.cast(pointer, ct.POINTER(wt.DWORD))[0] = 0
                    return 1
                fake_kernel.GetExitCodeProcess.side_effect = exit_code
                kernel.CloseHandle.argtypes = [wt.HANDLE]
                kernel.CloseHandle.restype = wt.BOOL
                fake_kernel.CloseHandle.side_effect = lambda handle: (
                    1 if handle == 123 else kernel.CloseHandle(handle))
                def dll(name, **kwargs):
                    if name == "shell32":
                        return shell
                    if name == "ole32":
                        return fake_ole
                    if name == "kernel32":
                        # Keep real token/DPAPI/file-related functions unaffected.
                        for function in ("GetSystemDirectoryW", "GetCurrentProcess", "LocalFree",
                                         "CreateMutexW", "ReleaseMutex", "CreateEventW", "OpenEventW"):
                            setattr(fake_kernel, function, getattr(kernel, function))
                        return fake_kernel
                    return real_dll(name, **kwargs)
                workflow = Enrollment(root, authority=authority, publish=partial(publish_elevated, key=validation_key),
                                      account=lambda: "synthetic-owner", verify_windows=lambda: True,
                                      capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
                self.assertEqual(workflow.start(consented=True).state, "save-code")
                with patch("ctypes.WinDLL", side_effect=dll):
                    result = workflow.complete(code_saved=True)
                self.assertEqual(result.state, "enrolled" if accepted else "unavailable")
                self.assertEqual(len(observed), 1)
                self.assertEqual(workflow.status().state, "enrolled" if accepted else "not-enrolled")

    def test_helper_success_without_exact_publication_cannot_complete_enrollment(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            authority = authority_for(root)
            workflow = Enrollment(root, authority=authority, publish=lambda candidate, lease: None,
                                  account=lambda: "synthetic-owner", verify_windows=lambda: True,
                                  capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
            self.assertEqual(workflow.start(consented=True).state, "save-code")
            self.assertEqual(workflow.complete(code_saved=True).state, "unavailable")
            self.assertEqual(workflow.status().state, "not-enrolled")

    def test_authority_installer_without_administrator_access_does_not_install(self):
        from pc_biometric.setup_authority import main as install
        dll = MagicMock()
        dll.IsUserAnAdmin.return_value = 0
        with patch("ctypes.WinDLL", return_value=dll), redirect_stdout(StringIO()) as output:
            self.assertEqual(install(), 2)
        self.assertIn("administrator", output.getvalue())

    def test_normal_launch_refuses_an_elevated_token(self):
        dll = MagicMock()
        dll.IsUserAnAdmin.return_value = 1
        with patch("ctypes.WinDLL", return_value=dll), patch("sys.argv", ["pc_biometric", "--check"]), \
                patch("subprocess.run", return_value=SimpleNamespace(returncode=0, stdout="0", stderr="")), \
                redirect_stdout(StringIO()) as output:
            self.assertEqual(main(), 2)
        self.assertIn("unelevated", output.getvalue())


if __name__ == "__main__":
    unittest.main()
