"""Create the single bounded Rev12 prompt comparison variant."""

from pathlib import Path

HERE = Path(__file__).resolve().parent
baseline = (HERE / "prompt-baseline.txt").read_text(encoding="utf-8")
old_count_rule = "For people counts use 'people'."
new_count_rule = (
    "For an unqualified count of people use 'people'; preserve a condition or location "
    "that narrows which people are counted."
)
if baseline.count(old_count_rule) != 1:
    raise SystemExit("The Rev11 count rule was not found exactly once")

candidate = baseline.replace(old_count_rule, new_count_rule)
candidate += (
    "\nLocation questions: when a request asks where a named person or object is, or "
    "which visible part or region contains it, propose a find step using that named "
    "target. Do not ask whether the user wants it found, and do not claim its location. "
    "Questions about current tracking or how a prior task turned out request one "
    "read-only status step. A request to survey the whole current camera view without "
    "a named subject may use targetless scout; keep a named subject as a named action.\n"
)
(HERE / "prompt-candidate.txt").write_text(candidate, encoding="utf-8", newline="\n")
