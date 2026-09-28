"""One-off sampling ablation for the prepared Qwen3-4B candidate."""

import hashlib
import http.client
import json
from pathlib import Path

from bgd_vision.conversation import LocalSemanticInterpreter, SYSTEM_PROMPT
from bgd_vision.evaluate_language import evaluate


CORPUS = Path("tests/vision/fixtures/conversation-eval.json")
OUTPUT = Path("bgd_vision/evidence/language-qwen3-4b-windows-low-variance-2026-09-22.json")
SAMPLING = {
    "temperature": 0,
    "top_p": 0.8,
    "top_k": 20,
    "min_p": 0,
    "presence_penalty": 0,
    "max_tokens": 300,
    "seed": 42,
}


original_request = http.client.HTTPConnection.request


def low_variance_request(connection, method, url, body=None, headers=None, *, encode_chunked=False):
    if url == "/v1/chat/completions":
        payload = json.loads(body)
        payload.update(SAMPLING)
        body = json.dumps(payload)
    return original_request(connection, method, url, body, headers or {}, encode_chunked=encode_chunked)


http.client.HTTPConnection.request = low_variance_request
cases = json.loads(CORPUS.read_text(encoding="utf-8"))
result = evaluate(LocalSemanticInterpreter(8081, 30), cases)
result.update({
    "corpus": str(CORPUS),
    "timeout_seconds": 30,
    "prompt_sha256": hashlib.sha256(SYSTEM_PROMPT.encode()).hexdigest(),
    "corpus_sha256": hashlib.sha256(CORPUS.read_bytes()).hexdigest(),
    "sampling": SAMPLING,
    "settings_sha256": hashlib.sha256(
        json.dumps(SAMPLING, sort_keys=True, separators=(",", ":")).encode()
    ).hexdigest(),
})
OUTPUT.write_text(json.dumps(result, indent=2) + "\n", encoding="utf-8")
print(json.dumps({key: value for key, value in result.items() if key != "cases"}), flush=True)
