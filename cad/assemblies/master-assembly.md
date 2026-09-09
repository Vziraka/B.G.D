# Planned Fusion master assembly

**Current robust-design checkpoint:** [AIO review](../robust-aio-review.md) and [RF-GATE-01](../received-frame-inspection-gate.md). Do not send the TBS inquiry. Preserve the conflicting bottom thickness as2.0–2.5mm; use the explicitly provisional expanded budgets for digital studies. A separate `BGD_AIO_ENVELOPE_R3` studies a45mm outline plus body/mount/service envelopes. Its planar bound passes, but the full mount does not. Original `BGD_MASTER` remains unchanged hypothesis B; neither document is a fabrication datum until received measurements and remaining digital checks are reconciled.

**Focused frame review:** [revision/confidence register and conditional adapter checks](../reference/source-one-v6-7in/revision-resolution.md). Current master geometry is unchanged hypothesis B; its Z stack must not be called manufacturer verified or released.

Status: **partial `BGD_MASTER` created and inspected**, with a [local archive/manifest](reference-r1-manifest.json). Seven plate/arm solids, eight standoff envelopes and one adapter study are modeled; the planned whole-aircraft tree below is not yet implemented. See [current findings](../engineering-progress-2026-09-05.md).

**2026-09-05 coordinate correction:** actual master placement uses right-handed FLU and rotor-centroid XY. The earlier circle-centre source analysis remains a separate datum. Z stack hypothesis B remains unverified; do not use it as a fabrication datum.

## Coordinate system and parameters

Units are millimetres, grams and degrees. Right-handed aircraft axes are **X forward, Y left, Z up**. XY origin is the mean of the four motor axes: raw DXF(1518.565263306285,1493.8850402200592). Transform X=1493.8850402200592−DXF_Y and Y=DXF_X−1518.565263306285. `frame_reference_z=0` is the assumed arm underside; `prop_plane_z` remains independent until the frame/motor stack is sourced or measured. Default Fusion material masses are not the aircraft mass ledger.

Required named parameters for further parameterization (the current scripted solids do not yet implement this complete parameter table):

| Parameter | Initial value | Status |
|---|---:|---|
| `prop_diameter` |177.8mm | Q75/APC source value |
| `aio_hole_pitch` |25.5mm | Manufacturer dimension |
| `aio_plate_thickness` |1.6mm | R1 study assumption |
| `battery_x/y/z` |48/139/72mm | Published/configured envelope; received-part hold |
| `cg_slider_travel` |50mm total | Approved design target, geometry unresolved |
| `d500_scan_height` | parameter only | Prior115mm target is not released geometry |
| `gnss_mast_height` | parameter only | Optimize after field/antenna/CG study |
| `tfmini_angle` |0deg downward | Initial orientation, later calibrated |
| `camera_pan/tilt` | parameter limits | Must come from servo/linkage/CSI clearance evidence |
| `landing_ground_clearance` | parameter only | Prior175mm rotor-to-ground target is not released geometry |

## Component tree

```text
BGD_MASTER
├─ 00_REFERENCE
│  ├─ FRAME_SOURCE_ONE_V6_7IN
│  ├─ AXES_DATUMS
│  └─ ENVELOPES_AND_MASS_POINTS
├─ 10_PROPULSION
│  ├─ MOTOR_FL / MOTOR_FR / MOTOR_RL / MOTOR_RR
│  ├─ PROP_FL / PROP_FR / PROP_RL / PROP_RR
│  └─ PROP_SWEEP_FL / FR / RL / RR
├─ 20_FLIGHT_AND_POWER
│  ├─ MICOAIR_AIO / AIO_ADAPTER
│  ├─ NEXUS_PACK / BATTERY_CRADLE
│  ├─ QS8 / INA_BM / C110_BUS_GUARD
│  └─ BEC_PI / BEC_PERIPHERAL / BEC_IR / CAPACITOR / FUSES
├─ 30_COMPUTE_AND_IMAGING
│  ├─ PI4 / PERMA_PROTO / FAN / HEATSINK / MICROSD
│  ├─ CAMERA3_NOIR / CSI_SWEEP
│  └─ PAN_TILT / IR_LEFT_RIGHT / RGBW_LEFT_RIGHT / CARRIER
├─ 40_NAVIGATION_AND_RADIO
│  ├─ D500 / D500_SCAN_KEEP_OUT / MAST / USB_ROUTE
│  ├─ TFMINI / DOWNWARD_FIELD / BRACKET
│  ├─ M10_IST8310 / MAGNETIC_KEEP_OUT / MAST
│  └─ RP1 / ELRS_ANTENNA / RF_KEEP_OUT / FINDER2
├─ 50_CARGO_AND_RECIPIENT
│  ├─ REMOVABLE_HOLDER / PAYLOAD_ENVELOPE / AIRCRAFT_INTERFACE
│  ├─ LATCH / SOLENOID / RC_SWITCH / HOLDER_CONNECTOR
│  └─ SWITCH_A / SWITCH_B / CAMERA_VERIFICATION_VIEW
├─ 60_LANDING_AND_PROTECTION
│  ├─ LANDING_GEAR / GROUND_PLANE
│  └─ TOUCH_GUARDS / STRAIN_RELIEF / SERVICE_KEEP_OUTS
└─ 70_HARNESS_ROUTE_VOLUMES
   ├─ HIGH_CURRENT / COMPUTE / PERIPHERAL / SENSOR
   └─ UART_I2C_PWM_GPIO_USB_CSI
```

All supplier parts are separate rigid components. Custom parts are parameterized components. Prop discs, camera motion, LiDAR fields, antenna zones, connector service and cable bends are non-manufacturing keep-out bodies in a dedicated appearance/color. Harness routes are centreline paths plus diameter/bend envelopes, not decorative wires.

## Assembly rules

- Ground the frame reference; do not ground moving or adjustable assemblies prematurely.
- Use rigid groups only within real rigid parts. Use revolute joints for pan/tilt/hinge and slider joints for the battery/holder where the design truly moves.
- Put documented mass at each component's model centroid; label allowances separately. Never tune mass to obtain a preferred CG/endurance result.
- Model connector mating/service volumes and cable exits before final placement.
- Maintain configurations for reference no-cargo, holder installed empty and holder+250g cargo. The Q74 reference is full required equipment, no delivery cargo.
- Save interference, static prop-clearance, CG and field-of-view results with input revision/tolerance assumptions. Dynamic proof remains bench/flight work.

## Review milestones

1. Authoritative frame import and coordinate validation.
2. Propulsion and battery envelopes; initial static rotor/pack clearance.
3. Flight/power stack and service access.
4. Compute/sensors/radio with fields, sweeps and routes.
5. Custom mounts/guards/landing/cargo.
6. Complete mass/CG, interference and harness-route review.
7. Export traceable neutral snapshot and drawings for independent release review.

Detailed CAD generation stops before milestone1 in this pass.
