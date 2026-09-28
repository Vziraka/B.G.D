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

    def get(self, path):
        connection = http.client.HTTPConnection("127.0.0.1", self.server.server_port, timeout=3)
        connection.request("GET", path)
        response = connection.getresponse()
        body = response.read()
        result = response.status, body, response.getheader("X-Frame-Meta")
        connection.close()
        return result

    def test_local_model_profile_remains_opt_in_and_disabled_by_default(self):
        self.assertIsNone(self.app.conversation.interpreter)

    def test_http_policy_guard_rejects_mixed_request_before_fake_model_can_return_partial_plan(self):
        calls = []
        self.app.conversation.interpreter = lambda text, context: calls.append(text) or validate_semantic_result({
            "status": "planned", "message": "", "steps": [{"action": "count", "target": "mugs"}]})
        code, result = self.request("/conversation", {"text": "Count mugs, then make a video clip"})
        self.assertEqual(code, 200)
        self.assertEqual(result["status"], "unsupported")
        self.assertEqual(result["interpretation"]["steps"], [])
        self.assertNotIn("proposal_id", result)
        self.assertEqual(calls, [])

    def test_natural_question_about_pending_review_preserves_exact_http_proposal(self):
        def model(text, context):
            if text.casefold() == "follow bottle":
                return validate_semantic_result({"status": "planned", "message": "", "steps": [
                    {"action": "follow", "target": "bottle"}]})
            return validate_semantic_result({"status": "planned", "message": "", "steps": [
                {"action": "status", "target": ""}]})
        self.app.conversation.interpreter = model
        _, proposal = self.request("/conversation", {"text": "follow bottle"})
        self.assertEqual(proposal["status"], "confirmation_required")
        _, status = self.request("/conversation", {"text": "What is awaiting my confirmation?"})
        self.assertEqual(status["status"], "status")
        self.assertEqual(status["pending_proposal"]["proposal_id"], proposal["proposal_id"])
        self.assertEqual(self.app.conversation.snapshot()["proposal_id"], proposal["proposal_id"])

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
        class Generic:
            status = "tracking"
            def clear(self): self.status = "idle"
            def snapshot(self, now): return {"status": self.status, "box": None, "reason": "test"}
        self.app.generic_object = Generic()
        now = time.monotonic()
        self.app.selection.update([{"id": 1, "box": [0, 0, 50, 90], "confidence": .9}], now)
        self.assertTrue(self.app.selection.select(1, now))
        results = []
        worker = threading.Thread(target=lambda: results.append(self.request(
            "/conversation", {"text": "Please keep track of a bottle"})))
        worker.start()
        self.assertTrue(started.wait(2))
        try:
            before = time.monotonic()
            _, stopped = self.request("/conversation", {"text": "Could you halt the mission now?"})
            self.assertLess(time.monotonic() - before, .5)
            self.assertEqual(stopped["status"], "stopped")
        finally:
            release.set()
            worker.join(2)
        self.assertEqual(results[0][1]["status"], "superseded")
        self.assertEqual(self.app.conversation.snapshot()["status"], "idle")
        self.assertEqual(self.app.generic_object.status, "idle")
        self.assertIsNone(self.app.selection.selected_id)

    def test_model_interpreted_status_reports_stale_and_lost_state_and_preserves_pending(self):
        _, proposal = self.request("/conversation", {"text": "follow bottle"})
        self.app.conversation.interpreter = lambda *_: validate_semantic_result({
            "status": "planned", "message": "", "steps": [{"action": "status", "target": ""}]})
        old = time.monotonic() - 2
        self.app.captured_at = old
        self.app.vision_at = old
        self.app.frame = object()
        self.app.selection.update([{"id": 9, "box": [1, 2, 30, 40], "confidence": .9}], old)
        self.app.selection.selected_id = 9
        self.app.selection.status = "Tracking"
        self.app.generic_object.status = "lost"
        self.app.generic_object.reason = "Could not safely reacquire the selected bottle."
        self.app.mission = self.app._mission_result("complete", "The previous count was two.", value=2)
        _, status = self.request("/conversation", {"text": "How is the camera doing at the moment?"})
        self.assertEqual(status["status"], "status")
        self.assertEqual(status["camera"]["freshness"], "stale")
        self.assertEqual(status["person_tracking"]["status"], "Lost")
        self.assertIsNone(status["person_tracking"]["visible_count"])
        self.assertEqual(status["object_tracking"]["status"], "lost")
        self.assertEqual(status["last_mission"]["message"], "The previous count was two.")
        self.assertIn("awaiting your confirmation", status["message"])
        self.assertEqual(status["pending_proposal"]["proposal_id"], proposal["proposal_id"])
        self.assertEqual(self.app.conversation.snapshot()["proposal_id"], proposal["proposal_id"])

    def test_fresh_camera_with_reacquiring_object_reports_untrusted_search_not_stale(self):
        class SearchingObject:
            def snapshot(self, now):
                return {"status": "reacquiring", "box": None,
                        "reason": "Searching near the last position; no target box is trusted."}
        now = time.monotonic()
        self.app.frame = object()
        self.app.captured_at = now
        self.app.vision_at = now
        self.app.generic_object = SearchingObject()
        self.app.conversation.interpreter = lambda *_: validate_semantic_result({
            "status": "planned", "message": "", "steps": [{"action": "status", "target": ""}]})
        _, status = self.request("/conversation", {"text": "How is the camera doing at the moment?"})
        self.assertEqual(status["camera"]["freshness"], "fresh")
        self.assertEqual(status["object_tracking"]["freshness"], "searching")
        self.assertFalse(status["object_tracking"]["box_trusted"])
        self.assertIn("no target box is trusted", status["message"])

    def test_public_status_and_frame_metadata_never_expose_pending_proposal_id(self):
        _, proposal = self.request("/conversation", {"text": "follow bottle"})
        self.app.sequence = 1
        self.app.jpeg = b"jpeg"
        self.app.frame = object()
        self.app.captured_at = time.monotonic()
        self.app.vision_at = self.app.captured_at
        status_code, status_body, _ = self.get("/status")
        self.assertEqual(status_code, 200)
        self.assertNotIn(proposal["proposal_id"], status_body.decode())
        frame_code, _, metadata = self.get("/frame?after=0")
        self.assertEqual(frame_code, 200)
        self.assertIsNotNone(metadata)
        self.assertNotIn(proposal["proposal_id"], metadata)

    def test_described_human_target_is_guarded_before_generic_object_detector(self):
        class Frame:
            shape = (100, 200, 3)
            def copy(self): return self
        now = time.monotonic()
        self.app.frame = Frame()
        self.app.captured_at = now
        self.app.detector_names = {0: "person"}
        called = []
        self.app.detect_objects = lambda *args, **kwargs: called.append(True)
        result = self.app.run_mission("follow a person wearing a blue shirt")
        self.assertEqual(result["status"], "clarification_required")
        self.assertIn("select the person", result["message"].lower())
        self.assertEqual(called, [])


if __name__ == "__main__":
    unittest.main()
