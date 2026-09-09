# Final propulsion optimization after the budget-cap removal — 2026-09-03

**Post-Q75 controlling update — 2026-09-03:** Q75 is approved and issue10 is **resolved as planning complete**, with Q74 unchanged. The [current hardware build package](../hardware/baseline-r1/README.md) records subsequent issue11 engineering. It exposes a genuine error: the selected$8 QS8-S item is a **two-pack series adapter**, not the assumed one-pack pigtail. Under the user's affected-subsystem authorization, R1.1 replaces only that interface with another genuine bare QS8 male and existing8AWG stock. Switch polarity, AHCT channel use and D500 cable reach are also corrected. The original1,897.251g/20.98min/$2,052.93 figures below are historical model/basket values, **not final R1.1 assembly totals**; see [mass/cost impact](../hardware/baseline-r1/mass-cost-impact.md). H01–H12 detailed engineering remains open; no purchase, fabrication or physical qualification is claimed. Dated pre-Q75 conclusions below do not override this update.

## Decision

**No presently documented, individually orderable configuration found in this bounded pass can be selected as both the lowest-cost build and a planning pass for every approved requirement.** Removing the budget ceiling does not repair the remaining engineering conflict. The existing 6S2P/XING/APC candidate is still the best fully specified near-candidate, but it predicts only **18.20 useful minutes in the established moderate-loss case**. It therefore must not be described as preserving the approved `>=20 useful minutes plus reserve` requirement merely because its central estimate is 20.98 minutes.

The exact near-candidate remains:

