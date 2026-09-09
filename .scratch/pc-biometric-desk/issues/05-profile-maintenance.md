# 05 — Profile maintenance and lost-code replacement

Status: ready-for-agent
Blocked by: 03

**Specification:** [M1 PC biometric desk application](../spec.md)

**What to build:** Guided reference updates and lost-code replacement using the existing owner face, voice and fresh designated-owner Windows verification.

- [ ] Updating either biometric reference requires both existing biometrics and fresh owner Windows verification; failure of a required biometric does not silently switch to Windows-only maintenance.
- [ ] Validate replacement enrollment and preserve the last committed complete profile until a durable successful update.
- [ ] Test canceled, failed, concurrent, account-switched and interrupted updates; no partial replacement or ambiguous authoritative profile remains.
- [ ] Ordinary verification never silently learns or rewrites enrollment.
- [ ] Lost-code replacement uses the same approved existing face/voice/Windows prerequisites, leaves enrollment unchanged and invalidates the old code durably on success.
- [ ] Neither maintenance flow grants the ordinary protected action or any aircraft permission; subsequent actions require fresh normal verification.
- [ ] Explain the distinction between routine updates, lost-code replacement and lockout recovery without requesting unnecessary recovery secrets.

Integrated interaction with ticket 04's retry controls is checked in ticket 08; this branch does not change the approved dependency graph.
