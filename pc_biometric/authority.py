"""Machine ownership authority: admin setup writes, ordinary read-only operation.

HKCU/key injection is for isolated registry tests only; no launcher option exposes
it. The production HKLM boundary additionally verifies its owner and exact ACL.
"""

from contextlib import contextmanager
from collections.abc import Iterator
import ctypes as ct
from ctypes import wintypes as wt
from dataclasses import asdict, dataclass
import json
import hashlib
import winreg
from uuid import uuid4

from .windows import _api


KEY = r"SOFTWARE\BGD.PCBiometricDesk"
SDDL = "O:BAG:BAD:P(A;;KA;;;SY)(A;;KA;;;BA)(A;;KR;;;BU)"
MUTEX_SDDL = "O:BAG:BAD:P(A;;0x1f0001;;;SY)(A;;0x1f0001;;;BA)"


def is_elevated() -> bool:
    return bool(_api("shell32", "IsUserAnAdmin", wt.BOOL)())


@dataclass(frozen=True)
class AuthorityState:
    installation: str
    owner: str
    profile: str = ""
    digest: str = ""

    def __post_init__(self) -> None:
        if (not all(isinstance(item, str) for item in (self.installation, self.owner, self.profile, self.digest))
                or not self.owner or len(self.owner) > 256):
            raise ValueError("Invalid designated account.")
        for item, length in ((self.installation, 32), (self.profile, 32), (self.digest, 64)):
            if item and (len(item) != length or any(char not in "0123456789abcdef" for char in item)):
                raise ValueError("Invalid ownership record.")
        if not self.installation or bool(self.profile) != bool(self.digest):
            raise ValueError("Incomplete ownership record.")


def _checked(result: int) -> None:
    if result != 0:
        raise OSError(result, "Protected ownership authority is unavailable.")


@contextmanager
def _descriptor(sddl: str = SDDL) -> Iterator[ct.c_void_p]:
    descriptor = ct.c_void_p()
    if not _api("advapi32", "ConvertStringSecurityDescriptorToSecurityDescriptorW", wt.BOOL,
                wt.LPCWSTR, wt.DWORD, ct.POINTER(ct.c_void_p), ct.c_void_p)(
            sddl, 1, ct.byref(descriptor), None):
        raise OSError("Cannot protect ownership authority.")
    try:
        yield descriptor
    finally:
        _api("kernel32", "LocalFree", ct.c_void_p, ct.c_void_p)(descriptor)


class SecurityAttributes(ct.Structure):
    _fields_ = [("length", wt.DWORD), ("descriptor", ct.c_void_p), ("inherit", wt.BOOL)]


def _validate_acl(key: winreg.HKEYType | int, *, mutex: bool = False) -> None:
    descriptor = ct.c_void_p()
    _checked(_api("advapi32", "GetSecurityInfo", wt.DWORD, wt.HANDLE, ct.c_int, wt.DWORD,
                  ct.c_void_p, ct.c_void_p, ct.c_void_p, ct.c_void_p, ct.POINTER(ct.c_void_p))(
        int(key), 6 if mutex else 4, 7, None, None, None, None, ct.byref(descriptor)))
    text = wt.LPWSTR()
    try:
        if not _api("advapi32", "ConvertSecurityDescriptorToStringSecurityDescriptorW", wt.BOOL,
                    ct.c_void_p, wt.DWORD, wt.DWORD, ct.POINTER(wt.LPWSTR), ct.c_void_p)(
                descriptor, 1, 7, ct.byref(text), None):
            raise OSError("Cannot check authority permissions.")
        if text.value != (MUTEX_SDDL if mutex else SDDL):
            raise OSError("Authority permissions changed; enrollment stays closed.")
    finally:
        free = _api("kernel32", "LocalFree", ct.c_void_p, ct.c_void_p)
        if text:
            free(text)
        free(descriptor)


