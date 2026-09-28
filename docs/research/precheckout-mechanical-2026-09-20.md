# F450 mechanical pre-check — 2026-09-20

Scope: selected Original HAWK’S WORK F450 B09YQ4G4ZZ; no old C1 CAD. This is a sourced dimensional screen, not a finished mount design or physical fit test. Source checkout HEAD `e760b7bdc83cf45f6089ea291b026856ad717557`; working BOM was uncommitted, SHA256 `A1614219B4C511C887521A40CEC7DE0C45EEE7A080DF71C20451C3930BDA1C76`. Main agent owns current BOM integration.

## Outcome

Keep the selected frame and included landing gear. Newly recovered seller dimensions provide substantial nominal battery-to-ground margin; buying taller gear is not justified. Keep a small hardware contingency instead of spending the entire remaining budget speculatively. The center stack's assembled height and the purchased RasTech cooler still require measurement. The 40 g print allocation is aggressive but plausible for skeleton brackets, not a solid enclosure.

## Verified frame evidence

The [exact Original Amazon page](https://www.amazon.com/dp/B09YQ4G4ZZ) includes this [seller dimension illustration](https://m.media-amazon.com/images/S/aplus-media-library-service-media/aed011a6-b521-4b00-907e-3e6ef254ffcd.__CR0,0,1464,600_PT0_SX1464_V1___.jpg). It depicts a 180 × 96 mm lower plate envelope, 150 mm lower-plate-to-ground gear height, 215 mm foot span and 450 mm diagonal wheelbase. **The 52 mm arrow is horizontal between the arm roots, not vertical plate separation.** It cannot establish interplate height. Seller diagrams have no tolerance specification; A+ imagery is shared among frame variants, but this image is actually present on the selected Original page.

That listing identifies four included landing skids, 280 g frame net mass, approximately 1.8 kg takeoff mass, 16/19 mm motor mounting pattern, eight M3×7 motor screws, 24 M2.5×6 arm screws and eight M2.5×8 bracket screws. Keep the existing 400 g frame/gear budget because the 280 g figure does not clearly include gear. Its recommended 1800–4500 mAh pack range is exceeded by our 6000 mAh selection; this is a custom payload/propulsion design, not the supplier’s recommended kit configuration.

## Battery with useful margin

[CNHL’s exact pack page](https://chinahobbyline.com/products/cnhl-black-series-6000mah-14-8v-4s-65c-lipo-battery-with-ec5-plug) specifies 155 × 45 × 44 mm with a stated 1–5 mm dimensional difference, 620 ±5 g, EC5 and 10 AWG leads. Use **160 × 50 × 49 mm** as the conservative body mock-up. This is manufacturing allowance, not permission to use a swollen pack.

Design assumptions, to verify in the dry build:

- Center the pack beneath the lower plate, long axis front/back. Reserve a **170 × 60 mm open mounting zone**: 5 mm adjustment each side of the maximum body. Plate outline is not an uninterrupted rectangle, so verify contact pads and strap paths rather than assuming full-area support.
- Reserve **54 mm below the plate** for 49 mm pack, 2 mm pad and approximately 3 mm strap/retention allowance. Nominal ground margin is **150 − 54 = 96 mm** on a level surface. Require at least 30 mm measured ground clearance with installed gear and full build resting under its own weight; 96 mm is not a promise for grass, uneven terrain or landing flex.
- Leave the connector end open and reserve an additional **30 mm wire/connector service zone** beyond the body; route/restrain EC5 laterally clear of gear rather than force the 10 AWG lead into a sharp bend. This is a layout allowance, not a certified bend radius. Verify against the supplied pigtail and connector.
- The 250 mm straps must loop through slots beside the battery, not around the entire 96 mm plate width. A simplified maximum-body/pad loop is approximately 2×(50+49+2)=202 mm before slot routing/buckle losses, leaving only 48 mm nominal. Use two straps, check useful hook/loop engagement and longitudinal retention physically; change to longer straps if the actual routing consumes that margin. Do not rely on one friction pad as the only restraint.

## Pi, flight stack and propeller separation

The [official Pi 5 drawing](https://datasheets.raspberrypi.com/rpi5/raspberry-pi-5-mechanical-drawing.pdf) shows an 85 × 56 mm board and 58 × 49 mm mounting centers. Its dimensional notes explicitly require reference to a physical board. The purchased kit cooler is not established to be the official Active Cooler: the latter’s [63.5 × 42.5 × 13.7 mm drawing](https://datasheets.raspberrypi.com/cooling/raspberry-pi-active-cooler-mechanical-drawing.pdf) must not silently become the installed cooler envelope.

[MicoAir’s current original 743 manual](https://micoair.cn/en/docs/flight-controller/micoair743/micoair743-flight-controller-manual) and [ArduPilot’s board documentation](https://ardupilot.org/copter/docs/common-MicoAir743.html) document the original controller. The controller is 36 × 36 × 8 mm; this is **not** the assembled ESC/controller/grommet height. The [selected stack listing](https://pyrodrone.com/products/micoair-743-stack-with-h743-bmi088-flight-controller-and-2-6s-50a-bluejay-4in1-esc-30x30mm) is the original 50 A stack, not v2 or Lite.

A credible adjustable architecture is the battery below, stack at the center, Pi above and camera/depth at the forward center. Reserve a **100 × 80 mm center hardware envelope** for Pi body, mounting edges and restrained local wires, plus an unobstructed removable cable-service path. Do not permanently carry unnecessary USB/HDMI plugs. Leave the Pi fan inlet and exhaust open; preserve access to its GPIO socket, CSI latch and microSD.

If the actual assembled stack fits between plates with at least 5 mm measured top-component clearance and unpinched cable exits, use the original between-plates plan. Otherwise place it above the top plate with an open printed bridge for the Pi. Set bridge underside from **measured stack height + at least 5 mm**, rather than order a speculative tall spacer pack or assume the 30 mm purchased bolts define stack height. This fallback changes print geometry and center of gravity; it is not released CAD. Keep stack vibration grommets functional and do not bridge them with taut wires.

Calculated plan-view screen: for a square-X 450 mm diagonal, motors lie at approximately (±159.1, ±159.1) mm. With a conservative 240 mm prop diameter, a centered 100 × 80 mm rectangular envelope has approximately **41.5 mm** shortest nominal separation from a prop disk: sqrt((159.1−50)^2+(159.1−40)^2)−120. This supports a narrow central tower without relying solely on height. Require at least 20 mm physical swept-disk separation after all antennas/cables are restrained, checking flex; the calculation excludes dynamic motion and noncentral protrusions. A large GPS mast, cable loop or wide Pi case is not automatically inside that envelope.

Place the downward sensor outside the battery silhouette with its complete view cone unobstructed. Route the downward lamp so neither battery nor landing legs block its light. Camera/depth brackets must remain between front prop disks, with the complete sensor field checked in the live image. Mount GPS away from current-carrying loops; confirm compass interference with the completed powered assembly.

## Print mass and buying consequence

For a transparent rough screen, use [Polymaker PETG density](https://shop.polymaker.com/products/petg) 1.3 g/cm³. A solid 100 × 70 × 2 mm Pi plate alone is 18.2 g; retaining 60% of its area gives 10.9 g before ribs/supports. The total 40 g budget corresponds to about 30.8 cm³ of plastic. A skeleton Pi plate, small stack adapter and compact sensor brackets can plausibly share that amount, but two full plates, a tall solid tower and enclosures likely cannot. A slicer estimate and scale measurement must replace this screen. Printed-part strength, creep, layer orientation and vibration are separate acceptance checks.

No mechanical replacement purchase is demonstrated necessary. Retain funds for exact screw lengths, longer straps or a compact cooler only if measured parts establish the need. Order the quickly arriving frame/PETG first and perform cardboard maximum-envelope checks before opening strict-return electronics. The existing Pi is available for direct measurement now. Weigh the received frame with gear and purchased Pi/camera/cooling early; recalculate total mass/endurance before soldering the aircraft. Motor screws need independent engagement checking: compatible hole spacing does not prove M3×7 is safe in the selected motor.

No carts, orders or vendor messages were changed in this research. Report is saved locally, not committed.
