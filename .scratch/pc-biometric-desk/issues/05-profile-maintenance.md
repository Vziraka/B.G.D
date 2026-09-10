# 05 — Profile maintenance and lost-code replacement

**Controlling disposition: retired and dormant.** The standalone PC app and voice-identity check are removed from the finished product by the [scope clarification](../spec.md#controlling-disposition-retired-and-dormant). All content below is dated history. It creates no implementation, testing, validation, packaging, evidence-refresh or reporting task. Repository files, installed software and profiles remain untouched pending any separate removal decision.

Status: wontfix
Blocked by: 03

## Historical checkpoint — September 9

The confirmed PC completion plan authorizes implementation while formal acceptance waits. `Maintenance` and the UI B Account page now implement reference updates and lost-code replacement through the protected helper generation writer. Both existing biometrics and fresh owner Windows verification are required; pending reference/code changes do not grant a desktop action. Synthetic workflow tests cover prerequisites, cancellation, account changes, expiry and uncertain publication replies; native Tk tests cover the separate reference confirmation and code-copy/save paths. An independent security review and installed-helper integration remain in progress. Ticket 03's real speaker mismatch is unresolved, so this checkpoint does not close that dependency or establish real maintenance acceptance.

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
