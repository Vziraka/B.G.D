# Radio link research: RC control, telemetry, and MAVLink command path (ticket 03)

> **Consolidation note — 2026-08-30**
> Historical link architecture; final hardware, firmware compatibility, and authorization enforcement still require validation.
> Source: `research/radio-link`, commit `c7d723482c0a92652750c42cd0b366f75f11906e`, file `docs/research/radio-link.md`.
> Original report text is retained below, with line endings normalized; this consolidation did not revalidate its external claims. Current decisions: [Lock the milestone ladder](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md).

Researched 2026-08-06 against primary sources (ExpressLRS docs/GitHub, ArduPilot docs, PX4 docs, EdgeTX manual). All claims cited. Verification verdicts marked inline.

## Verdict on the earlier AI claim

> "MAVLink command packets over ExpressLRS from a handheld unit"

**NUANCED — the core mechanism is real, the "handheld unit" part glosses over the actual topology.**

- **Confirmed:** MAVLink-over-ExpressLRS is an official, shipping feature. ELRS firmware v3.5.0+ (TX and RX) provides "full bi-directional MAVLink support, enabling both native MAVLink telemetry downlink and RC control uplink over a single radio link," including "full parameter editing and mission planning support" from a GCS — i.e. ground→drone command injection over the ELRS link works. Source: https://www.expresslrs.org/software/mavlink/
- **Nuance 1 — topology:** A custom handheld unit does not speak the ELRS air protocol itself. The documented ingestion path is: GCS-style device → WiFi/UDP → TX module's backpack (TX Backpack v1.5.0+ required for internal modules) → ELRS uplink → flight controller. So the voice unit talks to the *transmitter's WiFi backpack*, not directly over ELRS RF. Source: https://www.expresslrs.org/software/mavlink/
- **Nuance 2 — bandwidth:** The MAVLink uplink is narrow: ~1,190 B/s up / ~2,375 B/s down at 2.4 GHz F1000, with a forced 1:2 telemetry ratio and hybrid/16-ch switch mode. Fine for discrete commands (COMMAND_LONG, mode changes, guided-mode setpoints at low rate); not a fat data pipe. Source: https://www.expresslrs.org/software/mavlink/
- **Nuance 3 — hardware constraint:** ESP-based TX/RX only (STM32 ELRS hardware cannot do MAVLink mode); 2.4 GHz or LR1121 dual-band recommended, legacy 900 MHz is significantly slower. Source: https://www.expresslrs.org/software/mavlink/
- **Refuted (implicitly):** the old ELRS "AirPort" serial-passthrough route is *not* the way to do this. AirPort replaces RC control entirely (RC + AirPort simultaneously needs two full TX/RX pairs), has no ACK/retransmission, tops out around 500–1,665 B/s, and the docs explicitly say MAVLink via AirPort is "no longer recommended" since v3.5 — use the dedicated MAVLink feature. Source: https://www.expresslrs.org/software/airport/

## (a) Manual RC control — how it travels

- ELRS natively carries **up to 16 RC channels** over its own LoRa-based air protocol. In the common modes, channels 1–4 (sticks) go 10-bit in every packet plus a 2-position arm channel; aux channels are lower-resolution or round-robin (hybrid: 3-bit ch6–11; wide: 6-bit/64-pos; full-res 16ch mode: all 16 at 10-bit, half rate). Source: https://www.expresslrs.org/software/switch-config/
- Receiver → flight controller is a serial CRSF connection: ArduPilot uses `SERIAL_PROTOCOL = 23`, `RSSI_TYPE = 3`, DMA-capable UART, and `RC_OPTIONS` bit 13 for ELRS's 420 kBaud (vs Crossfire's 416 kBaud). Betaflight is the same CRSF wiring. Source: https://ardupilot.org/copter/docs/common-tbs-rc.html
- Milestone 1 needs nothing beyond this: handset → ELRS TX module → RF → RX → CRSF → FC.

## (b) Telemetry — how it travels back

- CRSF telemetry rides the same ELRS link in reverse, in telemetry slots set by the telemetry ratio. Two packet types: LINK (link stats, always ~2/s) and DATA ("Advanced Telemetry" from the FC, shared with MSP transfers); burst mode concentrates DATA packets to roughly double effective throughput. Source: https://www.expresslrs.org/info/telem-bandwidth/
- Real numbers (2.4 GHz, from the official bandwidth table): 250 Hz @ 1:2 ≈ 4,922 bps with burst; 500 Hz @ 1:2 ≈ 9,922 bps with burst; 1:8 ratios land around 1.2–2.4 kbps. So think **hundreds of bytes to ~1.2 kB/s**, not a serial-radio-class pipe. Source: https://www.expresslrs.org/info/telem-bandwidth/
- For milestone 1 (Betaflight, manual LOS), CRSF telemetry to the handset (RSSI/LQ, battery voltage, GPS if fitted) is sufficient and free — no extra hardware.
- The classic separate-link alternative for autopilot telemetry is a **SiK 915/433 MHz serial radio or WiFi**, which PX4 documents as the standard GCS links ("protocol compatible with SiK Radio and will generally work out of the box"; WiFi = "shorter range, higher data rates"). Source: https://docs.px4.io/main/en/telemetry/ — This remains a valid fallback but is no longer the *only* answer.

