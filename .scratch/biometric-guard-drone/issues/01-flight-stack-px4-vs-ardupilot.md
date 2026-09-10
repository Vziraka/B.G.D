# Flight stack: PX4 vs ArduPilot

Type: research
Status: resolved

## Question

Which flight-controller firmware should this project standardise on — PX4 or ArduPilot — for a beginner-built 5-inch-class quad that must later carry a companion computer for autonomous features?

Weigh, against primary sources (official docs of each project):

- Beginner documentation quality and community help for a first self-build.
- Companion-computer integration: MAVLink routing, PX4's uXRCE-DDS vs ArduPilot's approaches, ROS 2 support maturity. (The Gemini doc asserts uXRCE-DDS and "no legacy MAVROS" — verify rather than inherit.)
- Later-milestone fit: injecting external commands (voice-derived), follow-me/precision-loiter support, gimbal control.
- Supported flight-controller boards that are cheap or commonly available secondhand.
- SITL simulation story on a Windows machine (WSL2), since dev machine is Windows.

Findings: [Shared research report](../../../docs/research/flight-stack.md), originally from branch `research/flight-stack` (commit `1410f67`). Read its dated status note before applying the historical answer below.

## Answer

**ArduPilot (ArduCopter ≥ 4.5) on an STM32 H743-class board.**

- **Board economics (decisive at this budget):** ArduPilot documents 200+ boards including cheap betaflight-style AIO boards used on 5-inch quads (SpeedyBee/Matek F405, Kakute H7, ~$60–90). PX4's supported hardware centres on pricier Pixhawk-standard boards.
- **Broader milestone fit:** ArduPilot has Precision Loiter *and* Precision Landing; PX4 has landing only. Both do Follow modes and MAVLink gimbal v2; ArduPilot adds onboard Lua scripting.
- **Incremental companion path:** milestone-2 voice/follow needs only MAVLink Guided-mode targets from the Pi — no ROS required on day one; ROS 2 (AP_DDS, Humble) remains available later. WSL2 SITL officially supported by both, so no differentiator.
- **On Gemini's "uXRCE-DDS, never legacy MAVROS" rule:** partially true, PX4-specific, overstated. The defensible rule is "no ROS 1", not "no MAVROS" — and with ArduPilot the primary companion interface is plain MAVLink anyway.
- Consistent with ticket 03's link sketch (its MAVLink-over-ELRS path assumed ArduPilot/PX4 on the drone; ArduPilot qualifies).

Could-not-verify items (community size comparisons, some release-version history) listed in the findings doc.

## Comments

### 2026-08-30 — Shared research and current scope

The ArduPilot research direction is retained. The later Q75 hardware selection and R1.1 corrections control the board path. The September 9 product amendment replaces biometric approval before every arm with the [v1 phone/onboard interaction contract](../../../docs/phone-drone/interaction-contract.md): paired-device launch authority, onboard face/liveness before spoken commands, and independent radio takeover. Flight-controller compatibility and enforcement remain implementation and validation work.

The original question and answer are retained as history. The report is now available in the main checkout with source provenance; consolidation did not revalidate its external claims or change this research ticket's resolved status.
