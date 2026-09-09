"""Explicit real lock validation; not run by ordinary test discovery."""

import ctypes
from ctypes import wintypes
import os
from pathlib import Path
from queue import Empty, SimpleQueue
import tempfile
from threading import Event, Thread
import time
import tkinter as tk
from tkinter import ttk
import sys
import winreg
from uuid import uuid4

from pc_biometric.authority import RegistryAuthority, is_elevated
from pc_biometric.enrollment import Enrollment, EnrollmentResult, References
from pc_biometric.windows import SessionGuard, current_account, top_level_window


def different_console_session(active: int, own: int) -> bool:
    active &= 0xFFFFFFFF
    return active != 0xFFFFFFFF and active != own


def write_report(path: Path, report: str) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    pending = path.with_suffix(".pending")
    pending.write_text(report + "\n", encoding="utf-8")
    os.replace(pending, path)


def main() -> int:
    switch_mode = sys.argv[1:] == ["switch"]
    if sys.argv[1:] and not switch_mode:
        print("passed=False invalid_mode=True")
        return 2
    report_path = (Path(__file__).resolve().parents[1] / ".scratch" / "pc-biometric-desk"
                   / "validation" / "session-switch-result.txt")
    if switch_mode:
        try:
            write_report(report_path, "passed=False mode=switch complete=False")
        except OSError:
            print("passed=False mode=switch report_ready=False")
            return 2
    if is_elevated():
        print("passed=False elevated=True")
        return 2
    key = rf"Software\BGD.Tests.SessionLock.{uuid4().hex}"
    authority = RegistryAuthority(key=key, hive=winreg.HKEY_CURRENT_USER)
    temporary = None
    root = None
    guard = None
    workers: list[Thread] = []
    cancelled, capture_entered, interrupted, terminal = Event(), Event(), Event(), Event()
    switch_ready, switch_observed, disconnect_cancelled = Event(), Event(), Event()
    results: SimpleQueue[EnrollmentResult] = SimpleQueue()
    lock_requested = False
    fixture_committed = False
    cleanup_ok = True
    passed = False

    def stop() -> None:
        cancelled.set()
        terminal.set()

    def callback_error(*_args: object) -> None:
        stop()

    def capture() -> References:
        capture_entered.set()
        cancelled.wait()
        return References(b"synthetic-face", b"synthetic-voice")

    try:
        temporary = tempfile.TemporaryDirectory()
        root = tk.Tk()
        root.title("B.G.D Ticket 02 — " + ("account-switch" if switch_mode else "workstation-lock")
                   + " validation")
        root.geometry("600x270")
        root.lift()
        root.attributes("-topmost", True)
        root.after(750, lambda: root.attributes("-topmost", False))
        root.report_callback_exception = callback_error
        root.protocol("WM_DELETE_WINDOW", stop)
        frame = ttk.Frame(root, padding=24)
        frame.pack(fill="both", expand=True)
        heading = "Real Windows account-switch interruption" if switch_mode else "Real workstation-lock interruption"
        ttk.Label(frame, text=heading, font=("Segoe UI", 18, "bold")).pack(anchor="w")
        status = ttk.Label(frame, wraplength=540,
                           text=("Synthetic references only. Start, then switch to another existing account and back. "
                                 "No camera or microphone." if switch_mode else
                                 "Synthetic references only. Start locks Windows; unlock normally. No camera or microphone."))
        status.pack(anchor="w", pady=18)
        button = ttk.Button(frame, text="Start " + ("account-switch" if switch_mode else "lock") + " validation")
        button.pack(anchor="w")
        root.update_idletasks()
        authority.install(current_account())
        enrollment = Enrollment(Path(temporary.name), account=current_account,
                                verify_windows=lambda: True, capture=capture,
                                cancelled=cancelled, authority=authority)
        class ValidationGuard(SessionGuard):
            def dispatch(self, message: int, reason: int) -> None:
                if switch_mode and message == 0x02B1 and reason == 0x7:  # Ignore lock for causal isolation.
                    return
                before = cancelled.is_set()
                super().dispatch(message, reason)
                if (switch_mode and message == 0x02B1 and reason == 0x2  # WTS_CONSOLE_DISCONNECT
                        and not before and cancelled.is_set() and interrupted.is_set()):
                    disconnect_cancelled.set()

        guard = ValidationGuard(top_level_window(root.winfo_id()), cancelled, interrupted.set)

        own_session = wintypes.DWORD()
        if switch_mode and not ctypes.windll.kernel32.ProcessIdToSessionId(os.getpid(),
                                                                         ctypes.byref(own_session)):
            raise OSError("Windows session identity is unavailable.")

        def observe_switch() -> None:
            while not terminal.is_set() and not switch_observed.is_set():
                active = int(ctypes.windll.kernel32.WTSGetActiveConsoleSessionId())
                if different_console_session(active, own_session.value):
                    switch_observed.set()
                    return
                terminal.wait(.05)

        def start() -> None:
            button.state(["disabled"])
            if not enrollment.rearm():
                stop()
                return
            interrupted.clear()
            status.configure(text="Starting isolated pending setup…")
            worker = Thread(target=lambda: results.put(enrollment.start(consented=True)), daemon=True)
            workers.append(worker)
            worker.start()
            ready_deadline = time.monotonic() + 3

            def poll_capture() -> None:
                nonlocal lock_requested
                if terminal.is_set():
                    return
                if capture_entered.is_set():
                    interrupted.clear()
                    if switch_mode:
                        status.configure(text="Ready. Press Ctrl+Alt+Delete, choose Switch user (not Lock), "
                                              "sign into the other account, then switch back.")
                        switch_ready.set()
                        monitor = Thread(target=observe_switch, daemon=True)
                        workers.append(monitor)
                        monitor.start()
                    else:
                        status.configure(text="Locking now. Unlock Windows normally.")
                        root.update_idletasks()
                        lock_requested = bool(ctypes.windll.user32.LockWorkStation())
                        if not lock_requested:
                            stop()
                elif time.monotonic() >= ready_deadline:
                    stop()
                else:
                    root.after(20, poll_capture)

            root.after(20, poll_capture)

        button.configure(command=start)
        deadline = time.monotonic() + (300 if switch_mode else 120)
        result = None
        while time.monotonic() < deadline and not terminal.is_set():
            root.update()
            if result is None:
                try:
                    result = results.get_nowait()
                except Empty:
                    pass
            if result is not None and (not switch_mode or switch_observed.is_set()):
                break
            time.sleep(.02)
        fixture_committed = bool(authority.read().profile)
        requested = switch_ready.is_set() if switch_mode else lock_requested
        passed = (requested and (switch_observed.is_set() and disconnect_cancelled.is_set()
                                 if switch_mode else True)
                  and result is not None and result.state == "cancelled"
                  and interrupted.is_set() and not fixture_committed
                  and not list(Path(temporary.name).glob("profile-*.bin")))
    except Exception:
        passed = False
    finally:
        stop()
        for worker in workers:
            worker.join(5)
            cleanup_ok = cleanup_ok and not worker.is_alive()
        cleanups = []
        if guard is not None:
            cleanups.append(guard.close)
        if root is not None:
            cleanups.append(root.destroy)
        if temporary is not None:
            cleanups.append(temporary.cleanup)
        cleanups.append(lambda: winreg.DeleteKeyEx(winreg.HKEY_CURRENT_USER, key, winreg.KEY_WOW64_64KEY))
        for cleanup in cleanups:
            try:
                cleanup()
            except FileNotFoundError:
                pass
            except Exception:
                cleanup_ok = False
    passed = passed and cleanup_ok
    report = (f"passed={passed} mode={'switch' if switch_mode else 'lock'} "
              f"action_ready={switch_ready.is_set() if switch_mode else lock_requested} "
              f"account_switched={switch_observed.is_set() if switch_mode else False} "
              f"disconnect_cancelled={disconnect_cancelled.is_set() if switch_mode else False} "
              f"interrupted={interrupted.is_set()} "
              f"cancelled={cancelled.is_set()} fixture_profile_committed={fixture_committed} "
              f"cleanup_ok={cleanup_ok}")
    if switch_mode:
        try:
            write_report(report_path, report + " complete=True")
        except OSError:
            print("passed=False mode=switch report_complete=False")
            return 1
    print(report)
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(main())