## (c) Later voice-derived MAVLink commands — viable path

- **Is command injection over ELRS viable? Yes**, since v3.5.0 (current stable is 4.1.0, released 2026-07-17; 4.x added Yaapu CRSF translation, serial GPS, GPS time sync). Sources: https://www.expresslrs.org/software/mavlink/ , https://github.com/ExpressLRS/ExpressLRS/releases
- Supported FC firmware for MAVLink-over-ELRS: **ArduPilot** (`SERIALx_PROTOCOL = 2`, 460800 baud, `RSSI_TYPE = 5`), **PX4** (`MAV_0_CONFIG` → TELEM port, 460800), INAV v8+ (limited), Betaflight only in 2025.12+ beta. Practical consequence: **the voice-command milestone implies moving the drone to ArduPilot (or PX4)** — Betaflight has no meaningful MAVLink command surface. Sources: https://www.expresslrs.org/software/mavlink/ , https://ardupilot.org/copter/docs/common-tbs-rc.html
- ArduPilot's docs confirm the ground-side hop: with a WiFi-capable ELRS TX module, "the telemetry data can be forwarded wirelessly to a PC or phone based GCS close to the transmitter" — the same UDP path a custom voice unit would inject MAVLink into. Source: https://ardupilot.org/copter/docs/common-tbs-rc.html

## Which ecosystem to buy into now

**2.4 GHz ExpressLRS, ESP-based hardware, EdgeTX handset.** Reasons:

- 2.4 GHz ESP hardware is exactly what the MAVLink feature requires (900 MHz "significantly slower", STM32 excluded) — so milestone-1 gear carries forward to milestone 3 unchanged. Source: https://www.expresslrs.org/software/mavlink/
- ELRS is open-source, the cheapest ecosystem per unit (receivers are commodity parts), and ArduPilot lists it as a first-class RC system. Source: https://ardupilot.org/copter/docs/common-rc-systems.html
- EdgeTX radios (RadioMaster Pocket/Boxer class) natively act as a **USB HID joystick** for simulators — Classic/Advanced modes, per-channel axis/button mapping, 1000 Hz mixer in joystick mode — satisfying the "transmitter doubles as sim controller" requirement with zero extra hardware. Source: https://manual.edgetx.org/color-radios/model-settings/model-setup/usb-joystick
- Alternatives rejected: TBS Crossfire/Tracer (closed, pricier, no equivalent official MAVLink-uplink feature in its docs at time of writing — not fully verified, see below), FrSky/Spektrum (no MAVLink path, weaker ecosystem for self-built quads).

Buy: one EdgeTX handset with internal 2.4 GHz ELRS ESP module (confirm TX Backpack support — RadioMaster internal modules have it), commodity ESP-based 2.4 GHz RX per craft.

## Sketched later architecture (ground→drone)

```
[Voice unit (handheld, does STT + verification, emits MAVLink)]
        │  WiFi (UDP, MAVLink)
        ▼
[ELRS TX backpack (v1.5.0+) in the handset's TX module]
        │  merged with RC channels
        ▼
[ELRS 2.4 GHz RF link — RC uplink + bidirectional MAVLink, ~1.2 kB/s up]
        ▼
[ELRS RX] ── UART @460800, SERIALx_PROTOCOL=2 ──► [FC running ArduPilot]
```

- Pilot's sticks retain full-rate RC priority on the same link; manual override is inherent.
- Migration path: milestone 1 flies Betaflight + CRSF; milestone 3 reflashes the same FC (or swaps to an ArduPilot-capable board) and flips the RX to MAVLink mode. No radio hardware is discarded.
- Fallback if ELRS bandwidth or backpack latency proves inadequate: add a SiK 915 MHz or WiFi telemetry link per PX4/ArduPilot standard practice (https://docs.px4.io/main/en/telemetry/). This is additive, not a replacement.

## What I could not verify

- Exact uplink latency of the WiFi-backpack → ELRS MAVLink path (no official figures published; only throughput is documented).
- Whether every RadioMaster internal TX module ships backpack v1.5.0-capable hardware — check the specific handset's product page before buying.
- TBS Crossfire's current MAVLink capabilities were not checked against TBS primary docs (rejected on cost/openness grounds anyway).
- GitHub release notes summary conflated MAVLink introduction with 4.0.0 Yaapu translation; the ELRS docs' "minimum v3.5.0" requirement is the authoritative version claim used here.
