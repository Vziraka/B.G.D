"""Explicit real face-capture validation; never run by automated discovery."""

import argparse
import hashlib
import importlib
import os
from pathlib import Path
from threading import Event, Thread
import tkinter as tk
from tkinter import ttk

from pc_biometric.authority import RegistryAuthority, is_elevated
from pc_biometric.capture import CaptureError, CaptureFeedback, EnrollmentCapture
from pc_biometric.ui import DeskApp
from pc_biometric.workflow import DeskWorkflow, all_models_valid


RAW_SUFFIXES = {".avi", ".jpeg", ".jpg", ".m4a", ".mov", ".mp3", ".mp4", ".pcm", ".png", ".wav"}
APP_SHUTDOWN_TIMEOUT = 15  # Allows the readiness probe's bounded 12-second Windows timeout plus cleanup.


def tree_snapshot(root: Path) -> dict[str, str]:
    if not root.exists():
        return {}
    result = {}
    for path in sorted(item for item in root.rglob("*") if item.is_file()):
        with path.open("rb") as stream:
            result[path.relative_to(root).as_posix()] = hashlib.file_digest(stream, "sha256").hexdigest()
    return result


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--models", required=True, type=Path)
    args = parser.parse_args()
    if is_elevated():
        print("passed=False elevated=True")
        return 2
    if not all_models_valid(args.models):
        print("passed=False models_ready=False camera_opened=False")
        return 1

    local = Path(os.environ.get("LOCALAPPDATA", str(Path.home()))) / "BGD/PCBiometricDesk"
    profile_root, diagnostic_root = local / "profile", local / "diagnostics"
    try:
        before_profile = tree_snapshot(profile_root)
        before_diagnostics = tree_snapshot(diagnostic_root)
        before_authority = RegistryAuthority().read()
    except Exception:
        print("passed=False preservation_snapshot_ready=False camera_opened=False")
        return 1

    root = None
    app = None
    worker = None
    cancelled, face_complete, finished = Event(), Event(), Event()
    preview_seen, rejection_seen, worker_failed = Event(), Event(), Event()
    landmark_frames = 0
    operator_confirmed = False
    app_cleanup_ok = True

    try:
        root = tk.Tk()
        app = DeskApp(root, DeskWorkflow(args.models))
        landmark_confirmed = tk.BooleanVar(value=False)

        def stage(value: str) -> None:
            if value == "voice":
                face_complete.set()
                cancelled.set()  # No acknowledgement: the child cannot enter microphone capture.
                return
            app.report_stage(value)

        def preview(value: bytes) -> None:
            nonlocal landmark_frames
            preview_seen.set()
            cv2 = importlib.import_module("cv2")
            numpy = importlib.import_module("numpy")
            image = cv2.imdecode(numpy.frombuffer(value, dtype="uint8"), cv2.IMREAD_COLOR)
            if image is not None:
                difference = numpy.abs(image.astype("int16") - numpy.array([135, 220, 170]))
                if int(numpy.all(difference <= 12, axis=2).sum()) >= 15:
                    landmark_frames += 1
            app.report_preview(value)

        def feedback(value: CaptureFeedback) -> None:
            if not value.message.startswith(("Hold still", "Capturing clear")):
                rejection_seen.set()
            app.report_feedback(value)

        capture = EnrollmentCapture(args.models, cancelled, stage, preview=preview, feedback=feedback)

        def run_capture() -> None:
            try:
                capture.capture()
            except CaptureError:
                pass
            except Exception:
                worker_failed.set()
            finally:
                finished.set()

        def start() -> None:
            nonlocal worker
            start_button.state(["disabled"])
            app.setup_active = True
            app.task_detail.configure(
                text="Begin out of frame or too far away to observe rejection guidance. Then center one "
                     "well-lit face, look forward and hold still. Eight samples capture automatically; "
                     "do not click a shutter.")
            worker = Thread(target=run_capture, daemon=True)
            worker.start()

        def close() -> None:
            nonlocal operator_confirmed, app_cleanup_ok
            if finished.is_set():
                operator_confirmed = bool(landmark_confirmed.get())
            cancelled.set()
            app_cleanup_ok = app.wait_for_workers(APP_SHUTDOWN_TIMEOUT)
            app.close()

        def poll() -> None:
            if not finished.is_set():
                root.after(50, poll)
                return
            app._clear_preview()
            app.capture_label.configure(text="Camera off\nMicrophone off")
            app.task_detail.configure(
                text="Face capture ended. Confirm only if you personally saw the dots follow your facial "
                     "features. Then choose Confirm and close; no profile will be written.")
            landmark_check.pack(anchor="w", pady=(6, 12))
            start_button.configure(text="Confirm and close", command=close)
            start_button.state(["!disabled"])

        app.show("Setup")
        app.title.configure(text="Real face capture validation")
        app.task_detail.configure(text="Camera remains off until Start. This validation writes no profile or raw media.")
        app.action_button.pack_forget()
        app.consent_check.pack_forget()
        landmark_check = ttk.Checkbutton(app.main, variable=landmark_confirmed,
                                         text="I saw the landmark dots track my facial features.")
        start_button = ttk.Button(app.main, text="Start face validation", command=start)
        start_button.pack(anchor="w", pady=12)
        root.protocol("WM_DELETE_WINDOW", close)
        root.after(50, poll)
        root.mainloop()
    except Exception:
        worker_failed.set()
    finally:
        cancelled.set()
        if worker is not None:
            worker.join(APP_SHUTDOWN_TIMEOUT)
        if app is not None:
            if not app.closed:
                try:
                    app_cleanup_ok = app.wait_for_workers(APP_SHUTDOWN_TIMEOUT) and app_cleanup_ok
                    app.close()
                except Exception:
                    app_cleanup_ok = False
        elif root is not None:
            try:
                root.destroy()
            except Exception:
                app_cleanup_ok = False

    capture_cleanup_ok = worker is None or not worker.is_alive()
    try:
        after_profile = tree_snapshot(profile_root)
        after_diagnostics = tree_snapshot(diagnostic_root)
        state_unchanged = (after_profile == before_profile and after_diagnostics == before_diagnostics
                           and RegistryAuthority().read() == before_authority)
        new_files = set(after_profile) - set(before_profile) | set(after_diagnostics) - set(before_diagnostics)
        raw_media_created = any(Path(name).suffix.casefold() in RAW_SUFFIXES for name in new_files)
    except Exception:
        state_unchanged, raw_media_created = False, True
    passed = (face_complete.is_set() and preview_seen.is_set() and rejection_seen.is_set()
              and landmark_frames >= 3 and operator_confirmed and not worker_failed.is_set()
              and capture_cleanup_ok and app_cleanup_ok and state_unchanged and not raw_media_created)
    print(f"passed={passed} face_complete={face_complete.is_set()} preview_seen={preview_seen.is_set()} "
          f"overlay_frames={landmark_frames >= 3} operator_landmark_confirmation={operator_confirmed} "
          f"rejection_guidance={rejection_seen.is_set()} microphone_stage_acknowledged=False "
          f"storage_unchanged={state_unchanged} raw_media_created={raw_media_created} "
          f"cleanup_ok={capture_cleanup_ok and app_cleanup_ok}")
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
