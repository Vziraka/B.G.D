"""Opt-in integration regression using the Pi's already installed model assets."""

import os
from pathlib import Path
import unittest


@unittest.skipUnless(os.environ.get("BGD_MODEL_TESTS") == "1", "opt-in Pi model test")
class OpenVocabularyThreadTests(unittest.TestCase):
    def test_text_visual_and_refreshed_predictors_keep_budget_and_numeric_outputs(self):
        import numpy as np
        import torch
        from bgd_vision.open_vocabulary import OpenVocabularyDetector

        directory = Path.home() / "bgd-vision/candidates/yoloe26"
        detector = OpenVocabularyDetector(directory / "yoloe-26n-seg.pt",
                                          directory / "bgd-targets-yoloe26n.npz",
                                          image_size=320)
        frame = np.random.default_rng(2219).integers(0, 256, (320, 320, 3), dtype=np.uint8)
        detector.detect(frame, "book")
        self.assertEqual(torch.get_num_threads(), 1)
        tensor = torch.from_numpy(frame.transpose(2, 0, 1).copy()).unsqueeze(0).float() / 255
        with torch.inference_mode():
            torch.set_num_threads(3)
            original = detector.model.model(tensor)
            torch.set_num_threads(1)
            limited = detector.model.model(tensor)
        torch.testing.assert_close(original, limited, rtol=1e-3, atol=1e-4)
        detector.ground(frame, [80, 80, 220, 240])
        self.assertEqual(torch.get_num_threads(), 1)
        torch.set_num_threads(3)
        detector.detect_visual(frame, [{"image": frame, "box": [80, 80, 220, 240]}],
                               version=1, refresh=True)
        self.assertEqual(torch.get_num_threads(), 1)


if __name__ == "__main__":
    unittest.main()
