"""Reuse BoxMOT 25 Deep OC-SORT; selected-person confirmation stays separate."""


class PersonTracker:
    """One detector result and one appearance pass per frame, including empty frames."""

    def __init__(self, appearance_encoder):
        import boxmot
        from boxmot import DeepOcSort

        if boxmot.__version__ != "25.0.0":
            raise RuntimeError("PersonTracker requires the verified BoxMOT 25.0.0 API")
        self.tracker = DeepOcSort(cmc_off=True, use_embeddings=True, min_hits=1,
                                 det_thresh=0.35, max_age=30)
        self.appearance_encoder = appearance_encoder
        self.sequence = 0
        self.feature_size = 512

    def update(self, result, frame):
        import numpy as np
        import torch
        from boxmot.structures import Boxes, Detections

        boxes = result.boxes.cpu().numpy() if result.boxes is not None else None
        detections = ([] if boxes is None else
                      [{"box": box.tolist(), "confidence": float(score)}
                       for box, score in zip(boxes.xyxy, boxes.conf)])
        self.appearance_encoder.encode(frame, detections)
        # Invalid crops cannot support person association. Advance with the remaining
        # observations (possibly empty), preserving their descriptor-row alignment.
        detections = [d for d in detections if d.get("appearance") is not None
                      and np.isfinite(d["appearance"]).all() and np.linalg.norm(d["appearance"]) > 0]
        count = len(detections)
        if count:
            self.feature_size = len(detections[0]["appearance"])
        self.sequence += 1
        batch = Detections(
            geometry=Boxes(torch.tensor([d["box"] for d in detections], dtype=torch.float32).reshape(-1, 4)),
            scores=torch.tensor([d["confidence"] for d in detections], dtype=torch.float32),
            class_ids=torch.zeros(count, dtype=torch.int64), sample_id=str(self.sequence),
            embeddings=(torch.tensor([d["appearance"] for d in detections], dtype=torch.float32)
                        if count else torch.empty((0, self.feature_size), dtype=torch.float32)))
        rows = self.tracker.update(batch, frame)
        tracks = []
        for box, identity, score, index in zip(rows.geometry.values.tolist(), rows.track_ids.tolist(),
                                              rows.scores.tolist(), rows.detection_indices.tolist()):
            if not 0 <= index < len(detections):
                raise RuntimeError("Tracker returned an invalid detection index")
            tracks.append({"id": int(identity), "box": [round(float(v), 1) for v in box],
                           "confidence": round(float(score), 3),
                           "appearance": detections[index].get("appearance")})
        return tracks


def association_probe():
    """Synthetic integration evidence; does not qualify real appearance or identity."""
    import json
    from types import SimpleNamespace
    import numpy as np
    from ultralytics.engine.results import Boxes

    class FakeEncoder:
        features = []

        def encode(self, _frame, tracks):
            assert len(tracks) == len(self.features)
            for track, feature in zip(tracks, self.features):
                track["appearance"] = feature

    encoder = FakeEncoder()
    frame = np.zeros((480, 640, 3), dtype=np.uint8)

    def run(tracker, boxes, features):
        encoder.features = features
        data = np.asarray([list(box) + [0.95, 0] for box in boxes], dtype=np.float32).reshape(-1, 6)
        result = SimpleNamespace(boxes=Boxes(data, frame.shape[:2]))
        return tracker.update(result, frame)

    tracker = PersonTracker(encoder)
    initial = run(tracker, [(100, 100, 160, 260)], [[1.0, 0.0]])
    original_id = initial[0]["id"]
    for _ in range(3):
        assert run(tracker, [], []) == []
    recovered = run(tracker, [(100, 100, 160, 260)], [[1.0, 0.0]])
    occlusion_ok = bool(recovered and recovered[0]["id"] == original_id)
    assert occlusion_ok, "Same-position matching person failed three-frame occlusion recovery"

    tracker = PersonTracker(encoder)
    initial = run(tracker, [(100, 100, 160, 260)], [[1.0, 0.0]])
    wrong = run(tracker, [(100, 100, 160, 260)], [[0.0, 1.0]])
    wrong_same_id = bool(wrong and wrong[0]["id"] == initial[0]["id"])

    tracker = PersonTracker(encoder)
    identity_by_person = None
    crossing_consistent = True
    for step in range(17):
        positions = (80 + step * 8, 240 - step * 8)
        # One person is completely occluded around the crossing; detection index changes.
        visible = [1] if 8 <= step <= 10 else [0, 1]
        output = run(tracker, [(positions[i], 100, positions[i]+60, 260) for i in visible],
                     [[1.0, 0.0] if i == 0 else [0.0, 1.0] for i in visible])
        mapped = {int(np.argmax(track["appearance"])): track["id"] for track in output}
        if identity_by_person is None:
            identity_by_person = mapped
        crossing_consistent &= all(identity_by_person[i] == identity for i, identity in mapped.items())
    crossing_consistent &= set(mapped) == {0, 1}
    assert crossing_consistent, "Crossing changed identities or failed to return both people"
    tracker = PersonTracker(encoder)
    valid = run(tracker, [(20, 20, 40, 60), (100, 100, 160, 260)], [None, [0.0, 1.0]])
    assert len(valid) == 1 and valid[0]["appearance"] == [0.0, 1.0]
    assert run(tracker, [(100, 100, 160, 260)], [[float("nan"), 0.0]]) == []
    report = {"three_empty_frames_same_person_recovers": occlusion_ok,
              "synthetic_crossing_ids_consistent": bool(crossing_consistent),
              "wrong_appearance_same_position_keeps_id": wrong_same_id,
              "invalid_descriptors_filtered_with_aligned_indices": True,
              "qualification": "Synthetic association only; wrong-ID reuse requires separate target veto."}
    print(json.dumps(report))
    return report


if __name__ == "__main__":
    association_probe()
