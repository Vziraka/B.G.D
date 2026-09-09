"""Synthetic external device/model outputs through the public enrollment capture adapter."""

import json
from pathlib import Path
from types import SimpleNamespace
import tempfile
from threading import Event
import time
import unittest
from contextlib import contextmanager
from unittest.mock import patch

import numpy as np
import cv2

from pc_biometric.capture import CaptureError, ENROLLMENT_PHRASES, EnrollmentCapture, VoicePrompt
from pc_biometric.enrollment import References
from voice_capture_validation import rejection_reason


class Camera:
    def __init__(self):
        self.released = False

    def isOpened(self):
        return True

    def read(self):
        frame = np.repeat((100 + (np.indices((240, 320)).sum(axis=0) % 2) * 60)
                          .astype(np.uint8)[:, :, None], 3, axis=2)
        return True, frame

    def release(self):
        self.released = True


class Detector:
    def setInputSize(self, _size):
        pass

    def detect(self, _frame):
        return None, np.array([[80, 30, 160, 180, 120, 85, 200, 85, 160, 120,
                               135, 165, 185, 165, .99]], dtype=np.float32)


class Recognizer:
    def alignCrop(self, frame, _face):
        return frame

    def feature(self, _aligned):
        return np.arange(128, dtype=np.float32).reshape(1, 128)


class AudioStream:
    def __init__(self):
        self.blocks = 0

    def __enter__(self):
        return self

    def __exit__(self, *_args):
        pass

    def read(self, _frames):
        self.blocks += 1
        volume = 50 if self.blocks <= 2 else 4000
        return (np.sin(np.arange(4000) * .08) * volume).astype("<i2").tobytes(), False


class SpeechRecognizer:
    phrase = ""

    def __init__(self, *_args):
        self.blocks = 0

    def SetSpkModel(self, _model):
        pass

    def AcceptWaveform(self, _audio):
        self.blocks += 1
        return self.blocks >= 8

    def Result(self):
        return json.dumps({"spk": [0.1] * 128, "text": self.phrase})

    def FinalResult(self):
        return self.Result()


