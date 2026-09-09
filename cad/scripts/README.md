# CAD scripts

- Use standard Python for acquisition metadata, hash checks and neutral-file inspection.
- Put Fusion-hosted Python under `fusion/` only when a real parameterized part or assembly check is ready.
- A Fusion script must expose important dimensions as named parameters, fail on missing/ambiguous components and write a provenance manifest for exports.
- The user approved Issue11 Fusion Python on2026-09-05. Review repository scripts before execution; ordinary scoped engineering needs no repeat permission. Generated geometry must be inspected in Fusion; script success alone is not a fit claim.

`run_fusion_script.py` sends the reviewed file through Autodesk's official loopback MCP, checks project configuration, records its hash/result and never retries an unknown operation. Scripts are under `fusion/`; they modify only the asserted B.G.D. document. Python has Windows-user privileges: path checks and assertions are safeguards, not a sandbox. See [executed evidence and release limits](../engineering-progress-2026-09-05.md).
