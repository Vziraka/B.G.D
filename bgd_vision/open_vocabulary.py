"""Lazy YOLOE adapter for the measured, local prompt profile."""


def _limit_cpu_threads(predictor):
    """Restore the measured Pi budget after Ultralytics initializes a predictor."""
    import torch

    # CPU predictor setup resets Torch to three threads on the four-core Pi.
    # One thread measured faster while leaving the live NCNN pipeline headroom.
    # This callback also covers replacement visual-prompt predictors.
    if torch.get_num_threads() != 1:
        torch.set_num_threads(1)


class OpenVocabularyDetector:
    """Detect one requested label from an offline prompt-embedding profile."""

    def __init__(self, model_path, prompt_profile, image_size=640, confidence=.05):
        from ultralytics import YOLOE

        self.model = YOLOE(str(model_path))
        self.model.add_callback("on_predict_start", _limit_cpu_threads)
        self.prompt_profile = str(prompt_profile)
        self.model.load_prompt_embeddings(self.prompt_profile)
        self.image_size = image_size
        self.confidence = confidence
        self.visual_version = None

    def detect(self, frame, target):
        self.model.load_prompt_embeddings(self.prompt_profile)
        self.visual_version = None
        names = self.model.names
        class_id = next(
            (int(identity) for identity, name in names.items() if name == target), None
        )
        if class_id is None:
            return None
        result = self.model.predict(
            frame, imgsz=self.image_size, classes=[class_id], conf=self.confidence,
            max_det=20, device="cpu", verbose=False,
        )[0]
        return [
            {
                "label": target,
                "confidence": round(float(score), 3),
                "box": [round(float(coordinate), 1) for coordinate in box],
            }
            for score, box in zip(result.boxes.conf, result.boxes.xyxy)
        ]

    def ground(self, frame, box):
        import numpy as np
        from ultralytics.models.yolo.yoloe import YOLOEVPSegPredictor

        prompts = {"bboxes": np.asarray([box], dtype=np.float32),
                   "cls": np.zeros(1, dtype=np.int64)}
        self.model.predict(
            frame, refer_image=frame, visual_prompts=prompts,
            predictor=YOLOEVPSegPredictor, imgsz=self.image_size,
            conf=self.confidence, device="cpu", verbose=False,
        )
        self.visual_version = 0
        return self._visual_predictions(frame)

    def detect_visual(self, frame, views, version, refresh=False):
        """Re-detect one visually prompted target from temporary multi-view memory."""
        if self.visual_version is None or (refresh and self.visual_version != version):
            self._prepare_visual(views, version)
        return self._visual_predictions(frame)

    def _prepare_visual(self, views, version):
        import cv2
        import numpy as np
        from ultralytics.models.yolo.yoloe import YOLOEVPSegPredictor

        if not views:
            raise RuntimeError("No temporary target views are available")
        cell, columns = 320, min(2, len(views))
        rows = (len(views)+columns-1)//columns
        reference = np.zeros((rows*cell, columns*cell, 3), dtype=np.uint8)
        boxes = []
        for index, view in enumerate(views[:4]):
            image, box = view["image"], view["box"]
            height, width = image.shape[:2]
            scale = min((cell-16)/width, (cell-16)/height)
            resized = cv2.resize(image, (max(1, round(width*scale)), max(1, round(height*scale))),
                                 interpolation=cv2.INTER_AREA if scale < 1 else cv2.INTER_LINEAR)
            row, column = divmod(index, columns)
            left = column*cell+(cell-resized.shape[1])//2
            top = row*cell+(cell-resized.shape[0])//2
            reference[top:top+resized.shape[0], left:left+resized.shape[1]] = resized
            boxes.append([left+box[0]*scale, top+box[1]*scale,
                          left+box[2]*scale, top+box[3]*scale])
        prompts = {"bboxes": np.asarray(boxes, dtype=np.float32),
                   "cls": np.zeros(len(boxes), dtype=np.int64)}
        self.model.predict(
            reference, refer_image=reference, visual_prompts=prompts,
            predictor=YOLOEVPSegPredictor, imgsz=self.image_size,
            conf=self.confidence, device="cpu", verbose=False,
        )
        self.visual_version = version

    def _visual_predictions(self, frame):
        result = self.model.predict(
            frame, imgsz=self.image_size, conf=self.confidence,
            max_det=20, device="cpu", verbose=False,
        )[0]
        return [
            {
                "label": "visually prompted object",
                "confidence": round(float(score), 3),
                "box": [round(float(coordinate), 1) for coordinate in candidate],
            }
            for score, candidate in zip(result.boxes.conf, result.boxes.xyxy)
        ]