- four [iFlight XING-E 2809 800KV](https://shop.iflight.com/XING-E-2809-Cinelifter-Motor-Pro2064) motors;
- [APC 7x4E](https://www.apcprop.com/product/7x4e/) / [7x4EP](https://www.apcprop.com/product/7x4ep/) two-blade counter-rotating props, bought as two manufacturer `LP07040E-B4` bundles (one installed set and one complete spare set);
- one factory [Nexus 6S2P Molicel P50B](https://nexusbatterysystems.com/products/6s2p-p50b), ordered with QS8 female, 8AWG leads and the correct 6S balance connector;
- the existing coordinated QS8/8AWG/INA-BM/capacitor aircraft path.

The propulsion, battery and named main-path subtotal is **$430.17**: motors $127.96, two APC bundles $14.12, pack $252.00, aircraft QS8 $4.70, 8AWG wire $7.90, INA-BM $19.99 and capacitors $3.50. This updates prop purchasing from eight singles to two exact manufacturer bundles without changing airborne mass or the model. It is a price optimization, not an endurance fix.

## Requirements held fixed

This review retains the seven-inch self-build, all installed compute/camera/navigation/video/sensing and independent-radio equipment, recipient face verification, removable protected holder, landed motors-stopped handoff and disarmed carry-back behavior. Reference endurance is the approved Q74 no-extra-cargo workload: twelve minutes walking follow at 1–2m/s, six minutes hover/stops and two minutes gentle transitions, dry daylight, 15–30°C, mean wind at most 2m/s, gust at most 3m/s, at most 100m away and 10m high. Reserve remains `max(20Wh, 1.5 * modelled 120-second recovery energy)` and may only increase after measurement.

The separate delivery case remains **250g cargo including packaging plus the 170g provisional holder allowance**. It must retain safe recovery/control authority; it does not inherit a twenty-minute endurance promise. No feature, contingency, reserve or cargo mass was deleted to make a result pass.

## Frozen mass and reference result

| Item | Installed planning mass |
|---|---:|
| Retained non-propulsion equipment and structure | 613.500g |
| XING motors, four | 244.000g |
| Installed APC props, four | 31.751g |
| Configured 6S2P P50B pack allowance | 930.000g |
| QS8/8AWG/INA/capacitor main path | 70.000g |
| IR sub-regulator | 8.000g |
| **No-cargo reference** | **1,897.251g** |
| Cargo plus holder | +420.000g |
| **Loaded reference** | **2,317.251g** |

The retained equipment figure includes the previously allocated structure, closures, full feature interfaces and 50g unallocated integration contingency. The configured pack figure is Nexus's approximate 900g plus 30g uncertainty; it is not an exact measured mass.

The [preceding reproducible model](least-cost-propulsion-2026-08-31.md) remains numerically valid for this unchanged airborne combination. APC's files are manufacturer-computed static aerodynamic data, not a matched bench test. The motor is represented by its published KV/interphase resistance and an explicit equivalent-circuit approximation. The coupled endpoint calculation uses Molicel's discharge graph and a `57.6mOhm` incremental pack/path sensitivity, not an asserted worst-case resistance.

| Case | Mission power | Endpoint-consistent usable energy | Reserve | Useful time | Planning status |
|---|---:|---:|---:|---:|---|
| Central, 1,897.251g | 354.54W | 148Wh | 20Wh | **20.98min** | Central pass only |
| Established moderate loss | 401.96W | 146Wh | 20.10Wh | **18.20min** | **Fails required planning sensitivity** |
| Loaded, 2,317.251g | 455.59W | 83Wh at its earlier endpoint | 22.78Wh | 7.40min | Model only; no 20min requirement |

At the no-cargo 19.6V/10A-per-cell reference-curve state, the weak motor/prop corner and all 4A coincident auxiliaries couple to 18.454V bus, 35.888A propulsion and 2,608.21g thrust: **1.375 thrust/weight** against the provisional 1.35 screen. Full charge gives 81.923A propulsion in the high-current corner; adding 4A auxiliaries and applying the retained 1.25 component-rating factor requires **107.404A**. That fits the lower QS8 maker rating of 110A and Nexus's 120A pack statement, with little connector rating margin. These are paper screens, not thermal or transient validation.

## Cheaper and larger-pack alternatives evaluated

### 5S2P P50B plus EMAX Pro 2810 950KV: cheaper but fails three independent gates

The exact [EMAX 950KV variant](https://shop.emax-usa.com/products/pro-series-2810-brushless-motor) is SKU `101099010`, variant `44377554059500`, $27.99 and available. The [Nexus 5S2P P50B](https://nexusbatterysystems.com/products/5s2p-p50b) is $210 and available, with 21V maximum, 750g approximate pack mass, 120A maker discharge statement and a configurable QS8/8AWG path. A conservative screening mass is **1,799.251g**, using a 780g configured-pack allowance and a 74g-per-motor allowance.

This combination is not selectable:

- the official EMAX commerce page does not publish the exact 950KV winding's resistance, mounting pattern, shaft geometry or installed mass; the detailed sheet encountered is manufacturer-branded but retailer-hosted, so exact mechanical/electrical compatibility is not established from first-party evidence;
- the high-current corner predicts 98.501A propulsion plus 4A auxiliaries; the retained rating rule requires **128.126A**, above both the 110A connector and 120A pack statements;
- using the same P50B graph method scaled to ten cells, the 3.2V/cell state provides about 129.28Wh after the 5% allowance. The weak coupled endpoint gives about 1.367 thrust/weight, yet central endurance is only **19.20 minutes** and the moderate case about **16.93 minutes**. Deeper discharge loses the 1.35 control screen.

### 5S3P P50B plus documented 900KV motor: current can fit, energy and control cannot intersect

The factory [Nexus 5S3P P50B](https://nexusbatterysystems.com/products/5s3p-p50b) is $315, available, 270Wh typical, 1,125g approximate, 116x71x72mm and rated 180A by the pack maker. A BrotherHobby Avenger 2810 900KV listing is $28.99, available, 65g with 25cm leads, M5 shaft and 19x19mm M3 mounting. A manufacturer-branded winding sheet hosted by a retailer gives 71.2mOhm and 0.8A no-load current; because that sheet is not first-party-hosted, these remain conditional model inputs.

At a 1,155g configured-pack allowance the no-cargo aircraft is **2,138.251g**. APC7x4 modelling predicts 385.46W centrally and 430.45W in the moderate case. The full-charge high-current corner plus auxiliaries requires **109.868A** after the 1.25 factor, barely below 110A. However, the coupled weak corner reaches 1.376 thrust/weight at 3.5V/cell with only about 138.84Wh usable and 17.88 central minutes; by 3.4V/cell energy rises to 162.24Wh and central time to 21.52 minutes, but thrust/weight falls to 1.307. There is no state where both the 1.35 control screen and twenty minutes pass. The loaded 2,558.251g case only barely reaches 1.354 at the very early 3.8V/cell state.

The same 5S3P pack with XING800 reduces full-command current, but weak-corner thrust/weight is only 1.141 even at 3.6V/cell for the no-cargo aircraft. It does not preserve recovery control or the loaded target.

### 6S3P P50B plus XING800: more nominal energy, but pack mass consumes it

The factory [Nexus 6S3P P50B](https://nexusbatterysystems.com/products/6s3p-p50b) is $378, available, 324Wh typical, 1,350g approximate and rated 180A by Nexus. With the same 30g configuration uncertainty, reference mass becomes **2,347.251g** and loaded mass **2,767.251g**.

Full-charge current remains acceptable at the existing 107.404A component-rating requirement. The coupled no-cargo weak corner is approximately 1.346 thrust/weight at the 3.5V/cell curve state, already just below 1.35; endpoint-consistent energy there is about 166.61Wh and central useful time only **18.07 minutes**. The established moderate mission power rises to 521.19W, so it misses by more. The loaded weak corner falls below 1.35 by the 3.8V/cell state. Increasing cell count without increasing rotor disk area therefore does not provide a valid escape from the energy/control coupling.

### Other current offers do not close the gap

| Offer | Why it is not selected |
|---|---|
| [MaxAmps 6S2P 12Ah](https://maxamps.com/products/li-ion-12000mah-6s2p-21-6v-battery-pack), $504, 259.2Wh, 874g | Attractive energy/mass, but the maker specifies only **36A continuous**, far below the 85.923A full-system corner. Connector choice cannot increase the pack rating. |
| [Lumenier NAV 6S 12Ah](https://www.lumenier.com/products/lumenier-nav-12000mah-6s-21700-lithium-ion-battery-xt90), $189.99, 1,402g | Maker page states 50A continuous/80A burst and XT90. Both fall below the retained continuous screen; its page also inconsistently prints 43.2Wh beside 12Ah/22.2V, so it is not a reliable energy basis. |
| Molicel P60B 6S2P concept | Molicel's current sheet specifies 21.3Wh minimum per cell, 75g and temperature-conditioned high current. Twelve cells would be 255.6Wh minimum nameplate before endpoint losses, a promising direction. This pass found **no MOQ-one, in-stock factory 6S2P pack with a documented complete discharge path, exact configured mass and price**. QueenBattery's listing was out of stock and stated MOQ 50. A cell sheet is not a purchasable aircraft pack. |
| APC7x5/7x6 with lower-KV BrotherHobby motors | Modelled variants can improve low-voltage thrust, but available documented motors add 60–150g, and examined current/endurance intersections still fail. The 7x5 XING corner previously required 125.561A after rating margin, above both QS8 110A and the 6S2P pack's 120A. No software throttle cap or unpriced custom connector was used to conceal that conflict. |

## What would constitute the least-cost corrective change

No price can honestly be attached to the corrective configuration until one of these two evidence packages exists:

1. an orderable 6S2P roughly 12Ah high-power factory pack with complete connector/lead/pack continuous rating at least 107.404A, exact configured mass near the current pack, price and an endpoint discharge curve at relevant current and temperature; or
2. a matched seven-inch motor/prop test demonstrating enough reduction in moderate mission power while retaining the 1.35 coupled endpoint and the 107.404A-or-lower complete-path screen.

For the current 148Wh endpoint, the twenty-minute equation permits at most about 372W with the 20Wh reserve floor; the established moderate case is 401.96W. At its own 146Wh allowance it must fall to roughly **370W**, about an 8% reduction, without dropping equipment or control authority. A candidate pack must be evaluated at the actual earlier control endpoint; quoting 255.6Wh or 259.2Wh nameplate alone is insufficient.

The practical procurement status is therefore **unselected**. The 6S2P/XING/APC/P50B basket is suitable for continued detailed design and test-fixture planning, but it is not acceptable as the final requirement-preserving hardware selection. Physical Q74 evaluation remains mandatory after a paper-qualified design exists; it cannot retroactively justify purchasing a paper-known moderate-case miss as the final configuration.

## Required physical acceptance evidence for any eventual selection

- exact installed mass and centre-of-gravity range with the configured pack, all reference equipment, the removable-holder interfaces and retained contingency;
- matched four-motor electrical/thrust mapping with the exact motor winding, APC lot, MicoAir firmware/settings and installed airflow from full charge through the proposed endpoint;
- constant-power pack discharge and recovery-pulse testing across the approved 15–30°C range, measuring group balance, bus sag, delivered Wh, connector/lead/joint/pack temperatures and post-load recovery;
- calibrated INA comparison against an external reference, including auxiliary peaks, motor acceleration and gimbal/lighting coincidence;
- endpoint control evidence at no-cargo and 250g-cargo-plus-holder mass, followed by the approved Q74 workload with at least three successful complete evaluations over at least two days per released pack.

These are acceptance gates, not novice flight instructions. Failed endurance, thermal, current, balance or control evidence requires redesign or an earlier endpoint; reserve and required features are not reduced.

## Provenance and reproducibility

Fresh read-only retrieval occurred on 2026-09-03. Repository base was `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. Working-tree changes outside this report pre-existed or were made by parallel tasks and were not modified here.

| Artifact | SHA-256 |
|---|---|
| Molicel P50B data sheet v1.1 | `867A4873B71A7C5B758BE83F8371DAF5CA5CB624675AC85B405DC227504DF20C` |
| Molicel P60B data sheet | `93CC57E072C62FBD5998A610B646806F93B1778677BAC99F60A6ECC810570D6A` |
| APC7x4E manufacturer performance file | `DA962147F34CDDEC145E8159B33C51080C6754F3443CCC4CAD281DABBF01C53C` |
| Fresh Nexus 6S2P page capture | `1F5AC6A18BCF62979D304334E2B5AE70C7B36E7B967DCDE9B86FD0C75C89E980` |
| Fresh Nexus 6S3P page capture | `C4C6D36C73827EB60A97327F62239812276A25E4317B5D98B8B1F4CFA83674B8` |
| Fresh Nexus 5S2P page capture | `6A2F1CC3399B03EBD6D1BDBF7A8748570CE664325060ECDBD54BFE3515E2304A` |
| Fresh Nexus 5S3P page capture | `95A1C2D313F9480FC7C1AD656CDA5D11184FF8527F563C3D037F6FAFF8638836` |
| Fresh iFlight store page capture | `4AC28526E88304350002E3C5005C4BF68BDE4948C6E210221088E4719DEF834A` |
| 5S screening script | `F57AD684A0233CCDACFC4821C0384F2DF14D86A2054D03AEB835F7C8232B0471` |
| 5S3P screening script | `36F8AE57BE53374ABFECAAD8446F73DFEE5D3D3B1BFEA81549E657FF1B890B74` |
| 6S3P screening script | `8994A613BE0DF785B1DFE01A64BE5F55B6EE0D2FCBD589D53F894833F2AD08D0` |

Primary sources: [Molicel P50B](https://www.molicel.com/wp-content/uploads/Product-Data-Sheet-of-INR-21700-P50B-80122.pdf), [Molicel P60B](https://www.molicel.com/wp-content/uploads/Product-Data-Sheet-of-INR-21700-P60B_80145.pdf), [APC RPM limits](https://www.apcprop.com/technical-information/rpm-limits/), [Nexus 6S2P](https://nexusbatterysystems.com/products/6s2p-p50b), [Nexus 6S3P](https://nexusbatterysystems.com/products/6s3p-p50b), [Nexus 5S2P](https://nexusbatterysystems.com/products/5s2p-p50b), [Nexus 5S3P](https://nexusbatterysystems.com/products/5s3p-p50b), [EMAX exact offer](https://shop.emax-usa.com/products/pro-series-2810-brushless-motor), [BrotherHobby Avenger2810 offer](https://www.brotherhobbystore.com/products/avenger-2810-motor), [BrotherHobby Avenger3110 offer](https://www.brotherhobbystore.com/products/brotherhobby-avenger-3110-730kv-900kv-motorcw-116), [MaxAmps 12Ah](https://maxamps.com/products/li-ion-12000mah-6s2p-21-6v-battery-pack), [Lumenier NAV12Ah](https://www.lumenier.com/products/lumenier-nav-12000mah-6s-21700-lithium-ion-battery-xt90), [QueenBattery P60B-family listing](https://queenbattery.com.cn/our-products/1330-6s2p-21700-moli-p42a-p45b-p50b-216v-22v-fpv-ua-rc-drones-uav-rpa-rpv-pa-battery-10ah-9ah-84ah-8400mah-9000mah-10000mah.html).

No purchase, supplier contact, battery modification, hardware operation or flight occurred.
