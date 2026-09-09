"""Native desktop Windows verification. No API is called at import time.

Call verification on a worker thread with the real application's top-level HWND.
The UI must set the cancellation event on session interruption and window close.
This adapter is not enabled in the production launcher pending ticket 02 gates.
"""

from contextlib import contextmanager
import ctypes as ct
from ctypes import wintypes as wt
import os
from threading import Event
from collections.abc import Callable, Iterator
from typing import Any
from uuid import UUID, uuid5


def _api(library: str, name: str, result: Any, *arguments: Any) -> Any:
    # Dynamic ctypes signatures stay confined to the native ABI boundary.
    function = getattr(ct.WinDLL(library, use_last_error=True), name)
    function.restype, function.argtypes = result, list(arguments)
    return function


def current_account() -> str:
    """Read the process token SID; never accept an environment/display account name."""
    token = wt.HANDLE()
    process = _api("kernel32", "GetCurrentProcess", wt.HANDLE)()
    if not _api("advapi32", "OpenProcessToken", wt.BOOL, wt.HANDLE, wt.DWORD,
                ct.POINTER(wt.HANDLE))(process, 8, ct.byref(token)):  # TOKEN_QUERY
        raise OSError("Windows account verification is unavailable.")
    try:
        size = wt.DWORD()
        query = _api("advapi32", "GetTokenInformation", wt.BOOL, wt.HANDLE, ct.c_int,
                     ct.c_void_p, wt.DWORD, ct.POINTER(wt.DWORD))
        query(token, 1, None, 0, ct.byref(size))  # TokenUser
        if not 0 < size.value <= 65536:
            raise OSError("Windows account verification is unavailable.")
        data = ct.create_string_buffer(size.value)
        if not query(token, 1, data, size, ct.byref(size)):
            raise OSError("Windows account verification is unavailable.")
        sid = ct.cast(data, ct.POINTER(ct.c_void_p))[0]  # TOKEN_USER begins with SID*
        text = wt.LPWSTR()
        if not _api("advapi32", "ConvertSidToStringSidW", wt.BOOL, ct.c_void_p,
                    ct.POINTER(wt.LPWSTR))(sid, ct.byref(text)):
            raise OSError("Windows account verification is unavailable.")
        try:
            return str(text.value)
        finally:
            _api("kernel32", "LocalFree", ct.c_void_p, ct.c_void_p)(text)
    finally:
        _api("kernel32", "CloseHandle", wt.BOOL, wt.HANDLE)(token)


def top_level_window(hwnd: int) -> int:
    """Return this process's top-level HWND for native desktop integration."""
    root = int(_api("user32", "GetAncestor", wt.HWND, wt.HWND, wt.UINT)(hwnd, 2) or 0)
    if not root:
        raise OSError("Application window is unavailable.")
    process_id = wt.DWORD()
    if (not _api("user32", "GetWindowThreadProcessId", wt.DWORD, wt.HWND,
                 ct.POINTER(wt.DWORD))(root, ct.byref(process_id))
            or process_id.value != os.getpid()):
        raise OSError("Application window is unavailable.")
    return root


def _check(result: int) -> None:
    if result < 0:
        raise OSError("Windows verification is unavailable.")


def _guid(value: str) -> ct.Array[ct.c_char]:
    return ct.create_string_buffer(UUID(value).bytes_le, 16)


def _method(pointer: ct.c_void_p, index: int, *arguments: Any) -> Any:
    table = ct.cast(pointer, ct.POINTER(ct.POINTER(ct.c_void_p))).contents
    return ct.WINFUNCTYPE(wt.LONG, ct.c_void_p, *arguments)(table[index])


