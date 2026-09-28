"""OpenCV YuNet/SFace face features; recognition only, never liveness."""

import argparse
from pathlib import Path
import time


class FaceEncoder:
    """Detect one face and return its SFace feature vector."""

    def __init__(self, detector_model, recognizer_model, score_threshold=0.9):
        import cv2

        detector_model = Path(detector_model)
        recognizer_model = Path(recognizer_model)
        if not detector_model.is_file() or not recognizer_model.is_file():
            raise ValueError("YuNet and SFace ONNX model files are required")
        cv2.setNumThreads(1)
        self.cv2 = cv2
        self.detector = cv2.FaceDetectorYN.create(
            str(detector_model), "", (320, 320), score_threshold, 0.3, 5000
        )
        self.recognizer = cv2.FaceRecognizerSF.create(str(recognizer_model), "")

    def detect(self, frame):
        """Return YuNet face rows for a BGR frame."""
        if frame is None or getattr(frame, "ndim", 0) != 3 or frame.shape[2] != 3:
            raise ValueError("Expected a three-channel image")
        height, width = frame.shape[:2]
        if width < 1 or height < 1:
            raise ValueError("Image cannot be empty")
        self.detector.setInputSize((width, height))
        faces = self.detector.detect(frame)[1]
        return [] if faces is None else list(faces)

    def encode_one(self, frame):
        """Return (feature, face) only when exactly one face is visible."""
        import numpy as np

        faces = self.detect(frame)
        if len(faces) != 1:
            return None, None
        aligned = self.recognizer.alignCrop(frame, faces[0])
        feature = self.recognizer.feature(aligned)
        if feature.shape != (1, 128) or not np.isfinite(feature).all():
            raise RuntimeError("SFace returned an invalid feature")
        return feature.copy(), faces[0]

    def observe(self, frame):
        """Return private feature plus framing/pose measurements for guided enrollment."""
        import numpy as np

        faces = self.detect(frame)
        result = {"face_count": len(faces)}
        if len(faces) != 1:
            return result
        face = np.asarray(faces[0], dtype=np.float32)
        aligned = self.recognizer.alignCrop(frame, face)
        feature = self.recognizer.feature(aligned)
        if feature.shape != (1, 128) or not np.isfinite(feature).all():
            raise RuntimeError("SFace returned an invalid feature")
        height, width = frame.shape[:2]
        x, y, box_width, box_height = [float(value) for value in face[:4]]
        points = face[4:14].reshape(5, 2)
        eye_mid = points[:2].mean(axis=0)
        mouth_mid = points[3:].mean(axis=0)
        vertical_span = max(float(mouth_mid[1] - eye_mid[1]), 1.0)
        # Relative landmark geometry is sufficient for guidance, not head-pose proof.
        yaw = float((points[2, 0] - (eye_mid[0] + mouth_mid[0]) / 2) / max(box_width, 1.0))
        pitch = float((points[2, 1] - eye_mid[1]) / vertical_span)
        result.update(
            confidence=float(face[14]),
            box=[x, y, x + box_width, y + box_height],
            center_x=(x + box_width / 2) / width,
            center_y=(y + box_height / 2) / height,
            face_height=box_height / height,
            yaw=yaw,
            pitch=pitch,
            feature=feature.copy(),
        )
        return result

    def compare(self, first, second):
        """Return SFace cosine similarity; this is not an authorization decision."""
        import numpy as np

        first = np.asarray(first, dtype=np.float32)
        second = np.asarray(second, dtype=np.float32)
        if first.shape != (1, 128) or second.shape != (1, 128):
            raise ValueError("Expected two SFace feature vectors")
        if not np.isfinite(first).all() or not np.isfinite(second).all():
            raise ValueError("Face features must be finite")
        return float(self.recognizer.match(
            first, second, self.cv2.FaceRecognizerSF_FR_COSINE
        ))


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("detector", type=Path)
    parser.add_argument("recognizer", type=Path)
    args = parser.parse_args()

    import numpy as np

    started = time.perf_counter()
    encoder = FaceEncoder(args.detector, args.recognizer)
    load_ms = (time.perf_counter() - started) * 1000
    blank = np.zeros((320, 320, 3), dtype=np.uint8)
    assert encoder.detect(blank) == []
    aligned = np.zeros((112, 112, 3), dtype=np.uint8)
    first = encoder.recognizer.feature(aligned)
    second = encoder.recognizer.feature(aligned)
    assert first.shape == (1, 128) and np.isfinite(first).all()
    assert abs(encoder.compare(first, second) - 1.0) < 1e-6
    print(f"YuNet/SFace self-check passed in {load_ms:.1f} ms; accuracy and liveness untested.")


if __name__ == "__main__":
    main()
