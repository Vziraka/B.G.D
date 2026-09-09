# Practice simulator + transmitter choice

Type: research
Status: resolved
Blocked by: 03 (resolved)

## Question

Which FPV practice simulator (Windows-native, free or cheap) and which radio transmitter (~$50–60, secondhand acceptable) should the user buy for simulator-first flight training — where the same transmitter carries over to the real milestone-1 build?

- Transmitter must: work as a USB controller for the sim, and speak whatever link ticket 03 selects (likely ELRS) for the real quad. Name 1–2 concrete models with current prices.
- Simulator shortlist with cost and realism for line-of-sight (not FPV-goggle) flying — milestone 1 flies line-of-sight.
- Rough practice-hours guidance from community consensus before first real flight (`/last30days` sentiment welcome here).

Findings: [Shared research report](../../../docs/research/sim-and-radio.md), originally from branch `research/sim-and-radio` (commit `c3ef799`). Read its dated status note before applying the historical answer below.

## Answer

**Transmitter: RadioMaster Pocket ELRS — $71.50 new** (manufacturer-direct, current price; the ticket's $50–60 target was stale). Internal 2.4 GHz ELRS, EdgeTX preinstalled, USB-HID joystick for sims confirmed from the EdgeTX manual. Needs 2× 18650 cells (~$10–15). Buy the **ELRS** variant, not CC2500. Boxer ELRS ($154) not worth 2× for this project.

**Simulator: FPV Freerider, $5.99** — the only shortlisted sim that explicitly advertises line-of-sight flying and has essentially no GPU floor; free demo to try first. Step-up if the PC handles it: VelociDrone (~$20, Intel HD 4000 minimum, has an LOS camera mode). Everything else surveyed (Liftoff, TRYP, Uncrashed, FPV.SkyDive) needs a discrete GPU.

**Practice guidance: 10–25 hours** of deliberate LOS practice (hover, circuits, figure-8s, landings) before first real flight — community range is wide, confidence medium.

**Running spend: ~$88–112** (radio + cells + sim), leaving roughly $490 of the ceiling for the quad itself.

## Comments

### 2026-08-30 — Shared research and current scope

The practice direction is retained, but the budget is a lifetime target/working ceiling, not a milestone-1 allowance. Historical running spend is a planning allocation, not a purchase record or proof of affordability. See the [provisional budget rebaseline](../../../docs/research/lifetime-budget-rebaseline.md). Confirmed scope is recorded in [Lock the milestone ladder](10-milestone-ladder.md#comments).

The original question and answer are retained as history. The report is now available in the main checkout with source provenance; consolidation did not revalidate its external claims or change this research ticket's resolved status.
