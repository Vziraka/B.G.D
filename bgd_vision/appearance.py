"""OSNet MSMT17 person-ReID descriptors; ephemeral continuity, not face identity."""

from pathlib import Path


class AppearanceEncoder:
    def __init__(self, model):
        import ncnn

        self.ncnn = ncnn
        self.net = ncnn.Net()
        # One CPU thread avoids oversubscription with the live detector/camera.
        self.net.opt.num_threads = 1
        self.net.opt.use_vulkan_compute = False
        # Preserve the FP32 export: default ARM half storage reduced parity.
        self.net.opt.use_fp16_storage = False
        self.net.opt.use_fp16_arithmetic = False
        self.net.opt.use_fp16_packed = False
        model = Path(model)
        if (self.net.load_param(str(model / "model.ncnn.param")) != 0
                or self.net.load_model(str(model / "model.ncnn.bin")) != 0):
            raise RuntimeError("Could not load appearance model")
        self.input_name = self.net.input_names()[0]
        self.output_name = self.net.output_names()[0]

    def encode(self, frame, tracks):
        """Attach private descriptors to xyxy pixel boxes in a BGR image; never persist them."""
        import numpy as np
        from PIL import Image

        height, width = frame.shape[:2]
        for track in tracks:
            track["appearance"] = None
            box = np.asarray(track.get("box", []), dtype=float)
            if box.shape != (4,) or not np.isfinite(box).all():
                continue
            x1, y1 = np.floor(box[:2]).astype(int)
            x2, y2 = np.ceil(box[2:]).astype(int)
            x1, x2 = max(0, min(width, x1)), max(0, min(width, x2))
            y1, y2 = max(0, min(height, y1)), max(0, min(height, y2))
            if x2 - x1 < 8 or y2 - y1 < 8:
                continue
            # Match Torchreid FeatureExtractor: RGB PIL bilinear 256x128, ImageNet normalization.
            crop = Image.fromarray(frame[y1:y2, x1:x2, ::-1]).resize(
                (128, 256), Image.Resampling.BILINEAR)
            pixels = np.asarray(crop, dtype=np.float32) / 255
            pixels = (pixels - np.array([0.485, 0.456, 0.406], dtype=np.float32)) / np.array(
                [0.229, 0.224, 0.225], dtype=np.float32)
            blob = np.ascontiguousarray(pixels.transpose(2, 0, 1))
            with self.net.create_extractor() as extractor:
                if extractor.input(self.input_name, self.ncnn.Mat(blob)) != 0:
                    raise RuntimeError("Appearance model rejected input")
                status, output = extractor.extract(self.output_name)
                if status != 0:
                    raise RuntimeError("Appearance inference failed")
                feature = np.array(output, dtype=np.float32).reshape(-1)
            norm = float(np.linalg.norm(feature))
            if feature.shape == (512,) and np.isfinite(feature).all() and np.isfinite(norm) and norm > 1e-12:
                track["appearance"] = (feature / norm).tolist()
        return tracks


if __name__ == "__main__":
    import sys
    import numpy as np

    encoder = AppearanceEncoder(sys.argv[1])
    image = np.random.default_rng(123).integers(0, 256, (480, 640, 3), dtype=np.uint8)
    boxes = [{"box": [10, 20, 120, 400]}, {"box": [10, 20, 120, 400]},
             {"box": [-20, -20, -1, -1]}, {"box": [0, 0, float("nan"), 30]},
             {"box": [10, 10, 10, 20]}]
    encoder.encode(image, boxes)
    assert all(box["appearance"] is None for box in boxes[2:])
    assert len(boxes[0]["appearance"]) == 512
    assert abs(np.linalg.norm(boxes[0]["appearance"]) - 1) < 1e-5
    assert np.allclose(boxes[0]["appearance"], boxes[1]["appearance"])
    print("Appearance encoder crop/normalization checks passed; accuracy untested.")
