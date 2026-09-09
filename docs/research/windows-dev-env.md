# Research: Windows dev environment for SITL/Gazebo/ROS 2/biometrics/FPV (ticket 02)

> **Consolidation note — 2026-08-30**
> Environment split retained, but WSL2/ROS installation is deferred beyond milestone 1. Recheck version choices when installation is actually needed.
> Source: `research/windows-dev-env`, commit `979e7a299937da28dca376be5a14fce03fb93099`, file `docs/research/windows-dev-env.md`.
> Original report text is retained below, with line endings normalized; this consolidation did not revalidate its external claims. Current decisions: [Lock the milestone ladder](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md).

Date: 2026-08-06. Sources: official PX4, ArduPilot, ROS, Gazebo, Microsoft docs (URLs inline).

## Recommendation (TL;DR)

**WSL2 + Ubuntu 22.04. No dual-boot.** Native Windows hosts only the things that are
already Windows-native: FPV practice sims, the ground control station (QGroundControl /
Mission Planner), and the Python biometric stack (webcam/mic access is trivial there and
broken-to-painful inside WSL).

Dual-boot buys nothing a beginner needs: PX4 explicitly supports Windows *via WSL2* as a
first-class dev platform, ArduPilot's Windows setup guide *is* the WSL2 guide, and WSLg
gives GUI (Gazebo) support out of the box on Windows 11. Dual-boot costs are real for a
novice (partitioning, boot repair risk, rebooting away from your FPV sims and daily
environment) and the payoff is only raw sim performance you don't need for a hobby SITL.

## Where each piece runs

| Piece | Runs in | Why |
|---|---|---|
| PX4 or ArduPilot SITL + Gazebo | WSL2 Ubuntu 22.04 | Official supported path on Windows; no native toolchain |
| ROS 2 (Humble) | WSL2 Ubuntu 22.04 | Windows is Tier 1 for ROS core, but Gazebo + PX4/ArduPilot tooling are not — keep the whole robot stack in one Ubuntu |
| Gazebo (Harmonic) | WSL2 Ubuntu 22.04 (via WSLg) | Gazebo has no working Windows binaries |
| QGroundControl / Mission Planner | Native Windows | Windows builds are official; WSL QGC cannot flash firmware |
| Firmware flashing (later, real hardware) | Native Windows side | PX4/ArduPilot both route uploads through Windows Python/COM ports; usbipd bootloader access is unreliable |
| FPV practice sims (Liftoff, VelociDrone, etc.) | Native Windows | They are Windows games; radio plugs in as a USB joystick, zero WSL involvement |
| Biometric stack (face + voice, Python, CPU) | Native Windows Python | Webcam has no WSLg support path; mic exists in WSLg but native is simpler and both are needed |

## Evidence

### SITL + Gazebo under WSL2 is the official Windows path

- PX4 lists supported dev platforms as "Ubuntu Linux (24.04/22.04), Windows (10/11) —
  via WSL2, macOS". There is no native-Windows toolchain.
  <https://docs.px4.io/main/en/dev_setup/dev_env.html>
- PX4's WSL2 guide: "This setup is supported by the PX4 dev team. The environment should
  in theory be able to build any target that can be built on Ubuntu" — Gazebo and Gazebo
  Classic sim targets included. It recommends recent GPU drivers plus the kisak-mesa PPA
  in Ubuntu "so that most OpenGL features get emulated" for sim rendering.
  <https://docs.px4.io/main/en/dev_setup/dev_env_windows_wsl.html>
- ArduPilot's Windows 10/11 setup guide is WSL2-based: "WSL2 ... is many times faster
  than WSL1 and is therefore preferred". SITL + MAVProxy run inside it; on Windows 11
  GUI support is automatic (WSLg), Windows 10 needs a third-party X server.
  <https://ardupilot.org/dev/docs/building-setup-windows10_new.html>
- Both projects warn: keep the repo inside the WSL filesystem (`~/...`), not `/mnt/c/...`,
  or builds get very slow (same two URLs above).
- WSLg (built into Windows 11 / current WSL) provides X11+Wayland GUI apps, GPU-accelerated
  OpenGL via Mesa/D3D12, audio out, and audio in (microphone).
  <https://github.com/microsoft/wslg>

Verdict: acceptable, and officially supported. Dual-boot is only "materially better" if
you need max sim frame rates or native USB — neither applies to a few-hours-a-week
CPU-only SITL workflow.

### ROS 2 + Gazebo versions

- ROS 2 tier 1 platforms (REP 2000): Ubuntu 24.04 for Jazzy/Kilted; Windows 10 is also
  Tier 1 *for ROS core* — but that doesn't carry the simulation stack.
  <https://www.ros.org/reps/rep-2000.html>
- PX4: "The supported and recommended ROS 2 platform for working with PX4 is ROS 2
  'Humble' LTS on Ubuntu 22.04", paired with Gazebo Harmonic.
  <https://docs.px4.io/main/en/ros2/user_guide.html>
- Gazebo on Windows: "Support via Conda-Forge is not fully functional, as there are known
  runtime issues" — no supported Windows binaries; Ubuntu is the recommended platform
  (Harmonic on 22.04, Jetty on 24.04).
  <https://gazebosim.org/docs/latest/getstarted/>

