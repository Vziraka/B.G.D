"""Public enrollment using native Windows boundaries; never opens an auth prompt."""

from pathlib import Path
from threading import Event
import ctypes as ct
from ctypes import wintypes as wt
import tkinter as tk
import tempfile
import unittest
from unittest.mock import patch

from pc_biometric.enrollment import References
from pc_biometric.windows import SessionGuard, WindowsVerification, current_account, top_level_window
from registry_fixture import Enrollment as fixture_enrollment


def Enrollment(directory, **kwargs):
    return fixture_enrollment(directory, fixture_owner=current_account(), **kwargs)


class ConsentApi:
    """Controlled Windows COM boundary. No Windows verification request is sent."""

    def __init__(self, result=0, *, cancel=None, status=1, on_result=None):
        self.keepalive = []
        self.requests = 0
        self.result = result
        self.status = status
        self.cancel = cancel
        self.on_result = on_result
        self.actual_dll = ct.WinDLL
        self.info = self.interface(11, {
            7: ([ct.POINTER(ct.c_int)], self.get_status),
            9: ([], lambda _this: 0), 10: ([], lambda _this: 0),
        })
        self.operation = self.interface(9, {
            0: ([ct.c_void_p, ct.POINTER(ct.c_void_p)], self.query_info),
            8: ([ct.POINTER(ct.c_int)], self.get_results),
        })
        self.factory = self.interface(7, {
            6: ([wt.HWND, ct.c_void_p, ct.c_void_p, ct.POINTER(ct.c_void_p)], self.request),
        })

    def interface(self, count, methods):
        table = (ct.c_void_p * count)()
        methods[2] = ([], lambda _this: 1)  # Release
        for index, (args, function) in methods.items():
            callback = ct.WINFUNCTYPE(wt.LONG, ct.c_void_p, *args)(function)
            self.keepalive.append(callback)
            table[index] = ct.cast(callback, ct.c_void_p).value
        instance = ct.pointer(ct.cast(table, ct.c_void_p))
        self.keepalive.extend((table, instance))
        return ct.cast(instance, ct.c_void_p).value

    def get_status(self, _this, target):
        target[0] = self.status
        if self.cancel is not None:
            self.cancel.set()
        return 0

    def query_info(self, _this, _iid, target):
        target[0] = self.info
        return 0

    def get_results(self, _this, target):
        target[0] = self.result
        if self.on_result is not None:
            self.on_result()
        return 0

    def request(self, _this, _hwnd, _message, _iid, target):
        self.requests += 1
        target[0] = self.operation
        return 0

    def dll(self, name, **kwargs):
        library = self.actual_dll(name, **kwargs)
        if name == "combase":
            def activate(_name, _iid, target):
                ct.cast(target, ct.POINTER(ct.c_void_p))[0] = self.factory
                return 0
            library.RoGetActivationFactory = activate
        return library


