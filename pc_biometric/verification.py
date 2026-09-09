"""Development-only face + spoken-challenge check for one desktop receipt.

No approval token, profile mutation, aircraft command or persistent unlocked state.
Retry persistence and presentation/input attack defenses remain Tickets 04/07.
"""

import base64
from collections.abc import Callable
from dataclasses import dataclass, field
import math
from pathlib import Path
import secrets
import struct
from threading import Event, RLock, Timer
import time

from .authority import AuthorityState, RegistryAuthority
from .enrollment import References
from .storage import ProfileStore, acquire_operation


POLICY_VERSION = "desk-verification-dev-3"
FACE_COSINE_MIN = 0.363
VOICE_COSINE_MIN = 0.75  # Development setting, not a calibrated security threshold.
CHALLENGE_WORDS = ("one", "two", "three", "four", "five", "six", "seven", "eight", "nine")


class VerificationRejected(Exception):
    """A completed spoken challenge was rejected; no retry within this request."""

    def __init__(self, guidance: str = ""):
        # Only fixed application guidance crosses the worker/result boundary.
        # Never forward transcripts, reference data or arbitrary exception text.
        allowed = {
            "Audio input was interrupted. Record this phrase again.",
            "Audio is clipping. Move farther away or lower microphone gain.",
            "Voice is too quiet. Move closer or speak a little louder.",
            "Too much background noise compared with your voice.",
            "Not enough clear speech was detected. Read the entire displayed phrase.",
            "The displayed phrase was not recognized exactly. Read every word once at a normal pace.",
            "A usable voice signature was not detected. Try again at a normal volume.",
        }
        super().__init__(guidance if guidance in allowed else "Spoken challenge did not pass.")


def valid_challenge(phrase: str) -> bool:
    words = phrase.split(" ")
    return len(words) == 6 and words[:2] == ["please", "say"] and all(
        word in CHALLENGE_WORDS for word in words[2:])


@dataclass(frozen=True)
class VerificationRequest:
    request_id: str
    identity: AuthorityState = field(repr=False)
    phrase: str
    policy: str = POLICY_VERSION
    diagnostics: bool = False
    microphone: int | None = None


@dataclass(frozen=True)
class VerificationEvidence:
    request: VerificationRequest
    references: References = field(repr=False)


@dataclass(frozen=True)
class VerificationResult:
    state: str
    message: str
    request_id: str = ""
    elapsed_seconds: float = 0.0
    diagnostics: str = field(default="", repr=False)


def vector(blob: bytes, header: bytes, minimum: int, maximum: int) -> tuple[float, ...]:
    """Validate the existing bounded reference format before any comparison."""
    if not isinstance(blob, bytes) or not blob.startswith(header) or len(blob) < len(header) + 4:
        raise ValueError("Invalid biometric reference.")
    count, = struct.unpack_from("<I", blob, len(header))
    if not minimum <= count <= maximum or len(blob) != len(header) + 4 + count * 4:
        raise ValueError("Invalid biometric reference.")
    values = struct.unpack_from(f"<{count}f", blob, len(header) + 4)
    norm = math.hypot(*values)
    if not all(math.isfinite(value) for value in values) or not math.isfinite(norm) or norm <= 0:
        raise ValueError("Invalid biometric reference.")
    return tuple(value / norm for value in values)


def match_scores(enrolled: References, observed: References) -> tuple[float | None, float | None]:
    scores: list[float | None] = []
    for first, second, header, low, high in (
        (enrolled.face, observed.face, b"SFACE1\0", 128, 128),
        (enrolled.voice, observed.voice, b"VOSKSPK1\0", 64, 512),
    ):
        left, right = vector(first, header, low, high), vector(second, header, low, high)
        scores.append(math.fsum(a * b for a, b in zip(left, right)) if len(left) == len(right) else None)
    return scores[0], scores[1]


def scores_pass(scores: tuple[float | None, float | None]) -> bool:
    return all(score is not None and score >= threshold for score, threshold in
               zip(scores, (FACE_COSINE_MIN, VOICE_COSINE_MIN)))


def matches(enrolled: References, observed: References) -> bool:
    return scores_pass(match_scores(enrolled, observed))


