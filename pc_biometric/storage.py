"""User DPAPI payload subordinate to the separately protected machine authority."""

import ctypes
from collections.abc import Callable
from ctypes import wintypes
from datetime import datetime, timezone
import hashlib
import json
import msvcrt
import os
from pathlib import Path
import tempfile
import time
from typing import BinaryIO
from typing import TypeVar
from uuid import uuid4

from .authority import AuthorityState, RegistryAuthority
from .publication import publish_elevated
from .coordination import publication_lease, publication_pending


class StorageError(Exception):
    pass


T = TypeVar("T")


def _trace(event: str, result: str, error: BaseException | None = None) -> None:
    """Optional, secret-free storage checkpoints for the temporary M1 diagnosis."""
    if os.environ.get("BGD_STORAGE_DIAGNOSTICS") != "1":
        return
    try:
        record: dict[str, str | int | None] = {
            "schema": 1,
            "timestamp_utc": datetime.now(timezone.utc).isoformat(timespec="microseconds"),
            "monotonic_ns": time.monotonic_ns(),
            "process_id": os.getpid(),
            "event": event,
            "result": result,
        }
        if error is not None:
            record.update(error_type=type(error).__name__,
                          winerror=getattr(error, "winerror", None),
                          errno=getattr(error, "errno", None))
        root = Path(os.environ.get("LOCALAPPDATA", str(Path.home())))
        path = root / "BGD" / "PCBiometricDesk" / "diagnostics" / "storage.jsonl"
        path.parent.mkdir(parents=True, exist_ok=True)
        with path.open("a", encoding="utf-8") as stream:
            stream.write(json.dumps(record, separators=(",", ":")) + "\n")
    except Exception:
        # Diagnosis must never change enrollment/storage results.
        pass


def _traced_step(event: str, operation: Callable[[], T]) -> T:
    _trace(event, "started")
    try:
        value = operation()
    except Exception as error:
        _trace(event, "failed", error)
        raise
    _trace(event, "succeeded")
    return value


def acquire_operation(directory: Path) -> BinaryIO:
    """Windows file lock is shared by processes and released on process termination."""
    directory.mkdir(parents=True, exist_ok=True)
    handle = (directory / "operation.lock").open("a+b")
    try:
        handle.seek(0)
        msvcrt.locking(handle.fileno(), msvcrt.LK_NBLCK, 1)
        return handle
    except OSError:
        handle.close()
        raise


class Blob(ctypes.Structure):
    _fields_ = [("size", wintypes.DWORD), ("data", ctypes.POINTER(ctypes.c_ubyte))]


def protect(data: bytes, *, decrypt: bool = False) -> bytes:
    """DPAPI encrypt/authenticate for this Windows account; forbid any platform UI."""
    crypt32 = ctypes.WinDLL("crypt32.dll", use_last_error=True)
    kernel32 = ctypes.WinDLL("kernel32.dll", use_last_error=True)
    buffer = (ctypes.c_ubyte * len(data)).from_buffer_copy(data)
    source, target = Blob(len(data), buffer), Blob()
    function = crypt32.CryptUnprotectData if decrypt else crypt32.CryptProtectData
    function.argtypes = [ctypes.POINTER(Blob), ctypes.c_void_p, ctypes.c_void_p,
                         ctypes.c_void_p, ctypes.c_void_p, wintypes.DWORD, ctypes.POINTER(Blob)]
    function.restype = wintypes.BOOL
    kernel32.LocalFree.argtypes = [ctypes.c_void_p]
    kernel32.LocalFree.restype = ctypes.c_void_p
    try:
        if not function(ctypes.byref(source), None, None, None, None, 1, ctypes.byref(target)):
            raise StorageError("Windows data protection failed.")
        return ctypes.string_at(target.data, target.size)
    finally:
        ctypes.memset(buffer, 0, len(buffer))
        if target.data:
            ctypes.memset(target.data, 0, target.size)
            kernel32.LocalFree(target.data)


def atomic_write(path: Path, content: bytes) -> None:
    """Replace one ciphertext file; machine authority commits the whole profile."""
    path.parent.mkdir(parents=True, exist_ok=True)
    descriptor, temporary = tempfile.mkstemp(prefix=".pending-", dir=path.parent)
    try:
        with os.fdopen(descriptor, "wb") as stream:
            stream.write(content)
            stream.flush()
            os.fsync(stream.fileno())
        # Windows replacement can fail while a status reader briefly has the
        # target open, even with delete-sharing. Retry that transient race only;
        # persistent sharing/permission errors still abort before publication.
        deadline = time.monotonic() + 1
        while True:
            try:
                os.replace(temporary, path)
                break
            except OSError as error:
                if error.winerror not in (5, 32, 33) or time.monotonic() >= deadline:
                    raise
                time.sleep(.01)
    finally:
        Path(temporary).unlink(missing_ok=True)


