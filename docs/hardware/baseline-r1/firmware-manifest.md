# Baseline R1 firmware, configuration and pin manifest

Date: 2026-09-03. Scope: Q75-approved hardware architecture; implementation design only. No flashing, installation, device provisioning, motor operation or purchase performed. The machine-readable companion is [firmware-manifest.json](firmware-manifest.json); every allocated pin is in [pin-allocation.csv](pin-allocation.csv).

## Release disposition

The upstream flight firmware and hardware resources are pinned. **This is not a flash-and-fly parameter file, an approved operational binary, or an as-built configuration.** The approved all-arming authorization requirement needs a mandatory FC software gate: the stock release's Lua auxiliary authorization and MAVLink signing do not supply it. That is a source-demonstrated software integration gap, not a reason to change the selected FC, radio or compute hardware. Production software implementation and its tests remain future work.

This manifest distinguishes three things:

- **Design-fixed:** hardware target, pin allocation, protocol, intended motor wiring, documented sensor address and documentary initial parameters.
- **Implementation-dependent:** the mandatory authorization/release modules, their reviewed binary hashes, configured radio images, application dependencies and signed/provisioned secrets. These require software work, not aircraft flight measurements.
- **As-built:** device revisions/readbacks, axes, calibration, PWM endpoints, actual reserve thresholds, motor tuning, radio failsafes and measured sensor transforms. Their explicit acceptance records must be completed at commissioning; invented numerical values are forbidden.

## Frozen reference artifacts

| Artifact | Identity and SHA-256 | Allowed use / limitation |
| --- | --- | --- |
| ArduCopter `MicoAir743v2` `.apj` | 4.7.1 official; commit `dbe792162d06cab66c3475fd5556bf7a120f119e`; `5d4a1afd080ceeaa84ee61421e3d6bdd82724325d99f04acd65dd21dd0e0f670` | Upstream reference and later unpowered recovery/commissioning base; not a complete B.G.D operational gate. Downloaded and locally hashed, 1,281,772 bytes. |
| Same release `arducopter_with_bl.hex` | `c017bff8c34edf73af38f19b6f6ac7ed3c5fa04e985881e70d4ed6d40e19201e` | Separately identified recovery image including bootloader, 4,303,148 bytes; never an automatic bootloader-overwrite instruction. Received bootloader identity/backup required first. |
| Exact source `hwdef.dat` | `e456ad6f8647071d316d6ba73eb418027e04d9528c24872cd9da8740d7d98732` | Pin/port source at the same commit, not moving `master`. |
| Release `features.txt` | `924ae19d313f3ed30fb232af8d61e8260db68807db7db0dad67e1b124edc4cc7` | Includes INA2XX, IST8310, CRSF, TFmini serial, servo mount, scripting and signing; support does not prove enforcement or performance. |
| AM32 AIO factory identity | Manufacturer specifies `AM32_F4A_4IN1_F421_2.19`, 48kHz switching | Do not substitute a generic AM32 image. Read all four installed target/version/configuration records and archive readbacks before any change. Factory binary hash is not available from the board until receipt; no claim of a hashed AM32 release here. |
| Raspberry Pi OS Lite 64-bit reference | `2026-06-18-raspios-trixie-arm64-lite.img.xz`; publisher SHA-256 `acff736ca7945e3b305f07cda4abdb870910e12634991da69783611756e381b3` | Dated official base for future Pi4 bring-up. Publisher checksum fetched; large image **not** downloaded/locally hashed. This is not a frozen application image or model-runtime qualification. |
| EdgeTX Pocket reference | 2.12.4 `pocket-def35ad.bin`, 519,580 bytes; `8e863307a61815588e2c6ffa68d2e0156b5481c9d2e03826afa65f9c47c357a4` | Extracted and hashed from official firmware archive; archive SHA-256 `cea098f12ac2710b3611a5bd9eff2ef73a35396c1aba0b433aff1fa3d339875b`. Confirm received Pocket board target before future installation; preserve its model/firmware backup. |
| ExpressLRS reference | 4.1.0 source commit `a9d4a9cb5b5687c4c9d7e9e7fbdf44ad93651da6`; targets revision `c4bd7b823594c233e673828ab493a2f8319a756a` | Pocket internal TX: `Unified_ESP32_2400_TX`, RadioMaster Pocket layout. RP1 RX: `Unified_ESP8285_2400_RX`, RadioMaster RP1 layout. Target matching, lawful regulatory domain, paired UID/model ID and the generated exact image hashes must be archived at provisioning. An upstream version is not a device-specific binary. |
| D500, TFmini-S, M10, M6AC | Retain manufacturer firmware until identification/readback | Record reported device version/configuration and tool version; no speculative updates. Sensor protocol selection below is fixed. Charger firmware is identified during ground-equipment receipt, never presumed from the product name. |

