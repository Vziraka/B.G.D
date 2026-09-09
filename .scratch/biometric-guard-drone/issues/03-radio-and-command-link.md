# Radio & command-link architecture

Type: research
Status: resolved

## Question

How do (a) manual RC control, (b) telemetry, and (c) later voice-derived MAVLink commands actually travel from ground to drone? The Gemini doc claims "MAVLink command packets over ExpressLRS" from a handheld unit — verify this against primary sources (ExpressLRS docs, PX4/ArduPilot telemetry docs).

- ExpressLRS: what it carries natively (RC channels), real telemetry bandwidth, MAVLink-over-ELRS status (e.g. the airport/MAVLink features) — is it viable for command injection or is a separate link (telemetry radio, WiFi) the standard answer?
- Which radio ecosystem to buy into now (2.4GHz ELRS vs alternatives) given milestone 1 is manual flight and the transmitter doubles as the USB simulator controller.
- Sketch the likely later architecture (handheld mic unit → drone) so milestone-1 purchases don't dead-end.

Findings: [Shared research report](../../../docs/research/radio-link.md), originally from branch `research/radio-link` (commit `c7d7234`). Read its dated status note before applying the historical answer below.

## Answer

**The Gemini claim ("MAVLink over ExpressLRS from a handheld unit") is NUANCED — mostly viable, with corrections.**

- Confirmed: MAVLink-over-ELRS is an official ELRS feature since v3.5.0 (stable 4.1.0) — bidirectional MAVLink + RC on one link, including command injection from a ground device.
- Corrections: the handheld unit wouldn't speak ELRS RF directly — it injects MAVLink via WiFi/UDP into the TX module's "backpack"; uplink bandwidth is only ~1,190 B/s (fine for short commands, not for streams); ESP-based 2.4 GHz hardware only; Betaflight barely supports it → the voice milestone implies ArduPilot/PX4 on the drone, which fits.
- Refuted sub-path: ELRS "AirPort" serial passthrough is officially not recommended for MAVLink and can't coexist with RC.
- Fallback if ever needed: separate SiK/WiFi telemetry radio (documented PX4/ArduPilot path), no longer required.

**Ecosystem to buy into:** 2.4 GHz ExpressLRS, ESP-based TX/RX, EdgeTX handset (RadioMaster Pocket/Boxer class) — cheapest, native USB-HID joystick for simulators, carries unchanged into the MAVLink milestone.

**Later architecture sketch:** voice unit → WiFi UDP MAVLink → ELRS TX backpack → 2.4 GHz link (RC + MAVLink merged) → RX UART → flight controller. Sticks keep priority. Milestone 1 can fly Betaflight+CRSF on the same hardware and reflash later.

Unverified items (backpack latency figures, specific internal-TX backpack versions) listed in the findings doc.

## Comments

### 2026-08-30 — Shared research and current scope

The link architecture remains research input, not a validated final integration. The later biometric-enabled phase requires face-and-voice authorization even for the radio arm switch; emergency in-flight control remains independent. Confirmed scope is recorded in [Lock the milestone ladder](10-milestone-ladder.md#comments).

The original question and answer are retained as history. The report is now available in the main checkout with source provenance; consolidation did not revalidate its external claims or change this research ticket's resolved status.
