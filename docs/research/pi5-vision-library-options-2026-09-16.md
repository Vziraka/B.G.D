# Pi 5 vision-library options for the Camera Module 3 desk prototype

September 16, 2026. Primary-source review plus a read-only inventory of the owner's Pi. This is a library/options note, **not** a performance qualification, liveness claim, or permission to install every package.

## Bottom line

Yes—there are several established choices. The sensible path is to keep the already-working Raspberry Pi camera stack, then evaluate **one detector + one tracker** at a time. The first practical comparison is:

1. **MediaPipe Object Detector** (with a small compatible `.tflite` model) for the most packaged detector path; Google supplies a Raspberry Pi example and supports live-stream operation. It needs a Pi compatibility/install check first.
2. **OpenCV DNN + an OpenCV Zoo ONNX model** for an explicit, inspectable detector/tracker pipeline. It is the better route when we want control over capture, frame-age measurement, drawing, and later face components, but it needs OpenCV installed and its exact version checked.

Do not start with a full Ultralytics/YOLO or multi-object stack merely because it is popular: that adds heavier dependencies and/or licence decisions before the desk test says they are needed.

## What is actually on this Pi

A non-mutating SSH inventory on the 64-bit Pi (Python 3.13.5) found:

| Component | State | Evidence / implication |
| --- | --- | --- |
| `python3-picamera2` 0.3.37 and `rpicam-apps` 1.13.0 | **Installed** | Keep this capture path. Raspberry Pi documents Picamera2 as the supported Python API for its current camera stack; Camera Module 3's IMX708 is supported by that stack. [Raspberry Pi camera software](https://www.raspberrypi.com/documentation/computers/camera_software.html) |
| Python `cv2` / `python3-opencv` | **Not installed** | Needed for an OpenCV route. Installation and version check come before choosing OpenCV Zoo's newer tracker models. |
| `mediapipe`, `tflite_runtime`, `tensorflow`, `onnxruntime`, `ultralytics`, `supervision` | **Not installed** | Each is an alternative runtime/framework, not a prerequisite. Add only the one selected for a bounded test. |

Picamera2 is BSD-2-Clause. [License](https://github.com/raspberrypi/picamera2/blob/main/LICENSE)

## Established options by job

| Job | Candidate | What it provides | Install/constraint | Licence note |
| --- | --- | --- | --- | --- |
| Camera capture | **Picamera2 / libcamera / rpicam-apps** | Native control of the official CSI camera; Python capture through Picamera2. `rpicam-apps` can also be built with optional OpenCV or TensorFlow Lite stages. | **Installed.** Do not use the retired legacy `picamera`/`raspivid` path. | Picamera2 BSD-2-Clause; Raspberry Pi documents `rpicam-apps` as BSD-2-Clause. [Camera docs](https://www.raspberrypi.com/documentation/computers/camera_software.html) |
| Known-category detection | **MediaPipe Object Detector** | Python task API with `IMAGE`, `VIDEO`, and asynchronous `LIVE_STREAM` modes. The official guide explicitly links a Raspberry Pi example and shows an EfficientDet-Lite0 model. | Needs `mediapipe` plus a task-compatible model; validate an ARM64/Python-3.13 wheel before selecting it. | MediaPipe is Apache-2.0; model licences still need recording. [Official guide](https://developers.google.com/edge/mediapipe/solutions/vision/object_detector/python), [source licence](https://github.com/google-ai-edge/mediapipe/blob/master/LICENSE) |
| Known-category detection / reusable vision plumbing | **OpenCV DNN + OpenCV Zoo** | OpenCV can read ONNX models. The Zoo supplies Python demos and named model files; its YOLOX example is an 80-category COCO detector and includes a `person` category. | Needs OpenCV; model choice must be benchmarked on this Pi. The documented Zoo YOLOX-s requires OpenCV 4.8+, so it is a comparison candidate, not an assumed real-time choice. | OpenCV Apache-2.0; the Zoo YOLOX directory says Apache-2.0. [DNN ONNX API](https://docs.opencv.org/4.x/df/d57/namespacecv_1_1dnn.html), [Zoo YOLOX](https://github.com/opencv/opencv_zoo/tree/main/models/object_detection_yolox), [OpenCV licence](https://github.com/opencv/opencv/blob/4.x/LICENSE) |
| Selected single-target tracking | **OpenCV Zoo ViTTrack** | Tracks one selected box and returns a score that can signal target loss—useful for explicit reacquisition rather than pretending a stale box is valid. | Needs OpenCV newer than 4.8; Zoo's reported speed test uses ONNX Runtime, so measure actual Pi performance rather than importing its Apple-M2 result. | Zoo directory says Apache-2.0. [ViTTrack source/readme](https://github.com/opencv/opencv_zoo/tree/main/models/object_tracking_vittrack) |
| Multiple tracked people / counting | **ByteTrack** | Associates detector boxes into temporary video track IDs; it can consume detections from another detector. | Not for the first single-target test. It needs a detector, task-specific crossing/re-entry rules, and a Pi benchmark. A track ID is not a persistent identity or a correct count after revisiting a scene. | ByteTrack code is MIT; detector/model licences are separate. [Integration API](https://github.com/FoundationVision/ByteTrack#combining-byte-with-other-detectors), [licence](https://github.com/FoundationVision/ByteTrack/blob/main/LICENSE) |
| Larger detector ecosystem | **Ultralytics YOLO** | Broad detection/tracking/export tooling. | Would add its package/model/runtime decisions; defer until the small comparison fails a measured requirement. | Community code is AGPL-3.0; Ultralytics offers a separate enterprise licence. Do not treat it as licence-neutral. [Ultralytics licensing](https://github.com/ultralytics/ultralytics#license) |

## Face, recognition, and liveness are separate work

* **Face detection/feature matching:** OpenCV Zoo has YuNet face detection (MIT) and SFace feature extraction (Apache-2.0); the SFace demo uses YuNet's five landmarks. This is a plausible later compact comparison, not yet installed or tested on the Pi. [YuNet](https://github.com/opencv/opencv_zoo/tree/main/models/face_detection_yunet), [SFace](https://github.com/opencv/opencv_zoo/tree/main/models/face_recognition_sface)
* **Face landmarks:** MediaPipe Face Landmarker reports 3D landmarks, blendshape scores, and transforms from images or a continuous stream. That is useful for framing or challenge-response experiments, but it is not identity recognition or anti-spoof proof. [Official guide](https://developers.google.com/edge/mediapipe/solutions/vision/face_landmarker/python)
* **InsightFace:** its current Python library exposes optional RGB liveness and CPU fallback, but its supplied pretrained models are explicitly non-commercial research only even though the library code is MIT. It is an evaluation-only candidate unless model rights are independently resolved. [Project README](https://github.com/deepinsight/insightface/tree/master/python-package)

No library name establishes liveness. A photo, screen replay, mask, poor lighting, motion blur, an unrecognized person, and a genuine enrolled person must remain separate test cases. The first tracking prototype should therefore contain no face enrollment or permission decision.

## Proposed narrow next experiment

1. Preserve the installed Picamera2 capture path and the existing private stream.
2. Install and pin **only one** candidate runtime after confirming its ARM64/Python-3.13 package compatibility.
3. Run the same fixed-camera, one-person test with a bounded frame queue. Record detector/tracker rate, frame age, target-loss/reacquisition events, temperature, memory, and power flags.
4. Choose the smallest stack that passes those measurements; add ByteTrack, face matching, or liveness only when its distinct test case is scheduled.

This order gives the owner a real comparison without silently turning “live tracking” into a claim of identification, counting, liveness, or flight readiness.
