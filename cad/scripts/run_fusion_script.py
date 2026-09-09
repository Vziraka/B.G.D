"""Send a reviewed repository script to Autodesk's official loopback MCP.

No dependency installation, background listener, or automatic retry. A timeout
means the Fusion operation may still be running: inspect before doing more.
"""
import argparse
from datetime import datetime, timezone
import hashlib
import json
from pathlib import Path
import tomllib
import urllib.request

ROOT = Path(__file__).resolve().parents[2]
SCRIPTS = ROOT / "cad/scripts/fusion"
URL = "http://127.0.0.1:27182/mcp"


def main():
    parser = argparse.ArgumentParser(__doc__)
    parser.add_argument("script", type=Path)
    args = parser.parse_args()
    source = args.script.resolve()
    if not source.is_relative_to(SCRIPTS.resolve()) or source.suffix != ".py":
        raise SystemExit("Only reviewed cad/scripts/fusion/*.py files may be sent")
    cfg = tomllib.loads((ROOT / ".codex/config.toml").read_text())["mcp_servers"]["bgd_fusion"]
    if (cfg.get("url") != URL or not cfg.get("enabled")
            or "fusion_mcp_execute" not in cfg.get("enabled_tools", [])
            or "fusion_mcp_execute" in cfg.get("disabled_tools", [])):
        raise SystemExit("Project configuration does not authorize this endpoint/tool")
    code = source.read_text(encoding="utf-8")
    headers = {"Content-Type": "application/json", "Accept": "application/json, text/event-stream"}

    def request(payload):
        req = urllib.request.Request(URL, json.dumps(payload).encode(), headers)
        with urllib.request.urlopen(req, timeout=120) as response:
            session = response.headers.get("MCP-Session-Id")
            if session:
                headers["MCP-Session-Id"] = session
            body = response.read()
            return json.loads(body) if body else None

    init = request({"jsonrpc": "2.0", "id": 1, "method": "initialize", "params": {
        "protocolVersion": "2025-03-26", "capabilities": {},
        "clientInfo": {"name": "BGD reviewed engineering scripts", "version": "1.0"}}})
    if "error" in init:
        raise SystemExit(json.dumps(init))
    headers["MCP-Protocol-Version"] = init["result"]["protocolVersion"]
    request({"jsonrpc": "2.0", "method": "notifications/initialized"})
    print(json.dumps({"script": str(source.relative_to(ROOT)),
                      "sha256": hashlib.sha256(source.read_bytes()).hexdigest()}), flush=True)
    result = request({"jsonrpc": "2.0", "id": 2, "method": "tools/call", "params": {
        "name": "fusion_mcp_execute", "arguments": {"featureType": "script", "object": {"script": code}}}})
    log_dir = ROOT / ".scratch/hardware-artifacts/fusion-runs"
    log_dir.mkdir(parents=True, exist_ok=True)
    log = log_dir / (datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%S%fZ") + "-" + source.stem + ".json")
    with log.open("x", encoding="utf-8") as handle:
        json.dump({"script": str(source.relative_to(ROOT)),
                   "sha256": hashlib.sha256(source.read_bytes()).hexdigest(), "response": result}, handle, indent=2)
    print("Execution evidence: " + str(log), flush=True)
    print(json.dumps(result, ensure_ascii=True), flush=True)
    if "error" in result or result.get("result", {}).get("isError"):
        raise SystemExit(1)
    for content in result.get("result", {}).get("content", []):
        if content.get("type") == "text":
            try:
                payload = json.loads(content["text"])
            except json.JSONDecodeError:
                continue
            if payload.get("success") is False:
                raise SystemExit(1)


if __name__ == "__main__":
    main()
