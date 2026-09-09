# Ticket 07 — Regulatory checklist for a self-built ~5-inch quad

> **Consolidation note — 2026-08-30**
> Historical checklist, not a jurisdiction-specific determination. Authorization-dependent aspirations remain milestones with permission and safety prerequisites; categorical exclusions are not the current roadmap.
> Source: `research/regulations`, commit `58259b4292181cadeba0850b84272d5d58813dde`, file `docs/research/regulations.md`.
> Original report text is retained below, with line endings normalized; this consolidation did not revalidate its external claims. Current decisions: [Lock the milestone ladder](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md).

Country-agnostic. Answer each question against your own jurisdiction's regulator before flying.
The FAA (US), EASA (EU), and Transport Canada (Canada) rules cited below are **illustrations of how
answers differ**, not advice for any specific country. All citations are primary sources (statute,
regulation text, or regulator pages). Verified 2026-08-06.

---

## 1. The checklist — questions every hobbyist must answer

### A. Weight class
- What does the drone weigh **at takeoff, including battery and any payload**? The near-universal
  break point is **~250 g**; the next common one is ~25 kg.
- Illustrations:
  - US: aircraft flown recreationally under 49 USC 44809 that weigh **0.55 lb (250 g) or less at
    takeoff** are exempt from registration (14 CFR 48.15) — https://www.law.cornell.edu/cfr/text/14/48.15
  - EU: Open category caps at 25 kg; the C0 class mark is "under 250 g" and gets the loosest
    subcategory (A1) — https://www.easa.europa.eu/en/domains/drones-air-mobility/operating-drone/open-category-low-risk-civil-drones
  - Canada: "micro" drones under 250 g need no registration or pilot certificate; 250 g–25 kg is the
    regulated small-RPAS band — https://tc.canada.ca/en/aviation/drone-safety/learn-rules-you-fly-your-drone/find-your-category-drone-operation

### B. Registration
- Must the **aircraft** and/or the **operator** be registered? At what weight? Recreational vs
  commercial purpose can change the answer.
- Illustrations:
  - US: everything above 250 g (and anything flown under Part 107 regardless of weight) must be
    registered and marked (14 CFR Part 48; 49 USC 44809(a)(8)) —
    https://www.law.cornell.edu/cfr/text/14/48.15, https://uscode.house.gov/view.xhtml?req=granuleid:USC-prelim-title49-section44809&num=0&edition=prelim
  - EU: operator registration is required unless the drone is a toy with no camera/sensor; C1–C4
    class drones always require it — https://www.easa.europa.eu/en/domains/drones-air-mobility/operating-drone/open-category-low-risk-civil-drones
  - Canada: registration and marking required at 250 g and up —
    https://tc.canada.ca/en/aviation/drone-safety/learn-rules-you-fly-your-drone/flying-your-drone-safely-legally

### C. Pilot test / certificate
- Is a knowledge test, online training, or certificate required, and does it differ by weight class
  or purpose?
- Illustrations:
  - US recreational: must pass "an aeronautical knowledge and safety test" (the TRUST test) and carry
    proof (49 USC 44809(a)(7)) — https://uscode.house.gov/view.xhtml?req=granuleid:USC-prelim-title49-section44809&num=0&edition=prelim
  - EU: C0 = read the manual; C1 = online training + exam; C2 adds an A2 theory/practical component —
    https://www.easa.europa.eu/en/domains/drones-air-mobility/operating-drone/open-category-low-risk-civil-drones
  - Canada: Basic certificate (age 14+) vs Advanced (16+) vs Level 1 Complex (18+, includes BVLOS
    privileges); micro (<250 g) needs none —
    https://tc.canada.ca/en/aviation/drone-safety/learn-rules-you-fly-your-drone/find-your-category-drone-operation

### D. Remote ID / electronic conspicuity
- Must the drone broadcast an ID? Is there a module retrofit path or geographic exemption zones?
  A self-built quad usually needs an **add-on broadcast module**, since it carries no built-in
  compliance.
