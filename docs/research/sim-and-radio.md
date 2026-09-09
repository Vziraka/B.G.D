# Research 08: Practice simulator + transmitter selection

> **Consolidation note — 2026-08-30**
> Historical simulator/radio selection; original prices and budget allocations are not current purchase approval.
> Source: `research/sim-and-radio`, commit `c3ef799dafdd5bd87024b31e76de23df18273489`, file `docs/research/sim-and-radio.md`.
> Original report text is retained below, with line endings normalized; this consolidation did not revalidate its external claims. Current decisions: [Lock the milestone ladder](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md).
> Newer budget evidence: [lifetime budget rebaseline](lifetime-budget-rebaseline.md).

Date: 2026-08-06. Prices in USD, checked against manufacturer/store pages on this date.
Constraint recap: Windows PC, GPU unknown (assume possibly integrated graphics), milestone 1 is LINE-OF-SIGHT flying, radio ecosystem locked to 2.4 GHz ExpressLRS + EdgeTX (ticket 07).

## Recommendation (TL;DR)

- **Transmitter: RadioMaster Pocket (ELRS version), $71.50 new** from RadioMaster direct. Internal 2.4 GHz ELRS, EdgeTX preinstalled, Hall gimbals, USB-C. Add ~$10–15 for two 18650 cells (not included).
- **Simulator: FPV Freerider, $5.99** — the only shortlisted sim that explicitly advertises a line-of-sight (LOS) mode, and the lightest on hardware. Safe on integrated graphics.
- **Step-up sim: VelociDrone (~$20)** if the PC turns out to have any half-decent GPU — official minimum is Intel HD 4000, so even many integrated GPUs qualify; has an LOS camera (F key).
- **Practice guidance: 10–25 sim hours before the first real LOS flight**; no hard community number exists (see below).
- Radio + sim + batteries: **~$90–110** of the $500–600 budget.

## Transmitter

### Primary pick: RadioMaster Pocket (ELRS)

Source: https://www.radiomasterrc.com/products/pocket-radio-controller-m2

- Price: **$71.50** (ELRS 2.4 GHz, FCC or LBT variant), verified on the RadioMaster product page 2026-08-06.
- Internal RF: "ELRS 2.4GHz" internal module option — this is the ELRS variant; do NOT buy the cheaper CC2500 variant, it is a different protocol and useless for the locked ELRS ecosystem.
- Firmware: "Preinstalled with EdgeTX firmware" (RadioMaster is an EdgeTX Gold Partner).
- Gimbals: X5 Hall-effect, quad ball-bearing nano gimbals (AG01 Nano compatible).
- Power: 2x 18650 Li-ion cells, **not included** (~$10–15 extra); USB-C QC3 charging built in.
- USB-HID sim support: the RadioMaster page does not list this explicitly, but it is an EdgeTX OS feature, not a per-radio feature. EdgeTX documents USB Joystick (HID) mode — "Joystick" interface mode with 8 analog axes / 24 buttons over USB — in the official manual: https://manual.edgetx.org/color-radios/model-settings/model-setup/usb-joystick and https://manual.edgetx.org/edgetx-how-to/joystick-mapping-information-for-game-developers. A Steam community sim-setup guide even uses the Pocket as its worked example (https://steamcommunity.com/sharedfiles/filedetails/?id=3627458818). Confidence: high.
- Price vs. ticket target: the ~$50–60 target from ticket 07 is **stale** — manufacturer-direct is $71.50 as of today. Secondhand or retailer sales may still land $50–60; not verified.

### Alternative: RadioMaster Boxer (ELRS)

Source: https://www.radiomasterrc.com/products/boxer-radio-controller-m2

- Price: **$153.99** (ELRS/FCC). Internal fan-cooled 2.4 GHz ELRS module, 1000 Hz capable; EdgeTX preinstalled; full-size V4.0 Hall gimbals.
- Verdict: nicer full-size gimbals and more switches, but 2x the price. Only worth it if hand size/ergonomics on a compact radio is a known problem. The Pocket carries into every later milestone (including MAVLink-over-ELRS) identically.

## Simulator shortlist (Windows)

All requirements below are minimums as published on the official store/support page unless noted.

| Sim | Price | Min GPU | Min CPU/RAM | Runs on integrated? | LOS mode? |
|---|---|---|---|---|---|
| **FPV Freerider** | $5.99 (itch.io) | none listed; only "does not work with Intel G45/G43" | Core2 Duo 2 GHz / 2 GB (3rd-party listing) | **Yes** (lightest option) | **Yes — explicit** |
| **VelociDrone** | ~$20 | **Intel HD 4000** or better | 2.0 GHz / 4 GB (rec: i3 + GTX 760 / 8 GB) | Yes (bare min "will not run all scenes") | Yes (F key toggle, manual) |
| FPV.SkyDive | **Free** | GTX 650 2 GB | i5 / 8 GB | No | Not documented |
| Uncrashed | $14.99 | GTX 770 2 GB | i5-2300 / 4 GB | No | Not documented |
| TRYP FPV | $16.99 | GTX 960 / HD 7750 | i5 2.4 GHz / 3 GB | No | Not documented |
| Liftoff | $19.99 | **RTX 2060** / Vega 56 | Intel 8th gen / 8 GB | No | Not documented |

