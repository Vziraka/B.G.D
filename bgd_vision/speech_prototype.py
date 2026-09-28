"""Offline browser speech with bounded decoding and temporary audio cleanup."""

import json
from pathlib import Path
import subprocess
import sys
import tempfile
import wave


class OfflineSpeechPrototype:
    SUFFIXES = {
        "audio/mp4": ".mp4",
        "audio/ogg": ".ogg",
        "audio/wav": ".wav",
        "audio/webm": ".webm",
    }

    def __init__(self, runtime_path, model_path):
        self.runtime_path = Path(runtime_path)
        self.model_path = Path(model_path)
        self.model = None

    def transcribe(self, audio, media_type):
        suffix = self.SUFFIXES.get(media_type)
        if suffix is None:
            raise ValueError("Use WAV, WebM, Ogg, or MP4 audio")
        with tempfile.TemporaryDirectory(prefix="bgd-speech-") as directory:
            source = Path(directory) / ("capture" + suffix)
            wav_path = Path(directory) / "normalized.wav"
            source.write_bytes(audio)
            try:
                subprocess.run(
                    ["ffmpeg", "-nostdin", "-loglevel", "error", "-y", "-i", str(source),
                     "-t", "30.1", "-ar", "16000", "-ac", "1", "-c:a", "pcm_s16le", str(wav_path)],
                    check=True, timeout=35, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL,
                )
            except (OSError, subprocess.SubprocessError) as exc:
                raise ValueError("Audio could not be decoded") from exc
            with wave.open(str(wav_path), "rb") as recording:
                duration = recording.getnframes() / recording.getframerate()
                if not 0.2 <= duration <= 30:
                    raise ValueError("Speak for up to 30 seconds")
                if self.model is None:
                    if str(self.runtime_path) not in sys.path:
                        sys.path.append(str(self.runtime_path))
                    from vosk import Model, SetLogLevel
                    SetLogLevel(-1)
                    self.model = Model(str(self.model_path))
                from vosk import KaldiRecognizer
                recognizer = KaldiRecognizer(self.model, recording.getframerate())
                segments = []
                while data := recording.readframes(4000):
                    if recognizer.AcceptWaveform(data):
                        segments.append(json.loads(recognizer.Result()).get("text", "").strip())
                segments.append(json.loads(recognizer.FinalResult()).get("text", "").strip())
                transcript = " ".join(segment for segment in segments if segment)
        if not transcript:
            raise ValueError("No speech recognized")
        return transcript
