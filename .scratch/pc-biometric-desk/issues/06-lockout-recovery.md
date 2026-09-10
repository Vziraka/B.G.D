# 06 — Lockout recovery and durable code rotation

**Product scope: retired from active delivery, September 9.** The standalone PC app and voice-identity check are removed from the finished product by the [scope amendment](../spec.md#current-product-scope-standalone-pc-app-retired). The status, dependencies, checkpoints and completion instructions below are historical, not an active PC-product work queue. Preserve code, tests, results and data protections; retirement neither passes unresolved acceptance nor authorizes capture, data deletion or uninstalling anything.

Status: claimed
Blocked by: 02

## Current checkpoint — September 9

The confirmed completion plan authorizes this independent implementation. `Maintenance` and the UI B Recovery page now require fresh designated-owner Windows verification plus the current recovery code, collect replacement references and require copying/saving a new code before conditional generation publication. The old committed profile/code pair remains authoritative before publication. Recovery uses a separate protected retry counter and never grants a desktop action. Synthetic workflow and native Tk tests cover wrong prerequisites, interruption, code acknowledgement and uncertain replies; production recovery has not been exercised and no existing profile or code has been replaced. Installed-helper validation and independent review remain in progress; formal real acceptance is deferred by the owner.

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
