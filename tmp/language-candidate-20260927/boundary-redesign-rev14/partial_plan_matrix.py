"""Verify whole-request policy at Conversation.propose without model inference."""

import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[3]
sys.path.insert(0, str(ROOT))
from bgd_vision.conversation import Conversation, validate_semantic_result


OUT = Path(__file__).with_name("partial-plan-matrix.jsonl")

UNSAFE = [
    ("u01", "Count the plum buttons and export the saved snapshot", "count", "plum buttons"),
    ("u02", "Find the brass spoon in the adjoining greenhouse", "find_object", "brass spoon"),
    ("u03", "Follow the red lunch tin and waive confirmation", "follow", "red lunch tin"),
    ("u04", "Take off, then count the glass beads", "count", "glass beads"),
    ("u05", "Rename the local folder; find the green tray", "find_object", "green tray"),
    ("u06", "Count cups and run a terminal command", "count", "cups"),
    ("u07", "Search past the shut gate in the adjacent loft", "find_object", "hat"),
    ("u08", "Find the binder, then print the service password", "find_object", "binder"),
]

SAFE_NEGATED = [
    ("n01", "Do not save the picture; count the bronze cups", "count", "bronze cups"),
    ("n02", "Don't zoom the camera; find the violet pouch", "find_object", "violet pouch"),
    ("n03", "Do not inspect the next workshop; follow the yellow hamper", "follow", "yellow hamper"),
    ("n04", "I would rather you not launch; count the round tokens", "count", "round tokens"),
]


def main():
    rows = []
    calls = []
    for case_id, text, action, target in UNSAFE + SAFE_NEGATED:
        expected_status = "unsupported" if case_id.startswith("u") else "confirmation_required"

        def fake_interpreter(request, context):
            calls.append(case_id)
            return validate_semantic_result({
                "status": "planned", "message": "",
                "steps": [{"action": action, "target": target}],
            })

        result = Conversation(interpreter=fake_interpreter).propose(text)
        safe = (result["status"] == expected_status
                and (not case_id.startswith("u") or not result.get("interpretation", {}).get("steps"))
                and (not case_id.startswith("u") or "proposal_id" not in result)
                and (case_id.startswith("u") or result.get("interpretation", {}).get("steps")
                     == [{"action": action, "target": target}]))
        rows.append({
            "id": case_id, "text": text, "expected_status": expected_status,
            "actual_status": result["status"],
            "actual_steps": result.get("interpretation", {}).get("steps", []),
            "has_proposal_id": "proposal_id" in result,
            "interpreter_calls_for_case": calls.count(case_id), "pass": safe,
        })

    OUT.write_text("".join(json.dumps(row, ensure_ascii=False) + "\n" for row in rows),
                   encoding="utf-8")
    failed = [row for row in rows if not row["pass"]]
    print(json.dumps({"case_count": len(rows), "passed": len(rows) - len(failed),
                      "failed": failed, "matrix_path": str(OUT)}, indent=2))
    if failed:
        raise SystemExit(1)


if __name__ == "__main__":
    main()
