# Country-agnostic drone regulations checklist

Type: research
Status: resolved

## Question

Produce a country-agnostic checklist of the regulatory questions any hobbyist must answer before flying a self-built ~5-inch quad in suburban/rural areas — phrased so the user can privately apply their own jurisdiction. Do not ask or assume where the user lives.

- The recurring thresholds: takeoff weight classes (the ~250 g line and up), registration, pilot tests, remote ID or equivalents, visual line of sight, flight over people/property, altitude caps, night flying.
- Use major frameworks (FAA, EASA, and one or two others) as *illustrations* of how the answers differ, citing the primary regulator pages.
- Flag which of this project's use cases (follow-me filming, yard patrol, night escort, payload delivery) commonly collide with rules, so the milestone ladder can stage them honestly.
- Note the sub-250g vs 5-inch build implication explicitly.

Findings: [Shared research report](../../../docs/research/regulations.md), originally from branch `research/regulations` (commit `58259b4`). Read its dated status note before applying the historical answer below.

## Answer

Full cited checklist in the findings doc. Headlines:

- **~250 g takeoff weight is the universal break point** (US/EU/Canada all use it): below it, registration/Remote ID/certificate tiers largely fall away; above it they all attach. A 5-inch build (~500–800 g wet) is above the line in every framework surveyed — **sub-250 vs 5-inch is a BOM-stage decision, not retrofittable**.
- Near-universal hobby baseline: visual line of sight, ~120 m / 400 ft altitude cap, distance from uninvolved people, purpose test ("strictly recreational").
- **Use-case legality ranking:**
  - *Follow-me filming*: legal in short-leash, pilot-watching form (EU caps follow-me at 50 m).
  - *Night escort*: feasible with an anti-collision strobe + training requirements.
  - *Payload delivery*: dropping is banned outright in the EU Open category and hazardous drops banned in the US; carry-and-land on own property is the survivable version.
  - *Unattended yard patrol*: **no hobby-legal form in any framework surveyed** (purpose test + autonomy + beyond-line-of-sight all collide).
- Unverified items (UK CAA thresholds, a Canadian distance figure) flagged in the doc; US claims cited via official mirrors since faa.gov blocks fetches.

## Comments

### 2026-08-30 — Shared research and current scope

Authorization-dependent aspirations remain normal roadmap milestones with permission and safety prerequisites. The earlier categorical legal conclusions are historical research, not universal exclusions or approvals; no jurisdiction is assumed. Confirmed scope is recorded in [Lock the milestone ladder](10-milestone-ladder.md#comments).

The original question and answer are retained as history. The report is now available in the main checkout with source provenance; consolidation did not revalidate its external claims or change this research ticket's resolved status.
