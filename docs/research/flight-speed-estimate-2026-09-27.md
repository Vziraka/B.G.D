# Flight-speed estimate — September 27, 2026

**Best preliminary engineering estimate: roughly 40 mph (64 km/h), with illustrative scenarios around 30–50 mph.** This is a low-confidence estimate of attainable straight-line, level, still-air speed under stated tilt and drag assumptions. It is neither a measured top speed nor a statistical interval or guaranteed bound. The actual aircraft may fall outside it. No flight-controller settings were changed.

## Configuration and evidence

Current selection: F450 frame, four SunnySky X2212 multirotor 980 KV motors, four selected SS-Prop-9450 blades, and the received HOOVO 4S 6200 mAh battery. [Live BOM](../increment-1-2-bom.md) and [September 20 propulsion evidence](precheckout-propulsion-2026-09-20.md).

The BOM's old 1,707 g total includes a 625 g allowance for the canceled CNHL battery. Substituting the HOOVO listing's 534 g gives **1,616 g by arithmetic only** if everything else remains unchanged. Neither is a scale measurement; use approximately 1.6–1.8 kg as an uncertainty screen, with 1.7 kg for the scenarios below. Installed wiring, mounts and payload remain unweighed.

[SunnySky's exact multirotor motor page](https://sunnyskyusa.com/products/sunnysky-x2212-brushless-motors-new) specifies 3–4S and its 9450 chart gives 1,230 g-force maximum static thrust per motor at 14.8 V. Four motors nominally sum to 4.92 kg-force in that test condition. This does not establish thrust at forward speed, continuous thermal capability, or installed battery/ESC performance. The [selected prop page](https://sunnyskyusa.com/products/sunnysky-multirotor-9450-propellers-cw-ccw-rotation-pair-fit-a2212-x2212-multirotor-motors) calls the blade 9045/9×4.5 despite the 9450 SKU; exact test-blade identity remains unresolved.

## Calculation

[NASA's drag equation](https://www1.grc.nasa.gov/beginners-guide-to-aeronautics/drag-equation/) is `D = 0.5 × rho × CdA × v²`. NASA explains that drag depends on shape and inclination and the coefficient normally requires experimental determination. Here `CdA` means drag coefficient multiplied by reference area; it is **assumed**, not measured or supplied by the manufacturer.

For steady level flight, neglecting other vertical aerodynamic forces, rotor thrust satisfies `T cos(theta) = mg`. Its horizontal component is therefore `mg tan(theta)`. Balancing that component against drag gives:

`v = sqrt(2 × m × g × tan(theta) / (rho × CdA))`

Assumptions: `m = 1.7 kg`, `g = 9.80665 m/s²`, `rho = 1.225 kg/m³`; tilt measured from vertical thrust direction; still air; adequate propulsion to maintain the assumed tilt and altitude. The following CdA and tilt choices are sensitivity scenarios, not verified aircraft parameters.

| Scenario | Tilt | Assumed CdA | Calculated speed | Required total thrust |
| --- | ---: | ---: | ---: | ---: |
| More drag / modest tilt | 35° | 0.10 m² | 13.8 m/s; 30.9 mph; 49.7 km/h | 2.08 kg-force |
| Middle assumption | 40° | 0.07 m² | 18.1 m/s; 40.4 mph; 65.0 km/h | 2.22 kg-force |
| Less drag / greater tilt | 45° | 0.05 m² | 23.3 m/s; 52.2 mph; 84.0 km/h | 2.40 kg-force |

The static thrust figure exceeds these force requirements on paper, which makes the scenarios plausible enough to investigate; it does not prove speed. At fixed tilt the equation makes greater weight produce a higher equilibrium speed because more thrust is required to hold altitude. **It does not mean adding weight improves the drone:** propulsion limits and drag also change, and those effects are not modeled here. Using the revised 1.616 kg arithmetic mass lowers the middle scenario only about 2.5%, to approximately 39.4 mph.

## Practical interpretation and limitations

Use **about 40 mph as a rough answer**, with low confidence. Do not quote 50 mph as an established maximum. Airframe drag, rotor aerodynamic drag/inflow, exact propeller behavior, voltage sag, thermal limits, control reserve, installed payload and actual firmware tilt/speed restrictions can all change the outcome. There is no tested maximum tilt, configured speed limit, flight log or measured drag parameter supporting a precise top-speed claim. Multiplying motor KV by battery voltage cannot supply ground speed, and propeller pitch speed is not a reliable multirotor forward-flight ceiling.

For scale only, [DJI's Phantom 3 Standard specification](https://www.dji.com/support/product/phantom-3-standard) lists 16 m/s (35.8 mph) and 35° maximum pitch. It is a different 1.216 kg, 350 mm aircraft; its speed is not evidence that this F450 achieves the same result.

This estimate does not qualify autonomous tracking speed, stopping distance or obstacle avoidance. Those need separate tests. After normal assembly, power/failsafe and hover qualification, obtain complete flying mass and flight logs from gradually faster, level passes under a separately prepared flight procedure. Opposite-direction passes in low wind can reduce wind bias; a GPS maximum in a dive or tailwind must not be labeled still-air level top speed.

## Provenance

Prepared in main checkout, branch `main`, base commit `e760b7bdc83cf45f6089ea291b026856ad717557`; sources include uncommitted files, so the commit alone does not preserve the evidence. BOM SHA256 at review: `0f3e135572942ad4cbe93bea0483f4536bce342e70dd6bfad101c6472f41832b`. September 20 propulsion note SHA256: `4e31ffd0a45ef82b7f84c8f1a51ae8e356d5666994ba4bde78f3a8cd5f461ed0`. NASA, SunnySky and DJI pages checked September 27, 2026. Calculations are new engineering inference, not manufacturer performance claims. This note is saved locally and not committed.
