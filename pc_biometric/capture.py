"""Local reference capture isolated from the desktop process."""

from collections.abc import Callable
from dataclasses import dataclass, field, replace
import importlib
import json
import math
import multiprocessing
import secrets
from pathlib import Path
import struct
from threading import Event
import time
from typing import Any

from .enrollment import References
from .workflow import all_models_valid
from .verification import (VerificationEvidence, VerificationRequest, VerificationRejected,
                           POLICY_VERSION, valid_challenge)


ENROLLMENT_PHRASES = (
    "the garden gate is open this morning",
    "please bring the blue book to the table",
    "we can walk beside the river today",
    "a little bird is singing near the window",
    "the green light is shining on the wall",
    "my next journey starts early in the morning",
)


class CaptureError(Exception):
    pass


@dataclass(frozen=True)
class CaptureFeedback:
    message: str
    waveform: tuple[float, ...] = ()


@dataclass(frozen=True)
class CaptureDiagnostic:
    request_id: str
    stage: str
    details: str = field(repr=False)

    def valid(self) -> bool:
        return (isinstance(self.request_id, str) and len(self.request_id) == 32
                and all(c in "0123456789abcdef" for c in self.request_id)
                and isinstance(self.stage, str) and self.stage in {"face", "voice"}
                and isinstance(self.details, str) and len(self.details) <= 4000)


@dataclass(frozen=True)
class VoicePrompt:
    state: str
    take: int
    attempt: int
    phrase: str
    elapsed_seconds: float = 0.0
    response_timeout_seconds: float = 60.0


def _capture_child(models: str, connection: Any, request: VerificationRequest | None = None) -> None:
    """Run device libraries in a disposable unelevated child process."""
    def stage(value: str) -> None:
        connection.send(("stage", value))
        if value != "idle" and connection.recv() != "displayed":
            raise CaptureError("Capture status could not be displayed.")

    def preview(value: bytes) -> None:
        connection.send(("preview", value))
        if connection.recv() != "displayed":
            raise CaptureError("Camera preview could not be displayed.")

    def feedback(value: CaptureFeedback) -> None:
        connection.send(("feedback", value))
        if connection.recv() != "displayed":
            raise CaptureError("Capture guidance could not be displayed.")

    def voice_control(value: VoicePrompt) -> str:
        connection.send(("voice_control", value))
        action = connection.recv()
        if not isinstance(action, str):
            raise CaptureError("Voice controls are unavailable.")
        return action

    def diagnostic(value: CaptureDiagnostic) -> None:
        connection.send(("diagnostic", value))
        if connection.recv() != "displayed":
            raise CaptureError("Diagnostic display is unavailable.")

    try:
        result = EnrollmentCapture(Path(models), Event(), stage, preview=preview,
                                   feedback=feedback, voice_control=voice_control,
                                   diagnostic=diagnostic,
                                   isolated=False, verification_request=request).capture()
        connection.send(("result", result if request is None else VerificationEvidence(request, result)))
    except VerificationRejected as error:
        connection.send(("rejected", str(error)))
    except Exception:
        connection.send(("error", None))
    finally:
        connection.close()


