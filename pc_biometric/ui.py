"""UI B: persistent navigation, central task and secondary context. No policy here."""

import base64
import math
from queue import Empty, Full, Queue, SimpleQueue
from collections.abc import Callable
from datetime import date
from functools import partial
from threading import Event, Thread
import time
import tkinter as tk
from tkinter import ttk

from . import __version__
from .enrollment import Enrollment, EnrollmentResult
from .capture import CaptureDiagnostic, CaptureFeedback, ENROLLMENT_PHRASES, VoicePrompt
from .workflow import Check, DeskWorkflow, Readiness
from .verification import Verification, VerificationResult, valid_challenge


def enrollment_session_terms(delete_after: str, *, today: date | None = None) -> str:
    """Build the exact disclosure required to unlock one real enrollment session."""
    try:
        deletion = date.fromisoformat(delete_after)
    except ValueError as error:
        raise ValueError("Deletion date must use YYYY-MM-DD.") from error
    if deletion < (date.today() if today is None else today):
        raise ValueError("Deletion date cannot be in the past.")
    displayed = f"{deletion.strftime('%B')} {deletion.day}, {deletion.year}"
    return ("I consent to one Windows verification and local face/voice capture session. "
            "A memory-only live face preview is cleared when face capture ends or is cancelled; "
            "a memory-only voice recording may be played back before submission and is then discarded; "
            "no raw media files are written. Encrypted references are accessible "
            f"to the current Windows account and local administrators and will be deleted on {displayed}.")


