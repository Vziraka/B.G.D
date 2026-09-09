"""Explicit real voice-capture validation; never run by automated discovery."""

import argparse
import hashlib
import multiprocessing
import os
from pathlib import Path
import re
from threading import Event, Thread
import time
import tkinter as tk
from tkinter import ttk
from typing import Any

from pc_biometric.authority import RegistryAuthority, is_elevated
from pc_biometric.capture import CaptureError, CaptureFeedback, EnrollmentCapture, VoicePrompt
from pc_biometric.ui import DeskApp
from pc_biometric.workflow import DeskWorkflow, all_models_valid


RAW_SUFFIXES = {".avi", ".jpeg", ".jpg", ".m4a", ".mov", ".mp3", ".mp4", ".pcm", ".png", ".wav"}
APP_SHUTDOWN_TIMEOUT = 15
CAPTURE_FAILURES = {
    "Voice models are unavailable.": "models_unavailable",
    "Voice enrollment inactive for too long. Try setup again.": "capture_timeout",
    "Three usable voice takes were not collected. Cancelled or poor samples are not saved.": "attempts_exhausted",
    "Voice reference was invalid.": "reference_invalid",
    "Capture status could not be displayed.": "display_protocol",
    "Capture guidance could not be displayed.": "display_protocol",
    "Voice controls are unavailable.": "display_protocol",
}
REJECTION_REASONS = {
    "Not enough clear speech was detected.": "insufficient_speech",
    "The displayed phrase was not recognized exactly.": "phrase_mismatch",
    "A usable voice signature was not detected.": "signature_unavailable",
    "Audio input was interrupted.": "input_interrupted",
    "Background noise is too high.": "background_noise",
    "Audio is clipping.": "clipping",
    "Voice is too quiet.": "too_quiet",
    "Too much background noise compared with your voice.": "background_noise",
}


def tree_snapshot(root: Path) -> dict[str, str]:
    if not root.exists():
        return {}
    result = {}
    for path in sorted(item for item in root.rglob("*") if item.is_file()):
        with path.open("rb") as stream:
            result[path.relative_to(root).as_posix()] = hashlib.file_digest(stream, "sha256").hexdigest()
    return result


def rejection_reason(message: str) -> str | None:
    """Reduce a displayed fixed guidance line to a non-secret category."""
    guidance = message.rsplit("\n", 1)[-1]
    for prefix, reason in REJECTION_REASONS.items():
        if guidance.startswith(prefix):
            return reason
    return None