class EnrollmentCapture:
    """Create bounded face/speaker references without writing ordinary raw media."""

    def __init__(self, models: Path, cancelled: Event,
                 stage: Callable[[str], None] | None = None,
                 validate_models: Callable[[Path], bool] = all_models_valid, *,
                 preview: Callable[[bytes], None] | None = None,
                 feedback: Callable[[CaptureFeedback], None] | None = None,
                 voice_control: Callable[[VoicePrompt], str] | None = None,
                 face_sample_interval: float = 0.3,
                 isolated: bool = True,
                 verification_request: VerificationRequest | None = None,
                 diagnostic: Callable[[CaptureDiagnostic], None] | None = None):
        self.models = models
        self.cancelled = cancelled
        self.stage = stage if stage is not None else lambda _stage: None
        self.validate_models = validate_models
        self.preview = preview if preview is not None else lambda _frame: None
        self.feedback = feedback if feedback is not None else lambda _value: None
        self.voice_control = voice_control if voice_control is not None else self._automatic_voice_control
        self.face_sample_interval = face_sample_interval
        self.isolated = isolated
        self.verification_request = verification_request
        self.diagnostic = diagnostic if diagnostic is not None else lambda _value: None

    def _diagnose(self, stage: str, details: str) -> None:
        request = self.verification_request
        if request is not None and request.diagnostics:
            self.diagnostic(CaptureDiagnostic(request.request_id, stage, details))

    def _diagnosing(self) -> bool:
        return self.verification_request is not None and self.verification_request.diagnostics

    def capture_verification(self, request: VerificationRequest) -> VerificationEvidence:
        """Use a new disposable capture session for this exact random challenge."""
        capture = EnrollmentCapture(
            self.models, self.cancelled, self.stage, self.validate_models,
            preview=self.preview, feedback=self.feedback, voice_control=self.voice_control,
            face_sample_interval=self.face_sample_interval, isolated=self.isolated,
            verification_request=request, diagnostic=self.diagnostic)
        return VerificationEvidence(request, capture.capture())

    def capture(self) -> References:
        if self.verification_request is not None and (
                self.verification_request.policy != POLICY_VERSION
                or (self.verification_request.microphone is not None
                    and (type(self.verification_request.microphone) is not int
                         or self.verification_request.microphone < 0))
                or not valid_challenge(self.verification_request.phrase)):
            raise CaptureError("Verification challenge is invalid.")
        if self.cancelled.is_set():
            raise CaptureError("Enrollment capture cancelled.")
        return self._isolated_capture() if self.isolated else self._local_capture()

    def _isolated_capture(self) -> References:
        context = multiprocessing.get_context("spawn")
        parent, child = context.Pipe(duplex=True)
        process = context.Process(target=_capture_child,
                                  args=(str(self.models), child, self.verification_request), daemon=True)
        process.start()
        child.close()
        deadline = time.monotonic() + (60 if self.verification_request else 300)
        try:
            while process.is_alive() or parent.poll():
                now = time.monotonic()
                if self.cancelled.is_set() or now >= deadline:
                    raise CaptureError("Enrollment capture cancelled or timed out.")
                if not parent.poll(0.025):
                    continue
                kind, value = parent.recv()
                if kind == "stage":
                    self._report(str(value))
                    if self.cancelled.is_set():
                        raise CaptureError("Enrollment capture cancelled.")
                    if value != "idle":
                        parent.send("displayed")
                elif kind == "preview" and isinstance(value, bytes):
                    self._preview(value)
                    if self.cancelled.is_set():
                        raise CaptureError("Enrollment capture cancelled.")
                    parent.send("displayed")
                elif kind == "feedback" and isinstance(value, CaptureFeedback):
                    self.feedback(value)
                    if self.cancelled.is_set():
                        raise CaptureError("Enrollment capture cancelled.")
                    parent.send("displayed")
                elif kind == "voice_control" and isinstance(value, VoicePrompt):
                    action = self._voice_action(value)
                    parent.send(action)
                    if action in {"cancel", "timeout"}:
                        raise CaptureError("Enrollment capture cancelled or timed out.")
                elif kind == "diagnostic":
                    if (not self._diagnosing() or not isinstance(value, CaptureDiagnostic) or not value.valid()
                            or self.verification_request is None
                            or value.request_id != self.verification_request.request_id):
                        raise CaptureError("Invalid diagnostic response.")
                    self.diagnostic(value)
                    parent.send("displayed")
                elif kind == "result" and self.verification_request is not None:
                    if (not isinstance(value, VerificationEvidence)
                            or value.request != self.verification_request
                            or self.cancelled.is_set()):
                        raise CaptureError("Obsolete verification evidence.")
                    process.join(1)
                    return value.references
                elif kind == "result" and isinstance(value, References):
                    process.join(1)
                    return value
                elif kind == "rejected" and self.verification_request is not None:
                    raise VerificationRejected(value if isinstance(value, str) else "")
                else:
                    raise CaptureError("Local enrollment capture failed.")
            raise CaptureError("Local enrollment capture failed.")
        except (EOFError, OSError) as error:
            raise CaptureError("Local enrollment capture failed.") from error
        finally:
            parent.close()
            if process.is_alive():
                process.terminate()
                process.join(2)
            if process.is_alive():
                process.kill()
                process.join(2)
            self._report("idle")

    def _local_capture(self) -> References:
        if not self.validate_models(self.models):
            raise CaptureError("Pinned enrollment models are unavailable or damaged.")
        try:
            face = self._face()
            self._report("idle")
            voice = self._voice()
            return References(face, voice)
        except (CaptureError, VerificationRejected):
            raise
        except Exception as error:
            raise CaptureError("Local enrollment capture failed.") from error
        finally:
            self._report("idle")

    def _report(self, stage: str) -> None:
        try:
            self.stage(stage)
        except Exception:
            if stage != "idle":
                raise CaptureError("Capture status could not be displayed.")

    @staticmethod
    def _automatic_voice_control(prompt: VoicePrompt) -> str:
        """Deterministic non-UI adapter used only by synthetic/local callers."""
        if prompt.state == "ready":
            return "record_start"
        if prompt.state == "recording":
            return "record_stop" if prompt.elapsed_seconds >= 2 else "continue"
        if prompt.state == "review":
            return "submit"
        if prompt.state == "noise_retry":
            return "remeasure"
        if prompt.state == "accepted":
            return "continue"
        if prompt.state == "rejected":
            return "retry"
        if prompt.state == "failed":
            return "finish"
        return "continue"

    def _voice_action(self, prompt: VoicePrompt) -> str:
        if self.cancelled.is_set():
            return "cancel"
        try:
            action = self.voice_control(prompt)
        except Exception as error:
            raise CaptureError("Voice controls are unavailable.") from error
        if self.cancelled.is_set():
            return "cancel"
        return action

    def _preview(self, frame: bytes) -> None:
        try:
            self.preview(frame)
        except Exception as error:
            raise CaptureError("Camera preview could not be displayed.") from error

    def _face(self) -> bytes:
        face_started = time.monotonic() if self._diagnosing() else 0.0
        observation: dict[str, str | int | float | bool] = {"Camera": "index 0 / DirectShow"}
        detector_path = self.models / "face_detection_yunet_2023mar.onnx"
        recognizer_path = self.models / "face_recognition_sface_2021dec.onnx"
        if not detector_path.is_file() or not recognizer_path.is_file():
            raise CaptureError("Face models are unavailable.")
        self._report("face")
        if self.cancelled.is_set():
            raise CaptureError("Enrollment capture cancelled.")
        cv2 = importlib.import_module("cv2")
        numpy = importlib.import_module("numpy")
        detector = cv2.FaceDetectorYN.create(str(detector_path), "", (320, 240))
        recognizer = cv2.FaceRecognizerSF.create(str(recognizer_path), "")
        if self._diagnosing():
            observation["Face model setup seconds"] = round(time.monotonic() - face_started, 3)
        camera = cv2.VideoCapture(0, cv2.CAP_DSHOW)
        if not camera.isOpened():
            camera.release()
            raise CaptureError("Camera is unavailable.")
        features: list[Any] = []
        sample_count = 1 if self.verification_request else 8
        deadline = time.monotonic() + 30
        next_sample = 0.0
        next_preview = 0.0
        stable_since: float | None = None
        anchor: Any = None
        try:
            while len(features) < sample_count and time.monotonic() < deadline:
                if self.cancelled.is_set():
                    raise CaptureError("Enrollment capture cancelled.")
                ok, frame = camera.read()
                if not ok:
                    features.clear()
                    stable_since = None
                    anchor = None
                    continue
                now = time.monotonic()
                height, width = frame.shape[:2]
                detector.setInputSize((width, height))
                _status, faces = detector.detect(frame)
                if self._diagnosing():
                    observation.update({"Frame pixels": f"{width} x {height}",
                                        "Detected faces": 0 if faces is None else len(faces),
                                        "Face box pixels": "not measured", "Brightness mean": "not measured",
                                        "Laplacian sharpness": "not measured"})
                message = "Keep exactly one face in the frame."
                face = None
                if faces is not None and len(faces) == 1 and numpy.isfinite(faces[0]).all():
                    candidate = faces[0]
                    x, y, w, h = (float(value) for value in candidate[:4])
                    if self._diagnosing():
                        observation["Face box pixels"] = f"{w:.1f} x {h:.1f}"
                    if x < 0 or y < 0 or w <= 0 or h <= 0 or x + w > width or y + h > height:
                        message = "Move your whole face inside the frame."
                    elif w < max(96, width * .25) or h < height * .35:
                        message = "Move closer to the camera."
                    elif w > width * .85 or h > height * .95:
                        message = "Move a little farther from the camera."
                    else:
                        points = candidate[4:14].reshape(5, 2)
                        eye_distance = abs(float(points[1, 0] - points[0, 0]))
                        nose_drop = float(points[2, 1] - (points[0, 1] + points[1, 1]) / 2)
                        mouth_drop = float((points[3, 1] + points[4, 1]) / 2 - points[2, 1])
                        if (eye_distance < w * .2 or abs(float(points[1, 1] - points[0, 1])) > eye_distance * .2
                                or abs(float(points[2, 0] - (points[0, 0] + points[1, 0]) / 2)) > eye_distance * .25
                                or not eye_distance * .2 <= nose_drop <= eye_distance * .8
                                or not eye_distance * .2 <= mouth_drop <= eye_distance * .9
                                or not ((points[:, 0] >= x).all() and (points[:, 0] <= x + w).all()
                                        and (points[:, 1] >= y).all() and (points[:, 1] <= y + h).all())):
                            message = "Look straight at the camera and level your head."
                        else:
                            gray = cv2.cvtColor(frame[int(y):int(y+h), int(x):int(x+w)], cv2.COLOR_BGR2GRAY)
                            normalized = cv2.resize(gray, (128, 128))
                            brightness = float(normalized.mean())
                            if self._diagnosing():
                                observation["Brightness mean"] = round(brightness, 2)
                            if brightness < 45 or brightness > 210 or float(((normalized < 15) | (normalized > 245)).mean()) > .2:
                                message = "Improve the lighting on your face."
                            else:
                                sharpness = float(cv2.Laplacian(normalized, cv2.CV_64F).var())
                                if self._diagnosing():
                                    observation["Laplacian sharpness"] = round(sharpness, 2)
                                if sharpness < 60:
                                    message = "Image is not sharp enough. Hold still or adjust camera focus."
                                else:
                                    face = candidate
                                    message = "Hold still — checking capture quality, not identity."
                if face is None:
                    features.clear()
                    stable_since = None
                    anchor = None
                else:
                    if anchor is None or float(numpy.max(numpy.abs(face[:4] - anchor) / numpy.array([width, height, width, height]))) > .04:
                        features.clear()
                        stable_since = now
                        anchor = face[:4].copy()
                    if stable_since is not None and now - stable_since >= 1 and now >= next_sample:
                        aligned = recognizer.alignCrop(frame, face)
                        feature = recognizer.feature(aligned).astype("float32").reshape(-1)
                        if feature.size != 128 or not numpy.isfinite(feature).all() or float(numpy.linalg.norm(feature)) <= 0:
                            raise CaptureError("Face reference was invalid.")
                        features.append(feature.copy())
                        next_sample = now + self.face_sample_interval
                        message = f"Capturing clear face samples: {len(features)}/{sample_count}."
                if self._diagnosing():
                    observation["Last face guidance"] = message
                if now >= next_preview:
                    # Draw detector landmarks on a display copy, never on model input.
                    shown = frame.copy()
                    if faces is not None and len(faces) == 1 and numpy.isfinite(faces[0]).all():
                        for px, py in faces[0][4:14].reshape(5, 2):
                            if 0 <= px < width and 0 <= py < height:
                                cv2.circle(shown, (int(px), int(py)), max(2, width // 200), (135, 220, 170), -1)
                    scale = min(1.0, 520 / width, 360 / height)
                    shown = (shown if scale == 1.0 else
                             cv2.resize(shown, (int(width * scale), int(height * scale))))
                    encoded, preview = cv2.imencode(".png", shown)
                    if encoded and 0 < preview.size <= 1_000_000:
                        self._preview(bytes(preview.tobytes()))
                    self.feedback(CaptureFeedback(message))
                    next_preview = now + 0.1
        finally:
            camera.release()
        if self._diagnosing():
            observation.update({"Face quality passed": len(features) >= sample_count,
                                "Face samples": len(features),
                                "Face stage seconds": round(time.monotonic() - face_started, 3)})
            self._diagnose("face", "\n".join(f"{key}: {value}" for key, value in observation.items()))
        if len(features) < sample_count:
            raise CaptureError("A single clear face reference was not collected.")
        reference = numpy.mean(numpy.stack(features), axis=0).astype("float32")
        norm = float(numpy.linalg.norm(reference))
        if not math.isfinite(norm) or norm <= 0:
            raise CaptureError("Face reference was invalid.")
        reference /= norm
        return b"SFACE1\0" + struct.pack("<I", reference.size) + bytes(reference.tobytes())

    def _voice(self) -> bytes:
        voice_started = time.monotonic() if self._diagnosing() else 0.0
        speech_path = self.models / "vosk-model-small-en-us-0.15"
        speaker_path = self.models / "vosk-model-spk-0.4"
        if not speech_path.is_dir() or not speaker_path.is_dir():
            raise CaptureError("Voice models are unavailable.")
        self._report("voice")
        if self.cancelled.is_set():
            raise CaptureError("Enrollment capture cancelled.")
        sounddevice = importlib.import_module("sounddevice")
        vosk = importlib.import_module("vosk")
        numpy = importlib.import_module("numpy")
        vosk.SetLogLevel(-1)
        model = vosk.Model(str(speech_path))
        speaker_model = vosk.SpkModel(str(speaker_path))
        references: list[Any] = []
        verifying = self.verification_request is not None
        device_options: dict[str, int] = {}
        voice_observation: dict[str, str | int | float | bool] = {}
        if verifying:
            # Resolve the default once. Room measurement and speech must not
            # silently use different endpoints if Windows' default changes.
            selected = self.verification_request.microphone if self.verification_request is not None else None
            input_info = (sounddevice.query_devices(kind="input") if selected is None
                          else sounddevice.query_devices(selected, kind="input"))
            device_id = int(input_info["index"])
            if device_id < 0:
                raise CaptureError("Microphone is unavailable.")
            device_options["device"] = device_id
            if self._diagnosing():
                host_info = sounddevice.query_hostapis(int(input_info["hostapi"]))
                voice_observation = {
                    "Microphone index": device_id,
                    "Microphone": " ".join(str(input_info["name"]).split())[:160],
                    "Audio backend": " ".join(str(host_info["name"]).split())[:80],
                    "Requested audio format": "16000 Hz / mono / signed 16-bit",
                    "Voice model setup seconds": round(time.monotonic() - voice_started, 3),
                }
                self._diagnose("voice", "\n".join(f"{key}: {value}" for key, value in voice_observation.items()))
        phrases = ([self.verification_request.phrase] if self.verification_request is not None
                   else secrets.SystemRandom().sample(ENROLLMENT_PHRASES, 3))
        take_count = len(phrases)
        attempt_count = 1 if verifying else 3
        def control(prompt: VoicePrompt, allowed: set[str]) -> str:
            # A normal check submits on release and ends after one comparison;
            # enrollment's playback/retry/Continue screens would add free guesses.
            if verifying and prompt.state in {"review", "accepted", "failed"}:
                return {"review": "submit", "accepted": "continue", "failed": "finish"}[prompt.state]
            action = self._voice_action(replace(prompt, response_timeout_seconds=60.0))
            if action == "cancel":
                raise CaptureError("Enrollment capture cancelled.")
            if action == "timeout":
                raise CaptureError("Voice enrollment inactive for too long. Try setup again.")
            if action not in allowed:
                raise CaptureError("Voice controls are unavailable.")
            return action

        def waveform_for(samples: Any) -> tuple[float, ...]:
            return tuple(float(min(1, numpy.sqrt(numpy.mean(part * part)) / .2))
                         for part in numpy.array_split(samples, 48))

        def wipe(recording: bytearray) -> None:
            recording[:] = b"\0" * len(recording)
            recording.clear()

        def play(recording: bytearray) -> None:
            sounddevice.play(numpy.frombuffer(recording, dtype="<i2"), 16000, blocking=False)
            while sounddevice.get_stream().active:
                if self.cancelled.is_set():
                    sounddevice.stop()
                    raise CaptureError("Enrollment capture cancelled.")
                time.sleep(.025)

        for take, phrase in enumerate(phrases, 1):
            accepted = False
            for attempt in range(1, attempt_count + 1):
                if self.cancelled.is_set():
                    raise CaptureError("Enrollment capture cancelled.")
                submitted = False
                while not submitted:
                    self.feedback(CaptureFeedback(
                        f"Take {take}/{take_count} · attempt {attempt}/{attempt_count}. Stay quiet while room noise is measured."))
                    control(VoicePrompt("measuring", take, attempt, phrase), {"continue"})
                    noise: list[float] = []
                    noise_waveform: tuple[float, ...] = ()
                    interrupted = False
                    with sounddevice.RawInputStream(samplerate=16000, blocksize=4000,
                                                    dtype="int16", channels=1, **device_options) as stream:
                        for _ in range(2):
                            audio, overflowed = stream.read(4000)
                            samples = numpy.frombuffer(bytes(audio), dtype="<i2").astype("float32") / 32768
                            if overflowed or samples.size != 4000:
                                interrupted = True
                                break
                            noise.append(float(numpy.sqrt(numpy.mean(samples * samples))))
                            noise_waveform = waveform_for(samples)
                    if interrupted or len(noise) != 2:
                        self.feedback(CaptureFeedback("Audio input was interrupted. Check the microphone, then measure again."))
                        control(VoicePrompt("noise_retry", take, attempt, phrase), {"remeasure"})
                        continue
                    if max(noise) > .02:
                        self.feedback(CaptureFeedback("Background noise is too high. Make the room quieter, then measure again.",
                                                      noise_waveform))
                        control(VoicePrompt("noise_retry", take, attempt, phrase), {"remeasure"})
                        continue

                    self.feedback(CaptureFeedback(f'Take {take}/{take_count} · English. Read: "{phrase}"', noise_waveform))
                    control(VoicePrompt("ready", take, attempt, phrase), {"record_start"})
                    recognizer = vosk.KaldiRecognizer(model, 16000)
                    recognizer.SetSpkModel(speaker_model)
                    recording = bytearray()
                    voiced_seconds = 0.0
                    low_volume_seen = False
                    quality_reason: str | None = None
                    payloads: list[str] = []
                    segment_seconds: list[float] = []
                    sample_energy = 0.0
                    sample_count = 0
                    peak_rms = 0.0
                    max_clipping = 0.0
                    segment_blocks = 0
                    discarded = False
                    if self.cancelled.is_set():
                        raise CaptureError("Enrollment capture cancelled.")
                    with sounddevice.RawInputStream(samplerate=16000, blocksize=4000,
                                                    dtype="int16", channels=1, **device_options) as stream:
                        initial_action = control(VoicePrompt("recording", take, attempt, phrase),
                                                 {"continue", "record_stop", "record_discard"})
                        discarded = initial_action == "record_discard"
                        started = time.monotonic()
                        if self._diagnosing():
                            rate = getattr(stream, "samplerate", None)
                            voice_observation["Opened stream Hz"] = (
                                float(rate) if isinstance(rate, (int, float)) and math.isfinite(rate)
                                else "not reported")
                        while not discarded and initial_action != "record_stop" and time.monotonic() < started + 10:
                            if self.cancelled.is_set():
                                wipe(recording)
                                raise CaptureError("Enrollment capture cancelled.")
                            audio, overflowed = stream.read(4000)
                            raw = bytes(audio)
                            samples = numpy.frombuffer(raw, dtype="<i2").astype("float32") / 32768
                            if overflowed or samples.size != 4000:
                                quality_reason = "Audio input was interrupted. Record this phrase again."
                                self.feedback(CaptureFeedback(quality_reason))
                                break
                            recording.extend(raw)
                            rms = float(numpy.sqrt(numpy.mean(samples * samples)))
                            clipping = float((numpy.abs(samples) >= .98).mean())
                            if self._diagnosing():
                                sample_energy += rms * rms * samples.size
                                sample_count += samples.size
                                peak_rms = max(peak_rms, rms)
                                max_clipping = max(max_clipping, clipping)
                            waveform = waveform_for(samples)
                            message = "Keep speaking at your normal pace."
                            if clipping > .005:
                                quality_reason = "Audio is clipping. Move farther away or lower microphone gain."
                                message = quality_reason
                            elif rms >= .008:
                                if rms < .015:
                                    low_volume_seen = True
                                    message = "Voice is too quiet. Move closer or speak a little louder."
                                elif rms < max(max(noise), .001) * 3.1623:
                                    quality_reason = "Too much background noise compared with your voice."
                                    message = quality_reason
                                else:
                                    voiced_seconds += .25
                            else:
                                message = "Listening — speak the displayed phrase clearly."
                            segment_blocks += 1
                            if recognizer.AcceptWaveform(raw):
                                payloads.append(recognizer.Result())
                                segment_seconds.append(segment_blocks * .25)
                                recognizer = vosk.KaldiRecognizer(model, 16000)
                                recognizer.SetSpkModel(speaker_model)
                                segment_blocks = 0
                            self.feedback(CaptureFeedback(
                                f'Take {take}/{take_count} · Read: "{phrase}"\n{message}', waveform))
                            elapsed = min(10.0, len(recording) / 32000)
                            action = control(VoicePrompt("recording", take, attempt, phrase, elapsed),
                                             {"continue", "record_stop", "record_discard"})
                            if action == "record_discard":
                                discarded = True
                                break
                            if action == "record_stop":
                                break
                    if discarded:
                        wipe(recording)
                        self.feedback(CaptureFeedback("Recording discarded. Hold to record this phrase again."))
                        continue
                    if not recording:
                        self.feedback(CaptureFeedback("No audio was recorded. Hold the button while reading the phrase."))
                        continue

                    while True:
                        action = control(VoicePrompt("review", take, attempt, phrase,
                                                     min(10.0, len(recording) / 32000)),
                                         {"playback", "submit", "rerecord"})
                        if action == "rerecord":
                            wipe(recording)
                            self.feedback(CaptureFeedback("Recording discarded. Measure the room, then record again."))
                            break
                        if action == "playback":
                            control(VoicePrompt("playing", take, attempt, phrase), {"continue"})
                            try:
                                play(recording)
                            except CaptureError:
                                raise
                            except Exception:
                                self.feedback(CaptureFeedback(
                                    "Playback is unavailable. You can submit or record this phrase again."))
                            continue
                        control(VoicePrompt("processing", take, attempt, phrase), {"continue"})
                        submitted = True
                        break
                    if not submitted:
                        continue
                    if segment_blocks or not payloads:
                        payloads.append(recognizer.FinalResult())
                        segment_seconds.append(segment_blocks * .25)
                    wipe(recording)
                results = [json.loads(payload) for payload in payloads]
                words = " ".join(result.get("text", "") for result in results
                                 if isinstance(result, dict) and isinstance(result.get("text", ""), str))
                candidate_index = next((index for index, result in enumerate(results)
                                        if isinstance(result, dict) and isinstance(result.get("spk"), list)), None)
                candidate = None if candidate_index is None else results[candidate_index].get("spk")
                phrase_matches = (isinstance(words, str)
                                  and " ".join(words.lower().split()) == phrase)
                candidate_valid = (isinstance(candidate, list) and 64 <= len(candidate) <= 512
                                   and all(type(value) in (int, float) and math.isfinite(value)
                                           for value in candidate))
                if self._diagnosing():
                    spk_frames = None if candidate_index is None else results[candidate_index].get("spk_frames")
                    voice_observation.update({
                        "Noise peak RMS": round(max(noise), 5),
                        "Recording seconds": sample_count / 16000,
                        "Qualifying loud-audio seconds (not VAD)": voiced_seconds,
                        "Whole-recording RMS": round(math.sqrt(sample_energy / sample_count), 5) if sample_count else 0.0,
                        "Peak block RMS": round(peak_rms, 5),
                        "Maximum block clipping percent": round(max_clipping * 100, 3),
                        "Audio quality gates passed": quality_reason is None and voiced_seconds >= 1.5,
                        "Recognized words match": phrase_matches,
                        "Speaker vector present": candidate_valid,
                        "Recognizer segments": len(results),
                        "Selected speaker segment": "none" if candidate_index is None else candidate_index + 1,
                        "Selected segment audio seconds": "none" if candidate_index is None else segment_seconds[candidate_index],
                        "Selected speaker nonsilence frames": spk_frames if type(spk_frames) is int and spk_frames >= 0 else "not reported",
                        "Voice stage seconds": round(time.monotonic() - voice_started, 3),
                    })
                    self._diagnose("voice", "\n".join(f"{key}: {value}" for key, value in voice_observation.items()))
                rejection_message = "A usable voice signature was not detected. Try again at a normal volume."
                if quality_reason is not None:
                    rejection_message = quality_reason
                elif voiced_seconds < 1.5:
                    rejection_message = ("Voice is too quiet. Move closer or speak a little louder."
                                         if low_volume_seen else
                                         "Not enough clear speech was detected. Read the entire displayed phrase.")
                elif not phrase_matches:
                    rejection_message = "The displayed phrase was not recognized exactly. Read every word once at a normal pace."
                elif candidate_valid:
                    vector = numpy.array(candidate, dtype="float32")
                    norm = float(numpy.linalg.norm(vector))
                    if norm > 0 and math.isfinite(norm) and (not references or vector.size == references[0].size):
                        references.append(vector / norm)
                        accepted = True
                        self.feedback(CaptureFeedback(
                            "Spoken challenge captured. Checking identity next." if verifying else
                            f"Take {take}/3 accepted for enrollment. Quality is not identity or liveness proof."))
                        control(VoicePrompt("accepted", take, attempt, phrase), {"continue"})
                        break
                self.feedback(CaptureFeedback(rejection_message))
                if attempt < attempt_count:
                    control(VoicePrompt("rejected", take, attempt, phrase), {"retry"})
                else:
                    control(VoicePrompt("failed", take, attempt, phrase), {"finish"})
            if not accepted:
                if verifying:
                    raise VerificationRejected(rejection_message)
                raise CaptureError("Three usable voice takes were not collected. Cancelled or poor samples are not saved.")
        reference = numpy.mean(numpy.stack(references), axis=0).astype("float32")
        norm = float(numpy.linalg.norm(reference))
        if not math.isfinite(norm) or norm <= 0:
            raise CaptureError("Voice reference was invalid.")
        reference /= norm
        return b"VOSKSPK1\0" + struct.pack(f"<I{reference.size}f", reference.size, *reference)
