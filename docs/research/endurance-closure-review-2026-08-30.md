# Endurance and cargo closure review — 2026-08-30

Researched in the main checkout, branch `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`. This is new, uncommitted research, not part of that commit, a purchase specification, a safety approval or a flight-test result. Only this report was written by this research task. The latest user instruction permits an **$800–$900 planning range, with $900 as the complete initial-project ceiling**; older $600/$800 figures in source reports are historical. All M1–M5 initial equipment and integration costs remain inside that boundary.

## Finding

**None of the existing candidates can yet be selected as an endurance-qualified, fully costed build.** A higher-energy factory-built pack remains a defensible candidate for further engineering comparison. It does not establish twenty useful minutes with a separate reserve, safe cargo capacity, or a complete fit under $900. The exact motor with the best available matched evidence is still unavailable from its checked first-party US listing.

Physical performance cannot be proven before a representative aircraft exists. Planning can still finish an explicit, conditional design and validation plan if the user accepts that risk. It cannot turn missing performance evidence into an achieved requirement, call a partial ledger complete, or silently remove the current ticket's hardware/shopping-list gate. A separate PC-only planning handoff is a reasonable **proposal**, described below, not a decision made by this report.

The retained aircraft is a self-built 7-inch quad. The reference is at least twenty useful minutes of walking-follow/stops/hover with future camera/computer and required installed equipment, followed by a separate protected return/landing reserve, initially within 100m in dry, calm daylight. No extra delivery cargo is included in this endurance reference. Delivery remains required, with recipient face verification, protection against ordinary manual cargo removal, removable equipment fitted/removed while disarmed, landed/motors-stopped handoff and disarmed physical collection afterward. No cargo item or capacity is imposed.

## What the primary evidence actually supports

