# Pre-checkout propulsion audit — 2026-09-20

Scope: selected F450 / X2212 multirotor / 4S6000 basket. Read-only research and calculations; no vendor contact, cart edits, purchase or powered test. Base commit `e760b7bdc83cf45f6089ea291b026856ad717557`; current BOM and Issue10 contain uncommitted decisions. Examined BOM SHA256 `a1614219b4c511c887521a40cec7de0c45eee7a080df71c20451c3930bda1c76`, Issue10 `b122693a71a90f56081c669cc004376fd7e30554f1aeb7e7fe2950bb0c27769e`.

## Recommendation

Keep the selected motor/battery as a credible staged-build candidate, subject to the parent mechanical/electrical review. Keep the manufacturer-matched prop rather than substituting an apparently similar hub. Do not present the selected prop as an identified match to the thrust chart, or this basket as a proven ten-minute complete product. No researched drop-in change demonstrably purchases an endurance margin inside the roughly $60 remaining.

The useful-duration requirement is **10 minutes excluding takeoff and landing**, from Issue10's current checkpoint. Eleven minutes and larger historical durations are explicitly superseded. The 2.45-minute equivalent recovery allowance is our engineering assumption; it is not an owner-required fixed value or measured emergency capability.

## Revalidated facts

- [Exact X2212 multirotor motor](https://sunnyskyusa.com/products/sunnysky-x2212-brushless-motors-new): 980KV, 3–4S, 56g, built-in-nut prop required, no accessory supplied. Chart marked9450; at16.5V400/500g need56/74W, at14.8V53/73W, at12.5V51/69W. Maximum tabulated thrust is1440g at16.5V/19.5A,1230g at14.8V/16.8A,930g at12.5V/13A. These are isolated motor data, not installed flight acceptance. Do not confuse the fixed-wing/V3 X2212 pages with this SKU.
- [Motor drawing](https://cdn.shopify.com/s/files/1/2024/0305/files/2212_7407c954-fd6c-459b-9f62-5b952dc0ac63.jpg?v=1553485455), visually inspected and retained as [drawing](x2212-multirotor-dimensions-2026-09-20.jpg):16×19mm M3 holes,2.8mm depth; M6×1 prop shaft and7.85mm shoulder. Screw length must account for actual arm thickness and leave bottoming clearance; included M3×7 cannot be accepted without measuring. Aim2.0–2.5mm engagement as an assembly target, then verify secure seating and free motor rotation; this target is engineering judgment.
- [Selected prop](https://sunnyskyusa.com/products/sunnysky-multirotor-9450-propellers-cw-ccw-rotation-pair-fit-a2212-x2212-multirotor-motors): title9045, description9in×4.5in, SKU SS-Prop-9450, variant31969157021790, $2.99 per CW/CCW pair; explicitly fits X2212 multirotor. Two pairs supply four rotors. That resolves mounting at documentation level, not test-chart identity. Retain a conservative240mm swept diameter envelope until measured.
- [Exact CNHL600654BKEC5](https://chinahobbyline.com/products/cnhl-black-series-6000mah-14-8v-4s-65c-lipo-battery-with-ec5-plug):6000mAh4S,EC5,JST-XH,620±5g,44×45×155mm **with a stated1–5mm dimensional difference**. Budget625g and reserve at least49×50×160mm before padding, strap, cable bend and connector. Nominal88.8Wh is arithmetic, not measured delivered energy. US listing says1–2working-day dispatch plus3–7delivery; exact checkout governs.

## Reproduced energy screen and sensitivity

Our assumptions:80% of nominal88.8Wh usable;40W battery-side electronics/lighting;20% added propulsion power for installation/workload;0.5minute takeoff×1.3load and1.5minutes recovery/landing×1.2load. The resulting2.45 equivalent minutes are subtracted after energy/power division. No wind, forward-flight drag, battery aging, temperature or installed efficiency measurements exist.

`P = 1.2 * 4 * (56 + (mass_g/4 - 400)*0.18) + 40`

`useful_minutes = 0.8 * 88.8 * 60 / P - 2.45`

| Ready-to-fly mass | Modeled power | Useful minutes |
| --- | ---: | ---: |
|1650g|319.60W|10.89|
|1707g current allocation|331.91W|10.39|
|1710g design target|332.56W|10.37|
|1750g|341.20W|10.04|
|1800g|352.00W|9.66|

The mathematical ten-minute boundary is1755.4g under these assumptions. Thus1710g is a prudent target, not a fundamental lift ceiling; it still offers little uncertainty margin. At1707g, changing only usable energy to75% yields9.59minutes; changing only propulsion penalty to25% yields9.94minutes. An extra50g of landing gear/mounts uses essentially all modeled duration margin. Extra budget must not be mistaken for extra mass allowance.

Using the lower14.8V chart's hover-region interpolation gives320.08W and10.87minutes at1707g;12.5V gives307.91W and11.39minutes with all other assumptions artificially held constant. These are sensitivity calculations, **not a reason to discharge the4S pack to12.5V or expect increasing usable energy**. The16.5V curve is conservative compared with these lower-voltage hover points, while maximum thrust decreases with voltage. Raw four-motor thrust/weight ratios are3.37,2.88 and2.18 respectively; they are uninstalled theoretical ratios and do not include inflow, control reserve, heat or sag.

The current allocation includes40g printed mounts and100g lighting, both unweighed. Target saving50–60g through measured lightweight brackets/retained stock gear when physically feasible. Do not remove required mission hardware to manufacture a paper pass. The model contains a propulsion penalty but no proven bound on the prop identity error; avoid describing it as conservative for every unknown.

## Alternative check and spending decision

[SunnySky EOLO1038](https://sunnyskyusa.com/products/eolo-10-x-3-8-propeller), variant44558311096559, costs$4.99/pair, is in stock and explicitly fits this multirotor shaft. The manufacturer links it as recommended. Two pairs cost$4 more than the selected pair set. It is254mm diameter, reducing adjacent rotor gap to about64mm on450mm diagonal geometry. No exact matching4S X2212/EOLO1038 curve was found; larger diameter alone does not establish efficiency or acceptable full-throttle current. Do not substitute as an untested energy fix.

[MyFPV genuine DJI9450 pair](https://www.myfpvstore.com/drone-propellers/dji-phantom-2-9450-self-tightening-propeller-1cw1ccw-set-of-2/) is a domestic stocked lead at$13.99/pair. Two pairs add$22 merchandise plus new freight over SunnySky. [DJI's original9450 data](https://www.bhphotovideo.com/lit_files/109912.pdf) specifies9.4×5in and its own DJI motors. No primary exact X2212 hub/shoulder fit confirmation was located. A label matching9450 would still not establish the SunnySky chart's brand/blade. [B&H E3059450](https://www.bhphotovideo.com/c/product/1164703-REG/dji_cp_ep_000085_9450_self_tightening_propeller_for.html/overview) is2–4week special order and expressly does not assure third-party motor compatibility. Reject as a replacement. [HiModel's SunnySky9450](https://www.himodel.com/multi_rotors/Sunnysky_9450_Self-lock_Propeller_Set_CW_CCW.html) is an old listing with no established domestic stock/delivery; also not a justified reroute.

Do not buy a larger/heavier battery speculatively. Preserve the roughly$60 for demonstrated mounting/wiring needs and final tax. One additional matched prop pair is a sensible optional$2.99 spare, but not an endurance upgrade or required installed mass; no change made here.

## Returnability and physical acceptance

[SunnySky return policy](https://sunnyskyusa.com/pages/return-and-warranty):30days from receipt with prior RMA; new original-packed goods incur no restocking, otherwise10–50% depending on condition; damaged nonwarranty goods excluded and shipping not refunded. Motor warranty excludes overload/crash and wear components. This corrects the earlier claim that SunnySky change-of-mind terms were not established. It is not free flight-trial insurance.

Before irreversible soldering/installation: weigh major parts and dimensional mock-ups, confirm motor bolt/prop seating, full battery envelope, connector routes and printed-mount mass. Recompute the complete mass budget if gear changes. The unresolved chart-to-prop identity blocks a guarantee of mission endurance, not the manufacturer's explicit mounting compatibility. If the owner requires ten minutes demonstrated before buying, research cannot supply it; purchase must be presented as staged development with this remaining risk.

Before flight acceptance: safely instrument exact motor/prop/ESC thrust and power at relevant loaded voltages, qualify temperature and startup behavior, then measure installed whole-battery power with representative Pi/lights and actual mission workload. Require at least ten useful minutes plus measured recovery/landing allowance without crossing tested battery limits, repeatedly. No full-throttle static endurance run is prescribed; manufacturer peak-current data is not a continuous thermal qualification.