Source and download URLs, checksum provenance and byte sizes are carried in JSON. Moving `stable` URLs are retrieval locations, not immutable identities: reject a changed hash. Reproducing from the pinned source is a new artifact and must receive its own build/toolchain/dependency and binary hashes. Downloaded reference artifacts were examined in an OS temporary working directory; this package does not claim to be an offline firmware archive.

## Important differences from generic board defaults

The AIO shares the `MicoAir743v2` target with a different full-size board. The target defines UART7, PWM9/10 and an analog OSD resource which this AIO does not expose or fit. **Do not connect to a nonexistent UART7 or PWM9/10.** Disable unused serial and OSD functions; do not mistake compile-time resources for connectors.

The target's default onboard current factor is 40.2, whereas the AIO manufacturer specifies 14.14. Neither measures accessory branches upstream of the AIO. The upstream INA-BM is the primary whole-pack sensor; use its documented shunt/range and later calibrate it. Do not inherit the board's analog default as total battery consumption.

ArduCopter 4.7.1 uses **`ARMING_SKIPCHK=0`** to retain all normal checks. Legacy `ARMING_CHECK=1` is not the current setting. Rangefinder limits are **`RNGFND1_MIN`, `RNGFND1_MAX`, `RNGFND1_GNDCLR` in metres**, not old `*_CM` names. MAVLink channel policy is in `MAVx_OPTIONS`; it is not a `SERIALx_OPTIONS` signing flag.

## Design-fixed FC configuration

These values describe the intended build. They may be entered only as part of authorized props-off commissioning; nothing in this table authorizes arming or waives the release holds.

