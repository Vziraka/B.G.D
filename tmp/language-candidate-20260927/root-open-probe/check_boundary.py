"""Independent matrix for partial-proposal exposure; no model or device access."""

from collections import Counter
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[3]))

from bgd_vision.conversation import Conversation, validate_semantic_result


unknown = ("paint the wall", "archive footage", "play music", "dim lights", "sort papers")
known = (("follow the bottle", "follow", "bottle"),
         ("count mugs", "count", "mugs"))
separators = (" and ", " then ", "; ", ", ", ". ", ": ", " while ",
              " before ", " after ", " during ")
failures = []
counts = Counter()
for unsupported in unknown:
    for supported, action, target in known:
        for separator in separators:
            for first, second in ((unsupported, supported), (supported, unsupported)):
                request = first + separator + second
                payload = {"status": "planned", "message": "", "steps": [
                    {"action": action, "target": target}]}
                calls = []
                def interpreter(text, context):
                    calls.append(text)
                    return validate_semantic_result(payload)
                result = Conversation(interpreter=interpreter).propose(request)
                counts[result["status"]] += 1
                if result["status"] not in {"clarification_required", "unsupported"}:
                    failures.append((request, result["status"], calls))

print({"tested": sum(counts.values()), "statuses": dict(counts),
       "partial_proposals": failures[:20], "failure_count": len(failures)})
raise SystemExit(1 if failures else 0)
