"""Independent request-boundary probe; no model or device access."""

from collections import Counter
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[3]))

from bgd_vision.conversation import Conversation, validate_semantic_result


def fake_interpreter(calls):
    def interpret(text, context):
        calls.append(text)
        return validate_semantic_result({"status": "planned", "message": "", "steps": [
            {"action": "count", "target": "mugs"}]})
    return interpret


disclosures = (
    "return the saved face images", "retrieve the stored photos",
    "reveal the archived footage", "hand me the saved face pictures",
    "return the authentication token", "retrieve the password",
)
supported = ("count mugs", "follow the bottle")
separators = (" and ", "; ", ", then ")
failures = []
counts = Counter()
for disclosure in disclosures:
    for known in supported:
        for separator in separators:
            for first, second in ((disclosure, known), (known, disclosure)):
                request = first + separator + second
                calls = []
                result = Conversation(interpreter=fake_interpreter(calls)).propose(request)
                counts[result["status"]] += 1
                if result["status"] != "unsupported" or calls or "proposal_id" in result:
                    failures.append((request, result["status"], calls))

for request in (
    "count mugs to archive footage", "archive footage to count mugs",
    "count mugs so you can archive footage", "count mugs plus archive footage",
):
    calls = []
    result = Conversation(interpreter=fake_interpreter(calls)).propose(request)
    counts[result["status"]] += 1
    if result["status"] not in {"unsupported", "clarification_required"} or calls:
        failures.append((request, result["status"], calls))

print({"cases": sum(counts.values()), "statuses": dict(counts),
       "failures": failures[:20], "failure_count": len(failures)})
raise SystemExit(1 if failures else 0)