Sources:
- FPV Freerider (official itch.io page): $5.99, "First person view (FPV) and line of sight (LOS) flying available", Intel G45/G43 incompatibility note — https://fpv-freerider.itch.io/fpv-freerider. Min specs (Core2 Duo / 2 GB / GTX 960M-class listed by aggregators, not the official page): https://sysrqmts.com/games/fpv-freerider — the aggregator GPU line conflicts with real-world reports that it runs on weak hardware; the official page's only hard exclusion is the G45/G43 chipset. Propwash Service (community FPV wiki) recommends it specifically for "low hardware requirements": https://propwashservice.com/intro/sim
- VelociDrone (official Bat Cave Games support article): min "2.0ghz processor", "Intel HD 4000 GPU or better", 4 GB RAM; recommended i3 + GTX 760 + 8 GB; "more sensitive to graphics card than CPU" — https://batcavegames.freshdesk.com/support/solutions/articles/16000062353-what-computer-specification-do-i-need-to-run-velocidrone-. Price ~$20 (single purchase tier) per GetFPV/community sources — https://www.getfpv.com/learn/fpv-flight-academy/velocidrone-the-most-realistic-fpv-simulator/ — the official shop (https://www.velocidrone.com/shop) requires an account, so exact current tier pricing **not verified**. LOS camera: official manual/community docs describe F-key toggle to a ground-observer view with adjustable 1.0–2.0 m eye height — https://www.apollomaniacs.com/ipod/howto_ar_drone_velocidrone_tuning_en.htm
- FPV.SkyDive (official Steam page): free-to-play; min i5 / GTX 650 2 GB / 8 GB — https://store.steampowered.com/app/1278060/
- Uncrashed (Steam): $14.99; min i5-2300 / GTX 770 / 4 GB — https://store.steampowered.com/app/1682970/Uncrashed__FPV_Drone_Simulator/
- TRYP FPV (Steam): $16.99; min i5 2.4 GHz / GTX 960 / 3 GB — https://store.steampowered.com/app/1881200/TRYP_FPV_Drone_Racer_Simulator/
- Liftoff (Steam): $19.99; min Intel 8th gen / RTX 2060 / 8 GB — https://store.steampowered.com/app/410340/Liftoff_FPV_Drone_Racing/

### Why FPV Freerider first

- GPU is unknown and possibly integrated: Liftoff, TRYP, Uncrashed, and FPV.SkyDive all list discrete GPUs as minimum. Freerider is the only one with effectively no GPU floor; VelociDrone is the only other integrated-GPU-plausible option.
- Milestone 1 is LOS: Freerider is the only sim on the list that advertises LOS flying as a headline feature; VelociDrone has an LOS camera but it is a secondary mode. The heavier sims are FPV-centric.
- $5.99 risk: if it turns out the PC can run VelociDrone, the Freerider spend is throwaway money; buy VelociDrone later for its better physics.
- There is a free Freerider demo on the same itch.io page — try it before paying anything, which also answers the "what GPU do I actually have" question empirically.

## Practice hours before first real flight

No hard consensus exists; treat any single number as folklore. Data points:

- Propwash Service (community FPV onboarding wiki): "The answers to this question vary widely — 5, 10, 20, 100, or even 1,000 hours"; cites one pilot needing ~25 h to reach smoothness indicating IRL readiness — https://propwashservice.com/intro/sim
- UK Army UAS Centre requires **30 h minimum** sim time before drone operator courses (professional bar, stricter than hobby) — https://soldier.army.mod.uk/issues/october-2025/update/drones
- Working guidance for this project: **10–25 hours** of deliberate practice (hover, slow circuits, figure-8s, controlled landings — in LOS camera mode, angle mode first) before the first real LOS flight. Confidence: medium — synthesized from the above, not a single citable consensus.

## Not verified / open items

- VelociDrone exact current price and license tiers (shop behind login). Assume ~$20 base; confirm before purchase.
- Whether FPV.SkyDive/Uncrashed/TRYP/Liftoff have LOS camera modes — not documented on their store pages; irrelevant given they fail the GPU constraint anyway.
- Pocket secondhand pricing at the $50–60 ticket target — manufacturer-direct is $71.50; retailer/used prices not surveyed.
- FPV Freerider's aggregator-listed "GTX 960M" minimum conflicts with its official page and community low-end reports; the official page only excludes Intel G45/G43 chipsets.

## Budget impact

- RadioMaster Pocket ELRS: $71.50
- 2x 18650 cells: ~$10–15
- FPV Freerider: $5.99 (+ VelociDrone ~$20 later, optional)
- **Total: ~$88–112** of the $500–600 project budget, leaving ~$490+ for the quad build.
