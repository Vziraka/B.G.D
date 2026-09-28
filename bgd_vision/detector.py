"""Pinned Ultralytics NCNN initialization with bounded CPU threading."""

from importlib.metadata import version
from pathlib import Path


def load_detector(model_path, imgsz=320):
    """Return YOLO with its inference net loaded using two threads, never mutated afterward."""
    import ncnn
    import numpy as np
    import torch
    from ultralytics import YOLO

    expected = {"ultralytics": "8.4.154", "ncnn": "1.0.20260526"}
    if any(version(package) != pinned for package, pinned in expected.items()):
        raise RuntimeError("Detector backend adapter requires verified Ultralytics/NCNN versions")
    path = Path(model_path)
    if not path.is_dir() or not (path / "model.ncnn.param").is_file():
        raise ValueError("Detector must be an exported NCNN model directory")
    detector = YOLO(str(path), task="detect")
    # Initialize public predictor/metadata once; Ultralytics has no NCNN thread argument.
    detector.predict(np.zeros((imgsz, imgsz, 3), dtype=np.uint8), imgsz=imgsz,
                     device="cpu", verbose=False)
    backend = detector.predictor.model.backend
    if not isinstance(backend.net, ncnn.Net):
        raise RuntimeError("Unexpected detector backend")
    net = ncnn.Net()
    net.opt.num_threads = 2
    net.opt.use_vulkan_compute = False
    if (net.load_param(str(path / "model.ncnn.param")) != 0
            or net.load_model(str(path / "model.ncnn.bin")) != 0):
        raise RuntimeError("Could not load detector NCNN weights")
    # Replace only this predictor's net. Setting opt after load retains old GEMM threads.
    backend.net = net
    torch.set_num_threads(2)
    return detector
