# Milestone-1 bill of materials

Type: research
Status: resolved
Blocked by: 01, 03, 04, 08 (all resolved)

## Question

Build the complete milestone-1 shopping list and verify it fits $500–600 all-in, given: flight stack (ticket 01), radio ecosystem (03), payload headroom for the later companion computer (04), and the transmitter already chosen (08).

- Everything, the user owns nothing: frame, motors, ESC, flight controller, props (plural — crashes), receiver, battery ×2, charger, soldering iron + basics, multimeter, straps/spares.
- New vs secondhand guidance per category: what's safe used (frames, transmitters) vs buy-new (LiPo batteries).
- Line-of-sight build — no FPV camera/goggles/VTX unless trivially cheap; note what adding FPV later costs.
- Frame/motor sizing must carry the ticket-04 payload gram budget without rebuying.
- Output: itemised table with realistic prices and a running total, plus a cheapest-viable column.

Findings: [Shared research report](../../../docs/research/milestone-1-bom.md), originally from branch `research/milestone-1-bom` (commit `1afc6e1`). Read its dated status note before applying the historical answer below.

## Answer

**Build:** TBS Source One V5.1 7-inch deadcat frame + 4× EMAX ECO II 2807 1300KV motors (6S) + SpeedyBee F405 V3 50A FC/ESC stack (verified on ArduPilot's supported list, target `SpeedyBeeF405v3`) + RadioMaster RP1 V2 ELRS receiver + 2× CNHL 6S 3300mAh 40C LiPos + ToolkitRC M6 charger + full tool kit.

**Thrust check:** ~6 kg conservative total thrust vs ~1.26 kg all-up weight *including* the 250 g Pi payload → thrust-to-weight ≈ 4.7:1, hover at ~21% throttle. The payload reservation holds comfortably.

**Totals (prices dated 2026-08-06):**
- Typical new: $506 quad+tools → **$594–618 project total — up to ~$18 over the $600 ceiling.** Named cuts to fit: Amazon motor 4-pack (−$16), 3 prop sets instead of 4 (−$5) → ≈$585–597.
- Cheapest-viable: $405 quad+tools → **$493–517 total — under ceiling with margin** (LiPos still new — never buy used LiPos).

**Risks:** LiPo price unverified (±$20 across two packs, biggest line item); TBS frame was out of stock at one vendor (any 7" long-deck deadcat substitutes, $50–60); the SpeedyBee F405 V3 is the last cheap ArduPilot-supported SpeedyBee stack — if stock vanishes, fallback is Matek H743 (~$120+), which strains the budget.

## Comments

### 2026-08-30 — Shared research and current scope

The self-built, payload-ready 7-inch direction is retained. Hardware choices and costs are reopened against the working lifetime ceiling; the old component list and apparent milestone-1 fit are not purchase approval. See the [provisional budget rebaseline](../../../docs/research/lifetime-budget-rebaseline.md). Confirmed scope is recorded in [Lock the milestone ladder](10-milestone-ladder.md#comments).

The original question and answer are retained as history. The report is now available in the main checkout with source provenance; consolidation did not revalidate its external claims or change this research ticket's resolved status.