| Parameter / resource | Design value | Reason and validation boundary |
| --- | --- | --- |
| `FRAME_CLASS` | `1` Quad | Four selected motors. |
| `FRAME_TYPE` | `1` X | Deliberately use the explicit wiring map below; override target default `12` Betaflight X. Deadcat geometry does not prove equal-arm mixing optimal: verify individual loading/control and tune against actual CG. |
| `AHRS_ORIENTATION` | Intended `0` | Manufacturer arrow aligned with aircraft forward `+s`, component side up. The 45° mechanical edge/hole rotation is **not** automatically a 45° attitude parameter. Mounted roll/pitch/yaw proof required; do not stack another internal IMU rotation onto the hwdef. |
| `MOT_PWM_TYPE` | `5` DShot300 | Maker's recommended initial protocol. TIM1 only for motors; no analog ESC endpoint calibration. Motor output arming/spin/tuning still held. |
| `SERVO1_FUNCTION` / `2` / `3` / `4` | `33` / `34` / `35` / `36` | Motor1–Motor4 with intentional wiring below. |
| `SERIAL1_PROTOCOL`, `_BAUD`, `_OPTIONS` | `2`, `115`, `0` | MAVLink2, 115200, full-duplex uninverted UART to Pi. This is a control/telemetry stream, not video transport. Later measured bandwidth can justify a baud-only revision; current use does not claim navigation throughput. |
| `SERIAL3_PROTOCOL`, `_BAUD`, `_OPTIONS` | `5`, `115`, `0` | GNSS, 115200, full-duplex uninverted UBX link. GPS auto-configuration can alter receiver settings; archive resulting receiver and FC readback. |
| `SERIAL4_PROTOCOL`, `_BAUD`, `_OPTIONS` | `9`, `115`, `0` | TFmini serial, 115200. FC TX4 is available for supported setup commands; continuous measurement arrives on RX4. |
| `SERIAL6_PROTOCOL`, `_OPTIONS` | `23`, `0` | RCIN, full-duplex uninverted CRSF. CRSF backend selects baud, not a guessed `SERIAL6_BAUD`. |
| `RC_PROTOCOLS` | `512` | CRSF-only protocol recognition (bit9). |
| `RC_OPTIONS` | `8226` | Bit13 420k ELRS, bit5 throttle-zero arm check, bit1 ignore MAVLink RC overrides. Phone/companion commands use the reviewed command interface, not an RC override bypass. Receiver and in-flight priority/failsafe behavior still require proof. |
| `SERIAL2_PROTOCOL`, `SERIAL5_PROTOCOL`, `SERIAL8_PROTOCOL` | `-1` each | Unused exposed ports disabled. |
| `SERIAL7_PROTOCOL` | `-1` | Target-internal resource, no exposed AIO UART7. |
| `OSD_TYPE` | `0` | No analog OSD or selected MSP-display device. |
| `BATT_MONITOR` | `21` | INA2XX whole-pack monitor, not board analog sensor. |
| `BATT_I2C_BUS` | `1` | External physical I2C1 is **logical bus1**: `I2C_ORDER I2C2 I2C1`. Internal SPL06 occupies logical bus0. |
| `BATT_I2C_ADDR` | `69` (`0x45`) | INA-BM factory address; verify straps/device revision. |
| `BATT_SHUNT` | `0.0002` ohm | Matek's 200µΩ shunt. |
| `BATT_MAX_AMPS` | `204.8` A | Documented sensor measurement range, **not** allowed flight current or fuse rating. |
| `RNGFND1_TYPE`, `RNGFND1_ORIENT` | `20`, `25` | Benewake serial, downward. Ground clearance and usable bounds require measurements. |
| `MNT1_TYPE` | Intended `1` Servo | Activate only after servo-current and safe-travel commissioning. |
| `SERVO5_FUNCTION`, `SERVO6_FUNCTION` | Intended `6`, `7` | Pan and tilt on TIM3, **through U1 SN74AHCT125N**: M5→U1.9→U1.8→pan; M6→U1.12→U1.11→tilt. Inputs are 3.3V, outputs are peripheral5V; no direct 3.3V servo recognition is assumed. Servo electrical speed/frame-rate and safe endpoints are commissioning fields; do not apply motor DShot to this timer. |
| PWM7 / `SERVO7_FUNCTION` | Reserved solely to FC release supervisor | TIM4 ordinary RC pulses **M7→U1.5→U1.6→Pololu #2802**, translated 3.3V→peripheral5V. Design signal is 50Hz, 1000µs OFF and 2000µs ON, conditional on confirming the maker's default non-inverted threshold. Production function ownership and code hash are an implementation hold: no RC passthrough, generic gripper command or unrestricted `DO_SET_SERVO` route may bypass the release policy. A stock scripting-function assignment alone would not satisfy it. |
| PWM8, PWM11 | Unconnected/reserved; no serial LED configuration | Same TIM4 group as PWM7. Visible lighting is on the Pi. |
| `ARMING_SKIPCHK` | `0` | Do not skip normal pre-arm checks; cannot replace mandatory B.G.D gate. |

No executable `.param` file is supplied: manufacturing/commissioning must not accidentally load incomplete tuning, battery failsafes or release control from a design table. The later complete readback must include **all** parameters, compared to this manifest and archived with a hash.

