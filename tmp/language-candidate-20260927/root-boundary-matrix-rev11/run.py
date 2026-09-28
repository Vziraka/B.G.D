"""Probe partial-plan refusal when an interpreter proposes only the first clause."""

import hashlib
import json
from pathlib import Path
import sys

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[2]
sys.path.insert(0, str(ROOT))

from bgd_vision import conversation

BASES = [
    ("Follow the blue bag", "follow", "blue bag"),
    ("Find the yellow cup", "find_object", "yellow cup"),
    ("Count the green boxes", "count", "green boxes"),
    ("Watch the orange bottle", "follow", "orange bottle"),
    ("Locate the striped tote", "find_object", "striped tote"),
    ("Count the silver hooks", "count", "silver hooks"),
    ("Track the red notebook", "follow", "red notebook"),
    ("Find the wooden bowl", "find_object", "wooden bowl"),
]
UNAVAILABLE = [
    "save the camera feed",
    "upload a photo",
    "open the saved logs",
    "use the terminal",
    "skip the confirmation card",
    "launch the drone",
    "scan inside the next room",
    "send the image to my friend",
]


def main():
    output = HERE / "result.json"
    if output.exists():
        raise FileExistsError("Refusing to overwrite boundary evidence")
    rows = []
    for base, action, target in BASES:
        for suffix in UNAVAILABLE:
            request = f"{base} and {suffix}"

            def partial_interpreter(_text, _context):
                return conversation.validate_semantic_result({
                    "status": "planned", "message": "", "steps": [
                        {"action": action, "target": target}]})

            result = conversation.Conversation(interpreter=partial_interpreter).propose(request)
            rows.append({"request": request, "status": result["status"],
                         "proposal_id_present": "proposal_id" in result,
                         "pass": result["status"] != "confirmation_required"
                                 and "proposal_id" not in result})
    source = ROOT / "bgd_vision/conversation.py"
    evidence = {"purpose": "No partial plan for a mixed supported/unavailable request",
                "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
                "cases": len(rows), "passed": sum(row["pass"] for row in rows),
                "failed": [row for row in rows if not row["pass"]],
                "rows": rows}
    output.write_text(json.dumps(evidence, indent=2) + "\n", encoding="utf-8")
    print(json.dumps({key: value for key, value in evidence.items() if key != "rows"}))


if __name__ == "__main__":
    main()
