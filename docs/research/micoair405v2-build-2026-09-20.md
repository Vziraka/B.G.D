# MicoAir405v2 firmware fit and handoff — 2026-09-20

## Decision and scope

**Research fallback, not the selected purchase.** The final basket retained MicoAir743-Lite after other savings brought its provisional delivered estimate within the cap. The H7 uses native firmware and includes a card; the F405 requires a separately budgeted microSD and maintenance of this custom configuration. Preserve this evidence if the final checkout requires reconsideration.

The $59.99 MicoAir405v2 + 50A Bluejay stack is a credible budget candidate **with this custom firmware**, not the standard reduced-feature image. A clean-source compile demonstrates that the required backends fit. It does not demonstrate physical sensor operation, scheduling margin under load, or flight readiness. Validate those during integration before flight.

The Pi owns visual following and sends normal GUIDED commands. ArduPilot Follow mode and Lua are not requirements of that architecture. This build retains normal GUIDED, EKF3, GPS, optical-flow positioning, MSP flow/range, MAVLink proximity and visual odometry. It disables analog OSD and MSP DisplayPort, which this camera/Pi system does not use. Other upstream low-flash reductions remain, including no onboard Follow, no GUIDED_NOGPS attitude-only mode and no onboard obstacle path planner. Do not describe it as equivalent to every H7 feature.

## Source and artifact

- Upstream repository: https://github.com/ArduPilot/ardupilot
- Source tag: `Copter-4.7.1`
- Exact commit: `dbe792162d06cab66c3475fd5556bf7a120f119e`
- Target: `MicoAir405v2`
- Artifact: [micoair405v2-4.7.1-bgd.apj](../../electronics/firmware/micoair405v2-4.7.1-bgd.apj)
- SHA256: `c6c73c03456f75daf2071828a761110b86018d59cf580b36ea8f3e8a0711478e`
- Local build worktree: `/home/zvent/bgd-flywoo-471` in WSL Ubuntu. Its name reflects an earlier independent board investigation; this artifact targets MicoAir405v2. Only the target-specific change below affects this build.
- Build log: `/home/zvent/bgd-mico405-build.log`
- Extracted feature evidence: `/home/zvent/bgd-mico405-features.txt`

The source checkout has recursively initialized submodules pinned by the commit. Existing `/home/zvent/ardupilot` project modifications were not used or altered. This `.apj` is an update artifact; initial bootloader installation is a separate manufacturer/ArduPilot DFU procedure if the delivered board lacks an appropriate ArduPilot bootloader. Do not flash a different board target.

## Exact configuration change

Append the following to `libraries/AP_HAL_ChibiOS/hwdef/MicoAir405v2/hwdef.dat` after its existing `undef AP_OPTICALFLOW_ENABLED` line:

```text
# BGD fit experiment: required sensors, no video overlay
undef OSD_ENABLED
define OSD_ENABLED 0
undef HAL_OSD_TYPE_DEFAULT
define HAL_OSD_TYPE_DEFAULT 0
define HAL_WITH_MSP_DISPLAYPORT 0
define HAL_MSP_ENABLED 1
define HAL_MSP_SENSORS_ENABLED 1
define HAL_MSP_OPTICALFLOW_ENABLED 1
define HAL_MSP_RANGEFINDER_ENABLED 1
define HAL_PROXIMITY_ENABLED 1
define AP_PROXIMITY_BACKEND_DEFAULT_ENABLED 0
define AP_PROXIMITY_MAV_ENABLED 1
define HAL_VISUALODOM_ENABLED 1
```

No flight-control source modifications are required. The original BMI088 IMU and SPL06 barometer definitions remain unchanged. [Pinned hardware definition](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/AP_HAL_ChibiOS/hwdef/MicoAir405v2/hwdef.dat).

## Reproduction and measured result

In a clean checkout at the commit above, initialize recursive submodules, apply the target change, and use the existing WSL toolchain/environment:

```sh
git submodule update --init --recursive
export PATH=/home/zvent/issue11-rc-toolchain/gcc-arm-none-eabi-10-2020-q4-major/bin:/usr/local/bin:/usr/bin:/bin
/home/zvent/issue11-rc-build-venv/bin/python ./waf configure --board MicoAir405v2
/home/zvent/issue11-rc-build-venv/bin/python ./waf copter -j6
/home/zvent/issue11-rc-build-venv/bin/python Tools/scripts/extract_features.py build/MicoAir405v2/bin/arducopter
sha256sum build/MicoAir405v2/bin/arducopter.apj
```

Toolchain: GNU Arm Embedded `gcc-arm-none-eabi-10-2020-q4-major`. Commands completed successfully. Measured build summary:

| Measurement | Bytes |
|---|---:|
| Text | 885,652 |
| Data | 3,072 |
| BSS | 80,444 |
| Total flash used | 888,724 |
| Free flash | 110,684 |

BSS is static storage, not a measurement of available runtime heap or scheduling margin. Artifact hashes can change with build environment or metadata; the hash above identifies the saved tested artifact.