def voice_child(models: str, connection: Any) -> None:
    """Run only the production voice routine in a disposable child process."""
    def stage(value: str) -> None:
        connection.send(("stage", value))
        if value != "idle" and connection.recv() != "displayed":
            raise CaptureError("Capture status could not be displayed.")

    def feedback(value: CaptureFeedback) -> None:
        connection.send(("feedback", value))
        if connection.recv() != "displayed":
            raise CaptureError("Capture guidance could not be displayed.")

    def voice_control(value: VoicePrompt) -> str:
        connection.send(("voice_control", value))
        action = connection.recv()
        if not isinstance(action, str):
            raise CaptureError("Voice controls are unavailable.")
        return action

    try:
        capture = EnrollmentCapture(Path(models), Event(), stage, feedback=feedback,
                                    voice_control=voice_control, isolated=False)
        capture._voice()  # Validation-only entry: avoids opening the camera before the same production routine.
        stage("idle")
        connection.send(("complete", None))
    except CaptureError as error:
        try:
            connection.send(("error", CAPTURE_FAILURES.get(str(error), "capture_error")))
        except (EOFError, OSError):
            pass
    except Exception:
        try:
            connection.send(("error", "device_or_runtime"))
        except (EOFError, OSError):
            pass
    finally:
        connection.close()


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--models", required=True, type=Path)
    args = parser.parse_args()
    if is_elevated():
        print("passed=False elevated=True")
        return 2
    if not all_models_valid(args.models):
        print("passed=False models_ready=False microphone_opened=False")
        return 1

    local = Path(os.environ.get("LOCALAPPDATA", str(Path.home()))) / "BGD/PCBiometricDesk"
    profile_root, diagnostic_root = local / "profile", local / "diagnostics"
    try:
        before_profile = tree_snapshot(profile_root)
        before_diagnostics = tree_snapshot(diagnostic_root)
        before_authority = RegistryAuthority().read()
    except Exception:
        print("passed=False preservation_snapshot_ready=False microphone_opened=False")
        return 1

    root = None
    app = None
    worker = None
    cancelled, finished = Event(), Event()
    child_stopped = Event()
    microphone_seen, camera_seen, waveform_seen, playback_seen = Event(), Event(), Event(), Event()
    rejection_seen, submitted_rejection_seen, worker_failed = Event(), Event(), Event()
    child_error, cancelled_or_timeout, protocol_error, unexpected_error = Event(), Event(), Event(), Event()
    cleanup_error = Event()
    child_failure = ["none"]
    prompt_takes: set[int] = set()
    accepted_takes: set[int] = set()
    rejection_reasons: set[str] = set()
    last_feedback_reason: list[str | None] = [None]
    operator_confirmed = False
    operator_playback_confirmed = False
    app_cleanup_ok = True

    try:
        root = tk.Tk()
        app = DeskApp(root, DeskWorkflow(args.models))
        waveform_confirmed = tk.BooleanVar(value=False)
        playback_confirmed = tk.BooleanVar(value=False)

        def run_voice() -> None:
            parent: Any | None = None
            child: Any | None = None
            process: Any | None = None
            try:
                context = multiprocessing.get_context("spawn")
                parent, child = context.Pipe(duplex=True)
                process = context.Process(target=voice_child, args=(str(args.models), child), daemon=True)
                process.start()
                child.close()
                child = None
                deadline = time.monotonic() + 300
                while process.is_alive() or parent.poll():
                    if cancelled.is_set() or time.monotonic() >= deadline:
                        cancelled_or_timeout.set()
                        raise CaptureError("Voice validation cancelled or timed out.")
                    if not parent.poll(0.025):
                        continue
                    kind, value = parent.recv()
                    if kind == "stage":
                        stage = str(value)
                        if stage == "face":
                            camera_seen.set()
                        if stage == "voice":
                            microphone_seen.set()
                        app.report_stage(stage)
                        if stage != "idle":
                            parent.send("displayed")
                    elif kind == "feedback" and isinstance(value, CaptureFeedback):
                        if value.waveform:
                            waveform_seen.set()
                        prompt = re.match(r'^Take ([123])/3 .*Read:', value.message)
                        accepted = re.match(r'^Take ([123])/3 accepted', value.message)
                        if prompt:
                            prompt_takes.add(int(prompt.group(1)))
                        if accepted:
                            accepted_takes.add(int(accepted.group(1)))
                        reason = rejection_reason(value.message)
                        last_feedback_reason[0] = reason
                        if reason is not None:
                            rejection_reasons.add(reason)
                        if reason is not None:
                            rejection_seen.set()
                        app.report_feedback(value)
                        parent.send("displayed")
                    elif kind == "voice_control" and isinstance(value, VoicePrompt):
                        if (value.state in {"rejected", "failed"}
                                and last_feedback_reason[0] is not None):
                            submitted_rejection_seen.set()
                        action = app.report_voice_state(value)
                        if action == "playback":
                            playback_seen.set()
                        parent.send(action)
                        if action in {"cancel", "timeout"}:
                            cancelled_or_timeout.set()
                            raise CaptureError("Voice validation cancelled or timed out.")
                    elif kind == "complete":
                        process.join(1)
                        return
                    elif kind == "error":
                        allowed = set(CAPTURE_FAILURES.values()) | {"capture_error", "device_or_runtime"}
                        child_failure[0] = value if isinstance(value, str) and value in allowed else "capture_error"
                        child_error.set()
                        raise CaptureError("Local voice validation failed.")
                    else:
                        protocol_error.set()
                        raise CaptureError("Local voice validation failed.")
                protocol_error.set()
                raise CaptureError("Local voice validation failed.")
            except Exception:
                if not any(event.is_set() for event in (child_error, cancelled_or_timeout, protocol_error)):
                    unexpected_error.set()
                worker_failed.set()
            finally:
                for connection in (child, parent):
                    try:
                        if connection is not None:
                            connection.close()
                    except Exception:
                        cleanup_error.set()
                        worker_failed.set()
                stopped = process is None
                try:
                    if process is not None and process.is_alive():
                        process.terminate()
                        process.join(2)
                    if process is not None and process.is_alive():
                        process.kill()
                        process.join(2)
                    stopped = process is None or not process.is_alive()
                    if process is not None and stopped:
                        process.close()
                except Exception:
                    cleanup_error.set()
                    worker_failed.set()
                if stopped:
                    child_stopped.set()
                else:
                    cleanup_error.set()
                    worker_failed.set()
                try:
                    app.report_stage("idle")
                except Exception:
                    pass
                finished.set()

        def start() -> None:
            nonlocal worker
            start_button.state(["disabled"])
            app.setup_active = True
            app.task_detail.configure(
                text="Stay silent during each automatic room measurement. For the first phrase, deliberately "
                     "submit one unusable recording, such as silence or a very quiet voice; verify that a "
                     "specific quality reason remains visible, then choose Try again. For each real take, hold Record while "
                     "reading every displayed word exactly once, release, use Play back on at least one real take, then Submit. "
                     "Choose Continue after each accepted take.")
            worker = Thread(target=run_voice, daemon=True)
            worker.start()

        def close() -> None:
            nonlocal operator_confirmed, operator_playback_confirmed, app_cleanup_ok
            if finished.is_set():
                operator_confirmed = bool(waveform_confirmed.get())
                operator_playback_confirmed = bool(playback_confirmed.get())
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
                text="Voice capture ended. Confirm only if you personally saw the waveform react and "
                     "heard the memory-only playback. Then choose Confirm and close; no profile will be written.")
            waveform_check.pack(anchor="w", pady=(6, 12))
            playback_check.pack(anchor="w", pady=(0, 12))
            start_button.configure(text="Confirm and close", command=close)
            start_button.state(["!disabled"])

        app.show("Setup")
        app.title.configure(text="Real voice capture validation")
        app.task_detail.configure(text="Microphone remains off until Start. Camera will stay off. No profile or raw media is written.")
        app.action_button.pack_forget()
        app.consent_check.pack_forget()
        waveform_check = ttk.Checkbutton(app.main, variable=waveform_confirmed,
                                         text="I saw the waveform respond while I spoke.")
        playback_check = ttk.Checkbutton(app.main, variable=playback_confirmed,
                                         text="I used Play back and heard my submitted recording.")
        start_button = ttk.Button(app.main, text="Start voice validation", command=start)
        start_button.pack(anchor="w", pady=12)
        root.protocol("WM_DELETE_WINDOW", close)
        root.after(50, poll)
        root.mainloop()
    except Exception:
        unexpected_error.set()
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
                    cleanup_error.set()
                    app_cleanup_ok = False
        elif root is not None:
            try:
                root.destroy()
            except Exception:
                cleanup_error.set()
                app_cleanup_ok = False

    capture_cleanup_ok = child_stopped.is_set() and (worker is None or not worker.is_alive())
    try:
        after_profile = tree_snapshot(profile_root)
        after_diagnostics = tree_snapshot(diagnostic_root)
        state_unchanged = (after_profile == before_profile and after_diagnostics == before_diagnostics
                           and RegistryAuthority().read() == before_authority)
        new_files = set(after_profile) - set(before_profile) | set(after_diagnostics) - set(before_diagnostics)
        raw_media_created = any(Path(name).suffix.casefold() in RAW_SUFFIXES for name in new_files)
    except Exception:
        state_unchanged, raw_media_created = False, True
    passed = (microphone_seen.is_set() and not camera_seen.is_set() and waveform_seen.is_set()
              and prompt_takes == {1, 2, 3} and accepted_takes == {1, 2, 3}
              and submitted_rejection_seen.is_set() and playback_seen.is_set()
              and operator_confirmed and operator_playback_confirmed
              and not worker_failed.is_set()
              and capture_cleanup_ok and app_cleanup_ok and state_unchanged and not raw_media_created)
    failure_kind = ("child_error" if child_error.is_set() else
                    "cancelled_or_timeout" if cancelled_or_timeout.is_set() else
                    "protocol" if protocol_error.is_set() else
                    "unexpected" if unexpected_error.is_set() else "none")
    reason_summary = ",".join(sorted(rejection_reasons)) or "none"
    print(f"passed={passed} microphone_stage={microphone_seen.is_set()} camera_stage={camera_seen.is_set()} "
          f"waveform_seen={waveform_seen.is_set()} operator_waveform_confirmation={operator_confirmed} "
          f"playback_seen={playback_seen.is_set()} operator_playback_confirmation={operator_playback_confirmed} "
          f"prompt_take_count={len(prompt_takes)} accepted_take_count={len(accepted_takes)} "
          f"rejection_guidance={rejection_seen.is_set()} submitted_rejection={submitted_rejection_seen.is_set()} "
          f"storage_unchanged={state_unchanged} "
          f"raw_media_created={raw_media_created} child_stopped={child_stopped.is_set()} "
          f"wrapper_stopped={worker is None or not worker.is_alive()} ui_cleanup_ok={app_cleanup_ok} "
          f"cleanup_error={cleanup_error.is_set()} failure_kind={failure_kind} "
          f"child_failure={child_failure[0]} rejection_reasons={reason_summary}")
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
