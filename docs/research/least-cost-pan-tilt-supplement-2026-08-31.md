# Issue 10 — lighter two-axis camera mount supplement

Date: **2026-08-31**. Status: **concrete alternative for the coordinated mass model, not a purchase or validated aircraft installation**. This bounded supplement replaces only the proposed pan/tilt assembly; it preserves the Camera Module3, two-axis camera movement, both power regulators, all milestone features and all existing contingency. No PC implementation, purchase, contact, installation or powered test was performed.

## Result and purchase evidence

**Adafruit Mini Pan-Tilt Kit1967 is a plausible42g installed-mass reduction** from the earlier82g Waveshare assembly, without buying another PWM driver. Adafruit specifies **37g for the fully assembled kit including two SG-90/SG-92-type micro servos**. Model **40g including a separate3g camera-adapter allowance**, keeping the camera, ribbon and existing structural allowances elsewhere. The3g adapter is a design allowance, not a measured manufactured part; if the actual adapter is heavier, recalculate. Do not remove the50g integration contingency or30g pack uncertainty allowance.

| Property | Primary/transaction evidence |
|---|---|
| Exact item | Adafruit1967, assembled mini pan/tilt including two analog micro servos |
| Published mass |37g |
| Movement | Approximately180° pan and150° tilt; installed travel must respect cable/mechanical stops |
| Dimensions |37×33×3mm base;30×26mm mounting-hole spacing;67mm standing height;38×36mm top platform |
| Price |**$18.95 USD** for one |
| Availability | Adafruit direct is out of stock. Fresh DigiKey product-page reads report stock available,60–63 units across the two product URLs, at$18.95. Earlier search snippets showing0 stock are stale relative to these page reads. No stock is reserved. |

[Adafruit's assembly, servos, dimensions and mass](https://www.adafruit.com/product/1967), [DigiKey1528-1106-ND offer](https://www.digikey.com/en/products/detail/adafruit-industries-llc/1967/5154681), [DigiKey alternate product URL](https://www.digikey.com/en/products/detail/adafruit-industries-llc/1967/1528-1106-ND/5154681).

Replacing the earlier$17.99 mount with this$18.95 item increases sticker price **$0.96**. That modest increase buys a documented mass reduction; do not call it a purchase-price saving. Small fastening/insulation material remains in the existing integration-consumables budget. No extra PCA9685/HAT cost or mass is needed for the direct-control proposal below. Delivery/tax remain in the complete-project ledger.

## Exact controller output path

The candidate controller is **MicoAir743v2-AIO-45A**, not the similarly named405v2 board. Its own specification separates motor outputs1–4 on TIM1 from outputs5–6 on TIM3. The manufacturer pin table and ArduPilot hardware definition identify:

| Proposed use | Physical signal / MCU timer | Separation |
|---|---|---|
| Four propulsion motors |M1–M4 / TIM1 | Retain their motor/DShot configuration |
| Camera pan signal |M5 / PB1 / TIM3 channel4 | Ordinary servo PWM on the separate5–6 timer group |
| Camera tilt signal |M6 / PB0 / TIM3 channel3 | Same ordinary PWM protocol/rate as pan |
| ELRS | Existing allocated serial UART | Does not consume these two PWM outputs |
| Servo power | Existing regulated5V peripheral rail, common ground | Do not power motors from MCU signal pads or back-feed the FC/Pi |

The board shares protocols within a timer group, so both5–6 must remain servo PWM, not one servo and one DShot motor. Outputs7–8 share a timer with the serial-LED pad; avoiding that group preserves the lighting option. Do not assume that shared-target outputs9–10 are physically exposed on this AIO merely because the generic firmware definition lists them. [Exact AIO output groups and pin table](https://micoair.com/flightcontroller_micoair743v2_aio_45a/), [ArduPilot MicoAir743v2 hardware definition at fixed commit1511f27194f1dcc3728270883047bdf022b3fd53](https://raw.githubusercontent.com/ArduPilot/ardupilot/1511f27194f1dcc3728270883047bdf022b3fd53/libraries/AP_HAL_ChibiOS/hwdef/MicoAir743v2/hwdef.dat).

ArduPilot explicitly lists the Adafruit Mini Pan-Tilt Kit as a supported PWM servo gimbal. A reviewed configuration can allocate mount type1, yaw function6 to output5 and pitch function7 to output6, with calibrated ordinary servo rate/travel limits. These are proposed assignments, not settings applied here. The Pi can issue mount commands over the already planned MAVLink connection; no new UART or Pi I2C servo board is necessary. **The published stable Copter/MicoAir743v2 feature list was checked on2026-08-31 and includes `HAL_MOUNT_SERVO_ENABLED`**; backend availability is therefore resolved for the checked build, not an unanswered paper blocker. Preserve M5/M6 in the final allocation and recheck the actual image/configuration at installation. [Stable build's feature list](https://firmware.ardupilot.org/Copter/stable/MicoAir743v2/features.txt), [ArduPilot servo-gimbal support](https://ardupilot.org/plane/docs/common-camera-gimbal.html), [output-function definitions](https://ardupilot.ardupilot.org/plane/docs/common-rcoutput-mapping.html), [companion mount commands](https://en.ardupilot.org/dev/docs/mavlink-gimbal-mount.html).

## Camera fit and remaining integration

Camera Module3 Standard/NoIR is **25×24×11.5mm**, so its board fits within the38×36mm platform footprint. This is a dimensional screen, not proof of matching mounting holes or unobstructed lens/ribbon clearance. Use a small nonconductive adapter and secured fasteners; retain clearance around the autofocus lens and a strain-relieved ribbon service loop through the qualified pan/tilt range. Neither advertised servo travel nor a fitting rectangle guarantees full installed movement. [Raspberry Pi Camera Module3 dimensions](https://www.raspberrypi.com/products/camera-module-3/?variant=camera-module-3-noir).

Before assembly, update the installed drawing for the67mm mount height, camera adapter, ribbon route, landing/prop clearance and center of gravity. The AIO manufacturer's linked port image returned404 during this bounded pass; the logical pad mapping above is documented, but physical pad-location/received-board revision must be checked against an available drawing or the received board before soldering.

Before operation, confirm servo signal recognition, neutral position, safe travel, startup/stall current, rail stability, vibration, retention and camera performance. The servo type may vary between the two published micro-servo types; validate the received units and keep their coincident current within the existing auxiliary budget. A successful command acknowledgement is not proof that the camera reached its angle. Preserve authorization rules when the companion controls the mount. This two-axis assembly does not claim three-axis stabilization or a vibration-free image.

**Mass-model handoff:** change only the82g pan/tilt row to40g, a **42g reduction**. Camera/ribbon mass remains unchanged. Any separate lighter Pi enclosure/cooling proposal must be added from its own evidence. Recompute coupled battery sag, endpoint thrust and useful endurance; this supplement alone does not claim to recover the full required approximately80g reduction or achieveQ74.

## Provenance

Shared checkout `C:\Users\zvent\Downloads\B.G.D`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. Source model read: `docs/research/least-cost-propulsion-2026-08-31.md`, uncommitted SHA-256 `405023581688491B45528D7F39B7F726F01D7163AA2F3477C989F59E07A205DE`. Later coordinated model revisions supersede that numerical snapshot. The hardware definition is pinned above; the stable firmware feature URL is a dated observation of a moving release path. No firmware was installed or modified. Parent owns final tracker/index linking and synchronized BOM selection.
