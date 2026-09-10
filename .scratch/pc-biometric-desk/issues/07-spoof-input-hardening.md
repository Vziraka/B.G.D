# 07 — Replay and substituted-input hardening

**Product scope: retired from active delivery, September 9.** The standalone PC app and voice-identity check are removed from the finished product by the [scope amendment](../spec.md#current-product-scope-standalone-pc-app-retired). The status, dependencies, checkpoints and completion instructions below are historical, not an active PC-product work queue. Preserve code, tests, results and data protections; retirement neither passes unresolved acceptance nor authorizes capture, data deletion or uninstalling anything.

Status: ready-for-agent
Blocked by: 04

**Specification:** [M1 PC biometric desk application](../spec.md)

**What to build:** The ordinary verification workflow hardened against the agreed physical replay, generated/converted voice and actual supported camera/microphone substitution threats.

- [ ] Establish a realistic threat-to-test matrix for the implemented challenges and supported capture paths before final evaluation; document attacker access assumptions under the intact-host/verifier boundary.
- [ ] Exercise owner-targeted photographs and video, recorded voice and consented generated/converted voice with meaningful varied source material.
- [ ] Exercise actual camera-only, microphone-only and paired digital substitution routes; file-to-model component tests are not a replacement.
- [ ] Include working legitimate positive controls, isolated-channel attacks with the other genuine channel supplied by the owner, and applicable combined attacks; record component and full-gate outcomes distinctly.
- [ ] Use only specifically consented assets/tools under an agreed local data/deletion plan. No participant contact, recording, cloud upload or voice synthesis is preauthorized by publication.
- [ ] An unauthorized approval blocks sign-off until fixed/retested. Missing mandatory coverage/tools/consent or a nonworking input path means incomplete; rejecting all users is not protection.
- [ ] Do not use the earlier ninety-attempt exploratory outline as a security pass quota, certification or universal risk estimate; preserve the genuine-owner usability requirements during hardening.

Record limitations honestly and carry regression evidence to the integrated acceptance work. Recognition alone never completes this ticket.
