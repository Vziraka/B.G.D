# Loaded endurance feasibility — bounded hardware round

Checked **2026-08-30** against primary manufacturer sources. Authored in the main checkout on `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. This is new, uncommitted research, not content of that commit, an approved shopping list or a flight-test result.

## Finding and scope

**The examined hardware does not yet substantiate 20 useful minutes plus return-and-landing reserve.** The inexpensive 1500mAh pack has a demanding energy ceiling; the larger historical 3300mAh candidate carries substantially more energy but also more mass. Manufacturer motor data found for the lower-cost candidate do not cover the required propeller and low-thrust operating region. This is a missing-evidence finding, not proof that every 7-inch design must fail.

The requirement remains walking-pace following with occasional stops/hovering, dry/daylight/calm conditions, camera/computer installed, no extra delivery cargo, and an initial 100m outward radius. Return and landing do not count toward the 20 minutes. Exact weather limits, activity proportions and reserve remain unselected. These are later loaded-flight requirements, not autonomous-flight additions to manual M1. See [ticket 10](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

## Verified components versus unverified installed mass

The [TBS Source One V6 7-inch DC](https://www.team-blacksheep.com/products/prod:source1v6) manufacturer specification gives **173g**. The [iFlight NIDICI 2807/1300KV](https://shop.iflight.com/NIDICI-2807-FPV-Motor-Pro2314) specification gives **60.5g per motor including wire**, hence 242g for four. These nominal figures are not a weighed complete aircraft.

CNHL's published product descriptions provide the following specifications; the description fields were read through each manufacturer's product-data endpoint because the rendered page omitted portions of the specification:

| New LiPo candidate; one pack per sortie | Nominal voltage/capacity | Manufacturer mass | Calculated nominal energy |
| --- | --- | --- | --- |
| [MiniStar 1501206, 120C](https://chinahobbyline.com/products/cnhl-ministar-series-1500mah-22-2v-6s-120c-lipo-battery-with-xt60-plug.js) | 22.2V / 1.5Ah | 246g ±5g | 33.30Wh |
| [330406Z, 40C](https://chinahobbyline.com/products/cnhl-3300mah-22-2v-6s-40c-lipo-battery-with-xt60-plug.js) | 22.2V / 3.3Ah | 535g ±5g | 73.26Wh |

Their stated dimensions are respectively 33×54×80mm and 44×46×137mm, subject to the manufacturer's stated dimensional variation. The larger pack adds **289g**; placement, retention and centre of gravity need checking. Capacity and discharge ratings are manufacturer specifications, not measurements of usable energy, sag or thermal margin on this aircraft. No switch to Li-ion, parallel-pack installation or battery purchase is proposed.

Retaining the earlier **250g provisional allowance** for camera/computer installation gives partial masses of **911g / 1200g** respectively, before the remaining flight hardware. That allowance is not a verified installed mass or a free allowance for unlimited sensors. As an explicitly illustrative calculation, another **150g** for flight controller/ESC, receiver, navigation hardware, props, wiring and other non-overlapping fittings produces **1061g / 1350g**. The 150g is not a complete measured parts list; required equipment must not be omitted to hit it. Any required gimbal, avoidance sensors or extra installation hardware must be counted, without double-counting items already in the payload allowance.

## What the motor test actually supports

iFlight's [manufacturer test sheet](https://shop.iflight.com/image/catalog/TEST%20REPORT/NIDICI-2807-1300KV.png), linked in that product's “TEST REPORT” tab, specifies **HQ 7.5×3.7×3**, not a validated 7-inch propeller. Selected single-motor static results are:

| Throttle label | Test voltage | Current | Thrust | Electrical power |
| --- | --- | --- | --- | --- |
| 50% | 24.06V | 6.75A | 824g | 162.4W |
| 70% | 23.99V | 17.29A | 1539g | 414.8W |
| 100% | 23.83V | 40.28A | 2602g | 959.9W |

The illustrative aircraft masses require approximately **265g / 338g per rotor** in level hover, well below the sheet's lowest tested point. **Do not linearly extrapolate that curve, equate transmitter throttle with thrust, or assume the 7.5-inch prop fits the selected frame.** Low-thrust data for the exact 7-inch motor/prop/ESC combination and battery-voltage range remain missing. The sheet's roughly 24V tests also do not independently establish the complete system's full-charge 6S compatibility. The checked [EMAX ECO II 2807 page](https://shop.emax-usa.com/products/eco-ii-2807-brushless-motor-1300kv-1500kv-1700kv) did not supply a usable numerical low-thrust curve in this bounded review; no substitute motor was selected.

## Energy-budget scenarios, not an approved reserve

For a 20-minute useful segment:

`maximum average useful-segment battery power = (u × nominal Wh − protected reserve Wh − pre-segment Wh) / (20/60 hours)`

Here `u` is the fraction available before the chosen battery endpoint, not assumed physical capacity. Actual energy must eventually be measured by integrating loaded voltage and current. The table deliberately sets pre-segment consumption to zero, making the comparison optimistic. **80%, 5Wh and 10Wh below are sensitivity assumptions, not safe cutoffs, sufficient reserves or approved settings.**

| Pack | Entire nominal energy over 20min, no reserve: mathematical ceiling only | Illustrative u=80%, reserve=5Wh | Illustrative u=80%, reserve=10Wh |
| --- | --- | --- | --- |
| 1500mAh | 99.9W | 64.9W | 49.9W |
| 3300mAh | 219.8W | 160.8W | 145.8W |

These are whole-aircraft battery-power limits, **not predicted motor draw or flight time**. Raspberry Pi reports roughly **12W peak under its most intensive Pi 5 workloads**, not an average for this vision application; a PSU's rating is not consumption. Camera draw, cooling, regulators and other electronics require workload measurement. The checked [Camera Module 3 brief](https://datasheets.raspberrypi.com/camera/camera-module-3-product-brief.pdf) does not specify application power. [Pi 5 manufacturer discussion](https://www.raspberrypi.com/news/introducing-raspberry-pi-5/)

For example only, allocating 15W at the battery to all non-propulsion electronics in the 10Wh-reserve scenario leaves **34.9W / 130.8W** for four motors and ESCs. Neither allocation nor achievable propulsion efficiency is established. The 100m radius alone cannot determine return energy: route, speed, height, approach, wind and uncertainty still matter.

## Next evidence gate

Obtain an exact compatible propulsion candidate with low-thrust electrical data; complete its installed mass/power ledger; then compare usable-energy and reserve scenarios without hidden omissions. Static bench data can screen candidates but cannot demonstrate the walking/hover workload, repeated safe landing or the final reserve. Staged, safe physical validation belongs after a suitable plan and equipment exist; no test was conducted here. The $600 lifetime ceiling, all requested capabilities, owner all-arming gate and independent emergency manual control remain unchanged. A measured or evidenced shortfall requires an explicit user decision, not weaker requirements.
