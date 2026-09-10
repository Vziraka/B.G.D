# 01 — Offline app launch and readiness

**Controlling disposition: retired and dormant.** The standalone PC app and voice-identity check are removed from the finished product by the [scope clarification](../spec.md#controlling-disposition-retired-and-dormant). All content below is dated history. It creates no implementation, testing, validation, packaging, evidence-refresh or reporting task. Repository files, installed software and profiles remain untouched pending any separate removal decision.

Status: resolved
Blocked by: None

**Specification:** [M1 PC biometric desk application](../spec.md)

**What to build:** A runnable Windows desktop app that shows whether its local dependencies and device/Windows interfaces are ready, missing or unverified, without automatically starting capture or claiming successful biometric verification.

- [x] Select and document a minimal Windows-compatible application/model stack, exact initial versions, offline installation approach, license/use assumptions and resource limitations; no paid dependency or extra hardware is assumed approved.
- [x] Launch through one documented local command or entry point; after installation, readiness checks do not require an online service.
- [x] Show actionable missing/unverified model, camera, microphone and Windows-verification states without mistaking device enumeration for validated access or liveness.
- [x] Keep camera/microphone capture off until an explicitly initiated and authorized workflow; readiness inspection alone does not enroll the owner.
- [x] Missing or failed prerequisites cannot show an authorized result. There is no aircraft connection or motor action.
- [x] Verify launch and visible missing/failed-dependency behavior through the approved workflow boundary, with a small UI smoke check.
- [x] Incorporate the selected **B — Everyday workspace** structure with sidebar navigation, central task and secondary status/context panel. Use real readiness states, not the prototype's simulated success controls. See [UI/UX review](../review.md#uiux-design-review).

The user approved this ticket's scope and dependency position and selected B as the current layout. The prototype is a design reference, not completion of this ticket.

## Comments

### 2026-08-30 — UI B selected; readiness implementation starts

The user says "its fine for now lets do B". Record B as the selected current direction, preserving later refinement. Begin the approved first slice: a native-Windows shell and offline prerequisite reporting. No camera/microphone capture, Windows credential prompt, biometric enrollment, model download, purchase or aircraft connection is implied. Existing Python 3.13.12 and Tk 8.6 are available; stack compatibility and actual readiness results will be recorded with the implementation. No commit or prototype cleanup is authorized.

### 2026-08-30 — Implementation claim

Resumed under the user's explicit eight-ticket implementation instruction. Baseline: main at `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`, with extensive pre-existing uncommitted planning/skill changes. Preserve those changes and all existing worktrees. Use the already approved public workflow and small UI smoke boundaries for red/green development. Review only this implementation's files against that baseline; the unrelated dirty checkout is not part of this change. No commit or push.

### 2026-08-30 — Readiness slice validated and reviewed

Implemented [the native desktop application](../../../pc_biometric/__main__.py), shared readiness workflow and UI B. [Installation/stack/limitations](../../../docs/pc-biometric/README.md) records exact initial versions, license sources, model provenance, offline bundle preparation and its remaining integration limits. The prototype is untouched and unused by production code.

Validation: six tests pass via `python -m unittest discover -s tests -v`; strict mypy 2.3.1 passes four application modules. Red/green cycles observed missing module, corrupt-model handling, failed-device integration, missing UI and unsupported-Windows failures before their implementations. Tests cover the public workflow, missing/damaged/present-but-unverified models, missing/mismatched runtimes, sanitized device errors, unsupported Windows and real Tk navigation/disabled actions. Native visual inspection and Tab/Space navigation passed; UI Automation exposes generic Tk panes, so screen-reader acceptance is explicitly unvalidated.

Actual readiness run: five selected runtime packages and four model artifacts missing; two imaging interfaces and one audio input interface enumerated, all access/liveness unverified; Windows prompt unverified and unopened. `--check` returned 1 as documented for missing prerequisites. No capture, biometric data, profile, code, Windows credential prompt, model download, aircraft connection, staging or commit occurred. Dependency metadata resolution succeeded for Windows x64/Python 3.13; Vosk's source-only `srt` wheel preparation is disclosed, not claimed completed.

Independent code review used two agents and scoped uncommitted additions against task-start HEAD. Standards: zero findings. Spec: one platform-reporting finding corrected with Windows-build/bitness checks and accurate tested-baseline wording; regression test passes. Existing unrelated `Project Idea.md` trailing-blank-line warning from global `git diff --check` is left untouched; scoped new-file whitespace checks are recorded in the review sheet.

## Answer

Ticket 01 is resolved as **offline readiness only**. Launch from the repository root with `python -m pc_biometric`. No biometric/security acceptance follows from this resolution. Ticket 02 is the next dependency; real enrollment and account-verification evidence retain their separate session/consent prerequisites. See the [PC implementation status index](../review.md#implementation-status--2026-08-30).

Final visual QA found a clipped Refresh button at the default window height after reserving footer space. A failing UI geometry assertion reproduced it (21px allocated versus 41px required). Packing the controls before the flexible readiness list fixed the allocation; the regression and final native visual inspection pass. This changes layout only, not readiness or authorization policy.
