"""Small fail-closed command interpreter for the desk prototype."""

import re


ACTION = re.compile(r"\s+(?:and\s+)?then\s+|\s+and\s+(?=(?:follow|find|count|scout|stop|status)\b)|\s*;\s*")


def interpret_command(text):
    if not isinstance(text, str):
        raise ValueError("Command text must be a string")
    text = re.sub(r"\s+", " ", text.strip()).rstrip(".!?")
    if not text:
        raise ValueError("Enter a command")
    if len(text) > 240:
        raise ValueError("Command is too long")

    clauses = [clause.strip() for clause in ACTION.split(text.casefold()) if clause.strip()]
    if not clauses or len(clauses) > 4:
        raise ValueError("Use one to four supported actions")

    steps = []
    for clause in clauses:
        step = _parse_clause(clause)
        if "question" in step:
            return _result("clarification_required", step["question"])
        if "error" in step:
            return _result("unsupported", step["error"])
        steps.append(step)

    if len(steps) > 1 and any(step["action"] == "stop" for step in steps):
        return _result("clarification_required", "Stop must be sent by itself.")
    summary = " → ".join(_describe(step) for step in steps)
    return _result("planned", f"Diagnostic plan: {summary}.", steps)


def _parse_clause(clause):
    if clause in {"status", "report status", "what is your status"}:
        return {"action": "status"}
    if clause in {"stop", "cancel", "cancel mission", "stop mission"}:
        return {"action": "stop"}
    if clause.startswith("follow "):
        target = clause[7:].strip()
        return {"action": "follow", "target": target} if target else {"question": "Who should be followed?"}
    if clause == "find":
        return {"question": "Are you looking for a person or an object?"}
    if clause.startswith("find "):
        target = clause[5:].strip()
        if target == "me":
            return {"action": "find_person", "target": "me"}
        person = re.fullmatch(r"(?:a |the )?(?:person|someone)(?: (.+))?", target)
        if person:
            return {"action": "find_person", "target": person.group(1) or "unspecified person"}
        item = re.fullmatch(r"(?:an? |the )?(?:object|item)(?: (.+))?", target)
        if item:
            return {"action": "find_object", "target": item.group(1) or "unspecified object"}
        if not target.startswith("my "):
            return {"action": "find_object", "target": re.sub(r"^(?:this|that|the|an?) ", "", target)}
        return {"question": "Are you looking for a person or an object?"}
    if clause.startswith("count "):
        target = clause[6:].strip()
        target = re.sub(r"^(?:the )?(?:amount|number) of ", "", target)
        target = re.sub(r"\bpeopel\b", "people", target)
        return {"action": "count", "target": target} if target else {"question": "What should be counted?"}
    if clause in {"scout", "scout area", "scout the area"}:
        return {"action": "scout"}
    return {"error": "That request is unsupported. Try follow, find, count, scout, status, or stop."}


def _describe(step):
    labels = {"find_person": "find person", "find_object": "find object"}
    label = labels.get(step["action"], step["action"])
    return f'{label} “{step["target"]}”' if "target" in step else label


def _result(status, message, steps=None):
    return {
        "status": status,
        "message": message,
        "steps": steps or [],
        "executable": False,
        "authority": "DIAGNOSTIC_ONLY",
    }