## Motor wiring and orientation contract

Looking down on the aircraft, front is `+s`, right is `+r`. Rotation is seen from above. `M1`–`M4` below are the maker's **motor-output labels**, not the tiny numbered mounting-hole silkscreen. Motor phase leads are intentionally routed from those outputs to these positions; do not infer motor identity from the nearest corner.

| Logical motor / AIO output | Installed motor centre `(s,r)` mm | Rotation | ArduPilot X motor-test order |
| --- | --- | --- | --- |
| Motor1 / M1, PE14 TIM1_CH4 | `(58.104,+145.223)` front right | CCW | A / first |
| Motor2 / M2, PE13 TIM1_CH3 | `(-123.357,-96.170)` rear left | CCW | C / third |
| Motor3 / M3, PE11 TIM1_CH2 | `(58.104,-145.223)` front left | CW | D / fourth |
| Motor4 / M4, PE9 TIM1_CH1 | `(-123.357,+96.170)` rear right | CW | B / second |

The pattern comes from the pinned X-mixer source, not from a presumed factory wiring arrangement. Record a photograph, output-to-arm continuity map, props-off one-at-a-time test and rotation result. Install the appropriately handed APC prop only after both motor identity and direction pass; an AHRS orientation setting does not remap motors. Actual deadcat/CG coupling remains the approved control-authority test, not a proven symmetric-X dynamic model.

## Pi and sensor resource contract

- J8 GPIO14/TXD0 pin8 → FC RX1/PA10; GPIO15/RXD0 pin10 ← FC TX1/PA9. Shared signal ground; no 5V on data. Set `enable_uart=1`, `dtoverlay=disable-bt`; disable the Bluetooth UART service and serial console/getty. This dedicates PL011 to `/dev/serial0` on Pi4 without relying on the clock-sensitive mini-UART. Verify `/dev/serial0` resolves to the expected device. Bluetooth is unused; local Wi-Fi remains available.
- J8 GPIO18 pin12 is the single NeoPixel data source: **GPIO18→U1.2→U1.3→330Ω→first lamp DIN**. U1 is the selected SN74AHCT125N; all four channels are allocated (the other three translate FC pan, tilt and release). Pin14 receives only peripheral5V, pin7 ground; all four active-low OE pins are grounded and every input has its own 10kΩ ground pull-down. U1's peripheral supply must not join the carrier's compute5V rail. No translated 5V output enters the Pi or FC. Independent-rail startup, shutdown and backfeed testing remains required. No conflicting audio/PWM driver owns GPIO18. The LED process starts black, but addressable pixels may retain their last color after a crash; neither lighting nor buffer behavior grants arming/release permission. Full connections are controlled by [the netlist](harness-netlist.csv).
- J8 GPIO23 pin16 receives holder-closed; GPIO24 pin18 receives latch-engaged. Each has its own external 4.7kΩ pull-up to Pi3.3V. Switch COM returns to ground, **NO** closes only when the cam positively reaches the safe position; NC is unused and insulated. `0` means contact closed, `1` means open/unsafe. This catches an open wire, not a short to ground or every stuck contact; plausibility/transition checks and fault tests remain mandatory. No peripheral 5V enters a GPIO.
- Compute5.2V feeds J8 pins2 and4 via the designed carrier; use at least two independent ground pins. Fan receives compute rail directly. No USB-C power input is simultaneously connected; USB data-service arrangements must prevent backfeed.
- Camera3 uses the **CSI camera** connector and selected 15-pin cable, not DSI. Enable camera auto-detection; use the supported libcamera/rpicam stack in the future dated application image. Exact application package/model hashes and image/pan transforms come from implementation and tests.
- D500 kit connects to one USB host port using its kit adapter. Bind a persistent device identity at commissioning instead of relying on transient `/dev/ttyUSB0`; raw device UART is 230400, while the FC link is separate. The Pi alone owns that scanner port.
- External I2C1 is FC PB8/SCL and PB9/SDA. INA-BM is `0x45`; IST8310 is `0x0E`; internal SPL06 is `0x77` on physical I2C2/logical bus0. No Pi I2C is tied to the FC bus. Verify pull-up voltage, discovery, sensor rotation and interference under load.

