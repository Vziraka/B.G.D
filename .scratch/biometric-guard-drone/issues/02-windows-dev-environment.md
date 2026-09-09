# Windows dev environment: WSL2 vs dual-boot vs mixed

Type: research
Status: resolved

## Question

The dev machine is Windows (GPU unknown; assume CPU-only). What environment should host each part of the toolchain: PX4/ArduPilot SITL + Gazebo, ROS 2, the Python biometric stack (face + voice), and FPV practice simulators?

- Does SITL + Gazebo run acceptably under WSL2/WSLg today, or is dual-boot Ubuntu materially better? Cite the official PX4/ArduPilot dev-env docs.
- Note that FPV *practice* sims are native Windows games — separate concern from SITL; confirm and name where each piece runs.
- USB device access implications (radio transmitter as USB sim controller, webcam/mic into WSL2 vs native).
- Recommend one concrete setup with install route, biased to the lazy option that actually works (beginner, few hrs/week).

Findings: [Shared research report](../../../docs/research/windows-dev-env.md), originally from branch `research/windows-dev-env` (commit `979e7a2`). Read its dated status note before applying the historical answer below.

## Answer

**WSL2 + Ubuntu 22.04. No dual-boot.**

- WSL2 hosts: SITL (PX4/ArduPilot) + Gazebo Harmonic + ROS 2 Humble. Both projects' official Windows dev paths *are* WSL2; WSLg provides GUI/OpenGL/mic on Windows 11 automatically.
- Native Windows hosts: FPV practice sims (Windows games; the radio is a USB joystick and never touches WSL), QGroundControl/Mission Planner, and the **biometric stack — WSLg has no webcam support, so face verification runs Windows-side**.
- Why not dual-boot: every needed piece has an officially supported Windows/WSL2 path; dual-boot adds partitioning risk for zero required capability and separates you from the FPV sims.
- Version pin: Ubuntu 22.04 + ROS 2 Humble + Gazebo Harmonic (PX4's recommended combo). Gazebo has no working Windows binaries, which alone kills a pure-native stack.
- USB: skip usbipd-win; when hardware arrives, flashing happens Windows-side via COM ports per both projects' docs.
- Caveats: Liftoff (FPV sim) officially requires a dedicated GPU — on a truly CPU-only machine the sim choice needs a hands-on check (feeds ticket 08); if PX4 moves its recommendation to Ubuntu 24.04/Jazzy, only the Ubuntu version changes.

## Comments

### 2026-08-30 — Shared research and current scope

The native-Windows/WSL2 split is retained, with WSL2/ROS installation explicitly deferred beyond milestone 1. Historical version pins are not an instruction to install them now. Confirmed scope is recorded in [Lock the milestone ladder](10-milestone-ladder.md#comments).

The original question and answer are retained as history. The report is now available in the main checkout with source provenance; consolidation did not revalidate its external claims or change this research ticket's resolved status.