| Evidence | Recheck and implication |
| --- | --- |
| EMAX ECO II 2807/1300KV | First-party commerce data retrieved directly on this date: SKU `ECO228071300`, $19.49, `available:false`. The 1500KV variant is available but cannot inherit the 1300KV test results. [Exact variant data](https://shop.emax-usa.com/products/eco-ii-2807-brushless-motor-1300kv-1500kv-1700kv.js) |
| Matched low-thrust motor data | The EMAX-branded, distributor-hosted PDF was retrieved again; its HQ7×3.5×3 point previously visually checked in the [propulsion report](seven-inch-propulsion-after-q53.md) is 300g, 25.2V, 2.1A and 52.92W per motor. Four such points total 211.68W at 1.2kg static-equivalent thrust. Test date, ESC, exact retail prop revision and behavior at declining pack voltage remain unestablished. [Manufacturer table, PDF page 7](https://evelta.com/content/datasheets/449-0101096022.pdf) |
| Flywoo P30B 6S2P6000 | Rechecked listing: $89.99, 596.2g, XT60, with 35A described as peak in the narrative and simply as discharge performance in specifications. The current rendering shows Add to cart, not a destination-specific delivery guarantee. [Pack listing](https://www.flywoo.net/products/flywoo-explorer-molicell-p30b-18650-6s2p-6000mah-lionpack-battery) |
| iFlight Fullsend 6S2P8000 | Rechecked listing: $83.99, in stock, 177.6Wh, 840g ±10g, 42×64×147mm. It lists 17.5C and an EVE40PL revision, while older Q&A names other cells. Confirm supplied revision and assembled-pack limits; a C-rating multiplication is not validated installation current capacity. [Pack listing](https://shop.iflight.com/Fullsend-6S-8000mAh-Li-Ion-Battery-Pro1914) |

For the P30B pack, twelve cells at the manufacturer sheet's typical 10.8Wh give **129.6Wh**; its minimum 10.4Wh gives **124.8Wh**, before pack losses and the mission's usable endpoint. The listing's 22.2V×6Ah would instead give 133.2Wh. Use the explicitly identified cell-based figure for comparison, not a mixture of favorable bases. Cell ratings do not qualify the complete pack's wiring, thermal behavior or safe landing endpoint. [Molicel Version 1.0 cell sheet](https://www.molicel.com/wp-content/uploads/Product-Data-Sheet-of-INR-18650-P30B-80111-1.pdf), [preceding battery analysis](endurance-cargo-options-after-q54.md)

No larger platform was selected or re-priced in this bounded pass. The [preceding platform comparison](payload-platform-options-2026-08-30.md) supplies no transferable endurance/carrying qualification for this 7-inch build. Published maximum hover and peak thrust are not this mission's reserve or cargo evidence.

## Transparent mass and energy accounting

Retain the **illustrative, unmeasured** 763.4g non-battery allowance from the prior report: 173g frame, 190.4g motors excluding wires, 250g camera/computer allowance and 150g remainder. This is not a completed equipment ledger. Every required propeller, wire, sensor, regulator, cooling part, mount and permanent delivery interface must eventually be accounted for once. The removable holder can be absent from normal reference flights under Q65; retained interfaces and required mission equipment cannot disappear.

| Pack comparison | Illustrative no-extra-cargo mass | Nameplate/cell energy used | Absolute average-power ceiling for twenty minutes if every quoted Wh were consumed and reserve were zero |
| --- | ---: | ---: | ---: |
| Previous CNHL3300 6S LiPo, 535g | 1298.4g | 73.26Wh | 219.78W |
| Flywoo6000, 596.2g | 1359.6g | 129.6Wh typical cell total | 388.80W |
| iFlight8000, 840g | 1603.4g | 177.6Wh listed | 532.80W |

These are arithmetic ceilings under unrealistic assumptions, **not expected power, flight time or sufficient reserve**. They do not assume the packs' nominal energy is delivered at the aircraft's load. Using P30B minimum rather than typical cell energy gives 374.40W in the last column. Prices, mass and historical LiPo assumptions are documented in the linked reports and primary listings above.

The actual requirement is:

`E_start_usable >= E_before_useful + (P_whole_aircraft_average / 3) + E_protected_return_and_landing`

Energy is in Wh and average power in W; twenty minutes is one-third hour. Equivalently, each additional 1Wh of unavailable, pre-segment or protected energy reduces the allowable useful-segment average by **3W**. All electronics and conversion losses belong in battery-side power. Usable energy, recovery energy and average power remain unknown; no arbitrary percentage, voltage cutoff or reserve duration is adopted.

The documented HQ static reference would consume **70.56Wh** in twenty minutes if sustained unchanged. The old LiPo's nominal remainder would be only **2.70Wh**, before electronics, reserve or losses, while the illustrative aircraft is heavier than that reference's 1.2kg thrust. That flags poor margin in this comparison; it is not a lower bound on all possible 7-inch mission power or proof that every redesign fails. Higher-energy packs improve the energy allowance while increasing mass and therefore changing the operating point. Neither side of that trade can be ignored.

The 100m radius alone cannot determine recovery energy: altitude, route, speed, landing duration, environmental disturbance, battery condition and uncertainty affect it. ArduPilot documents battery monitoring and staged low/critical battery actions; these mechanisms require correct monitoring/configuration and do not calculate this project's validated reserve merely by existing. Its generic examples are not selected values for this aircraft. [ArduPilot battery failsafe](https://ardupilot.org/copter/docs/failsafe-battery.html)

## Cargo is a separate validation problem

No safe positive carrying capacity is established. For scale only, adding 250g, 500g or the tentative 3lb (1360.777g) to the illustrative Flywoo configuration produces **1609.6g, 1859.6g or 2720.377g**, respectively, before additional holder, packaging and integration mass. These are neither recommendations nor payload limits. No intended item is required to continue designing the evaluation framework.

Future capacity must be an envelope covering mass, dimensions, position/centre of gravity, retention, drag, maneuver/thermal/current margin and loaded recovery behavior. A maximum-thrust subtraction is insufficient. Delivery trials need their own mission duration and reserve evidence; the twenty-minute no-extra-cargo requirement neither guarantees nor specifies loaded endurance.

The security requirement also affects mechanics: removing the complete holder must not provide ordinary access to the cargo before recipient verification. A generic strap, detachable hook or servo latch is not yet demonstrated compliance. Safe landing remains independent of successful recipient verification. These are retained design obligations, not a new forced-entry or whole-drone-theft resistance claim.

## Consequences for the new $900 ceiling

The preceding conditional **$807.92** comparison still lacks required later-feature and integration costs. Replacing its two $44.99 LiPos with the rechecked factory packs would give **$897.92** for Flywoo6000 or **$885.92** for iFlight8000, leaving **$2.08** or **$14.08** below $900 before those same omissions and delivery/other applicable charges. This carries forward the other prices and qualification gaps; it is not a fresh complete quote. [Cost comparison and omissions](cost-reduction-options-2026-08-30.md)

The two-pack accounting funds separate sorties, not twice the energy aboard one flight. Changing chemistry, pack count or required equipment is not assumed. These arithmetic comparisons cannot support selecting an endurance battery now or promise that an extra $100 has closed the complete-project cost gap. They also do not prove that no different complete design can fit.

## Gates that allow useful progress without false closure

1. **Finish on paper now:** preserve the reference mission and delivery rules; assign every required component to the ordinary/delivery configurations; mark measured, manufacturer-listed and allowance masses separately; maintain one full-project ledger including unpriced obligations. Define what evidence will demonstrate usable energy and a separately protected recovery reserve. Freeze the test conditions before acceptance evaluation, without inventing safety thresholds from user preference.
2. **Before selecting/purchasing the aircraft package:** qualify an obtainable exact motor/prop/ESC/pack combination, complete installation/current/thermal/retention compatibility, and an honest cost total. Use matched manufacturer data and documented engineering assumptions to screen it. If an experimental candidate is proposed, disclose the performance uncertainty, possible replacement expense and risk to the $900 ceiling; do not label it an endurance-qualified build.
3. **Before physical acceptance:** after separately approved construction and readiness prerequisites, obtain representative installed mass, battery-side workload power and usable-energy evidence. Establish conservative recovery protection using measured conditions and uncertainty. A qualified staged validation plan must precede operations; this report supplies no novice powered-test or flight procedure.
4. **Before claiming the endurance requirement:** demonstrate twenty useful minutes in the specified equipment/workload configuration while the separate validated reserve remains available, with repeatability and battery/environment limitations recorded. Reduced equipment, a maximum-hover marketing number or a depleted battery endpoint cannot substitute.
5. **Before delivery release:** separately validate the loaded operating envelope, ordinary-removal protection, verified landed handoff and failure behavior. Keep carrying capacity explicitly unresolved until evidence supports it; no 250g/500g/3lb cap is silently chosen.

**Recommended planning separation, requiring an explicit workflow decision:** a hardware-independent M1 PC specification and its tests can be reviewed and implemented while aircraft feasibility remains an open tracked workstream. It uses the same owner/recovery/security decisions and does not require an invented airframe capacity. M1 as a whole still includes manual flight and cannot be declared complete on PC results. Hardware purchases, aircraft integration, flight and later autonomous capabilities remain gated. This is a change to the currently combined ticket-10 handoff rule, so this report does not close that issue or activate the handoff itself.

The remaining useful human choice is whether to accept that limited software-first planning separation if a complete qualified hardware package cannot yet be justified. The user should not be asked to guess a reserve, choose an unsupported cargo number, or repeatedly reconfirm already approved requirements.

## Provenance

Local inputs are uncommitted read snapshots; later concurrent edits may differ. SHA-256:

- Ticket10 read before this task's parent records the new budget: `52E4AAFCAD28E038A517800D77371B2E98B69F4CA35AB6AFDD1D8F337D54A814`.
- Map snapshot: `B50242646410B0C98C788135D2CCB402A1C18EBB6D4D432B9321D8972B73A6CC`.
- `seven-inch-propulsion-after-q53.md`: `34521ECC8EE399A3DC00C88C5F83A4936D408B36909D9A07675A9A5E3B07C636`.
- `endurance-cargo-options-after-q54.md`: `C052A86F9E84E49BE7B38EFE383E7AAC2BE16DD9C66C8C127A398ACEB927B2F3`.
- `payload-platform-options-2026-08-30.md`: `0BEF2F5A6EE04EE04B0F3DDCF51E3960C84668ABC5EA7E532B6F5B65FEA3EDCF`.
- `cost-reduction-options-2026-08-30.md`: `6EB585981864B870EE500D49767DAD7D43157D09045CF0E4C443682CD88541F1`.
- EMAX-branded PDF bytes freshly retrieved in memory: `81B13EDED16A94295F65E0A7859DF5D93A6469DFBC8EF92841B61F67D9F1B56E`.

Fresh primary retrieval covered Flywoo, iFlight, ArduPilot and the EMAX-branded PDF. EMAX's commerce endpoint failed through the web reader but succeeded by direct read-only HTTPS request. The Molicel PDF initially returned through the web reader; subsequent retries timed out, so its numerical basis is also preserved explicitly in the hashed preceding report. This bounded task did not revalidate every earlier component or manufacturer claim. No purchase, installation, biometric capture, hardware operation or flight occurred.