- Illustrations:
  - US: Remote ID applies to any unmanned aircraft **registered or required to be registered**
    (14 CFR 89.101) — i.e., a sub-250 g recreational drone that needn't register also needs no
    Remote ID; anything heavier does — https://www.law.cornell.edu/cfr/text/14/89.101
  - EU: essentially all Open-category drones need direct remote identification, with limited
    exceptions; DoC-compliant add-on modules exist —
    https://www.easa.europa.eu/en/domains/drones-air-mobility/operating-drone/open-category-low-risk-civil-drones

### E. Visual line of sight (VLOS)
- Must the pilot (or a co-located observer) keep the aircraft in unaided sight the whole flight?
  This is near-universal at the hobby level, and it is what forbids most "the drone flies itself
  while I do something else" plans. FPV goggles typically require a visual observer.
- Illustrations:
  - US: 14 CFR 107.31 (pilot/observer must see the aircraft throughout the flight); recreational
    equivalent in 44809(a)(3) — https://www.law.cornell.edu/cfr/text/14/107.31
  - EU: Open category is VLOS-only (UAS.OPEN.010 ff., Reg. (EU) 2019/947) —
    https://eur-lex.europa.eu/eli/reg_impl/2019/947/oj/eng

### F. Flight over people and private property
- Can you overfly uninvolved people at all? At what weight? What horizontal separation is required?
  Separately: does national/local law restrict low flight over others' private property (trespass,
  privacy) independent of aviation rules?
- Illustrations:
  - US: no flight over people unless they are participants, under cover/in a vehicle, or the
    operation meets a Category 1–4 design standard (14 CFR 107.39) —
    https://www.law.cornell.edu/cfr/text/14/107.39
  - EU: A1 = no flight over uninvolved persons (only sub-250 g C0 may briefly overfly); A2 = 30 m
    from uninvolved people (5 m in low-speed mode); A3 = 150 m from residential/commercial areas
    (Reg. (EU) 2019/947 Annex Part A) — https://eur-lex.europa.eu/eli/reg_impl/2019/947/oj/eng
  - Canada: Basic operations keep horizontal distance from bystanders; Advanced certificate +
    declared drone safety features needed to fly closer —
    https://tc.canada.ca/en/aviation/drone-safety/learn-rules-you-fly-your-drone/find-your-category-drone-operation

### G. Altitude cap and airspace
- What is the ceiling (commonly **120 m / 400 ft AGL**), and where do you need airspace
  authorization (near airports, controlled airspace)?
- Illustrations:
  - US: 400 ft AGL under Part 107 (14 CFR 107.51, with a structure exception); recreational flyers
    are capped at 400 ft in uncontrolled airspace and need prior authorization in controlled
    airspace (44809(a)(5)-(6)) — https://www.law.cornell.edu/cfr/text/14/107.51
  - EU: 120 m in the Open category — https://www.easa.europa.eu/en/domains/drones-air-mobility/operating-drone/open-category-low-risk-civil-drones
  - Canada: 400 ft (122 m) AGL, structure exception at 100 ft within 200 ft of the structure
    (CARs 901.25) — https://laws-lois.justice.gc.ca/eng/regulations/SOR-96-433/section-901.25.html

### H. Night flying
- Is night flight allowed, and with what lighting/training?
- Illustration (US Part 107): allowed only with post-2021 training/test and **anti-collision
  lighting visible for at least 3 statute miles** with an adequate flash rate (14 CFR 107.29) —
  https://www.law.cornell.edu/cfr/text/14/107.29. A steady "escort light" does not satisfy an
  anti-collision-strobe requirement by itself.

### I. Autonomous flight and BVLOS
- Is autonomous operation (waypoints, follow-me) permitted while the pilot retains override? Is any
  beyond-visual-line-of-sight flight possible without a waiver/certificate?
- Illustrations:
  - EU: follow-me mode is defined and limited (up to 50 m from the pilot) in Reg. (EU) 2019/947;
    everything else in the Open category stays VLOS — https://eur-lex.europa.eu/eli/reg_impl/2019/947/oj/eng
  - Canada: BVLOS is gated behind the Level 1 Complex certificate tier —
    https://tc.canada.ca/en/aviation/drone-safety/learn-rules-you-fly-your-drone/find-your-category-drone-operation
  - US: BVLOS requires a Part 107 waiver; there is no recreational BVLOS path (44809(a)(3) requires
    VLOS unconditionally).

