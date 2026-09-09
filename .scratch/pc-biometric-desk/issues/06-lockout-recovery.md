# 06 — Lockout recovery and durable code rotation

Status: ready-for-agent
Blocked by: 02

**Specification:** [M1 PC biometric desk application](../spec.md)

**What to build:** Guided lockout recovery requiring the valid offline recovery code plus fresh designated-owner Windows verification, with a consistent replacement profile and saved new recovery code.

- [ ] Neither the code nor Windows verification alone allows recovery. Wrong/canceled/unavailable Windows verification and wrong-account cases deny safely.
- [ ] Permit re-enrollment without requiring the failed drone biometrics, but grant no normal-action or arming authorization from recovery.
- [ ] Choose and verify code-verifier storage and bounded guessing controls separately from normal biometric retry controls, using established cryptographic/platform facilities.
- [ ] Prepare and validate replacement enrollment and obtain confirmation of saving the new code before successful completion.
- [ ] Commit the new complete profile, new code verifier and old-code invalidation together; a preliminary failure must not consume the old code.
- [ ] Test interruptions around every durable transition, restart, concurrent reuse and state rollback within the approved intact-host boundary. Before commit only the old committed pair is authoritative; afterward only the new pair is.
- [ ] Preserve the approved no-code-plus-failed-biometric limitation, with no hidden Windows-only ownership reset or indefinite old-code grace period.

This branch uses ticket 02's enrollment/storage foundation and can be developed independently of the normal verification branch. Actual biometric capture still needs consent.
