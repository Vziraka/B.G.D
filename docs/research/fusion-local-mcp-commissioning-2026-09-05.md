# Official local Fusion MCP commissioning — 2026-09-05

Status: **official endpoint and inspection calls verified; native Codex task attachment and approval enforcement not yet verified; modeling disabled**.

This follows the user's "Approve" for the limited setup proposed in the [integration investigation](fusion-kicad-codex-integration-2026-09-05.md). That investigation remains a historical pre-commissioning record. Work occurred in the shared main checkout at base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`; these documents/configuration are uncommitted. No PC Ticket 2 files or unrelated changes were edited.

## Completed setup and evidence

1. Opened installed Autodesk Fusion 2704.1.53, under its existing Education license. Did not accept the separate Autodesk Assistant Tech Preview invitation.
2. Enabled **Preferences → General → API → Fusion MCP Server (runs locally on this device)**, retaining port 27182. Applied the setting.
3. Windows reported the listener at **127.0.0.1:27182**, owned by the installed Fusion360 process. No bind-all or LAN listener was configured. This does not audit Fusion's unrelated network activity.
4. Initialized `http://127.0.0.1:27182/mcp` using MCP protocol `2025-03-26`. The server identified itself as `MCP Server Adapter` version `1.0.0`; it supplied a session ID and advertised tools/resources. Sent the initialized notification and successfully enumerated four tools.
5. Successfully called the official read tool: initially zero open documents; after creating a disposable blank Hybrid Design in millimetres through Fusion's UI, one active, unsaved, unmodified `Untitled` document. No existing document was changed and no cloud save was performed.
6. Successfully queried the official API documentation through MCP for DXF import and native archive export. This verifies documentation access, **not execution of those APIs**.
7. Created [the B.G.D. project configuration](../../.codex/config.toml). Installed `codex-cli 0.148.0` successfully reads `bgd_fusion` from this checkout as enabled Streamable HTTP with the exact tool allowlist/blocklist below. No global Codex configuration or trust setting was changed.

The HTTP calls above were commissioning diagnostics through the official endpoint, not tools loaded into this running task's native catalog. They do not exercise Codex's tool-approval UI. No direct HTTP modeling call was used to bypass the disabled write tool.

## Actual live tools

| Tool | Live capability | Project profile |
|---|---|---|
| `fusion_mcp_read` | API documentation; screenshots; open/recent/search document lists; projects; active command | Allowed, prompt mode requested |
| `fusion_mcp_execute` | In-process Python scripts; document open/close/save | Disabled |
| `fusion_mcp_update` | Undo/redo | Disabled |
| `fusion_mcp_electronics_read` | Fusion Electronics entity queries | Disabled; KiCad is our electrical route |

The actual installation uses the script-oriented schema, not the much larger typed Create/Read/Update catalog found among bundled alternatives. There is no dedicated typed sketch, component or DXF-import tool in this live catalog. Automation of geometry creation, numeric inspection and exports consequently needs the **general Python execution tool**, or the traditional manually invoked official API route.

Correction to a conservative investigation concern: the live Read tool's `document`/`open` operation **lists open documents**; it does not open a file. A screenshot with a requested direction can change the view, and project/file searches can reveal account-wide metadata. The allowed read tool is therefore not a project-confined data boundary. Use current-view screenshots and B.G.D. search filters; do not enumerate unrelated account data.

## Security and incomplete commissioning gate

The project file limits which tools a correctly loaded client exposes. It does not restrict which local processes can reach Fusion, which documents Fusion can access, or Python's Windows-user privileges. No authentication was required by the tested loopback endpoint; an MCP session ID is not authentication. Fusion must remain running for access. This is an application connection, **not an OS sandbox**.

`enabled_tools = ["fusion_mcp_read"]` and the explicit disabled tool names are recognized by `codex mcp get bgd_fusion --json`. The file requests `default_tools_approval_mode = "prompt"`. This running task's available tool catalog has no Fusion entry. Therefore native-client attachment, allowlist enforcement and actual prompts have **not** been tested. Configuration parsing alone must not be recorded as approval enforcement.

Do not restart another task or the entire Codex app to test this. On the next hardware-task turn, inspect whether its tools have refreshed; if not, reload/reopen only this hardware task using the app's supported controls. Then perform a read call through the native tool and verify the configured prompt behavior before enabling writes. Do not spawn another model run merely to simulate this check.

The approved setup proposal explicitly kept general script execution behind a privilege review. That review now confirms it can execute Python with Fusion's user rights, including filesystem/network operations; a narrow tool name cannot confine those operations. Leave it disabled pending explicit approval of that capability and verification of the client control, or use the approved manual Fusion workflow. Any future B.G.D. script must identify its target document, validate the pinned source hash, confine its own file paths, refuse overwrites, make serialized changes and return measurements. These are reviewed-code safeguards, not enforced containment against malicious Python.

## CAD-T01 continuation prepared

Re-ran and corrected the existing provisional [source verifier](../../cad/scripts/verify_source_one_frame.py) and [measurement report](../../cad/reference/source-one-v6-7in/frame-2d-verification.json):

- Parse drawing `ENTITIES` separately from block definitions; do not silently count block-local circles as placed geometry.
- Calculate four edge pitches from matched structural-layer circle centers, rather than repeating expected 20/30.5 mm values as measurements.
- Label vertex bounds and chord-polygon areas as approximations where DXF bulge arcs are not evaluated.
- Correct the proposed axis handedness: **forward/left/up** is right-handed; forward/right/up is left-handed. Front orientation and final datum remain provisional pending frame inspection. The earlier architecture-stage transform was reflected relative to the raw DXF plane and is not an approved Fusion transform.

The corrected source pre-check passes the pinned hash/identity, declared millimetres, motor symmetry, common-circle check and both central mounting patterns. The separate architecture manifest checker also passes its 61 inventory/13 custom-work/27 digital-check consistency checks. Neither check validates a Fusion import, physical plate identities, assembled Z or the aircraft.

No DXF was imported, no BGD_MASTER was created, no CAD archive was exported, and no dimensioned fabrication drawing was released. The blank connection-test document is not the frame reference. The CAD-T01 workflow and next required decisions are recorded in the [continuation note](../../cad/reference/source-one-v6-7in/import-readiness.md).

## Scope preserved and reversal

No third-party packages, bridges or add-ins were installed. Fusion Data MCP, KiCad settings, procurement, physical hardware and PC implementation were untouched. Q75 and Q74 remain unchanged. Issue 11 remains claimed, not complete.

To stop access after a CAD session, turn off the same Fusion MCP preference; the project configuration can remain for the next session. To disable this project's client discovery, set its `enabled` field to `false`. Neither action requires deleting existing engineering work. The endpoint was left enabled for the approved commissioning/continuation; the general write tool remains disabled.

## References

- [Autodesk Fusion MCP overview](https://help.autodesk.com/view/fusion360/ENU/?guid=FMCP-OVERVIEW).
- [Codex MCP configuration](https://learn.chatgpt.com/docs/extend/mcp).
- [Codex configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference).
- [Commissioning evidence](fusion-local-mcp-commissioning-evidence-2026-09-05.json): captured live tool schemas, diagnostic responses, listener observation and configuration hash. No authentication secrets/session ID are retained in that record.
