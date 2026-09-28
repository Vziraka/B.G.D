"""Temporary frozen30 runner: production prompt, with only /no_think removed."""

from pathlib import Path
import sys


sys.path.insert(0, str(Path(__file__).resolve().parents[2]))

from bgd_vision import conversation


if not conversation.SYSTEM_PROMPT.endswith(" /no_think"):
    raise RuntimeError("The baseline prompt suffix changed; refusing an unpinned run")

conversation.SYSTEM_PROMPT = conversation.SYSTEM_PROMPT.removesuffix(" /no_think")

from bgd_vision import evaluate_language


if evaluate_language.SYSTEM_PROMPT != conversation.SYSTEM_PROMPT:
    raise RuntimeError("Evaluator did not receive the pinned candidate prompt")


if __name__ == "__main__":
    raise SystemExit(evaluate_language.main())
