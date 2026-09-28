"""Audio plumbing regressions, no model download or microphone required."""

import io
import json
from pathlib import Path
import shutil
import types
import unittest
from unittest.mock import patch
import wave

from bgd_vision.speech_prototype import OfflineSpeechPrototype


class SpeechSegmentsTests(unittest.TestCase):
    def transcribe(self, finalized, final):
        source = io.BytesIO()
        with wave.open(source, "wb") as recording:
            recording.setnchannels(1)
            recording.setsampwidth(2)
            recording.setframerate(16000)
            recording.writeframes(b"\0\0" * (4000 * (len(finalized) + 1)))

        class Recognizer:
            def __init__(self, *_args):
                self.index = 0

            def AcceptWaveform(self, data):
                self.index += 1
                return self.index <= len(finalized)

            def Result(self):
                return json.dumps({"text": finalized[self.index - 1]})

            def FinalResult(self):
                return json.dumps({"text": final})

        paths = []

        def normalize(command, **_kwargs):
            input_path = Path(command[command.index("-i") + 1])
            output_path = Path(command[-1])
            paths.extend((input_path, output_path))
            shutil.copyfile(input_path, output_path)

        prototype = OfflineSpeechPrototype("unused-runtime", "unused-model")
        prototype.model = object()
        with patch.dict("sys.modules", {"vosk": types.SimpleNamespace(KaldiRecognizer=Recognizer)}), \
                patch("bgd_vision.speech_prototype.subprocess.run", side_effect=normalize):
            try:
                return prototype.transcribe(source.getvalue(), "audio/wav")
            finally:
                self.assertTrue(paths)
                self.assertTrue(all(not path.exists() for path in paths), "Temporary audio must be discarded")

    def test_preserves_pause_separated_segments_and_final_clause_in_order(self):
        self.assertEqual(self.transcribe(["find the bottle", "do not follow it"], "count people instead"),
                         "find the bottle do not follow it count people instead")

    def test_skips_empty_segments_without_dropping_earlier_speech(self):
        self.assertEqual(self.transcribe(["  ", "stop", ""], " "), "stop")

    def test_continuous_utterance_uses_final_result(self):
        self.assertEqual(self.transcribe([], "follow me"), "follow me")

    def test_empty_audio_has_no_invented_command_and_is_discarded(self):
        with self.assertRaisesRegex(ValueError, "No speech recognized"):
            self.transcribe(["", " "], "")


if __name__ == "__main__":
    unittest.main()
