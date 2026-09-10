# 04 — Retry, cancellation and restart protection

**Controlling disposition: retired and dormant.** The standalone PC app and voice-identity check are removed from the finished product by the [scope clarification](../spec.md#controlling-disposition-retired-and-dormant). All content below is dated history. It creates no implementation, testing, validation, packaging, evidence-refresh or reporting task. Repository files, installed software and profiles remain untouched pending any separate removal decision.

Status: wontfix
Blocked by: 03

## Historical checkpoint

September 9: the owner confirmed the full PC completion plan, including a protected local helper service and implementation before formal acceptance. Foundational protected-state and retry work is active. Ticket03 real verification evidence remains unresolved; this parallel preparation does not resolve its dependency or claim integrated acceptance. The main agent owns integration; bounded agents own the broker state machine and capture-device selection.

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
