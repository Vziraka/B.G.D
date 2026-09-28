"""Deterministic protocol v1 model. Every authority and observation is SIMULATED.

Only the trusted test harness calls maintenance, radio, flight and face injection
methods. They are not network endpoints or production security implementations.
There are no actuator, camera, microphone, storage or transport adapters.
"""

from dataclasses import dataclass, field, replace
from math import isfinite
from uuid import uuid4


def valid_envelope(message):
    return (isinstance(message, Message) and type(message.protocol_version) is int
            and message.protocol_version == 1 and type(message.sequence) is int
            and message.sequence > 0 and isinstance(message.payload, dict)
            and all(isinstance(value, str) and value for value in
                    (message.aircraft_id, message.configuration_id, message.boot_epoch,
                     message.session_id, message.request_id, message.kind))
            and message.payload.get("origin") == "SIMULATED")


@dataclass(frozen=True)
class Message:
    protocol_version: int
    aircraft_id: str
    configuration_id: str
    boot_epoch: str
    session_id: str
    sequence: int
    request_id: str
    kind: str
    payload: dict = field(default_factory=dict)


class Simulator:
    """Single-threaded event loop with an explicitly advanced monotonic clock."""

    def __init__(self):
        self.aircraft_id = "SIMULATED-aircraft"
        self.configuration_id = "SIMULATED-illustrative-v1"
        self.boot_epoch = str(uuid4())
        self.session_id = str(uuid4())
        self.now = 0.0
        self.state = "DISCONNECTED"
        self.connected = False
        # Fixture identities are labels, not keys or authentication proof.
        self.paired_phone = "SIMULATED-phone"
        self.radio_paired = True
        self.ownership_valid = True
        self.enrolled = False
        self.reference_version = 0
        self.healthy = True
        self.airborne = self.armed = False
        self.motor_inhibited = True
        self.ready = dict(configuration=True, site=True, radio=True, energy=True,
                          navigation=True, prearm=True, return_point=True, pose=True)
        self.return_healthy = self.return_reachable = self.reserve_protected = True
        self.degraded_policy_validated = False
        self.stable_pose = False
        self.preview = False
        self.guidance = "SIMULATED preview off"
        self.face_result = "SIMULATED not checked"
        self.permission = False
        self.speech_window = None
        self.last_command_at = None
        self.activity = None
        self.pending = None
        self.pending_deadline = None
        self.challenge = None
        self.verification_id = None
        self.last_verification_id = None
        self.verification_deadline = None
        self.retry_deadline = None
        self.failures = 0
        self.maintenance_deadline = None
        self.enrollment_id = None
        self.enrollment_deadline = None
        self._radio_high = False
        self._rx_sequence = self._tx_sequence = 0
        self._seen = set()
        self.events = []
        self._record("Initialized; fixture pairing only; no real authentication")

    def _record(self, reason):
        self.events.append({"origin": "SIMULATED", "time": self.now,
                            "state": "SIMULATED " + self.state, "reason": reason})

    def snapshot(self):
        return {"origin": "SIMULATED", "state": "SIMULATED " + self.state,
                "time": self.now, "airborne": self.airborne, "armed": self.armed,
                "permission": "SIMULATED " + ("GRANTED" if self.permission else "DENIED"),
                "preview": self.preview, "guidance": self.guidance,
                "face_result": self.face_result, "activity": self.activity,
                "reason": self.events[-1]["reason"],
                "physical_geometry": "DISABLED; no validated flight distances or limits"}

    def message(self, kind, request_id, **payload):
        self._tx_sequence += 1
        return Message(1, self.aircraft_id, self.configuration_id, self.boot_epoch,
                       self.session_id, self._tx_sequence, request_id, kind,
                       {"origin": "SIMULATED", **payload})

    def _binding(self, message):
        return (message.protocol_version == 1
                and message.aircraft_id == self.aircraft_id
                and message.configuration_id == self.configuration_id
                and message.boot_epoch == self.boot_epoch
                and message.session_id == self.session_id)

    def status_messages(self):
        """Versioned status seam; the UI never creates aircraft permission."""
        messages = [self.message("flight_status", str(uuid4()), **self.snapshot())]
        if self.last_verification_id:
            status = ("pending" if self.verification_id else
                      "pass" if self.permission else
                      "timeout" if "TIMEOUT" in self.face_result else "fail")
            messages.append(self.message("verification_status", self.last_verification_id,
                                         status=status, face_result=self.face_result,
                                         preview=self.preview, guidance=self.guidance))
        messages.append(self.message("command_session", str(uuid4()),
                                     permission="granted" if self.permission else "denied"))
        return messages

    def connect(self, phone="SIMULATED-phone"):
        if phone != self.paired_phone or not self.ownership_valid:
            return False
        if not self.connected:
            self.connected = True
            self.session_id = str(uuid4())
            self._rx_sequence = self._tx_sequence = 0
            self._seen.clear()
            if not self.airborne:
                self.state = "GROUND_READY"
            self._record("Fresh simulated connection; no permissions resumed")
        return True

    def issue_challenge(self):
        if not self.connected or self.state != "GROUND_READY" or self.enrollment_id:
            return None
        self.challenge = (str(uuid4()), self.now + 15)
        return self.message("launch_challenge", str(uuid4()),
                            challenge_id=self.challenge[0], expires_in_seconds=15)

    def receive(self, message):
        """Phone request boundary. Phone-supplied face results are always rejected."""
        if not valid_envelope(message) or not self.connected or not self._binding(message):
            return False
        if (type(message.sequence) is not int or message.sequence <= self._rx_sequence
                or not isinstance(message.request_id, str) or not message.request_id
                or message.request_id in self._seen or not isinstance(message.payload, dict)):
            return False
        self._rx_sequence = message.sequence
        self._seen.add(message.request_id)
        p = message.payload
        if message.kind == "launch_request":
            challenge, self.challenge = self.challenge, None
            valid = (challenge is not None and p.get("challenge_id") == challenge[0]
                     and self.now < challenge[1] and p.get("hold_confirmed") is True)
            if not valid or self.state != "GROUND_READY":
                return self.message("launch_result", message.request_id, accepted=False,
                                    reason="Invalid, expired or consumed launch authority")
            self.pending = replace(message, payload=dict(p))
            self.pending_deadline = challenge[1]
            self.state = "LAUNCH_PENDING"
            self._record("One launch challenge consumed; flight checks still pending")
            return True
        if message.kind == "command_request":
            window, self.speech_window = self.speech_window, None
            valid = (self.permission and self.state == "COMMAND_READY" and window
                     and self.now < window[1] and p.get("window_id") == window[0]
                     and isinstance(p.get("command"), str)
                     and p.get("command") in {"status", "inspect_once", "observe_until_stopped"}
                     and p.get("ambiguous", False) is False)
            if not valid:
                return self.message("command_result", message.request_id, accepted=False,
                                    reason="No current permission/window or unsupported/ambiguous command")
            self.pending = replace(message, payload=dict(p))
            self.pending_deadline = window[1]
            self._record("Command pending onboard acceptance; no action yet")
            return True
        if message.kind == "cancel_request":
            if self.pending and p.get("target_request_id") == self.pending.request_id:
                result_kind = "launch_result" if self.pending.kind == "launch_request" else "command_result"
                result_id = self.pending.request_id
                self.pending = None
                if self.state == "LAUNCH_PENDING":
                    self.state = "GROUND_READY"
                self._record("Named pending request canceled; no flight mode requested")
                return self.message(result_kind, result_id, accepted=False, reason="Canceled")
            return False
        return False

    def resolve_pending(self, safe=True):
        request, self.pending = self.pending, None
        if request is None:
            return None
        safe = safe is True and self.now < self.pending_deadline
        self.pending_deadline = None
        if request.kind == "launch_request":
            accepted = self._launch_ready() and safe
            if accepted:
                self._launch()
            else:
                self.state = "GROUND_READY"
                self._record("Launch rejected by simulated flight readiness checks")
            return self.message("launch_result", request.request_id, accepted=accepted)
        accepted = bool(safe and self.permission and self.state == "COMMAND_READY"
                        and self.connected and self.healthy)
        if accepted:
            self.last_command_at = self.now
            self.activity = ("SIMULATED open-ended observation" if
                             request.payload["command"] == "observe_until_stopped" else
                             "SIMULATED finite " + request.payload["command"])
        self._record("Command " + ("accepted" if accepted else "rejected"))
        return self.message("command_result", request.request_id, accepted=accepted)

    def _launch_ready(self):
        return (self.healthy and self.ownership_valid and self.enrolled and self.radio_paired
                and all(self.ready.values()) and not self.enrollment_id and not self.airborne)

    def _launch(self):
        self.state = "APPROACHING"
        self.airborne = self.armed = True
        self.motor_inhibited = False  # State assertion only; no outputs exist.
        self.permission = False
        self.challenge = None
        self.failures = 0
        self._record("SIMULATED launch toward fixed verification zone; no physical geometry")

    def radio_control(self, high, paired=True):
        edge = high is True and not self._radio_high
        self._radio_high = high is True
        if not edge or not paired or not self.radio_paired:
            return False
        self.challenge = None
        if self.state not in {"GROUND_READY", "DISCONNECTED", "LANDED"} or not self._launch_ready():
            self._record("Radio edge consumed and rejected")
            return False
        self._launch()
        return True

    def arrive_at_pose(self, stable=True):
        if self.state != "APPROACHING":
            return False
        self.stable_pose = stable
        if not stable or not self.connected:
            self._recover("Invalid pose or phone disconnected")
            return False
        self.state = "VERIFYING"
        self._begin_verification()
        return True

    def _begin_verification(self):
        self.verification_id = str(uuid4())
        self.last_verification_id = self.verification_id
        # Illustrative first-attempt timeout; retry admission has the approved 30 s bound.
        self.verification_deadline = self.now + 30
        self.retry_deadline = None
        self.preview = True
        self.guidance = "SIMULATED hold still inside the frame; advisory only"
        self.face_result = "SIMULATED onboard face+liveness pending"
        self._record("Synthetic camera guidance started")

    def inject_onboard_face_result(self, request_id, *, face_match, live):
        """Trusted test-double injection; deliberately absent from receive()."""
        if (self.state != "VERIFYING" or request_id != self.verification_id
                or request_id is None or not self.stable_pose or not self.preview
                or not self.connected or self.now >= self.verification_deadline):
            return False
        self.verification_id = None
        self.verification_deadline = None
        if face_match is True and live is True:
            self.face_result = "SIMULATED onboard face+liveness PASS; no biometric evidence"
            self.preview = False
            self.guidance = "SIMULATED preview off after completion"
            self.permission = True
            self.state = "COMMAND_READY"
            self.last_command_at = self.now
            self._record("SIMULATED onboard result grants current command session only")
        else:
            self.failures += 1
            self.face_result = "SIMULATED onboard face/liveness FAIL"
            if self.failures >= 2:
                self._recover("Verification retry exhausted")
            else:
                self.retry_deadline = self.now + 30
                self._record("One explicit retry allowed within 30 seconds")
        return True

    def retry_verification(self):
        if (self.state != "VERIFYING" or self.failures != 1 or not self.retry_deadline
                or self.now >= self.retry_deadline or not self.connected or not self.stable_pose
                or not self.preview):
            return False
        self._begin_verification()
        return True

    def lose_preview(self):
        self.preview = False
        self.guidance = "SIMULATED preview lost; never biometric success"
        if self.enrollment_id:
            self.enrollment_id = self.enrollment_deadline = None
            self._record("Enrollment canceled; old reference retained")
        elif self.state == "VERIFYING":
            self._recover("Guidance preview lost")

    def set_pose_stable(self, stable):
        self.stable_pose = stable is True
        if not self.stable_pose and self.state == "VERIFYING":
            self._recover("Verification pose became invalid")

    def open_speech_window(self, deliberate=True):
        if not self.permission or self.state != "COMMAND_READY" or deliberate is not True or self.pending:
            return None
        self.speech_window = (str(uuid4()), self.now + 10)
        return self.speech_window[0]

    def interrupt_speech(self, reason):
        self.speech_window = None
        if self.pending and self.pending.kind == "command_request":
            self.pending = None
        self._record("Speech closed; queued input discarded: " + reason)

    def stop(self):
        self._recover("Explicit Stop revokes owner command session")

    def cancel_enrollment(self):
        if not self.enrollment_id:
            return False
        self.enrollment_id = self.enrollment_deadline = None
        self.maintenance_deadline = None
        self.preview = False
        self.guidance = "SIMULATED preview off after cancellation"
        self.face_result = "SIMULATED enrollment CANCELED"
        self._record("Enrollment canceled; old reference retained")
        return True

    def disconnect(self, reason="phone disconnect"):
        self.connected = False
        self._recover(reason)
        if not self.airborne:
            self.state = "DISCONNECTED"

    def restart(self):
        self.disconnect("Restart invalidates all prior requests/permissions; flight rescue not proven")
        self.activity = None
        self.boot_epoch = str(uuid4())
        self.session_id = str(uuid4())
        self._rx_sequence = self._tx_sequence = 0
        self._seen.clear()
        self.maintenance_deadline = None
        # Do not turn a held radio control into a fresh edge after restart.

    def change_configuration(self, configuration_id):
        self.configuration_id = configuration_id
        self.disconnect("Configuration changed")

    def safety_fault(self):
        self.healthy = False
        self.activity = None
        self._recover("Safety fault")

    def _recover(self, reason):
        if self.enrollment_id:
            self.face_result = "SIMULATED enrollment CANCELED"
        elif self.verification_id and "TIMEOUT" not in self.face_result:
            self.face_result = "SIMULATED verification CANCELED"
        self.permission = False
        self.speech_window = self.pending = self.challenge = None
        self.pending_deadline = None
        self.verification_id = self.verification_deadline = self.retry_deadline = None
        self.enrollment_id = self.enrollment_deadline = None
        self.maintenance_deadline = None
        self.preview = False
        self.guidance = "SIMULATED preview off"
        if self.activity and ("open-ended" in self.activity or not self.healthy
                              or not self.return_healthy or not self.return_reachable
                              or not self.reserve_protected):
            self.activity = None
        if self.airborne and self.state == "AIRBORNE_MANUAL":
            reason += "; independent manual authority retains priority"
        elif self.airborne:
            self.state = "PROTECTIVE_RECOVERY"
            if self.return_healthy and self.return_reachable and self.reserve_protected:
                reason += "; SIMULATED return-and-land branch"
            elif self.degraded_policy_validated:
                reason += "; SIMULATED separately-validated degraded branch fixture"
            else:
                reason += "; recovery policy UNQUALIFIED, independent radio required; no blind return/hover claim"
        else:
            self.state = ("FAULT_GROUND" if not self.healthy or not self.ownership_valid else
                          "GROUND_READY" if self.connected else "DISCONNECTED")
        self._record(reason)

    def manual_takeover(self, paired=True):
        if not paired or not self.radio_paired or not self.airborne:
            return False
        self._recover("Independent radio takeover; no biometric requirement")
        self.activity = None
        self.state = "AIRBORNE_MANUAL"
        self._record("Independent manual authority has priority")
        return True

    def land_and_disarm(self):
        """Trusted flight-status injection, not a disarm command."""
        self._recover("SIMULATED landed and disarmed observation")
        self.airborne = self.armed = False
        self.motor_inhibited = True
        self.activity = None
        self.connected = False
        self.session_id = str(uuid4())
        self.last_verification_id = None
        self.state = "LANDED"
        self._record("Landing ended flight permissions; new deliberate launch required")

    def advance(self, seconds):
        if isinstance(seconds, bool) or not isfinite(seconds) or seconds < 0:
            raise ValueError("Clock advances must be finite and nonnegative")
        self.now += seconds
        if self.enrollment_deadline is not None and self.now >= self.enrollment_deadline:
            self.enrollment_id = self.enrollment_deadline = None
            self.preview = False
            self.guidance = "SIMULATED preview off after enrollment expiry"
            self._record("Enrollment expired; old reference retained")
        if self.speech_window and self.now >= self.speech_window[1]:
            self.interrupt_speech("10-second window expired")
        if ((self.verification_deadline is not None and self.now >= self.verification_deadline)
                or (self.retry_deadline is not None and self.now >= self.retry_deadline)):
            self.face_result = "SIMULATED verification TIMEOUT"
            self._recover("Verification timeout")
        if self.permission and self.now >= self.last_command_at + 300:
            self._recover("Five-minute accepted-command inactivity expiry")

    def maintenance_gesture(self, *, physical_radio=False):
        if (physical_radio is not True or not self.radio_paired or self.airborne
                or self.armed or not self.healthy or not self.motor_inhibited):
            return False
        self.maintenance_deadline = self.now + 120
        self._record("SIMULATED physical radio opens two-minute maintenance window")
        return True

    def begin_enrollment(self, *, current_reference_verified=False, recovery_authorized=False):
        """Approval flags are trusted maintenance fixtures, never phone assertions.

        No recovery secrets, device keys or encrypted references are created here.
        Actual pairing/recovery/atomic durable storage remain integration gates.
        """
        if (not self.connected or not self.ownership_valid or not self.healthy or self.airborne
                or self.armed or not self.motor_inhibited or self.pending or self.enrollment_id
                or self.maintenance_deadline is None or self.now >= self.maintenance_deadline
                or (self.enrolled and not (current_reference_verified is True or recovery_authorized is True))):
            return None
        self.maintenance_deadline = None
        self.challenge = None
        self.enrollment_id = str(uuid4())
        self.enrollment_deadline = self.now + 120  # Illustrative bounded service duration.
        self.preview = True
        self.guidance = "SIMULATED enrollment: center face, improve lighting, hold still"
        self.face_result = "SIMULATED onboard enrollment pending"
        self._record("Motor-inhibited synthetic enrollment; no biometric data collected")
        return self.enrollment_id

    def inject_enrollment_result(self, request_id, *, face_match, live):
        if (not self.enrollment_id or request_id != self.enrollment_id or not self.preview
                or not self.connected or self.airborne or self.armed or not self.motor_inhibited
                or not self.healthy or not self.ownership_valid):
            return False
        self.enrollment_id = self.enrollment_deadline = None
        self.preview = False
        self.guidance = "SIMULATED preview off after enrollment"
        success = face_match is True and live is True
        if success:
            self.enrolled = True
            self.reference_version += 1
        self.face_result = "SIMULATED enrollment " + ("PASS; no biometric evidence" if success else "FAIL")
        self._record("Synthetic reference committed" if success else "Old reference retained")
        return success


