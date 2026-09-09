# 04 — Retry, cancellation and restart protection

Status: ready-for-agent
Blocked by: 03

**Specification:** [M1 PC biometric desk application](../spec.md)

**What to build:** The approved temporary waiting and request-expiry behavior, with safe cancellation, device-loss and restart handling that preserves enrollment.

- [ ] Five consecutive failed complete requests cause thirty seconds before each subsequent attempt until full normal verification succeeds and resets the streak; reopening does not clear protection.
- [ ] Define and test attempt counting, including early channel rejection, cancellation after comparison, device faults and interrupted attempts; count a rejected request once and prevent unlimited free comparisons.
- [ ] Enforce one authoritative active-operation policy across application instances; duplicate/concurrent requests cannot bypass waiting or reuse evidence.
- [ ] Expire unfinished normal requests sixty seconds after starting without extending the deadline on input; discard partial success and reject late results.
- [ ] Show understandable wait, cancel, unavailable-device and restart outcomes; preserve enrollment through ordinary interrupted checks.
- [ ] Test clock changes, sleep, restart, damaged state and late callbacks. Do not quietly reset protection, impose a permanent ban, escalate waits or force re-enrollment.
- [ ] Keep the separate approved recovery route available under its own prerequisites; a cooldown is not permission to bypass biometrics or recovery-code controls.

The ten-second normal-success target remains separate from the sixty-second unfinished-request deadline.