### J. Payload carriage and dropping
- May the drone carry an external load, and may anything be **dropped**? Dangerous-goods carriage is
  separately restricted. "Delivery for compensation" usually leaves the hobby framework entirely.
- Illustrations:
  - US: dropping an object in a way that creates an undue hazard to persons or property is
    prohibited (14 CFR 107.23) — https://www.law.cornell.edu/cfr/text/14/107.23
  - EU: the Open category flatly prohibits dropping material and carrying dangerous goods
    (Reg. (EU) 2019/947 Annex Part A) — https://eur-lex.europa.eu/eli/reg_impl/2019/947/oj/eng

### K. Purpose test (recreational vs "operational")
- Does your regulator split rules by **purpose** (pure recreation vs anything else)? Yard patrol,
  security escort, and delivery are typically not "strictly recreational" — in the US that language
  is literally the first condition of 49 USC 44809(a)(1), which would push those uses into Part 107.

---

## 2. Collision map — this project's use cases vs the rules

| Use case | Rules it collides with | Severity |
|---|---|---|
| Follow-me filming | VLOS (E) if the drone trails you out of sight; autonomy limits (I) — EU caps follow-me at 50 m; over-people (F) if others are nearby | Medium — legal in tight VLOS form, illegal as "walk away and let it follow" |
| Yard patrol (automated) | Purpose test (K) — arguably not recreation; autonomy/BVLOS (I) if unattended; over private property/privacy (F) at the boundary | High — unattended autonomous patrol has no hobby-legal form in any framework surveyed |
| Night escort with a light | Night rules (H) — needs anti-collision strobe + training, a utility light is not enough; VLOS at night (E); purpose test (K) | Medium — feasible with strobe, training, and pilot present |
| Small payload delivery | Dropping prohibitions (J) — EU Open bans it outright, US bans hazardous drops; over people (F) at the recipient; purpose/compensation (K) | High — payload *drop* is the most restricted; payload *carry-and-land* on your own property is the survivable version |

Milestone-ladder implication: stage as (1) manual VLOS day flight → (2) night flight with strobe →
(3) short-leash follow-me with pilot watching → (4) payload carry-and-land on own property.
Autonomous patrol and any true BVLOS/drop step should be marked "requires waiver/Specific-category
authorization or is out of hobby scope," not scheduled as a normal milestone.

## 3. Sub-250 g vs the 5-inch build

A 5-inch quad with battery is realistically 500–800 g at takeoff — **it is above the 250 g line in
every framework surveyed**. Consequences: registration (US/EU/Canada), Remote ID (US: because
registration is required, 14 CFR 89.101; EU: Open-category remote identification), pilot
test/certificate tiers, and loss of the sub-250 over-people allowances (EU C0 overflight, Canada
micro exemptions). If minimum regulatory surface ever matters more than performance, that is a
**sub-250 g build decision made at the BOM stage** (frame, battery, camera all count toward takeoff
weight) — it cannot be retrofitted onto a 5-inch airframe. Note sub-250 g exempts you from
registration-type paperwork, **not** from operating rules (VLOS, altitude, airspace, reckless
operation, privacy law).

## 4. What was not verified (and known gaps)

- **faa.gov and ecfr.gov block automated retrieval** (HTTP 403 / bot-block redirect). US claims are
  cited to uscode.house.gov (statute) and law.cornell.edu's verbatim CFR mirror instead of the
  regulator's own pages. Spot-check https://www.faa.gov/uas manually before relying on them.
- **UK CAA specifics unverified**: the CAA Drone Code index confirms flyer ID / operator ID and
  height/distance rules exist (https://www.caa.co.uk/drones/open-category/drone-code/), but the
  numeric thresholds (250 g/camera trigger, 50 m from people) sit on sub-pages that could not be
  retrieved. UK is therefore not used as a load-bearing illustration.
- **Canada bystander distance (30 m) and night-lighting specifics** were not confirmed in the
  retrieved TC pages; the category framework and 122 m cap were.
- **US recreational night flying**: 49 USC 44809 is silent on night; FAA guidance on recreational
  night ops lives on the blocked faa.gov pages — unverified.
- Local law (municipal ordinances, privacy/trespass statutes, park rules) is out of scope of any
  aviation checklist above and must be checked separately in your jurisdiction.
