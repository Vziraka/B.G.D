# Research: Flight-controller firmware — PX4 vs ArduPilot (ticket 01)

> **Consolidation note — 2026-08-30**
> ArduPilot research retained; flight-controller hardware is reopened and must satisfy the confirmed all-arming authorization requirement.
> Source: `research/flight-stack`, commit `1410f679d894a6a13a238ffa36e14a2dc8b34a64`, file `docs/research/flight-stack.md`.
> Original report text is retained below, with line endings normalized; this consolidation did not revalidate its external claims. Current decisions: [Lock the milestone ladder](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md).
> Newer budget evidence: [lifetime budget rebaseline](lifetime-budget-rebaseline.md).

**Date:** 2026-08-06
**Method:** Primary sources only — official PX4 docs (docs.px4.io), official ArduPilot wiki (ardupilot.org), the ArduPilot and MAVROS GitHub repos. Every claim below links to the source that owns it. Unverified items are listed at the end.

## Recommendation

**Standardise on ArduPilot (ArduCopter), on an STM32 H7-class board.**

Top reasons, in order of weight for this project:

1. **Board economics.** ArduPilot supports well over 200 autopilot boards, including the cheap betaflight-style AIO boards actually used on 5-inch quads (SpeedyBee F4/F405, Matek F405, Kakute F4/H7, Mamba F405) ([ArduPilot: Autopilot Hardware Options](https://ardupilot.org/copter/docs/common-autopilots.html)). PX4's officially supported hardware centres on Pixhawk-standard and manufacturer-supported boards (Pixhawk 6X, CUAV, Holybro), which are larger and more expensive; cheap racing FCs get at best manufacturer/experimental-tier support ([PX4: Flight Controllers](https://docs.px4.io/main/en/flight_controller/)). On a $500–600 all-in budget, this is decisive.
2. **Later-milestone coverage is strictly broader.** ArduPilot has Precision **Loiter** as well as Precision Landing (companion computer + AprilTag → MAVLink `LANDING_TARGET`) ([ArduPilot: Precision Landing and Loiter](https://ardupilot.org/copter/docs/precision-landing-and-loiter.html)); PX4 implements precision *landing* only — no precision-loiter equivalent ([PX4: Precision Landing](https://docs.px4.io/main/en/advanced_features/precland.html)). Both have Follow modes (see below). ArduPilot additionally has onboard Lua scripting for custom behaviour without firmware forks ([ArduPilot: Lua Scripts](https://ardupilot.org/copter/docs/common-lua-scripts.html)).
3. **The companion path is incremental.** Milestone-2 features (voice-derived commands, follow-me triggers) need only MAVLink Guided-mode targets from a Raspberry Pi/Jetson — no ROS required on day one ([ArduPilot: Companion Computers](https://ardupilot.org/dev/docs/companion-computers.html), [Guided Mode](https://ardupilot.org/copter/docs/ac2_guidedmode.html)). ROS 2 via DDS is there when/if wanted ([ArduPilot: ROS 2](https://ardupilot.org/dev/docs/ros2.html)).

PX4 wins one axis cleanly: its ROS 2 integration (uXRCE-DDS bridging internal uORB topics straight into ROS 2) is deeper and more native than ArduPilot's. If this were a ROS-2-first research platform on Pixhawk-class hardware, PX4 would be the pick. It is not — it is a budget 5-inch self-build whose autonomy features are all reachable over plain MAVLink.

---

## Findings by criterion

### 1. Beginner documentation and community

- Both projects maintain full official documentation sites and official forums (discuss.ardupilot.org, discuss.px4.io). ArduPilot's wiki carries per-board setup pages across its very large hardware matrix ([common-autopilots](https://ardupilot.org/copter/docs/common-autopilots.html)); PX4's docs are organised around the Pixhawk-standard reference platform ([flight_controller](https://docs.px4.io/main/en/flight_controller/)).
- **Not quantitatively verified:** relative community size / answer quality. No primary source owns that claim; treat "ArduPilot has a bigger hobbyist community" as folklore until observed first-hand.
- Practical tilt for a first self-build: the FC you can afford for a 5-inch build will almost certainly be a board ArduPilot documents and PX4 does not.

### 2. Companion-computer integration

**PX4:**
- Two official channels: MAVLink, and uXRCE-DDS/ROS 2 over serial or Ethernet ([PX4: Companion Computers](https://docs.px4.io/main/en/companion_computer/)). MAVLink Router is the documented routing tool for fanning one vehicle link out to GCS + onboard apps; MAVProxy is the alternative (same page).
- uXRCE-DDS is the official ROS 2 middleware from PX4 v1.14 (replaced Fast-RTPS of v1.13). Client runs in firmware **by default**; the Micro XRCE-DDS Agent runs on the companion ([PX4: uXRCE-DDS](https://docs.px4.io/main/en/middleware/uxrce_dds.html), [PX4: ROS 2 User Guide](https://docs.px4.io/main/en/ros2/user_guide.html)).
- Caveat: from PX4 v1.16, uORB message *versioning* means a ROS 2 app built against different message definitions needs the Message Translation Node ([ROS 2 User Guide](https://docs.px4.io/main/en/ros2/user_guide.html)). Extra moving part for a novice.

**ArduPilot:**
- Companion integration is MAVLink-first: pymavlink, MAVSDK, DroneKit etc. on a Pi/Jetson ([Companion Computers](https://ardupilot.org/dev/docs/companion-computers.html)).
- ROS 2 is natively supported via **AP_DDS**, which also uses eProsima Micro XRCE-DDS client over serial or UDP, with topics (IMU, GPS, battery…) and services (arm, mode, takeoff) ([AP_DDS README](https://github.com/ArduPilot/ardupilot/blob/master/libraries/AP_DDS/README.md)).
- Caveats: DDS requires firmware ≥ 4.5 built with `--enable-DDS` (or the Custom Build Server option) — it is not in default builds — and the wiki states H7 boards support it while **F4/F7 lack the processing power** ([ROS 2 over Ethernet](https://ardupilot.org/dev/docs/ros2-over-ethernet.html)). ROS 2 Humble is the only supported ROS 2 version ([ROS 2](https://ardupilot.org/dev/docs/ros2.html)).

**Verdict on the inherited claim "uXRCE-DDS, never legacy MAVROS":**
- *Partially supported, PX4-specific, overstated.* For PX4 + ROS 2, uXRCE-DDS is indeed the official recommendation since v1.14, and PX4's ROS 1 docs are deprecated ([ROS 2 User Guide](https://docs.px4.io/main/en/ros2/user_guide.html)).
- But MAVROS is not dead: MAVROS 2.x targets ROS 2 (first ROS 2 release 2.0.0, 2021) and the repo remains maintained for both APM and PX4 ([mavros README](https://github.com/mavlink/mavros/blob/master/README.md)).
- And the claim does not transfer to ArduPilot, where MAVLink (not DDS) is the primary documented companion interface, and DDS is an opt-in custom build. What *is* correctly deprecated is **ROS 1**: ArduPilot's own docs say "ROS 1 is end-of-life in 2025" and recommend ROS 2 ([ArduPilot: ROS 1](https://ardupilot.org/dev/docs/ros1.html)).
- Project stance: use MAVLink for milestone 2; adopt DDS/ROS 2 (AP_DDS) only if a concrete need appears. Never ROS 1 — that part of the claim holds.

### 3. Later-milestone fit

| Capability | ArduPilot | PX4 |
|---|---|---|
| External command injection | Guided mode: MAVLink position/velocity/attitude targets, `GUID_TIMEOUT` safety hover ([Guided Mode](https://ardupilot.org/copter/docs/ac2_guidedmode.html)); plus onboard Lua scripting (needs 2 MB flash, not F4) ([Lua Scripts](https://ardupilot.org/copter/docs/common-lua-scripts.html)) | Offboard mode: MAVLink setpoints or ROS 2 topics; requires continuous ≥2 Hz setpoint stream as proof-of-life, failsafe on loss ([Offboard Mode](https://docs.px4.io/main/en/flight_modes/offboard.html)) |
| Follow-me | Follow mode: tracks `GLOBAL_POSITION_INT` or `FOLLOW_TARGET` from any publisher — a companion computer qualifies ([Follow Mode](https://ardupilot.org/copter/docs/follow-mode.html)) | Follow Me mode: `FOLLOW_TARGET` from QGC-on-Android or MAVSDK; docs warn of no obstacle avoidance and Android altitude bugs ([Follow Me](https://docs.px4.io/main/en/flight_modes_mc/follow_me.html)) |
| Precision loiter/landing | Both: Precision Landing **and** Precision Loiter via IR-LOCK or companion `LANDING_TARGET` (AprilTag etc.) ([Precision Landing and Loiter](https://ardupilot.org/copter/docs/precision-landing-and-loiter.html)) | Precision Landing only (IR-LOCK or `LANDING_TARGET`); "only possible with a valid global position"; no loiter equivalent ([Precision Landing](https://docs.px4.io/main/en/advanced_features/precland.html)) |
| Gimbal | Servo, SToRM32, SimpleBGC, Siyi, Gremsy, DJI RS2/RS3, MAVLink control from GCS/companion ([Cameras and Gimbals](https://ardupilot.org/copter/docs/common-cameras-and-gimbals.html)) | MAVLink Gimbal Protocol v2 (recommended), PWM, RC; PX4 acts as gimbal manager for GCS/companion commands ([Gimbal Configuration](https://docs.px4.io/main/en/advanced/gimbal_control.html)) |

Both stacks cover the roadmap; ArduPilot covers it with one extra mode (precision loiter — directly useful for a face-verification hover) and a scripting escape hatch.

Note the follow-me pattern for this project: "follow-me" from vision on the companion is really *the companion streaming Guided/Offboard targets*, which both stacks support; the built-in Follow modes are GPS-target-based.

### 4. Cheap / secondhand boards

- ArduPilot: 200+ boards; SpeedyBee F405, Matek F405 TE, Kakute F4/H7, Mamba F405 all documented. F4 boards omit features due to 1 MB flash (no Lua, no DDS) ([common-autopilots](https://ardupilot.org/copter/docs/common-autopilots.html), [Lua Scripts](https://ardupilot.org/copter/docs/common-lua-scripts.html)).
- PX4: Pixhawk-standard boards are the reference platform; support tiers are Pixhawk-standard > manufacturer-supported > experimental ([Flight Controllers](https://docs.px4.io/main/en/flight_controller/)).
- **Spec consequence:** buy an H743-based AIO or stack FC (Kakute H7, Matek H743-class, ~$60–90 new, common secondhand). It fits a 5-inch frame, keeps Lua and AP_DDS open for milestone 2+, and stays inside budget. An F405 board works for milestone 1 only and dead-ends the companion roadmap features that live in firmware.

### 5. SITL on Windows/WSL2

Effectively a tie — both officially recommend WSL2:

- ArduPilot: Windows 11 WSL2 is the documented dev path; you "build ArduPilot binaries and run the native ArduPilot SITL simulator, including MAVProxy" inside WSL2; Cygwin explicitly not recommended for new developers ([Setting up the Build Environment on Windows 11](https://ardupilot.org/dev/docs/building-setup-windows11.html), [Windows overview](https://ardupilot.org/dev/docs/building-setup-windows.html)).
- PX4: WSL2 setup "supported by the PX4 dev team"; Ubuntu 22.04/24.04, Gazebo works under WSL2 (GPU caveats); Windows QGroundControl needs manual UDP link to the WSL IP ([Windows Development Environment (WSL2)](https://docs.px4.io/main/en/dev_setup/dev_env_windows_wsl.html)).

## Decisions this implies

- Firmware: **ArduCopter, stable release ≥ 4.5**.
- FC: STM32 **H743-class** board from ArduPilot's supported list.
- Companion link (milestone 2): **MAVLink** over serial/UDP (pymavlink or MAVSDK); MAVLink Router/MAVProxy if multiple consumers need the stream.
- ROS 2 (optional, later): AP_DDS custom build + Micro XRCE-DDS agent, ROS 2 Humble. No ROS 1 under any circumstances.

## Could not verify

- Relative community size / responsiveness of the two forums — no primary source; anecdote only.
- ROS Noetic's exact EOL date from ros.org (site blocked fetches); ArduPilot's wiki statement "ROS 1 is end-of-life in 2025" is cited instead.
- Which ArduPilot release introduced Follow mode and precision landing (wiki pages don't date them; both are present in current stable, which is what matters here).
- Real-world PX4 behaviour on non-Pixhawk cheap boards — the docs only establish support *tiers*, not quality on specific budget boards.
