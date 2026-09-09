"""Explicit, consented Windows dialog check; never run by ordinary discovery.

Run `python tests/windows_verification_validation.py cancel` and then `verify`.
Interact only with the real Windows dialog. B.G.D capture/enrollment stays off.
No network configuration is changed; this alone does not prove offline operation.
The Boolean False proves non-verification only; cancellation needs the operator's
separate confirmation that they selected Cancel in the Windows dialog.
"""

from ctypes import wintypes as wt
import json
from pathlib import Path
from queue import Empty, SimpleQueue
import sys
from threading import Event, Thread
import time
import tkinter as tk
from tkinter import ttk

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from pc_biometric.authority import is_elevated
from pc_biometric.windows import WindowsVerification, _api, current_account


def main():
    if len(sys.argv) != 2 or sys.argv[1] not in ("cancel", "verify"):
        raise SystemExit("Usage: python tests/windows_verification_validation.py cancel|verify")
    if is_elevated():
        raise SystemExit("Start this test unelevated.")
    phase = sys.argv[1]
    account = current_account()
    cancelled = Event()
    results = SimpleQueue()
    exit_code = 1
    root = tk.Tk()
    root.title("B.G.D — Windows verification test only")
    root.geometry("640x280")
    panel = ttk.Frame(root, padding=24)
    panel.pack(fill="both", expand=True)
    instruction = ("Choose Cancel in the real Windows dialog. Do not authenticate. "
                   "If Windows Hello recognizes you immediately, look away from its camera before starting."
                   if phase == "cancel" else
                   "Complete the real Windows dialog using your configured sign-in method.")
    ttk.Label(panel, text=instruction, wraplength=585).pack(anchor="w", pady=(0, 16))
    ttk.Label(panel, text="This is an adapter test, not enrollment. No B.G.D camera or microphone "
              "capture, profile, recovery code or action authorization. Windows may use its own "
              "configured sign-in camera. Enter credentials only in the Windows dialog.",
              wraplength=585).pack(anchor="w", pady=(0, 16))
    status = ttk.Label(panel, text="Ready. Use the button below to open the Windows dialog.", wraplength=585)
    status.pack(anchor="w")
    root.update_idletasks()
    hwnd = _api("user32", "GetAncestor", wt.HWND, wt.HWND, wt.UINT)(root.winfo_id(), 2)
    if not hwnd:
        root.destroy()
        raise SystemExit("Cannot identify the test window.")

    def verify():
        started = time.monotonic()
        try:
            verified = WindowsVerification(hwnd, cancelled).verify()
            unchanged = current_account() == account
            result = {"phase": phase, "verified": verified, "account_unchanged": unchanged,
                      "unelevated": not is_elevated(), "elapsed_seconds": round(time.monotonic() - started, 3)}
        except Exception:
            result = {"phase": phase, "error": "Windows verification unavailable"}
        results.put(result)

    def close():
        cancelled.set()
        root.destroy()

    def poll():
        nonlocal exit_code
        try:
            result = results.get_nowait()
        except Empty:
            root.after(50, poll)
            return
        root.after_cancel(timeout_id)
        matched = (result.get("verified") is (phase == "verify")
                   and result.get("account_unchanged") is True
                   and result.get("unelevated") is True and not cancelled.is_set())
        result["expected_boolean_observed"] = matched
        if phase == "cancel":
            result["native_cancellation_reason"] = "not exposed by Boolean adapter"
        print(json.dumps(result), flush=True)
        exit_code = 0 if matched else 1
        status.configure(text=("Expected Boolean observed. No enrollment or action authorized."
                               if matched else "Expected Boolean NOT observed. No enrollment or action authorized."))
        root.after(1500, close)

    def timeout():
        nonlocal exit_code
        exit_code = 1
        print(json.dumps({"phase": phase, "error": "Test timed out; no pass claimed"}), flush=True)
        close()

    def start():
        start_button.state(["disabled"])
        status.configure(text="Waiting for the real Windows dialog…")
        Thread(target=verify, daemon=True).start()

    start_button = ttk.Button(panel, text="Open Windows dialog", command=start)
    start_button.pack(anchor="w", pady=(12, 0))

    root.protocol("WM_DELETE_WINDOW", close)
    timeout_id = root.after(180000, timeout)
    root.after(50, poll)
    root.lift()
    root.mainloop()
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
