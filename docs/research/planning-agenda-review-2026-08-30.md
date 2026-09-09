# Remaining planning agenda — review for approval

> **Decision update — 2026-08-30:** The user explicitly approves **Q69 and Q70**. The acceptance contract and separate PC-only specification/ticket-planning handoff are adopted; issue 10 remains claimed for aircraft/full-budget feasibility. Review the concrete PC specification's test boundaries and ticket breakdown next. Historical pending wording below is superseded only for those decisions; actual validation, capture consent and the proposed numerical test-data retention periods are not approved or completed. See the [latest ticket comment](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

Prepared **2026-08-30** in the main checkout, branch `main`, base `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. This is an uncommitted planning review, **not an implementation specification, shopping list, completed test result or approval to operate hardware**. The [latest ticket-10 comments](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments) remain authoritative. New proposals below do not override approved decisions.

## What is settled

- The revised complete-project budget is an accepted **$800–$900 planning range, maximum $900**. Spending less is welcome. It still covers the whole M1–M5 initial build, tools, radio, charger, initial spares and necessary integration/build costs. Maintenance is separate; recurring fees are disclosed and not selected automatically.
- Retain the self-built seven-inch direction, offline operation and independent radio/manual safety path. Once enabled, the biometric arming gate requires the owner's face and voice for every new arming; it must not prevent emergency takeover or safe landing during flight.
- The later endurance requirement remains at least **20 useful minutes plus a separate return-and-landing reserve**, with camera/computer installed, no extra delivery cargo, and the approved calm/daylight/dry walking-follow/stop/hover reference. This is a future acceptance requirement, not a completed measurement or a basic M1 flight exercise.
- Delivery keeps **recipient face verification and protection against ordinary manual cargo removal**. The holder is removable between missions while landed and disarmed, must stay securely attached in use, and must not bypass verification. First delivery ends landed, motors stopped, with the disarmed aircraft carried back. No safe cargo capacity or theft/forced-entry guarantee is established.
- Milestone order stays M1 manual flight plus hardened PC biometrics; M2 onboard authorization plus offline iPhone voice/live inspection video; M3 subject commands/patrol/navigation/avoidance; M4 lighting/night operation; M5 guest access/secure delivery. All previously approved guest permissions and retention rules remain; this summary does not replace them.

## What the completed review can and cannot close

The [complete-budget review](complete-budget-review-900-2026-08-30.md), [endurance review](endurance-closure-review-2026-08-30.md) and [M1 acceptance review](m1-acceptance-closure-review-2026-08-30.md) are decision support. They do not establish that a complete build meets $900 or that the aircraft/software meets its performance and security targets.

The prior conditional **$807.92** comparison leaves **$92.08** below $900 before missing obligations. It is not a qualified basket or a minimum achievable price. Unknown integration, secure-holder, avoidance, lighting, camera-motion, phone-build and delivered costs cannot be treated as zero. Higher-energy battery examples also change cost, mass and current constraints. Raising the ceiling does not itself select a compatible propulsion package.

| Agenda item | Review outcome | Required next evidence or decision |
| --- | --- | --- |
| Revised budget | Recorded | Honor $900 for the full initial project; no purchase authorization |
| Hardware and full cost | Still unresolved | One compatible, obtainable, itemized candidate with all required costs and explicit allowances supported well enough for review; delivered-cost check before purchase |
| Endurance and cargo | Still unproven | Credible installed mass/energy/current model before committing to a design; measured safe acceptance after assembly and commissioning; cargo capacity stays unset until supported |
| M1 acceptance definition | Consolidated for review | Approve the finite acceptance contract below; engineering details then belong in the reviewed specification |
| Final planning handoff | Original whole-M1 handoff remains blocked | Decide whether to permit the narrower PC-software planning handoff below while leaving the hardware decision open |
| Implementation | Not started | Approved specification, reviewed test boundaries and ticket breakdown; capture and physical operation have their own prerequisites |

Actual software measurements require software, and actual flight measurements require a completed, commissioned aircraft. Those are future acceptance gates, not requirements to perform impossible tests before writing a specification. Conversely, a future test plan does not justify claiming today's hardware compatibility or full budget fit.

## Proposed M1 acceptance contract — Q69, awaiting approval

**PC usability:** keep the approved normal first enrollment target of five minutes after installation, including owner Windows verification and saving a recovery code. Use the approved 100 fresh owner first attempts across five days, twenty daily in two sessions of ten. The proposed observed pass rule is **at least 95 first-attempt successes out of 100, with every successful baseline check completed within ten seconds**. Count slow successes as successes for reliability but failures of timing; keep failed attempts and retries separate. Freeze configuration and evaluation conditions before the run. This finite result does not prove a true future success probability of at least 95%.

**PC security and state:** require the full agreed attack categories, live nonowner checks, working positive controls, single-channel attacks with the other channel genuine, and applicable combined attacks. The earlier 90-negative-attempt proposal is an exploratory starting allocation, not an automatic pass quota or universal security-rate denominator. Define coverage before evaluation against the actual design; missing required coverage is incomplete. Any unauthorized approval blocks sign-off until investigation, correction and retesting. Enrollment, stored-state integrity, recovery, restart, cancellation, timeouts and approval replay must also pass their specified tests. This is a bounded evaluation, not certification or a claim of immunity to unseen attacks.

Preserve all approved owner/setup/recovery/privacy rules, including five failures followed by thirty seconds before each further attempt until full success; reopening cannot clear that wait; unfinished normal checks expire at sixty seconds; successful recovery rotates the code only when the replacement is ready and saved. Do not reopen those choices. Fault classification, concurrency, durable state, recovery-code guessing controls and completed-approval freshness are engineering decisions to propose and test in the specification. They cannot weaken approved behavior or add a silent bypass.

**Flight:** retain simulator preparation, separate completed-build review and commissioning, then the approved three consecutive qualifying takeoff/hover/movement/landing runs across at least two sessions. Fix measurable maneuver criteria, mode, operating bounds and reserve criteria before acceptance attempts using the selected aircraft and suitable operating conditions. Those figures cannot responsibly be invented as universal numbers now. Unresolved safety faults ground the aircraft; a safe early stop is never relabeled as a passing flight. No deliberate airborne fault injection is required. The solo-novice baseline remains, without a newly imposed helper requirement or a claim that AI can physically inspect/supervise the aircraft.

**Test data:** approve only an acceptance-planning direction now, not collection. Normal raw captures remain discarded. Before any security-test recording or owner-targeted synthesis, present a local-only test plan identifying participants, asset types, access, storage, removal of temporary copies and deletion dates, and obtain each person's consent. The supporting review proposes deletion of each raw/derived attack asset when its evaluation/retest use ends or thirty days after creation, whichever comes first; detailed pseudonymous results would expire ninety days after evaluation completion/abandonment, with only non-identifying aggregate results retained. These numerical retention periods remain draft session-plan proposals, **not parameters approved by Q69**. Retain no biometric media or secrets in ordinary result metadata. Unavailable consent or attack tooling leaves a coverage gap. No one is contacted and no recordings are collected by approving this planning document.

PC acceptance alone is **not completion of M1**, which also needs the flight/build side.

## Proposed software-first handoff — Q70, awaiting approval

The current map requires ticket 10 and its hardware/shopping-list inputs to close before a whole-M1 specification handoff. That has not happened. **Explicitly permit a separate, bounded PC-software specification and ticket effort while ticket 10 retains the unresolved aircraft/full-budget work.** This changes the planning dependency only; it does not resolve the original issue, certify a shopping list or delete any later requirement.

The first scope would be the owner-only native-Windows biometric desk application, including enrollment, verification, liveness/replay/injection defenses, encrypted references, one-action authorization, recovery and acceptance evidence. Its requested action is harmless desktop behavior with no connection to aircraft motors. Simulator learning can accompany execution when the actual radio/software prerequisites are ready. Onboard arming, iPhone implementation, autonomous flight, guests and delivery implementation stay in their approved later milestones.

If approved, the next work is to propose the PC specification's test boundaries, write the reviewed specification, review a small sequence of end-to-end implementation tickets, then implement the approved slices. Existing recognition models are research starting points, not proven defenses. Do not represent mocks or recognition-only demonstrations as hardened acceptance. Any paid dependency, extra capture hardware, scope change or failed feasibility result must remain visible against the project budget.

**Tradeoff:** PC development can provide useful progress without waiting for a complete aircraft basket, but the full aircraft may still need a later explicit budget/scope decision if no supported $900 design emerges. The PC work does not promise that the eventual drone will fit $900. No hardware purchase, alternative platform, reduced endurance, delivery removal or recurring service is authorized by this handoff proposal.

The `grilling` skill requires confirmation of shared understanding before acting on the design. Q69 and Q70 are the remaining independent decisions in this review. Capture consent, specification test-boundary review, ticket review and future hardware approval occur when their concrete artifacts are ready; they are not silently bundled into a general "continue".

## Record provenance

The dated ticket decisions and research reports linked above are uncommitted working files, not contents of the base commit. Each supporting review records its source snapshot hashes and external evidence where used. This document is a synthesis of those reports and the user's budget/continuation message, not a new external research source. Earlier reports retain historical text with later status notes. No application code, installations, tests, purchases, biometric capture, powered checks, flights or commits were performed for this review.

Supporting review snapshots, SHA-256 at consolidation:

- Complete budget: `4BB6FD5B22AF085B588C3D0E60E3CC4ED100B10597FD0291EAE873176F8E4AFE`.
- Endurance: `6669A94529B6DD7D9B459641882D79CD9C90153BD26CEE9F89E5864861634E5B`.
- M1 acceptance: `9E55FC5F3E308FE50C0E88C7DFC6457D68EB4A3EB4BA962748C1F5D793340B7A`.
