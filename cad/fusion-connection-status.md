# Fusion connection and CAD-T01 write-access review

**Superseding authorization, 2026-09-05:** the user explicitly approved general Fusion Python/API execution for B.G.D. Issue11 digital engineering, beyond CAD-T01, through the attainable fabrication-ready package. The frame-only scope, pending execution approval and mandatory frame-stage pause below are historical proposals, superseded by this authorization. The project now allows Read and Execute; Update and Fusion Electronics Read remain excluded as unnecessary. Reviewed scripts may be delivered through the official loopback MCP endpoint while the native tool catalog awaits refresh; this uses the newly authorized capability, not a bypass of a denied operation. Per-call prompts are not assumed to be a security boundary. Preserve Q75/Q74, parallel PC work and unrelated documents. Procurement/spending, physical fabrication/operation, physical firmware upload and destructive/irreversible actions outside the engineering workspace remain unauthorized.

Updated 2026-09-05 after the user's full-app restart and `continue`.

## Current executed state

Official Python execution, units/import checks, partial master modeling, interference analysis, local export and native archive reopening now pass. See [current engineering evidence](engineering-progress-2026-09-05.md). The project allows Read/Execute; the task's loaded native catalog still exposes Read only, so the approved standard-library client delivers reviewed Python to the same official endpoint. No further Python privilege approval is needed for ordinary scoped Issue11 work.

## Historical inspection-only state before execution approval

- The current task exposes exactly one Fusion tool: `mcp__bgd_fusion__fusion_mcp_read`. Previously it exposed none.
- A native tool call, not a diagnostic HTTP request, successfully listed the one active `Untitled` document as unsaved and unmodified.
- A second native call returned official API documentation for Documents, DXF2DImportOptions and FusionUnitsManager. It confirms per-layer DXF import options and internal length units of centimetres, distinct from display units.
- The project configuration still allows only `fusion_mcp_read` and disables Execute, Update and Fusion Electronics Read. The native catalog matches that tool restriction.
- The official Fusion server remains bound to loopback port27182. No third-party bridge is involved.

The task-loading problem is resolved. A loaded inspection tool does not grant modeling or prove a successful import. The current model-visible results do not establish whether a human approval prompt was shown. **Per-call approval enforcement remains unverified; do not rely on it as a safety boundary.**

## Exact remaining permission decision

Autodesk's live catalog exposes geometry authoring, numeric geometry inspection and export through `fusion_mcp_execute`, a general in-process Python executor. It is not a narrowly constrained DXF import tool. Scripts can inherit Fusion's Windows-user filesystem/network privileges; project scope and tool allowlists do not sandbox Python.

Recommended next approval: permit this tool for reviewed, repository-recorded **CAD-T01 frame-reference scripts only**, with explicit acceptance of that privilege breadth and without relying on unproven per-call prompts. No additional package, add-in or operating-system permission is needed. Do not enable it until the user answers this specific decision.

Only these two existing project settings would change:

```toml
enabled_tools = ["fusion_mcp_read", "fusion_mcp_execute"]
disabled_tools = ["fusion_mcp_update", "fusion_mcp_electronics_read"]
```

Keep the existing URL, timeouts and requested prompt mode. Do not add a global server or an automatic approval setting. Actual activation must be rechecked in the native catalog; a file edit alone is not activation. If another app restart is necessary, coordinate it with the PC task rather than interrupting that task.

## Approved-task scope proposed for that permission

1. Record and review each script in `cad/scripts/` before execution. Use the official Fusion API, standard Python libraries and no dynamically downloaded code.
2. Create dedicated B.G.D. test/reference documents. Assert their identities before subsequent changes; never change an unrelated active document. Do not discard or overwrite existing user work.
3. Verify a simple known dimension and unit conversion, then import the pinned Source One DXF. Preserve original coordinates/layers first. Check the source hash and stop on mismatch.
4. Measure imported geometry, identify the front/plate layers, document the final datum/axis mapping, and establish the reference foundation. A timed-out import is an unknown result to inspect, not a reason to blindly repeat it.
5. Write only new, non-overwriting local CAD-T01 evidence/exports under this repository's CAD or ignored hardware-artifact directories. Do not perform cloud saves, external network requests, package installation, process execution or unrelated filesystem operations in these scripts.
6. Stop at the frame-reference review checkpoint. Disable Execute again after the stage. No detailed custom parts, fabrication, hardware purchase, firmware deployment, PC implementation or physical aircraft operation.

These restrictions are engineering operating rules enforced by code review and our actions, not a claim that malicious Python would be contained. The existing source pre-check is still provisional, and all assembled-Z/physical validation requirements remain unchanged.