class Verification:
    def __init__(self, directory: Path, *, account: Callable[[], str],
                 capture: Callable[[VerificationRequest], VerificationEvidence],
                 cancelled: Event | None = None, authority: RegistryAuthority | None = None,
                 clock: Callable[[], float] = time.monotonic, diagnostics: bool = False,
                 voice_study: bool = False, microphone: int | None = None):
        if microphone is not None and (type(microphone) is not int or microphone < 0):
            raise ValueError("Invalid microphone index.")
        if voice_study and (not diagnostics or microphone is None):
            raise ValueError("Voice study requires diagnostics and an explicit microphone.")
        self.directory = directory
        self.store = ProfileStore(directory, authority)
        self.account = account
        self.capture = capture
        self.cancelled = cancelled if cancelled is not None else Event()
        self.clock = clock
        self.transitions = RLock()
        self.active = False
        self.deadline = 0.0
        self.diagnostics = diagnostics
        self.voice_study = voice_study
        self.microphone = microphone
        self._study_samples: list[tuple[float, ...]] = []
        self._study_lines: list[str] = []
        self._study_identity: AuthorityState | None = None
        self._study_complete = False
        self._study_timer: Timer | None = None

    @property
    def study_complete(self) -> bool:
        return self._study_complete

    def reset_study(self) -> None:
        """Discard temporary comparison vectors; never touches enrollment."""
        with self.transitions:
            if self._study_timer is not None:
                self._study_timer.cancel()
                self._study_timer = None
            self._study_samples.clear()
            self._study_lines.clear()
            self._study_identity = None
            self._study_complete = False

    def _measure_voice(self, request: VerificationRequest, observed: References, score: float | None) -> str:
        with self.transitions:
            if self.cancelled.is_set() or self.expired():
                raise ValueError("Study interrupted.")
            if self._study_identity != request.identity:
                self.reset_study()
                self._study_identity = request.identity
            if not self._study_samples:
                self._study_timer = Timer(300, self.reset_study)
                self._study_timer.daemon = True
                self._study_timer.start()
            sample = vector(observed.voice, b"VOSKSPK1\0", 64, 512)
            count = len(self._study_samples) + 1
            formatted = "incompatible dimensions" if score is None else f"{score:.4f}"
            self._study_lines.append(f"Sample {count} vs enrolled voice: {formatted}")
            for index, previous in enumerate(self._study_samples, 1):
                similarity = (f"{math.fsum(a * b for a, b in zip(previous, sample)):.4f}"
                              if len(previous) == len(sample) else "incompatible dimensions")
                self._study_lines.append(f"Samples {index} vs {count}: {similarity}")
            self._study_samples.append(sample)
            report = (f"Voice consistency study — no authorization\nStudy samples: {count}/3\n"
                      f"Fixed microphone index: {self.microphone}\n"
                      + "\n".join(self._study_lines)
                      + "\nPairwise scores measure repeatability, not proof of identity. No study pass threshold.")
            if count == 3:
                self.reset_study()
                self._study_complete = True
            return report

    def rearm(self) -> bool:
        with self.transitions:
            if self.active:
                return False
            self.cancelled.clear()
            return True

    def request_cancel(self) -> None:
        self.cancelled.set()
        self.reset_study()

    def expired(self) -> bool:
        return self.deadline > 0 and self.clock() >= self.deadline

    def start(self, *, consented: bool, requested_at: float | None = None) -> VerificationResult:
        started = self.clock() if requested_at is None else requested_at
        with self.transitions:
            if self.active:
                return VerificationResult("busy", "Another verification is still active.")
            if not consented:
                return VerificationResult("consent-required", "Agree this specific local verification session first.")
            if self.voice_study and self._study_complete:
                return VerificationResult("study-complete", "Three-sample study complete. Navigate away to clear it.")
            if not math.isfinite(started) or started > self.clock() or self.clock() >= started + 60:
                return VerificationResult("expired", "Request expired. Start a fresh check.")
            self.active = True
            self.deadline = started + 60
        operation = None
        timer = Timer(max(0, self.deadline - self.clock()), self.request_cancel)
        timer.daemon = True
        request_id = ""
        scores: tuple[float | None, float | None] | None = None
        study_details = ""

        def result(state: str, message: str) -> VerificationResult:
            if self.voice_study and state in {"cancelled", "expired", "unavailable", "denied", "not-enrolled"}:
                self.reset_study()
            details = ""
            if self.diagnostics and state not in {"cancelled", "expired"}:
                lines = [f"Policy: {POLICY_VERSION}", f"Final result: {state}"]
                for index, (name, threshold) in enumerate((("Face", FACE_COSINE_MIN), ("Voice", VOICE_COSINE_MIN))):
                    score = None if scores is None else scores[index]
                    outcome = ("not evaluated" if scores is None else "incompatible vector dimensions" if score is None
                               else f"{'PASS' if score >= threshold else 'FAIL'}; similarity {score:.4f}")
                    lines.append(f"{name} identity: {outcome}; threshold {threshold:.3f}")
                details = "\n".join(lines)
                if study_details:
                    details += "\n\n" + study_details
            return VerificationResult(state, message, request_id, max(0, self.clock() - started), details)

        try:
            timer.start()
            if self.cancelled.is_set():
                return result("cancelled", "Check cancelled. No action authorized.")
            try:
                operation = acquire_operation(self.directory)
            except OSError:
                return result("busy", "Another operation is active or storage is unavailable.")
            if self.store.publication_pending():
                return result("busy", "Setup publication is still active. No action authorized.")
            identity = self.store.authority.read()
            if self.account() != identity.owner:
                return result("denied", "Use the designated owner Windows account.")
            profile = self.store.load()
            if profile is None:
                return result("not-enrolled", "Complete owner setup before verification.")
            enrolled = References(base64.b64decode(profile["face"], validate=True),
                                  base64.b64decode(profile["voice"], validate=True))
            # Reject invalid stored vectors before opening either device.
            vector(enrolled.face, b"SFACE1\0", 128, 128)
            vector(enrolled.voice, b"VOSKSPK1\0", 64, 512)
            if self.store.authority.read() != identity or self.cancelled.is_set() or self.expired():
                return result("cancelled", "Identity or session changed. Start a fresh check.")
            request_id = secrets.token_hex(16)
            phrase = "please say " + " ".join(secrets.choice(CHALLENGE_WORDS) for _ in range(4))
            request = VerificationRequest(request_id, identity, phrase, diagnostics=self.diagnostics,
                                          microphone=self.microphone)
            evidence = self.capture(request)
            if self.expired():
                return result("expired", "Request expired. Start a fresh check.")
            if self.cancelled.is_set():
                return result("cancelled", "Check cancelled. No action authorized.")
            if not isinstance(evidence, VerificationEvidence) or evidence.request != request:
                self.reset_study()
                return result("rejected", "Face and voice check did not pass. No action authorized.")
            scores = match_scores(enrolled, evidence.references)
            if self.voice_study:
                if (self.store.load() != profile or self.store.authority.read() != identity
                        or self.account() != identity.owner or self.cancelled.is_set() or self.expired()):
                    return result("cancelled", "Identity or session changed. Start a fresh study.")
                study_details = self._measure_voice(request, evidence.references, scores[1])
                if self.cancelled.is_set() or self.expired():
                    return result("cancelled", "Study interrupted. No action authorized.")
                return result("measured", "Three-sample study complete. No action authorized. See diagnostics."
                              if self.study_complete else
                              "Diagnostic sample measured. No action authorized. "
                              "See diagnostics; collect three samples on the same microphone.")
            if not scores_pass(scores):
                return result("rejected", "Face and voice check did not pass. No action authorized.")
            # The only action is creation of this request's informational desktop
            # receipt, immediately after rechecking committed state and session.
            # There is no public completion API or reusable permission object.
            if (self.store.load() != profile or self.store.authority.read() != identity
                    or self.account() != identity.owner or self.cancelled.is_set() or self.expired()):
                return result("cancelled", "Identity or session changed. Start a fresh check.")
            return result("authorized", "This desktop request is authorized. Development check only; "
                          "no unlocked session or aircraft permission.")
        except VerificationRejected as error:
            if self.expired() or self.cancelled.is_set():
                return result("expired" if self.expired() else "cancelled",
                              "Check interrupted. No action authorized.")
            return result("rejected", f"{error} No action authorized; start a fresh check.")
        except Exception:
            state = "expired" if self.expired() else "cancelled" if self.cancelled.is_set() else "unavailable"
            return result(state, "Check could not complete. No action authorized; start a fresh check.")
        finally:
            timer.cancel()
            timer.join()
            if operation is not None:
                operation.close()
            with self.transitions:
                self.deadline = 0.0
                self.active = False
