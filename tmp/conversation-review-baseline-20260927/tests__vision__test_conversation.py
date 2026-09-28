import http.client
import json
import threading
import unittest
from unittest.mock import patch

from bgd_vision.conversation import Conversation, LocalSemanticInterpreter, validate_semantic_result


def proposed(action="follow", target="bottle"):
    return {"status": "planned", "message": "", "steps": [{"action": action, "target": target}]}


class ConversationTests(unittest.TestCase):
    def test_confirmation_is_exact_one_use_expiring_and_copy_isolated(self):
        now = [100.0]
        dialog = Conversation(clock=lambda: now[0])
        first = dialog.propose("follow bottle")
        first["interpretation"]["steps"][0]["target"] = "person"
        self.assertEqual(dialog.confirm(first["proposal_id"])["command"], "follow bottle")
        self.assertEqual(dialog.confirm(first["proposal_id"])["status"], "expired")
        second = dialog.propose("count people")
        self.assertEqual(dialog.confirm("incorrect")["status"], "expired")
        self.assertEqual(dialog.confirm("\u00e9")["status"], "expired")
        now[0] += 45
        self.assertEqual(dialog.confirm(second["proposal_id"])["status"], "expired")

    def test_correction_uses_only_pending_steps_and_invalidates_old_confirmation(self):
        seen = []
        def model(text, context):
            seen.append((text, context))
            return validate_semantic_result(proposed(target="bottle" if context is None else "cup"))
        dialog = Conversation(interpreter=model)
        first = dialog.propose("Could you keep track of the bottle?")
        second = dialog.propose("Actually, make that the cup")
        self.assertEqual(seen[1][1], [{"action": "follow", "target": "bottle"}])
        self.assertEqual(dialog.confirm(first["proposal_id"])["status"], "expired")
        self.assertEqual(dialog.confirm(second["proposal_id"])["command"], "follow cup")

    def test_stop_bypasses_busy_model_and_suppresses_late_result(self):
        started, release = threading.Event(), threading.Event()
        def slow_model(text, context):
            started.set()
            self.assertTrue(release.wait(2))
            return validate_semantic_result(proposed())
        dialog, results = Conversation(interpreter=slow_model), []
        thread = threading.Thread(target=lambda: results.append(dialog.propose("track that bottle")))
        thread.start()
        self.assertTrue(started.wait(2))
        try:
            stopped = dialog.propose("Please stop!")
            self.assertEqual(stopped["command"], "stop")
        finally:
            release.set()
            thread.join(2)
        self.assertEqual(results[0]["status"], "superseded")
        self.assertEqual(dialog.snapshot()["status"], "idle")

    def test_ambiguous_failed_or_unsupported_correction_retires_old_plan(self):
        dialog = Conversation()
        first = dialog.propose("follow bottle")
        self.assertEqual(dialog.propose("No, the other one")["status"], "unsupported")
        self.assertEqual(dialog.confirm(first["proposal_id"])["status"], "expired")
        dialog.interpreter = lambda text, context: (_ for _ in ()).throw(ValueError("Unavailable"))
        self.assertEqual(dialog.propose("Could you find my cup?")["status"], "unavailable")

    def test_status_and_unbound_yes_cannot_execute_or_replace_pending_plan(self):
        dialog = Conversation()
        first = dialog.propose("follow bottle")
        self.assertEqual(dialog.propose("status")["status"], "status")
        self.assertNotIn("command", dialog.propose("yes"))
        self.assertEqual(dialog.snapshot()["proposal_id"], first["proposal_id"])

    def test_supported_canonical_commands_round_trip_without_silent_step_loss(self):
        for text, canonical in [("follow me", "follow me"), ("find a bottle", "find object bottle"),
                                ("count people", "count people"), ("follow this object", "follow this object")]:
            with self.subTest(text=text):
                self.assertEqual(Conversation().propose(text)["command"], canonical)
        for text in ["scout", "find a person", "find bottle then follow bottle"]:
            with self.subTest(text=text):
                result = Conversation().propose(text)
                self.assertEqual(result["status"], "unsupported")
                self.assertNotIn("proposal_id", result)
        dialog = Conversation(interpreter=lambda *_: validate_semantic_result(
            proposed(target="bottle then follow me")))
        self.assertEqual(dialog.propose("request")["status"], "clarification_required")

    def test_untrusted_model_cannot_supply_authority_actions_or_extra_fields(self):
        bad = [dict(proposed(), execute=True), proposed("arm", "motors"), proposed("stop", ""),
               proposed(target=""), proposed(target="x" * 161), proposed("status", "bottle"),
               dict(proposed(), status=[]), dict(proposed(), status="unsupported")]
        for payload in bad:
            with self.subTest(payload=payload):
                with self.assertRaises(ValueError):
                    validate_semantic_result(payload)


class LocalModelTests(unittest.TestCase):
    def test_local_request_has_no_images_tools_keys_or_remote_destination(self):
        class Response:
            status = 200
            def read(self, limit):
                return json.dumps({"choices": [{"finish_reason": "stop", "message": {
                    "content": json.dumps(proposed())}}]}).encode()
        with patch("bgd_vision.conversation.http.client.HTTPConnection") as connection:
            connection.return_value.getresponse.return_value = Response()
            result = LocalSemanticInterpreter()("track the bottle", None)
            connection.assert_called_once_with("127.0.0.1", 8081, timeout=8)
            args = connection.return_value.request.call_args.args
            sent = json.loads(args[2])
            self.assertNotIn("tools", sent)
            self.assertEqual(sent["chat_template_kwargs"], {"enable_thinking": False})
            self.assertEqual(set(json.loads(sent["messages"][1]["content"])), {"request", "pending_proposal"})
            self.assertEqual(result["steps"], [{"action": "follow", "target": "bottle"}])
            self.assertFalse(result["executable"])

    def test_truncated_output_connection_failure_and_concurrent_request_fail_closed(self):
        with patch("bgd_vision.conversation.http.client.HTTPConnection") as connection:
            connection.return_value.request.side_effect = http.client.HTTPException("failure")
            with self.assertRaises(ValueError):
                LocalSemanticInterpreter()("request")
            connection.return_value.close.assert_called_once()
        client = LocalSemanticInterpreter()
        client.busy.acquire()
        try:
            with self.assertRaises(ValueError):
                client("request")
        finally:
            client.busy.release()
        with patch("bgd_vision.conversation.http.client.HTTPConnection") as connection:
            response = connection.return_value.getresponse.return_value
            response.status = 200
            response.read.return_value = b'{"choices":[{"finish_reason":"length"}]}'
            with self.assertRaises(ValueError):
                LocalSemanticInterpreter()("request")


if __name__ == "__main__":
    unittest.main()
