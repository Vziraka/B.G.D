# Lock the milestone ladder (grilling)

Type: grilling
Status: resolved
Blocked by: 02, 05, 06, 07, 09

## Current checkpoint

**September 25 owner deadline requirement:** the full project is due **Wednesday September 30, 2026 at 12:00 p.m. ET (America/New_York, EDT/UTC-04:00)**. This is mandatory and supersedes later planning dates; all product requirements below remain required. A deadline does not establish feasibility or qualify unfinished work. Issue12 tracks actual progress, dependencies and completion risk.

**September 20 owner amendment:** complete-system ceiling is now **$1,100**, including the $288.22 already paid, all remaining parts, tax and shipping. The extra $100 applies to the whole build, not a shipping-only allowance. Still prefer less. Prioritize reasonable delivery and avoid selected items requiring three to four weeks; some less critical items may arrive later than assembly-critical parts. All mission and performance requirements below remain unchanged. This supersedes the earlier $1,000 amount wherever repeated.

**September 11 budget amendment: $1,000 maximum delivered usable system; architecture reopened.** The September10 product requirements remain unchanged except for the explicit budget amendment below. This checkpoint supersedes Q75's architecture freeze, cargo obligations, earlier endurance targets and the previous no-cap/$1,000-feasibility-target wording. Issue10 remains resolved for these product choices; revised engineering belongs to Issue11 and phone/onboard integration to Issue12. Historical evidence does not qualify this revision.

| Area | Current requirement or preference |
| --- | --- |
| Product | Self-built personal autonomous drone; natural phone language expresses goals and compositions of supported actions. Unsupported or ambiguous requests require an explanation or clarification, not invented capability. |
| Missions | Follow a selected person (including description-based selection); search for the owner or another person using a face reference; find described objects; scout an area and report counts/other supported metrics. Define measurable recognition, search and counting cases during engineering. |
| Optional extensions | Watch, orbit and patrol only where they reuse core capabilities without substantial extra work; they are not completion blockers. |
| Access | Face and liveness verification before command access. Simple trusted enrollment/removal via unlocked paired phone while landed; enrolled people have the same command abilities. No per-guest command permissions or expiry system. Device authentication, recovery and independent manual takeover remain. |
| Voice and video | Speak through the phone; live aircraft video; fixed-lens camera with digital zoom. Reposition for detail when a clear route, separation and energy allow; report uncertainty when sufficient detail is unavailable. Optical zoom is not required. |
| Environment | Outdoor areas with trees/buildings and large open interiors such as warehouses, including darkness and eventual out-of-sight missions. These are design goals requiring bounded, validated operating cases, not universal all-environment capability. |
| Connectivity | Essential aircraft operation independent of internet, with optional online language assistance. Phone/aircraft link range is a separate engineering question. |
| Endurance | At least **10 useful minutes**, excluding takeoff and landing. Monitor battery and interrupt tasks early enough to reach a suitable landing spot and descend. Predicting completion of every mission is not required. Early recovery takes priority but does not pass the useful-duration target. |
| Energy evidence | Size takeoff/recovery/landing allowances from credible revised conditions. The old 20 Wh floor, 120-second recovery model, fixed-return workload and 12.1-minute paper target are historical assumptions to reassess, not new proven limits. Physical evidence, uncertainty margin and repeatability remain required; use retained evaluation principles where applicable. |
| Range and speed | Initial working-distance target **100 m from the user**, not total path length or a permanent maximum. Track landing destination separately. Max speed means fastest task execution allowed by surroundings, sensing and tested capability, with slowing when needed. Report estimated and demonstrated final speed/altitude separately. |
| Structure and portability | Prefer backpack portability; size/layout are engineering choices. Compare printed, purchased, machined and hybrid structures. Previous nonprinted-primary restriction is reopened for investigation, not automatic structural print qualification. |
| Cost and resources | **Hard maximum $1,100 for a usable system (September 20 amendment)**, strongly prefer less: aircraft, onboard equipment, one flight battery, controller, charger, required accessories, tax and shipping included. Credit the existing iPhone, computer and free lab access. Optional spares and development allowances are separate; required installed equipment, adapters and usable-app delivery cannot be hidden as optional. Actual tax/shipping remain quote-dependent and must fit inside the cap. Free lab access provides no staff guidance or operator training; use novice-feasible processes. |
| Removed | Cargo, holder/lock/release equipment, recipient verification and delivery acceptance. Preserve reusable historical artifacts; the standalone PC product remains dormant. |

No current airframe, propulsion, battery, compute or sensing selection is mandatory. Existing seven-inch and X650 designs are candidates/evidence. Recalculate integrated mass, power, cost and performance for a selected revision before asserting acceptance.

Next: pause further detailed engineering of the over-budget configuration. Issue11 owns a focused affordability review using preserved evidence, including simpler fabricated/hybrid designs and combined functions. Establish a credible within-budget design or explicitly identify unresolved conflicts and decision options. No capability may be silently weakened and estimates alone do not establish feasibility. Issue12's completed v1 simulator remains evidence only for its original slice. Procurement, fabrication, powered operation and physical qualification remain separate.

## Historical planning context

Everything below predating the final product-reset comment records the earlier revision. Earlier Answer, freeze, cargo, guest-policy and acceptance wording is retained for provenance and does not override the current checkpoint.

The twenty-, fifteen- and eleven-minute endurance targets below belong to earlier revisions. The current checkpoint requires ten useful minutes excluding takeoff and landing. Historical numerical results remain evidence for their original inputs and do not qualify the current aircraft.

The dated notes below preserve the decisions leading to closure. Their earlier budgets, open status and task-specific stops do not override Q75 or later Issue11/PC authorizations.

> **Resolved by Q75:** the user approves the exact conditional baseline and closes planning. Q74's twenty useful minutes plus independent reserve remains mandatory. Fabrication drawings, procurement readiness, fabrication readiness, physical compatibility, endurance and qualification are not certified by this approval. Continue the implementation-artifact stage in [issue 11](11-hardware-build-package.md).

