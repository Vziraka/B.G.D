# Complete-build feasibility after Q53

> **Q54 status update — 2026-08-30:** The user has no current cargo example but explicitly retains delivery as a requested capability. Cargo type and carrying limit remain undecided; the tentative 3 lb suggestion is not a requirement or promised capacity. The item question at the end of this report is superseded: do not require an example before continuing planning. Present evidence-backed capacity options with the hardware/budget proposals, keeping delivery inside the complete-build scope and preserving the no-extra-cargo endurance reference. The original findings below are unchanged; this clarification does not establish a budget fit or authorize a purchase.

Checked **2026-08-30**. New, uncommitted synthesis in the main checkout on `main`, base commit `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`; that commit does not contain this report. Supporting reports preserve exact variants, sources and limitations. No purchase, installation, physical test or implementation occurred.

## Result

**This round did not produce a complete, procurable build within the approved budget.** The conservative conditional route below totals **$857.87–$868.87 before shipping, tax and several required feature costs**. It is not a recommended purchase, a proven minimum achievable cost, or evidence that every redesign must fail.

Q53 keeps **$600 as the goal and $800 as the absolute maximum only for worthwhile tradeoffs the user approves**. The complete planned build includes tools, radio, charger, initial spares and every requested capability. Future repairs and worn-out replacements are budgeted separately; that does not exclude initial feature costs or hide necessary recurring fees.

## Non-duplicated conditional comparison

| Cost group | Pi 4 route | Pi 5 route | Evidence boundary |
| --- | ---: | ---: | --- |
| Aircraft and ground equipment, including navigation, tools and three propeller sets | $552.64 | $552.64 | [Exact ledger](aircraft-ground-cost-after-q53.md); H7 stack availability contradictory, further integration/tool needs remain |
| Four motors and two new 3300mAh 6S LiPos | $167.94 | $167.94 | [Propulsion ledger](seven-inch-propulsion-after-q53.md); exact checked US motor/battery variants unavailable |
| Compute, camera, cooling, regulator and compute storage | $134.34 | $145.34 | [Compute/video ledger](compute-video-cost-after-q53.md); Pi 5 board unavailable at checked seller; workload unvalidated |
| One card reader for acquisition, counted once | $2.95 | $2.95 | Can serve separate FC/compute cards; not an onboard component |
| **Partial total** | **$857.87** | **$868.87** | **Already $57.87 / $68.87 above $800; still incomplete** |

The $11 compute difference is not a demonstrated performance-equivalent saving. A checked Pocket Crush alternative saves $6.51 if adopted, leaving these incomplete totals at $851.36 / $862.36; it is not selected. Reconcile supplied parts, compatible power sharing and genuinely cheaper tools before claiming further savings. The old $66 tool allowance is not a validated substitute. [Aircraft/ground comparison](aircraft-ground-cost-after-q53.md)

Missing costs include camera movement/mounts, avoidance sensing, infrared and visible path lighting, delivery retention/release, possible extra hardening sensors, radio/network bridging, further installation/bench-power items and necessary app-development/distribution costs. Some may share existing hardware after validation; none is silently zero. Apple's $99/year membership is conditional on the examined native-build route, not a selected or universally unavoidable fee. [Compute/video obligations](compute-video-cost-after-q53.md), [Apple membership](https://developer.apple.com/support/compare-memberships/)

## Endurance and integration

The EMAX-branded table now supplies exact 7-inch low-thrust evidence. At 300g per rotor, the Gemfan 7042 point gives 221.76W across four motors; a better HQ 7x3.5x3 point gives 211.68W. Over twenty minutes those use 73.92Wh / 70.56Wh, versus the examined pack's 73.26Wh nominal, before electronics and reserve. This is unfavorable screening at those static points, **not measured assembled-aircraft endurance or a bound on all designs**. Both relevant PDF pages were visually checked; the better propeller entry is retained explicitly. Exact current prop revisions, installed mass, usable capacity, workload and reserve remain unvalidated. [Propulsion analysis](seven-inch-propulsion-after-q53.md), [manufacturer-branded PDF](https://evelta.com/content/datasheets/449-0101096022.pdf)

Documented browser streaming supports investigating camera/compute/Wi-Fi reuse before adding separate FPV hardware. It does not demonstrate 100m coverage, simultaneous tracking/security/video, or locked/pocketed iPhone voice control. [Official camera documentation](https://www.raspberrypi.com/documentation/computers/camera_software.html#third-party-streaming-servers)

## Next user input and engineering work

**Q54 remains unanswered:** what is the heaviest item the user wants the finished drone to deliver? Naming an object is sufficient; do not ask them to invent engineering weights or power budgets. Recommend a lightweight, non-hazardous starting example, such as keys, without silently selecting a final cargo cap.

Delivery intent affects complete-build sizing. It does **not** change the already approved twenty-useful-minute reference test **without extra delivery cargo**, or delete delivery from the roadmap. Use the answer to refine mass/cost requirements while reopening the unsuccessful hardware route. A purchase-ready basket, evidence-backed M1 acceptance inputs and the sketch-level later sequence remain unfinished; ticket 10 stays claimed.