So the version pin that keeps everything on one official page: **Ubuntu 22.04 + ROS 2
Humble + Gazebo Harmonic**, inside WSL2.

### FPV practice sims: separate concern, native Windows

FPV sims are consumer games, not part of the SITL toolchain. Example: Liftoff (Steam)
supports Windows/macOS/Linux, is "Only playable with a game or radio controller", and
wants a dedicated GPU (4 GB VRAM min).
<https://store.steampowered.com/app/410340/Liftoff_FPV_Drone_Racing/>

Your radio transmitter (e.g. any radio with a USB "joystick"/HID mode) plugs straight
into Windows and appears as a game controller — no usbipd, no WSL. On a CPU-only machine
Liftoff may not run (dedicated-GPU requirement); pick a lighter sim — see unverified
notes below.

### USB device access

- WSL2 has **no native USB support**: "Support for connecting USB devices is not natively
  available in WSL" — the workaround is usbipd-win (admin install, `usbipd bind` /
  `usbipd attach --wsl`), and while attached the device is unavailable to Windows.
  <https://learn.microsoft.com/en-us/windows/wsl/connect-usb>
- ArduPilot on usbipd for flashing: "Microsoft's solution of providing USB access to WSL2
  via usbipd does not work for accessing the bootloader on the device due to slow
  mounting times" — instead install Python + pyserial + empy on the *Windows* side and
  upload via COM ports. <https://ardupilot.org/dev/docs/building-setup-windows10_new.html>
- PX4 similarly: from v1.18 `make ... upload` inside WSL drives the Windows Python
  interpreter to reach COM ports; the WSL build of QGroundControl "cannot flash firmware"
  — use Windows QGC for that. <https://docs.px4.io/main/en/dev_setup/dev_env_windows_wsl.html>
- Webcam: WSLg's feature list includes GUI, GPU rendering, audio out and audio in
  (microphone) — **no camera/video-capture support is listed**.
  <https://github.com/microsoft/wslg>
  Practical consequence: run anything needing the webcam (face verification) in native
  Windows Python.
- Radio-as-sim-controller: consumed by native Windows games, so it never touches WSL.

## Concrete install route (the lazy path)

All in an admin PowerShell unless noted:

1. `wsl --install -d Ubuntu-22.04` then reboot. (Windows 11 gives you WSLg GUI support
   automatically. <https://learn.microsoft.com/en-us/windows/wsl/install>)
2. Inside Ubuntu, clone into the WSL filesystem (`~/`), then ONE of:
   - **ArduPilot** (recommended for a first pass — simplest single-script setup):
     follow <https://ardupilot.org/dev/docs/building-setup-linux.html> —
     `git clone --recurse-submodules https://github.com/ArduPilot/ardupilot.git` and run
     `Tools/environment_install/install-prereqs-ubuntu.sh -y`, then `sim_vehicle.py`.
   - **PX4**: follow <https://docs.px4.io/main/en/dev_setup/dev_env_windows_wsl.html> —
     clone PX4-Autopilot, run `Tools/setup/ubuntu.sh`, then `make px4_sitl gz_x500`.
3. ROS 2 Humble in the same Ubuntu, from the official apt repo:
   <https://docs.ros.org/en/humble/Installation/Ubuntu-Install-Debs.html> (site is
   bot-gated to automated fetchers but fine in a browser).
4. QGroundControl (PX4) or Mission Planner (ArduPilot) installed on **Windows**; it
   auto-connects to SITL over localhost UDP.
5. Biometric stack: plain Windows Python 3.x venv, CPU wheels (e.g. opencv-python +
   a face lib, speechbrain/resemblyzer for voice). Webcam and mic just work.
6. FPV sim on Windows/Steam; radio in USB joystick mode.

Skip usbipd-win entirely until you have physical hardware, and even then prefer the
Windows-side flashing route both projects document.

## What I could not verify (primary sources unavailable or silent)

- `docs.ros.org` and `www.ros.org` block automated fetching (Anubis bot-gate); REP 2000
  content was verified from the canonical source repo
  (<https://raw.githubusercontent.com/ros-infrastructure/rep/master/rep-2000.rst>).
- VelociDrone's system requirements page couldn't be fetched — its suitability for a
  CPU-only/iGPU machine is unconfirmed. Liftoff's official requirements say Intel
  integrated graphics are NOT supported, so if the machine truly has no dGPU, verify a
  lightweight sim (VelociDrone low settings, or FPV Freerider) by hand before buying.
- Webcam-over-usbipd into WSL2: Microsoft's usbipd doc doesn't cover webcams; community
  reports say it needs a custom WSL kernel with UVC drivers. Not verified against a
  primary source — treated as "assume it doesn't work" and routed the biometric stack to
  native Windows instead.
- Whether PX4's ROS 2 page has been updated for Jazzy/24.04: as fetched today it still
  recommends Humble/22.04; if it later moves to Jazzy/24.04, swap `Ubuntu-22.04` for
  `Ubuntu-24.04` in step 1 — nothing else about this recommendation changes.
