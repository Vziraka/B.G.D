import http.client
import json
from pathlib import Path
import threading
import time
from types import SimpleNamespace
import unittest

from bgd_vision.conversation import validate_semantic_result
from bgd_vision.server import Application, Handler, ThreadingHTTPServer


class ConversationHTTPTests(unittest.TestCase):
    def setUp(self):
        self.app = Application(SimpleNamespace(model="test", imgsz=320, log=Path("unused")))
        self.server = ThreadingHTTPServer(("127.0.0.1", 0), Handler)
        self.server.app = self.app
        self.thread = threading.Thread(target=self.server.serve_forever, daemon=True)
        self.thread.start()

    def tearDown(self):
        self.server.shutdown()
        self.server.server_close()
        self.thread.join()

    def request(self, path, data, headers=None):
        connection = http.client.HTTPConnection("127.0.0.1", self.server.server_port, timeout=3)
        body = data if isinstance(data, bytes) else json.dumps(data)
        connection.request("POST", path, body, headers if headers is not None else {
            "X-Session-Token": self.app.token})
        response = connection.getresponse()
        result = response.status, json.loads(response.read())
        connection.close()
        return result

    def test_http_requires_exact_confirmation_and_rejects_replay_corrections_and_missing_auth(self):
        self.app.vision_at = time.monotonic()
        self.app.tracks = []
        code, first = self.request("/mission/run", {"text": "count people"})
        self.assertEqual(code, 200)
        self.assertEqual(first["status"], "confirmation_required")
        self.assertEqual(self.app.mission["status"], "idle")
        with self.app.condition:
            public_status = json.dumps(self.app.snapshot())
        self.assertNotIn(first["proposal_id"], public_status)
        self.assertNotIn("count people", public_status)
        _, second = self.request("/conversation", {"text": "count people"})
        self.assertEqual(self.request("/conversation/confirm", {"proposal_id": first["proposal_id"]})[1]["status"], "expired")
        self.assertEqual(self.request("/conversation", {"text": "yes"})[1]["status"], "expired")
        _, result = self.request("/conversation", {"text": "yes", "proposal_id": second["proposal_id"]})
        self.assertEqual(result["status"], "complete")
        self.assertEqual(result["value"], 0)
        self.assertEqual(self.request("/conversation/confirm", {"proposal_id": second["proposal_id"]})[1]["status"], "expired")
        self.assertEqual(self.request("/conversation/cancel", {}, {})[0], 403)
        self.assertEqual(self.request("/conversation/confirm", {"proposal_id": 42})[0], 400)

    def test_stop_during_slow_detection_never_resurrects_target_or_mission(self):
        class Frame:
            shape = (100, 200, 3)
            def copy(self): return self
        class Generic:
            status = "idle"
            def select(self, frame, box, now): self.status = "tracking"
            def associate_category(self, *args): pass
            def clear(self): self.status = "idle"
        started, release = threading.Event(), threading.Event()
        def detect(*args, **kwargs):
            started.set()
            self.assertTrue(release.wait(2))
            return [{"box": [10, 20, 50, 60]}]
        self.app.frame, self.app.captured_at = Frame(), time.monotonic()
        self.app.detector_names = {39: "bottle"}
        self.app.generic_object = Generic()
        self.app.detect_objects = detect
        _, proposal = self.request("/conversation", {"text": "follow bottle"})
        results = []
        worker = threading.Thread(target=lambda: results.append(self.request(
            "/conversation/confirm", {"proposal_id": proposal["proposal_id"]})))
        worker.start()
        self.assertTrue(started.wait(2))
        try:
            before = time.monotonic()
            _, stopped = self.request("/conversation", {"text": "stop"})
            self.assertLess(time.monotonic() - before, .5)
            self.assertEqual(stopped["status"], "stopped")
        finally:
            release.set()
            worker.join(2)
        self.assertEqual(results[0][1]["status"], "superseded")
        self.assertEqual(self.app.mission["status"], "stopped")
        self.assertEqual(self.app.generic_object.status, "idle")

    def test_stop_during_slow_tracker_initialization_never_installs_candidate(self):
        class Frame:
            shape = (100, 200, 3)
            def copy(self): return self
        started, release = threading.Event(), threading.Event()
        class Generic:
            status = "idle"
            def select(self, frame, box, now):
                started.set()
                release.wait(2)
                self.status = "tracking"
            def associate_category(self, *args): pass
            def clear(self): self.status = "idle"
        self.app.frame, self.app.captured_at = Frame(), time.monotonic()
        self.app.detector_names = {39: "bottle"}
        original = self.app.generic_object = Generic()
        self.app.detect_objects = lambda *a, **kw: [{"box": [10, 20, 50, 60]}]
        _, proposal = self.request("/conversation", {"text": "follow bottle"})
        results = []
        worker = threading.Thread(target=lambda: results.append(self.request(
            "/conversation/confirm", {"proposal_id": proposal["proposal_id"]})))
        worker.start()
        self.assertTrue(started.wait(2))
        try:
            self.assertEqual(self.request("/conversation", {"text": "stop"})[1]["status"], "stopped")
        finally:
            release.set()
            worker.join(2)
        self.assertEqual(results[0][1]["status"], "superseded")
        self.assertIs(self.app.generic_object, original)
        self.assertEqual(original.status, "idle")

    def test_stop_during_speech_discards_late_transcript(self):
        started, release = threading.Event(), threading.Event()
        def transcribe(*args):
            started.set()
            release.wait(2)
            return "follow bottle"
        self.app.transcribe_audio = transcribe
        results = []
        worker = threading.Thread(target=lambda: results.append(self.request(
            "/speech/transcribe", b"audio", {"X-Session-Token": self.app.token, "Content-Type": "audio/wav"})))
        worker.start()
        self.assertTrue(started.wait(2))
        try:
            self.request("/conversation", {"text": "stop"})
        finally:
            release.set()
            worker.join(2)
        self.assertEqual(results[0][1]["mission"]["status"], "superseded")
        self.assertEqual(self.app.conversation.snapshot()["status"], "idle")
        self.assertEqual(self.app.mission["status"], "stopped")

    def test_cancelling_proposal_preserves_established_tracking(self):
        self.app.selection.update([{"id": 1, "box": [0, 0, 50, 90], "confidence": .9}], time.monotonic())
        self.assertTrue(self.app.selection.select(1, time.monotonic()))
        _, proposal = self.request("/conversation", {"text": "count people"})
        _, result = self.request("/conversation/cancel", {})
        self.assertEqual(result["status"], "cancelled")
        self.assertEqual(self.app.selection.selected_id, 1)
        self.assertEqual(self.request("/conversation/confirm", {"proposal_id": proposal["proposal_id"]})[1]["status"], "expired")

    def test_stop_during_slow_language_interpretation_cannot_offer_old_plan(self):
        started, release = threading.Event(), threading.Event()
        def model(*args):
            started.set()
            release.wait(2)
            return validate_semantic_result({"status": "planned", "message": "", "steps": [
                {"action": "follow", "target": "bottle"}]})
        self.app.conversation.interpreter = model
        results = []
        worker = threading.Thread(target=lambda: results.append(self.request(
            "/conversation", {"text": "Please keep track of a bottle"})))
        worker.start()
        self.assertTrue(started.wait(2))
        try:
            self.request("/conversation", {"text": "stop"})
        finally:
            release.set()
            worker.join(2)
        self.assertEqual(results[0][1]["status"], "superseded")
        self.assertEqual(self.app.conversation.snapshot()["status"], "idle")


if __name__ == "__main__":
    unittest.main()