## Non-bypassable authorization: required affected software work

The pinned `AP_Arming` source runs auxiliary authorization during ordinary pre-arm checks; a force-arm path runs mandatory checks instead, which do not include auxiliary authorization. The registered-authorizer count also starts at zero, and an auxiliary pass does not contain a built-in action expiry. Thus an unstarted, stopped or stale Lua gate is not an acceptable basis for the all-arming claim. `SCR_LD_CHECKSUM`/`SCR_RUN_CHECKSUM` are useful future integrity checks, but do not turn this optional path into mandatory authorization.

The later FC implementation must deny by default from startup, require a fresh aircraft/boot/request/action-bound owner grant before **every** disarmed→armed transition, consume it atomically once, and cover RC, MAVLink, forced-arm, scripts, automatic/mode and service paths. Normal flight-safety checks remain additive. If authorization becomes unavailable while already airborne, deny future grants; do not cut motors or obstruct independent emergency control/safe landing. The FC release supervisor similarly owns PWM7 and permits a bounded pulse only under the approved landed/disarmed/recipient/holder conditions, with a timeout that survives companion failure. Both must be validated in source review and simulated/bench negative tests before any corresponding operational capability is enabled.

MAVLink signing authenticates message provenance, not a successful owner check. The stock release accepts unsigned traffic on MAVLink channel0, assumed USB, and permits listed radio-status exceptions. Key presence, nonzero material, correct channel policy and lack of unsigned action routes must be tested; do not describe it as universally rejecting unsigned messages. Provision 32-byte keys only through a controlled landed/disarmed service path; never store secrets in this repository or send them to hosted builds. Final FC gate must reject unauthorized arming even over USB and after parameter/reset/force-command attempts. Physical reflash resistance is a separate threat-model claim, not supplied by MAVLink signing.

## Explicit commissioning and implementation fields

| Field not presently executable/final | Owner/evidence needed | Why it is not an unresolved requirement |
| --- | --- | --- |
| Production FC gate, release-supervisor binary, protocol and state-machine hashes | Firmware implementation, mandatory-path source review, negative SITL/bench tests | Requirements and allocated interfaces are fixed; no code has been implemented. Stock firmware gap is documented above. |
| Freshness lifetimes, heartbeat-loss deadline, release pulse duration, switch debounce | Safety implementation specification plus measured solenoid/switch response; conservative fail-closed defaults before activation | Do not borrow desk-phase ten/sixty-second biometric timing as aircraft authorization lifetimes. No flight enabled until reviewed values exist. |
| Signing/link identity, RC UID, Wi-Fi credentials, generated ELRS image hashes | Private provisioning and versioned non-secret audit metadata | Values are deliberately per-aircraft/per-owner, not shared public constants. |
| Board/compass orientation, accel/gyro/compass calibration, sensor offsets | Received installation, six-face/axis and interference checks | The design datum is fixed; calibration belongs to the actual unit. |
| Radio channel mapping, throws, mode switches, takeover, RC/GCS/link failsafes | Actual Pocket model export, receiver and FC readbacks, fault matrix | No silent default mode or stale RC preset is operationally approved. |
| Motor direction, DShot/AM32 readbacks, idle/spin, thrust expo, filters, rate/attitude gains | Props-off identification, test stand and controlled commissioning | Manufacturer support cannot predict fitted dynamics. |
| Battery usable capacity, current/voltage calibration, sag, recovery reserve and failsafe values | Meter/known-load checks, each released pack's Q74 energy evidence | Nominal 10Ah/6S and the modeled endpoint are not measured safe trip thresholds. Q74 stays mandatory. |
| Servo trim/min/max/reverse, frame rate, mount angular limits; verification of solenoid command thresholds | Safe mechanism travel and current tests with hardware stops; confirm #2802 defaults against the fixed 50Hz/1000µs OFF/2000µs ON design | Do not use full servo travel or a generic RC centre as a cargo-release command. The coil energization duration is separate from the RC pulse width and remains a measured safety limit. |
| Rangefinder min/max/ground clearance, navigation sensor transforms/latency | Measured surface/environment/mount geometry and workload | Nominal 12m range is not a guaranteed avoidance or landing envelope. |
| Pi application/ML/driver lockfile, final OS-image hash, telemetry bandwidth and watchdogs | Future software build and load/thermal/latency/security tests | Dated OS reference is reproducible setup input, not complete runtime qualification. |
| As-received firmware/bootloader identity and rollback bundle for every programmed unit | Device inventory/readback, original settings/backups and restore test | Such evidence cannot exist before receiving the exact unit. Never replace unknown firmware by guess. |