class DeskApp:
    def __init__(self, root: tk.Tk, workflow: DeskWorkflow):
        self.root = root
        self.workflow = workflow
        self.results: SimpleQueue[Readiness] = SimpleQueue()
        self.enrollment_results: SimpleQueue[tuple[int, EnrollmentResult]] = SimpleQueue()
        self.verification_results: SimpleQueue[tuple[int, VerificationResult]] = SimpleQueue()
        self.verification: Verification | None = None
        self.verification_terms: str | None = None
        self.verification_active = False
        self.verification_started = 0.0
        self.verification_elapsed = 0.0
        self.diagnostic_events: Queue[tuple[int, CaptureDiagnostic]] = Queue(maxsize=4)
        self.diagnostic_text = ""
        self.diagnostic_window: tk.Toplevel | None = None
        self.operation_epoch = 0
        self.stages: SimpleQueue[tuple[int, str, Event]] = SimpleQueue()
        self.previews: Queue[tuple[int, bytes, Event]] = Queue(maxsize=1)
        self.feedbacks: Queue[tuple[int, CaptureFeedback, Event]] = Queue(maxsize=1)
        self.voice_states: Queue[tuple[int, VoicePrompt, Event]] = Queue(maxsize=1)
        self.voice_actions: Queue[str] = Queue()
        self.voice_holding = Event()
        self.voice_discard = Event()
        self.voice_mode = "idle"
        self.enrollment: Enrollment | None = None
        self.session_terms: str | None = None
        self.close_callbacks: list[Callable[[], None]] = []
        self.was_interrupted = False
        self.setup_active = False
        self.completing = False
        self.setup_ready = False
        self.current_page = "Readiness"
        self.closed = False
        self.workers: list[Thread] = []
        self.details: dict[str, str] = {}
        root.title("B.G.D — PC Biometric Desk")
        root.geometry("1180x760")
        root.minsize(1040, 700)
        root.configure(background="#edf1ef")
        style = ttk.Style(root)
        style.configure("TFrame", background="#ffffff")
        style.configure("TLabel", background="#ffffff", foreground="#172b2a", font=("Segoe UI", 10))
        style.configure("Heading.TLabel", font=("Segoe UI", 23, "bold"))
        style.configure("Brand.TLabel", font=("Segoe UI", 15, "bold"))
        style.configure("Muted.TLabel", foreground="#536b65")
        style.configure("Phrase.TLabel", font=("Segoe UI", 22, "bold"), foreground="#102b27")
        style.configure("VoiceStatus.TLabel", font=("Segoe UI", 11, "bold"), foreground="#356e5a")
        style.configure("TButton", font=("Segoe UI", 10), padding=8)
        style.configure("Treeview", font=("Segoe UI", 10), rowheight=28)
        style.configure("Treeview.Heading", font=("Segoe UI", 10, "bold"))

        shell = ttk.Frame(root, padding=20)
        shell.pack(fill="both", expand=True, padx=18, pady=18)
        header = ttk.Frame(shell)
        header.pack(fill="x", pady=(0, 20))
        ttk.Label(header, text="B.G.D   Identity workspace", style="Brand.TLabel").pack(side="left")
        ttk.Label(header, text=f"M1 PC  /  {__version__}  /  DEVELOPMENT", style="Muted.TLabel").pack(side="right")
        ttk.Separator(shell).pack(fill="x")
        footer = ttk.Frame(shell)
        footer.pack(side="bottom", fill="x")
        ttk.Separator(footer).pack(fill="x")
        ttk.Label(footer, text="Local processing  •  Capture only with deliberate consent  •  No biometric security acceptance",
                  style="Muted.TLabel").pack(anchor="w", pady=(12, 0))
        body = ttk.Frame(shell)
        body.pack(fill="both", expand=True, pady=20)
        sidebar = ttk.Frame(body, width=155)
        sidebar.pack(side="left", fill="y", padx=(0, 20))
        self.navigation: dict[str, ttk.Button] = {}
        for name in ("Readiness", "Setup", "Verify", "Account", "Recovery"):
            button = ttk.Button(sidebar, text=name, command=partial(self.show, name))
            button.pack(fill="x", pady=(0, 8))
            self.navigation[name] = button
        ttk.Label(sidebar, text="M1 / PC only\n\nNo aircraft connection.\nNo motor action.",
                  style="Muted.TLabel", wraplength=150).pack(side="bottom", anchor="w")

        context = ttk.Frame(body, width=205)
        context.pack(side="right", fill="y", padx=(22, 0))
        context.pack_propagate(False)
        ttk.Label(context, text="Workspace status", style="Brand.TLabel").pack(anchor="w", pady=(0, 20))
        self.summary = ttk.Label(context, text="Inspecting local prerequisites…", wraplength=200)
        self.summary.pack(anchor="w")
        ttk.Separator(context).pack(fill="x", pady=20)
        self.capture_label = ttk.Label(context, text="Camera off\nMicrophone off", wraplength=200)
        self.capture_label.pack(anchor="w")
        ttk.Label(context, text="Readiness does not open devices, prompt for credentials, "
                  "enroll anyone or approve an action.\n\nDetected hardware is not verified access "
                  "or proof of liveness.", style="Muted.TLabel", wraplength=200).pack(anchor="w", pady=20)

        self.main = ttk.Frame(body)
        self.main.pack(fill="both", expand=True)
        self.title = ttk.Label(self.main, text="Check this PC", style="Heading.TLabel")
        self.title.pack(anchor="w", pady=(0, 12))
        self.task_detail = ttk.Label(self.main, text="", wraplength=540)
        self.task_detail.pack(fill="x", pady=(0, 14))
        self.main.bind("<Configure>", lambda event: self.task_detail.configure(wraplength=max(260, event.width - 8)))
        self.preview_panel = ttk.Frame(self.main)
        self.preview_panel.pack(fill="x")
        self.preview_label = ttk.Label(self.preview_panel)
        self.preview_image: tk.PhotoImage | None = None
        self.audio_canvas = tk.Canvas(self.preview_panel, width=480, height=105,
                                      background="#f2f6f3", highlightthickness=0)
        self.voice_panel = ttk.Frame(self.main, padding=(0, 8))
        self.voice_progress = ttk.Label(self.voice_panel, text="", style="VoiceStatus.TLabel")
        self.voice_progress.pack(anchor="w")
        self.voice_phrase = ttk.Label(self.voice_panel, text="", style="Phrase.TLabel", wraplength=620)
        self.voice_phrase.pack(fill="x", pady=(8, 14))
        self.voice_status = ttk.Label(self.voice_panel, text="", wraplength=620)
        self.voice_status.pack(fill="x", pady=(0, 12))
        self.record_button = ttk.Button(self.voice_panel, text="Hold to record", state="disabled")
        self.record_button.bind("<ButtonPress-1>", self._record_press)
        self.record_button.bind("<ButtonRelease-1>", self._record_release)
        self.record_button.bind("<KeyPress-space>", self._record_press)
        self.record_button.bind("<KeyRelease-space>", self._record_release)
        self.review_actions = ttk.Frame(self.voice_panel)
        self.playback_button = ttk.Button(self.review_actions, text="Play back",
                                          command=lambda: self._send_voice_action("playback"))
        self.playback_button.pack(side="left")
        self.submit_voice_button = ttk.Button(self.review_actions, text="Submit",
                                              command=lambda: self._send_voice_action("submit"))
        self.submit_voice_button.pack(side="left", padx=8)
        self.rerecord_button = ttk.Button(self.review_actions, text="Record again",
                                          command=lambda: self._send_voice_action("rerecord"))
        self.rerecord_button.pack(side="left")
        self.root.bind("<FocusOut>", self._voice_focus_out, add="+")
        self.readiness_panel = ttk.Frame(self.main)
        self.check_list = ttk.Treeview(self.readiness_panel, columns=("name", "state"), show="headings", height=12)
        self.check_list.heading("name", text="Local prerequisite")
        self.check_list.heading("state", text="State")
        self.check_list.column("name", width=340, minwidth=200)
        self.check_list.column("state", width=95, minwidth=85, stretch=False)
        scrollbar = ttk.Scrollbar(self.readiness_panel, orient="vertical", command=self.check_list.yview)
        self.check_list.configure(yscrollcommand=scrollbar.set)
        scrollbar.pack(side="right", fill="y")
        self.check_list.pack(fill="both", expand=True)
        self.check_list.bind("<<TreeviewSelect>>", self.describe_selection)
        self.detail = ttk.Label(self.main, text="", wraplength=530, style="Muted.TLabel")
        self.detail.bind("<Configure>", lambda event: self.detail.configure(wraplength=max(260, event.width - 8)))
        self.refresh_button = ttk.Button(self.main, text="Refresh readiness", command=self.refresh)
        self.action_button = ttk.Button(self.main, state="disabled", command=self.start_setup)
        self.diagnostic_button = ttk.Button(self.main, text="Show diagnostics", command=self.show_diagnostics)
        self.consent = tk.BooleanVar(value=False)
        self.consent_check = ttk.Checkbutton(
            self.main, variable=self.consent,
            text="I agree to Windows verification and one local face and voice capture session. "
                 "Encrypted references are retained for this Windows owner until explicitly removed.")
        self.cancel_button = ttk.Button(self.main, text="Cancel setup", command=self.cancel_setup)
        self.code_panel = ttk.Frame(self.main)
        ttk.Label(self.code_panel, text="Save this recovery code offline. It will not be shown again.").pack(anchor="w")
        self.recovery_code = ""
        self.code_revealed = False
        self.code_value = ttk.Label(self.code_panel, text="", font=("Consolas", 11), wraplength=490)
        self.code_value.pack(anchor="w", pady=10)
        self.code_saved = tk.BooleanVar(value=False)
        code_actions = ttk.Frame(self.code_panel)
        code_actions.pack(anchor="w")
        self.reveal_button = ttk.Button(code_actions, text="👁 Show code", command=self.toggle_code)
        self.reveal_button.pack(side="left")
        self.copy_button = ttk.Button(code_actions, text="Copy code", command=self.copy_code)
        self.copy_button.pack(side="left", padx=8)
        ttk.Label(self.code_panel, wraplength=490, text="Copying enables completion but does not save the code permanently. "
                  "Store it safely offline. Other apps or clipboard history may retain it; B.G.D does not clear the clipboard.").pack(anchor="w", pady=8)
        self.complete_button = ttk.Button(self.code_panel, text="Complete setup", state="disabled", command=self.complete_setup)
        self.complete_button.pack(anchor="w", pady=(10, 0))
        self.show("Readiness")
        self.refresh()
        self.root.protocol("WM_DELETE_WINDOW", self.close)
        self.root.after(40, self.finish_enrollment)

    def bind_enrollment(self, enrollment: Enrollment, *, session_terms: str | None = None) -> None:
        """Attach the one authoritative setup workflow after the Tk HWND exists."""
        self.enrollment = enrollment
        self.session_terms = session_terms
        if session_terms is not None:
            self.consent_check.configure(text=session_terms)

    def on_close(self, callback: Callable[[], None]) -> None:
        self.close_callbacks.append(callback)

    def bind_verification(self, verification: Verification, *, session_terms: str | None = None) -> None:
        self.verification = verification
        self.verification_terms = session_terms

    def _capture_cancelled(self) -> bool:
        if self.verification_active and self.verification is not None:
            return self.verification.cancelled.is_set()
        return self.enrollment is not None and self.enrollment.cancelled.is_set()

    def report_diagnostic(self, value: CaptureDiagnostic) -> None:
        """Memory-only bounded telemetry, never used to decide authorization."""
        if (self.closed or not self.verification_active or self._capture_cancelled()
                or self.verification is None or not self.verification.diagnostics):
            return
        if not value.valid():
            raise ValueError("Invalid diagnostic response.")
        self.diagnostic_events.put_nowait((self.operation_epoch, value))

    def _clear_diagnostics(self) -> None:
        self.diagnostic_text = ""
        self.diagnostic_button.pack_forget()
        if self.diagnostic_window is not None:
            self.diagnostic_window.destroy()
            self.diagnostic_window = None
        while True:
            try:
                self.diagnostic_events.get_nowait()
            except Empty:
                break

    def show_diagnostics(self) -> None:
        if not self.diagnostic_text or self.closed:
            return
        if self.diagnostic_window is not None:
            self.diagnostic_window.lift()
            return
        window = tk.Toplevel(self.root)
        self.diagnostic_window = window
        window.title("B.G.D — memory-only verification diagnostics")
        window.geometry("760x650")
        text = tk.Text(window, wrap="word", font=("Consolas", 10), padx=14, pady=14)
        scrollbar = ttk.Scrollbar(window, orient="vertical", command=text.yview)
        text.configure(yscrollcommand=scrollbar.set)
        scrollbar.pack(side="right", fill="y")
        text.pack(fill="both", expand=True)
        text.insert("1.0", self.diagnostic_text)
        text.configure(state="disabled")

        def close_report() -> None:
            window.destroy()
            self.diagnostic_window = None

        window.protocol("WM_DELETE_WINDOW", close_report)

    def start_verification(self) -> None:
        if (self.verification is None or self.verification_terms is None or not self.setup_ready
                or self.setup_active or self.verification_active):
            return
        if not self.consent.get():
            self.task_detail.configure(text="Agree to this local face and voice check before continuing.")
            return
        requested_at = time.monotonic()
        self.verification_started = requested_at
        self.verification_elapsed = 0.0
        verification = self.verification
        if not verification.rearm():
            return
        self._clear_diagnostics()
        self.operation_epoch += 1
        epoch = self.operation_epoch
        self.verification_active = True
        self.was_interrupted = False
        self.action_button.state(["disabled"])
        self.consent_check.state(["disabled"])
        for button in self.navigation.values():
            button.state(["disabled"])
        self.cancel_button.configure(text="Cancel check")
        self.cancel_button.pack(anchor="w", pady=(0, 8))
        self.task_detail.configure(text="Starting a fresh face and spoken-challenge check…")
        results = self.verification_results
        self._start_worker(lambda: results.put((epoch, verification.start(
            consented=True, requested_at=requested_at))))

    def _finish_verification(self) -> None:
        try:
            epoch, result = self.verification_results.get_nowait()
        except Empty:
            return
        if epoch != self.operation_epoch:
            return
        interrupted = self._capture_cancelled() or self.was_interrupted
        capture_details: dict[str, str] = {}
        while True:
            try:
                diagnostic_epoch, value = self.diagnostic_events.get_nowait()
            except Empty:
                break
            if diagnostic_epoch == epoch and value.request_id == result.request_id:
                capture_details[value.stage] = value.details
        self.verification_active = False
        self._clear_preview()
        self._clear_voice()
        self.capture_label.configure(text="Camera off\nMicrophone off")
        message = ("Check interrupted. No action authorized." if interrupted else result.message)
        self.task_detail.configure(text=message)
        self.root.update_idletasks()
        self.verification_elapsed = max(result.elapsed_seconds, time.monotonic() - self.verification_started)
        self.task_detail.configure(text=f"{message}\nElapsed: {self.verification_elapsed:.2f}s "
                                   f"(normal-success target: 10s)."
                                   + (f"\nRequest: {result.request_id}" if result.request_id else ""))
        self.cancel_button.pack_forget()
        self.consent.set(False)
        self.consent_check.state(["!disabled"])
        self.action_button.state(["!disabled"])
        if self.verification is not None and self.verification.voice_study and self.verification.study_complete:
            self.action_button.state(["disabled"])
            self.consent_check.state(["disabled"])
        for name, button in self.navigation.items():
            button.state(["disabled"] if name == self.current_page else ["!disabled"])
        if (not interrupted and result.diagnostics and self.verification is not None
                and self.verification.diagnostics):
            self.diagnostic_text = (
                "DEVELOPMENT DIAGNOSTICS — NOT SECURITY ACCEPTANCE\n"
                "In memory only; cleared on a new check, navigation, interruption or close.\n"
                "No raw media, transcript or reference vectors in this report.\n\n"
                + result.diagnostics + f"\nRequest to displayed result: {self.verification_elapsed:.3f}s\n\n"
                + "\n\n".join(capture_details.get(stage, f"{stage.title()} capture: not measured")
                               for stage in ("face", "voice")))
            self.diagnostic_button.pack(anchor="w", pady=8)
            self.show_diagnostics()
        else:
            self._clear_diagnostics()

    def _start_worker(self, target: Callable[[], object]) -> None:
        worker = Thread(target=target, daemon=True)
        self.workers.append(worker)
        worker.start()

    def wait_for_workers(self, timeout: float = 5) -> bool:
        """Wait for currently tracked background operations during controlled shutdown/tests."""
        deadline = time.monotonic() + timeout
        for worker in tuple(self.workers):
            worker.join(max(0.0, deadline - time.monotonic()))
        return not any(worker.is_alive() for worker in self.workers)

    def report_stage(self, stage: str, queued: Event | None = None) -> None:
        """Thread-safe capture status sink for the concrete device adapter."""
        displayed = Event()
        epoch = self.operation_epoch
        self.stages.put((epoch, stage, displayed))
        if queued is not None:
            queued.set()
        if not displayed.wait(1):
            raise TimeoutError("Capture status was not displayed before device activation.")

    def report_preview(self, frame: bytes) -> None:
        """Display one bounded in-memory preview frame and acknowledge its rendering."""
        displayed = Event()
        try:
            self.previews.put_nowait((self.operation_epoch, frame, displayed))
        except Full as error:
            raise TimeoutError("Camera preview display is unavailable.") from error
        if not displayed.wait(1):
            raise TimeoutError("Camera preview was not displayed.")

    def _clear_preview(self) -> None:
        self.preview_label.configure(image="")
        self.preview_label.pack_forget()
        self.preview_image = None
        self.audio_canvas.delete("all")
        self.audio_canvas.pack_forget()

    def report_feedback(self, feedback: CaptureFeedback, queued: Event | None = None) -> None:
        """Acknowledge capture guidance and bounded transient amplitude data on Tk."""
        if (len(feedback.message) > 500 or len(feedback.waveform) > 48
                or any(not math.isfinite(value) or not 0 <= value <= 1 for value in feedback.waveform)):
            raise ValueError("Invalid capture feedback.")
        displayed = Event()
        try:
            self.feedbacks.put_nowait((self.operation_epoch, feedback, displayed))
        except Full as error:
            raise TimeoutError("Capture guidance is unavailable.") from error
        if queued is not None:
            queued.set()
        if not displayed.wait(1):
            raise TimeoutError("Capture guidance was not displayed.")

    def report_voice_state(self, prompt: VoicePrompt) -> str:
        """Display a deliberate voice-control state and return one bounded UI action."""
        allowed_states = {"measuring", "noise_retry", "ready", "recording", "review",
                          "playing", "processing", "accepted", "rejected", "failed", "idle"}
        if (prompt.state not in allowed_states or not math.isfinite(prompt.elapsed_seconds)
                or not math.isfinite(prompt.response_timeout_seconds)
                or not 0 < prompt.response_timeout_seconds <= 60
                or not 0 <= prompt.elapsed_seconds <= 10
                or (prompt.state == "idle" and (prompt.take, prompt.attempt, prompt.phrase) != (0, 0, ""))
                or (prompt.state != "idle" and (not 1 <= prompt.take <= 3
                                                or not 1 <= prompt.attempt <= 3
                                                or not (valid_challenge(prompt.phrase) if self.verification_active
                                                        else prompt.phrase in ENROLLMENT_PHRASES)))):
            raise ValueError("Invalid voice-control state.")
        displayed = Event()
        try:
            epoch = self.operation_epoch
            deadline = time.monotonic() + prompt.response_timeout_seconds
            self.voice_states.put_nowait((epoch, prompt, displayed))
        except Full as error:
            raise TimeoutError("Voice controls are unavailable.") from error
        if not displayed.wait(min(1.0, max(0.0, deadline - time.monotonic()))):
            raise TimeoutError("Voice controls were not displayed.")
        if time.monotonic() >= deadline:
            return "timeout"
        if epoch != self.operation_epoch or self.closed or self._capture_cancelled():
            return "cancel"
        if prompt.state == "recording":
            if self.voice_discard.is_set():
                return "record_discard"
            return "continue" if self.voice_holding.is_set() else "record_stop"
        expected = {"ready": {"record_start"}, "noise_retry": {"remeasure"},
                    "review": {"playback", "submit", "rerecord"},
                    "accepted": {"continue"}, "rejected": {"retry"},
                    "failed": {"finish"}}.get(prompt.state)
        if expected is None:
            return "continue"
        while time.monotonic() < deadline:
            if epoch != self.operation_epoch or self.closed or self._capture_cancelled():
                return "cancel"
            try:
                action = self.voice_actions.get(timeout=min(.05, max(0.0, deadline - time.monotonic())))
            except Empty:
                continue
            if action in expected:
                return action
        return "timeout"

    def _send_voice_action(self, action: str) -> None:
        if self.closed:
            return
        self.voice_actions.put(action)
        for button in (self.playback_button, self.submit_voice_button, self.rerecord_button):
            button.state(["disabled"])

    def _record_press(self, event: object = None) -> str:
        if self.record_button.instate(["disabled"]):
            return "break"
        if self.voice_mode == "noise_retry":
            self.record_button.state(["disabled"])
            self._send_voice_action("remeasure")
            return "break"
        if self.voice_mode in {"accepted", "rejected", "failed"}:
            action = {"accepted": "continue", "rejected": "retry", "failed": "finish"}[self.voice_mode]
            self.record_button.state(["disabled"])
            self._send_voice_action(action)
            return "break"
        if self.voice_mode != "ready" or self.voice_holding.is_set():
            return "break"
        self.voice_discard.clear()
        self.voice_holding.set()
        self.record_button.configure(text="Opening microphone… keep holding")
        self.voice_status.configure(text="Wait for Recording before speaking; keep holding the button.")
        if getattr(event, "keysym", "") != "space":
            try:
                self.record_button.grab_set()
            except tk.TclError:
                self.voice_discard.set()
                self.voice_holding.clear()
        self._send_voice_action("record_start")
        return "break"

    def _record_release(self, event: object = None) -> str:
        self.voice_holding.clear()
        if getattr(event, "keysym", "") != "space":
            try:
                self.record_button.grab_release()
            except tk.TclError:
                self.voice_discard.set()
        return "break"

    def _voice_focus_out(self, _event: object = None) -> None:
        self.root.after_idle(self._discard_if_focus_lost)

    def _discard_if_focus_lost(self) -> None:
        if self.voice_holding.is_set() and self.root.focus_displayof() is None:
            self.voice_discard.set()
            self._record_release()

    def _clear_voice(self) -> None:
        self.voice_discard.set()
        self._record_release()
        self.voice_mode = "idle"
        self.voice_panel.pack_forget()
        self.review_actions.pack_forget()
        while True:
            try:
                self.voice_actions.get_nowait()
            except Empty:
                break

    def show(self, page: str) -> None:
        if self.verification_active:
            return
        if self.setup_active and page != "Setup":
            return
        if self.verification is not None:
            self.verification.reset_study()
        self._clear_diagnostics()
        self.current_page = page
        for name, button in self.navigation.items():
            button.state(["disabled"] if name == page else ["!disabled"])
        self.readiness_panel.pack_forget()
        self.detail.pack_forget()
        self.refresh_button.pack_forget()
        self.action_button.pack_forget()
        self.consent_check.pack_forget()
        self.cancel_button.pack_forget()
        self.code_panel.pack_forget()
        if page != "Setup":
            self._clear_preview()
        if page == "Readiness":
            self.title.configure(text="Check this PC")
            self.task_detail.configure(text="Local prerequisites for owner setup. Select a row for next steps. "
                                       "Missing, failed and unverified checks never grant authorization.")
            self.refresh_button.pack(side="bottom", anchor="w")
            self.detail.pack(side="bottom", fill="x", pady=12)
            self.readiness_panel.pack(fill="both", expand=True)
        else:
            title, action, detail = self.workflow.task(page)
            self.title.configure(text=title)
            self.task_detail.configure(text=detail)
            self.action_button.configure(text=action)
            self.action_button.configure(command=self.start_verification if page == "Verify" else self.start_setup)
            self.action_button.pack(anchor="w", pady=12)
            self.action_button.state(["disabled"])
            if page == "Setup" and self.enrollment is not None:
                self.consent_check.configure(text=self.session_terms or "")
                state = self.enrollment.status()
                self.task_detail.configure(text=state.message)
                if state.state == "not-enrolled":
                    if not self.setup_ready:
                        self.task_detail.configure(text="Resolve every Missing or Failed readiness prerequisite "
                                                   "before setup can start.")
                    elif self.session_terms is None:
                        self.task_detail.configure(text="Real capture is blocked until the participant, access, "
                                                   "retention and deletion terms are agreed for this session.")
                    else:
                        self.action_button.state(["!disabled"])
                        self.consent_check.pack(anchor="w", pady=(4, 8))
            elif page == "Verify" and self.verification is not None:
                if self.verification.voice_study:
                    self.title.configure(text="Voice consistency study")
                    self.action_button.configure(text="Measure next sample (3 total)")
                    self.task_detail.configure(text="Diagnostic study only; no action can be authorized. "
                                               "Use the same microphone for three samples. Open diagnostics after each.")
                self.consent.set(False)
                if not self.setup_ready:
                    self.task_detail.configure(text="Resolve Missing or Failed prerequisites before verification.")
                elif self.verification_terms is None:
                    self.task_detail.configure(text="Development verification is ready. Real capture remains blocked "
                                               "until a specific owner session is agreed. Retry and spoof defenses "
                                               "are incomplete; this is not a security release.")
                else:
                    self.consent_check.configure(text=self.verification_terms)
                    self.consent_check.state(["!disabled"])
                    self.consent_check.pack(anchor="w", pady=(4, 8))
                    self.action_button.state(["!disabled"])

    def start_setup(self) -> None:
        if (self.enrollment is None or self.session_terms is None or not self.setup_ready
                or self.verification_active):
            return
        enrollment = self.enrollment
        if not self.consent.get():
            self.task_detail.configure(text="Agree to this specific local enrollment session before continuing.")
            return
        if not enrollment.rearm():
            self.task_detail.configure(text="Another setup operation is still active.")
            return
        self.operation_epoch += 1
        epoch = self.operation_epoch
        self.action_button.state(["disabled"])
        self.was_interrupted = False
        self.setup_active = True
        for button in self.navigation.values():
            button.state(["disabled"])
        self.consent_check.state(["disabled"])
        self.cancel_button.pack(anchor="w", pady=(0, 8))
        self.cancel_button.configure(text="Cancel setup")
        self.task_detail.configure(text="Confirm your Windows account. Face and voice capture starts only after success.")
        self.capture_label.configure(text="Camera off\nMicrophone off\nSetup in progress")
        results = self.enrollment_results
        self._start_worker(lambda: results.put((epoch, enrollment.start(consented=True))))

    def toggle_code(self) -> None:
        if not self.recovery_code:
            return
        self.code_revealed = not self.code_revealed
        self.code_value.configure(text=self.recovery_code if self.code_revealed else "•••• •••• •••• ••••")
        self.reveal_button.configure(text="👁 Hide code" if self.code_revealed else "👁 Show code")

    def copy_code(self) -> None:
        if not self.recovery_code or self.closed or self.completing:
            return
        try:
            self.root.clipboard_clear()
            self.root.clipboard_append(self.recovery_code)
        except tk.TclError:
            self.task_detail.configure(text="Could not copy the code. Try Copy again before completing setup.")
            return
        self.code_saved.set(True)
        self.complete_button.state(["!disabled"])
        self.task_detail.configure(text="Code copied. Save it somewhere safe before completing setup.")

    def _clear_code(self) -> None:
        self.recovery_code = ""
        self.code_revealed = False
        self.code_saved.set(False)
        self.code_value.configure(text="")
        self.reveal_button.configure(text="👁 Show code")
        self.complete_button.state(["disabled"])
        self.code_panel.pack_forget()

    def complete_setup(self) -> None:
        if self.enrollment is None or self.completing:
            return
        enrollment = self.enrollment
        if not self.code_saved.get():
            self.task_detail.configure(text="Copy the complete recovery code before completing setup.")
            return
        self.complete_button.state(["disabled"])
        self.copy_button.state(["disabled"])
        self.completing = True
        self.task_detail.configure(text="Saving the protected owner profile…")
        epoch = self.operation_epoch
        results = self.enrollment_results
        self._start_worker(lambda: results.put((epoch, enrollment.complete(code_saved=True))))

    def cancel_setup(self) -> None:
        self._clear_diagnostics()
        self._clear_code()
        self._clear_preview()
        self._clear_voice()
        if self.verification_active and self.verification is not None:
            self.verification.request_cancel()
            self.task_detail.configure(text="Cancelling check and closing capture…")
            return
        if self.enrollment is not None:
            enrollment = self.enrollment
            enrollment.request_cancel()
            self.operation_epoch += 1
            epoch = self.operation_epoch
            results = self.enrollment_results
            self._start_worker(lambda: results.put((epoch, enrollment.cancel())))

    def session_interrupted(self) -> None:
        self._clear_diagnostics()
        if self.verification is not None:
            self.verification.reset_study()
        if self.verification_active:
            self.was_interrupted = True
            self.cancel_setup()
            return
        if not self.setup_active:
            return
        self.was_interrupted = True
        self._clear_code()
        self.capture_label.configure(text="Camera off\nMicrophone off")
        self.task_detail.configure(text="Windows session interrupted. Setup cancelled; no profile was completed.")
        self.cancel_setup()

    def finish_enrollment(self) -> None:
        self._finish_verification()
        if (self.setup_active and self.enrollment is not None and self.enrollment.expired()
                and not self.completing):
            self.task_detail.configure(text="Enrollment reached five minutes and was cancelled. Start again when ready.")
            self.cancel_setup()
            self.root.after(40, self.finish_enrollment)
            return
        try:
            voice_epoch, prompt, displayed = self.voice_states.get_nowait()
            if voice_epoch != self.operation_epoch or self._capture_cancelled():
                displayed.set()
            elif prompt.state == "idle":
                self._clear_voice()
                displayed.set()
            else:
                self.voice_mode = prompt.state
                self.voice_panel.pack(fill="x", pady=(0, 14))
                self.voice_progress.configure(text="One fresh spoken challenge" if self.verification_active else
                                              f"Phrase {prompt.take} of 3  ·  Attempt {prompt.attempt} of 3")
                self.voice_phrase.configure(text=prompt.phrase)
                self.review_actions.pack_forget()
                self.record_button.pack_forget()
                self.record_button.state(["disabled"])
                state_text = {
                    "measuring": "Measuring room noise… stay quiet.",
                    "noise_retry": "The room is too noisy. Make it quieter, then measure again.",
                    "ready": ("Hold the button or Spacebar while reading the phrase. Release to submit this check."
                              if self.verification_active else
                              "Hold the button or Spacebar while reading the phrase. Release when finished."),
                    "recording": f"Recording… {prompt.elapsed_seconds:.1f} seconds. Release when finished.",
                    "review": "Microphone off. Play back, submit, or record this phrase again.",
                    "playing": "Playing the memory-only recording. Microphone off.",
                    "processing": "Checking this take… microphone off.",
                    "accepted": "Accepted. Continue when you are ready for the next phrase.",
                    "rejected": "Not accepted. Review the guidance, then try this phrase again.",
                    "failed": "Not accepted. All three attempts for this phrase have been used.",
                }[prompt.state]
                self.voice_status.configure(text=state_text)
                if prompt.state == "noise_retry":
                    self.record_button.pack(anchor="w")
                    self.record_button.configure(text="Measure again")
                    self.record_button.state(["!disabled"])
                elif prompt.state == "ready":
                    self.record_button.pack(anchor="w")
                    self.record_button.configure(text="Hold to record")
                    self.record_button.state(["!disabled"])
                    self.record_button.focus_set()
                elif prompt.state == "recording":
                    self.record_button.pack(anchor="w")
                    self.record_button.configure(text="Recording… release to stop")
                    self.record_button.state(["!disabled"])
                elif prompt.state == "review":
                    self._record_release()
                    self.record_button.configure(text="Hold to record")
                    self.review_actions.pack(anchor="w")
                    for button in (self.playback_button, self.submit_voice_button, self.rerecord_button):
                        button.state(["!disabled"])
                elif prompt.state in {"accepted", "rejected", "failed"}:
                    self.record_button.pack(anchor="w")
                    self.record_button.configure(text={"accepted": "Continue", "rejected": "Try again",
                                                       "failed": "Finish"}[prompt.state])
                    self.record_button.state(["!disabled"])
                self.capture_label.configure(text={
                    "measuring": "Camera off\nMicrophone measuring room",
                    "recording": "Camera off\nMicrophone recording",
                    "playing": "Camera off\nMicrophone off\nPlayback active",
                }.get(prompt.state, "Camera off\nMicrophone off"))
                self.root.update_idletasks()
                displayed.set()
        except Empty:
            pass
        try:
            feedback_epoch, feedback, displayed = self.feedbacks.get_nowait()
            if feedback_epoch != self.operation_epoch or self._capture_cancelled():
                self.root.after(0, self.finish_enrollment)
                return
            self.task_detail.configure(text=feedback.message)
            self.audio_canvas.delete("all")
            if feedback.waveform:
                self.audio_canvas.pack(fill="x", pady=(0, 12))
                self.root.update_idletasks()
                width = self.audio_canvas.winfo_width()
                step = width / len(feedback.waveform)
                for index, value in enumerate(feedback.waveform):
                    amplitude = max(1, value * 44)
                    x = step * (index + .5)
                    self.audio_canvas.create_line(x, 52 - amplitude, x, 52 + amplitude,
                                                  fill="#4e9478", width=max(2, step * .55), capstyle="round")
            else:
                self.audio_canvas.pack_forget()
            self.root.update_idletasks()
            displayed.set()
        except Empty:
            pass
        try:
            preview_epoch, frame, displayed = self.previews.get_nowait()
            if preview_epoch != self.operation_epoch or self._capture_cancelled():
                self.root.after(0, self.finish_enrollment)
                return
            image = tk.PhotoImage(data=base64.b64encode(frame), format="png")
            self.preview_image = image
            self.preview_label.configure(image=image)
            self.preview_label.pack(anchor="center", pady=(0, 12))
            self.root.update_idletasks()
            displayed.set()
        except Empty:
            pass
        try:
            stage_epoch, stage, displayed = self.stages.get_nowait()
            if (stage_epoch != self.operation_epoch
                    or stage != "idle" and self._capture_cancelled()):
                self.root.after(0, self.finish_enrollment)
                return
            capture = {"face": "Camera active\nMicrophone off",
                       "voice": "Camera off\nMicrophone active",
                       "idle": "Camera off\nMicrophone off"}.get(stage)
            if capture is not None:
                self.capture_label.configure(text=capture)
            if stage == "idle":
                self._clear_preview()
                self._clear_voice()
            guidance = {"face": "Keep one face clearly visible and look toward the camera. Cancel to stop.",
                        "voice": "Preparing the voice step. Stay quiet for room measurement, then hold "
                                 "Record or Spacebar while reading the displayed phrase."}.get(stage)
            if guidance is not None:
                self.task_detail.configure(text=guidance)
            self.root.update_idletasks()
            displayed.set()
        except Empty:
            pass
        try:
            epoch, result = self.enrollment_results.get_nowait()
        except Empty:
            self.root.after(40, self.finish_enrollment)
            return
        if epoch != self.operation_epoch:
            self.root.after(0, self.finish_enrollment)
            return
        message = ("Windows session interrupted. Setup cancelled; no profile was completed."
                   if self.was_interrupted and result.state == "cancelled" else result.message)
        self.task_detail.configure(text=message)
        self.capture_label.configure(text="Camera off\nMicrophone off")
        self._clear_preview()
        self._clear_voice()
        if result.state == "save-code" and result.recovery_code:
            self._clear_code()
            self.recovery_code = result.recovery_code
            self.copy_button.state(["!disabled"])
            self.code_value.configure(text="•••• •••• •••• ••••")
            self.code_panel.pack(anchor="w", fill="x", pady=12)
            self.cancel_button.pack(anchor="w", pady=(0, 8))
        else:
            self.completing = False
            self.setup_active = False
            for name, button in self.navigation.items():
                button.state(["disabled"] if name == "Setup" else ["!disabled"])
            self._clear_code()
            self.cancel_button.pack_forget()
            self.consent.set(False)
            self.consent_check.state(["!disabled"])
            if result.state == "not-enrolled":
                self.action_button.state(["!disabled"])
        self.root.after(40, self.finish_enrollment)

    def close(self) -> None:
        if self.closed:
            return
        self.closed = True
        self._clear_diagnostics()
        self._clear_code()
        self._clear_preview()
        self._clear_voice()
        if self.verification is not None:
            self.verification.request_cancel()
        if self.enrollment is not None:
            self.enrollment.request_cancel()
        for callback in self.close_callbacks:
            callback()
        if self.enrollment is not None:
            self._start_worker(self.enrollment.cancel)
        self.wait_for_workers(2)
        self.workers.clear()
        try:
            for callback in self.root.tk.call("after", "info"):
                self.root.after_cancel(callback)
        except tk.TclError:
            pass
        self.root.destroy()

    def describe_selection(self, _event: object = None) -> None:
        selected = self.check_list.selection()
        if selected:
            self.detail.configure(text=self.details[selected[0]])

    def refresh(self) -> None:
        if self.refresh_button.instate(["disabled"]):
            return
        self.refresh_button.state(["disabled"])
        self.summary.configure(text="Inspecting local prerequisites…\nNo capture started.")

        workflow = self.workflow
        results = self.results

        def inspect() -> None:
            try:
                report = workflow.refresh()
            except Exception:
                report = Readiness((Check("Platform", "Readiness inspection", "Failed",
                                          "Cannot inspect local prerequisites. Repair the environment and refresh."),))
            results.put(report)

        self._start_worker(inspect)
        self.root.after(40, self.finish_refresh)

    def finish_refresh(self) -> None:
        try:
            report = self.results.get_nowait()
        except Empty:
            self.root.after(40, self.finish_refresh)
            return
        self.check_list.delete(*self.check_list.get_children())
        self.details.clear()
        for check in report.checks:
            item = self.check_list.insert("", "end", values=(check.name, check.state))
            self.details[item] = f"{check.group} — {check.detail}"
        missing = sum(check.state == "Missing" for check in report.checks)
        failed = sum(check.state == "Failed" for check in report.checks)
        unverified = sum(check.state == "Unverified" for check in report.checks)
        self.setup_ready = not missing and not failed
        boundary = ("Setup prerequisites are present; unverified items require a deliberate session."
                    if self.setup_ready else
                    "Setup remains closed until every Missing or Failed prerequisite is resolved.")
        self.summary.configure(text=f"{missing} missing\n{failed} failed\n{unverified} unverified\n\n{boundary}")
        children = self.check_list.get_children()
        if children:
            self.check_list.selection_set(children[0])
            self.describe_selection()
        self.refresh_button.state(["!disabled"])
        if self.current_page == "Setup":
            self.show("Setup")