@contextmanager
def _hstring(value: str) -> Iterator[ct.c_void_p]:
    string = ct.c_void_p()
    _check(_api("combase", "WindowsCreateString", wt.LONG, wt.LPCWSTR, wt.UINT,
                ct.POINTER(ct.c_void_p))(value, len(value.encode("utf-16-le")) // 2, ct.byref(string)))
    try:
        yield string
    finally:
        _api("combase", "WindowsDeleteString", wt.LONG, ct.c_void_p)(string)


@contextmanager
def _factory(iid: str) -> Iterator[ct.c_void_p]:
    # MTA worker thread; never change the apartment of a preinitialized UI thread.
    _check(_api("combase", "RoInitialize", wt.LONG, wt.UINT)(1))
    factory = ct.c_void_p()
    try:
        with _hstring("Windows.Security.Credentials.UI.UserConsentVerifier") as name:
            _check(_api("combase", "RoGetActivationFactory", wt.LONG, ct.c_void_p,
                        ct.c_void_p, ct.POINTER(ct.c_void_p))(name, _guid(iid), ct.byref(factory)))
        if not factory:
            raise OSError("Windows verification is unavailable.")
        yield factory
    finally:
        if factory:
            _method(factory, 2)(factory)  # IUnknown::Release
        _api("combase", "RoUninitialize", None)()


def _wait(operation: ct.c_void_p, cancelled: Event) -> int | None:
    """Wait for the WinRT enum result, never infer success from S_OK/request start."""
    if not operation:
        raise OSError("Windows verification is unavailable.")
    info = ct.c_void_p()
    try:
        _check(_method(operation, 0, ct.c_void_p, ct.POINTER(ct.c_void_p))(
            operation, _guid("00000036-0000-0000-c000-000000000046"), ct.byref(info)))
        if not info:
            raise OSError("Windows verification is unavailable.")
        status = ct.c_int()
        while True:
            _check(_method(info, 7, ct.POINTER(ct.c_int))(info, ct.byref(status)))
            if cancelled.is_set():
                _method(info, 9)(info)  # IAsyncInfo::Cancel (best effort)
                return None
            if status.value != 0:  # AsyncStatus::Started
                break
            cancelled.wait(0.025)
        if status.value != 1:  # only AsyncStatus::Completed may yield a result
            return None
        result = ct.c_int()
        _check(_method(operation, 8, ct.POINTER(ct.c_int))(operation, ct.byref(result)))
        return None if cancelled.is_set() else result.value
    finally:
        if info:
            _method(info, 10)(info)  # Close may fail if cancellation is still pending.
            _method(info, 2)(info)
        _method(operation, 2)(operation)


class WindowsVerification:
    def __init__(self, hwnd: int, cancelled: Event):
        self.hwnd = hwnd
        self.cancelled = cancelled

    def verify(self) -> bool:
        """Only a completed Verified result counts; launching the prompt never does."""
        if self.cancelled.is_set() or not self._owns_window():
            return False
        with _factory("39e050c3-4e74-441a-8dc0-b81104df949c") as factory:
            operation = ct.c_void_p()
            # Windows Runtime's documented parameterized-IID algorithm, not a
            # security primitive. The enum is a signed 32-bit WinRT value.
            signature = ("pinterface({9fc2b0bb-e446-44e2-aa61-9cab8f636af2};"
                         "enum(Windows.Security.Credentials.UI.UserConsentVerificationResult;i4))")
            iid = uuid5(UUID("11f47ad5-7b73-42c0-abae-878b1e16adee"), signature)
            with _hstring("Confirm the designated owner Windows account for B.G.D enrollment.") as message:
                if self.cancelled.is_set():
                    return False
                _check(_method(factory, 6, wt.HWND, ct.c_void_p, ct.c_void_p,
                               ct.POINTER(ct.c_void_p))(
                    factory, self.hwnd, message, _guid(str(iid)), ct.byref(operation)))
            return _wait(operation, self.cancelled) == 0 and self._owns_window()  # Verified

    def _owns_window(self) -> bool:
        process_id = wt.DWORD()
        thread_id = _api("user32", "GetWindowThreadProcessId", wt.DWORD, wt.HWND,
                         ct.POINTER(wt.DWORD))(self.hwnd, ct.byref(process_id))
        return bool(thread_id and process_id.value == os.getpid())


_WindowProcedure = ct.WINFUNCTYPE(ct.c_ssize_t, wt.HWND, wt.UINT, ct.c_size_t, ct.c_ssize_t)


class SessionGuard:
    """Invalidate an operation when Windows leaves the active desktop session."""

    def __init__(self, hwnd: int, cancelled: Event, interrupted: Callable[[], None]):
        self.hwnd = hwnd
        self.cancelled = cancelled
        self.interrupted = interrupted
        self.closed = False
        self.procedure = _WindowProcedure(self._window_procedure)
        if not _api("wtsapi32", "WTSRegisterSessionNotification", wt.BOOL,
                    wt.HWND, wt.DWORD)(hwnd, 0):  # NOTIFY_FOR_THIS_SESSION
            raise OSError("Windows session notifications are unavailable.")
        ct.set_last_error(0)
        self.original = int(_api("user32", "SetWindowLongPtrW", ct.c_ssize_t,
                                 wt.HWND, ct.c_int, ct.c_void_p)(
                                     hwnd, -4, ct.cast(self.procedure, ct.c_void_p)) or 0)
        if not self.original and ct.get_last_error():
            _api("wtsapi32", "WTSUnRegisterSessionNotification", wt.BOOL, wt.HWND)(hwnd)
            raise OSError("Windows session notifications are unavailable.")

    def dispatch(self, message: int, reason: int) -> None:
        invalidating = (message in (0x0011, 0x0016)  # query/end session
                        or message == 0x02B1 and reason in (0x2, 0x4, 0x6, 0x7))
        if invalidating and not self.cancelled.is_set():
            self.cancelled.set()
            self.interrupted()

    def _window_procedure(self, hwnd: int, message: int, wparam: int, lparam: int) -> int:
        try:
            self.dispatch(message, wparam)
        finally:
            return int(_api("user32", "CallWindowProcW", ct.c_ssize_t, ct.c_void_p,
                            wt.HWND, wt.UINT, ct.c_size_t, ct.c_ssize_t)(
                                self.original, hwnd, message, wparam, lparam))

    def close(self) -> None:
        if self.closed:
            return
        self.closed = True
        _api("wtsapi32", "WTSUnRegisterSessionNotification", wt.BOOL, wt.HWND)(self.hwnd)
        if self.original:
            _api("user32", "SetWindowLongPtrW", ct.c_ssize_t, wt.HWND, ct.c_int,
                 ct.c_void_p)(self.hwnd, -4, ct.c_void_p(self.original))
