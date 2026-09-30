# MicoAir743 USB-only configuration batch — proposed, 30 September 2026

**Status: engineering proposal for main-agent review; no device write, battery connection, motor test, arming or flight is released by this document.** After review, configuration can run as one USB-only batch with one saved result, rather than a report after every setting. Aircraft battery and charger disconnected; all props absent; FC–ESC eight-pin cable unplugged at both ends. USB may power the original FC and its already-tested Nano only; Nano antenna attached and joints accessible. Keep the working Pi separate.

Evidence: `docs/hardware/evidence/MicoAir743-after-frame-class-2026-09-29.param` records ArduCopter 4.5.7, Quad X, motor functions 33/34/35/36, normal PWM, CH5 flight modes, 3300 mAh, uncalibrated current scale 40.2, 10.5 V low battery and disabled battery actions. The later receiver success is owner-reported; exact saved calibration/failsafe results are not available. Do not reload this old file over later work: save the actual current parameters first.

## A. One configuration batch

1. Leave radio SA in its low/disarm position and throttle fully down. Power the radio normally, without radio USB. Connect the FC USB, identify the FC COM port (previously COM8; COM7 hub/COM9 radio are not it), and connect Mission Planner at 115200. Confirm the expected original MicoAir743/ArduCopter identity. Save `MicoAir743-before-USB-batch-2026-09-30.param` through `CONFIG/TUNING → Full Parameter List → Save to file`.
2. In that list, enter the reviewed values below. Save/write the batch. If a parameter is absent, its displayed meaning differs, or the write is rejected, stop that group and report the exact name; do not substitute a similar parameter or flash firmware. Keep `RC5_OPTION=0` during radio calibration; its later proposed arm value is separate below.
3. Disconnect Mission Planner, unplug FC USB, reconnect USB and Mission Planner, and verify the batch after reboot. Save `MicoAir743-after-USB-batch-2026-09-30.param` once after the radio/calibration work too. Report the two filenames and any failed group together. Do not press Arm, Motor Test or ESC Calibration.

### Frame, shortest motor routes and basic DShot

This table applies only to an ESC with its socket toward the **front/red arms**, nearest motor-pad groups, and an FC whose arrow also points to the aircraft front. FC orientation is independent of ESC rotation. If the FC arrow differs, resolve its orientation before using `AHRS_ORIENTATION=0`.

| Parameter | Proposed value |
| --- | ---: |
| `FRAME_CLASS` | 1 |
| `FRAME_TYPE` | 1 |
| `AHRS_ORIENTATION` | 0, conditional on FC arrow forward |
| `SERVO1_FUNCTION` | 34 |
| `SERVO2_FUNCTION` | 35 |
| `SERVO3_FUNCTION` | 36 |
| `SERVO4_FUNCTION` | 33 |
| `MOT_PWM_TYPE` | 5 |
| `SERVO_BLH_BDMASK` | 0 |
| `SERVO_BLH_3DMASK` | 0 |
| `SERVO_BLH_RVMASK` | 0 |
| `SERVO_DSHOT_ESC` | 0 |
| `ARMING_CHECK` | 1 |
| `ARMING_RUDDER` | 0 |

The output mapping is FC1/ESC1 rear-left Motor2; FC2/ESC2 front-left Motor3; FC3/ESC3 rear-right Motor4; FC4/ESC4 front-right Motor1. DShot300 is supported by the manufacturer's Bluejay table and recommended by MicoAir. Do not select DShot150 for this Bluejay board merely because generic advice favors slower signals on large aircraft. Basic DShot uses no throttle-range ESC calibration. Leave existing DShot rate/passthrough settings unchanged; bidirectional telemetry, direction commands, AirMode and 3D are not enabled here. [MicoAir ESC specification](https://micoair.cn/zh/docs/esc/esc), [MicoAir743 manual](https://micoair.cn/en/docs/flight-controller/micoair743/micoair743-flight-controller-manual), [ArduPilot DShot setup](https://ardupilot.org/copter/docs/common-dshot-escs.html).

**Installed-firmware limit:** MicoAir now states official original-board support begins at ArduPilot 4.6.0; this owner board actually runs 4.5.7. Preserve that working firmware during this batch. Before motor operation, observe its startup `RCOut` message showing DShot on outputs 1–4 after the reboot. A current manufacturer's manual does not prove the output implementation in this installed binary. A missing/contradictory banner requires diagnosis before motor commands.

