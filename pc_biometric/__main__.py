"""Launch with python -m pc_biometric; --check prints the same local readiness."""

import argparse
import os
from pathlib import Path
from threading import Event

from .workflow import DeskWorkflow


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--models", type=Path,
                        default=Path(os.environ.get("LOCALAPPDATA", str(Path.home()))) / "BGD/PCBiometricDesk/models",
                        help="Local installed-model directory; never downloaded or created by readiness")
    parser.add_argument("--check", action="store_true", help="Print readiness without opening the desktop UI")
    parser.add_argument("--enrollment-delete-after", metavar="YYYY-MM-DD",
                        help="Enable one real enrollment session with this agreed deletion date")
    parser.add_argument("--verification-session", action="store_true",
                        help="Enable deliberate development checks after agreeing an owner capture session")
    parser.add_argument("--verification-diagnostics", action="store_true",
                        help="Show memory-only per-channel scores and capture diagnostics in a consented session")
    parser.add_argument("--voice-consistency-study", action="store_true",
                        help="Compare three temporary voice signatures; never authorize an action")
    parser.add_argument("--microphone", type=int, help="Explicit PortAudio input index for verification/study")
    args = parser.parse_args()
    if args.verification_diagnostics and not args.verification_session:
        parser.error("--verification-diagnostics requires --verification-session")
    if args.microphone is not None and (args.microphone < 0 or not args.verification_session):
        parser.error("--microphone requires a nonnegative index and --verification-session")
    if args.voice_consistency_study and (not args.verification_diagnostics or args.microphone is None
                                         or args.enrollment_delete_after is not None):
        parser.error("Voice study requires verification diagnostics and an explicit microphone, without enrollment")
    from .authority import is_elevated
    if is_elevated():
        print("Normal B.G.D operation must be unelevated. Close this process and launch normally. "
              "Use the separate authority installer only for administrator setup.")
        return 2
    workflow = DeskWorkflow(args.models)
    if args.check:
        report = workflow.refresh()
        for check in report.checks:
            print(f"{check.group} / {check.name}: {check.state} — {check.detail}")
        print("Capture off. No authorization. Development build; biometric security not accepted.")
        return 1 if any(check.state in {"Missing", "Failed"} for check in report.checks) else 0
    import tkinter as tk
    from .capture import EnrollmentCapture
    from .enrollment import Enrollment
    from .verification import Verification
    from .windows import SessionGuard, WindowsVerification, current_account, top_level_window
    from .ui import DeskApp, enrollment_session_terms
    root = tk.Tk()
    app = DeskApp(root, workflow)
    root.update_idletasks()
    cancelled = Event()
    hwnd = top_level_window(root.winfo_id())
    verification = WindowsVerification(hwnd, cancelled)
    capture = EnrollmentCapture(args.models, cancelled, app.report_stage, preview=app.report_preview,
                                feedback=app.report_feedback, voice_control=app.report_voice_state,
                                diagnostic=app.report_diagnostic)
    data_root = Path(os.environ.get("LOCALAPPDATA", str(Path.home()))) / "BGD/PCBiometricDesk/profile"
    def interrupted() -> None:
        root.after(0, app.session_interrupted)

    guard = SessionGuard(hwnd, cancelled, interrupted)
    app.on_close(guard.close)
    terms = None
    if args.enrollment_delete_after is not None:
        try:
            terms = enrollment_session_terms(args.enrollment_delete_after)
        except ValueError as error:
            parser.error(str(error))
    app.bind_enrollment(Enrollment(data_root, account=current_account,
                                   verify_windows=verification.verify, capture=capture.capture,
                                   cancelled=cancelled), session_terms=terms)
    app.bind_verification(Verification(data_root, account=current_account,
                                      capture=capture.capture_verification, cancelled=cancelled,
                                      diagnostics=args.verification_diagnostics,
                                      voice_study=args.voice_consistency_study, microphone=args.microphone),
                          session_terms=(
                              "I am the enrolled owner and consent to this local face and voice check. "
                              "Capture stays in memory, accessible to this process and local administrators; "
                              "raw media is discarded when the check ends. "
                              + ("This is a three-sample diagnostic study, never an authorization check. "
                                 "Up to three temporary voice signatures and comparison scores stay in memory "
                                 "across samples for at most five minutes from the first sample. "
                                 "Signatures are discarded after sample three, cancellation, navigation, "
                                 "Windows interruption or app close. Final scores remain in the displayed report. "
                                 if args.voice_consistency_study else
                                 "Derived check vectors are discarded when the check ends. ") +
                              "No test recordings or new references are saved to disk; my encrypted profile is unchanged. "
                              "This developmental result has no security or aircraft authority."
                              + (" Per-channel scores, device details and quality/timing measurements will be shown "
                                 "in memory until the next check, navigation, interruption or app close; "
                                 "no diagnostic file is saved." if args.verification_diagnostics else "")
                              if args.verification_session else None))
    root.mainloop()
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