class ProfileStore:
    def __init__(self, directory: Path, authority: RegistryAuthority | None = None,
                 *, publish: Callable[[AuthorityState, str], None] | None = None):
        self.directory = directory
        self.control = directory / "ownership.bin"
        self.authority = authority if authority is not None else RegistryAuthority()
        # Explicit authority injection is the isolated storage-test boundary.
        # Normal construction always publishes via the separate setup process.
        self.publish = publish if publish is not None or authority is not None else publish_elevated

    def publication_pending(self) -> bool:
        return publication_pending(self.authority.read().installation)

    def owner(self) -> tuple[str, str, str] | None:
        authority = self.authority.read()
        local = self._local_owner()
        expected = (authority.owner, authority.profile, authority.digest)
        if authority.profile and local != expected:
            raise StorageError("User state does not match the committed ownership authority.")
        if local and local[0] != authority.owner:
            raise StorageError("Local ownership differs from the installation account.")
        return expected

    def _local_owner(self) -> tuple[str, str, str] | None:
        if not self.control.exists():
            if self.directory.exists() and any(self.directory.glob("profile-*.bin")):
                raise StorageError("Ownership record missing; setup stays closed.")
            return None
        try:
            data = json.loads(protect(self.control.read_bytes(), decrypt=True))
            if (not isinstance(data, dict) or set(data) != {"schema", "owner", "profile", "digest"}
                    or data["schema"] != 1 or not isinstance(data["owner"], str)
                    or not data["owner"] or not isinstance(data["profile"], str)
                    or not isinstance(data["digest"], str)):
                raise ValueError("Invalid ownership record")
            profile, digest = data["profile"], data["digest"]
            if profile and (len(profile) != 32 or any(c not in "0123456789abcdef" for c in profile)
                            or len(digest) != 64 or any(c not in "0123456789abcdef" for c in digest)):
                raise ValueError("Invalid committed record")
            if not profile and digest:
                raise ValueError("Invalid reservation")
            return data["owner"], profile, digest
        except (ValueError, TypeError, OSError, StorageError) as error:
            raise StorageError("Ownership data is missing or damaged. Setup stays closed.") from error

    def reserve(self, owner: str) -> str:
        _trace("reservation", "started")
        try:
            authority = self.authority.read()
            if authority.owner != owner or authority.profile:
                raise StorageError("Setup is closed for this account or already committed.")
            _traced_step("reservation.local_index_write", lambda: self.write_control(owner, "", ""))
        except Exception as error:
            _trace("reservation", "failed", error)
            raise
        _trace("reservation", "succeeded")
        return authority.installation

    def write_control(self, owner: str, profile: str, digest: str) -> None:
        data = json.dumps({"schema": 1, "owner": owner, "profile": profile, "digest": digest}).encode()
        atomic_write(self.control, protect(data))

    def load(self) -> dict[str, str] | None:
        owner = self.owner()
        if owner is None or not owner[1]:
            return None
        try:
            payload = (self.directory / f"profile-{owner[1]}.bin").read_bytes()
            if hashlib.sha256(payload).hexdigest() != owner[2]:
                raise StorageError("Committed payload integrity check failed.")
            data = json.loads(protect(payload, decrypt=True))
            if (not isinstance(data, dict) or set(data) != {"owner", "face", "voice", "code_verifier"}
                    or not all(isinstance(value, str) and value for value in data.values())
                    or data["owner"] != owner[0]):
                raise StorageError("Invalid committed profile.")
            return data
        except (OSError, ValueError, TypeError) as error:
            raise StorageError("Committed profile is missing or damaged. Setup stays closed.") from error

    def commit(self, profile: dict[str, str], *, installation: str) -> None:
        _trace("commit", "started")
        try:
            before = self.authority.read()
            if before.owner != profile["owner"] or before.profile or before.installation != installation:
                raise StorageError("Installation changed; setup stays closed.")
            generation = uuid4().hex
            payload = protect(json.dumps(profile).encode())
            candidate = AuthorityState(before.installation, before.owner, generation,
                                       hashlib.sha256(payload).hexdigest())
            with publication_lease(installation) as lease:
                _traced_step("commit.payload_write",
                             lambda: atomic_write(self.directory / f"profile-{generation}.bin", payload))
                _traced_step("commit.local_index_write",
                             lambda: self.write_control(candidate.owner, candidate.profile, candidate.digest))
                # User files are candidates until the protected authority commits.
                if self.publish is None:
                    _traced_step("commit.publication",
                                 lambda: self.authority.commit(candidate.owner, candidate.profile,
                                                               candidate.digest,
                                                               installation=candidate.installation))
                else:
                    publisher = self.publish
                    _traced_step("commit.publication", lambda: publisher(candidate, lease))

                def confirm() -> None:
                    if self.authority.read() != candidate or self.load() != profile:
                        raise StorageError("Enrollment publication was not confirmed.")

                _traced_step("commit.confirmation", confirm)
        except Exception as error:
            _trace("commit", "failed", error)
            raise
        _trace("commit", "succeeded")
