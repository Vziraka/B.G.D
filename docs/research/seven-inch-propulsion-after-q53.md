# Seven-inch propulsion after Q53 — bounded evidence update

Checked **2026-08-30**. Main checkout, branch `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. This new, uncommitted report is not part of that commit, an approved purchase list, or a flight-test result.

## Finding and scope

**Exact 7-inch, low-thrust manufacturer data were recovered, but no currently purchasable, endurance-qualified direction was established.** One conditional direction is retained below; the bounded search did not justify inventing a second. Its checked US motor and battery variants are unavailable. At a documented reference thrust, propulsion alone already uses essentially the larger pack's entire nominal 20-minute energy budget.

[Q53](../../.scratch/biometric-guard-drone/issues/10-milestone-ladder.md#comments) establishes a **$600 complete-build goal and conditional $800 absolute maximum**, with later wear/repairs separate. All requested capabilities remain. The reference mission remains at least 20 useful minutes of walking-follow/stops/hover, plus a separate return-and-landing reserve, initially within 100m, in dry/daylight/calm conditions, with future camera/computer and necessary hardware installed, **without extra delivery cargo**. Neither a final cargo limit nor a reduced endurance target is selected. Two new LiPos fund separate sorties, not twice the airborne energy. M1, the owner all-arming gate and independent emergency manual control are unchanged.

## One conditional component direction

Prices below are listed USD, before shipping/tax, not deliverable quotes or spending approval. Availability is exact-variant metadata, not the product-family default.

| Component | Current listing and mass evidence | Conditional initial cost |
| --- | --- | --- |
| Four EMAX ECO II 2807 **1300KV**, SKU `ECO228071300` | $19.49 each; **unavailable** at EMAX USA. Datasheet: 47.6g each **without silicone wire**; 3–6S. Do not substitute the stocked 1500KV winding under these data. | $77.96 |
| Two new CNHL **330406Z US**, 3300mAh 6S 40C, XT60 | $44.99 each; **US unavailable**. EU available, but US deliverability/landed cost not established. Specification: 22.2V, 535g ±5g, 44×46×137mm. | $89.98 |
| Gemfan **7042 two-blade** propeller | Exact nominal propeller designation in the motor table; current Flash SKU/revision still needs matching to that test. Three sets are costed **only in the aircraft/ground ledger**. | Not duplicated here |

**Motor-plus-two-pack subtotal: $167.94**, conditional on unavailable listings; not a complete project basket. Sources: [EMAX exact variant data](https://shop.emax-usa.com/products/eco-ii-2807-brushless-motor-1300kv-1500kv-1700kv.js), [CNHL exact warehouse variants and specification](https://chinahobbyline.com/products/cnhl-3300mah-22-2v-6s-40c-lipo-battery-with-xt60-plug.js), and [EMAX-branded datasheet, pages 6–7](https://evelta.com/content/datasheets/449-0101096022.pdf).

CNHL's commerce metadata contains a different weight field (514g); this calculation uses the explicit 535g physical specification, not a claimed weight saving. Battery retention, clearance, centre of gravity, connectors and installed compatibility remain unchecked.

## What the new data support

The **EMAX-branded, distributor-hosted** PDF was visually inspected, including its complete specification and 1300KV table pages. Its test/revision date and test ESC are not established. Selected single-motor static results follow; these are not complete-aircraft measurements:

| Motor / exact listed prop | Voltage | Thrust | Current | Electrical power |
| --- | --- | --- | --- | --- |
| ECO II 2807/1300KV / Gemfan 7042 two-blade | 25.2V | 300g | 2.2A | 55.44W |
| Same | 25.2V | 500g | 4.0A | 100.80W |

[Manufacturer-branded test table, PDF page 7](https://evelta.com/content/datasheets/449-0101096022.pdf). This improves the earlier missing low-thrust/7-inch evidence, but does not validate a different winding, propeller, ESC, declining battery voltage or assembled workload. The earlier NIDICI 7.5-inch table remains unsuitable for validating this 7-inch combination.

For mass context, the [TBS Source One V6 7-inch DC specification](https://www.team-blacksheep.com/products/prod:source1v6) lists 173g. Adding four bare-wire-excluded motors and one 535g pack gives **898.4g before other equipment**. Retaining the earlier *unverified* 250g camera/computer allowance and an *illustrative* 150g remainder gives **1298.4g**, or approximately **325g thrust per rotor** in level hover. The remainder must include motor wires and all non-overlapping flight hardware; these allowances are not measured installed masses. Required sensors, cooling, gimbal, video hardware and mounts cannot disappear into an unlimited allowance. No interpolation is treated as a validated 325g operating point.

## Energy screening, not an achieved endurance claim

The pack's calculated nominal energy is `22.2V × 3.3Ah = 73.26Wh`. For a 20-minute useful segment:

`maximum average battery power = (u × 73.26Wh − reserve Wh − pre-segment Wh) / (20/60h)`

`u` represents the usable fraction before a suitable battery endpoint; it is unknown. The examples deliberately omit pre-segment consumption:

| Scenario, not approved settings | Maximum whole-aircraft average power |
| --- | --- |
| Every nominal Wh consumed; zero reserve | 219.78W |
| Illustrative 80% usable; 5Wh protected reserve | 160.82W |
| Illustrative 80% usable; 10Wh protected reserve | 145.82W |

Four documented 300g points imply **221.76W** at **1.2kg static-equivalent thrust**, or **73.92Wh over 20 minutes**. That reference point alone exceeds the pack's nominal energy by 0.66Wh, before electronics or any reserve. This comparison signals inadequate margin in this scenario; it is **not** proof of complete-drone flight time, the exact 1298g aircraft's consumption, or impossibility of every 7-inch design.

**Gemfan is not the best published point or a bound on all propellers.** The same table lists **HQ 7×3.5×3 three-blade** at 300g, 2.1A and **52.92W**: four imply **211.68W**, or **70.56Wh over 20 minutes**. That leaves **2.70Wh of nominal energy before electronics and reserve**, not a validated recovery margin. This modest improvement does not demonstrate the installed mission; the exact current HQ SKU and availability remain unverified. [EMAX-branded table, page 7](https://evelta.com/content/datasheets/449-0101096022.pdf)

Camera/compute, regulators, cooling and video add battery-side demand. An illustrative 15W combined allocation would leave only **130.82W** for propulsion in the 80%/10Wh scenario; 15W is not measured application power. Wind, forward-flight effects, activity mix, usable capacity and recovery energy remain unknown. Neither 80% nor 5/10Wh is an approved cutoff or sufficient reserve. A 100m radius alone does not determine return/landing energy.

## Search boundary and next evidence gate

The second bounded motor check was [iFlight XING 2806.5/1300KV](https://shop.iflight.com/xing-x2806-5-fpv-nextgen-motor-pro1001). Its [manufacturer test sheet](https://shop.iflight.com/image/catalog/TEST%20REPORT/XING-2806.5-1300KV.png) has a lowest listed Gemfan 7040 thrust of 593g, above this loaded-hover region. It was not promoted to a second qualified direction or extrapolated downward. No Li-ion, 7.5/8-inch propeller, smaller payload or shorter mission substitution was made.

Next establish a procurable exact pairing, a complete installed mass/power ledger, suitable low-thrust data across battery voltage, and usable-energy/recovery margins. Static evidence screens candidates; it cannot prove walking/hover endurance and safe reserve. Final delivery-item intent is a separate user constraint affecting complete-build sizing; this no-extra-cargo reference does not settle it. No purchase, installation, configuration or physical test occurred.