class RegistryAuthority:
    def __init__(self, *, key: str = KEY, hive: int = winreg.HKEY_LOCAL_MACHINE):
        self.key = key
        self.hive = hive

    @contextmanager
    def _write(self, *, install: bool = False) -> Iterator[tuple[int, bool]]:
        """Serialize privileged writers across processes/sessions; no user IPC.

        An unprivileged process squatting the mutex cannot impersonate this
        authority: the writer requires its exact admin-owned security descriptor.
        """
        # Registry names are case-insensitive; named kernel objects are not.
        identity = f"{self.hive}:" + self.key.rstrip("\\").casefold()
        name = "Global\\BGD.PCBiometricDesk." + hashlib.sha256(identity.encode()).hexdigest()
        with _descriptor(MUTEX_SDDL) as descriptor:
            attributes = SecurityAttributes(ct.sizeof(SecurityAttributes), descriptor, False)
            mutex = _api("kernel32", "CreateMutexW", wt.HANDLE, ct.c_void_p, wt.BOOL, wt.LPCWSTR)(
                ct.byref(attributes) if self.hive == winreg.HKEY_LOCAL_MACHINE else None, False, name)
        if not mutex:
            raise OSError("Administrator setup access is required.")
        acquired = False
        try:
            if self.hive == winreg.HKEY_LOCAL_MACHINE:
                _validate_acl(int(mutex), mutex=True)
            wait = _api("kernel32", "WaitForSingleObject", wt.DWORD, wt.HANDLE, wt.DWORD)(mutex, 0)
            if wait not in (0, 0x80):  # acquired or previous owner terminated
                raise OSError("Another protected setup operation is active.")
            acquired = True
            with _descriptor() as descriptor:
                attributes = SecurityAttributes(ct.sizeof(SecurityAttributes), descriptor, False)
                handle, created = wt.HKEY(), wt.DWORD()
                # Predefined HKEY values are sign-extended Windows LONG constants.
                hive = ct.c_void_p(ct.c_int32(self.hive).value)
                if install:
                    _checked(_api("advapi32", "RegCreateKeyExW", wt.LONG, wt.HKEY,
                                  wt.LPCWSTR, wt.DWORD, wt.LPWSTR, wt.DWORD, wt.DWORD,
                                  ct.c_void_p, ct.POINTER(wt.HKEY), ct.POINTER(wt.DWORD))(
                        hive, self.key, 0, None, 0, winreg.KEY_ALL_ACCESS | winreg.KEY_WOW64_64KEY,
                        ct.byref(attributes) if self.hive == winreg.HKEY_LOCAL_MACHINE else None,
                        ct.byref(handle), ct.byref(created)))
                else:
                    _checked(_api("advapi32", "RegOpenKeyExW", wt.LONG, wt.HKEY, wt.LPCWSTR,
                                  wt.DWORD, wt.DWORD, ct.POINTER(wt.HKEY))(
                        hive, self.key, 0, winreg.KEY_READ | winreg.KEY_SET_VALUE | winreg.KEY_WOW64_64KEY,
                        ct.byref(handle)))
                if not handle.value:
                    raise OSError("Missing protected registry handle.")
                key = int(handle.value)
                try:
                    if self.hive == winreg.HKEY_LOCAL_MACHINE:
                        _validate_acl(key)
                    yield key, created.value == 1
                    winreg.FlushKey(key)
                finally:
                    winreg.CloseKey(key)
        finally:
            if acquired:
                _api("kernel32", "ReleaseMutex", wt.BOOL, wt.HANDLE)(mutex)
            _api("kernel32", "CloseHandle", wt.BOOL, wt.HANDLE)(mutex)

    def _read(self, key: winreg.HKEYType | int) -> AuthorityState:
        data, kind = winreg.QueryValueEx(key, "State")
        try:
            if kind != winreg.REG_BINARY or not isinstance(data, bytes) or len(data) > 4096:
                raise ValueError
            value = json.loads(data)
            if (not isinstance(value, dict) or set(value) != {"installation", "owner", "profile", "digest"}
                    or not all(isinstance(item, str) for item in value.values())):
                raise ValueError
            return AuthorityState(**value)
        except (ValueError, TypeError):
            raise OSError("Ownership authority is damaged; enrollment stays closed.") from None

    def read(self) -> AuthorityState:
        # Never create, initialize, repair or downgrade on a normal read.
        with winreg.OpenKey(self.hive, self.key, 0, winreg.KEY_READ | winreg.KEY_WOW64_64KEY) as key:
            if self.hive == winreg.HKEY_LOCAL_MACHINE:
                _validate_acl(key)
            return self._read(key)

    def install(self, owner: str) -> None:
        """Explicit admin installation, idempotent for the same designated account."""
        if not owner or len(owner) > 256:
            raise ValueError("A designated Windows account is required.")
        with self._write(install=True) as (key, created):
            if not created:
                if self._read(key).owner != owner:
                    raise OSError("Existing installation belongs to a different Windows account.")
                return
            state = AuthorityState(uuid4().hex, owner)
            winreg.SetValueEx(key, "State", 0, winreg.REG_BINARY, json.dumps(asdict(state)).encode())

    def commit(self, owner: str, profile: str, digest: str, *, installation: str | None = None) -> None:
        """Initial enrollment only. No reset, update or recovery operation exists."""
        with self._write() as (key, created):
            if created:
                raise OSError("Installation authority is missing; enrollment stays closed.")
            state = self._read(key)
            if (state.owner != owner or state.profile
                    or (installation is not None and state.installation != installation)):
                raise OSError("Enrollment authority changed or is already committed.")
            updated = AuthorityState(state.installation, owner, profile, digest)
            if not updated.profile:
                raise ValueError("A complete enrollment is required.")
            winreg.SetValueEx(key, "State", 0, winreg.REG_BINARY, json.dumps(asdict(updated)).encode())
