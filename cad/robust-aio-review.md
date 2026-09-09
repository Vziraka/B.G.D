# AIO robust-design checkpoint — Issue11

Status: **digital work continues; received-part and unfinished-design gates remain before fabrication**. The user withdrew the TBS inquiry: **do not send it; manufacturer correspondence is not a workflow dependency**. Q75 hardware and Q74 endurance remain unchanged. All files here are engineering studies, not physical compatibility or fabrication approval.

## 1. Dimensional envelopes used

[Machine-readable inputs](components/aio-envelope-inputs.json) distinguish the owner's documented2.0–2.5mm bottom-plate range from additional **chosen design/inspection budgets**. None of these budgets is a manufacturer tolerance or a promise that purchased parts meet it. They define what the design attempts to accommodate and what incoming inspection must check; outside-budget parts trigger affected-interface reevaluation.

| Item | Tested range / maximum | Evidence category |
|---|---|---|
| Bottom plate | Documented2.0–2.5mm; screened1.85–2.65mm including±0.15mm allowance | Conflicting documented dimensions plus conservative design envelope |
| Other nominal2mm plates | 1.85–2.15mm | Nominal maker value plus chosen allowance |
| Arms/spacer | 5.8–6.2mm | Nominal6mm plus chosen allowance |
| Standoffs | 19.8–20.2 /21.8–22.2 /29.8–30.2mm; OD≤5.2mm | Nominal20/22/30/5 plus chosen allowance; the two20mm supports have unverified placement |
| Relative lateral error | ±0.75mm per axis; ±1° yaw | Worst summed allocation:0.20 frame datum+0.10 seating+0.20 adapter+0.25 assembly; installation acceptance required |
| Tilt / plate bow | Independent±1° adapter/AIO tilt budgets;0.20mm bow | Chosen stress-screen bounds, not measured deformation or dynamic qualification |
| Adapter | 48/46/45mm outlines; size±0.25mm total; thickness1.45–1.75mm; support gap3.1–3.5mm above local bearing face P | Design variables; no final drill/fastener release |
| AIO | Nominal36×36×8mm; screened37×37×9mm at45° | [MicoAir nominal specification](https://micoair.cn/zh/docs/flight-controller/micoair743-aio-series/micoair743v2-aio-45a-manual) plus chosen margin |
| Isolator / fasteners | Effective isolator rise2.5–3mm, OD≤6mm; top projection≤2.5mm, underside≤2mm, head OD≤7mm | Prospective fit contracts only; not an exact sourced or qualified mount set |
| Service trial | 12mm expansion around every AIO edge | Conservative trial reservation; not actual USB/SD plug/card dimensions |
| Power-route trial | Wire OD≤6mm, centerline bend radius36mm,2mm obstacle gap | Trial allocation only; actual10AWG stock bend/OD and completed route still required |

All dimensions are mm unless specified. Actual manufacturer facts and the source conflict remain in the [source review](reference/source-one-v6-7in/revision-resolution.md); this document changes the workflow, not those facts.

## 2. Worst-case combinations and method

[Analysis](scripts/analyze_aio_envelope.py), [results](components/aio-envelope-results.json). Continuous XY error is bounded using distance's1-Lipschitz property: subtract the translation radius`√2×0.75` and the maximum corner displacement under±1° rotation, then subtract maximum standoff radius. This is conservative over the full interval; it is not a sample-only claim. Endpoint XY cases are also calculated as adverse witnesses. Negative lower bounds mean the method cannot guarantee separation, not proof of an actual collision.

Z screening uses all32 endpoint combinations of bottom, arm, intermediate plate and22/30mm supports, plus adverse adapter thickness/gap, isolator rise, body height, head projections, independent tilts and bow. Monotonic interval equations cover the continuous ranges. For topology B, the conservative ceiling above P is`min(21.8,29.8−(6.2+2.15))−0.2=21.25mm`. Bottom thickness cancels from upper clearances when P is the local bearing-face datum, but **does not cancel from screw grip/engagement**.

This does not prove assembly order. Hypothesis A has an intervening plate over the proposed mounting columns; changing its thickness cannot remove that obstruction. It is explicitly rejected for this mounting-column arrangement. No finite min/max for an unknown brace or arbitrarily different stack is invented. Some interval combinations give up to0.75mm support-height mismatch; these are stress cases, not permission to pull a mismatched factory frame flat with screws. Incoming inspection establishes the real topology and mating planes.

The two nominal20mm supports have no verified placement. Their19.8–20.2mm acceptance interval is recorded but cannot enter a defensible assembled-Z equation until their connections are known. Consequently21.25mm is a topology-B screening ceiling, **not a guaranteed minimum across all plausible assembly orders**. Planar outline clearance also does not qualify tilted solid edges, hole ligaments, joints or strength.

## 3. Minimum clearances and full-mount outcome

All guaranteed bounds below are **conditional on the declared design envelope and applicable topology**, not manufacturer verification. A1mm minimum hard-clearance target is used as an engineering design target; thermal and structural requirements are additional.

| Interface / candidate | Conservative minimum bound | Outcome |
|---|---:|---|
| 48mm outline → standoffs | −0.498mm bound; an adverse realizable case leaves0.136mm | Does not meet1mm target. This is not a claim of physical overlap. |
| 46mm outline → standoffs | 0.527mm bound | This conservative proof does not establish1mm; endpoint cases alone are insufficient. |
| **45mm R3 outline → standoffs** | **1.039mm** | Passes the declared continuous planar budget; small residual margin, received confirmation mandatory. |
| Maximum AIO body → standoffs | **7.423mm** | Passes body-only geometric bound; connectors/wires excluded. |
| Adapter underside → P | **2.342mm** | Includes adapter tilt and plate bow. |
| Under-adapter fastener envelope → P | **0.342mm** | **Fails1mm target**; mount detail must change. |
| AIO body underside → adapter | **2.043mm** | Geometric space only; exact isolator and protrusions still required. |
| AIO top → ceiling | **2.985mm** | Conditional topology-B bound; not a ventilation/thermal pass. |
| Top fastener → ceiling | **0.485mm** | **Fails1mm target**; mount detail must change. |
| Generic all-side12mm service trial → standoffs | Bound−4.413mm; native nominal study intersects four supports | Generic service reservation fails. Does not prove the actual USB plug/card collides; exact locations and swept volumes are needed. |
| Actual USB/SD/connector insertion-removal | **Not established** | Missing exact envelope/route; no fictitious minimum assigned. |
| Wire bend / bus / harness / insulation guard | **Not established** | Trial bend requires41mm outer swept radius including gap; no route-wide minimum claimed. |
| Screw engagement / head bearing / clamp retention | **Not established** | Prospective solid envelopes do not define a load-bearing joint or safe thread depth. |
| Airflow / serviceability | **Not qualified** | No complete airflow obstruction/plug/tool study; actual thermal behavior remains bench validation. |

**The48mm adapter does not survive the proposed robustness target.** The outline has been revised to45mm in a new digital study. **The complete45mm mounting assembly is also not qualified yet:** fastener margins and generic service-space checks expose remaining design work. No gaps or requirements were relaxed to force a pass, and a not-yet-sourced isolator/fastener is not treated as known hardware.

## 4. CAD work performed and adjustability

Created a separate27-body [Fusion envelope study](exports/aio-envelope-r3/BGD_AIO_ENVELOPE_R3_NOT_FOR_FABRICATION.f3d) with the revised adapter, maximum AIO body, isolator/head envelopes, support volumes and hidden ceiling/thickness/service/bend reservations. [Preview](exports/aio-envelope-r3/aio-envelope-r3.png), [Fusion result manifest](components/aio-envelope-fusion-manifest.json). Native Fusion measured8.940mm nominal board/support separation and four intersections for the nominal generic service trial; the smaller7.423mm analytical body bound includes uncertainty. The model contains intentional overlapping keep-outs and illustrative mount envelopes, not a manufactured assembly.

The original BGD_MASTER/frame archive and48mm STEP remain unchanged and unreleased. The new study uses local P; its mapping to the old master is provisional. Dimensions are parameterized through JSON and reproducible scripts; no fully constrained native parametric sketch claim is made. A visually plausible model does not validate the missing parts.

Provenance amendment: after the R3 export, the input register added the unassigned20mm support interval and an explicit warning against assuming its placement. These fields do not drive R3 geometry. The Fusion manifest retains the actual input hash at export and separately records the amended input hash; the archive has not been silently regenerated or relabeled as using the later input bytes.

Keep a replaceable adapter and reserve captured, matched nonconductive shims at **custom** support stations. Final drill positions can be regenerated from received coordinates. Do not enlarge/slot the frame or release slotted adapter holes before ligament, bearing, alignment and clamp/slip checks. This avoids claiming that adjustability preserves strength without evidence. Service loops and the battery/CG adjustment remain design provisions; no final route or slider is implied.

## 5. Received confirmation and fabrication boundary

[RF-GATE-01](received-frame-inspection-gate.md) explicitly requires plate/arm/spacer thicknesses, standoff lengths and locations, full plate spacing/topology, hole centers, fastener geometry and actual clearances. It also reconciles the AIO, mounts, plugs and wire envelope. Measurements update BGD_MASTER before dimension-sensitive fabrication release. This replaces waiting for manufacturer correspondence.

Use **ROBUST ACROSS DOCUMENTED ENVELOPE** only for bounded claims such as the independence of above-P geometry from2.0–2.5mm bottom thickness within the same confirmed mounting topology; the45mm planar bound additionally depends on the stated conservative budgets. It is **not** the status of the whole AIO assembly.

The frame-dependent adapter, drill pattern, spacer/shim/fastener selection, bus guard/routes, battery mounts and other dimension-sensitive custom parts remain **REQUIRES RECEIVED-PART CONFIRMATION BEFORE FABRICATION**. Several also require unfinished digital engineering; receipt alone cannot release an uncompleted design. Physical vibration/strength, insulation, thermal/current, electromagnetic, flight and Q74 endurance acceptance remain separate.

## 6. Continuation and next CAD task

**CAD can continue now without TBS.** Continue component envelopes, alternative mounting details, service-route studies and a versioned measurement-driven master. Keep unknown topology as a configuration branch and final drilling as a received-frame variant.

**Exact next CAD task:** replace the R3 prospective isolator/fastener envelopes with an actual dimensioned joint design and actual AIO USB/SD/power-interface envelopes; resolve the two sub1mm fastener margins and route a specific service corridor instead of the failing all-side reservation. Then rerun the same continuous tolerance bounds and native collision checks for each admissible mounting topology. Do not release the new45mm outline or select a lower clearance target merely because it looks plausible.

No TBS inquiry, procurement, fabrication, physical operation, hardware substitution, Q74 change or PC work occurred. The separate Electrical agent retains electronics/**; its logical schematic handoff does not establish physical route clearances.