> The initial questions below are retained as history. Read the [dated comments](#comments) for confirmed scope and remaining decisions.

> **Historical closure scope, 2026-08-30:** The user requests planning closure without requiring an unbuilt aircraft to pass physical tests. Resolve answerable decisions, engineering estimates, the proposed complete BOM/budget and acceptance definitions now; carry physical proof into an explicit future validation register. `resolved` will mean **planning complete**, never aircraft accepted. The eight approved PC tickets are for a separate implementation agent and must not be started in this task.

> **Historical hardware review, 2026-08-31:** a [specific corrected-power-path proposal](../../../docs/research/least-cost-hardware-selection-2026-08-31.md) now exists at **$1,862.64 complete scenario / $1,196.64 named purchases**. It retains the requested functions and models20.98 useful minutes centrally, with an18.20-minute moderate-loss case. It remains over the approved$900 ceiling and unselected; read the latest dated comment. No physical test is required just to review this proposal.

> **Budget and audit update — 2026-09-03:** the user removes the former $800–$900 complete-project ceiling. Drone hardware now has **no fixed maximum budget**; lowest complete cost remains the optimization objective, with every approved feature, safety, performance and validation requirement preserved. The [final decision packet](../../../docs/research/final-hardware-optimization-2026-09-03.md) now supplies the complete conditional architecture, cost, interfaces, models and deferred-validation list. Its former over-$900 status is historical, not a current blocker. Q75 has now approved the conditional baseline; issue10 is resolved and issue11 owns detailed engineering. No purchase or implementation is authorized.

## Question

With all research landed, grill the user to lock: (1) the final milestone-1 spec inputs (exact BOM cut at their comfort level, dev-env choice, which desk-phase deliverables count as done), and (2) the sketch-level ladder for milestones 2+ (voice-commanded flight, onboard vision, follow-me, handheld controller) ordered against the regulations findings and their appetite.

Decisions the research has already surfaced for this session:

- **Sub-250 g vs 5-inch** (ticket 07): sub-250 escapes most registration/ID rules but cannot carry the ticket-04 compute payload — it would sacrifice onboard vision, the project's soul. Not retrofittable; decide at BOM stage.
- **Use-case staging vs legality** (ticket 07): yard patrol has no hobby-legal form; payload *drops* widely banned; follow-me only in short-leash form. The ladder must reflect this honestly.

Run `/grilling` + `/domain-modeling`. Closing this ticket clears the map: the destination is reached and the effort hands off to `/to-spec` for the milestone-1 spec.

## Comments

### 2026-09-25 — full-project deadline reaffirmed

Owner explicitly reaffirmed September30 at noon ET as a requirement in the context-handoff task after "New parts ongoing project." Preserve this requirement in subsequent scheduling and handoffs; no scope reduction was approved.

### 2026-08-30 — Confirmed decisions through Q8

- **Q1:** Retain the self-built, payload-ready **7-inch** aircraft. The earlier "5-inch-class" wording does not describe the selected direction.
- **Q2/Q7:** The $600 target covers the lifetime project, not milestone 1 alone. Use $600 as the working ceiling; no undefined overrun is authorized. Hardware choices are reopened, but requested capabilities must not be silently removed.
- **Q3:** Ratify the native-Windows/WSL2 split, with WSL2/ROS installation deferred beyond milestone 1.
- **Q4:** Retain the hardened desk-phase scope: liveness, encrypted biometric storage, polished enrollment and replay resistance. Its threat model, acceptance tests, achievable cost and completion schedule remain unresolved; it is not downgraded to a demonstration.
- **Q5:** Adopt **biometric command gate** instead of an impenetrable-lock claim. Biometric motor arming remains prohibited until the required safeguards and independent manual override are validated.
- **Q6:** Include authorization-dependent aspirations as normal roadmap milestones, with required permissions and safety validation as completion prerequisites. No jurisdiction is assumed or requested, and approval is not guaranteed.
- **Q8:** Once the biometric command gate is enabled, **every new arming request requires face-and-voice authorization, including the radio's arm switch**. Emergency takeover and safe landing during flight remain independent of another biometric check. The earlier manual-learning phase remains separate from the later biometric-enabled operation.

Terminology is recorded in [CONTEXT.md](../../../CONTEXT.md). This records confirmed requirements, not a selected hardware implementation or a completed security validation.

Provisional budget research: [lifetime-budget-rebaseline.md](../../../docs/research/lifetime-budget-rebaseline.md), preserved in the main checkout from the uncommitted report on `research/milestone-1-bom`; its consolidation note records source provenance. It does not establish a complete $600 fit or authorize purchases.

Still open: minimum useful flight time with the future payload and a landing reserve; complete delivered/lifetime costs; propulsion and compute validation; authentication freshness, enrollment/recovery and threat-model acceptance criteria; and the ordered milestone-2+ ladder. Q8 is settled, but the ticket remains claimed and unresolved. No `/to-spec` handoff yet.

### 2026-08-30 — Approved documentation and handoff cleanup

The user approved consolidating the research into the main checkout, refreshing map summaries, exposing this effort's map/ticket Markdown to Git, and documenting shared Codex/Claude Code handoffs. Source worktrees and existing edits are retained; no commit, push, purchase, or hardware change is part of that approval.

Continue with the unanswered flight-time question: how many useful minutes per battery are required with the future camera/computer onboard and a landing reserve? The assistant suggested ten minutes, but the user has not accepted that target. This organization approval does not answer the flight-time question or resolve the milestone-ladder ticket.

### 2026-08-30 — Q9: Desired loaded flight time

The user answered: "I think around 20 minutes." Record approximately **20 minutes per battery with the future camera and onboard computer installed** as the desired flight-time target, replacing the assistant's unaccepted ten-minute suggestion.

This is a requested target, not measured endurance, a guaranteed hard minimum, or proof of a complete $600 lifetime fit. Confirm whether the twenty minutes excludes the return/landing reserve, then define the representative flight activity and acceptance tolerance before comparing hardware. Reserve size, battery selection, and achievable performance remain unresolved; no overrun, capability reduction, purchase, or motor-arming change is authorized by this answer. The milestone-ladder ticket remains claimed.

### 2026-08-30 — Q10: Return-and-landing reserve is additional

The user explicitly confirmed **20 minutes of useful flying plus enough battery left to return and land safely**, with the future camera and onboard computer installed. The return-and-landing reserve is separate from the useful-flight target; it must not be counted inside those twenty minutes. This settles Q9's reserve-accounting question.

The [glossary](../../../CONTEXT.md) now distinguishes useful flight time from the return-and-landing reserve. The original approximate duration remains a design target; acceptance tolerance, representative flight activity, operating conditions, return distance, and reserve size still need definition and validation. No particular battery, claimed endurance, or complete $600 fit is approved by this decision.

Next decision: what should the drone mainly be doing during the twenty minutes of useful flight? Do not assume a hovering, following, or cruising workload until the user specifies it. The ticket remains claimed and unresolved.

### 2026-08-30 — Q11: Representative flight activity

The user accepted **following at walking pace, with occasional stops and hovering**, as the first scenario to design and test against for the desired twenty minutes of useful flight with the future camera/computer onboard, plus a separate return-and-landing reserve.

This establishes a representative endurance workload, not a restriction on the finished drone's capabilities, a claim of achieved performance, or an instruction to add autonomous following to the earlier manual-learning milestone. Exact activity proportions, operating conditions, return distance, reserve size, and acceptance tolerance remain unresolved.

The user also asked what "other requested capabilities would remain on the roadmap" means. Clarification: the roadmap is the staged plan for the requested features. Choosing this first endurance scenario does not remove capabilities, make them optional, or approve their milestone placement or indefinite postponement. Other requested functions still require design, cost accounting, validation, and applicable safety/authorization prerequisites. The full lifetime fit remains unverified; any proposed scope reduction or budget increase must be raised explicitly for user approval.

The milestone-ladder ticket remains claimed and unresolved.

### 2026-08-30 — Approved subject and patrol commands

The user approved the four most recently proposed commands: "I like the proposed commands let's do that." They added that things to follow or patrol could be "anything." Preserve this as open-ended subject intent beyond following only the enrolled owner; no fixed subject-category list has been approved.

- **"Follow that"** — follow a selected moving subject.
- **"Orbit that"** — fly around a selected subject to film or inspect it.
- **"Watch that"** — keep the camera observing a selected subject without automatically flying after it.
- **"Patrol this area"** — repeatedly check an approved area or route.

These are approved roadmap requirements, not implemented capabilities or a guarantee that every object can be recognized, tracked, or approached safely. They extend the original owner-following and area-patrol ideas without removing existing requested capabilities. The exact supported subjects, operating conditions, acceptance tests, and milestone placement remain unresolved; do not silently turn a provisional implementation limit into a reduced project requirement.

The proposed boundaries remain part of the command design: confirm which subject the user means, do not silently switch subjects after tracking is lost, and keep subject selection separate from permission to command the drone. The selection interface, handling of ambiguity, and safe response to tracking loss still need design and validation; no unconditional hover, pursuit, or return behavior is selected here.

The [glossary](../../../CONTEXT.md) distinguishes the selected subject, following, orbiting, watching, and area patrol. These remain normal later-roadmap capabilities with applicable safety and permission prerequisites, not additions to milestone 1's manual-flight scope. The $600 lifetime target and working ceiling, approximate twenty minutes of useful flight plus a separate return-and-landing reserve under the representative workload, and biometric arming safeguards are unchanged. Hardware fit and universal subject support are not established. No purchase, implementation, or capability reduction is authorized by this planning decision; the ticket remains claimed and unresolved.

### 2026-08-30 — Q12 (partial): Fixed return point

The user agreed to a fixed takeoff/landing point for the first endurance scenario and asked whether that means the place of takeoff is the landing point. The intended normal return destination is the takeoff location for that flight, not one permanent address and not the pilot's changing position. A later flight can use a different suitable takeoff location and corresponding fixed return point.

This records the planned return destination, not implemented navigation behavior, exact landing accuracy, or permission to launch from any arbitrary place. Confirmation of the recorded return point before launch and handling of an unsafe or unavailable landing location still require design and validation; selecting a normal destination does not override emergency manual control or require landing there regardless of conditions. The [glossary](../../../CONTEXT.md) now defines the fixed return point without prescribing its implementation.

The distance part of Q12 remains unanswered: how far from that flight's return point the drone should travel during the representative endurance scenario. No distance, reserve amount, operating conditions, or endurance tolerance is assumed. Existing budget, capability, and arming requirements are unchanged; the ticket remains claimed and unresolved.

### 2026-08-30 — Q12: Provisional first-test distance approved

The user explicitly approved **100 metres (about 330 feet) from the takeoff point** as the provisional target for the first endurance test, and explicitly requested **greater eventual range**. This answers the distance portion of Q12; the earlier unanswered note is retained as history.

The number is the first test's planned maximum outward distance from its fixed takeoff/return point, not total path length, a final product range ceiling, or proof of safe operating range. Walking loops was an illustrative way to remain in that area, not a separately approved required route. No automatic stop-following, return, or geofence-crossing behavior is selected by this distance decision. Greater-range requirements and validation remain open rather than excluded.

The approximate twenty minutes of useful flight with future camera/computer payload, plus the separate return-and-landing reserve for this fixed-return scenario, remain the target. Operating conditions, activity proportions, reserve amount, and acceptance tolerance still need definition. This remains a later endurance scenario, not an instruction to add autonomous following to milestone 1. No hardware purchase, budget overrun, or implementation is authorized; the ticket remains claimed.

### 2026-08-30 — New grilling branch: selectable landing destination

The user requested that the grilling also cover an optional alternative to returning to the original takeoff point: continue following, accept a command such as **"Land here"** or a command selecting another landing location, and automatically land near the user if a low-battery notification is missed. They described this as possibly turning off the return-and-landing reserve and landing on very low battery. Preserve the requested alternate-landing capability and unattended-warning fallback as design topics; the safe policy and implementation are not yet agreed.

The assistant's recommendation, **not yet ratified**, is to distinguish changing the landing destination from disabling landing-energy protection: an alternate destination may remove the need to travel all the way back to takeoff, but the plan should retain sufficient energy for reaching a suitable landing area, descending, and safety margin. Automatic protective action should not depend on the user noticing a warning or waiting until only an emergency descent is possible. No numeric battery threshold, universal reserve, or guaranteed safe-site recognition is selected.

Questions to resolve in this new branch:

- Whether both destination policies retain mandatory landing-energy protection, and how the user chooses a policy before or during a flight. Switching destination must not be assumed to restore energy already spent or guarantee a now-unreachable return home.
- Whether "here" means the drone's current ground position, the user's vicinity, or an explicitly selected landing spot; how the destination is confirmed and distinguished from a moving person.
- How a suitable reachable landing area is established, without promising that following a person or issuing a generic land command proves the ground is safe. The desired near-user fallback is not permission to land on or dangerously close to a person.
- Warning, missed-response, unavailable/unsafe landing site, lost subject/location/link, and low-versus-critical battery handling, including when a requested destination must be rejected in favor of a protective response.
- The alternate option's acceptance tests, milestone placement, and sensing/compute/power costs under the unchanged $600 lifetime target and working ceiling. No more usable minutes or larger supported range is established by changing the destination policy.

The first fixed-return endurance scenario remains approved. The new option is not a silent replacement for that scenario, an approved removal of its reserve, or an implemented failsafe. Existing biometric arming safeguards and independent emergency manual control remain unchanged. The next grilling decision is whether to adopt selectable landing destinations with mandatory landing-energy protection; the ticket remains claimed and unresolved.

Supporting research: [Landing policy and battery reserve](../../../docs/research/landing-policy-and-battery-reserve.md), checked 2026-08-30 against official ArduPilot documentation. It distinguishes native battery/descent behaviors from unvalidated destination and landing-site capabilities; its recommendations are not user decisions or a selected flight configuration.

### 2026-08-30 — Q13: Landing protection remains mandatory

The user answered **yes** to retaining a mandatory landing reserve and automatic low-battery protection in both landing options while allowing the landing destination to be chosen. This ratifies the safety principle proposed in the preceding comment; it does not ratify every recommendation in the supporting research report or select a flight-controller configuration.

- **Return to takeoff:** protect energy for the return journey, landing, and safety margin.
- **Land elsewhere:** protect energy for reaching a suitable selected landing destination, landing, and safety margin. This option does not promise that enough energy remains for a later return to the original takeoff point.
- **Missed warning:** automatic low-battery protection must not depend on the user acknowledging a notification. The agreed direction is to act before the energy needed for the protected landing is consumed, not to plan normal operation around an almost-empty-battery descent.

The [glossary](../../../CONTEXT.md) now distinguishes the landing destination, landing reserve, and return-and-landing reserve. Useful flight time remains separate from energy protected for ending the flight safely. This is a requirement, not evidence that safe-site selection, reserve prediction, or automatic landing near the owner has been implemented or validated.

Still open: what "Land here" refers to; how a site is selected and confirmed; preflight policy selection and allowed in-flight changes; unattended-warning and unavailable-site fallback behavior; reserve calculation and thresholds; operating conditions, acceptance tests, cost, and milestone placement. Q12's first fixed-return 100-metre endurance scenario, the twenty-useful-minute target, greater eventual range, the $600 lifetime working ceiling, biometric arming safeguards, and independent emergency manual override are unchanged. The ticket remains claimed and unresolved.

### 2026-08-30 — Q14: Meaning of the explicit "Land here" command

The user answered **"ok yes"** to defining **"Land here"** as a request to land at a clear patch of ground near the user that the user selects and confirms. The intended destination is that patch of ground, not the user's body or feet and not automatically the spot directly beneath the drone. Landing proceeds only if the required site-safety and battery checks pass; neither those checks nor landing accuracy are validated by agreeing to the command's meaning.

This decision applies to a deliberate command. It does **not** require a fresh user reply for the separate automatic response to a missed low-battery warning; Q13's automatic protection remains mandatory, while that fallback's destination-selection rules are still open. A confirmed location must not be confused with proof of safe ground or available energy.

The [glossary](../../../CONTEXT.md) now defines the command. The indication/confirmation interface, position accuracy, safe separation, fallback behavior, acceptance tests, and hardware/cost implications remain to be designed. No particular screen, gesture, recognition system, or sensor is selected. Existing flight-time, range, budget, and arming requirements remain unchanged; the ticket remains claimed and unresolved.

Next decision: when an alternative landing plan may replace energy reserved for returning to takeoff, without leaving the drone without a reachable landing destination.

### 2026-08-30 — Q15: Protect the return plan until an alternative is established

The user answered **yes** to keeping enough battery to return to takeoff until another suitable landing spot has been confirmed and checked as reachable. Merely selecting "land elsewhere" is not permission to spend the home-return reserve before a usable alternative is established.

After that change is accepted, the protected energy may be calculated for reaching the alternative destination and landing there with the required margin, instead of returning to the original takeoff point. This does not guarantee that a later request to return to takeoff will still be feasible. It is a requirement for planned destination changes, not a claim that remaining-energy estimation or landing-site validation is implemented.

Q13's mandatory landing reserve and automatic low-battery protection, and Q14's meaning of a deliberate "Land here" request, remain in effect. Emergency manual takeover remains independent of a new biometric check. Unexpected loss or obstruction of a destination, inaccurate energy estimates, and loss of navigation/link information still need explicit fallback design; this decision does not prescribe returning to an unsafe or unreachable site.

Next decision: the initial alternate-landing response when the user has walked away from the selected site and misses a low-battery warning. Using the last confirmed, still-suitable and reachable site is a proposal to discuss, not yet approved; the requested automatic near-user landing capability is not silently removed. Other endurance, range, budget, security, and milestone decisions are unchanged. The ticket remains claimed and unresolved.

### 2026-08-30 — Q16: Initial automatic alternate-landing destination

The user answered **yes** to the first version of alternate landing using the **last confirmed landing spot**, provided it remains suitable and reachable, when automatic battery protection activates and the user does not respond. This applies even if the user has walked away since confirming it, so the aircraft may land behind the user at the agreed spot rather than beside the user's current position.

The agreed direction does not wait for a new confirmation while consuming the landing reserve. It also does not permit using a stale, obstructed, unsafe, or unreachable destination merely because it was once confirmed. Site-validity checks, positioning/energy uncertainty, and the response when no suitable confirmed site remains are still design and validation work, not solved by this choice.

Automatically finding and validating a new landing spot near the user's current position remains a requested capability to develop; this initial behavior does not remove it, prove its feasibility, or establish its milestone order. The first version here is the alternate-landing feature's initial behavior, not an addition to milestone 1's manual-flight scope. Q13–Q15's protection and destination-change rules, and all existing flight-time, range, budget, and biometric requirements, remain unchanged.

Next grilling topic: the reference operating conditions for the first twenty-useful-minute endurance target. Remaining landing failure cases remain open alongside that question; the ticket remains claimed and unresolved.

### 2026-08-30 — Q17: Reference endurance-test conditions

The user answered **yes** to assessing the first twenty-minute useful-flight target in **dry, daylight, calm-weather conditions**, with the **camera and onboard computer installed but no extra delivery cargo**. The separate return-and-landing reserve remains additional to the useful-flight target. Q11's walking-pace following with occasional stops/hovering and Q12's provisional 100-metre radius from the fixed takeoff/return point remain the reference scenario.

This establishes reference conditions, not a guarantee of achieved endurance or a restriction on the finished project's requested capabilities. Night escort, carrying items, and other requested uses remain on the roadmap with their own validation. Excluding extra cargo from this test does not authorize stripping required flight or camera/computer equipment to claim the target has been met.

Measurable weather limits, including the meaning of calm conditions, still need definition before testing. The useful-flight pass threshold or tolerance, activity proportions, reserve calculation, and repeatability criteria also remain unresolved. No operating clearance, hardware purchase, budget overrun, or change to existing safety protections is approved by this answer; the ticket remains claimed and unresolved.

Next decision: what useful-flight duration counts as passing this reference endurance test, distinguishing the approximate design target from an agreed acceptance threshold.

### 2026-08-30 — Q18: Firm reference endurance acceptance threshold

The user answered **yes** to requiring **at least 20 minutes of useful flight**, under the agreed reference conditions, with the **full separate return-and-landing reserve still available at the end of that useful-flight period**. Twenty minutes is now the minimum passing duration for this test, superseding the earlier approximate target and unresolved duration tolerance. No shorter passing threshold has been approved.

This applies to Q11's walking-pace following with occasional stops/hovering, Q12's provisional 100-metre fixed-return scenario, and Q17's dry/daylight/calm conditions with camera/computer installed and no extra delivery cargo. Returning and landing are not counted within the twenty useful minutes. Existing mandatory battery protection still takes priority if conditions require ending a flight early; an early safe recovery must not be relabeled as a passing endurance result or delayed merely to reach the timer target.

This establishes a future test requirement, not demonstrated capability, a proof of complete $600 lifetime affordability, or a requirement to conduct autonomous flights during this planning effort or milestone 1. Any hardware-analysis or measured shortfall must be presented to the user for a decision; do not silently reduce the duration, spend the protected reserve, remove capabilities, or approve an overrun.

Reserve sizing and measurement, precise weather limits and activity proportions, test repetitions, and remaining landing failure cases are still unresolved engineering and validation work. The next grilling topic is the hardened desk-phase security threat model and acceptance criteria. The ticket remains claimed and unresolved.

Supporting research for that next topic: [Desk biometric threat model](../../../docs/research/desk-biometric-threat-model.md), checked 2026-08-30 against primary sources. It distinguishes identity recognition, presentation/replay/synthetic-media attacks, digital capture injection, and host compromise. Its proposed test framing and trust assumptions are not user decisions; no attack class has been excluded, security threshold selected, or NIST compliance established. The approved face-and-voice requirement and prohibition on biometric motor arming remain unchanged.

### 2026-08-30 — Q19: First desk-phase PC-security boundary

The user answered **yes** to assuming, for the first hardened desk phase, that an attacker has **not taken control of Windows or altered the verification program**. This phase will not claim protection after that PC or verifier compromise. This ratifies that specific trust boundary, superseding the preceding note's statement that no attack class had yet been excluded; it does not establish that the real PC is uncompromised.

The accompanying test scope remains **photos, videos, recorded or AI-generated voices, and software substituting fake camera/microphone inputs**. Input substitution is not silently excluded merely because it involves software: it must be evaluated separately under the agreed intact-host/verifier assumptions. Specific attack access, representative samples, defenses and passing criteria remain to be defined. Agreeing to these tests is not evidence of resistance to every spoof, recording, synthetic sample or injection technique.

This is not a blanket exclusion of biometric-data theft, unauthorized enrollment/replacement, or every kind of physical access. Their requirements and relevant trust assumptions still need explicit definition. Existing liveness, replay-resistance, encrypted-storage and polished-enrollment requirements remain; the [supporting research](../../../docs/research/desk-biometric-threat-model.md) is evidence for framing the decisions, not a NIST-compliance claim or a selected implementation.

Next decision: how the owner authorizes enrollment changes and recovers from failed recognition, without creating an alternative route to motor arming. No recovery method has been approved. The original Gemini note's guest-enrollment proposal also needs separate approval and access rules; Q19 neither enables nor removes it. Biometric motor arming remains prohibited until its safeguards and independent manual override are validated; budget, endurance and roadmap requirements are unchanged. The ticket remains claimed and unresolved.

### 2026-08-30 — Q20: Offline recovery code required for lockout recovery

The user answered **yes** to requiring a **private recovery code kept offline** before re-enrolling when face or voice verification stops recognizing the owner. The code is **one required part of a protected recovery process**, not an approved sufficient credential by itself. This settles that prerequisite for lockout recovery; it does not select authorization rules for ordinary enrollment updates, first setup or guest enrollment.

Recovery grants no direct motor-arming permission. After authorized re-enrollment, both face and voice verification remain required for a new arming request once the biometric gate is enabled. The user was explicitly told that theft of the code could help an attacker replace enrollment, and loss of the code could leave the owner locked out. Requiring both biometrics after replacement does not by itself prevent an attacker from enrolling their own face and voice through a compromised recovery process.

Additional recovery evidence, secure generation/storage, guessing protection, use/replacement rules, and lost/stolen/unavailable-code handling still need agreement and validation. No unrestricted reset, permanent lockout policy, Windows-account requirement, password-only flight path or actual recovery code is approved or created here. The [supporting research](../../../docs/research/desk-biometric-threat-model.md) remains decision support; its broader recommendations are not ratified as a package.

Next decision: what independent owner-verification check must accompany the recovery code without depending on the failed drone biometrics. Q19's host/verifier trust boundary, the prohibition on biometric motor arming until safeguards and independent override are validated, and all budget, endurance and roadmap requirements remain unchanged. The ticket remains claimed and unresolved.

### 2026-08-30 — Q21: Fresh owner Windows-account verification for recovery

The user answered **yes** to the first PC phase requiring **fresh verification of the owner's Windows account in addition to the offline recovery code** before lockout re-enrollment. Entering a Windows PIN was an example, not a selected exclusive verification mechanism. The user accepted that this recovery path requires access to that Windows account; merely possessing the code or finding an already-unlocked desktop is not sufficient.

The check must correspond to the designated owner's account, not just any logged-on Windows user, and must not depend on the drone biometrics that failed. This is an additional recovery prerequisite within Q19's intact-host/verifier assumption, not protection against an already compromised PC or approval of an arbitrary operating-system administrator override. Neither recovery credential directly authorizes arming; both drone biometric checks remain required after authorized re-enrollment.

The [supporting research](../../../docs/research/desk-biometric-threat-model.md) establishes a Windows verification capability, not validated integration for this project. No API, PIN configuration, credential handling or implementation is selected. Offline behavior, account binding, failure handling and acceptance tests still need validation. This approval does not establish that these two checks settle the complete recovery protocol or prescribe recovery for every later onboard/handheld milestone.

Next decision: replacing a lost recovery code while the owner's face and voice still verify, as distinct from being unable to verify and also lacking the recovery code. No code-replacement or combined-lockout fallback has been approved. First enrollment, ordinary enrollment changes and guest policy remain separate open decisions. Existing budget, endurance, roadmap and biometric motor-arming safeguards are unchanged; the ticket remains claimed and unresolved.

### 2026-08-30 — Q22: Replace a lost code while biometric verification still works

The user answered **yes** to issuing a replacement for a lost recovery code after **fresh face verification, fresh voice verification and fresh verification of the owner's Windows account**. This first-PC-phase maintenance path does not require presenting the lost code. The replacement **invalidates the old code** and **does not change the enrolled face or voice**.

This is code replacement while normal biometric verification remains available, not Q20–Q21's lockout re-enrollment path. It grants no direct arming authorization, does not permit Windows-only replacement, and does not approve a fallback when the code is missing and either biometric check cannot succeed. The latter combined-lockout case is the next decision; no lasting-lockout policy or alternative owner-reset path is assumed.

Secure replacement, invalidation persistence and interruption/failure behavior still need implementation and testing. No code has been generated, displayed or invalidated, and no enrollment data has changed. First enrollment, ordinary biometric updates, guest policy and other remaining security criteria are still open. Existing budget, endurance, roadmap and biometric motor-arming safeguards are unchanged; the ticket remains claimed and unresolved.

### 2026-08-30 — Q23: No recovery route for combined code loss and biometric lockout

The user answered **yes** to the first PC version keeping recovery blocked when **no valid recovery code is available and the owner cannot pass both required biometric checks**, even if the owner can sign into Windows. Failure of either face or voice verification prevents Q22's code-replacement path; it is not necessary for both checks to fail. There is **no Windows-only ownership reset** for this case.

The user explicitly accepted that if neither a valid backup of the recovery code can be found nor successful face-and-voice verification regained, **this version has no recovery path**. A valid code, if recovered, still requires Q21's fresh owner Windows-account verification; regaining both biometric checks enables Q22's code replacement only with its fresh Windows-account check. This is a potentially lasting application lockout, not an automatic deletion of enrollment, a reset after a waiting period, or an approved bypass.

The decision is limited to the first PC version's recovery policy. It does not disable independent in-flight manual emergency control, make a single failed attempt a permanent ban, or authorize changing the policy in a later implementation without a new decision. Handling unavailable Windows accounts, trusted first setup, storage loss/tampering and interruption still requires design and validation; an unenforced requirement is not demonstrated security.

Next decision: how the initial owner and recovery Windows account are established before biometric enrollment exists, while keeping first setup distinct from resetting an existing owner. No first-setup workflow has been approved. No code, biometric data, application configuration or flight behavior has been changed; budget, endurance, roadmap and biometric motor-arming safeguards remain unchanged. The ticket remains claimed and unresolved.

### 2026-08-30 — Q24: Deliberate first enrollment binds the recovery account

The user answered **yes** to creating the first owner profile through **deliberate setup on the PC, protected by fresh Windows-account verification**, with that verified account becoming the recovery account. This establishes initial enrollment authority before a stored face or voice profile exists; it is not approval for any Windows user to replace an existing owner.

After initial setup, **missing or damaged profile data must not automatically reopen unrestricted new-owner enrollment**. First enrollment and recovery of an existing enrollment must remain distinct so that loss of profile data cannot become a Windows-only reset that bypasses Q20–Q23. The secure distinction between genuinely uninitialized state and lost, corrupted or altered enrollment state still requires design and validation; a particular file, flag, storage mechanism or installation-reset procedure is not selected.

This settles the first-PC-phase setup authority, not the full enrollment interface, sample-quality criteria, liveness implementation, completion tests, recovery-code handling or unavailable-account migration policy. No Windows account has been bound, biometric data collected or code generated. Setup grants no motor-arming permission; existing safeguards, budget, endurance and roadmap requirements are unchanged.

Next decision: whether to adopt the original Gemini note's temporary guest-access proposal as a later capability, distinct from selecting someone for following or observation. Guest enrollment, guest commands, arming rights, expiration, revocation and owner/recovery privileges remain unapproved. This setup decision neither enables nor removes the proposal; the ticket remains claimed and unresolved.

### 2026-08-30 — Q25: Optional later guest access; first PC phase remains owner-only

The user answered **yes** to a later **guest mode** in which the owner explicitly authorizes another person to issue commands using **that guest's own enrolled identity**, while the first PC phase stays **owner-only**. Only the owner may grant or revoke guest access. Guests may not change ownership or recovery settings; access does not make them another owner or allow them to authorize further guests.

Following or observing a person remains separate from granting command authority. The [glossary](../../../CONTEXT.md) now distinguishes the owner, a guest and a selected subject, and expresses the biometric command gate as identity verification plus permission for an action. That vocabulary change does not itself approve any guest command or arming privilege, replace face-and-voice safeguards, or relax Q20–Q24's owner recovery and setup rules.

Exact guest commands, permission to arm/start a flight, the grant/revocation interface, access duration or automatic expiration, concurrent commands and safe handoff/revocation behavior remain open. The historical on-drone guest-enrollment workflow is not approved in detail. No role has been provisioned, biometric data collected or flight behavior implemented.

This adopts guest access as a requested optional-use capability in the later roadmap, not as an addition to milestone 1 or a discretionary feature to silently drop. Its milestone position, security validation, hardware implications and lifetime cost remain to be established under the unchanged $600 working ceiling. No budget overrun or removal of other capabilities is authorized.

Next decision: whether each new flight remains subject to the owner's face-and-voice arming authorization when a guest will issue commands. Guest arming is not approved by Q25. Existing emergency manual override and prohibition on biometric motor arming until safeguards are validated remain in force; the ticket remains claimed and unresolved.

### 2026-08-30 — Enrollment and controller terminology clarified before Q26

The user clarified that face enrollment means a **live camera scan to obtain the person's faceprint, not uploading a photograph**. The assistant explained that "face samples" meant frames captured during that live scan and that a faceprint is a reference used for later comparison. This intended live-enrollment approach applies to the owner and later guests; it does not select 3D/depth-scanning hardware, establish liveness/replay resistance, or choose raw-image retention rules. The [glossary](../../../CONTEXT.md) now distinguishes the faceprint from proof of liveness or command permission.

The assistant also clarified that "radio" means the handheld RC transmitter with sticks/switches, rather than the voice-command microphone, and that arming enables the motors rather than necessarily initiating takeoff. These clarification questions were not treated as approval of guest arming; Q26 was asked again before the answer below.

### 2026-08-30 — Q26: Owner approval remains required for every new arming request

The user answered **yes** to an enrolled guest still needing **the owner's face-and-voice approval before arming for every new flight**. This preserves Q8's all-arming gate and makes the required identity explicit for guest flights: the owner's, not merely any enrolled guest's. A radio arm request cannot bypass it. Guest enrollment or a previously granted access permission is not standing authorization to arm again.

The user explicitly accepted the tradeoff that a guest cannot start another flight while the owner is unavailable to approve it. Arming authorization remains separate from the guest's own identity verification and permitted commands; the precise command list, handoff, authorization freshness/binding, expiration and revocation behavior still need design and validation. This does not yet authorize any specific guest command after the owner approves arming.

Independent emergency manual takeover and safe landing during flight still require no new biometric check. This decision does not require ongoing owner recognition to keep motors running, prescribe motor shutdown on failed recognition, or change the separate early manual-learning phase. Biometric motor arming remains prohibited until the required safeguards and independent override are validated.

Next decision: how the owner limits which commands a guest may issue after authorization. The first PC phase remains owner-only; guest access is a later capability. No implementation, enrollment, purchase or flight action has occurred, and budget/endurance/roadmap requirements remain unchanged. The ticket remains claimed and unresolved.

### 2026-08-30 — Q27: Owner-selected voice-command permissions per guest

The user answered **yes** to the owner choosing an **explicit list of voice commands each guest may use**, with **unapproved commands blocked**. The suggested example of allowing "Follow me" and "Hold position" while withholding patrol or landing-destination changes was illustrative, not approval of a fixed command list or preset.

Guest command permission cannot bypass owner-only arming approval, ownership/recovery restrictions or mandatory flight-safety protections. Independent emergency manual takeover and safe landing remain available without a new biometric check; this voice-command permission list does not restrict that emergency path. Enrollment, command permission and permission to arm remain distinct.

The grant interface, authorization freshness, permission changes during flight, handoff, concurrent or queued commands, expiration and safe revocation behavior still need definition and validation. No guest permissions have actually been provisioned. Guest access remains a later capability, not part of the owner-only first PC phase; budget, endurance, other requested capabilities and biometric motor-arming safeguards are unchanged.

Next decision: how long a guest's command permission lasts, separately from how long their biometric enrollment data is retained. No expiration or retention policy is approved by Q27. The ticket remains claimed and unresolved.

### 2026-08-30 — Q28: Guest command permission lasts one flight

The user answered **yes** to guest command permission lasting **one flight**, expiring **after the drone has landed and disarmed**. The owner must approve guest access again for the next flight. The accepted tradeoff is an additional per-flight reapproval step to avoid forgotten ongoing access. This permission renewal remains separate from the owner's required face-and-voice arming approval; neither substitutes for the other.

Permission expiry does **not automatically require deletion of the guest's face or voice profile**, nor does this decision approve keeping that data. Biometric-enrollment retention is a separate unresolved policy. A retained profile, if later permitted, would not by itself grant active command access or independent arming authority.

This sets the normal completed-flight boundary, not a timer that expires during flight or a reason to cut motors. Aborted flights, reboot or lost-state handling, early revocation and in-flight command handoff still need safe design and validation. Mandatory safety protections and independent emergency manual control are unchanged.

Next decision: whether guest biometric profiles are deleted after use by default and whether saving them for future visits should be permitted. No retention default, consent workflow or retention duration has been selected. This is a decision record only; no biometric data or flight behavior has changed. Guest access remains a later capability, existing budget/endurance requirements remain, and the ticket stays claimed and unresolved.

### 2026-08-30 — Q29: Delete guest profiles by default; saving requires mutual consent

The user answered **yes** to deleting guest **faceprints and voiceprints after each flight by default**, with an option to save an **encrypted profile only when both the owner and the guest explicitly agree**. The normal completed-flight boundary remains landing and disarming, not an instruction to remove recognition data or stop motors during flight.

The accepted tradeoff is that a guest whose profile is deleted must enroll again for a later flight; a returning guest may instead agree with the owner to save their profile. Saving enrollment does not grant standing command permission: Q28's owner reapproval for each flight and Q26's separate owner face-and-voice arming authorization still apply.

The retention period for saved profiles is still undecided. This does not authorize indefinite storage, unilateral owner consent, retaining raw enrollment photographs or audio recordings, or changing the owner's own enrollment/recovery policy. Consent capture and withdrawal, deletion of stored copies, encryption/key handling, interrupted cleanup and other failure cases still require design and validation; no deletion guarantee has been demonstrated.

Next decision: how long a mutually approved saved guest profile may remain before it expires. No actual biometric data has been collected, saved or deleted. Guest access remains a later capability; budget, endurance, mandatory safety protections and independent emergency control are unchanged. The ticket remains claimed and unresolved.

### 2026-08-30 — Q30: Saved guest profiles expire 30 days after saving

The user answered **yes** to saved guest profiles being **automatically deleted 30 days after saving**, with **fresh enrollment required afterward**. Using the profile does **not restart the deadline**. The accepted tradeoff is repeat face scanning and voice enrollment roughly monthly for regular guests, rather than indefinite retention. This is the agreed starting project policy, not a legal retention requirement or demonstrated deletion capability.

If the deadline arrives **during a flight**, deletion waits until the drone has **landed and disarmed**, without interrupting the flight. This exception protects the current flight; it is not a renewal of the saved profile for subsequent flights, an extension triggered by normal use, or permission to cut motors when a timer expires.

Q29's default deletion after each flight and explicit owner-and-guest agreement to save an encrypted profile remain in force. A saved profile still grants neither standing command access nor independent arming authority: per-flight owner permission and the owner's separate face-and-voice arming approval remain required.

Timekeeping, powered-off periods, interrupted cleanup, stored-copy deletion and related validation remain unresolved implementation matters. Early deletion or withdrawal of storage consent is the next policy decision, not an answer inferred from this retention limit. No actual biometric data or flight behavior has changed; guest access remains a later capability, existing budget/endurance and safety requirements are unchanged, and the ticket remains claimed and unresolved.

### 2026-08-30 — Q31: Either party may request early deletion of a guest profile

The user answered **yes** to either the owner or the guest requesting deletion of **that guest's saved profile before its retention deadline**, **without needing the other person's agreement**. Either may withdraw consent to storage. A guest's authority is limited to their own profile: it does not permit deleting the owner's enrollment or another guest's profile.

Deletion takes place while the drone is **landed and disarmed**; a request during flight waits until then. This does not authorize an in-flight motor shutdown, interrupt independent emergency control, or require keeping a profile until the full 30-day limit when an eligible early-deletion request has been made.

This settles withdrawal of storage consent, not all effects on active command permission. Whether a deletion request also immediately revokes current command access, how to handle executing or queued commands, and the owner's separate in-flight access-revocation behavior remain to be defined. Request verification, offline delivery/acknowledgment, interrupted cleanup and deletion of stored copies still need design and validation.

Next decision: how the drone should respond when the owner revokes a guest's command access during flight, as distinct from deleting stored enrollment. No actual profile, permission or flight behavior has changed. Guest access remains a later capability, owner arming authority and mandatory safety protections remain, budget/endurance requirements are unchanged, and the ticket remains claimed and unresolved.

### 2026-08-30 — Q32: Revocation blocks new and waiting guest voice commands in flight

The user answered **yes** to the drone blocking a guest's **new voice commands and commands waiting to run as soon as it receives and verifies the owner's revocation request**, including while airborne. Revoking command permission does not wait for landing or for deletion of the stored guest profile. This is not a claim that a request takes effect before it reaches the drone or a selected delivery, verification or acknowledgment mechanism.

Revocation must **never cut motors, disable independent manual emergency control, or interrupt a safety return or landing**. These protections remain separate from the guest's ordinary voice-command permissions. The user has **not yet selected how to handle an activity already underway**, such as following; blocking new and waiting commands does not by itself settle cancellation or the safe transition from an executing activity.

Q31's profile-deletion policy remains distinct: whether a deletion request also revokes active access is still open. Request authentication, communication failures, concurrent requests and execution-boundary behavior need design and validation. No actual permission, biometric data or flight behavior has changed; guest mode remains a later capability and the first PC phase stays owner-only. Existing budget, endurance, owner arming authorization and other requested capabilities are unchanged. The ticket remains claimed and unresolved.

### 2026-08-30 — Approved refocus on milestone-1 completion criteria

The user answered **"ok"** to preserving the approved decisions, leaving remaining guest/autonomy details for their later planning, and returning to **milestone-1 completion criteria**. The current destination remains milestone 1 in detail plus a sketch-level later milestone ladder, not the complete design of every future feature. This is approval of planning focus, not approval of a new acceptance checklist, hardware package or specific later-milestone order.

Use **`/grill-with-docs`**, whose local definition runs the existing `/grilling` and `/domain-modeling` combination. This changes neither the shared tracker/glossary responsibilities nor the approved project requirements; no interview restart is needed.

Unanswered later-feature questions, including handling an executing guest activity after revocation, remain recorded and unresolved. Their relevant safety requirements, capability commitments and lifetime-cost implications must still inform the ladder and hardware choices; deferring detailed design does not permit deploying an unvalidated feature or silently dropping it.

Continue with the owner-only PC and manual-learning completion criteria, then resolve the remaining endurance/test-plan and hardware/budget inputs, agree the sketch-level later sequence, and obtain final shared-understanding approval. Research and engineering evidence must support proposed technical criteria; the user chooses requirements and tradeoffs rather than inventing benchmark results. No new performance target, purchase, implementation or test result is approved by this process decision. The ticket remains claimed and unresolved.

### 2026-08-30 — Q33: Initial 10-second PC verification usability target

The user answered **"ok lets do that"** to an initial usability target of **10 seconds or less for a normal successful face-and-voice check** in milestone 1's **owner-only PC app**. The interval runs **from starting the check to showing "authorized," including following its prompts**. First-time enrollment and retries are measured separately; the target is not merely model-inference time or time after the user has already completed every prompt.

Actual performance must be tested on the user's PC **without weakening liveness or replay protection** to meet the target. This is an approved target, not a measured result or proof that the chosen hardware/software can achieve it. It does not select an automatic timeout, grant access when the timer expires, set how long authorization stays valid, or authorize biometric motor arming.

The required proportion of normal attempts that succeed on the first try, test conditions, measurement protocol and separate enrollment/retry usability criteria remain open. Attack acceptance and spoof-resistance criteria also remain separate; fast genuine-user recognition is not evidence of security.

Next decision: the acceptable first-attempt success target for the genuine owner. No success percentage, sample count or statistical confidence requirement is approved by Q33. No implementation or tests have been performed; existing hardening, budget, endurance and later-capability requirements are unchanged. The ticket remains claimed and unresolved.

### 2026-08-30 — Q34: Initial 95% genuine-owner first-attempt success target

The user answered **yes** to an initial PC usability target of **recognizing the genuine owner correctly on the first attempt at least 95% of the time under normal conditions**. This applies to the owner's complete face-and-voice check, not an independently approved 95% target for each factor. Occasional retries are acceptable; frequent retries would miss this target. Q33's separate 10-second successful-check target remains in force.

The comparison **"roughly 19 out of 20"** explained the percentage; it does not select a 20-attempt test, prove the underlying success rate, or guarantee 19 successes in every sequence of 20 checks. Normal-use conditions, evaluation samples, measurement details and statistical confidence requirements remain to be specified and tested. No unlimited-retry policy, retry limit or lockout timing has been chosen.

This is a genuine-owner usability target, **not permission to accept strangers or spoofed inputs 5% of the time**, evidence of attack resistance, or approval to weaken liveness/replay protections. Security acceptance criteria remain separate and unresolved. No achieved recognition rate or hardware feasibility is claimed.

Next decision: the everyday PC conditions these initial usability targets should cover. No implementation, biometric collection or testing has occurred. The first PC phase remains owner-only, all earlier safety, budget and endurance requirements are unchanged, and the ticket remains claimed and unresolved.

### 2026-08-30 — Q35: Everyday indoor baseline for PC usability targets

The user answered **yes** to assessing the initial PC usability targets under **ordinary indoor lighting, mild room noise, natural speech and a clearly visible face, including clear eyeglasses if worn**. This supplies the everyday-use baseline for Q33's 10-second successful-check target and Q34's at-least-95% genuine-owner first-attempt success target. It does not claim that either target has been achieved.

The first PC version does **not promise the same performance in darkness, heavy noise or with a covered face**. Those conditions require separate validation; requested later outdoor and night capabilities remain on the roadmap. This genuine-owner usability boundary does not remove the agreed photo/video, recorded or AI-generated voice, or substituted-input attack tests, weaken the security requirements, or authorize accepting an uncertain check outside the baseline.

Measurable lighting/noise ranges, capture position, representative sessions, sample counts and evaluation procedures still need an evidence-backed test plan. No camera, microphone, lighting hardware or test result is selected by this answer. Enrollment/retry usability and separate security acceptance criteria remain open.

Next topic: what constitutes failure of the desk-phase security tests, distinct from missing a usability target. No security pass threshold is approved by Q35. Existing budget, endurance, later-capability and biometric motor-arming safeguards are unchanged; no implementation or biometric collection has occurred, and the ticket remains claimed and unresolved.

### 2026-08-30 — Q36: Any observed unauthorized approval blocks milestone-1 sign-off

The user answered **yes** to **any impersonator or spoofed input receiving an "authorized" result during the agreed security tests blocking milestone-1 sign-off**, even if speed and genuine-owner reliability meet their targets. A successful bypass must be **investigated, fixed and retested**. Meeting the usability targets cannot compensate for such a security failure.

Passing this criterion means **no unauthorized approvals observed in the agreed tests**, not a zero underlying risk, immunity to unseen attacks or a return to an "impenetrable lock" claim. Adequate test coverage and the separate enrollment, storage and recovery checks remain required; an empty, trivial or cherry-picked test set cannot establish completion. This is a necessary sign-off condition, not the whole milestone-1 acceptance checklist.

Attack coverage, sample counts, independent evaluation data, statistical uncertainty and retest procedures still need an evidence-backed plan under the existing host/verifier trust boundary. This decision neither removes a required attack class nor chooses model thresholds, weakens liveness/replay protections, or treats failed testing as permanent abandonment of the project.

Next topic: the first PC version's normal-use biometric-data retention policy, separate from the already approved later guest-profile policies and any specifically authorized security-test recordings. No actual test, biometric collection, data deletion or implementation has occurred. Existing budget, endurance, later-capability and biometric motor-arming safeguards are unchanged; the ticket remains claimed and unresolved.

### 2026-08-30 — Q37: Keep encrypted biometric references, discard normal-use raw captures

The user answered **yes** to the first PC app retaining the owner's **encrypted faceprint and voiceprint** while **discarding the original camera images and voice recordings after normal enrollment or verification**. Raw captures may be processed for the operation but are not to be kept afterward as a normal-use archive. This does not authorize automatic enrollment replacement from later verification attempts; existing owner-enrollment and recovery restrictions remain in force, while ordinary update rules still need definition.

The user accepted that these old captures would not be available for replay during troubleshooting. Recordings specifically needed for security testing require **separate explicit permission**; this answer does not grant that permission or authorize collecting any recordings now. Stored faceprints and voiceprints remain sensitive and require protection, rather than being treated as anonymous data.

Encryption/key handling, transient copies, logs, crash artifacts and reliable cleanup still need design and validation; no deletion guarantee or specific storage mechanism is established. This decision does not set an owner-profile expiration period, change the later guest retention rules, or decide retention of all non-capture operational metadata.

Next topic: handling an interrupted PC verification attempt without reusing partial authorization. No interruption policy is approved by Q37. No implementation, biometric collection or actual data deletion has occurred. Existing safety, budget, endurance and later-capability requirements are unchanged, and the ticket remains claimed and unresolved.

### 2026-08-30 — Q38: Interrupted PC checks discard partial authorization

The user answered **yes** to a PC verification attempt interrupted by **camera/microphone disconnection, user cancellation or an app crash** discarding **any partial success** and requiring a **fresh face-and-voice check before authorization**. For example, a passed face check cannot carry over from the interrupted attempt into a later voice check. Reconnection or restarting the app does not make that partial evidence valid again.

The owner's **enrolled profile stays saved**: the owner repeats verification, not enrollment. Interruption is not permission to delete or replace the stored identity, reopen unrestricted first setup, or bypass the established recovery rules. Profile persistence and safe handling of actual storage corruption still require validation.

This decision concerns interruption **during PC verification**, not automatic motor shutdown during flight or a new biometric prerequisite for independent emergency manual control. It does not define the lifetime of a completed authorization, retry limits, cooldowns or all enrollment/recovery interruption behavior. These remain distinct from invalidating an unfinished check.

Next topic: permission for deliberate enrollment updates while the owner's current face and voice still verify, separately from the existing lockout-recovery path. No ordinary-update policy is approved by Q38. No implementation or testing has occurred; budget, endurance, hardening and later-capability requirements remain unchanged, and the ticket remains claimed and unresolved.

### 2026-08-30 — Q39: Routine enrollment updates require current biometrics and owner Windows verification

The user answered **yes** to deliberately updating **either** enrolled owner biometric profile while the existing face and voice still verify requiring **fresh verification against the existing faceprint and voiceprint, plus fresh designated owner Windows-account verification**. Both current biometric checks are required even when only one profile is being updated. **No recovery code is required** for this routine-update path.

Ordinary verification **must not silently rewrite enrollment**. If either existing biometric check no longer works, the separately approved **offline recovery code plus fresh designated owner Windows-account verification** path applies instead. Q23's no-recovery condition remains: without a valid recovery code and with either required biometric check unavailable, this version offers no Windows-only ownership reset.

This approves update authority, not a capture, storage or replacement mechanism. Handling cancellation, crashes or other failures during an update remains unresolved, as do the implementation and validation of fresh verification and account binding. The normal-use raw-capture retention rule remains in force; this decision grants no permission to collect biometric data now or to arm motors.

Next topic: preserving the last valid enrollment if a routine update fails or is interrupted before a replacement is fully checked and saved. No update-failure policy is approved by Q39. No implementation or testing has occurred; existing safety, budget, endurance and later-capability requirements remain unchanged, and the ticket remains claimed and unresolved.

### 2026-08-30 — Q40: Preserve valid enrollment through an interrupted routine update

The user answered **yes** to keeping the existing enrollment until its replacement is **fully checked and successfully saved**, so cancellation or an app crash during a routine update must not leave a half-updated profile. If the update fails before successful replacement, the existing enrollment remains usable and the owner repeats the update under Q39's verification requirements.

After successful replacement, the new profile **replaces** the old one; the old profile does not remain an additional accepted identity. This is a requirement for routine updates while the current biometrics still work, not a promise that keeping an old profile restores access when those biometrics can no longer be verified. The separate lockout-recovery rules remain unchanged.

Storage integrity, interruption handling and replacement behavior require implementation and testing; no crash-proof storage claim, transaction mechanism, backup archive or indefinite old-profile retention is selected. Q37's normal-use raw-capture retention rule remains in force. No biometric collection, actual profile update, implementation or test has occurred.

Next topic: whether a completed PC verification should authorize only its requested action rather than leave an unlocked session for later actions. Q40 does not approve that authorization scope or a session duration. Existing safety, budget, endurance and later-capability requirements remain unchanged, and the ticket remains claimed and unresolved.

### 2026-08-30 — Q41: One PC biometric approval per requested action

The user answered **yes** to a successful face-and-voice check in the **first PC app** approving **only the action requested**, rather than leaving the app unlocked for later actions. Another protected action requires a **fresh face-and-voice check**; a completed approval is not standing permission for subsequent requests.

Existing action-specific requirements remain in force, including designated owner Windows-account verification where already required. This decision does not replace the separate recovery-code-plus-Windows lockout-recovery path with a requirement to pass unavailable biometrics. It concerns the scope of normal PC biometric approval, not a new recovery policy.

This is **not a decision about how often verification is required during flight**. The established owner authorization for every new arming request and independent in-flight emergency manual control remain unchanged. Binding approval to the requested action, freshness and preventing reuse still need design and validation; no numeric timeout or implementation mechanism is selected.

Next topic: observable completion criteria for the manual-flight side of milestone 1, building on the existing simulator-first learning direction. Q41 does not approve a flight-skill checklist or establish completion of the remaining PC hardening and acceptance work. No implementation, testing or flight has occurred; existing budget, endurance and later-capability requirements remain unchanged, and the ticket remains claimed and unresolved.

### 2026-08-30 — Q42: Repeatable basic radio-controlled flight as an M1 requirement

The user answered **yes** to the flying side of milestone 1 requiring, **after simulator practice**, repeatable **takeoff, steady hovering, controlled movement and landing** of the self-built drone **using the radio while keeping it in sight**. This establishes an observable basic-piloting requirement, not a claim that the user or aircraft has already demonstrated it.

**Flight stabilization may remain enabled.** Pilot control through the radio does not require disabling stabilization or selecting an unassisted flight mode. No exact flight mode, practice-hour minimum, repetition count, maneuver tolerance or test procedure is chosen by this answer; those need a suitable acceptance plan.

The piloting requirement sits **alongside separate build and safety checks**, not in place of them or the hardened owner-only PC acceptance work. It does not add autonomous following, the loaded twenty-minute endurance demonstration or biometric motor arming to the earlier manual-learning phase. The approved later capabilities, endurance requirement and arming safeguards remain unchanged.

Next topic: build review and support for the first flights, informed by primary-source safety guidance. No experienced-helper requirement or commissioning checklist is approved by Q42. No build, configuration, purchase, test or flight has occurred; the $600 lifetime target and working ceiling remain, and the ticket remains claimed and unresolved.

Decision support for the next question: [Milestone-1 flight readiness](../../../docs/research/milestone-1-flight-readiness.md), checked 2026-08-30. The report distinguishes official first-flight hazards and commissioning guidance from our proposed experienced-helper requirement; the latter remains unapproved.

### 2026-08-30 — Q43: Solo novice baseline, not approval of required first-flight help

The user stated that they are a **solo builder and a novice**, then answered **yes to the clarified question** asking whether solo also means expecting to conduct the first flights **without experienced in-person help**. This yes answers that clarification, **not the original proposal to require an experienced builder/pilot's review and presence**.

Plan around the user doing the building and not having experienced in-person first-flight support. No helper requirement has been approved, and no helper's availability, fee or scheduling may be assumed. This does not prohibit accepting help later, reject every form of remote review, or authorize contacting anyone. Experienced review and first-flight assistance remain the assistant's recommendation, not an adopted milestone prerequisite.

The clarification is **not evidence that solo first-flight testing is safe or that the aircraft is ready to fly**. Q42's separate build and safety checks, simulator-first learning and demonstrated piloting requirements remain; AI guidance cannot physically inspect the aircraft or supervise a flight. The commissioning and acceptance plan still needs evidence and validation against the solo-novice constraint. The [flight-readiness research](../../../docs/research/milestone-1-flight-readiness.md) retains the relevant hazards and the distinction between source guidance and our recommendation.

Next decision: whether a failed safety check or unexplained motor/control behavior should block takeoff and further test flights until investigated, corrected and rechecked, even if this delays milestone 1. No specific stop rule, checklist, flight procedure or test result is approved by Q43. No build, configuration, purchase or flight has occurred; existing budget, endurance, biometric safeguards and later-capability commitments remain unchanged, and the ticket remains claimed and unresolved.

### 2026-08-30 — Q44: Pause unsafe flying while troubleshooting and independent work continue

After the question was rephrased and a wrong-direction motor was given as a concrete example, the user answered **"ok then yes"** to **keeping the aircraft grounded when a safety problem appears, while actively troubleshooting and progressing other independent parts of the project**. Takeoff and further test flights wait until the problem is investigated, resolved and the required checks pass. Simulator practice and PC biometric work may continue when safe and independent of the aircraft fault; the whole project need not be put on hold.

A safety problem here means a fault that could cause injury, damage, a crash or loss of control, not merely an unrelated cosmetic issue. The motor-direction example was illustrative, not a diagnosed fault, an approved powered-test procedure or an indication that equipment has been bought. Grounding does not make hazardous ground testing safe, and this decision is **not an instruction to cut motors in flight**; existing emergency manual-control and safe-landing protections remain.

The user wants to **minimize avoidable delays and use AI and online resources extensively for support, learning and troubleshooting**. This does not establish a zero-delay schedule, treat an AI answer as proof a fault is fixed, or waive required checks. Development assistance using online resources does not change the project's existing **offline-operation requirement**.

The solo-novice baseline remains; no experienced-helper requirement is introduced. The detailed commissioning checklist, test procedures and evidence of readiness remain unresolved. Next, assess the remaining milestone-1 inputs and hardware/endurance/budget dependencies rather than infer another approved requirement. No implementation, purchase, physical test or flight has occurred; earlier capabilities and the $600 lifetime target and working ceiling remain unchanged, and the ticket remains claimed and unresolved.

### 2026-08-30 — Hardware/endurance and local-PC evidence after Q44

The approved user-facing criteria now support a focused feasibility investigation before the next parts decision; unresolved engineering quantities are not replaced with additional generic approvals. The following reports are new, uncommitted decision support in the main checkout, not completed M1 validation or an approved shopping list:

- [Local PC capability inventory](../../../docs/research/local-pc-capability-inventory.md): read-only checks identify an Intel Ultra 7 255H, approximately 31.40 GiB reported RAM, RTX 4050 Laptop GPU, HP 5MP/IR camera names and input-related audio endpoints. This supersedes the GPU-unknown inventory assumption, but does not establish capture access, usable acceleration, liveness, security or zero additional desk-phase cost. No capture or benchmark occurred.
- [Loaded endurance feasibility](../../../docs/research/loaded-endurance-feasibility-round.md): the examined manufacturer's motor tests use a 7.5-inch propeller and a higher thrust region than the illustrative loaded-hover requirement. They do not substantiate the selected 7-inch aircraft's 20 useful minutes plus reserve. Battery energy/mass comparisons and sensitivity calculations are explicitly not approved reserves, battery endpoints or achieved flight times.
- [Hardware budget feasibility](../../../docs/research/hardware-budget-feasibility-round.md): illustrative comparisons reach $690.59 or $709.69 using the prior, partly estimated aircraft/ground subtotal plus compute and GPS, before several retained capabilities. Some quoted compute options are unavailable at the checked vendors. These are incomplete conditional comparisons, not a purchase-ready basket, minimum possible cost, proven global impossibility or permission to exceed $600. Controller all-arming gate enforcement and the full workload remain unvalidated.

**Next input, Q45, remains unanswered:** whether the user is open to evaluating a phone they already own as the offline voice controller instead of a separate handheld computer. This is a proposed evaluation, not selection of a phone architecture, an assumption that a suitable phone is owned, proof of affordability or removal of biometric checks or requested commands. Model, performance, audio, radio/interface, power and security suitability would still need investigation if evaluation is accepted. Live-video/HUD expectations from the earlier Gemini proposal also remain unratified; neither must be silently costed as zero.

The detailed M1 acceptance protocol, complete lifetime-cost scope and basket, demonstrated hardware compatibility/endurance and sketch-level later sequence remain unresolved. All approved capabilities and safety prerequisites remain; no purchase, installation, implementation or flight is authorized by these findings. The ticket stays claimed, with no `/to-spec` handoff.

### 2026-08-30 — Q45: Pursue the phone-based offline handheld direction

After clarifying that this means a phone app or possibly an offline-capable web app, the user answered **"yeah lets do that i actaully like that alot"**. This approves **pursuing and evaluating an existing phone as the offline handheld voice controller instead of building a separate handheld computer**. It is not a final validated architecture or a decision between a native app and a web app.

The proposed role includes microphone input, offline voice verification and command understanding, battery/flight-status feedback, command confirmations and sending authorized requests to the drone. All required biometric checks and command permissions remain; the phone does **not** replace onboard computation, the drone's face-verification role, the flight controller or independent emergency radio control. Additional radio/interface hardware may still be needed. Live-video/HUD expectations remain a separate unresolved proposal, not implied by status feedback.

The phone's make/model and operating system are still unknown. Offline processing, microphone and audio-route suitability, app lifecycle behavior, radio connectivity, power, storage/security and any interface costs require investigation before choosing an implementation. No phone purchase, guaranteed savings, zero-cost handheld, shorter development schedule or complete $600 fit is established.

Milestone 1 remains the native-Windows owner-only PC phase plus manual learning; this answer does not move phone-app implementation or autonomous flight into M1, select the later milestone order, or authorize coding, installation, enrollment or flight. The [glossary](../../../CONTEXT.md) now distinguishes the handheld voice controller from onboard flight control and the emergency radio. The [hardware research](../../../docs/research/hardware-budget-feasibility-round.md) records this decision status while retaining its original evidence and open compatibility checks.

Next input: the phone model the user intends to use, so platform-specific facts can be investigated rather than assumed. No model or operating system is selected by Q45. Existing endurance, safety and capability commitments remain, and the ticket stays claimed and unresolved.

### 2026-08-30 — Q46: iPhone 17 Pro identified for handheld evaluation

The user answered **"iphone 17 pro"** when asked which phone they intend to use. Record **iPhone 17 Pro** as the user-reported device for Q45's existing-phone handheld evaluation. Its installed iOS version is unknown; no phone inspection, connection or compatibility test has occurred.

This identifies the evaluation target, **not a native-app versus web-app decision** or evidence of offline voice verification, replay resistance, background operation, radio connectivity or performance. Platform development/signing access, any additional interface hardware and lifetime costs still require investigation. Phone reuse does not imply zero cost or a complete $600 fit.

Milestone 1 remains Windows-first PC biometrics plus manual learning. Onboard face verification/computation, independent emergency radio control, biometric arming safeguards, endurance and all other retained capabilities remain unchanged. No installation, implementation, biometric capture, purchase or flight is authorized by this answer. Platform-specific primary-source research will inform the next question; the ticket stays claimed and unresolved.

Decision support: [iPhone handheld feasibility](../../../docs/research/iphone-handheld-feasibility.md), checked 2026-08-30 and preserved as a new uncommitted report in the main checkout. Apple documents local transcription/model execution and interruptible native background recording, but those APIs do not validate the required speaker verification, anti-spoofing or complete command pipeline. Browser offline/background behavior and a compatible phone-to-radio interface remain unverified; no route is selected.

The native build workflow introduces a material development-access/cost dependency: compatible Mac/Xcode access is unknown. Apple's free personal-device testing has seven-day provisioning limits; paid membership is optional for that testing, not an automatically required purchase. These constraints belong in the lifetime-cost assessment, not an assumed overrun. **Next input, Q47, remains unanswered:** whether the user already has access to a Mac, including one they could borrow, for iPhone development. This is not a purchase request or a decision to require a Mac or native app; M1's Windows setup remains unchanged.

### 2026-08-30 — Q47: No owned or borrowable Mac available

The user answered **"i dont have a mac and i cant borrow one"**. Planning must not assume local or borrowed Mac access for iPhone development. This resolves Q47's resource question; it does not authorize buying or renting a Mac, paying for developer membership or cloud builds, uploading project source/credentials, or changing the $600 lifetime target and working ceiling.

The existing iPhone 17 Pro remains the handheld evaluation target. Lack of a Mac does **not itself select a web app or establish that a native app is impossible**. Investigate development paths usable from Windows and their actual device-testing, native-capability, signing and recurring-cost constraints before recommending a platform. An online development/build service is distinct from an internet-dependent operational controller; offline flight operation remains required, and no service use is approved by this answer.

Milestone 1 remains the native-Windows PC phase plus manual learning. No later handheld capability, biometric requirement, independent emergency radio, onboard role or endurance target is removed, and no implementation or installation has occurred. The ticket remains claimed and unresolved. The [iPhone feasibility report](../../../docs/research/iphone-handheld-feasibility.md) retains earlier evidence and will record the bounded no-Mac follow-up separately.

The report's Q47 supplement identifies a documented Windows-triggered hosted native-build option, using Expo EAS as a concrete example rather than a selected stack. Its physical-iPhone build route requires paid Apple Developer signing; the currently listed $99 annual membership is separate from any build-service charges and is not approved expenditure. Free Expo Go or simulator demonstrations do not establish our custom native offline ML/audio/radio capabilities. Source/credential uploads require separate approval; online compilation is distinct from the required offline controller operation.

**Next input, Q48, remains unanswered:** during a deliberately enabled drone voice-control session, should commands remain available with the phone's screen locked and the phone in a pocket? The recommendation is yes for the hands-free use case, only during intentional controller use rather than all-day listening. This is not yet an adopted requirement, a promise of background reliability, approval to record/store audio, a microphone/accessory selection or a native-versus-web decision. Audio routing, interruptions and security validation remain engineering work; no foreground-only capability reduction is assumed.

### 2026-08-30 — Q48: Locked-screen and pocketed use during deliberate voice-control sessions

The user answered **yes** to commands remaining available during a **deliberately started voice-control session while the phone is locked and in a pocket**. Adopt this as a requirement for the later handheld, supporting the hands-free use case, **not all-day or automatically permanent listening**. A foreground-only interface must not silently be treated as satisfying the finished handheld requirement.

An active listening session is **not standing authorization to execute commands or arm the aircraft**. Existing identity checks, command permissions, owner approval for new arming and independent in-flight emergency radio control remain unchanged. This answer does not select command-verification frequency, session activation/termination controls, a wake phrase or an interruption-response policy. Locking the phone is not an instruction to shut down aircraft motors.

This is an approved capability requiremilestonement, **not proof of reliable background operation on the iPhone 17 Pro**. Microphone placement/routing, calls and other interruptions, app lifecycle, local model availability, power, security and the radio link still need validation. No native/web platform, build service, developer membership, audio accessory or expenditure is selected. Mac access remains unavailable; M1 remains Windows-first PC biometrics plus manual learning, and the $600 lifetime target and working ceiling and other retained capabilities are unchanged. No implementation, installation, capture or test occurred.

The [iPhone research status](../../../docs/research/iphone-handheld-feasibility.md) now distinguishes this approved requirement from earlier open questions while retaining the original findings. **Next input, Q49, remains unanswered:** whether the user already uses earbuds or a headset with a microphone with this iPhone, and its model if so. Start by investigating existing equipment rather than assuming a purchase or verified compatibility. The prior PC inventory's EarPods endpoint does not identify the phone's accessories or establish a usable phone audio route. The ticket stays claimed and unresolved.

### 2026-08-30 — Q49 clarification: No external microphone reported in use

The user replied **"I dont use a microphone and why would i need one ?"** to the question about microphone-equipped earbuds/headsets used with the iPhone. No external microphone or headset is reported in use. Do not infer that the phone lacks built-in microphones, that no accessory is owned, that a purchase is approved, or that every future accessory is rejected.

Pause the next grilling question to explain that an external microphone is **not an adopted requirement**. The question arose from Q48's pocketed-phone goal: obstruction and clothing noise are an audio-quality concern to evaluate, not a demonstrated failure of this iPhone. Recommend evaluating the built-in microphones before considering an accessory; no capture/test or new hardware choice is authorized by this exchange. Locked-screen app support and pocketed audio quality are separate validation needs. Q48, the budget and existing security/handheld requirements remain unchanged; the ticket stays claimed and unresolved.

### 2026-08-30 — Q49: Use existing Apple EarPods as the microphone direction

After the microphone clarification, the user stated **"now that you say it we should use earbuds i have the regular apple earpods"**. Record ownership of user-identified **Apple EarPods** and approval to use that existing pair as the handheld microphone direction, subject to compatibility and performance validation. This supersedes the earlier lack of a reported accessory; it does not establish that the pair is already used with this iPhone.

The exact connector is unknown. Do not silently substitute wireless AirPods, select an EarPods variant, assume direct iPhone compatibility or add an adapter/replacement purchase. Microphone routing, outdoor speech/voice-verification quality and locked-screen operation remain untested. Q48's deliberately started, locked/pocketed sessions, all security requirements, the $600 lifetime ceiling and Windows-first M1 remain unchanged. No capture, installation, implementation or hardware test is authorized by this planning choice.

The [iPhone feasibility note](../../../docs/research/iphone-handheld-feasibility.md) records the accessory direction and Apple's different connector variants. **Next input, Q50, remains unanswered:** whether this pair plugs directly into the iPhone 17 Pro's charging port without an adapter. The prior PC's EarPods endpoint does not answer that physical-connector question. The ticket stays claimed and unresolved.

### 2026-08-30 — Q50: Existing USB-C EarPods identified and basic connection confirmed

The user said **"i plug them in this is the one I use"** and supplied [Apple's EarPods (USB-C) product page](https://www.apple.com/shop/product/myqy3am/a/earpods-usb-c), product identifier `MYQY3AM/A`. This resolves the unknown connector: the selected existing pair is **Apple EarPods (USB-C)**, with user-reported plug-in use. Apple lists **iPhone 17 Pro** among compatible models on that page, checked 2026-08-30. Do not add a new pair or a headphone connector adapter for this basic connection.

Manufacturer compatibility and the user's report are not project validation. Actual microphone routing, outdoor speech and voice-verification quality, anti-spoofing, offline processing and locked-screen behavior remain untested. Occupying the phone's USB-C port also does not settle simultaneous charging or any future wired radio interface; those integration needs and costs remain open.

The [iPhone feasibility note](../../../docs/research/iphone-handheld-feasibility.md) records the source and supersedes prior connector uncertainty while preserving earlier research. No capture, installation, implementation, purchase or flight occurred. The app platform/build-service choice, no-Mac constraint, Windows-first M1, $600 lifetime ceiling, safety and other capabilities are unchanged. Detailed phone design remains a later-milestone matter; the remaining ticket-10 frontier is being checked against its M1 inputs, full-budget feasibility and sketch-level ladder. The ticket stays claimed and unresolved.

**Next decision, Q51, remains unanswered:** whether the finished system should let the user open the phone app and see a live view from the drone's camera, in addition to voice commands and battery/status information. The recommendation is yes as a later capability supporting inspection and patrol, not M1 scope. This is the previously unratified live-video proposal, not a resolved feature or permission to exceed the budget. If adopted, offline video transport, hardware/power costs and feasibility must be accounted for; resolution, latency, range and recording policy are not bundled into this question. Q48's locked/pocketed voice requirement remains unchanged.

The current next question is chosen because it affects the complete hardware and lifetime-cost scope. The installed iOS version remains an input for later phone feasibility/testing, not a new blocker for Windows-first M1. Full-budget/endurance feasibility, M1 acceptance details and the later milestone order still prevent closing ticket 10.

### 2026-08-30 — Q51: Offline live camera viewing on the phone as a later milestone

The user answered **yes** to the finished system letting them open the phone app and see **live video from the drone's camera alongside battery/status information**, with the recommendation that it remain **offline and a later milestone**. This ratifies the previously open live-view capability; it is not added to Windows-first M1 or treated as already implemented.

Include the video path's hardware, software workload, power/mass and lifetime costs in feasibility work under the unchanged **$600 target and working ceiling**. Existing command telemetry does not establish a working video transport. No parts, native/web platform, build service, expenditure, resolution, frame rate, latency, range or endurance-test video duty cycle is selected. The approved endurance target and other capabilities remain; no budget fit or working stream is demonstrated.

Live viewing is distinct from saving recordings and does not approve a retention policy, every element of the original HUD proposal, or screen-based manual piloting. Q48's locked/pocketed voice-control requirement remains; taking out the phone to view video does not require keeping its screen open for voice commands. The [phone](../../../docs/research/iphone-handheld-feasibility.md) and [budget](../../../docs/research/hardware-budget-feasibility-round.md) status notes preserve prior evidence while marking live viewing as approved scope. No installation, capture, implementation, purchase or flight occurred; the ticket stays claimed and unresolved.

**Next decision, Q52, remains unanswered:** for the first live-view version, should video be an inspection/framing aid while manual flying still relies on watching the aircraft directly, without treating the phone screen as a piloting display? The recommendation is yes for that first version, not a permanent ban on discussing later video-piloting capabilities. This question establishes intended use before engineering performance targets; it does not bundle a resolution, latency number, operating distance, regulatory permission or budget increase.

### 2026-08-30 — Q52: First live view is an inspection/framing aid

After the distinction between viewing the camera feed and steering through it was explained, the user answered **"ok then yes"**. The first live-view version is for **inspection and checking camera framing**. If flying manually, the pilot watches the actual aircraft directly rather than relying on the phone video as the piloting display.

This concerns the first live-view version, not a permanent prohibition on discussing later first-person-view piloting. No later FPV capability is requested or approved by this answer. Following, orbiting, Watching, patrol and voice commands remain planned; the clarification's ordinary word "watching" described viewing the feed, not a change to the glossary's **Watching** command.

Q51's offline live video and battery/status scope and Q48's locked/pocketed voice sessions remain. Video transport, image quality, latency, range, recording policy and endurance-test video duty cycle still need suitable requirements and feasibility evidence; Q52 does not approve unreliable or stale video. M1 remains Windows-first PC biometrics plus manual learning. The $600 lifetime target/working ceiling, endurance goal and safety requirements are unchanged.

Return to hardware/endurance/lifetime-cost feasibility, M1 acceptance inputs and the sketch-level later ladder. No implementation, purchase, installation, capture or flight occurred. The ticket remains claimed and unresolved; no new decision is inferred from this approval.

**Next input, Q53, remains unanswered:** how long should the $600 total cover using the finished drone after all planned features are built? This asks for the operating period used to account for replacement batteries, propellers, repairs and any recurring costs, not permission to raise the ceiling or leave requested capabilities out. Recommend a defined period and an explicit upkeep allowance; do not silently assume a short lifetime or promise unlimited repairs. Existing reports identify this missing cost boundary. Hardware, loaded-endurance and live-video feasibility remain engineering work, not quantities for the user to invent.

### 2026-08-30 — Q53 clarification: $600 goal, conditionally up to an $800 maximum

The user requested another explanation of upkeep and clarified that **$600 is the goal**, **$800 is the maximum**, and even $800 feels high: they would consider it only if the tradeoffs are worthwhile. This supersedes the earlier numeric rule treating $600 as the absolute working ceiling. Continue optimizing toward $600. Any proposal above it must show its specific additional cost, relevant benefits and limitations for the user's approval; $800 is not the default shopping budget or blanket spending permission, and exceeding $800 is not authorized.

No parts or package is selected. Previous incomplete conditional subtotals are not proof of a complete fit below either amount. All requested capabilities and safety/endurance requirements remain. The word "drone" does not silently move tools, radio, charger or later milestones outside the budget; prior full-project coverage remains until explicitly clarified.

**Q53's upkeep boundary remains unanswered.** Explain upkeep as later replacement or repair costs—for example, a propeller broken a year after completion. The user has not chosen an operating period, excluded maintenance or approved a recurring fee.

**Clarified Q53 proposal, not yet approved:** apply the $600 goal and conditional $800 maximum to achieving the complete planned build, including tools, radio, charger, initial spares and all planned capabilities, and show future maintenance as a separate budget. Recommend that clear accounting separation, but do not adopt it before the user confirms. Necessary recurring charges must still be disclosed, not hidden or treated as zero. This replaces the request to guess years of ownership with a concrete cost-boundary decision.

The shared map and research status notes reflect the numeric clarification while preserving earlier history and estimates. No implementation, purchase, installation, capture or flight occurred. Ticket 10 remains claimed and unresolved.

### 2026-08-30 — Q53: Complete-build budget; future upkeep accounted for separately

The user answered **"lets do your recommendation"** to the clarified proposal. Apply the **$600 goal and conditional $800 absolute maximum** to completing the **whole planned project**: aircraft, radio, charger, tools, initial spares and **all requested capabilities**, including later milestones. This is not an M1-only allowance. Future repairs and worn-out replacements after completion are **budgeted separately**.

This resolves Q53's build-versus-upkeep boundary; the earlier request to choose years of ownership is no longer a prerequisite for costing the complete build. Separate upkeep is not free upkeep, an approved maintenance amount or permission to disguise initial build costs and unfinished features as repairs. Necessary development/build costs and recurring charges must be disclosed; no service, membership or recurring fee is selected by this answer.

Keep optimizing toward $600. Any proposal above it must show a specific price difference, relevant benefits and limitations for the user's approval; $800 remains the absolute maximum, not the default shopping budget. No complete fit or qualifying hardware package is established, and all safety, security and endurance requirements remain.

The next work is bounded primary-source feasibility research on current aircraft/ground costs, matched 7-inch propulsion evidence and onboard compute/offline live-view costs. These facts inform the next decision; another arbitrary approval or guessed engineering number is not a substitute. Existing research is preserved, with the updated accounting boundary recorded separately. No purchase, installation, implementation, capture or flight is authorized. Ticket 10 remains claimed and unresolved.

### 2026-08-30 — Post-Q53 feasibility findings and Q54 delivery intent

The bounded primary-source research is preserved in the [complete-build synthesis](../../../docs/research/complete-build-feasibility-after-q53.md), with separate [aircraft/ground](../../../docs/research/aircraft-ground-cost-after-q53.md), [propulsion](../../../docs/research/seven-inch-propulsion-after-q53.md) and [compute/video](../../../docs/research/compute-video-cost-after-q53.md) ledgers.

The conservative conditional route is **$857.87 with Pi 4 or $868.87 with Pi 5**, including one shared card reader, before shipping/tax and several retained feature/integration costs. Some exact variants are unavailable. These totals exceed the $800 maximum and are **not recommended purchases, minimum possible prices or proof that all redesigns fail**. The small checked radio/compute savings do not establish a fit. No expenditure or feature cut is inferred.

Visually checked manufacturer-branded 7-inch motor data improve the prior evidence gap but do not establish twenty useful minutes plus reserve. The better published propeller point is included, not omitted to exaggerate the shortfall. Camera/Wi-Fi/browser reuse is a documented integration candidate, not proof of required range, combined workload or locked-screen voice operation.

**Q54 remains unanswered:** what is the heaviest item the user wants the finished drone to deliver? The user can name an object instead of supplying engineering numbers. The recommendation is a lightweight, non-hazardous starting example such as keys; no final load cap or item is selected. This user-intent input affects complete-build sizing and does **not** redefine the approved no-extra-cargo endurance reference. The question was sent while the cost comparison was being completed.

Q53's budget/accounting approval, every retained capability and all safety requirements remain. Continue reopening the unsuccessful hardware route, completing M1 acceptance inputs and agreeing the later ladder; no implementation, purchase, installation, capture or flight occurred. Ticket 10 stays claimed and unresolved.

### 2026-08-30 — Q54 clarification: Tentative 3 lb cargo idea, not an approved requirement

The user answered **"not sure yet ? maybe like max 3lbs is that alot"**. Treat **3 lb of delivery cargo** as a tentative possibility to discuss, not a confirmed maximum, minimum demonstrated capacity or instruction to redesign/buy parts for that load. Q54 remains unresolved.

Three pounds converts to **1.3608kg**. The [current illustrative mass calculation](../../../docs/research/seven-inch-propulsion-after-q53.md#what-the-new-data-support) is **1.2984kg** for aircraft, one flight pack and provisional equipment allowances, not a measured finished aircraft. Adding that cargo gives approximately **2.6592kg (5.86 lb)** before any additional cargo mounting/release/packaging. The cargo would roughly double this estimated flying mass. These calculations explain scale; they do not establish safe payload capacity, loaded endurance or impossibility.

Being able to produce enough peak thrust for a brief lift is not proof of controlled delivery with energy and control margins. ArduPilot notes greater payloads increase thrust-loss/yaw-imbalance warning likelihood and that motor saturation can compromise control. No such fault is diagnosed here and no loaded-flight test is authorized. [Primary guidance](https://ardupilot.org/copter/docs/thrust_loss_yaw_imbalance.html), checked 2026-08-30.

Recommend not locking the tentative 3 lb number before identifying a real intended delivery item and assessing feasibility. Clarify whether there is a particular item the user hopes to carry; no smaller cargo cap or replacement example is adopted. The $600 complete-build goal, conditional $800 maximum, retained delivery capability and separate twenty-useful-minute reference **without extra delivery cargo** remain unchanged. No engineering implementation, purchase, installation, capture or flight occurred; ticket 10 remains claimed.

### 2026-08-30 — Q54 clarification: Delivery wanted; no current item or carrying limit selected

The user clarified **"I dont have a real example yet at all im not sure what id carry on it but i do want that option"**. Delivery remains a requested later capability even without a current cargo example. This settles the immediate intent question; do not keep requiring the user to name an item before continuing planning.

Cargo type and carrying capacity remain open. The earlier **3 lb** suggestion is tentative, not a confirmed requirement, promised capacity or approved redesign target. No smaller limit, example item, cargo attachment/release mechanism or modular design is selected by this answer. Bring evidence-backed capacity options and their costs, limitations and safety implications back with the hardware proposals for agreement; do not silently substitute a token payload or treat delivery as removed.

The complete-build **$600 goal and conditional $800 absolute maximum** still include the requested delivery capability, including its necessary hardware. Future maintenance is separate, not a place to move unfinished delivery costs. The approved **twenty useful minutes plus separate recovery reserve without extra delivery cargo** remains the reference test; no loaded-cargo endurance claim is established.

Continue hardware/endurance/budget feasibility work, then the remaining M1 acceptance inputs and sketch-level later milestone order. This clarification does not authorize implementation, purchases, installation, cargo tests or flight. Ticket 10 remains claimed; its broader planning work and the delivery capacity decision are not complete.

### 2026-08-30 — Resumed after Q54: battery/cost evidence; Q55 pending

The user asked to resume `/grill-with-docs`. Two bounded primary-source investigations are preserved in the main checkout: [hardware cost options](../../../docs/research/hardware-cost-options-after-q54.md) and [endurance/cargo directions](../../../docs/research/endurance-cargo-options-after-q54.md). These are new, uncommitted supporting reports, not approved components or evidence of a complete budget fit.

Charger/iron power sharing could avoid the previously priced $14.99 adapter, subject to electrical verification and separate charging/soldering operation. A mixed SEQURE/FLYWOO controller/ESC saves only $9.97 at opened-page prices and is not recommended pending harness, storage/script and authorization compatibility. Crediting both conditional savings to the earlier incomplete comparison leaves $832.91–$843.91, still over $800 with the old LiPo allowance and unresolved feature costs. No safety equipment, chosen radio, spares or capabilities are removed, and this is not a minimum possible price or purchase-ready basket.

Factory-built 6S2P Li-ion alternatives provide a materially different energy direction: Flywoo P30B 6000mAh is listed at 596.2g/$89.99, with 129.6Wh typical cell-based nominal energy; iFlight Fullsend 8000mAh is listed at 840g/$83.99 and 177.6Wh. They add approximately 61g/$90 or 305g/$78 respectively versus the earlier one-installed/two-purchased LiPo comparison. Stock, current ratings, supplied revisions and installed compatibility remain qualified in the report. Larger nominal energy does not establish useful flight time, safe reserve or cargo capacity; the examples at 250g, 500g and tentative 3lb are analytical comparisons, not adopted limits. The no-extra-cargo endurance reference is unchanged.

**Q55 asked, not answered:** Does delivery still require verifying the intended recipient's face before releasing the item, as described in [Project Idea](../../../Project%20Idea.md), or is transport without that check enough? Recommend retaining recipient verification if secure delivery is wanted, with safe landing independent of successful recipient verification. A plain cargo strap must not be silently counted as satisfying authenticated release. The original aspiration remains pending clarification; no transport-only scope reduction, release mechanism, recipient enrollment policy or theft-resistance claim is selected.

ArduPilot documents gripper actuation through multiple command paths and configurable failsafe release. That establishes actuator support, not this project's recipient-verification or physical-security guarantees; gating the applicable release paths would require separate design and validation. [Official gripper documentation](https://ardupilot.org/copter/docs/common-gripper-landingpage.html), checked 2026-08-30. The existing safe-landing and independent emergency-control requirements remain in force.

Wait for Q55 before branching into its dependent delivery choices. Cargo sizing, a complete costed hardware proposal, remaining M1 acceptance inputs and the sketch-level later ladder remain open. No purchase, installation, implementation, capture, physical test or flight occurred. Ticket 10 remains claimed; there is no `/to-spec` handoff.

### 2026-08-30 — Q55: Retain recipient verification before cargo release

The user answered **"keep recipient verfication"**. Retain verification of the **intended recipient's face before releasing delivery cargo** as a required part of the later delivery capability. Transport without that check is not an accepted substitute. This confirms a requirement, not a working release gate or proof of biometric security.

Recipient verification does not override the existing mandatory safe-landing, battery-protection or independent emergency-control requirements. Receiving cargo does not by itself grant guest command permissions, ownership or arming authorization. Recipient enrollment/selection, anti-spoofing, release-path enforcement, interruption handling and verification-failure recovery remain unspecified; no extra identity factor or bypass is selected.

The physical protection provided by the cargo holder is still open: blocking the drone's release command does not establish that someone cannot remove cargo by hand. No latch, container, tamper-resistance level, aerial release, cargo cap or delivery endurance is approved. Keep necessary delivery hardware, mass and power within the complete-build comparison; the $600 goal, conditional $800 maximum and no-extra-cargo twenty-useful-minute reference are unchanged.

**Next round, Q56–Q57, proposed but unanswered:**

- **Q56 — Physical cargo protection:** Should verification only gate the drone's release mechanism, or must the holder also prevent ordinary hand-removal before verification? Recommend the latter as a modest protection target, without promising resistance to force or theft of the entire aircraft. Mechanism feasibility, mass and cost remain engineering work.
- **Q57 — First delivery handoff:** Must the first delivery version be landed and its motors stopped before cargo is released? Recommend a ground handoff; any airborne-release request would need separate design and safety/permission review. This proposal is not yet an adopted delivery restriction.

These independent questions affect the hardware/cost scope. Detailed later delivery protocols remain deferred; broader hardware feasibility, M1 acceptance inputs and the later milestone order are still open. The glossary now distinguishes a recipient from command-authorized roles. No purchase, installation, implementation, capture or physical test occurred. Ticket 10 remains claimed and the documentation remains uncommitted.

### 2026-08-30 — Q56–Q57: Physical cargo protection and ground handoff

The user answered **"yes to both recommendation"**, approving both proposals:

- **Q56:** The cargo holder must prevent ordinary manual removal before recipient verification; merely blocking an automatic release command is insufficient. Resistance to force or theft of the whole aircraft remains a separate, unproven protection. No specific holder, latch, dimensions, mass, carrying limit or tamper-test protocol is selected.
- **Q57:** The **first delivery version releases cargo only after landing and with the motors stopped**, to the verified intended recipient. Airborne delivery is outside this first version; no permanent ban or approved later airborne-release feature is inferred. Safe landing remains independent of successful recipient verification.

These are required behaviors, not demonstrated protections. Necessary holder/release hardware, mounting, power and mass remain inside the complete-build assessment. The budget, no-extra-cargo endurance reference, guest permissions and owner-only authorization for every new arming request remain unchanged.

**Q58 — After-delivery return, proposed but unanswered:** Should the first delivery version remain landed and disarmed for collection, or must it fly back after the recipient takes the item? Recommend remaining disarmed for collection in the first version. A return flight after disarming requires a new owner face-and-voice authorization under Q8/Q26; recipient verification cannot substitute, and an unattended return cannot silently reuse the outbound approval. Remote owner verification and safe re-arming at the delivery site are not established. Do not assume automatic disarming is already implemented merely because the required motors-stopped handoff is approved; landed/disarmed collection is the proposed next policy.

This return-trip choice affects the later capability and integration scope. Detailed recipient enrollment, holder failure/recovery and other later protocols remain deferred. No hardware selection, purchase, installation, implementation, biometric capture or physical test occurred. Ticket 10 remains claimed; documentation remains uncommitted.

### 2026-08-30 — Q58: Carry the drone back after the first delivery version's handoff

After clarification that collection means physically collecting **the drone**, the user answered **"carrying it back"**. The first delivery version remains **landed and disarmed after handoff**, with someone carrying the aircraft back rather than an automatic return takeoff. The person responsible for collection and the handling procedure are not selected here.

Recipient face verification, protection against ordinary manual cargo removal before verification, and landed/motors-stopped release remain required. Q58 grants no recipient arming permission, owner-authentication bypass or remote re-arming implementation. It does not forbid a separately designed later return-flight capability, promise force/theft resistance, or change normal return/landing protections during other flights.

This settles the initial delivery return choice, not cargo capacity or a complete delivery design. Hardware mass, cost, mechanism reliability, recipient enrollment and failure/recovery behavior remain unresolved. The $600 complete-build goal, conditional $800 maximum and twenty-useful-minute no-extra-cargo reference are unchanged. No purchases, implementation or physical tests occurred.

Return to the previously approved scope of detailed M1 inputs plus a sketch-level later ladder; do not expand into every delivery protocol now. **Q59 — Proposed milestone order, not yet approved:**

1. **M1:** Existing agreed scope: self-built manual flight plus hardened owner-only PC biometrics.
2. **M2:** Onboard biometric command gate, offline iPhone voice control and live inspection video, with independent emergency radio control and the required safety/integration checks before flight use.
3. **M3:** Selected-subject following, orbiting, watching and area patrol, with the navigation/avoidance and safety capabilities needed for the validated operating conditions.
4. **M4:** Night-use capabilities, including necessary lighting and validation under the intended conditions.
5. **M5:** Guest access and secure delivery with the approved landed handoff and physical collection; guest and recipient roles remain distinct.

Recommend that priority order, subject to the user's preferences. This is a proposed roadmap, not an implementation design, validated dependency graph, timetable or purchase approval. Each stage keeps applicable permission and safety prerequisites; hardware sizing must still include later features. The later endurance requirement remains independent of this proposed ordering and must not be claimed using stripped-down equipment. All stages remain within the complete-build budget; their placement does not remove their costs. Final M1 acceptance details, hardware feasibility, cargo capacity and shared-understanding approval remain open. Ticket 10 remains claimed; documentation remains uncommitted.

### 2026-08-30 — Q59: Milestone sequence approved

The user answered **"yeah looks good"** to Q59, approving this sketch-level order:

1. **M1:** Self-built manual flight plus hardened owner-only PC biometrics.
2. **M2:** Onboard biometric authorization, offline iPhone voice control and live inspection video.
3. **M3:** Selected-subject following, orbiting, watching and area patrol, with the necessary navigation and obstacle avoidance.
4. **M4:** Lighting and night operation.
5. **M5:** Guest access and secure delivery, including recipient verification, protection against ordinary manual cargo removal, landed/motors-stopped handoff and physically carrying the disarmed aircraft back.

This settles the milestone order, **not** hardware feasibility, implementation details, dates, safety validation or the complete-build budget. The independent emergency radio and applicable permission/safety prerequisites remain. M5 recipient status does not confer guest command access or arming authority. Costs and hardware allowances for every stage remain inside the $600 goal/conditional $800 maximum. The later twenty-useful-minute requirement with its separate reserve remains unchanged and unvalidated.

Return to the remaining M1 acceptance inputs. Bounded PC-evaluation and flight-readiness protocol research is underway; its recommendations require review and are not approved tests or proof of readiness. No software installation, camera/microphone capture, hardware operation or flight is authorized by approving this sequence.

**Q60 — First-time enrollment, asked but unanswered:** Once the app and its models are installed, should normal guided owner enrollment take at most **five minutes**, including face/voice enrollment, designated owner Windows-account confirmation and saving the offline recovery code? Recommend that as an initial usability target, with downloads and troubleshooting measured separately and no weakening of security to satisfy the timer. It is not achieved performance, an automatic security timeout or a replacement for the already approved normal-verification targets. No enrollment-time limit is adopted until the user answers.

The approved order is reflected in the map; detailed later-feature designs remain deferred. M1 acceptance, hardware/budget feasibility, cargo capacity and final shared-understanding approval still prevent closing ticket 10. Documentation remains uncommitted.

### 2026-08-30 — M1 acceptance evidence after Q59; Q60–Q62 pending

Two bounded primary-source reports are preserved: [PC acceptance proposal](../../../docs/research/m1-pc-acceptance-proposal-after-q59.md) and [flight acceptance proposal](../../../docs/research/m1-flight-acceptance-proposal-after-q59.md). Their sample counts, schedules and detailed criteria are **proposals, not approved acceptance rules or executed tests**.

The PC report proposes fresh evaluation sessions separate from development, records timing and first-attempt outcomes separately, and covers live nonowners, face photographs/video, recorded/generated voice, digital input substitution and state/storage/recovery behavior. Its illustrative 95/100 observed successes do not establish a true future success probability of at least 95%; the approved target is not weakened. The proposed negative-test matrix is exploratory, not automatically adequate coverage. Test-resource availability, statistical interpretation and the concrete protocol still need resolution. Specific recording/synthetic-media and volunteer consent must be obtained for a concrete future test session; no blanket biometric capture or upload permission is requested or granted here.

The flight report separates simulator preparation, build checks, commissioning, observed piloting repeatability and closure. Its proposed three-run/two-session criterion is project bookkeeping, not a published safety threshold, proof of solo readiness or a powered-test procedure. Vehicle/site-specific tolerances and suitable commissioning evidence remain engineering work, fixed before acceptance attempts. Q43 does not become an experienced-helper requirement; Q44 still grounds unresolved safety faults.

**Current independent user-choice round, all unanswered:**

- **Q60:** The five-minute normal first-enrollment usability target described above.
- **Q61 — Repeated failed PC verification:** Recommend temporarily delaying further checks while preserving the enrolled profile, rather than requiring re-enrollment solely because several checks failed. The normal retry still requires fresh face-and-voice verification. This asks for the policy direction, not an attempt count, cooldown duration or permanent-ban rule; limits and persistence across restart require subsequent design and validation. Existing recovery requirements and denial of unauthorized actions remain unchanged.
- **Q62 — M1 piloting demonstration:** Recommend three consecutive successful complete takeoff/hover/controlled-movement/landing runs across at least two separately prepared sessions, after commissioning and required safety checks. Every attempt remains recorded; safety or weather conditions override completing a quota. This count is an initial repeatability criterion alongside, not instead of, the separate build/readiness and PC acceptance requirements. No flight authorization or arbitrary maneuver tolerance follows from approval.

These questions do not select the complete research proposals, execution dates, hardware or a spending increase. The approved M1–M5 sequence remains; ticket 10 stays claimed with no `/to-spec` handoff.

### 2026-08-30 — Q60–Q62: Enrollment target, temporary cooldown and piloting demonstration approved

The user explicitly answered **Q60 yes, Q61 yes, Q62 yes**:

- **Q60:** Normal guided first-owner enrollment has a **five-minute-or-less usability target**, after the app/models are installed, including face/voice enrollment, designated owner Windows-account confirmation and saving the recovery code. Downloads and troubleshooting are measured separately. This is a target to validate without weakening security, not achieved performance or an automatic timeout that grants access. Normal verification retains its separate ten-second/at-least-95% targets.
- **Q61:** Repeated failed PC biometric checks cause a **temporary pause in further attempts while preserving the enrolled profile**, rather than forcing re-enrollment solely because several checks failed. Subsequent authorization still requires the appropriate fresh checks; recovery rules are unchanged. The failed-attempt limit, pause duration, escalation/reset behavior and restart persistence remain to be designed and validated. No numeric threshold or permanent-ban rule is approved.
- **Q62:** M1 includes **three consecutive successful complete takeoff–hover–controlled-movement–landing exercises across at least two practice sessions**, alongside separate build, commissioning and safety checks. This is an observed repeatability requirement, not certification of safety or solo readiness. Vehicle/site-specific tolerances, session preparation and detailed evidence handling remain unresolved; safety conditions take precedence over completing the count.

Approval of these three choices does not approve the entire PC/flight research protocols, the PC trial counts/schedule, collecting any biometric samples, hardware operation or flight. The records and research status notes now distinguish these confirmed requirements from remaining proposals. No implementation or testing occurred; budget feasibility, hardware/cargo choices, remaining M1 protocol details and final shared-understanding approval remain open. Ticket 10 stays claimed and documentation remains uncommitted.

**Next independent logistics questions, Q63–Q64, proposed but unanswered:**

- **Q63 — Owner test schedule:** Is an initial evaluation of **100 fresh owner checks over five days**, twenty per day in two short sessions, practical? Recommend that starting schedule to sample more than one sitting. This is an evaluation-effort proposal, not proof that observed 95/100 establishes the underlying 95% target, approval of the whole protocol or permission to begin capture. Interpretation of results and the complete acceptance rule remain separate.
- **Q64 — Live nonowner test availability:** Could **three consenting adults** participate in brief tests of rejecting people other than the owner? Recommend three as an initial small sample if available; ask what is feasible if not. No names or personal details are requested, their consent must be obtained separately before any concrete session, and nobody is contacted. Availability is not an imposed population-performance standard or evidence that this sample alone establishes security. Photos, replays and synthetic media remain separate attack coverage.

Specific test-data permissions, retention and any synthetic-media methods will be presented for consent before concrete test sessions. Exact cooldown parameters and remaining technical protocol work stay open; the user is not being asked to invent engineering thresholds.

### 2026-08-30 — Hardware/carrying follow-up; Q65 removable delivery holder proposed

The user asked **"Ok let's delve into that"**, continuing the hardware/carrying comparison. The current shared decisions through Q62 were read and preserved. This request does not answer Q63–Q64's PC-evaluation logistics, approve a hardware purchase, or change the approved M1–M5 sequence.

New primary-source findings are preserved in [cost-reduction options](../../../docs/research/cost-reduction-options-2026-08-30.md) and [payload-platform options](../../../docs/research/payload-platform-options-2026-08-30.md). They are uncommitted reports with source provenance, not implementation or validated build specifications.

- **Cost:** MicoAir743v2-AIO-45A's ArduPilot variant is listed at $74.99, $34.96 below the earlier $109.95 stack. With the prior conditional $14.99 charger/iron sharing, the earlier incomplete Pi 4 comparison becomes **$807.92**. Do not also subtract the mutually exclusive mixed-stack saving. Mounting, power/current measurement, thermal and authorization compatibility remain qualification work. Missing delivery, avoidance, lighting and other integration costs remain additional; this is not a complete basket or minimum possible price.
- **Battery direction:** Applying only the previously priced two-pack Li-ion substitutions to that conditional comparison would give **$897.92** for the 6000mAh direction or **$885.92** for the 8000mAh direction, before the same missing obligations. Those carried-forward prices are not newly validated stock or landed quotes. Higher nameplate energy is not proven endurance; the selected baseline of two new LiPos has not changed.
- **Size and carrying:** The checked 9/10-inch manufacturers' aircraft figures do not establish twenty useful minutes plus reserve with this project's complete equipment or a safe cargo limit. Root rechecking found conflicting Helion availability; the report records that qualification. The 250g, 500g and tentative 3lb comparisons increase the old illustrative 1298.4g aircraft mass by approximately 19.3%, 38.5% and 104.8%, before additional holder/packaging. They are analytical examples, not adopted targets or demonstrated capacities.

**Q65 — Delivery hardware between missions, proposed but unanswered:** Should the cargo holder be removable between flights so it is fitted only for delivery missions? Recommend this direction for evaluation so normal following/filming need not carry unused delivery hardware, with fitting/removal only while landed and disarmed. This is a hardware-configuration preference, not a selected quick-release mechanism or established saving.

If adopted, the holder must remain securely attached during delivery and removal must not become a shortcut for taking cargo before recipient verification. The approved ordinary-removal protection, landed/motors-stopped verified handoff and disarmed physical collection remain; no force/theft-resistance guarantee is added. Necessary permanent mounts, landing clearance, wiring and retained camera/computer/sensors must still be counted in the relevant flight configuration. The holder and its integration remain inside the complete-build budget even when not installed for another mission. Exact reference-test equipment and any configuration change require explicit accounting, not silently stripped-down endurance claims.

The $600 goal, conditional $800 absolute maximum, twenty-useful-minute no-extra-cargo reference and mandatory recovery reserve remain unchanged. No complete budget fit, safe capacity, part selection, implementation, purchase, installation, capture, powered test or flight is established or authorized. Ticket 10 remains claimed; Q63–Q65 and the remaining technical feasibility/acceptance work are open.

### 2026-08-30 — Q65: Removable delivery equipment approved

The user answered **"Yes it should be removable delivery equipment"**. Adopt delivery equipment removable **between flights**, so it can be fitted for delivery missions and left off ordinary following/filming flights. Fitting/removal is while landed and disarmed, as proposed. This selects the configuration direction, not a particular quick-release mechanism or hardware package.

The holder must remain securely attached during delivery; removability must not bypass recipient verification or the approved protection against ordinary manual cargo removal. The landed/motors-stopped handoff and disarmed physical collection remain. No force/theft-resistance guarantee or new arming permission is added.

Necessary permanent mounts, wiring, landing clearance and retained camera/computer/safety equipment remain in the relevant mass and power accounts. The removable equipment and its integration still count toward the **$600 complete-build goal and conditional $800 absolute maximum**. The twenty-useful-minute no-extra-cargo reference and mandatory recovery reserve are unchanged; this answer neither proves endurance nor permits silently omitting required equipment.

Mechanism, carrying limit, compatibility and complete budget fit remain open. No implementation, purchase, installation, biometric capture, hardware operation or flight occurred; existing uncommitted work is preserved. Ticket 10 remains claimed.

**Resume the earlier unanswered Q63, not a new question number:** Once the PC biometric app is ready, would 100 fresh owner checks over five days—twenty per day, split into two sessions of ten—be manageable? Recommend that as an initial usability-evaluation schedule, with security testing separate. This is prospective planning, not permission to start capture or approval of the full acceptance protocol. Q64's nonowner-participant availability also remains unanswered.

### 2026-08-30 — Q64: Nonowner participation feasible; Q63 explanation requested

The user answers **Q64 yes**, indicating that arranging **three willing adults** for initial live nonowner rejection tests is feasible. This records prospective participant availability, not those individuals' consent, a completed recruitment/contact action, a scheduled session, guest enrollment or adequate population coverage. Do not request names or contact anyone. Obtain each participant's consent and agree the concrete data-handling plan before testing; no capture or test is authorized now.

For **Q63**, the user asks why the proposed owner evaluation has so many checks. **Q63 remains unanswered**; do not count the explanation request as approval of 100 trials or five days.

Explain a check as one normal full face-and-voice verification in the PC app, using the already enrolled owner profile, not another enrollment or a drone flight. The proposed 100 checks are a practical starting evaluation budget, not a scientific minimum. They support assessing the already requested first-attempt reliability across normal sessions: one failed check changes a 20-trial observed rate by five percentage points, versus one percentage point in 100. Spreading sessions over days samples ordinary variation rather than one favorable sitting; it does not establish independence or prove the true future success rate is at least 95%. Attack testing remains separate.

At the unvalidated ten-second successful-check target, twenty checks total approximately **3 minutes 20 seconds of verification time per day**, or **16 minutes 40 seconds across 100 checks**, before setup, recording results, failed attempts, cooldowns and retries. This arithmetic is not a completion-time promise or a measured workload. Retain the 100-check/five-day schedule as the recommendation pending the user's assessment of that burden; no reduced schedule is adopted here.

Q65's removable delivery-equipment decision and all other confirmed requirements are preserved. No implementation, purchase, capture or physical testing occurred. Ticket 10 stays claimed; records remain uncommitted.

### 2026-08-30 — Q63: Initial owner-evaluation schedule approved

After the test-count and workload explanation, the user answered **"ok we could do that"**. Approve the initial PC owner-usability evaluation schedule of **100 fresh full face-and-voice checks across five days: twenty per day, split into two sessions of ten**, once the app is ready. These use the enrolled owner profile; they are not 100 enrollments or aircraft flights. This is prospective evaluation planning, not a dated appointment or recurring automation.

The schedule samples normal-use sessions against the existing first-attempt reliability and successful-check timing targets. It does not prove a true future success probability of at least 95%, make repeated observations independent, approve the entire security/state-management test matrix, or select a new statistical-confidence criterion. Keep first-attempt outcomes and retries distinct; attack testing remains separate. The earlier workload arithmetic is conditional on the unvalidated ten-second target and excludes setup, failures, cooldowns and retries.

Q64's planned availability of three adult nonowner participants remains confirmed, with their individual consent and concrete test-data handling still required before testing. No capture, enrollment, installation, tests or flight begins from Q63's approval. Hardware/budget/cargo feasibility, remaining PC retry/timeout/recovery details, complete acceptance protocols and final shared-understanding approval remain open. Ticket 10 stays claimed; documentation remains uncommitted.

### 2026-08-30 — PC retry/timeout/recovery evidence; Q66–Q68 proposed

Primary-source decision support is preserved in [PC retry, timeout and recovery options](../../../docs/research/pc-retry-timeout-recovery-options.md). It distinguishes source principles from project-specific proposed numbers and retains the existing owner Windows/recovery, profile-preservation and one-action authorization rules. NIST's framework does not permit the project's voice-biometric arrangement; these references do not establish compliance or the gate's security. No tests, captures or implementation occurred.

**Next independent decision round, unanswered:**

- **Q66 — Retry waiting rule:** Recommend an initial **five consecutive rejected full verification requests**, then **thirty seconds before each further attempt** until a successful complete face-and-voice check resets the streak. Preserve enrollment and the pending control state across app restart; simply reopening must not clear the wait. This is not thirty seconds after each batch of five new free attempts, or permission for permanent disabling/forced re-enrollment. Pauses can also delay the genuine owner and lengthen rejection tests. Exact counting of device faults/cancellations, concurrent requests, timing integrity and separate recovery-code guessing controls require design and validation. The increasing-delay alternative in the report is not selected by this recommendation.
- **Q67 — Unfinished normal check:** Recommend expiring a normal face-and-voice verification request **sixty seconds after it starts** if unfinished, rejecting it, discarding partial successes and requiring a fresh full check while preserving enrollment. Continuing input does not extend this proposed deadline. The normal-success ten-second target remains; a slower success does not thereby meet that target. This does not set enrollment/recovery duration, the lifetime of a completed approval or an in-flight rule.
- **Q68 — Used recovery code:** Recommend that a **successfully completed lockout recovery replaces the used code with a new one**, which the owner saves offline. The old code must not remain usable after successful replacement. It must not be consumed merely because recovery was attempted: prepare/validate the replacement profile and obtain confirmation of saving the new code before finalizing the new enrollment/code state together. Interrupted pre-completion recovery must not leave the owner with both the old and replacement codes invalid. Exact durable storage/restart behavior remains engineering work, not a validated guarantee. The valid-code-plus-fresh-designated-owner-Windows prerequisite remains unchanged, and recovery grants no direct action/arming permission.

These are reviewable starting proposals, not approved parameters or proof of adequate attack resistance. Approval would still require testing against usability, security and interruption requirements before sign-off. M1 hardware/cost feasibility and the rest of the acceptance protocol remain open; ticket 10 stays claimed.

### 2026-08-30 — Q66–Q68 approved; planning and implementation workflow clarified

The user explicitly answered **Q66 yes, Q67 yes, Q68 yes**:

- **Q66:** After **five consecutive failed complete verification requests**, impose **thirty seconds before each further attempt** until a successful complete face-and-voice check resets the failure streak. Reopening the app must not clear the wait. Enrollment remains intact. This is the fixed-delay direction, not the report's escalating-delay alternative, permanent disabling or a new Windows-only bypass. Device/cancellation classification, concurrency, durable counter/timer handling and recovery-code guessing controls still need engineering and testing.
- **Q67:** An unfinished normal face-and-voice verification request expires **sixty seconds after starting**; reject it, discard partial successes and require a fresh complete check while retaining enrollment. The **ten-second normal-success target remains**. This does not set enrollment/recovery timing, completed-approval lifetime or an in-flight behavior.
- **Q68:** A successfully completed lockout recovery replaces the used recovery code with a **new code saved offline**. The old code becomes invalid only when recovery completes successfully with the replacement ready and saved, not on a failed or interrupted preliminary attempt. The existing code-plus-fresh-designated-owner-Windows prerequisite remains; recovery still grants no direct protected-action or arming approval. Durable replacement and interruption handling remain requirements to implement and validate, not guarantees already demonstrated.

The user also asks whether finishing the milestone work leads to specs, implementation tickets and then implementation, and whether software comes first. Clarify that **finishing the current planning decisions** is the prerequisite, not physically completing M1–M5 before writing specs. The agreed process is to resolve the remaining current planning/feasibility inputs and confirm shared understanding, then synthesize the **M1 spec**, agree its test boundaries and implementation-ticket breakdown, and implement/test the approved work. Later milestones receive their own detailed specifications and tickets when approached; the present roadmap does not require all future software to be designed or finished upfront.

Starting execution with **native-Windows PC biometric software and simulator practice** is consistent with the existing M1 direction. This is the recommended starting sequence being explained, not approval to start coding now or a new rule that every software feature must be complete before hardware work. Hardware selection/cost research can proceed alongside it; approved assembly, bench integration, commissioning and manual-flight validation follow their actual prerequisites. M1 still needs both hardened PC acceptance and the manual-flight/build/safety side. Phone/onboard/autonomous software remains in its approved later milestones and requires real-hardware integration evidence.

This workflow question is not final approval of an M1 spec, implementation tickets, purchases, installation, capture, hardware operation, commits or flight. Remaining hardware/budget/cargo feasibility and detailed acceptance inputs still prevent closing ticket 10 or handing off to `/to-spec`. The current decision records and report status notes are updated; documentation remains uncommitted.

### 2026-08-30 — Budget raised to $800–$900; remaining agenda authorized

The user states **"I think 800-900 is fine now btw lets continue and finish up all the agenda"**. Record an accepted **$800–$900 planning range with $900 as the complete-project maximum**. This supersedes the prior working $600 goal and conditional $800 ceiling; it is not a minimum spend, permission to exceed $900, a purchase, or an approved recurring fee. Continue seeking lower cost without silently removing requirements.

The scope of that budget is unchanged: the entire planned M1–M5 initial build, including aircraft, radio, charger, tools, initial spares, required capabilities and necessary integration/build costs. Future repairs/replacements remain separate. Keep the self-built seven-inch direction, twenty useful minutes plus separate reserve, future camera/computer, owner face-and-voice arming policy, offline phone requirements, guest scope and removable recipient-verified delivery with ordinary manual-removal protection. No cargo capacity, alternate battery/platform or part selection follows from this budget change.

The user authorizes continuing the remaining agenda: complete the evidence review, consolidate M1 acceptance inputs and prepare the final shared-understanding review. The existing conditional $807.92 comparison leaves **$92.08 below $900 before its missing costs**; this arithmetic does not establish a full fit. Resolve remaining decisions against concrete evidence rather than reopening approved preferences. Prepare the spec/ticket handoff when its prerequisites are satisfied; this general continuation is not approval of an unseen final design or a waiver of the grilling skill's final shared-understanding check. Ticket 10 stays claimed during the review. No purchase, capture, physical operation or commit occurs from this update.

### 2026-08-30 — Remaining agenda reviewed; Q69–Q70 proposed

Preserved the bounded reviews in the main checkout: [complete budget at $900](../../../docs/research/complete-budget-review-900-2026-08-30.md), [endurance and cargo](../../../docs/research/endurance-closure-review-2026-08-30.md) and [M1 acceptance contract](../../../docs/research/m1-acceptance-closure-review-2026-08-30.md). The [consolidated planning review](../../../docs/research/planning-agenda-review-2026-08-30.md) is the reviewable decision packet, with source provenance. None is an implementation specification, available shopping basket or passed acceptance result.

The cost review reconciles the prior **$807.92** conditional comparison and identifies every outstanding obligation without treating unknown costs as zero. Exact original motor/battery availability remains problematic. Component-only examples add $93.88, and the examined native iPhone signing route separately adds $99/year; these are unselected sensitivities, not minimum possible costs or justification for another automatic budget increase. Higher-energy two-pack alternatives total **$897.92/$885.92 before the same missing features and integration/delivered costs**. No complete qualified $900 fit is established; no claim that all redesigns are impossible follows. All requirements, including recipient verification and ordinary manual-removal protection, remain.

Actual PC/flight acceptance occurs after the relevant implementation and build. The agent can prepare a testable acceptance contract now, with hardware-dependent flight criteria set before physical evaluation and remaining software mechanisms designed in the reviewed spec. Do not require nonexistent software to pass its acceptance tests before specification, or relabel a future test plan as proven hardware feasibility.

**Remaining independent decision round — both unanswered:**

- **Q69 — Consolidated M1 acceptance contract:** Recommend the reviewed contract: at least **95 first-attempt successes out of the approved 100**, with **every successful baseline check within ten seconds**; enrollment measured separately against five minutes; required security/state coverage with meaningful controls and any unauthorized approval blocking sign-off; separate build/commissioning gates and the approved three consecutive full piloting runs across at least two sessions, using criteria fixed before evaluation. The observed result is not a population guarantee; ninety negative attempts are an exploratory starting allocation, not an automatic security pass. Retain all existing Q66–Q68 and owner/recovery/privacy policies. Engineering details belong in the reviewed specification without weakening these invariants. Q69 approves a planning contract only, not passed tests or capture. The supporting thirty-/ninety-day test-data retention suggestions remain draft for concrete session-plan review and individual consent, not numerical parameters bundled into this answer.
- **Q70 — Separate PC-software planning handoff:** Recommend explicitly allowing a **bounded native-Windows owner-only PC specification and implementation-ticket planning effort while ticket 10 stays claimed with aircraft/full-budget feasibility open**. This is an exception to the current combined whole-M1 handoff dependency, not silent closure, a new hardware budget, purchase authorization or removal of later capabilities. PC actions remain harmless and disconnected from aircraft motors. After approval, review the specification's test boundaries and end-to-end ticket breakdown before implementation. The tradeoff is that useful PC progress can precede an affordable full-aircraft design, but a future explicit budget/scope decision may still be necessary if no supported $900 build emerges. M1 still needs both PC and flight acceptance.

The `grilling` skill requires confirmation of shared understanding before acting on the design, and the current map couples the whole-M1 handoff to closing this issue. Those are the specific reasons for the final review request; the user's new budget and continuation authorization have already been acted on without asking again. No implementation, purchase, installation, participant contact, biometric capture, powered test, flight, commit or source-worktree change occurred. Existing unrelated changes are preserved; decision/research documents remain uncommitted.

### 2026-08-30 — Q69 and Q70 approved; separate PC specification work begins

The user explicitly answers **Q69 yes and Q70 yes**.

**Q69:** Adopt the consolidated M1 acceptance contract: at least **95 first-attempt authorizations out of the approved 100 trials**, with **every successful baseline check within ten seconds**; first normal enrollment measured separately against five minutes; required security/state coverage and working controls, with any unauthorized approval blocking sign-off; and separate build/commissioning checks before the approved three consecutive complete flight exercises across at least two sessions. Actual flight criteria are fixed before evaluation using the selected aircraft and suitable conditions. This approves the planning contract, not successful results, a population reliability guarantee, a ninety-attack pass quota or permission to collect biometrics. All prior owner/recovery/privacy and Q66–Q68 policies remain. The research's proposed thirty-/ninety-day test-data retention periods remain unapproved pending the concrete session plan and individual consent.

**Q70:** Authorize a **separate, bounded native-Windows owner-only PC specification and implementation-ticket planning effort** while this ticket retains unresolved aircraft and complete-budget feasibility. This explicitly removes ticket 10's closure as a prerequisite for that PC-only planning handoff; the original whole-M1/hardware handoff still depends on resolving its actual blockers. Keep the complete-project $900 ceiling, all later capabilities and recipient verification. PC actions are harmless and disconnected from aircraft motors. Completing the PC application alone does not complete M1 or establish an affordable full aircraft.

Shared understanding is confirmed for this scoped handoff. Proceed to concrete specification/test-boundary and ticket-breakdown review without re-asking Q69/Q70 or reopening settled product preferences. The `to-spec` and `to-tickets` workflows still require review of their new artifacts before publication as ready implementation work. New draft planning files may be written locally; the tracker requires explicit approval of their narrow Git-ignore exception before relying on Git to preserve them. No such exception, commit, purchase, installation, capture or implementation is inferred from these answers. Ticket 10 stays **claimed**; no resolved answer is added.

### 2026-08-30 — Planning closure requested; physical validation deferred explicitly

The user now instructs continuation with `grill-with-docs` to close this issue as far as legitimately possible **without requiring hardware that has not been built**. This supersedes older wording that conflates an unresolved test result with an unresolved planning decision. Previously approved Q1–Q70 decisions remain; the $800–$900 planning range/$900 complete-build maximum, twenty useful minutes plus reserve, secure recipient-verified removable cargo and M1–M5 sequence are not reopened automatically.

Classify each remaining obligation as **answerable now** or **requires physical validation**, splitting mixed items into a design/acceptance definition and a future test. Research and calculations may support a proposed hardware choice without proving performance. A prediction that misses a requirement or a BOM exceeding $900 is an answerable design/tradeoff problem, not something to hide in a physical-validation backlog. Prices, unavailable variants, integration parts, initial spares/tools and necessary development costs must remain visible. No private location questions are needed; applicable permissions remain a future operational gate with explicit cost uncertainty.

Closure is permissible after answerable planning items and shared understanding are settled, with every deferred validation identified by milestone, prerequisites, acceptance evidence and failure consequence. The intended progression is planning complete → locked requirements/specifications → reviewed implementation tickets → build → collect evidence → validate. The current effort remains detailed M1 planning plus the approved sketch-level later ladder, with required later capabilities, hardware assumptions and costs preserved. Detailed later feature design must have explicit future work/entry gates; it must not masquerade as either completed design or physical validation.

The subsequent PC specification, test approach, eight individual tickets, dependencies/sizes and narrow tracking exception are already approved. **UI B is selected for now.** The user explicitly clarified that those tickets are ready for a separate implementation agent, not to be started here. No production code or tests are written by this planning effort. Separate PC implementation work and its ticket-01 claim are visible in the shared checkout and must be preserved; that claim does not authorize continuing it in this task. This planning effort will not alter or implement those eight tickets.

Issue 10 remains **claimed** during the evidence/decision audit; this is not closure, purchase authorization, capture consent, powered testing, flight permission or approval of a new service/fee. Current work and source worktrees remain uncommitted and intact.

### 2026-08-30 — Closure audit, proposed engineering package and Q71–Q72

The [planning-closure audit](../../../docs/research/issue10-planning-closure-audit-2026-08-30.md) consolidates the current review. Supporting documents are the [complete proposed BOM and alternatives](../../../docs/research/issue10-bom-closure-options-2026-08-30.md), [endurance/payload model](../../../docs/research/issue10-endurance-payload-model-2026-08-30.md), [full two-class inventory and validation register](../../../docs/research/issue10-validation-register-2026-08-30.md), and [no-Mac phone build options](../../../docs/research/issue10-phone-build-options-2026-08-30.md). Read each report's final coordinated candidate and qualifications rather than preliminary figures exchanged during research.

The work now supplies explicit component proposals/allowances, numerical endurance and cargo estimates, reserve/workload/repetition proposals, and a concrete proposed M1 simulator/build/commissioning/manual-flight contract. These are engineering proposals and evidence, not new user approvals. The originally examined motor's unrestricted current demand triggered a paper-compatibility correction; the final report records the matched alternative instead of calling a known rating conflict a future-test result. Actual installed limits still require validation.

Every remaining group is split between **Answerable now** and **Requires physical validation**. The register provides 40 traceable acceptance/release obligations with prerequisites, evidence and blocked capabilities. It includes nonphysical software/consent/procurement/permission gates as well as physical tests; it is not 40 new tickets or 40 physical experiments. Actual endurance/reserve, safe cargo capacity, mounting/power/thermal behavior, aircraft readiness, device performance and real biometric/security outcomes are explicitly **pending physical validation**. Detailed M2–M5 questions already deferred by the user have named later-spec exit gates; they are not relabeled physical uncertainty or silently assumed solved.

**Closure assessment:** this issue cannot yet be resolved because an affordable selected complete BOM and several new acceptance/design choices remain. The completed cost estimate is substantially above the existing **$900 maximum**, even after the bounded cheaper comparisons. No increase is inferred and no old budget question is re-asked in this round. A cost/design conflict is an answerable planning problem; missing physical results are not. Further cost/design work remains necessary unless the user explicitly changes a constraint. No claim of global impossibility or permission to omit features follows.

**Next manageable decision round — unanswered:**

- **Q71 — Initial cargo design target:** Recommend designing the first delivery version around **250g of cargo (about half a pound)**, with a **separate 170g engineering allowance for the secure removable holder**. This makes the initial sizing target concrete while leaving the actual safe capacity pending controlled testing. It is not permission to carry that weight now, a guarantee of twenty-minute loaded flights, or a new 3lb reduction: 3lb was tentative and never approved. Recipient face verification, ordinary-removal protection, landed/motors-stopped handoff and carrying the disarmed aircraft back remain. A 500g load is retained as a comparison, not an approved stretch requirement. This sizing choice can guide a cheaper redesign without approving the over-budget reference BOM.
- **Q72 — Phone maintenance versus fees:** Recommend evaluating a **native iPhone app with personal signing refreshed through the Windows PC at least every seven days**, plus authorized private hosted-Mac builds within free quotas, before choosing a paid signing route. This preserves the no-Mac and locked/pocketed offline-use requirements but adds periodic internet/account access and maintenance; expiry prevents opening the app until refreshed, and automatic refresh is not guaranteed. Third-party tooling/device trust and source-only cloud build setup require a later concrete review; no credentials, biometric data or recovery secrets are to be sent into cloud builds. The documented paid alternative adds **$99 per membership year** and is not selected automatically. Ask whether the user accepts the weekly-maintenance direction as the planning basis, not whether they authorize installation/uploads/payment now. Actual app/entitlement/iPhone compatibility remains to test.

The next round after these answers will recompute the frontier. New M1 and endurance protocol details still need package review; the full hardware/cost selection and final shared-understanding check come before issue resolution. Do not revisit Q1–Q70, start PC tickets, perform capture/physical tests, purchase, stage or commit during this planning round.

### 2026-08-30 — Q71 and Q72 approved; acceptance-protocol review

The user answers **Q71 “yes I agree” and Q72 “yes that’s fine.”** These answers supersede the preceding unanswered status; they do not approve the complete research packet.

**Q71 — Initial cargo target approved:** design the first delivery version for **250g cargo**, including its packaging, separate from the holder. Carry the **170g holder allowance** in the engineering model; it is provisional, not a measured holder mass or certified maximum. Actual safe capacity remains **pending physical validation** through structural/retention, balance, current/thermal, control and loaded recovery checks (V33/V37). Recipient face verification, ordinary-manual-removal protection, secure removable mounting, landed/motors-stopped release and carrying the disarmed aircraft back remain. This does not approve 500g, a three-pound requirement, twenty-minute loaded missions, the proposed battery chemistry or the over-budget BOM.

**Q72 — Phone maintenance direction approved:** evaluate the native iPhone route with legitimate personal signing refreshed through the Windows PC at least every seven days and private hosted-Mac builds within free quotas. Periodic internet/account access, maintenance and app unavailability after signing expires are accepted tradeoffs; actual flight operation remains offline, including the required intentionally enabled locked/pocketed voice sessions. Automatic refresh is not guaranteed. Concrete installation, device/account trust, source upload and service setup remain for a later review; no such action or paid membership is authorized now. Cloud builds exclude credentials, pairing material, biometric data and recovery secrets; paid overages must be blocked. Actual build/entitlement compatibility and device operation remain M2 engineering/validation gates, not proof supplied by this answer. The $99/year alternative remains unselected.

**Next manageable round — Q73/Q74 proposed, unanswered:**

- **Q73 — Concrete M1 aircraft acceptance package:** review [register gates A–D](../../../docs/research/issue10-validation-register-2026-08-30.md#concrete-proposed-m1-aircraft-acceptance-definition). New details are three consecutive simulator rehearsals plus emergency/control understanding; documented bench checks and separate commissioning; then the basic manual exercise in commissioned Stabilize mode: 30-second hover nominally at 3m (2–4m height band, within 2m horizontally), 5m out-and-back with five-second stops within 2m of each endpoint, controlled landing within a 2m-radius target and disarming. Plan each exercise within three minutes. The proposed envelope is dry daylight, 15–25°C, mean wind ≤2m/s/gust ≤3m/s, a 10×10m box, separately assessed clear margin (proposed minimum 20m outside the box) and pilot separation (proposed minimum 15m from the nearest intended flight position). These are planning criteria, not certified safe distances or first-flight instructions; actual safety/site/component assessment may require tighter limits or disqualify the exercise. Preserve the **already approved** three consecutive real runs across at least two sessions. The linked package defines measurement evidence and reset/stop rules: skill misses reset the sequence, prudent weather stops are not passes or skill failures, faults ground the aircraft and configuration changes restart the sequence. Only the added package needs approval; the earlier run count is not reopened. No helper requirement is added.
- **Q74 — Fully equipped endurance acceptance package:** review the [reference mission contract](../../../docs/research/issue10-endurance-payload-model-2026-08-30.md#proposed-reserve-and-reference-mission-contract). New details: distribute **12 minutes following at walking pace (1–2m/s), six minutes hovering/stopped and two minutes gentle turns/transitions** across the existing twenty useful minutes, with camera/compute/video/navigation active and no extra delivery cargo. Initial proposed envelope: dry daylight, 15–30°C, mean wind ≤2m/s/gust ≤3m/s, within the already approved 100m radius and ≤10m height, subject to stricter actual limits. The engineering reserve starts at **1.5× modeled return/landing energy with a 20Wh floor**, using the documented 120-second recovery model; measured worst-case recovery and uncertainty must validate or increase it before reliance. Never reduce reserve to pass. Propose **three successful complete evaluations across at least two days**, logging every attempt and retaining the full validated reserve at the twenty-minute checkpoint. **Pack-count clarification:** this test plan does not select or require buying two packs. Identify every tested pack; each pack released for reference missions must have qualifying evidence, with at least three total successful evaluations. This supersedes the earlier report's assumption of “both identified flight packs.” Exact inventory remains part of the unresolved BOM. This is later fully equipped endurance validation (V26), not a new twenty-minute M1 piloting task or loaded-delivery promise.

Both packages define future acceptance; no simulator setup, powered testing or flight is started here. **Issue 10 stays claimed** for the affordable selected BOM/paper compatibility and these still-unanswered protocol details, followed by final shared-understanding review. Q71/Q72 are resolved planning decisions; physical measurements remain deferred rather than being re-asked. No PC implementation tickets, production code, purchases, installs, capture, staging or commits are part of this update.

### 2026-08-30 — Q73 and Q74 approved; acceptance definitions settled

The user explicitly answers **Q73 yes and Q74 yes**. The immediately preceding proposals are now the approved planning acceptance packages, subject to their stated configuration/site qualification and stricter safety limits. This supersedes their unanswered status, not historical evidence or test outcomes.

**Q73 — M1 aircraft acceptance:** adopt [register gates A–D](../../../docs/research/issue10-validation-register-2026-08-30.md#concrete-proposed-m1-aircraft-acceptance-definition), including three simulator rehearsals and control/emergency understanding, documented mechanical/electrical/sensor/radio/energy checks, separate commissioning, and the defined short manual hover/movement/landing exercise with its measurement tolerances, weather/spatial envelope and stop/reset bookkeeping. Keep the previously approved three consecutive qualifying real runs across at least two sessions. Actual aircraft/site readiness may impose tighter limits or make the exercise unsuitable; approval is not a first-flight procedure, universal safe-distance certification, a helper requirement or an achieved result. Build/commissioning/piloting evidence remains **pending physical validation** (V08–V11 as applicable); M1 also requires the independent approved PC acceptance.

**Q74 — Fully equipped reference endurance:** adopt the [reference mission contract](../../../docs/research/issue10-endurance-payload-model-2026-08-30.md#proposed-reserve-and-reference-mission-contract) with the prior comment's explicit pack-count correction. The twenty useful minutes comprise twelve minutes following at 1–2m/s, six minutes hovering/stopped and two minutes gentle turns/transitions, distributed across the mission with camera/compute/video/navigation active and no delivery cargo. Keep the stated dry/daylight/weather/height/100m reference envelope and the modeled recovery reserve of 1.5× recovery energy with a 20Wh floor. Actual worst-case recovery, usable battery energy and uncertainty must validate or increase protection before reliance; reserve must not be cut to pass. Require at least three successful complete evaluations across at least two days and qualifying evidence for each pack released for those missions, with every attempt logged and the full validated reserve remaining at the twenty-minute checkpoint. This does not select two packs, approve battery chemistry/BOM, promise loaded endurance or add fully equipped twenty-minute flights to the M1 basic exercise. Actual performance remains **pending physical validation** (V19/V26, with loaded delivery separately V33/V37).

The protocol choices are now resolved **Answerable now** items (P04/P06). Q71/Q72 remain settled. The present substantive planning blockers are **P01 complete-project affordability and P02 final hardware selection/paper compatibility**, followed by P13 final packet/shared-understanding confirmation. No further physical measurement is demanded to finish planning. A focused research pass may improve the hardware/cost proposal; it cannot silently raise $900, omit capabilities or classify a documented electrical conflict as a future flight test. Issue 10 remains **claimed**, and the eight PC implementation tickets remain outside this task.

### 2026-08-30 — Post-Q74 affordability and paper-qualification findings

Completed a bounded [affordability follow-up](../../../docs/research/issue10-affordability-after-q74-2026-08-30.md) and [hardware paper review](../../../docs/research/issue10-hardware-paper-qualification-after-q74-2026-08-30.md). They preserve all Q1–Q74 decisions. No revised budget, reduced capability, selected purchase basket, new implementation ticket or physical test is inferred.

**P01 — Answerable now, still unresolved:** the one-pack/MicoAir AIO/Plusivo-tool comparison retaining D500/TFmini-S sensing totals **$1,034.65 in named parts** and **$1,679.28 including explicit integration, shipping, illustrative tax, initial rework and conditional compliance allowances**. That is **$779.28 above the existing $900 complete-project ceiling**. The new tool offer is a manufacturer-advertised price, not a verified delivered checkout. A D200/TF-Luna alternative reaches **$1,624.28**, but its range/scan-rate/mass changes are not established as capability-equivalent. No global minimum or impossibility claim follows. Splitting the same ledger gives **$1,087.71 M1/reusable allocation + $591.57 later additions**; this is accounting, not approval to reinterpret $900 as an M1 budget or omit later costs. The parent independently reproduced all 36 named rows and scenario totals.

**P02 — Answerable now, concrete paper conflict identified:** the proposed factory pack uses an AMASS XT60H-F. Its current manufacturer rating is **35A under stated 12AWG/≤85K temperature-rise conditions**, not a safe installed temperature target or an unconditional burst rating. The four matched motor-table maxima sum to **113.88A before auxiliaries**. This is a simultaneous-demand screen, not actual mission demand or proof of immediate connector failure; it does mean unrestricted peaks are not qualified by the available documents. A delayed software current limiter or a connector adapter does not prove adequate protection. The public sources did not establish a qualified complete-pack pulse envelope or an exact factory replacement meeting it. A supplier-supported restricted operating envelope with adequate control/recovery authority, or a differently rated factory assembly, must be documented and re-costed before procurement. The paper report contains a concrete **unsent manufacturer evidence request**; no contact is authorized or made.

**Paper facts resolved now:** both controller/ESC candidates have plausible documented voltage/channel-current headroom and sufficient allocated serial ports. The exact MicoAir AIO page specifies current factor **14.14**, while its inspected shared upstream target defaults to **40.2**; board-specific configuration and later calibration must prevent that mismatch. Matek BEC12S-PRO is **5A continuous/9A peak**, with 5.2V default output. Keep two regulators in this comparison; define peak-load, device-voltage, ground/back-feed and total-energy measurement topology rather than assuming headline ratings prove it. An annotated installed layout remains a pre-build design deliverable; manufacturer frame CAD exists. Neither layout nor wiring can be finalized by pretending the unresolved power-path choice is fixed.

**Physical evidence remains explicitly deferred:** as-built mass/balance/clearance, workmanship, calibrated energy, thermal/sag/transient behavior, actual Q73/Q74 performance, phone/biometric/vision/link performance and loaded 250g holder/control/security results stay in the validation register. The old 27.5-minute central prediction belongs to its specified 1,851.6g reference; cheaper AIO/mount/sensor changes need a synchronized model update before selection. No test result or safe cargo rating is claimed.

**Closure assessment after both approvals and follow-up:** acceptance planning is settled, but issue 10 **cannot honestly close as planning complete yet**. An affordable, electrically coherent hardware choice is still missing. These remaining blockers require design/cost/supplier evidence, **not an assembled aircraft**. Preserve the current ceiling and features; do not repeatedly re-ask their approval or solicit acceptance of an unqualified over-budget basket. Final shared-understanding review follows a supported hardware/cost response. This planning task did not implement or alter the eight PC tickets, capture data, contact suppliers, purchase, stage or commit.

New report snapshots (uncommitted; base `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac` does not contain them): affordability SHA-256 `DC367BE6C1A32C05A7B4E0121196E15037006E08B3616BF6EB773B2ED282AA3E`; paper qualification SHA-256 `2689F7AA17EB4FCE1E08176AE93DD3146A9A3D0E997C7B24C39F0A36CED20DAC`.

### 2026-08-31 — Cheapest defensible hardware search and power-path redesign

The user requested: **"Find the cheapest technically defensible hardware configuration that preserves the approved requirements, while simultaneously correcting the power-path problem."** This authorizes continued research, calculations and a concrete engineering proposal, not purchases, supplier contact, a budget increase or removal of requested features. Q1–Q74 remain settled. No new interview question or approval is inferred.

The [final comparison and recommendation](../../../docs/research/least-cost-hardware-selection-2026-08-31.md) coordinates the [complete BOM](../../../docs/research/least-cost-bom-2026-08-31.md), [factory power-path correction](../../../docs/research/least-cost-power-path-2026-08-31.md), [coupled propulsion/battery model](../../../docs/research/least-cost-propulsion-2026-08-31.md), [installed layout](../../../docs/research/least-cost-integration-2026-08-31.md) and [lighter pan/tilt supplement](../../../docs/research/least-cost-pan-tilt-supplement-2026-08-31.md). These are dated uncommitted proposals, not a selected shopping list or achieved aircraft performance.

**Proposed hardware:** Source One V6 seven-inch DC, MicoAir743v2-AIO45A, four XING-E2809 **800KV** motors with APC7×4E/EP props, one factory Nexus6S2P P50B10Ah pack with **QS8 female/8AWG**, matching rated aircraft wiring and upstream INA-BM. Retain independent ELRS radio, GNSS/compass, Pi4/2GB, Camera3 NoIR, both sensing devices, pan/tilt, night lighting and secure recipient-verified removable delivery. Correct the supplies with separate compute/peripheral rails and a dedicated3.3V IR regulator. One complete spare prop set and a32GB compute card replace earlier research quantities, not user requirements. The lighter70g compute assembly and40g pan/tilt assembly save77g while retaining cooling, protection and movement, the50g integration contingency and30g configured-pack uncertainty allowance. Their fabrication/adapter costs remain explicit.

**P01 — complete affordability remains unresolved:** **$1,196.64 named purchases +$276.21 completion +$75 shipping +$154.79 illustrative tax +$100 initial rework +$60 conditional compliance = $1,862.64**, **$962.64 above the unchanged$900 maximum**. The split is$1,300.21 M1/reusable and$562.43 later additions; this does not authorize treating$900 as an M1 budget. No complete compliant$900 design was found, and no global minimum or impossibility is proved. An unverified cheaper exact motor offer remains outside the primary total. Earlier$1,679.28 pricing cannot be attached to the new factory path.

**P02 — known current-path conflict corrected in a specific conditional design:** the original35A XT60 path is gone. The revised motor model gives60.986A centrally at full command/full charge,81.923A in its unfavorable parameter corner, and **85.923A including all4A auxiliaries**. Retaining the original1.25 engineering sizing factor requires107.404A; the conservative110A QS8,120A factory pack and150A shunt pass that numerical screen. All branch inputs are downstream of the monitor. No delayed current limiter, high-C headline, pack modification or aircraft XT60 adapter is used as the fix. Actual current/thermal behavior and workmanship are still physical gates. Final fabrication, rail-fault/protection, monitor-loss and configuration-specific energy/temperature details belong in the aircraft specification before assembly or activation.

**Endurance correction and final proposal:** the first heavier7×4 draft failed when extra voltage sag at maneuver current was coupled to the same state used for available energy. A7×5 comparison improved thrust but failed the retained current-margin screen. The final lighter **1,897.251g** configuration keeps7×4 and the original margins. The approximate primary-cell discharge integration gives **148Wh** to the selected19.6V reference-curve state, with a separate coupled maneuver calculation of approximately18.454V actual bus and **1.375 modeled thrust/weight** under its weak-control assumptions. The central354.540W model gives **20.98 useful minutes plus reserve**; the moderate401.961W/146Wh case gives **18.20 minutes and fails**. These are a conditional design hypothesis and sensitivity, not confidence bounds or a physical pass. The reference-curve voltage is not an instruction to set a raw battery failsafe value. Q74's full workload, reserve floor/recovery multiplier, evidence and repetition rules remain unchanged.

**Cargo remains250g including packaging**, with a separate170g provisional holder and **2,317.251g** loaded mass. Its earlier loaded battery endpoint and reserve give approximately **7.40 useful minutes** in the current model; no20-minute loaded requirement existed. Actual allowable mass/dimensions, control, holder retention and recipient-verification release remain pending physical validation, with landed/motors-stopped handoff and carrying the disarmed aircraft back preserved. No safe payload rating or delivery range is declared.

**Deferred evidence remains traceable:** [V09–V11/V19/V26](../../../docs/research/issue10-validation-register-2026-08-30.md) cover as-built mass/balance/clearance, electrical/thermal/energy, commissioning, Q73 and Q74; the corresponding V12–V37 gates cover onboard authorization, actual phone/link/video/sensing/night and cargo/security behavior. V39/V40 require updated cost/mass/power and affected revalidation when the configuration changes. Low-current meter checks and sampled logs do not prove fast transients; the power report states baseline instrumentation limits and separately priced diagnostic escalation if faults require it. None of these physical results must already exist to review planning.

**Closure assessment:** issue10 stays **claimed** because the affordable complete basket and final user hardware selection/shared understanding remain missing. The technical proposal advances substantially beyond the earlier known-incompatible path, but neither being able to build it nor its central prediction resolves the$900 constraint. Do not reopen Q71–Q74, reduce reserve or call a moderate-loss miss a pass. No PC code/tickets, accounts, captures, supplier communications, carts, purchases, powered hardware, staging or commits were performed by this planning task. Concurrent PC work is separate and preserved.

Verification: the parent independently reproduced all41 named purchase rows, full cost, mass, central power, upper-current corner, coupled endpoint voltage/thrust and reserve-duration arithmetic; checked manufacturer CAD geometry and the selected firmware's INA/servo support; and found no missing targets in232 local planning-document links. Detailed reports retain their primary-source provenance and assumptions. The base commit remains `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`; it does not contain these new reports.

Final uncommitted report snapshots, SHA-256:

| Report | Hash |
|---|---|
| Hardware selection | `9118CC748A72E9740D6F38631ACD064281D98265BA641A7034DF643503CD4676` |
| Complete BOM | `F31FFA6C3EE4D48AFC7FC7714D0419BCFE646C241077A610832FCBAF50DC3E2E` |
| Installed layout/interfaces | `D54DE67594BBE18E32FE49EB35EDF99AA2FEDB12F9F84C3AEF39EDB47026C122` |
| Pan/tilt supplement | `3EC437E33053BFB1B20F0B7608A48B53CF3399D11326AD66B05D5C0AD44A3A4C` |
| Power path | `BAFCADB71A50CE52ECE1902A92DE5594CF32A6EF8E539DC3BC4B01CE70EAC84B` |
| Propulsion/coupled battery model | `91CA95194E47A8A9BCE283B2FF93AB0BB6F55FBA8ACE333304A9F57F8DC5CA0A` |

### 2026-09-03 — Confirmed budget removal and final compatibility-audit mandate

The user explicitly removes the **$800–$900 complete-project budget ceiling** and sets **no fixed maximum for drone hardware**. Optimize for the lowest possible fully itemized total while preserving every previously approved drone feature, capability, safety requirement, performance requirement and validation requirement. A lower price does not authorize a downgrade, omission, deferral or weaker requirement. Cost remains an optimization metric and purchase remains unauthorized.

Re-evaluate the approximately$1,862.64 August31 candidate and documented alternatives. The final recommendation must represent **one complete physically buildable drone**, with mechanical fit, dimensions, mass/CG, rotor clearance, propulsion voltage/current, connectors/wire, distribution/regulators, FC I/O, UART/I2C/PWM allocation, sensor addresses, Pi/camera, radio/telemetry, pan/tilt, lighting, cargo/recipient-verification hardware, firmware and every adapter/cable/mount/fastener/harness/breakout/fabricated part accounted. Nominal voltage, connector family, protocol or apparent dimensional similarity alone is not compatibility evidence.

The final matrix uses only **VERIFIED**, **REQUIRES PHYSICAL VALIDATION** and **INCOMPATIBLE**. VERIFIED requires manufacturer/authoritative documentation or a transparent engineering calculation from documented specifications. Insufficient evidence is not promoted to VERIFIED. Demonstrably incompatible combinations are rejected rather than carried into the final BOM. Real-world workmanship, measured mass/CG, thermal/current/endurance and feature behavior remain future physical validations after the paper design is coherent. Do not purchase or implement during this audit.

### 2026-09-03 — Final hardware optimization complete; Q75 proposed

The [final hardware decision packet](../../../docs/research/final-hardware-optimization-2026-09-03.md) coordinates the [exact cost ledger](../../../docs/research/final-cost-optimization-2026-09-03.md), [propulsion search](../../../docs/research/final-propulsion-optimization-2026-09-03.md) and [interface audit](../../../docs/research/final-compatibility-audit-2026-09-03.md). It preserves Q1–Q74, including recipient face verification, owner face-and-voice arming, independent ELRS emergency control, the seven-inch self-build, every sensing/lighting/phone/guest/delivery feature, 250g cargo plus the separate 170g holder target, Q73 and Q74. No PC ticket was implemented.

**Lowest-cost complete conditional baseline:** Source One V6; MicoAir743v2-AIO45A; four XING-E2809 800KV motors; APC 7×4 E/EP props; one factory Nexus 6S2P P50B pack with QS8 female/8AWG/7-pin JST-XH; upstream INA-BM; guarded C110 positive/negative bus bars; short 10AWG AIO feed; separated compute/peripheral/IR rails; Pocket/RP1 ELRS; M10/IST8310; Pi4/Camera3; D500/TFmini-S; two-axis camera; IR/RGBW lighting; and mechanically latched removable recipient-verified holder. Every named cable, adapter, driver, level shifter, state switch, fuse, mounting/fabrication category and required ground tool is included. Known-incompatible FCHUB, direct Camera3/IR-board mounting, cut USB-C power and flight-path XT60 alternatives are rejected.

**Cost:** **$1,375.84 named purchases + $270.00 fabrication/support = $1,645.84** before delivery/tax/risk provisions. The complete scenario is **$2,052.93**, comprising a $75.00 delivery scenario, $172.09 illustrative tax, $100.00 first-build rework and $60.00 conditional compliance provision. No fixed maximum applies; these remain dated estimates rather than authorization or quotes.

**Mass/power/endurance:** the provisional fully equipped no-cargo mass remains **1,897.251g**, with all exact additions assigned within the existing structural/harness and 50g contingency categories pending as-built weighing. The central model gives 354.54W, 148Wh endpoint-usable energy, 20Wh reserve and **20.98 useful minutes**. The moderate-loss sensitivity gives **18.20 minutes**, so endurance is a material redesign risk and never a paper-certified pass. The 250g-cargo plus 170g-holder case is **2,317.251g** and predicts about **7.40 useful minutes**; no twenty-minute loaded requirement exists. The full-current rating screen is 107.404A; the factory 120A pack, lower cited 110A QS8 rating, 150A INA, calculated copper/wire path and four 45A ESC channels satisfy the paper screen.

All answerable current work is resolved: budget policy, BOM, cost, power topology, major dimensions/envelopes, FC I/O map, nominal sensor addresses, mass/CG target, endurance/payload estimates and acceptance definitions. The packet lists received-part, fabrication, electrical/thermal, mass/CG, Q73, Q74, loaded-cargo, phone/sensor/night/autonomy and biometric/security evidence as **pending physical validation**. Failure disables the affected capability and triggers redesign/retest; it never reduces reserve, equipment or authentication.

**Q75 — Final shared understanding, recommended yes:** accept the exact 6S2P/XING/APC configuration as issue 10's conditional planning baseline, keep the Q74 twenty-minute requirement mandatory, and accept the explicit possibility that the moderate-loss result forces a post-build propulsion/energy redesign. A yes closes issue 10 only as **planning complete, with specified physical validations deferred to implementation/testing**. It does not authorize purchase, construction, firmware loading, flight, capture, paid services or implementation of the eight PC tickets. A no leaves the seven-inch propulsion/energy architecture open; the current bounded search found no stronger documented orderable substitute.

Issue 10 remains **claimed** pending Q75. This is the `grill-with-docs` shared-understanding check, not a repeat of Q1–Q74.

### 2026-09-03 — Buildability gate supplied before Q75

At the user's request, the [final buildability gate](../../../docs/research/final-buildability-gate-2026-09-03.md) expands every `REQUIRES PHYSICAL VALIDATION` row and inventories every custom-fabricated assembly without reopening requirements or optimizing the BOM again.

The selected component architecture contains **no presently known fundamental incompatibility**. Fabrication release is still pending the dimensioned custom drawings, complete harness/netlist and firmware/safety manifests. Four physical-validation groups could force an affected hardware redesign if they fail: propulsion/endurance/control; pack/CG/rotor packaging; undocumented high-current pad or regulator/load behavior; and compute/RF integration. Q74 endurance is the largest known risk. Q75 remains unanswered and issue 10 remains claimed.

### 2026-09-03 — Q75 approved; planning closed and artifact stage authorized

The user explicitly approves the exact configuration as the conditional planning baseline and directs closing this issue as **planning complete**. Q74's twenty-minute useful-endurance requirement is mandatory and is not waived. This approval does not mean that fabrication drawings are complete, the aircraft is ready to purchase or fabricate, physical compatibility is proven, endurance is proven, or physical qualification is complete.

The hardware architecture is frozen. New evidence of a genuine incompatibility or failure of an approved requirement permits the minimum necessary redesign of only the affected subsystem, preserving the remaining approved requirements and minimizing cost. The user authorizes completing the implementation-ready hardware artifacts named by the buildability gate: dimensioned fabrication drawings, final harness/netlist and pin allocations, firmware/configuration manifest and safety/state truth tables. Procurement requires separate explicit authorization. The eight PC tickets remain outside this hardware task.

## Answer

**Planning complete — Q75 approved.** The accepted baseline is the [September3 exact configuration](../../../docs/research/final-hardware-optimization-2026-09-03.md), with the [cost ledger](../../../docs/research/final-cost-optimization-2026-09-03.md) of $1,375.84 named purchases / $2,052.93 illustrative complete scenario and the [buildability gate](../../../docs/research/final-buildability-gate-2026-09-03.md). These are dated planning amounts, not purchase authorization or guaranteed delivered totals.

Q1–Q74, the M1–M5 sequence, seven-inch architecture, owner biometric arming and independent emergency control, phone/sensing/lighting/guest scope, recipient verification and 250g cargo plus separate holder target remain in force. Q74's full workload, reserve and repetition contract is mandatory despite the 20.98-minute central / 18.20-minute moderate prediction. Actual acceptance remains in [V01–V40](../../../docs/research/issue10-validation-register-2026-08-30.md), including Q73, Q74, loaded payload, power/thermal/clearance, biometric and recipient-release evidence. Failure requires affected-subsystem correction and revalidation, never a silent requirement reduction.

The next stage is [issue 11: hardware build package](11-hardware-build-package.md). Issue 10 closure does not close its design-release or empirical gates, implement PC tickets, authorize purchases, or approve powered operation.


### Post-closure engineering note — 2026-09-03

Issue11 found a genuine selected-interface error: the QS8-S item is a two-pack series adapter. The user's Q75 affected-subsystem authorization permits the [R1.1 correction](../../../docs/hardware/baseline-r1/README.md) to a single bareQS8 male and existing8AWG stock, without reopening the remaining hardware architecture. The new harness/pin/firmware/safety artifacts and19 drawing studies expose unfinished mechanical release details and mass/cost overruns. Those remain issue11 engineering, not a reversal of Q75, an endurance waiver, or a claim that physical testing has passed. No purchase or PC implementation occurred.

### 2026-09-09 Phone and onboard direction; PC product retired

The owner explicitly removes the standalone PC biometric app from the finished B.G.D product. Preserve existing code, tests and evidence as development/reference material; no code deletion, installed-service removal or biometric/profile deletion is requested. This later decision supersedes the earlier September 9 direction to finish the Windows product and its acceptance campaign. Unfinished PC-product tickets leave the active delivery plan; they are not deemed accepted or successfully validated. The PC remains available for engineering, configuration, simulation and testing.

Confirmed design direction: use the phone and radio controller; spoken commands enter through phone/earbuds, without speaker-identity verification. After a deliberate launch request through the phone/controller, the desired interaction is automatic takeoff/approach, onboard owner face and liveness verification at a validated separation, then command access. The owner accepts return to a designated landing point on verification failure with independent manual takeover retained, and asks for the easiest practical way to locate the person. A fixed verification area/position is the current proposal, not a proven operating procedure.

This intentionally revises the old requirement for both owner biometrics before every arming request. Pairing, initial owner enrollment, launch authorization, command-session security, verification geometry and approach/failure behavior still need design and validation. Existing flight-controller contracts must be reconciled before implementation; their historical all-path biometric gate is not silently declared implemented or applicable unchanged. The existing hardware pause for a possible printed redesign remains. Platform, payload, endurance/reserve and other requirements are unchanged except where explicitly amended above. No purchasing, paid-tool installation, fabrication or physical flight is authorized here.

### 2026-09-09 Delivery sequencing and pre-purchase assessment

The owner agrees to source-backed feasibility calculations, CAD/structural checks, software/flight simulation and staged evidence before buying the complete aircraft, then requests repo alignment before continuing. The [phone/onboard entry point](../../../docs/phone-drone/README.md) records confirmed product choices separately from the proposed schedule. Issue12 owns a small interface and simulated first slice; Issue11 retains hardware feasibility/engineering. Neither a completed Windows product nor a completed phone app is a prerequisite for aircraft feasibility work. Physical qualification and procurement authorization remain separate; no printed manufacturing choice is implied.

### 2026-09-10 PC retirement clarified as dormant, not a reference workstream

The owner confirms that the standalone PC biometric application is no longer needed and must not cause further roadmap drift. Its source, tests, packaging, tickets and reports may remain as dated history, but they are not active reference tooling, a completion dependency, a cleanup task or evidence that advances the aircraft. Do not refresh PC test counts, finish its unresolved tickets or include PC work in goal-completion lists. Current delivery work proceeds through Issue11 hardware engineering and Issue12 phone/onboard interaction. Any future PC-product reactivation requires a new explicit owner direction; this clarification does not itself delete installed software, profiles or repository files.

### 2026-09-10 — Owner changes Q74 to fifteen useful minutes

The owner explicitly replaces Q74's minimum of 20 useful flight minutes with **15 useful flight minutes**, preserving the separate independent return-and-landing reserve. This later owner decision supersedes every earlier twenty-minute requirement; it is not an agent waiver based on a failed model. Keep the same fully equipped, no-extra-cargo reference configuration, operating envelope, active equipment, repeated-evaluation evidence and reserve methodology. The loaded cargo mission retains its own validated operating envelope and is not automatically required to fly for fifteen useful minutes.

To make the representative workload total fifteen minutes while retaining its approved 60%/30%/10% proportions, the engineering implementation is **9 minutes following at 1–2 m/s, 4.5 minutes hover/stops and 1.5 minutes gentle transitions**, distributed across the segment. This arithmetic adjustment changes duration only; it is not a new easier mission or equipment reduction. Keep dry daylight, 15–30°C, mean wind ≤2 m/s, gust ≤3 m/s, distance ≤100 m and height ≤10 m, subject to stricter qualified site/component limits.

The reserve remains `max(20 Wh, 1.5 × recovery energy)` with the initial 120-second recovery model and independent validation; observed demand/uncertainty may increase protection. It is never part of useful flight time. Retain at least three successful complete evaluations over at least two days, qualifying evidence for each released pack and a record of every attempt. Early recovery or insufficient reserve at fifteen minutes fails the endurance test; safety still takes priority. No two-pack purchase, procurement, fabrication, powered operation or qualification is authorized by this amendment.

Issue11 recalculates current mass/propulsion/energy and affected traceability against fifteen minutes. Issue12's authority/preview simulator behavior is unchanged. Current results are integrated in the [pre-purchase decision report](../../../docs/prepurchase-decision-2026-09-10.md); historical numerical benchmarks remain preserved as original-input evidence.


### 2026-09-10 — Later owner decision replaces fifteen with eleven useful minutes

The owner explicitly replaces the previous 15-minute Q74 minimum (itself superseding twenty) with **at least 11 useful flight minutes**. This is the acceptance minimum, not a model-based waiver. Keep the fully equipped no-extra-cargo reference, separate independent return-and-landing reserve and mandatory physical validation. The loaded cargo mission retains its separate validated operating envelope and has no automatic eleven-minute duration requirement.

Preserve the representative workload's 60%/30%/10% proportions: **6.6 minutes following at 1–2 m/s, 3.3 minutes hover/stops and 1.1 minutes gentle transitions**, distributed through the eleven-minute segment. Preserve dry daylight, 15–30°C, mean wind ≤2 m/s, gust ≤3 m/s, distance ≤100 m and height ≤10 m, subject to stricter qualified limits. Reserve remains `max(20 Wh, 1.5 × recovery energy)`, with the initial 120-second recovery model and independent validation; it is never useful time. Keep the 4 Wh pre-reference allowance in paper calculations, three successful evaluations over at least two days, qualifying evidence per released pack and every attempt logged. Early safe recovery remains a failed endurance attempt; safety takes priority.

The owner also requires reasonable paper-design margin. The engineering implementation adopts a **provisional 12.1-useful-minute target under moderate modeled losses**, 10% above eleven and still separate from reserve. This is not a new acceptance minimum or a statistical uncertainty guarantee. Retain sensitivity tests and increase margin where evidence warrants it. The unchanged planning model's 11.15 minutes barely clears eleven but misses this target; [Issue11](11-hardware-build-package.md) records the current calculation and supported mass-reduction work. No component, purchase, fabrication, operation or flight is approved by changing the threshold.

### 2026-09-10 — Available printers and final physical performance report

The owner identifies access to **Creality Ender 3, Voron 0, Voron 2.4, Creality Ender 5 Plus, Creality CR-10 S5, Creality Ender 3 S1, UltiMaker S5, UltiMaker S3, Bambu Lab X1 Carbon and Bambu Lab A1**. Access does not imply ownership, modifications, calibration, accessories or free consumables/machine time. Issue11 reassesses the existing secondary printed-part recommendation, candidate materials and appropriate machines against standard capabilities. No structural flight part is released without strength and process validation; no printer purchase or physical fabrication is authorized here.

The owner's third item, clarified as “what it is once everything is finalized,” requires the final aircraft's maximum physical speed and altitude capability to be reported once its configuration is stable. No numerical maximum is chosen now. Issue11 owns that report and its evidence, distinguishing estimates from demonstrated limits, reference conditions from physical capability, and physical capability from legal/site operating limits. Document mass/cargo, pack state, environment, uncertainty and the speed/altitude reference frames. This does not expand Q74's reference envelope or authorize physical limit-seeking tests.

### 2026-09-10 — Product reset and autonomous engineering direction

The owner reviewed the project step by step and authorized reconciling the audit findings. The current checkpoint records the settled product: ten useful minutes excluding takeoff/landing, battery-triggered suitable-site recovery, no cargo, phone natural-language missions, trusted face/liveness enrollment, live digital-zoom video, darkness/warehouse goals, initial 100 m from the user, task-dependent speed and backpack preference. Watch/orbit/patrol are optional. These later choices supersede conflicting earlier requirements and Q75's implementation freeze.

The owner delegates engineering methods and routine selections with no fixed spending ceiling but lowest credible complete-project cost. Free access to the listed printers, scanning, electronics tools and fabrication/wood/media labs expands design options; no machine guidance is available, resin printing is inactive, and access is not qualification or a materials budget. Structural printing is open to evidence-based comparison. Preserve prior CAD, models and test results as configuration-specific evidence; do not relabel the old 10.17-minute prediction as acceptance for the revised aircraft.

This reconciliation authorizes repository requirement/instruction/model-applicability updates. It does not itself launch a new sustained hardware execution run, select a final aircraft, authorize purchases or establish physical performance. Independent digital work and proportional analysis should not stop merely because one result requires a physical test.

#### Available lab resources supplied by the owner

Free access; no guidance/training supplied. Names are owner-reported, not verified specifications or proof of materials/tooling availability.

| Category | Reported resources |
| --- | --- |
| FDM printers | Creality Ender 3, Ender 5 Plus, CR-10 S5, Ender 3 S1; Voron 0 and 2.4; UltiMaker S5 and S3; Bambu Lab X1 Carbon and A1. |
| Scanning | EinScan turntable and handheld scanners. |
| Electronics | Soldering irons, hot air gun, hot plate, microscope, multimeters, oscilloscope; UNO-compatible kits (reported as Arduino Leils), Adafruit Feather M0 Bluetooth boards, Raspberry Pi 3 and Zero W. Exact variants/availability need checking before selection. |
| Fabrication | Small/large Boss laser cutters; LMS 6550 vertical mill; LittleMachineShop HiTorque 8.5x20 Deluxe bench lathe; PCB mill; horizontal band saw; Genmitsu CNC for metals; bench grinder; AVID CNC Pro 4896; injection molding machine; vacuum former. Resin printing inactive. |
| Wood shop | Wen 8-inch drill press; scroll, miter and track saws; belt sander; Laguna 14-inch band saw; DeWalt cordless oscillating saw and sanders; handheld tools. |
| Textiles/software | Brother embroidery machine, sewing machine and lock serger; Inkscape/Inkstitch; UltiMaker Cura. |
| Media | Studio lights, overhead/roving box lights and panel lights; VR headset; podcast booth with RODECaster Pro II and four-person PodMic station. |

### 2026-09-10 — Approved engineering-freedom instruction audit

The owner approved the instruction audit with a concise authority rule and a clarification that accepted engineering recommendations do not automatically become fixed product requirements. The agent owns architecture, engineering methods, development order and routine selections; delegated details remain revisable when they preserve agreed requirements and deliberately required user experience. Recover decision provenance when uncertain. Only the owner may approve requirement changes; difficulty or faster completion does not justify reducing scope, and unmet requirements remain unfinished. Complete-project cost and novice effort govern routine tradeoffs as described in CLAUDE.md. This audit changes no product capability and does not authorize sustained product implementation, purchases or physical operation.