class CaptureTests(unittest.TestCase):
    def test_recording_signal_is_not_shown_until_microphone_stream_is_open(self):
        active = [False]
        class Stream(AudioStream):
            def __enter__(self):
                active[0] = True
                return self

            def __exit__(self, *_args):
                active[0] = False

        def control(prompt):
            if prompt.state == "recording":
                self.assertTrue(active[0], "Recording was announced before microphone startup completed")
            return EnrollmentCapture._automatic_voice_control(prompt)

        with self.voice_fixture(stream_type=Stream) as (root, _events, feedback):
            capture = EnrollmentCapture(root, Event(), validate_models=lambda _root: True,
                                        feedback=feedback, voice_control=control, isolated=False)
            capture.capture()
        self.assertFalse(active[0])

    def test_validation_reduces_prefixed_guidance_to_safe_categories(self):
        self.assertEqual(rejection_reason('Take 1/3 · Read: "words"\nAudio is clipping. Move farther away.'),
                         "clipping")
        self.assertEqual(rejection_reason('Take 1/3 · Read: "words"\nVoice is too quiet. Move closer.'),
                         "too_quiet")
        self.assertEqual(rejection_reason('Take 1/3 · Read: "words"\nToo much background noise compared with your voice.'),
                         "background_noise")

    @contextmanager
    def voice_fixture(self, stream_type=AudioStream, speech_type=SpeechRecognizer, play=lambda *_args, **_kwargs: None):
        with self.face_fixture() as (root, _camera):
            (root / "vosk-model-small-en-us-0.15").mkdir()
            (root / "vosk-model-spk-0.4").mkdir()
            vosk = SimpleNamespace(Model=lambda *_args: object(), SpkModel=lambda *_args: object(),
                                   KaldiRecognizer=speech_type, SetLogLevel=lambda _level: None)
            events = []
            def feedback(value):
                events.append(value)
                if 'Read: "' in value.message:
                    speech_type.phrase = value.message.split('Read: "')[1].split('"')[0]
            with patch.dict("sys.modules", {"sounddevice": SimpleNamespace(RawInputStream=lambda **_kwargs: stream_type(),
                                                                            query_devices=lambda *_args, **_kwargs: {"index": 1, "name": "Synthetic microphone", "hostapi": 0},
                                                                            query_hostapis=lambda _index: {"name": "Synthetic backend"},
                                                                            play=play,
                                                                            get_stream=lambda: SimpleNamespace(active=False),
                                                                            stop=lambda: None),
                                            "vosk": vosk}):
                yield root, events, feedback

    def test_voice_waits_for_hold_release_review_and_memory_playback(self):
        states = []
        played = []
        played_once = False

        def control(prompt: VoicePrompt) -> str:
            nonlocal played_once
            states.append(prompt.state)
            if prompt.state == "ready":
                return "record_start"
            if prompt.state == "recording":
                return "record_stop" if prompt.elapsed_seconds >= 2 else "continue"
            if prompt.state == "review" and not played_once:
                played_once = True
                return "playback"
            if prompt.state == "review":
                return "submit"
            return "continue"

        with self.voice_fixture(play=lambda audio, rate, **options:
                                played.append((audio.copy(), rate, options))) as (root, _events, feedback):
            result = EnrollmentCapture(root, Event(), validate_models=lambda _root: True,
                                       feedback=feedback, voice_control=control,
                                       isolated=False).capture()
        self.assertTrue(result.voice.startswith(b"VOSKSPK1\0"))
        self.assertIn("measuring", states)
        self.assertIn("ready", states)
        self.assertIn("recording", states)
        self.assertIn("review", states)
        self.assertIn("playing", states)
        self.assertIn("processing", states)
        self.assertEqual(len(played), 1)
        self.assertEqual(played[0][1:], (16000, {"blocking": False}))

    def test_isolated_capture_has_a_five_minute_wall_clock_bound(self):
        clock = [0.0]

        class ParentConnection:
            def __init__(self):
                self.messages = []
                self.sent = []
                self.polls = 0

            def close(self):
                pass

            def poll(self, _timeout=None):
                self.polls += 1
                clock[0] = 299.0 if self.polls == 1 else 300.0
                return bool(self.messages)

            def recv(self):
                return self.messages.pop(0)

            def send(self, value):
                self.sent.append(value)

        class ChildConnection:
            def close(self):
                pass

        class Process:
            def __init__(self):
                self.alive = True
                self.terminated = False

            def start(self):
                pass

            def is_alive(self):
                return self.alive

            def terminate(self):
                self.terminated = True
                self.alive = False

            def join(self, _timeout=None):
                pass

            def kill(self):
                self.alive = False

        parent = ParentConnection()
        process = Process()
        context = SimpleNamespace(Pipe=lambda duplex=True: (parent, ChildConnection()),
                                  Process=lambda **_kwargs: process)
        capture = EnrollmentCapture(Path("unused"), Event())
        with patch("pc_biometric.capture.multiprocessing.get_context", return_value=context), \
                patch("pc_biometric.capture.time.monotonic", side_effect=lambda: clock[0]):
            with self.assertRaisesRegex(CaptureError, "timed out"):
                capture.capture()
        self.assertTrue(process.terminated)
        self.assertFalse(process.is_alive())
        self.assertEqual(parent.sent, [])

    def test_record_again_keeps_the_same_take_and_attempt(self):
        ready_prompts = []
        rerecorded = False

        def control(prompt: VoicePrompt) -> str:
            nonlocal rerecorded
            if prompt.state == "ready":
                ready_prompts.append((prompt.take, prompt.attempt, prompt.phrase))
                return "record_start"
            if prompt.state == "recording":
                return "record_stop" if prompt.elapsed_seconds >= 2 else "continue"
            if prompt.state == "review" and not rerecorded:
                rerecorded = True
                return "rerecord"
            if prompt.state == "review":
                return "submit"
            return "continue"

        with self.voice_fixture() as (root, _events, feedback):
            EnrollmentCapture(root, Event(), validate_models=lambda _root: True,
                              feedback=feedback, voice_control=control,
                              isolated=False).capture()
        self.assertGreaterEqual(len(ready_prompts), 4)
        self.assertEqual(ready_prompts[0], ready_prompts[1])

    def test_voice_rejects_silence_clipping_noise_and_wrong_words(self):
        class Silence(AudioStream):
            def read(self, _frames):
                return bytes(8000), False
        class Noise(AudioStream):
            streams = 0
            def __init__(self):
                super().__init__()
                Noise.streams += 1
                self.measuring = Noise.streams % 2 == 1
            def read(self, _frames):
                volume = 300 if self.measuring else 800
                return (np.sin(np.arange(4000) * .08) * volume).astype("<i2").tobytes(), False
        class Clipping(AudioStream):
            def read(self, frames):
                data, overflow = super().read(frames)
                return ((np.ones(4000) * 32767).astype("<i2").tobytes() if self.blocks > 2 else data), overflow
        class WrongWords(SpeechRecognizer):
            def Result(self):
                return json.dumps({"spk": [.1] * 128, "text": "different words entirely"})
        class NoSignature(SpeechRecognizer):
            def Result(self):
                return json.dumps({"text": self.phrase})
        for stream, speech, reason in [(Silence, SpeechRecognizer, "not enough clear speech"),
                                        (Noise, SpeechRecognizer, "noise"),
                                        (Clipping, SpeechRecognizer, "clipping"),
                                        (AudioStream, WrongWords, "not recognized exactly"),
                                        (AudioStream, NoSignature, "usable voice signature")]:
            with self.subTest(reason=reason), self.voice_fixture(stream, speech) as (root, events, feedback):
                with self.assertRaises(CaptureError) as raised:
                    EnrollmentCapture(root, Event(), validate_models=lambda _root: True,
                                      feedback=feedback, isolated=False).capture()
                self.assertEqual(str(raised.exception),
                                 "Three usable voice takes were not collected. Cancelled or poor samples are not saved.")
                self.assertTrue(any(reason in event.message.lower() for event in events))
                self.assertIn(reason, events[-1].message.lower())
                self.assertFalse(any("accepted for enrollment" in event.message for event in events))

    def test_specific_rejection_reason_remains_last_when_retry_is_offered(self):
        class WrongWords(SpeechRecognizer):
            def Result(self):
                return json.dumps({"spk": [.1] * 128, "text": "different words entirely"})

        shown_at_retry = []
        with self.voice_fixture(speech_type=WrongWords) as (root, events, feedback):
            def control(prompt: VoicePrompt) -> str:
                if prompt.state == "rejected":
                    shown_at_retry.append(events[-1].message)
                return EnrollmentCapture._automatic_voice_control(prompt)

            with self.assertRaises(CaptureError):
                EnrollmentCapture(root, Event(), validate_models=lambda _root: True,
                                  feedback=feedback, voice_control=control,
                                  isolated=False).capture()
        self.assertEqual(len(shown_at_retry), 2)
        self.assertTrue(all("not recognized exactly" in message for message in shown_at_retry))

    def test_early_quality_failure_remains_visible_after_later_good_audio(self):
        class FirstBlockClips(AudioStream):
            streams = 0

            def __init__(self):
                super().__init__()
                FirstBlockClips.streams += 1
                self.recording = FirstBlockClips.streams % 2 == 0

            def read(self, frames):
                data, overflow = super().read(frames)
                if self.recording and self.blocks == 1:
                    data = (np.ones(4000) * 32767).astype("<i2").tobytes()
                return data, overflow

        shown_at_retry = []
        with self.voice_fixture(stream_type=FirstBlockClips) as (root, events, feedback):
            def control(prompt: VoicePrompt) -> str:
                if prompt.state == "rejected":
                    shown_at_retry.append(events[-1].message)
                return EnrollmentCapture._automatic_voice_control(prompt)

            with self.assertRaises(CaptureError):
                EnrollmentCapture(root, Event(), validate_models=lambda _root: True,
                                  feedback=feedback, voice_control=control,
                                  isolated=False).capture()
        self.assertEqual(len(shown_at_retry), 2)
        self.assertTrue(all(message.startswith("Audio is clipping.") for message in shown_at_retry))

    def test_bad_voice_take_retries_without_counting_as_one_of_three(self):
        class FirstWrong(SpeechRecognizer):
            results = 0
            def Result(self):
                FirstWrong.results += 1
                if FirstWrong.results == 1:
                    return json.dumps({"spk": [.1] * 128, "text": "wrong phrase"})
                return super().Result()
        with self.voice_fixture(speech_type=FirstWrong) as (root, events, feedback):
            result = EnrollmentCapture(root, Event(), validate_models=lambda _root: True,
                                       feedback=feedback, isolated=False).capture()
            self.assertTrue(result.voice.startswith(b"VOSKSPK1\0"))
            self.assertEqual(FirstWrong.results, 4)
            self.assertEqual(sum("accepted for enrollment" in event.message for event in events), 3)
            vector = np.frombuffer(result.voice[13:], dtype="<f4")
            self.assertAlmostEqual(float(np.linalg.norm(vector)), 1, places=5)

    def test_cancel_while_voice_guidance_is_displayed_closes_audio_stream(self):
        cancelled = Event()
        class Stream(AudioStream):
            closed = False
            def __exit__(self, *_args):
                Stream.closed = True
        with self.voice_fixture(stream_type=Stream) as (root, _events, original):
            def feedback(value):
                original(value)
                if 'Read: "' in value.message:
                    cancelled.set()
            with self.assertRaises(CaptureError):
                EnrollmentCapture(root, cancelled, validate_models=lambda _root: True,
                                  feedback=feedback, isolated=False).capture()
        self.assertTrue(Stream.closed)

    @contextmanager
    def face_fixture(self, *, frame=None, faces=None):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "face_detection_yunet_2023mar.onnx").write_bytes(b"detector")
            (root / "face_recognition_sface_2021dec.onnx").write_bytes(b"recognizer")
            if frame is None:
                frame = np.repeat((100 + (np.indices((240, 320)).sum(axis=0) % 2) * 60)
                                  .astype(np.uint8)[:, :, None], 3, axis=2)
            if faces is None:
                faces = np.array([[80, 30, 160, 180, 120, 85, 200, 85, 160, 120,
                                   135, 165, 185, 165, .99]], dtype=np.float32)
            camera = Camera()
            camera.read = lambda: (True, frame)
            detector = Detector()
            detector.detect = lambda _frame: (None, faces() if callable(faces) else faces)
            ticks = iter(np.arange(0, 1000, .05))
            with patch.multiple(cv2, VideoCapture=lambda *_args: camera,
                    FaceDetectorYN=SimpleNamespace(create=lambda *_args: detector),
                    FaceRecognizerSF=SimpleNamespace(create=lambda *_args: Recognizer())), \
                    patch("pc_biometric.capture.time.monotonic", side_effect=lambda: float(next(ticks))):
                yield root, camera

    def test_blurry_face_never_advances_to_voice_and_reports_guidance(self):
        events = []
        with self.face_fixture(frame=np.full((240, 320, 3), 130, dtype=np.uint8)) as (root, camera):
            with self.assertRaises(CaptureError):
                EnrollmentCapture(root, Event(), validate_models=lambda _root: True,
                                  feedback=events.append, isolated=False).capture()
            self.assertTrue(camera.released)
        self.assertTrue(any("sharp" in event.message.lower() for event in events))

    def test_bad_framing_lighting_pose_and_multiple_faces_are_rejected(self):
        good = Detector().detect(None)[1]
        small = good.copy()
        small[0, 2] = 60
        outside = good.copy()
        outside[0, 0] = -10
        tilted = good.copy()
        tilted[0, 7] = 120
        pitched = good.copy()
        pitched[0, 9] = 86
        pitched[0, 11] = pitched[0, 13] = 95
        cases = [(None, small, "closer"), (None, outside, "inside"),
                 (None, tilted, "straight"), (None, pitched, "straight"), (None, np.vstack([good, good]), "one face"),
                 (np.zeros((240, 320, 3), dtype=np.uint8), good, "lighting")]
        for frame, faces, expected in cases:
            with self.subTest(expected=expected), self.face_fixture(frame=frame, faces=faces) as (root, _camera):
                events = []
                with self.assertRaises(CaptureError):
                    EnrollmentCapture(root, Event(), validate_models=lambda _root: True,
                                      feedback=events.append, isolated=False).capture()
                self.assertTrue(any(expected in event.message for event in events))

    def test_face_must_stay_present_continuously_before_automatic_sampling(self):
        calls = 0
        def intermittent():
            nonlocal calls
            calls += 1
            return Detector().detect(None)[1] if calls % 2 else None
        with self.face_fixture(faces=intermittent) as (root, _camera):
            events = []
            with self.assertRaises(CaptureError):
                EnrollmentCapture(root, Event(), validate_models=lambda _root: True,
                                  feedback=events.append, isolated=False).capture()
        self.assertFalse(any("Capturing" in event.message for event in events))

    def test_landmarks_are_only_in_preview_and_disappear_without_a_face(self):
        calls = 0
        def detected():
            nonlocal calls
            calls += 1
            return Detector().detect(None)[1] if calls == 1 else None
        cancelled = Event()
        previews = []
        def preview(png):
            previews.append(cv2.imdecode(np.frombuffer(png, dtype=np.uint8), cv2.IMREAD_COLOR))
            if len(previews) == 2:
                cancelled.set()
        with self.face_fixture(faces=detected) as (root, camera):
            with self.assertRaises(CaptureError):
                EnrollmentCapture(root, cancelled, validate_models=lambda _root: True,
                                  preview=preview, isolated=False).capture()
            source = camera.read()[1]
        self.assertEqual(previews[0][85, 120].tolist(), [135, 220, 170])
        self.assertEqual(previews[1][85, 120].tolist(), source[85, 120].tolist())

    def test_synthetic_camera_and_microphone_outputs_become_bounded_references(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "face_detection_yunet_2023mar.onnx").write_bytes(b"detector")
            (root / "face_recognition_sface_2021dec.onnx").write_bytes(b"recognizer")
            (root / "vosk-model-small-en-us-0.15").mkdir()
            (root / "vosk-model-spk-0.4").mkdir()
            camera = Camera()
            cv2 = SimpleNamespace(
                CAP_DSHOW=700, VideoCapture=lambda *_args: camera,
                FaceDetectorYN=SimpleNamespace(create=lambda *_args: Detector()),
                FaceRecognizerSF=SimpleNamespace(create=lambda *_args: Recognizer()),
                imencode=lambda *_args: (True, np.frombuffer(b"memory-only-preview", dtype=np.uint8)),
                circle=__import__("cv2").circle, resize=__import__("cv2").resize,
                cvtColor=__import__("cv2").cvtColor, COLOR_BGR2GRAY=6,
                Laplacian=__import__("cv2").Laplacian, CV_64F=6,
            )
            sounddevice = SimpleNamespace(RawInputStream=lambda **_kwargs: AudioStream())
            vosk = SimpleNamespace(Model=lambda *_args: object(), SpkModel=lambda *_args: object(),
                                   KaldiRecognizer=SpeechRecognizer, SetLogLevel=lambda _level: None)
            stages = []
            previews = []
            prompts = []
            feedbacks = []
            def feedback(value):
                feedbacks.append(value)
                if 'Read: "' in value.message:
                    phrase = value.message.split('Read: "')[1].split('"')[0]
                    SpeechRecognizer.phrase = phrase
                    prompts.append(phrase)
            with patch.dict("sys.modules", {"cv2": cv2, "sounddevice": sounddevice, "vosk": vosk}):
                references = EnrollmentCapture(root, Event(), stages.append,
                                               validate_models=lambda _root: True,
                                               preview=previews.append,
                                               feedback=feedback,
                                               face_sample_interval=0,
                                               isolated=False).capture()
            self.assertTrue(references.face.startswith(b"SFACE1\0"))
            self.assertTrue(references.voice.startswith(b"VOSKSPK1\0"))
            self.assertEqual(len(set(prompts)), 3)
            self.assertTrue(any(value.waveform and max(value.waveform) > 0 for value in feedbacks))
            self.assertLessEqual(len(references.face), 65536)
            self.assertLessEqual(len(references.voice), 65536)
            self.assertEqual(stages, ["face", "idle", "voice", "idle"])
            self.assertGreaterEqual(len(previews), 1)
            self.assertEqual(previews[0], b"memory-only-preview")
            self.assertTrue(camera.released)
            self.assertEqual(set(root.iterdir()), {
                root / "face_detection_yunet_2023mar.onnx",
                root / "face_recognition_sface_2021dec.onnx",
                root / "vosk-model-small-en-us-0.15", root / "vosk-model-spk-0.4",
            })

    def test_cancelled_capture_opens_no_device(self):
        cancelled = Event()
        cancelled.set()
        with tempfile.TemporaryDirectory() as directory:
            with self.assertRaises(CaptureError):
                EnrollmentCapture(Path(directory), cancelled, isolated=False).capture()

    def test_status_failure_prevents_camera_activation(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            (root / "face_detection_yunet_2023mar.onnx").write_bytes(b"detector")
            (root / "face_recognition_sface_2021dec.onnx").write_bytes(b"recognizer")
            camera = Camera()
            cv2 = SimpleNamespace(
                CAP_DSHOW=700, VideoCapture=lambda *_args: camera,
                FaceDetectorYN=SimpleNamespace(create=lambda *_args: Detector()),
                FaceRecognizerSF=SimpleNamespace(create=lambda *_args: Recognizer()),
            )
            with patch.dict("sys.modules", {"cv2": cv2}):
                with self.assertRaises(CaptureError):
                    EnrollmentCapture(root, Event(), lambda _stage: (_ for _ in ()).throw(RuntimeError()),
                                      validate_models=lambda _root: True, isolated=False).capture()
            self.assertFalse(camera.released)

    def test_cancel_terminates_an_isolated_blocked_capture(self):
        cancelled = Event()

        class Connection:
            def close(self):
                pass

            def poll(self, _timeout=None):
                return False

        class Process:
            def __init__(self):
                self.alive = True
                self.terminated = False

            def start(self):
                cancelled.set()

            def is_alive(self):
                return self.alive

            def terminate(self):
                self.terminated = True
                self.alive = False

            def join(self, _timeout=None):
                pass

            def kill(self):
                self.alive = False

        process = Process()
        context = SimpleNamespace(
            Pipe=lambda duplex=True: (Connection(), Connection()),
            Process=lambda **_kwargs: process,
        )
        with patch("pc_biometric.capture.multiprocessing.get_context", return_value=context):
            with self.assertRaises(CaptureError):
                EnrollmentCapture(Path("unused"), cancelled).capture()
        self.assertTrue(process.terminated)

    def test_real_spawned_worker_rejects_models_before_device_access(self):
        with tempfile.TemporaryDirectory() as directory:
            started = time.monotonic()
            with self.assertRaises(CaptureError):
                EnrollmentCapture(Path(directory), Event()).capture()
            self.assertLess(time.monotonic() - started, 5)
            self.assertEqual(list(Path(directory).iterdir()), [])

    def test_cancellation_during_status_ack_never_releases_the_worker(self):
        cancelled = Event()

        class ParentConnection:
            def __init__(self):
                self.sent: list[str] = []

            def close(self):
                pass

            def poll(self, _timeout=None):
                return True

            def recv(self):
                return "stage", "face"

            def send(self, value):
                self.sent.append(value)

        class ChildConnection:
            def close(self):
                pass

        class Process:
            alive = True

            def start(self):
                pass

            def is_alive(self):
                return self.alive

            def terminate(self):
                self.alive = False

            def join(self, _timeout=None):
                pass

            def kill(self):
                self.alive = False

        parent = ParentConnection()
        process = Process()
        context = SimpleNamespace(
            Pipe=lambda duplex=True: (parent, ChildConnection()),
            Process=lambda **_kwargs: process,
        )
        capture = EnrollmentCapture(Path("unused"), cancelled,
                                    stage=lambda _stage: cancelled.set())
        with patch("pc_biometric.capture.multiprocessing.get_context", return_value=context):
            with self.assertRaises(CaptureError):
                capture.capture()
        self.assertEqual(parent.sent, [])

    def test_isolated_worker_forwards_only_the_selected_voice_action(self):
        prompt = VoicePrompt("ready", 1, 1, ENROLLMENT_PHRASES[0])

        class ParentConnection:
            def __init__(self):
                self.messages = [("stage", "voice"),
                                 ("voice_control", prompt),
                                 ("result", References(b"face", b"voice"))]
                self.sent = []

            def close(self):
                pass

            def poll(self, _timeout=None):
                return bool(self.messages)

            def recv(self):
                return self.messages.pop(0)

            def send(self, value):
                self.sent.append(value)

        class ChildConnection:
            def close(self):
                pass

        class Process:
            alive = True

            def start(self):
                pass

            def is_alive(self):
                return self.alive

            def terminate(self):
                self.alive = False

            def join(self, _timeout=None):
                self.alive = False

            def kill(self):
                self.alive = False

        parent = ParentConnection()
        process = Process()
        context = SimpleNamespace(Pipe=lambda duplex=True: (parent, ChildConnection()),
                                  Process=lambda **_kwargs: process)
        capture = EnrollmentCapture(Path("unused"), Event(),
                                    voice_control=lambda _prompt: "record_start")
        with patch("pc_biometric.capture.multiprocessing.get_context", return_value=context):
            result = capture.capture()
        self.assertEqual(result, References(b"face", b"voice"))
        self.assertEqual(parent.sent, ["displayed", "record_start"])


if __name__ == "__main__":
    unittest.main()
