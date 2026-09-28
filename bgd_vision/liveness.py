"""Experimental MiniFASNet RGB anti-spoof scoring; never authorization."""

import argparse
import json
from pathlib import Path
import sys
import time
from urllib.request import urlopen


class MiniFasLiveness:
    """Run Minivision's two-model fusion with a caller-supplied face box."""

    def __init__(self, source_dir, model_dir):
        source_dir, model_dir = Path(source_dir), Path(model_dir)
        if not (source_dir / "src").is_dir():
            raise ValueError("Silent-Face-Anti-Spoofing source directory is required")
        model_paths = sorted(model_dir.glob("*.pth"))
        if len(model_paths) != 2:
            raise ValueError("Expected the two official MiniFASNet model files")
        sys.path.insert(0, str(source_dir))

        import torch
        from src.generate_patches import CropImage
        from src.model_lib.MiniFASNet import MiniFASNetV1SE, MiniFASNetV2
        from src.utility import get_kernel, parse_model_name

        torch.set_num_threads(1)
        classes = {"MiniFASNetV1SE": MiniFASNetV1SE, "MiniFASNetV2": MiniFASNetV2}
        self.torch, self.cropper, self.models = torch, CropImage(), []
        for path in model_paths:
            height, width, kind, scale = parse_model_name(path.name)
            model = classes[kind](conv6_kernel=get_kernel(height, width))
            raw = torch.load(path, map_location="cpu", weights_only=True)
            state = {key.removeprefix("module."): value for key, value in raw.items()}
            model.load_state_dict(state, strict=True)
            self.models.append((model.eval(), scale, width, height))

    def score(self, frame, face):
        """Return fused class probabilities; class1 is the upstream real-face label."""
        import numpy as np

        if frame is None or getattr(frame, "ndim", 0) != 3 or frame.shape[2] != 3:
            raise ValueError("Expected a three-channel image")
        if len(face) < 4:
            raise ValueError("Expected a face box")
        bbox = [int(value) for value in face[:4]]
        if bbox[2] <= 0 or bbox[3] <= 0:
            raise ValueError("Face box must have positive size")
        fused = np.zeros(3, dtype=np.float64)
        with self.torch.no_grad():
            for model, scale, width, height in self.models:
                crop = self.cropper.crop(frame, bbox, scale, width, height, crop=True)
                tensor = self.torch.from_numpy(
                    np.ascontiguousarray(crop.transpose(2, 0, 1))
                ).float().unsqueeze(0)
                fused += self.torch.softmax(model(tensor), dim=1)[0].numpy()
        fused /= len(self.models)
        return {
            "probabilities": [round(float(value), 4) for value in fused],
            "label": int(fused.argmax()),
            "real_probability": round(float(fused[1]), 4),
            "is_live_label": int(fused.argmax()) == 1,
        }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source_dir", type=Path)
    parser.add_argument("model_dir", type=Path)
    parser.add_argument("--detector-model", type=Path)
    parser.add_argument("--frame-url")
    parser.add_argument("--image", type=Path)
    parser.add_argument("--frames", type=int, default=5)
    parser.add_argument("--expect-label", type=int, choices=(0, 1, 2))
    args = parser.parse_args()

    import numpy as np

    started = time.perf_counter()
    scorer = MiniFasLiveness(args.source_dir, args.model_dir)
    loaded_ms = (time.perf_counter() - started) * 1000
    if args.detector_model or args.frame_url or args.image:
        if not args.detector_model or not args.detector_model.is_file() or bool(args.frame_url) == bool(args.image):
            raise ValueError("Use --detector-model with exactly one of --frame-url or --image")
        if not 1 <= args.frames <= 20:
            raise ValueError("--frames must be between 1 and 20")
        import cv2

        detector = cv2.FaceDetectorYN.create(
            str(args.detector_model), "", (320, 320), 0.9, 0.3, 5000
        )
        sequence, results = -1, []
        frame_count = args.frames if args.frame_url else 1
        for _ in range(frame_count):
            if args.frame_url:
                with urlopen(f"{args.frame_url}?after={sequence}", timeout=3) as response:
                    metadata = json.loads(response.headers["X-Frame-Meta"])
                    frame = cv2.imdecode(np.frombuffer(response.read(), np.uint8), cv2.IMREAD_COLOR)
                sequence = metadata["sequence"]
            else:
                frame = cv2.imread(str(args.image))
                if frame is None:
                    raise ValueError("Could not read --image")
            detector.setInputSize((frame.shape[1], frame.shape[0]))
            faces = detector.detect(frame)[1]
            if faces is None or len(faces) != 1:
                raise RuntimeError("Exactly one clear face is required in every frame")
            started = time.perf_counter()
            result = scorer.score(frame, faces[0])
            result["inference_ms"] = round((time.perf_counter() - started) * 1000, 1)
            results.append(result)
        summary = {
            "frames": len(results),
            "real_labels": sum(result["is_live_label"] for result in results),
            "labels": [result["label"] for result in results],
            "probabilities": [result["probabilities"] for result in results],
            "real_probabilities": [result["real_probability"] for result in results],
            "inference_ms": [result["inference_ms"] for result in results],
        }
        print(json.dumps(summary))
        if args.expect_label is not None:
            assert summary["labels"] == [args.expect_label] * len(results)
        return

    frame = np.zeros((240, 320, 3), dtype=np.uint8)
    started = time.perf_counter()
    result = scorer.score(frame, [100, 50, 120, 140])
    inference_ms = (time.perf_counter() - started) * 1000
    assert len(result["probabilities"]) == 3
    assert abs(sum(result["probabilities"]) - 1) < 0.001
    print(f"MiniFASNet self-check passed: load {loaded_ms:.1f} ms, inference {inference_ms:.1f} ms; accuracy untested.")


if __name__ == "__main__":
    main()
