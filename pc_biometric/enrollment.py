"""Fail-closed local owner-enrollment workflow."""

from collections.abc import Callable
from dataclasses import dataclass, field
import base64
import hashlib
from pathlib import Path
import secrets
import time
from threading import Event, RLock, Timer
from typing import BinaryIO

from .storage import ProfileStore, StorageError, acquire_operation
from .authority import AuthorityState, RegistryAuthority


@dataclass(frozen=True)
class References:
    face: bytes = field(repr=False)
    voice: bytes = field(repr=False)


@dataclass(frozen=True)
class EnrollmentResult:
    state: str
    message: str
    recovery_code: str | None = field(default=None, repr=False)
    elapsed_seconds: float = 0.0


class Enrollment:
    def __init__(self, directory: Path, *, account: Callable[[], str],
                 verify_windows: Callable[[], bool], capture: Callable[[], References],
                 cancelled: Event | None = None, authority: RegistryAuthority | None = None,
                 publish: Callable[[AuthorityState, str], None] | None = None):
        self.directory = directory
        self.account = account
        self.verify_windows = verify_windows
        self.capture = capture
        self.store = ProfileStore(directory, authority, publish=publish)
        self.pending: dict[str, str] | None = None
        self.installation = ""
        self.started = 0.0
        self.operation: BinaryIO | None = None
        self.cancelled = cancelled if cancelled is not None else Event()
        self.preparing = False
        self.committing = False
        self.committed = False
        self.transitions = RLock()
        self.deadline = 0.0
        self.timeout: Timer | None = None
        self.timeout_epoch = 0

    def expired(self) -> bool:
        return self.deadline > 0 and time.monotonic() >= self.deadline

    def _start_timeout(self) -> None:
        self.started = time.monotonic()
        self.deadline = self.started + 300
        self.timeout_epoch += 1
        epoch = self.timeout_epoch
        self.timeout = Timer(300, lambda: self._expire(epoch))
        self.timeout.daemon = True
        self.timeout.start()

    def _expire(self, epoch: int) -> None:
        with self.transitions:
            if epoch == self.timeout_epoch and self.deadline > 0:
                self.cancelled.set()

    def _stop_timeout(self) -> None:
        self.timeout_epoch += 1
        if self.timeout is not None:
            self.timeout.cancel()
            self.timeout = None
        self.deadline = 0.0

    def status(self) -> EnrollmentResult:
        try:
            if self.store.publication_pending():
                return EnrollmentResult("busy", "An earlier setup publication is still active; wait for its result.")
            owner = self.store.owner()
            if owner:
                try:
                    account = self.account()
                except Exception:
                    return EnrollmentResult("unavailable", "Windows account could not be checked; setup stays closed.")
                if owner[0] != account:
                    return EnrollmentResult("denied", "Use the designated owner Windows account.")
            if self.store.load() is not None:
                return EnrollmentResult("enrolled", "Owner profile retained. No action authorized.")
        except (StorageError, OSError):
            return EnrollmentResult("damaged", "Protected state needs investigation; new-owner setup is closed.")
        return EnrollmentResult("not-enrolled", "Deliberate setup requires fresh Windows verification.")

    def start(self, *, consented: bool) -> EnrollmentResult:
        with self.transitions:
            if self.operation is not None:
                return EnrollmentResult("busy", "Finish or cancel the current setup first.")
            if not consented:
                return EnrollmentResult("consent-required", "Agree the specific local capture/data session first.")
            try:
                self.operation = acquire_operation(self.directory)
            except OSError:
                return EnrollmentResult("busy", "Another operation is active or storage is unavailable.")
            self._start_timeout()
            self.preparing = True
        try:
            result = self._prepare()
        except Exception:
            result = EnrollmentResult("unavailable", "Setup could not finish. No action authorized; "
                                    "check Windows, capture and storage prerequisites before retrying.")
        with self.transitions:
            self.preparing = False
            if self.cancelled.is_set():
                result = EnrollmentResult("cancelled", "Setup cancelled. No action authorized.")
            if result.state != "save-code":
                self._release()
            return result

    def rearm(self) -> bool:
        """Clear an earlier cancellation before a new UI-requested operation."""
        with self.transitions:
            if self.operation is not None or self.preparing or self.committing:
                return False
            self.cancelled.clear()
            return True

    def _prepare(self) -> EnrollmentResult:
        status = self.status()
        if status.state != "not-enrolled":
            return status
        owner = self.account()
        if self.cancelled.is_set():
            return EnrollmentResult("cancelled", "Setup cancelled before Windows verification.")
        if not self.verify_windows():
            return EnrollmentResult("denied", "Windows verification did not succeed. Nothing was enrolled.")
        if self.cancelled.is_set():
            return EnrollmentResult("cancelled", "Setup cancelled. No action authorized.")
        if not owner or self.account() != owner:
            return EnrollmentResult("denied", "Windows account changed. Start a fresh setup.")
        self.installation = self.store.reserve(owner)
        if self.cancelled.is_set():
            return EnrollmentResult("cancelled", "Setup cancelled. Capture was not started.")
        references = self.capture()
        if self.cancelled.is_set():
            return EnrollmentResult("cancelled", "Setup cancelled. No action authorized.")
        if self.account() != owner:
            return EnrollmentResult("denied", "Windows account changed. Start a fresh setup.")
        if not (isinstance(references.face, bytes) and isinstance(references.voice, bytes)
                and 0 < len(references.face) <= 65536 and 0 < len(references.voice) <= 65536):
            return EnrollmentResult("denied", "Both validated references are required. Start a fresh setup.")
        code = secrets.token_hex(32).upper()
        self.pending = {"owner": owner, "face": base64.b64encode(references.face).decode(),
                        "voice": base64.b64encode(references.voice).decode(),
                        "code_verifier": hashlib.sha256(code.encode()).hexdigest()}
        return EnrollmentResult("save-code", "Save this code offline before completing setup. "
                                "Without it and either working biometric, this version has no recovery.", code)

    def complete(self, *, code_saved: bool) -> EnrollmentResult:
        # Completion is an indivisible workflow transition. Once saving begins,
        # cancellation waits for the durable result instead of releasing its lock.
        with self.transitions:
            if self.preparing:
                return EnrollmentResult("busy", "Setup preparation has not finished.")
            if self.pending is None:
                return EnrollmentResult("denied", "Start a fresh setup workflow.")
            if self.cancelled.is_set():
                return self.cancel()
            if not code_saved:
                return EnrollmentResult("save-code", "Confirm that the offline code is saved before completing setup.")
            self.committing = True
            try:
                if self.account() != self.pending["owner"]:
                    return EnrollmentResult("denied", "Windows account changed. Start a fresh setup.")
                if self.cancelled.is_set() or self.expired():
                    return EnrollmentResult("cancelled", "Setup interrupted before saving. Start a fresh setup.")
                self._stop_timeout()
                self.store.commit(self.pending, installation=self.installation)
                self.committed = True
                return EnrollmentResult("enrolled", "Owner enrollment saved. No action authorized.",
                                        elapsed_seconds=time.monotonic() - self.started)
            except Exception:
                return EnrollmentResult("unavailable", "Enrollment was not confirmed. Start fresh and inspect "
                                        "the committed state; no action authorized.")
            finally:
                self.committing = False
                self._release()

    def _release(self) -> None:
        self._stop_timeout()
        self.pending = None
        self.installation = ""
        if self.operation is not None:
            self.operation.close()
            self.operation = None

    def cancel(self) -> EnrollmentResult:
        with self.transitions:
            if self.committing:
                return EnrollmentResult("saving", "Saving has begun; wait for the committed result.")
            if self.committed:
                return EnrollmentResult("enrolled", "Enrollment was already saved. No action authorized.")
            self.cancelled.set()
            self._stop_timeout()
            self.pending = None
            # Keep the cross-process lock until an in-flight external callback returns.
            if not self.preparing:
                self._release()
            return EnrollmentResult("cancelled", "Setup cancelled. Start fresh; no action authorized.")

    def request_cancel(self) -> None:
        """Signal external work synchronously; locked cleanup may follow elsewhere."""
        self.cancelled.set()