## Primary evidence

- [Exact ArduPilot board definition](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/AP_HAL_ChibiOS/hwdef/MicoAir743v2/hwdef.dat), [release artifacts](https://firmware.ardupilot.org/Copter/stable/MicoAir743v2/) and [Mico AIO manufacturer manual/pinout](https://micoair.cn/zh/docs/flight-controller/micoair743-aio-series/micoair743v2-aio-45a-manual).
- [Serial parameters](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/AP_SerialManager/AP_SerialManager.cpp), [RC options](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/RC_Channel/RC_Channels_VarInfo.h), [CRSF baud selection](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/AP_RCProtocol/AP_RCProtocol_CRSF.h).
- [X mixer](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/AP_Motors/AP_MotorsMatrix.cpp), [motor protocol enums](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/AP_Motors/AP_MotorsMulticopter.cpp), [servo functions](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/SRV_Channel/SRV_Channel.h), [mount type](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/AP_Mount/AP_Mount_Params.cpp).
- [INA driver parameters](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/AP_BattMonitor/AP_BattMonitor_INA2xx.cpp), [Matek INA-BM specifications](https://www.mateksys.com/?portfolio=i2c-ina-bm), [rangefinder parameters](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/AP_RangeFinder/AP_RangeFinder_Params.cpp), [Benewake serial setup](https://ardupilot.org/copter/docs/common-benewake-tfmini-lidar.html).
- [Arming paths](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/AP_Arming/AP_Arming.cpp), [Copter arm entry](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/ArduCopter/AP_Arming_Copter.cpp), [MAVLink arm handler](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/GCS_MAVLink/GCS_Common.cpp), [signing exceptions](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/GCS_MAVLink/GCS_Signing.cpp), [channel options](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/GCS_MAVLink/GCS_MAVLink_Parameters.cpp), [script integrity parameters](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/AP_Scripting/AP_Scripting.cpp).
- [Pi UART configuration](https://www.raspberrypi.com/documentation/computers/configuration.html#configuring-uarts), [Pi dated image/checksum](https://downloads.raspberrypi.com/raspios_lite_arm64/images/raspios_lite_arm64-2026-06-19/), [EdgeTX release](https://github.com/EdgeTX/edgetx/releases/tag/v2.12.4), [ELRS release](https://github.com/ExpressLRS/ExpressLRS/releases/tag/4.1.0), [exact ELRS targets](https://github.com/ExpressLRS/targets/blob/c4bd7b823594c233e673828ab493a2f8319a756a/targets.json).
- [TI SN74AHCT125 pinout and thresholds](https://www.ti.com/lit/ds/symlink/sn74ahct125.pdf), [Pololu RC switch guide](https://www.pololu.com/docs/0J60/all): electrical translation and nominal RC command behavior; not proof of safety-policy enforcement.

Prepared in the shared uncommitted checkout. The source/hash work is documentary verification only; final hardware acceptance and all Q73/Q74 gates remain pending.
