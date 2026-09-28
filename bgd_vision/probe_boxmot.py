"""Offline BoxMOT 25 comparison; run with its isolated directory on PYTHONPATH."""

import json


def main():
    import numpy as np
    import torch
    import boxmot
    from boxmot import DeepOcSort
    from boxmot.structures import Boxes, Detections

    frame = np.zeros((480, 640, 3), dtype=np.uint8)
    sample = 0

    def tracker():
        return DeepOcSort(cmc_off=True, use_embeddings=True, min_hits=1,
                          det_thresh=0.35, max_age=30)

    def run(engine, boxes, features):
        nonlocal sample
        sample += 1
        count = len(boxes)
        detections = Detections(
            geometry=Boxes(torch.tensor(boxes, dtype=torch.float32).reshape(-1, 4)),
            scores=torch.full((count,), .95, dtype=torch.float32),
            class_ids=torch.zeros(count, dtype=torch.int64), sample_id=str(sample),
            embeddings=torch.tensor(features, dtype=torch.float32).reshape(-1, 2))
        output = engine.update(detections, frame)
        return [{"id": int(identity), "person": int(np.argmax(features[int(index)]))}
                for identity, index in zip(output.track_ids.tolist(), output.detection_indices.tolist())]

    engine = tracker()
    initial = run(engine, [(100, 100, 160, 260)], [[1., 0.]])
    for _ in range(3):
        assert run(engine, [], []) == []
    recovered = run(engine, [(100, 100, 160, 260)], [[1., 0.]])
    occlusion_ok = bool(recovered and recovered[0]["id"] == initial[0]["id"])

    engine = tracker()
    initial = run(engine, [(100, 100, 160, 260)], [[1., 0.]])
    wrong = run(engine, [(100, 100, 160, 260)], [[0., 1.]])
    wrong_id = bool(wrong and wrong[0]["id"] == initial[0]["id"])

    engine = tracker()
    identity_by_person = None
    consistent = True
    trace = []
    for step in range(17):
        positions = (80 + step*8, 240-step*8)
        visible = [1] if 8 <= step <= 10 else [0, 1]
        output = run(engine, [(positions[i], 100, positions[i]+60, 260) for i in visible],
                     [[1., 0.] if i == 0 else [0., 1.] for i in visible])
        mapped = {t["person"]: t["id"] for t in output}
        if identity_by_person is None:
            identity_by_person = mapped
        consistent &= all(identity_by_person[i] == identity for i, identity in mapped.items())
        trace.append({"step": step, "identities": mapped})
    consistent &= set(mapped) == {0, 1}
    print(json.dumps({"boxmot_version": boxmot.__version__,
                      "three_empty_frames_same_person_recovers": occlusion_ok,
                      "synthetic_crossing_ids_consistent": bool(consistent),
                      "wrong_appearance_same_position_keeps_id": wrong_id,
                      "crossing_trace": trace,
                      "qualification": "Synthetic embeddings only; no real identity accuracy claim."}))


if __name__ == "__main__":
    main()