### Radio and first manual-aircraft failsafes

| Parameter | Proposed value |
| --- | ---: |
| `SERIAL5_PROTOCOL` | 23, retain |
| `SERIAL5_OPTIONS` | 0, retain |
| `RCMAP_ROLL / PITCH / THROTTLE / YAW` | 1 / 2 / 3 / 4, retain |
| `FLTMODE_CH` | 6 |
| `FLTMODE1` through `FLTMODE6` | 0 each, initial bench/manual preparation |
| `RC5_OPTION` | 0 while calibrating; later 153 as described below |
| `RC6_OPTION` | 0 |
| `RC_OPTIONS` | 32, retain throttle-low arming check |
| `RC_FS_TIMEOUT` | 1 second |
| `FS_THR_ENABLE` | 3 |
| `FS_THR_VALUE` | 975, conditional on measured active throttle minimum at least 985 |
| `FS_OPTIONS` | 0 |
| `FS_GCS_ENABLE` | 0, initial independent-radio stage |

All initial mode bins select Stabilize; this avoids scheduling an unqualified GPS/automatic mode. CH6 still changes the selected bin. Selecting a flight mode and declaring the aircraft fit to fly are separate. Radio loss selects Land for the initial local manual stage. GCS loss is not a manual-radio control dependency; later Pi authority/link-loss rules remain unfinished. These settings do not qualify autonomous recovery or out-of-sight flight. [Radio failsafe](https://ardupilot.org/copter/docs/radio-failsafe.html), [flight-mode switch configuration](https://ardupilot.org/copter/docs/common-rc-transmitter-flight-mode-configuration.html).

## B. Radio calibration and observations, in one USB-only pass

On `SETUP → Mandatory Hardware → Radio Calibration`, observe CH1 roll, CH2 pitch, CH3 throttle, CH4 yaw, SA/CH5 and SB/CH6. Roll/yaw/throttle must increase in their positive stick directions; pitch must decrease when the stick is pushed forward. Correct an observed reversal in the corresponding `RCx_REVERSED` setting or the transmitter, then recheck; do not copy assumed reversed flags or 1000/2000 endpoints.

If radio calibration is already demonstrably saved, retain it; the older backup's generic 1100/1900 endpoints do not prove that. Otherwise click `Calibrate Radio`, sweep both sticks and SA/SB fully, finish, center roll/pitch/yaw and put throttle fully down, then accept the measured endpoints. Sweep each control once more. No response, mixed channels, an unstable center, or a switch that cannot reach its intended states stops this group. [ArduPilot radio calibration](https://ardupilot.org/copter/docs/common-radio-control-calibration.html).

Record one set: actual CH1–CH4 min/trim/max and direction; CH5 low/high; CH6 every available SB position/bin. Mark the physical SA position producing CH5 low as DISARM. With the flight battery and ESC still absent, the **proposed later configuration** is `RC5_OPTION=153` (ArmDisarm on 4.2+), SA low before power-on. This is not old value 41 and is not 154/AirMode. Do not perform an arm request in this batch. If SA's low/high direction differs from the intended labeled switch positions, resolve that using the actual radio mapping rather than guessing.

With SA low and FC disarmed, briefly turn the radio off while watching Mission Planner messages/status, then restore it and verify fresh control response. A frozen bar or bound receiver LED is insufficient: record explicit RC-input loss/failsafe indication or report that it was not visible. Disarmed radio loss normally does **not** execute a Land mode change. Later real, props-off armed failsafe/takeover testing is a separate released test; do not arm here or disable checks to force a demonstration.

## C. Preliminary 4S battery protection — not calibration

| Parameter | Proposed value |
| --- | ---: |
| `BATT_MONITOR` | 4, retain analog voltage/current |
| `BATT_VOLT_PIN / BATT_CURR_PIN` | 10 / 11, retain |
| `BATT_VOLT_MULT` | 21.12 initially, existing value; must measure later |
| `BATT_CAPACITY` | 6200, nominal pack label |
| `BATT_FS_VOLTSRC` | 0, raw voltage |
| `BATT_ARM_VOLT` | 15.2 |
| `BATT_LOW_VOLT / BATT_CRT_VOLT` | 14.4 / 14.0 |
| `BATT_LOW_TIMER` | 5 seconds |
| `BATT_FS_LOW_ACT / BATT_FS_CRT_ACT` | 1 / 1, Land |
| `BATT_LOW_MAH / BATT_CRT_MAH / BATT_ARM_MAH` | 0 / 0 / 0 until current evidence |

The 15.2/14.4/14.0 V and five-second values are conservative engineering starting choices for short local tests, not HOOVO limits, measured usable capacity, proven recovery energy or permission to fly. Zero capacity thresholds temporarily exclude an uncalibrated consumed-mAh estimate; voltage protection stays enabled. A USB-only FC reads no real pack voltage and can report battery pre-arm failure: do not weaken `ARMING_CHECK` or thresholds to clear that.

**Choose the current stage correctly:** Stage P direct propulsion harness with original ESC `Curr` connected uses `BATT_AMP_PERVLT=78.4314` as a manufacturer-sensitivity starting calculation (1 / 0.01275 V/A), and provisional `BATT_AMP_OFFSET=0`. Neither is a measured calibration. Final Stage W uses **only** the isolated, divided 5292 path: calculated starting slope 100 A/V and zero 1.25 V. Do not apply those final values while native ESC Curr remains connected. Final ADC loading/zero and current-reference calibration are required. Changing sensors requires changing the calibration and documenting which circuit is installed.

After C1/C2/C3 release, compare simultaneous safe meter pack voltage with Mission Planner voltage; update multiplier by `new = old × meter voltage / displayed voltage`, then recheck at another voltage when available. Proposed agreement is within 0.2 V, considering meter uncertainty. Do not treat USB values or charger total from another time as simultaneous calibration. Do not insert the AM33D 10 A jack into the aircraft main current path. A credible current/load or charge-consumption reference remains to be selected; nominal slopes alone do not establish integrated consumption. After validated current/consumption evidence, proposed initial low/critical remaining-capacity thresholds are 1240/620 mAh (20%/10% of the nominal 6200); these still do not prove landing reserve. [Battery monitoring](https://ardupilot.org/copter/docs/common-power-module-configuration-in-mission-planner.html), [battery failsafe](https://ardupilot.org/copter/docs/failsafe-battery.html).

## D. What still gates actual motors and first hover

Before any motor command: the main agent must review actual C1 joint/insulation/polarity/short/retention results; C2 pack and four-cell/charge evidence; staged ESC/FC supply observations; remap read-back and DShot1–4 startup evidence. Secure the props-off airframe, clear tools and wires from motors, keep an immediate disconnect accessible, and use a separately released single-motor test. **No motor test or powered joint check is authorized by the USB batch.**

Later observed Motor Test A/B/C/D must run front-right / rear-right / rear-left / front-left, which for this remap are FC outputs 4 / 3 / 1 / 2. In the standard Quad X layout, front-right/rear-left rotate CCW and front-left/rear-right CW, viewed from above; actual rotation must be observed, not inferred from wire color. A wrong motor/direction stops the powered test for correction while disconnected. [ArduPilot motor order/test](https://ardupilot.org/copter/docs/connect-escs-and-motors.html).

Before hover additionally require: final board/airframe attitude agrees with Mission Planner HUD; completed accelerometer six-position and installed level calibration; final installed compass validity/interference review; credible battery-voltage/current evidence and tested failsafe/takeover/arm-disarm; sound mounts/battery retention and motor/prop clearance; proper prop direction and fastening after the props-off pass; relevant pre-arm checks passing; appropriate site/conditions and a competent pilot. Calibrations can follow Mission Planner's complete onscreen sequence as a batch; compass calibration should wait for final installed wiring and sensor position. GPS/flow/depth readiness is necessary before relying on those sensors or modes; receipt and USB radio success do not qualify them. First hover remains an intermediate milestone and does not pass phone/autonomy, 100 m, useful-duration or darkness requirements.

The proposed parameter values are checked against [ArduCopter 4.5.7's parameter reference](https://ardupilot.org/copter/docs/parameters-Copter-stable-V4.5.7.html). That reference cautions that generated metadata can include newer entries; a name absent from the actual board is a stop, not a reason to invent it. Save/read-back rather than claiming a write based on a checklist. Return the combined saved file and listed exceptions once; routine successful settings do not need individual photos or replies.