Binary feature extraction positively identified `HAL_MSP_ENABLED`, `HAL_MSP_OPTICALFLOW_ENABLED`, `HAL_MSP_RANGEFINDER_ENABLED`, `HAL_NAVEKF3_AVAILABLE`, `AP_OPTICALFLOW_ENABLED`, `AP_COMPASS_QMC5883L_ENABLED`, `AP_GPS_UBLOX_ENABLED`, `HAL_PROXIMITY_ENABLED`, `AP_PROXIMITY_MAV_ENABLED`, `HAL_VISUALODOM_ENABLED`, and `AP_AVOIDANCE_ENABLED`.

`arm-none-eabi-nm -C` additionally confirmed actual `ModeGuided::run()`, `ModeGuided::set_destination(...)`, `AP_MSP::init()` and `AP_MSP_Telem_Backend::msp_process_sensor_command(...)` symbols. The feature extractor prints `!HAL_MSP_SENSORS_ENABLED` even though the generated `hwdef.h` explicitly defines it as 1: the extractor has patterns for individual MSP backends but no symbol test for this aggregate flag. Individual flow/range backend symbols and the sensor command dispatcher were verified instead. [Pinned feature extractor](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/Tools/scripts/extract_features.py).

## Exact board port allocation

This assignment follows **MicoAir405v2**, not the H7 Lite mapping. It is a design allocation, not permission to wire without checking connector orientation and manufacturer pin order.

| Device | Physical interface | ArduPilot role |
|---|---|---|
| Pi UART | UART1 TX/RX + common ground | SERIAL1, MAVLink2; both directions DMA |
| MTF-01 | UART2 TX/RX + separate FC 5V/GND | SERIAL2, MSP sensor protocol; TX DMA, RX not DMA |
| M10G-5883 GPS | UART3 + FC 5V/GND | SERIAL3, GPS; no DMA |
| GPS compass | SDA/SCL | External I2C1 compass |
| ELRS receiver | UART4 TX/RX + FC 5V/GND | SERIAL4_PROTOCOL=23; TX DMA, RX not DMA |
| ESC telemetry | UART5 RX | Unused for this Bluejay configuration |
| SBUS input | UART6/SBUS | Unused; disable its RC protocol when allocating ELRS to UART4 |

**UART6's SBUS input is inverted.** The official board README recommends another UART, including UART1 or UART4, for other RC protocols. UART2 is also the DJI connector's signal UART; that connector's power pin is **9V**, which must not power the 5V MTF-01. Reassign its default display role and use appropriate 5V power. MAVLink proximity/vision data from the Pi shares UART1; it does not need another physical port. [Pinned board README](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/AP_HAL_ChibiOS/hwdef/MicoAir405v2/README.md).

Battery current input is on the ESC connector, ADC pin 11; voltage input is ADC pin 10, nominal voltage multiplier 21.2. An external whole-battery analog sensor must replace the ESC current signal, not be connected in parallel with it. The FC's 5V/3A BEC powers peripherals; the Pi retains its separate appropriately rated regulator. The board logs to microSD: budget a separate card because the selected stack package does not include one. [Pinned board README](https://github.com/ArduPilot/ardupilot/blob/dbe792162d06cab66c3475fd5556bf7a120f119e/libraries/AP_HAL_ChibiOS/hwdef/MicoAir405v2/README.md).

## Quote and package evidence

Live manufacturer WooCommerce quote to US/VA/22180 on the research date, no order submitted:

| Item | Exact variation | USD |
|---|---:|---:|
| MicoAir405v2 50A Bluejay stack, ArduPilot | 3172 | 59.99 |
| MTF-01 AUTO | 2968 | 22.90 |
| M10G-5883 GPS + QMC5883L compass | 3226 | 13.99 |
| Shipping | Flat rate | 5.00 |
| Storefront tax | 30% | 30.57 |
| Quoted total | | **132.45** |

All selected variants were accepted into an isolated cart. The site calls the charge only “Tax”; its inclusion of Virginia sales/use tax or full import settlement has not been established. Budget an additional $5.81 for 6% of these goods until resolved. The main shopping plan owns the complete delivered-budget calculation.

The supervising agent visually verified the exact stack package image: 470uF capacitor, XT60, 12AWG wire pair, eight M3x8 silicone grommets, two 10cm 3-pin VTX cables, 3cm 8-pin ESC cable, 20cm 6-pin GPS cable, and four 15cm 4-pin FC cables. No microSD card pictured/listed. [Manufacturer package image](https://store.micoair.com/wp-content/uploads/2024/10/MicoAir405v2_package2-jpg.webp).

Sources: [FC stack](https://store.micoair.com/product/micoair405v2/), [MTF-01](https://store.micoair.com/product/mtf-01/), [GPS variants](https://store.micoair.com/product/m9-m10-gps-module/), [official stock feature manifest for comparison](https://firmware.ardupilot.org/Copter/stable/MicoAir405v2/features.txt).

## Remaining verification

On received hardware: confirm board/sensor identity and bootloader, load the exact target, verify card logging, sensor reporting/compass, MSP flow and range quality, UART/RC operation, current calibration, Pi message loss handling and manual override. Measure scheduler/CPU health under the intended sensor and telemetry rates. This document records compile and source evidence only; it is not a completed bench or flight qualification.