class WindowsEnrollmentTests(unittest.TestCase):
    def test_session_lock_notification_invalidates_pending_enrollment(self):
        root = tk.Tk()
        guard = None
        try:
            root.withdraw()
            root.update_idletasks()
            cancelled = Event()
            callbacks = []
            guard = SessionGuard(top_level_window(root.winfo_id()), cancelled,
                                 lambda: callbacks.append("interrupted"))
            guard.dispatch(0x02B1, 0x7)  # WM_WTSSESSION_CHANGE / WTS_SESSION_LOCK
            self.assertTrue(cancelled.is_set())
            self.assertEqual(callbacks, ["interrupted"])
            cancelled.clear()  # A later Enrollment.start() rearms its operation Event.
            guard.dispatch(0x02B1, 0x2)  # WTS_CONSOLE_DISCONNECT
            self.assertTrue(cancelled.is_set())
            self.assertEqual(callbacks, ["interrupted", "interrupted"])
        finally:
            if guard is not None:
                guard.close()
            root.destroy()

    def test_async_cancel_error_and_unknown_status_never_enroll(self):
        root = tk.Tk()
        try:
            root.withdraw()
            root.update_idletasks()
            for status in (2, 3, 99):
                with self.subTest(status=status), tempfile.TemporaryDirectory() as directory:
                    windows = WindowsVerification(root.winfo_id(), Event())
                    api = ConsentApi(status=status)
                    workflow = Enrollment(Path(directory), account=current_account,
                                          verify_windows=windows.verify,
                                          capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
                    with patch("ctypes.WinDLL", side_effect=api.dll):
                        self.assertEqual(workflow.start(consented=True).state, "denied")
                    self.assertFalse((Path(directory) / "ownership.bin").exists())
        finally:
            root.destroy()

    def test_cancelled_windows_request_discards_completed_success(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            try:
                root.withdraw()
                root.update_idletasks()
                cancelled = Event()
                windows = WindowsVerification(root.winfo_id(), cancelled)
                api = ConsentApi(cancel=cancelled)
                workflow = Enrollment(Path(directory), account=current_account,
                                      verify_windows=windows.verify,
                                      capture=lambda: References(b"synthetic-face", b"synthetic-voice"),
                                      cancelled=cancelled)
                with patch("ctypes.WinDLL", side_effect=api.dll):
                    self.assertEqual(workflow.start(consented=True).state, "cancelled")
                self.assertFalse((Path(directory) / "ownership.bin").exists())
                self.assertEqual(workflow.complete(code_saved=True).state, "denied")
            finally:
                root.destroy()

    def test_closed_application_window_discards_late_windows_success(self):
        with tempfile.TemporaryDirectory() as directory:
            root = tk.Tk()
            root.withdraw()
            root.update_idletasks()
            windows = WindowsVerification(root.winfo_id(), Event())
            api = ConsentApi(on_result=root.destroy)
            workflow = Enrollment(Path(directory), account=current_account,
                                  verify_windows=windows.verify,
                                  capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
            try:
                with patch("ctypes.WinDLL", side_effect=api.dll):
                    self.assertEqual(workflow.start(consented=True).state, "denied")
                self.assertFalse((Path(directory) / "ownership.bin").exists())
            finally:
                workflow.cancel()

    def test_only_completed_verified_windows_result_allows_enrollment(self):
        root = tk.Tk()
        try:
            root.withdraw()
            root.update_idletasks()
            for result, expected in ((0, "save-code"), (1, "denied"), (2, "denied"),
                                     (3, "denied"), (4, "denied"), (5, "denied"),
                                     (6, "denied"), (99, "denied")):
                with self.subTest(result=result), tempfile.TemporaryDirectory() as directory:
                    api = ConsentApi(result)
                    windows = WindowsVerification(root.winfo_id(), Event())
                    workflow = Enrollment(Path(directory), account=current_account,
                                          verify_windows=windows.verify,
                                          capture=lambda: References(b"synthetic-face", b"synthetic-voice"))
                    try:
                        with patch("ctypes.WinDLL", side_effect=api.dll):
                            self.assertEqual(workflow.start(consented=True).state, expected)
                        self.assertEqual(api.requests, 1)
                    finally:
                        workflow.cancel()
        finally:
            root.destroy()

    def test_invalid_application_window_cannot_verify_or_start_capture(self):
        with tempfile.TemporaryDirectory() as directory:
            captured = []

            def capture():
                captured.append(True)
                return References(b"synthetic-face", b"synthetic-voice")

            windows = WindowsVerification(0, Event())
            workflow = Enrollment(Path(directory), account=current_account,
                                  verify_windows=windows.verify, capture=capture)
            self.assertEqual(workflow.start(consented=True).state, "denied")
            self.assertEqual(captured, [])
            self.assertFalse((Path(directory) / "ownership.bin").exists())


if __name__ == "__main__":
    unittest.main()