class Phone:
    """Simulated request construction and result replay/pending-request checks."""

    def __init__(self, aircraft):
        self.binding = (1, aircraft.aircraft_id, aircraft.configuration_id,
                        aircraft.boot_epoch, aircraft.session_id)
        self.sequence = self.result_sequence = 0
        self.now = 0.0
        self.pending = {}
        self.connected = True
        self.verification_pending = None
        self.display = {}
        self._seen_ids = set()

    def request(self, kind, **payload):
        self.sequence += 1
        request = Message(*self.binding, self.sequence, str(uuid4()), kind,
                          {"origin": "SIMULATED", **payload})
        if kind in {"launch_request", "command_request"}:
            self.pending[request.request_id] = (kind.replace("request", "result"),
                                                self.now + (15 if kind == "launch_request" else 10))
        return request

    def receive_result(self, message):
        if not self.connected or not valid_envelope(message):
            return False
        binding = (message.protocol_version, message.aircraft_id, message.configuration_id,
                   message.boot_epoch, message.session_id)
        if (binding != self.binding or type(message.sequence) is not int
                or message.sequence <= self.result_sequence
                or message.request_id not in self.pending
                or message.request_id in self._seen_ids
                or self.pending[message.request_id][0] != message.kind
                or self.now >= self.pending[message.request_id][1]
                or not isinstance(message.payload, dict)
                or message.payload.get("origin") != "SIMULATED"
                or type(message.payload.get("accepted")) is not bool):
            return False
        self.result_sequence = message.sequence
        self._seen_ids.add(message.request_id)
        del self.pending[message.request_id]
        return True

    def receive_status(self, message):
        if not self.connected or not valid_envelope(message):
            return False
        binding = (message.protocol_version, message.aircraft_id, message.configuration_id,
                   message.boot_epoch, message.session_id)
        if (binding != self.binding or message.sequence <= self.result_sequence
                or message.kind not in {"flight_status", "verification_status", "command_session"}):
            return False
        if message.kind == "verification_status":
            status = message.payload.get("status")
            if not isinstance(status, str) or status not in {"pending", "pass", "fail", "timeout"}:
                return False
            if status == "pending":
                if message.request_id in self._seen_ids:
                    return False
                self.verification_pending = message.request_id
            elif message.request_id != self.verification_pending:
                return False
            else:
                # One terminal result may correlate to its accepted pending status.
                self.verification_pending = None
        elif message.request_id in self._seen_ids:
            return False
        if message.kind == "command_session":
            permission = message.payload.get("permission")
            if not isinstance(permission, str) or permission not in {"granted", "denied", "expired", "revoked"}:
                return False
        self.result_sequence = message.sequence
        self._seen_ids.add(message.request_id)
        self.display[message.kind] = dict(message.payload)
        return True

    def disconnect(self):
        self.connected = False
        self.pending.clear()
        self.verification_pending = None
        self.display.clear()

    def advance(self, seconds):
        if isinstance(seconds, bool) or not isfinite(seconds) or seconds < 0:
            raise ValueError("Phone clock advances must be finite and nonnegative")
        self.now += seconds
