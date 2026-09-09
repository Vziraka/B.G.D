"""Publication lifetime markers shared by the desk process and one-shot helper.

The fixed marker blocks a new setup while either process holds it. The unique
marker prevents a delayed helper from joining a different attempt after its
parent dies. The helper opens fixed THEN unique; both are opened without creation.
These coordinate operations; only the HKLM authority establishes ownership.
"""

from contextlib import contextmanager
from collections.abc import Iterator
import ctypes as ct
from ctypes import wintypes as wt
from uuid import uuid4

from .windows import _api


def marker_names(installation: str, lease: str) -> tuple[str, str]:
    if any(len(value) != 32 or any(c not in "0123456789abcdef" for c in value)
           for value in (installation, lease)):
        raise ValueError("Invalid publication lifetime marker.")
    busy = "Global\\BGD.PCBiometricDesk.Setup." + installation
    return busy, busy + "." + lease


def publication_pending(installation: str) -> bool:
    name, _ = marker_names(installation, "0" * 32)
    handle = _api("kernel32", "OpenEventW", wt.HANDLE, wt.DWORD, wt.BOOL, wt.LPCWSTR)(0x100000, False, name)
    if handle:
        _api("kernel32", "CloseHandle", wt.BOOL, wt.HANDLE)(handle)
        return True
    # Permission denial or unexpected object type is never evidence of absence.
    return ct.get_last_error() != 2  # ERROR_FILE_NOT_FOUND


@contextmanager
def publication_lease(installation: str) -> Iterator[str]:
    lease = uuid4().hex
    handles = []
    try:
        for name in marker_names(installation, lease):
            ct.set_last_error(0)
            handle = _api("kernel32", "CreateEventW", wt.HANDLE, ct.c_void_p, wt.BOOL, wt.BOOL, wt.LPCWSTR)(
                None, True, False, name)
            exists = ct.get_last_error() == 183  # ERROR_ALREADY_EXISTS
            if not handle:
                raise OSError("Publication coordination is unavailable.")
            handles.append(handle)
            if exists:
                raise OSError("An earlier enrollment publication is still active.")
        yield lease
    finally:
        # Close the unique marker first; the fixed marker must outlive it.
        for handle in reversed(handles):
            _api("kernel32", "CloseHandle", wt.BOOL, wt.HANDLE)(handle)
