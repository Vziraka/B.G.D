# Endurance and cargo directions after Q54

> **Decision update through Q58 — 2026-08-30:** The user requires intended-recipient face verification before cargo release, protection against ordinary manual removal before verification, and a landed, motors-stopped handoff for the first delivery version. It then stays disarmed for someone to carry the drone back. References below to pending delivery scope describe the research-time state. No holder/release hardware, cargo limit, force/theft resistance or budget fit is established. The evidence below is unchanged. See [ticket 10's latest comments](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments).

Checked **2026-08-30** in the main checkout, branch `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. This is new, uncommitted research; that commit does not contain it. No purchase, installation, implementation, battery construction, physical test or flight occurred. The handoff includes this report's SHA-256 because it is not committed. Existing unrelated changes were preserved.

## Finding

**Higher-energy Li-ion packs materially improve the energy screen, but neither direction establishes the complete $600/$800 build, twenty useful minutes plus reserve, or a safe delivery capacity.** The 6000mAh direction adds only about 61g versus the previous pack while providing substantially more nominal energy. The 8000mAh direction offers still more energy but adds about 305g, consuming weight allowance that could otherwise support equipment or cargo. Both cost more than the prior pack; battery substitution alone worsens the previous incomplete project's cost.

Q54 keeps delivery without requiring an intended object. Cargo type and capacity remain open; 3lb is tentative. The accepted endurance reference remains **twenty useful minutes with camera/computer installed and no extra delivery cargo, followed by a separate protected return-and-landing reserve**, within the provisional 100m radius. No cargo example below is a proposed cap, demonstrated capability or replacement endurance requirement. All requested features and the complete-build accounting boundary remain.

## Two bounded battery directions

`6S2P` means six groups in series, with two cells in parallel per group. It does not itself establish a pack current rating. Prices are displayed USD and not destination-specific landed quotes.

| Direction | Listed mass | Nominal energy basis | Displayed price, one / two packs | Sourcing and electrical limit |
| --- | ---: | ---: | ---: | --- |
| Reference only: CNHL 3300mAh 6S LiPo | 535g ±5g | 22.2V × 3.3Ah = **73.26Wh** | $44.99 / $89.98 | Exact US variant unavailable in the earlier same-day check; no fresh availability confirmation obtained here |
| **A: Flywoo Explorer Molicel P30B 18650 6S2P 6000mAh**, FW19003600 | **596.2g** | Store voltage gives 133.2Wh; **129.6Wh** from twelve manufacturer-rated 10.8Wh cells is used below | **$89.99 / $179.98** | XT60; page describes 35A as peak, specifications merely say 35A. Do not assume 70A continuous. Stock rendering contains both availability and sold-out text; delivery not established |
| **B: iFlight Fullsend 6S2P 8000mAh Li-ion**, Pro1914 | **840g ±10g** | Manufacturer lists **177.6Wh**, 22.2V | **$83.99 / $167.98** | XT60H-F; page says in stock. Latest stated revision uses EVE 40PL cells and lists 17.5C, but older Q&A names other cells; confirm supplied revision and pack current envelope |

Sources: [prior exact CNHL check](seven-inch-propulsion-after-q53.md), [Flywoo pack](https://www.flywoo.net/products/flywoo-explorer-molicell-p30b-18650-6s2p-6000mah-lionpack-battery), [iFlight pack](https://shop.iflight.com/Fullsend-6S-8000mAh-Li-Ion-Battery-Pro1914).

Calculated nominal pack energy per mass is approximately **137Wh/kg** for the old LiPo, **217Wh/kg** for A using cell-based typical energy, and **211Wh/kg** for B using its listing. These compare nameplate energy density, not usable flight energy or complete-aircraft efficiency. A's smaller total energy comes with slightly better nominal energy per battery mass than B on these mixed but explicitly identified bases.

The P30B cell manufacturer's Version 1.0 sheet specifies **3.6V nominal, 10.8Wh typical, 10.4Wh minimum and 30A continuous with an 80°C cutoff**. Its product page separately advertises 36A. Neither cell number validates the assembled pack's wiring, cooling or duty cycle. Twelve typical/minimum cell energies total 129.6/124.8Wh before assembled-pack losses and the mission's usable endpoint. A datasheet's low-voltage discharge endpoint is not a safe landing threshold. [Molicel datasheet](https://www.molicel.com/wp-content/uploads/Product-Data-Sheet-of-INR-18650-P30B-80111-1.pdf), [Molicel product page](https://www.molicel.com/product/inr-18650-p30b/)

For B, multiplying the advertised 17.5C by 8Ah gives 140A arithmetically; **that is not a verified continuous operating allowance or approval to draw that current through this installation**. The revision discrepancy and absence of a checked assembled-pack discharge/thermal curve remain procurement and engineering gates. Its stated dimensions are 42×64×147mm; retention, frame clearance and centre of gravity need checking. [iFlight specification and revision history](https://shop.iflight.com/Fullsend-6S-8000mAh-Li-Ion-Battery-Pro1914)

These are factory-built pack candidates, not a recommendation that a novice assemble cells. Charger support, voltage range, current monitoring, low-voltage behavior, thermal limits and appropriate handling need confirmation before selection. No storage/charging or flight settings are selected.

## Matched 7-inch propulsion evidence and its limits

Retain the earlier exact **EMAX ECO II 2807/1300KV** table, with **HQ 7×3.5×3** at 25.2V, 300g thrust and 52.92W per motor, or **211.68W for four static test points**. The **Gemfan 7042 two-blade** table gives 300g/55.44W and 500g/100.8W per motor. These points were visually checked in the [preceding report](seven-inch-propulsion-after-q53.md); this round reopened the [EMAX-branded, distributor-hosted PDF](https://evelta.com/content/datasheets/449-0101096022.pdf). Test revision, ESC and voltage-dependent performance remain unknown. No interpolation, constant-power extrapolation or maximum-thrust payload estimate is treated as validation.

A currently listed matching **nominal designation** is HQProp **DP7X3.5X3GR-PC**, $3.59 per four-prop set, 8.8g per prop, 5mm shaft hole; the official listing shows stock in China. This is not the separately named V1S prop. Three sets would be $10.77 before delivery, **replacing**, not supplementing, any three-set prop allowance in another ledger. The old motor table does not identify this retail SKU/revision, so exact test-to-purchase identity is still unconfirmed. [HQProp listing](https://www.hqprop.com/https-hqprop-7x35x3-light-grey-2cw2ccw-poly-carbonate-p0320.html)

The prior same-day check found the EMAX 1300KV US variant unavailable. The commerce endpoint could not be freshly retrieved through the web tool in this round; no current stocked motor route is asserted. A 1500KV replacement cannot inherit these numbers.

## Energy screen with the installed equipment retained

Use the same **illustrative**, unmeasured non-battery mass of **763.4g** from the previous report: frame 173g, four motors 190.4g excluding wires, camera/computer allowance 250g, and remainder 150g. Replacing only the battery gives 1359.6g for A and 1603.4g for B. Every installed sensor, mount, prop, wire and delivery mechanism must eventually appear once in a measured mass ledger; this allowance does not prove all retained features fit.

For a twenty-minute useful segment:

`allowable average whole-aircraft power = 3 × (usable fraction × nominal Wh − reserve Wh − pre-segment Wh)`

| Pack | All nominal energy, zero reserve (unrealistic ceiling) | Illustrative 80% usable, 10Wh reserve, zero pre-segment consumption | After additionally allocating an illustrative 15W to electronics |
| --- | ---: | ---: | ---: |
| Previous 73.26Wh LiPo | 219.78W | 145.82W | 130.82W propulsion |
| A, cell-based 129.6Wh | 388.80W | **281.04W** | **266.04W propulsion** |
| B, listed 177.6Wh | 532.80W | **396.24W** | **381.24W propulsion** |

All values are calculations, **not power measurements or flight times**. The 80%, 10Wh and 15W assumptions are not approved settings or proven sufficient reserve/workload. For A, using the cells' minimum 124.8Wh instead would reduce the middle value to 269.52W. Pre-segment energy and larger real electronics demand reduce these allowances further.

The 211.68W documented HQ reference is at a total 1200g static thrust, below either illustrative aircraft mass. It cannot prove either candidate fits its power allowance. Conversely, the larger nominal-energy packs mean the earlier 73.26Wh shortfall cannot establish that every Li-ion redesign fails. Needed evidence is battery-side power under the actual mission, across state of charge, with complete installed mass, protected recovery energy and maneuver/control margins. Current increases as voltage falls for the same electrical power; a comfortable nominal-voltage average does not establish transient current or end-of-flight capability.

## Cargo screening examples only

These figures add cargo to the illustrative mass; they exclude **additional** cargo packaging, retention/release hardware or changes in drag and balance. Thrust per rotor is simply total mass divided by four for level static equilibrium. It is not a motor command, permitted takeoff mass or safe carrying limit.

| Added example cargo | A: mass / static equilibrium per rotor | B: mass / static equilibrium per rotor |
| --- | ---: | ---: |
| **0g — accepted endurance reference** | 1359.6g / 339.9g | 1603.4g / 400.9g |
| 250g, analytical example | 1609.6g / 402.4g | 1853.4g / 463.4g |
| 500g, analytical example | 1859.6g / 464.9g | 2103.4g / 525.9g |
| 1361g, rounded tentative 3lb example | 2720.6g / 680.2g | 2964.4g / 741.1g |

No row supplies a loaded endurance claim. The 3lb example nearly doubles A's illustrative flying mass and increases B's by about 85%; it warrants materially different scrutiny from a 250g example. None is approved or ruled impossible by this arithmetic. Retention/release reliability, centre of gravity, attitude control, structure, motor saturation, power and recovery margins require separate evidence.

At handoff, Q55 is pending on whether delivery still requires recipient face verification before release or only transport. The original requested verification/release scope remains until the user answers; no transport-only simplification or hardware saving is adopted here.

## Cost consequences and next decision

Keeping the previous **two-pack accounting assumption** for comparison, A adds **$90**, and B adds **$78**, versus two $44.99 LiPos. Applying only those substitutions to the earlier incomplete $857.87–$868.87 ledger gives **$947.87–$958.87 for A** or **$935.87–$946.87 for B**, before reconciling props, other substitutions, shipping/tax and missing features. Those are not minimum achievable prices or selected packages. The lower price of B does not establish a better installed design; its extra 243.8g over A changes the power and cargo problem.

**Engineering priority:** investigate A first for the smaller mass penalty, while retaining B as the larger-energy comparison, and combine either only with a genuinely complete revised cost ledger. Neither should be presented as a purchase recommendation or a demonstrated endurance solution.

**Defensible next user tradeoff once the whole ledger is available:** whether to prioritize preserving twenty useful minutes on the selected 7-inch platform while accepting only a separately validated cargo capacity, or reopen an existing requirement if a complete fit cannot be substantiated. Do not ask the user to guess current limits, reserve energy or a cargo number; do not make them select a battery before the current/stock/installed-data gaps are resolved. The fixed $800 maximum remains unless explicitly changed, and delivery is not removed while its safe capacity is unresolved.
