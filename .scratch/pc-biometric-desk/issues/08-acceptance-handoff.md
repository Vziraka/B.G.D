# 08 — Acceptance evaluation and local handoff

**Product scope: retired from active delivery, September 9.** The standalone PC app and voice-identity check are removed from the finished product by the [scope amendment](../spec.md#current-product-scope-standalone-pc-app-retired). The status, dependencies, checkpoints and completion instructions below are historical, not an active PC-product work queue. Preserve code, tests, results and data protections; retirement neither passes unresolved acceptance nor authorizes capture, data deletion or uninstalling anything.

Status: ready-for-agent
Blocked by: 05, 06, 07

## Current checkpoint — September 9

The owner chose implementation first and formal trials later. Offline snapshot packaging and the protected service installation/update/removal lifecycle are being built and tested. This does not mark the five-day trial or any attack/state acceptance criterion passed. The current local Git checkpoint is `9805c67`; subsequent implementation remains uncommitted. Hardware work is paused for the separately planned 3D-printing change.

**Specification:** [M1 PC biometric desk application](../spec.md)

**What to build:** A versioned integrated PC application with frozen, consented usability/security/state evaluation results and reproducible local usage/maintenance instructions.

- [ ] Integrate all approved branches and freeze versions, configuration, profile, prompts, thresholds, device paths, ordinary-use conditions and a meaningful coverage matrix before final evaluation.
- [ ] Run the approved 100 fresh first attempts over five days, twenty per day in two sessions of ten: at least 95 authorize and every successful baseline trial completes within ten seconds including prompts.
- [ ] Keep failed first attempts, slow successes, retries, timeouts and predeclared exclusions visible; measure complete normal enrollment separately against five minutes after installation.
- [ ] Evaluate the agreed consenting nonowners and required spoof/substitution coverage with working controls. No missing evidence or unauthorized approval is a pass.
- [ ] Verify setup, update, lost-code replacement, lockout recovery, privacy/storage, cooldown, timeout, restart, concurrency and replay behavior on the integrated version, including cross-workflow interactions.
- [ ] After fixes, preserve regression evidence and use fresh held-out sessions/material for confirmation; do not claim a true population success rate or immunity from a finite sample.
- [ ] Provide reproducible offline installation/launch/check instructions, approved data handling, configuration provenance and clear known limitations. Incomplete results stay visibly incomplete.
- [ ] State explicitly that PC acceptance does not close the aircraft issue, complete M1 alone, validate motor arming or establish a full $900 build.

Real sessions require their concrete individual consent/data plan. Numerical retention suggestions in prior research are not approved defaults.
