# Engineer the revised hardware build package

Type: task
Status: **abandoned 14 Sep 2026** (C1/C1C digital package). Live path is [CURRENT.md](../../../docs/CURRENT.md). Do not continue this ticket.

Requirements source: Issue10 current checkpoint; Issue10's product decisions are resolved.

## Current checkpoint

**September 11, 2026 (evening): ownership resumed; candidate C1C in progress; INCOMPLETE.**
The owner resumed autonomous ownership of the digital package. The bounded
side-entry repair (inverted LD19 under the belly, camera in the belly pocket)
[failed numerically](../../../docs/hardware/candidate-c1-2026-09-11/side-entry-feasibility-decision.md);
the architecture answer is [ADR 0002](../../../docs/adr/0002-high-camera-low-lidar.md):
camera raised onto the top tower (lens about 0.20 m above the body origin), LD19
inverted under the belly (plane 0.184 m below), 3/16 in rod gear crossing the plane
at r >= 0.27 m, acceleration limited to 1.25 m/s², braking >= 1.5 m/s², and an
attitude-aware ground filter. Same screen, Variant 3 rows: every named entrant
case passes (2.14-2.20 m at 45 degrees, 3.5 m side, with sustained 2-degree roll,
1.2-degree gap, ramped braking and +/-0.10 m altitude error). The search schedule
is unchanged at 1.3 m camera height (595 s with the 1.25 m/s² limit). Native CAD,
electrical, lamp and recovery-route work for C1C are in progress. Issue10
requirements and the $1,000 delivered ceiling (ZIP 22180) are unchanged. No commit,
push, purchase, external commitment or physical operation.

The [stop handoff](../../../docs/hardware/candidate-c1-2026-09-11/STOP-HANDOFF-2026-09-11.md)
records completed results, failures, process state, version drift and ordered next
actions. The [bounded Claude assignment](../../../docs/hardware/candidate-c1-2026-09-11/claude-next-assignment.md)
has now been executed; its next action 1 is closed with a failure record. Pre-stop checkpoint/map/README copies are
preserved in `docs/hardware/candidate-c1-2026-09-11/stop-state-2026-09-11/`.

- **Side-entry feasibility: belly-camera repair FAIL, C1C geometry PASS in screen.**
  Baseline reproduced exactly (level
  2.381 m, sine bank 1.331 m). The level pass rests on a 6.9 mm vertical margin
  (laser 1.1931 m versus a 1.2 m entrant): a sustained 1-degree roll toward the
  entrant or 20 mm of altitude excess gives no return and a leg contact. The
  attestation admits 1.2-degree gaps, at which the sourced 4.7625 mm rod exceeds
  the 3.16 mm optical bound for a 0.3 m person; with a ramped 5 m/s^3 braking
  onset even the level case falls to **1.810 m**. Lowering the plane 0.25 m on
  longer rods repairs bank/altitude cases (2.049 m) but not the leg-shadow case
  (1.825 m), and puts ground returns inside the guard during braking. Sourced
  rods are not integrated. Original off-plane entry, tight-start route,
  open/noecho, full 3D admission and safe landing remain unresolved.
- **Native firmware:** 75/75 bounded planning/authority/boundary checks, 26 authority
  assertions, 64 extracted-C++ sanitizer checks, three retreat faults and four
  allocation-refusal checks retained. Exact final image and 22-file patch replay
  are in [planning evidence](../../../docs/hardware/candidate-c1-2026-09-11/sitl-oa-planning.md).
  Passing bounded cases do not close the sensing/route failures.
- **Mechanical:** latest pre-lamp native model is 2,049.0 g, 158 source components,
  1,864 selected interference pairs clear. USB repair fits 189.80 mm route plus
  20 mm service within 213 mm minimum free cable. **The earlier main power route
  may intersect the newly added branch-fuse body and has not been regenerated.**
  Body-only native clearance does not validate wires.
- **Lamp/electrical:** conditional Cree CMA1303/LDD-500LW and two-NPN candidate
  has numerical thermal/optical/control screens, not qualification. CAD still
  has the old lamp. Holder, hot-mount isolation, current-control behavior and
  BJB-compatible pigtails remain unfinished. New electrical candidate has
  67 rows/105 terminals/nine sheets and zero ERC violations, but an unresolved
  netlist annotation warning; old harness checks do not validate it.
- **Budget:** ZIP **22180**, sourced 6% tax; evolving partial parts **$881.73**
  plus **unquoted $45 shipping**, conservatively taxed together, is **$982.33**.
  Missing final lamp/retention/termination and actual multi-vendor charges mean
  the delivered system is not yet demonstrated under $1,000.
- **Integration stale:** latest geometry, lamp candidate, BOM and mass/energy
  models disagree. Previous 2,045.2 g/87.992 Wh versus assumed 88.8 Wh usable
  had only 0.92% margin; it is historical evidence, not current acceptance.
  Final affected route/load/motion/slice checks and package summaries await
  coherent geometry. Failed cases and all prior revisions remain preserved.
- **Other retained evidence:** Android 11 Java/6 reader checks and signed APK,
  no installation; security Lua 25/protocol 13/rollback 4 mock checks. Earlier
  shared regressions 75 feasibility/35 simulator tests were not rerun for final
  shared edits. iOS probe is uncompiled; Issue11 interfaces remain unfinished.
- **Processes:** agents stopped; no known active engineering build/test. Last
  recognition session18704 is no longer addressable (exit status unrecovered).
  Fusion documents and shared tool infrastructure remain open; unidentified
  Python PID34368 was preserved. See handoff for exact limitations.

Current work order: (1) C1C native CAD revision with preserved C1B, (2) electrical
harness/annotation/pigtail/firmware-parameter reconciliation, (3) coherent lamp
module thermal/mechanical design, (4) recovery tight-start route and landing
volume, then (5) BOM/budget, mass/CG, energy, sensor-offset and package
regeneration against the frozen C1C geometry. Known failures stay recorded. No purchase, external
commitment or physical operation is authorized. Known failures and answerable
digital work remain; this is not a physical-only hold or completion claim.

## Scope

Engineer the current product through architecture comparison, component/process selection, mechanical/electrical integration and digital verification. Reuse proven work where it fits; design custom solutions where justified. Manufacturing methods, including primary printed structure, may be investigated on evidence. Material/process capability and novice operation must be accounted for before release. Routine choices belong to the agent; user involvement follows CLAUDE.md.

## Acceptance

- Select one coherent candidate against current goals with integrated mass, power, endurance, cost, sensing/compute and communications evidence. Identify unsupported goals or material product tradeoffs explicitly rather than hiding them in physical-test holds.
- Provide dimensioned CAD/drawings, source-backed interfaces, mounts, tolerances, material/process choices, harness/netlist and resource allocation for the selected configuration. Reconcile sources and export revisions.
- Provide firmware/software configuration and authority/recovery interfaces, distinguishing fixed design values from future measured calibration. Retain independent takeover, face/liveness command access and adequate landing energy; retire cargo release requirements.
- Trace each current requirement to a documented fact, reproducible calculation/simulation, implementation check or named decisive physical test with acceptance criteria. Use proportionate methods; physical dependencies do not stop independent work.
- Digital package completion means the design is coherent, required digital work is verified, and unavoidable physical checks are prepared. Known design failures and unfinished answerable engineering remain open. Fabrication/flight release and physical acceptance remain distinct statuses.
- Report final speed/altitude estimates with assumptions and later demonstrated bounds; no current numerical maximum is claimed.

Procurement, external commitments, fabrication, physical firmware upload and powered operation require their applicable authorization. Existing digital Fusion permission persists; historical stage-specific stop instructions below are superseded where later authorizations say so.

## Comments

### 2026-09-03 â€” Started after Q75

Issue10 is resolved as planning complete. This task owns the engineering artifacts and their release readiness. Physical acceptance remains pending in V01â€“V40 and procurement is not authorized.

### 2026-09-03 â€” Initial R1 artifact package and R1.1 correction

Created19 dimensioned SVG study sheets plus vector PDF/cut list,135-record harness/netlist and topology,43-row pin allocation, source/hash firmware manifests, safety/state truth tables and73 acceptance trace mappings. Root/delegated reviews and mechanical corrections are recorded in [review-record](../../../docs/hardware/baseline-r1/review-record.md).

**Actual incompatibility found:** the selected$8 QS8-S item is a two-pack series adapter. Under Q75's explicit affected-subsystem authorization, replace only that interface with another genuine bare QS8 male and existing8AWG stock/qualified solder process. The charging connector remains separate; selected battery, motors, props, frame, FC and sensors stay unchanged. Correct switch polarity, all four AHCT channels and the short D500 USB cable at the same interface-definition stage.

**Not complete:** H01â€“H12 in [mechanical-build](../../../docs/hardware/baseline-r1/mechanical-build.md) explicitly identify unfinished slider/mast/gear/latch/guard/carrier/route details and source-dependent interfaces. These are detailed-engineering holds, not falsely classified as physical tests. The old70g main-path allocation and100g support allocation are exceeded by partial accounting; [mass/cost reconciliation](../../../docs/hardware/baseline-r1/mass-cost-impact.md) must finish before updated propulsion/endurance and complete-price claims. Stock ArduPilot cannot supply the approved all-path biometric gate; mandatory FC implementation and its fault tests remain required.

Issue11 remains **claimed**, not resolved. No further user approval is needed to continue ordinary engineering within Q75. Purchase remains forbidden without explicit procurement authorization; no PC-ticket implementation was started here.

### 2026-09-04 â€” Digital engineering architecture stage

Created the CAD/electronics architecture requested before procurement. The [stage report](../../../cad/stage-report.md) records the read-only Fusion/KiCad environment audit, source-of-truth rules, 61-row component/CAD inventory, planned Fusion master tree, 13-item fabrication backlog, planned KiCad hierarchy and 27 digital checks covering all 33 distinct buildability gates.

The authoritative TBS Source One V6 7-inch DXF is pinned to commit 232ccff173c556d23cc857f0c07a6eaa66ddbc41 and its existing ignored cache was rehashed. Master axes are X right, Y forward, Z up, with XY origin at the motor-axis centroid. The source is 2D manufacturing geometry and does not establish assembled Z.

No Fusion master assembly or KiCad schematic is claimed. Fusion GUI/API control is not demonstrated; KiCad CLI version access is demonstrated. The exact next task is CAD-T01: import/inspect the pinned frame DXF in Fusion at 1:1 mm and verify its profiles, motor centres and hole datums before adding components. This task stops before detailed CAD generation as requested.

PC Ticket 2 code/tests/spec/issues, the shared map/root ignore/configuration and all unrelated working-tree changes were intentionally left unchanged. No purchase, installation, fabrication, physical operation, stash, reset, commit or push occurred. Issue 11 remains claimed.

### 2026-09-05 â€” Architecture-stage revalidation

Re-ran the requested environment/workspace audit without detailed CAD generation. Fusion remains 2704.1.53 with no demonstrated shell/API document control; KiCad CLI10.0.6 remains callable by full path. The engineering checker passes all61 inventory rows,13 custom work items,27 digital checks/33 source gates and the pinned Source One cache hash.

Corrected the inventory taxonomy to the user's exact latest definitions: self-created models based on manufacturer dimensions are class4 simplified envelopes, not class2 authoritative third-party CAD. No class1 or class2 model is claimed without an acquired model. Updated validation outcomes to the exact `STILL REQUIRES ...` labels. No BOM, requirement, component or architecture changed.

Stopped before CAD-T01 as requested. PC implementation and all unrelated working-tree changes remain untouched; no purchase, installation, fabrication, commit or push occurred.

### 2026-09-05 â€” Integration investigation before CAD-T01

At the user's explicit change of sequence, paused frame-reference work and completed the [Fusion/KiCad/Codex integration investigation](../../../docs/research/fusion-kicad-codex-integration-2026-09-05.md). Installed Fusion 2704.1.53 ships the official MCP library and schema variants; Codex supports compatible transport. Actual connection, tools and script access remain untested. Recommended official local Fusion MCP with the official API as complement/fallback, and installed KiCad CLI plus native-file authoring for the present harness/schematic work. Third-party candidates were inspected without execution or installation.

No configuration, application preference, permission or listener was changed. The user's latest instruction requires approval before integration commissioning. After that approval and appropriate connection checks, resume the exact CAD-T01 learning/measurement task, preserving its provisional extraction artifacts and final review checkpoint. No Fusion import/reference component has yet been verified. PC Ticket 2, Q75 and Q74 remain unaffected; issue11 stays claimed.

### 2026-09-05 â€” Approved official Fusion MCP commissioning

The user's "Approve" authorized the preceding limited commissioning proposal. Enabled Autodesk's official loopback MCP preference and created the project-local inspection profile; no third-party installation or global Codex/KiCad configuration change. Handshake, live four-tool discovery, blank-document inspection and API-doc queries succeeded. The installed Codex CLI recognizes the profile. See the [commissioning report](../../../docs/research/fusion-local-mcp-commissioning-2026-09-05.md) and linked captured evidence.

Actual modeling uses a general Python tool, which remains disabled under the proposal's privilege-review gate. Native tool attachment to this running task and client prompt enforcement remain unverified; direct diagnostic HTTP reads do not prove those controls. Refresh/check this hardware task only, without disturbing PC Ticket 2, before testing the native read tool. General script execution needs explicit privilege approval and verified client control; do not bypass the disabled tool with HTTP writes.

Resumed independent CAD-T01 preparation: corrected the provisional DXF verifier's section handling, measured mounting pitches, curved-profile limitations and proposed right-handed axes. Source checks and the architecture manifest check pass. [Import readiness](../../../cad/reference/source-one-v6-7in/import-readiness.md) records the remaining front/layer/datum review. No import, BGD_MASTER, native archive or detailed custom CAD is claimed. Q75/Q74, procurement prohibition, PC implementation and unrelated changes remain untouched. Issue11 stays claimed.

### 2026-09-05 â€” Native connection follow-up after Continue

The current task still reports `unknown MCP server 'bgd_fusion'`, despite a successful fresh official Fusion initialization and the CLI recognizing the existing project inspection profile. Reopening this task did not load the integration. A read-only attempt through the CLI's supported existing app-server proxy failed to connect to its default control socket; no app-server daemon, new model task or listener was started. The protocol schema confirms reload is a client operation covering loaded tasks, not a demonstrated per-task refresh available here.

Next human-side diagnostic is to inspect **Codex Settings â†’ MCP servers** for `bgd_fusion` and its status before choosing the documented MCP restart control. Do not repeat the unverified reopen-only instruction, restart the whole app during PC work, or add a duplicate global server. Python modeling remains disabled and no frame import is claimed. Only this hardware issue/environment note changed during the follow-up; PC Ticket2 and existing unrelated changes remain untouched.

### 2026-09-05 â€” Native Fusion inspection works after app restart

The current task now exposes `fusion_mcp_read` and successfully used it to list the open blank document and read official DXF/unit API documentation. The native catalog matches the inspection-only project configuration. The connection-loading blocker is resolved; prior unknown-server notes are historical.

Execute remains disabled. Its general Python privileges need the explicit decision retained by the commissioning proposal. [Current status and exact proposed permission/configuration](../../../cad/fusion-connection-status.md) defines reviewed CAD-T01 scripts, no unrelated documents, no network/process execution, non-overwriting repository outputs and a stop at frame-reference review. Per-call prompt enforcement is not claimed: the recommendation requires informed task-specific authorization rather than assuming prompts provide containment. No modeling/import or PC work occurred, and no configuration was changed this turn.

### 2026-09-05 â€” Broad digital hardware engineering execution authorized

The user explicitly approves Fusion Python/API for the whole B.G.D. Issue11 digital engineering effort, not just frame-reference scripts. Continue autonomously with pinned-frame verification, master assembly, custom mechanical design, placement, digital checks, drawings/exports, repository records and appropriate KiCad engineering. Resolve evidence-based design choices without reopening approved requirements. The former CAD-T01-only permission and required stage stop are superseded.

Q75/Q74 and existing Issue11 artifacts remain controlling. Redesign the smallest affected subsystem only when evidence reveals incompatibility or requirement failure. Distinguish documented facts, calculations, assumptions and physical gates. No purchase/spending authorization, physical fabrication/operation, physical firmware upload or destructive/irreversible action outside the engineering workspace. PC work remains separate. Enabled the existing official MCP Execute tool in the project configuration; no third-party installation or global configuration change. The official loopback transport can carry authorized scripts without interrupting another task for catalog refresh.

### 2026-09-05 â€” Executed CAD reference and adapter screen; frame evidence gate

Fusion Python executed successfully through the approved official MCP. Created actual `BGD_MASTER`, verified10mm units and1:1 pinned-source motor centres, copied exact curved profiles, and saved a local F3D/adapter STEP/preview with hashes. [Current evidence and continuation gate](../../../cad/engineering-progress-2026-09-05.md) supersedes historical claims that no master/import exists. The final captured partial model contains16 visible solids and zero solid intersections; it omits major aircraft and frame hardware and is not a complete buildability pass.

An actual study-geometry conflict affects only M01: the55mm blank overlaps four nominal frame standoffs. A48mm candidate retains both mounting patterns and gives1.3833mm nominal clearance, with calculated blank mass6.6294g instead of8.7636g. The revised dimensioned study and STEP are unreleased pending H01 fastener/grommet/services/structural checks. No purchased subsystem or requirement changed.

The pinned July DXF's2mm plate labeling disagrees with the current manufacturer's2.5mm bottom specification. Stack hypothesis A obstructed the intended mounting paths; B clears modeled solids/axes but remains an engineering hypothesis. Frame-dependent release needs authoritative current-revision/assembly confirmation or a clearly named incoming-part measurement gate. An unsent technical inquiry is included in the report. No manufacturer message, purchase or physical measurement is claimed.

H01â€“H12, complete mass/cost/endurance accounting and full aircraft layout remain unfinished. Existing harness/pins/firmware/safety tables are retained; no native KiCad ERC/DRC or complete fabrication package is claimed. Q74 remains mandatory. This is an evidence checkpoint at a frame-source gate, not Issue11 completion. PC code/tests/issues and unrelated work were left untouched; no Git publication occurred.

### 2026-09-05 â€” Focused frame-revision resolution attempt and review stop

At the user's requested narrow checkpoint, completed a primary-source revision audit and read-only native Fusion geometry recheck. See [nine-part mechanical review and prepared inquiry](../../../cad/reference/source-one-v6-7in/revision-resolution.md), [dimension/confidence register](../../../cad/reference/source-one-v6-7in/dimension-register.csv), and [manufacturer-source research](../../../docs/research/source-one-v6-revision-audit-2026-09-05.md).

Q75 identifies the exact retail configuration Source One V6 7-inch DC (`prod:source1v6`), but not a manufacturing lot or supplier-confirmed drawing change level. The live published7-inch file is still the pinned July07 drawing. Its2mm labels are actual TEXT entities, while `$THICKNESS` is0.0. No first-party evidence resolves the conflict with the current2.5mm product-page bottom plate. Classification: **documentation conflict remains unresolved**. No newer7-inch revision or verified layer/Z-stack assignment was asserted.

No Fusion geometry or F3D/STEP/drawing changed. The unchanged hypothesis-B model passes its prior16-body intersection screen; the48mm bare adapter gives minimum1.3833129101mm standoff gap and2mm middle-plate gap. This is not final adapter qualification. Dampers, USB/SD, power bends, bus/harness, screw depths and airflow/service space remain explicitly unverified. Motor-slot geometry was measured from all four source arms; no safe motor screw engagement or current-stock fit was inferred.

Stopped for owner review as requested, before release or large-scale CAD. The concise TBS inquiry is prepared, **not sent**, and requires messaging authorization. After manufacturer evidence, the exact next CAD task is a versioned confirmed frame stack with omitted structural/fastener envelopes followed by the full AIO mount/service audit. Issue11 remains claimed; no Q75/Q74 change, procurement, fabrication, physical operation or PC work occurred.

### 2026-09-05 local â€” User-directed robust design; no TBS correspondence dependency

The user explicitly prohibits sending the prepared TBS inquiry and authorizes continued conservative digital work. Neither 2.0 nor 2.5 mm is selected as authoritative. The documented range plus chosen allowances, worst-case method, results and limitations are in [the robust AIO review](../../../cad/robust-aio-review.md). Historical source reports remain unchanged evidence; their correspondence/review stop is superseded here.

The 48 mm outline fails the chosen 1 mm clearance target under an admissible case (0.136 mm). A new separate 45 mm Fusion envelope study yields a conservative 1.039 mm planar bound. The full mounting assembly does not pass: conditional topology-B under/top fastener bounds are 0.342/0.485 mm, generic all-side service reservation collides, and actual connector/wire/joint details remain unfinished. Original BGD_MASTER and old F3D/STEP are unchanged and unreleased. Unknown assembly order and the two unassigned 20 mm supports cannot be manufactured into certainty by a thickness envelope.

[RF-GATE-01](../../../cad/received-frame-inspection-gate.md) requires measured plate/arm/spacer thicknesses, support locations/lengths, assembled stack, hole centers, fastener geometry and actual clearances before dimension-sensitive fabrication. Receipt alone does not qualify unfinished CAD. The next CAD task is the actual isolator/fastener joint and AIO USB/SD/power service corridor, resolving both sub-1 mm margins and rerunning bounds/collisions. CAD continues without TBS; no purchase, fabrication, physical operation, Q75/Q74 change, PC implementation or Git publication occurred. Status remains claimed.

Separate electrical handoff received: [E1 engineering handoff](../../../electronics/engineering-handoff.md) records a logical native schematic and validation evidence, not physical harness release. Its E01 resistor-prose mismatch, 80 mm supplied fan leads versus older 150 mm assumption, unknown fan voltage tolerance and unsupported lamp maximum remain integration follow-ups. These records and electronics/** were not modified by this mechanical task; PC work remains untouched. The handoff's older mechanical stop statement is superseded by the user direction above.

### 2026-09-06 UTC â€” Limited shared electrical-record reconciliation

At the Electrical agent's coordination request, corrected the three switch pull-up entries in pin-allocation.csv, pi_reference.switch_contract in firmware-manifest.json and the corresponding paragraph in firmware-manifest.md to the controlling R1.1 R6/R7 value of 4.7 kÎ©. The separate U1 input pull-downs remain 10 kÎ©. No circuit, software implementation or firmware image changed.

Corrected W060/W061 in harness-netlist.csv from the unsupported 150 mm factory lead claim to the [Adafruit 3368 manufacturer's nominal 80 mm](https://www.adafruit.com/product/3368), rechecked September 6 UTC. This is supplied-tail length, not usable routed reach, a released cut length or approval of the fan's 5.2 V connection. Both rows explicitly hold routing/termination and any extension. No extension, joint, mass saving or installed route is selected or credited. Actual stock lead tolerance, stripping/termination and service slack reduce usable reach and require confirmation. Fan voltage tolerance remains Electrical's evidence hold.

JSON parsing and CSV structure/row counts (43 pins; 135 harness records) passed. Files changed: docs/hardware/baseline-r1/{pin-allocation.csv,firmware-manifest.json,firmware-manifest.md,harness-netlist.csv} and this issue comment. Electrical owns refreshing its input hashes and source-drift review; electronics/** and PC files were not edited. No CAD geometry, Q75/Q74, procurement, fabrication or physical-operation change.

### 2026-09-06 UTC â€” Electrical continuation evidence checkpoint

Reviewed the Electrical agent's [current handoff](../../../electronics/engineering-handoff.md) and [component evidence review](../../../electronics/component-evidence-review.md). The agent incorporated the exact E01/E05 shared corrections and reports unchanged native schematic geometry/connectivity (18 source files byte-identical), retained zero-violation ERC, refreshed input provenance and rejected shared-record regression mutations. Conditional I2C cases, TFmini voltage-drop ceilings and independent-rail acceptance cases improve the evidence package; they are not physical qualification.

New release holds: E10 lacks a demonstrated protection guarantee within the BEC12S-PRO's documented two-second output-short tolerance; input-fuse timing and unknown converter fault current do not establish it. E11 lacks exact rating evidence for the Generic Pololu2180/2181 AWG20 connector assemblies; JST RCY family ratings do not automatically certify them. Neither finding is a proven physical failure or an authorized hardware substitution. Electrical retains investigation ownership.

Mechanical route constraint: include all supplied 14 AWG FHM holder pigtail and splice length in the existing maximum30mm unfused path; counting only added wire is insufficient. No route, cut length, extension or mass credit is released. These evidence holds reinforce that the complete BOM is not purchase-ready. CAD can continue within the robust-design boundary; RF-GATE-01, unfinished mechanical/electrical design and Q74 remain. Issue11 stays claimed/incomplete. Only this issue comment was added by the shared owner; no baseline, electronics, CAD geometry or PC files changed.

### 2026-09-09 â€” Hardware paused; current work preserved

The owner requests a reviewed Git checkpoint, completion of the PC application, and a grilling session for its plan/design. Hardware work is paused for a future substantial change involving 3D printing. Preserve the existing engineering and open holds. No printer, material, printed component, altered geometry or manufacturing method has been selected by this request. The hardware pause supersedes earlier directions to continue digital engineering until the owner resumes it.

### 2026-09-09 Repository alignment before pre-purchase review

The owner agreed to staged pre-purchase assessment using source-backed calculations, CAD/structural checks, flight/software simulation and targeted component tests before full procurement. The owner then requested updating the repo first and asked whether phone development should precede hardware work. The proposed schedule in the phone/onboard entry point defines a small shared interface and simulated first slice, with phone software and hardware feasibility proceeding as parallel workstreams. This is sequencing, not approval of a printed airframe, purchases, physical tests or a new hardware selection.

Initial read-only review reproduced the historical endurance arithmetic and located original numerical inputs/scripts in Windows Temp; the preserved sources are not yet a runnable current-aircraft model. The 146 Wh moderate-case twenty-minute power ceiling is 366 W with the stated 4 Wh pre-reference allowance and 20 Wh reserve floor, correcting the old report's roughly 370 W statement. Current mass is still unreconciled. Further feasibility investigation was paused for this repo update; preserve these findings for resumption without treating them as new flight predictions.


### 2026-09-10 â€” Coordinated pre-purchase assessment delivered against amended Q74

The later owner decision supersedes twenty with **15 useful minutes**, with the independent reserve, full no-extra-cargo reference, workload proportions and repeated per-pack evidence retained. Current firmware acceptance metadata, safety tables, V26/V37/P25 traceability, validation register, engineering gates and model now agree; historical numerical results remain identified as historical. [Decision report](../../../docs/prepurchase-decision-2026-09-10.md) integrates both workstreams.

The [mass/energy/cost assessment](../../../docs/hardware/prepurchase-2026-09-10/assessment.md) completes 65 mass and 75 cost-obligation rows. Reference lower/planning/higher scenarios are 2,053.31/2,168.11/2,492.06 g. Planning predicts 12.63 central and 11.15 moderate useful minutes after reserve, versus 16.69/14.68 in the lower scenario. The roughly 2.04 kg moderate crossing is an investigation target without qualification margin. Cost scenarios $2,074.11/$2,095.01/$2,720.31 retain 18 unquoted obligations and unbounded costs. Loaded 250 g plus separate holder remains a distinct unqualified operating envelope, with no fifteen-minute requirement.

Retain the core provisionally and pursue supported route/mount mass reductions first. Current 6S3P, APC7x5/high-current-path, 900 KV and examined MaxAmps alternatives fail an endurance, rating, RPM or availability screen; an exact factory 6 Ah-cell pack remains only a research lead. The [integration assessment](../../../docs/hardware/prepurchase-2026-09-10/integration-assessment.md) identifies source-backed local fan, genuine preassembled cargo connector and longer strap candidates, plus unresolved regulator sustained-fault and lamp/servo evidence. None is silently selected or credited in baseline calculations.

The [preliminary placement study](../../../cad/prepurchase-2026-09-10/README.md) maps all mass rows into conditional CG/clearance studies. Eight deterministic tests pass. Actual stack, routing, AIO fastener/service, scan/rotor and load-path holds remain. Recommend secondary replaceable printed mounts/guides/shrouds/feet and a conditional holder shell with independent nonprinted retention/load paths; keep carbon frame/arms. Manufacturing-dependent CAD remains held pending print scope and stable component choices. No printer/material/process is selected and no manufacturing release is claimed.

Main-owner checks pass: energy/data regressions, cost reconstruction, placement tests, existing 61-row/33-gate CAD checker and electrical validation (147 independent expectations, seven fault mutations, three shared-record mutations). The Q74 acceptance-only source amendment is recorded in [the hash review](../../../electronics/q74-amendment-review.json); 18 native electrical files remain byte-identical. Issue12's actuator-free slice is complete with 35 passing tests, independently reviewed repairs and a runnable browser demo. No physical performance gate is passed.

Issue11 stays claimed and unreleased. Next: quantify supported mass reductions and resolve the named local engineering holds; owner choice of printed scope gates dependent CAD. Purchases, provider setup, supplier contact, fabrication, operation, upload and physical measurements need their applicable later authorization. Remote Mac access is the expected native-iPhone direction without a selected/purchased provider. Reuse-first guidance lives in canonical CLAUDE.md; no duplicate policy or unnecessary follow-up issue was created. Existing unrelated and dormant PC changes remain preserved.


### 2026-09-10 â€” Eleven-minute acceptance, paper margin and available printing resources

The later owner decision supersedes fifteen with **11 useful minutes**, preserving independent reserve, full reference equipment and physical acceptance. Current model/traceability now use 6.6/3.3/1.1-minute workload proportions. Engineering adopts a provisional 12.1-minute moderate-model target (10% headroom above acceptance, not reserve or a new acceptance minimum). Planning predicts the same 11.15 minutes: about nine seconds above acceptance, but short of design margin; 35 W auxiliaries reduce it to 10.91. The model needs 114.14 Wh for eleven, 122.79 Wh for the paper target, versus 115.31 Wh at the existing control endpoint. The target's approximate 2,137.4 g mass crossing needs 30.7 g supported reduction before candidate-component deltas; no equipment/contingency is deleted.

The owner now identifies access to ten named printers, recorded with source-backed standard capability/material comparisons in the existing [integration assessment](../../../docs/hardware/prepurchase-2026-09-10/integration-assessment.md). Recommend secondary replaceable printed parts first. Available printers resolve the earlier resource uncertainty, but not exact hardware revision, calibration, process, costs or structural release. Preserve primary carbon/nonprinted load paths and qualify part strength, heat/creep, joints, retention and process before flight use.

Add the owner's clarified final **maximum physical speed and altitude capability report** to this hardware outcome and V21 evidence. Once the configuration is finalized, state model estimates and safely demonstrated bounds with configuration/load/pack/environment and uncertainty; separate airspeed/groundspeed/climb from altitude reference and density-altitude capability. Values remain unknown now. Q74's follow speed and test height are not physical maxima. No new numeric speed/altitude requirement or expanded operational permission is inferred. No separate issue is needed to duplicate this final hardware reporting obligation.

Verification after this amendment: the deterministic model checks distinguish an eleven-minute paper pass from a 12.1-minute design-target miss, preserve reserve, and check both mass crossings. The generated model snapshot reproduces exactly; loaded cases carry no reference-duration target. All73 trace rows remain, with V21 final-performance reporting and V26/P25 margin distinctions. Cost reconstruction, CAD provenance/gate checks and electrical validation pass;18 native electrical sources and295 protected existing files remain byte-identical. Updated local links and scoped whitespace checks pass. No fabrication, physical operation, purchase or provider selection occurred.


### 2026-09-10 â€” Owner approves printing boundary and sustained detailed engineering

The owner approves printed secondary mounts, guides, shrouds, pads and appropriate hybrid holder components, retaining nonprinted primary frame/arms/motor and other safety-critical load paths. A boundary change requires a concrete consequence review before approval. Continue all useful research, routine component selections, analytical/tolerance/thermal/vibration/fatigue work and detailed Fusion CAD through the strongest attainable pre-fabrication package. Do not stop after assessment or treat a remaining physical test as blocking independent work. Reduce physical dependence using conservative digital proof, established designs, independent nonprinted retention and decisive inexpensive test/coupon/fixture designs.

Attempt Fusion first; use a repeatable script/add-in and the smallest manual run action only if direct control cannot work. Preserve source/license/version evidence and original archives. The current official connection opened a checked copy of BGD_MASTER; a workspace-property audit error was corrected, and the repository's official loopback client completed the audit after a native-read stall. Fusion2704.1.53 is callable; detailed R2 work uses a dedicated document. No original archive, unrelated document, PC work or hardware is changed. Routine source-backed local corrections are authorized; procurement, fabrication, physical operation and physical qualification are not.

### 2026-09-10 â€” R2 native package verified; concrete architecture decision

The main owner integrated the separate electrical, mechanical and mass/energy investigations into the [R2 decision report](../../../docs/prepurchase-decision-2026-09-10.md) and [native Fusion package](../../../cad/engineering-r2-2026-09-10/README.md). These later results supersede the earlier 11.15-minute checkpoint: the current lighter ledger gives **10.17 useful minutes**, and the counted R2D construction gives zero after reserve. Eleven remains the acceptance minimum, 12.1 the provisional moderate paper target. No equipment, contingency, cargo outcome or independent reserve was removed to produce a pass.

Direct Fusion control produced 146 current construction parts and actual native/STEP/secondary STEP-STL exports. Source models and original archives retain hashes/licenses. Reopened native and visible STEP exports preserve 146/115 part dimensions and volumes. Root verification passes 124 geometry screens, 121 native bounds/profile checks and ten selected interference pairs; an incorrect fan-aperture profile was repaired before final export. Separate native precision-regulator and protection-board imports verify current board datum/outline geometry. The configured hollow-rail Static Stress study reopens with valid setup; its 74,340-element mesh is not a solved result. Local Nastran is absent; isolated cloud submission remains pending authorization. No complete assembly FEA, fatigue life or physical qualification is claimed.

Selected local corrections are the documented Noctua fan, precision sensor carrier, two latch-off protection carriers, keyed Molex cargo harness, available pan/tilt kit/servos, RDQ 400 mm straps and 28 mm copper bus. Both native schematics have zero ERC violations; both routed boards have zero DRC violations/unconnected items. Independent verification passes **51 critical pin checks, 36 precision pads, 82 protection pads, ten main power segments and one via**. Six exact-part typical SPICE scenarios pass. All **32 Gerber/drill draft hashes and both current source PCB hashes** match; drafts remain NOT FOR FABRICATION. Raw Pi voltage must satisfy the calculated 5.052â€“5.270 V window for the stated endpoint/load screen. Converter tolerance, startup inrush, simultaneous loads, full fault timing and thermal behavior remain holds. The tooling record discloses possible metadata transmission by the initial router capability probe; subsequent board routing was local with analytics disabled, and current reproduction replays reviewed routes without network access.

Mechanical work resolves source-based joints, tolerances, independent support paths, conservative beams, holder kinematics and cheaper decisive fixtures. The direct-sear holder variant is rejected on switch-return/force margin; investigated stronger solenoids are not drop-in power/thermal corrections. A fully counted 106.298 g Pi support improves the heavy construction by 57.05 g; a 60 g tether concept remains an unachieved budget with explicit opposing-restraint requirements. Even deleting all three electronics supports cannot rescue that heavy construction. This does not prove a minimum attainable seven-inch mass.

The completed alternatives comparison recommends **X650 Development Kit SKU30181 / matched P15Ã—5 / factory MaxAmps 11Ah 6S** as a conditional next direction. Counted support and separate mass contingencies give **4,438.40 g**. Required energy before the loaded 22.2 V endpoint is **165.19 Wh for eleven / 177.86 Wh for 12.1**, including reserve; adverse values are 194.00 / 208.93 Wh. Actual delivered endpoint energy remains unknown. Whole-project planning arithmetic is **$3,675.79**, versus $2,169.24, retaining all 20 original unquoted obligations and adding three unresolved interface differences. Stock PDB/XT60 and full-charge current require correction; no connector adapter is credited with upgrading a bottleneck. Nine-inch and 16Ah alternatives have quantified current/control disadvantages. Research is complete enough for the **owner's adoption decision**, not another request to research. Changing to 15-inch propellers/Pixhawk, roughly doubled mass and higher cost/near-person hazards is material and has not been silently approved.

Final main-owner checks pass: current and larger-platform models, mass conservation, CG, holder/support regressions, native electrical verification, 12 assembly/study export hashes, seven pinned sources, 32 manufacturing-draft hashes and the 63-entry/13-item/27-check workspace register covering all 33 original gates. Issue12's 35 deterministic tests remain passing; its simulated biometrics are not physical evidence. All 295 protected existing files remain byte-identical and scoped whitespace checks pass. No unnecessary follow-up issue was created.

Issue11 remains **claimed and unreleased** at the concrete architecture decision. Approving that conditional direction permits the next integrated Fusion/current-path revision; procurement and physical release remain separate. The approved secondary-print boundary, remote Mac direction, final speed/altitude reporting and retired PC boundary remain intact. No purchase, fabrication, hardware operation, supplier message, firmware upload or Git publication occurred.

### 2026-09-10 â€” Revised product replaces frozen-baseline execution

The owner authorizes applying the requirement/rule audit. Issue10's current checkpoint now governs hardware design. Retire cargo-dependent completion work, the eleven-minute/12.1-minute target and mandatory X650 adoption decision. Preserve old configurations and quantitative results as historical evidence. Open architecture/process comparison and revised integrated modeling precede renewed detailed fabrication design; no current design is declared passed or released by this reconciliation.

Reconciliation verification: all three historical energy-model checks pass and retained numerical outputs are unchanged; the v1 phone simulator passes 35 tests; the CAD workspace verifier passes. Electrical document applicability changes were reverse-checked against the previous input hashes before updating provenance, and native schematic hashes remain unchanged. The legacy electrical validator then stops at a pre-existing `cad/component-inventory.csv` hash mismatch (inventory not edited in this reconciliation). Resolve that provenance discrepancy before relying on a new electrical-validation pass; no electrical or current-aircraft acceptance is claimed.

### 2026-09-11 â€” Provisional candidate C1 opened; propulsion pairing corrected

Opened a **provisional** low-cost candidate at [`docs/hardware/candidate-c1-2026-09-11/`](../../../docs/hardware/candidate-c1-2026-09-11/README.md), kept separate from the preserved revision-r3 package. Nothing in revision-r3 was modified, superseded or invalidated. Issue11 remains **claimed, not complete**, and C1 is not an approved design, a qualified aircraft or a purchase.

**Propulsion pairing corrected.** An earlier sketch applied SunnySky's published thrust table to APC propellers. That table is measured on **EOLO CN11x4.5** propellers and has been removed from the calculation path. The model now uses APC's own published performance file for the exact 11x4.5MR propeller, driven by a standard motor model built from SunnySky's published Kv and winding resistance. The EOLO data appear only as an independent check on the motor model: above 5000 rpm the model agrees within 9.7% on thrust, 14.9% on power and 4.5% on efficiency. Because APC's computed thrust exceeds the EOLO measurement at every matched rpm, a 0.93 model derate is applied. The earlier sketch also produced a **false failure**: it extrapolated the EOLO table by affinity and reported 0.970 endpoint thrust/weight. APC's file runs to 10000 rpm so no extrapolation is needed, and endpoint thrust/weight is **1.674**. That correction is recorded, not defended.

**C1 integrated result:** 1728 g, $811.60 parts, adverse mission demand 65.82 Wh against 71.04 Wh available at 80% of an 88.8 Wh pack, endpoint thrust/weight 1.674 at a 3.30 V/cell endpoint, full-charge 2.55, hover at 36% of the motor's current rating and 21% of its power rating, 16% rpm headroom to the APC multirotor limit, full-command pack current 35.3 A. Delivered **$925.13 at 8% tax / $942.26 at 10%** on the free-signing route; **$1032.05 / $1051.16 and therefore over the ceiling** with a paid Apple Developer membership. 270 g of the mass and $150.00 of the parts cost are allowance-based; both gates still pass at +30% on the allowance rows and the energy gate fails near +45%. Energy fails at 70% usable pack capacity.

**Interfaces.** The board's own hwdef gives eight UARTs plus USB and two I2C buses, so routing the lidar, rangefinder, temperature sensor and security element through the flight controller fits with two UARTs spare. ArduPilot carries an in-tree `AP_Proximity_LD06` driver for this lidar family and supports VL53L1X. The pinned Copter-4.7.1 Lua bindings expose a raw I2C `transfer`, so an ATECC608 anchor is reachable from script, and the existing `state_anchor.py` transaction fixture is device-agnostic so the tested revocation behaviour is preserved by construction. **The driver itself is unwritten, the wake timing from Lua is unproven, counter capability is inferred rather than verified, and the breakout is out of stock.**

**Explicitly unresolved and not closed by C1:** dark navigation, obstacle coverage outside the scan plane, the security anchor driver, link-loss behaviour, face recognition at range in darkness, the 100 m link, and whether a 6 GB phone runs the search model at all. No cost saving in C1 depends on treating any of these as closed. The app-signing fee is not the only remaining blocker. Both C1 scripts reproduce a published revision-r3 result bit-exact before scoring anything new.

**Next:** `test-plan.md` T1 (does the C1 feature set still fit the board's flash) and T2 (ONNX Runtime memory and quantised accuracy) need no hardware and no spending. T3, the phone workload probe on one Pixel 6a, is the smallest decisive physical test and needs spending authorisation. No purchase, vendor contact, firmware upload, CAD or application development occurred.

### 2026-09-11 â€” C1 hardware-free checks: firmware fits, compute route obstructed

Two checks ran with no purchase, no vendor contact and no firmware upload. Evidence in [`docs/hardware/candidate-c1-2026-09-11/`](../../../docs/hardware/candidate-c1-2026-09-11/README.md). C1 remains provisional; Issue11 remains **claimed, not complete**; the $1,000 delivered ceiling is unchanged.

**T1 firmware fit â€” PASSED.** Built ArduCopter from a fresh clone at tag `Copter-4.7.1`, commit `dbe792162d06cab66c3475fd5556bf7a120f119e` â€” the same commit already pinned by the earlier motor-output audit â€” with the repository's retained gcc-arm-none-eabi toolchain. Stock MicoAir743v2 image: 1,433,560 B used, **270,372 B flash free**, against the retained RC-guard image's 269,972 B. The stock image already links `AP_Proximity_LD06` (nine symbols confirmed by `arm-none-eabi-nm`), `AP_RANGEFINDER_VL53L1X_ENABLED` and `AP_SCRIPTING_ENABLED`. **C1's sensor routing needs no custom firmware.** A first reading of `extract_features.py` output concluded the lidar driver was absent; that was wrong â€” the script has no LD06 pattern at all â€” and the correction is recorded in `firmware-check.md` rather than dropped. A control build forcing the define changed flash by 16 bytes, confirming redundancy.

**T2 compute route â€” OBSTRUCTED.** Re-measuring the exact retained 64-token export under ONNX Runtime instead of PyTorch gives **2,069.6 MiB peak working set and 4.7-5.7 s per frame** at two desktop threads â€” worse than the 1,381 MiB PyTorch figure, not better. All-op int8 dynamic quantisation produces a graph ONNX Runtime cannot execute (`ConvInteger` not implemented). MatMul-only int8 works: 248.9 MiB on disk, 1,787.1 MiB peak, 1.9-2.0 s per frame â€” **2.5x faster, only 14% less memory**, because activations dominate.

The decisive finding needed no hardware: the graph's **48 `GridSample` nodes are supported by neither ONNX Runtime's NNAPI nor its XNNPACK execution provider**. No Android accelerator can take this model, so the phone would run it on CPU, slower than the desktop figures. C1's airframe, propulsion, energy, interfaces and cost still stand; its assumption of onboard description-based search at useful rate does not. Options recorded in `compute-route.md`: accept slow search and write the mission logic to it; replace the model with a two-stage CLIP-style open-vocabulary design that avoids `GridSample`; or relocate search to the ground iPhone, which is a requirement boundary and an owner decision, not assumed here.

**No hardware purchase requested.** `hardware-dependency.md` records exactly what one phone would and would not resolve, ranks the design-breaking uncertainties, and concludes that dark navigation, planar-coverage geometry and the security-anchor driver are stated requirements substantially answerable with no money, so spending first on the partly-digital question is the wrong order. Queued free work: quantised-graph accuracy against the retained parity fixtures, dark-navigation illumination arithmetic, planar-coverage geometry, the ATECC608 Lua driver against `state_anchor.py`, and link-loss re-analysis under the new sensor routing.

### 2026-09-11 â€” C1: authority repair preserved; cheap search alternative tested and failed

No purchases, no vendor contact, no external commitments, no firmware uploaded. C1 stays **provisional**; Issue11 stays **claimed, not complete**; the $1,000 delivered ceiling is unchanged. Cost, propulsion and energy results remain provisional while their assumptions are open.

**Manual-takeover repair preserved and measured.** The previous note's "no custom firmware needed" applied only to sensor drivers and was too broad. The mandatory authority repair `electronics/revision-r3/phone-rc-priority.patch` **applies cleanly** to the freshly cloned pinned tree and costs **416 bytes**: stock 270,372 B free, patched **269,956 B free**, against the retained revision-r3 figure of 269,972 B â€” a 16-byte agreement that corroborates both builds independently. The C1 flight image is the patched image. Stock sensor-driver availability does not replace this repair and must not be read as doing so.

**Accelerator claim narrowed.** What is established is that the two ONNX Runtime execution providers checked (NNAPI, XNNPACK) do not list `GridSample`, so on the retained ONNX route the model would execute on the phone CPU. It is **not** established that no Android acceleration is possible: other execution providers, vendor NNAPI driver implementations and other runtimes such as LiteRT with a hardware delegate were not checked and would each carry their own conversion and operator-coverage question. No phone latency is inferred from desktop timing in either direction.

**The cheap GridSample-free alternative was tested on object LOCATION and failed.** A CLIP ViT-B/32 two-stage pipeline scored 157 dense multi-scale windows on the identical public image used by the retained GroundingDINO run (SHA256 verified), against that run's recorded boxes. Results: "a cat" top-1 IoU **0.186** (best in top-5 0.365); "a remote control" top-1 IoU **0.178** (best in top-5 0.293); both centres fall inside a reference box but neither reaches IoU 0.5. Top-1-to-top-5 similarity spread was only **0.0083** and **0.0300**, so the argmax is near-arbitrary among plausible windows. The absent query "a forklift" returned a box at similarity 0.2081 against the cat's 0.2705 â€” the same range, with no calibrated way to decline. Three distinct failures: it cannot draw the box, it barely discriminates, and it cannot refuse. Dense windows were used deliberately so the test isolates CLIP rather than proposal quality; a learned proposal network would fix only the first failure and adds unevaluated model mass and compute. Reproducible in `docs/hardware/candidate-c1-2026-09-11/alt-search-probe.py` with results alongside.

**Consequence for C1.** Airframe, propulsion, energy, interfaces and cost stand provisionally. The cheap escape from the compute obstacle is closed. The leading option is now to retain GroundingDINO, accept multi-second search latency, and write the mission logic to that constraint â€” which preserves every requirement while separating search from following and avoidance, functions the requirements already distinguish. Relocating search to the ground iPhone remains a requirement boundary and an owner decision; it is not assumed.

**Still unresolved and explicitly not closed:** dark navigation, obstacle coverage outside the lidar scan plane, the ATECC608 security-anchor driver, link-loss behaviour under the new sensor routing, face recognition at range in darkness, the 100 m link, LiPo usable capacity, frame mass, and all on-device behaviour. Next queued free work: planar-coverage geometry, dark-navigation illumination arithmetic, the ATECC608 Lua driver against `state_anchor.py`, and quantised-graph accuracy against the retained parity fixtures.

### 2026-09-11 â€” C1: obstacle coverage and dark navigation quantified

No purchases, vendor contact, external commitments or firmware upload. C1 remains **provisional**; Issue11 remains **claimed, not complete**; the $1,000 ceiling is unchanged; cost, propulsion and energy stay provisional while their assumptions are open. Reproducible scripts and results in `docs/hardware/candidate-c1-2026-09-11/`.

**Obstacle coverage â€” partially addressed, now quantified.** Geometry from the LD19's documented specs (0.72 deg angular resolution, 10 Hz scan, 5000 Hz sampling, 0.03-12 m, retained in `software-d500-wiki.html`). **The sensor does solve what it was chosen for:** a 350 mm torso is guaranteed a return well past the sensor's 12 m range limit, walls and rack posts likewise, so the side/rear ingress case that motivated the planar scanner is addressed. **It does not close coverage.** Angular sampling means a 5 mm wire is guaranteed a return only inside **0.40 m**, shorter than the 0.60 m stop reservation â€” there is no closing speed at which this sensor sees a wire in time. A 20 mm branch gives 2.0 s of margin at 0.5 m/s; a 10 mm twig 0.4 s. Near-field vertical coverage is **4-16 % of the 220 mm airframe extent at 1 m** across an assumed 0.5-2.0 deg divergence sweep, since the maker does not publish divergence; the slab first spans the full airframe height only at 6.3-25.2 m. The inverse taper is structural to any planar scanner. Nothing above or below except the downward VL53L1X at about 4 m. A second scanner in a vertical plane (about $48.50, 55 g) would address the out-of-plane near field but **not** wires, where the limit is angular resolution. Recorded, not selected, not costed in.

**Dark navigation â€” quantified for the first time in this project.** Three independent limits. Illuminance: a 10 W COB at 120 deg gives 287 lx at 1 m, 32 lx at 3 m, 4.5 lx at 8 m. Exposure: the 10 ms ceiling is set by **yaw, not translation** (30 deg/s smears a feature about 7 px), so the lamp cannot be traded against exposure time; a usable frame needs 17.7 lx at ISO 3200, landing within 20 % of DJI's published 15 lx vision-positioning threshold as an independent sanity check. Combined: a **4.02 m navigable bubble at ISO 3200**, 5.68 m at ISO 6400. Narrow beams reach further but light only 39 % of the camera field, trading away the feature spread tracking needs.

**The bubble cannot be bought larger.** Re-running the integrated model with an enlarged lamp: 6 m needs 22 W and passes with 1.8 % energy margin; **8 m needs 40 W and fails the energy gate** (75.08 Wh required against 71.04 Wh available); 12 m, matching the lidar, needs 89 W. In darkness the camera is the binding constraint, not the scanner.

**Failure mode exposed:** confined dark spaces work â€” a warehouse aisle or treeline puts a surface inside the bubble â€” while **open dark spaces do not**, because visual tracking has no textured surface in range even though the lidar still reports geometry to 12 m. That distinction is not expressed in the requirements or mission logic and is the difference between darkness working and not.

**Face work is resolution-limited, not light-limited:** a 150 mm face spans 80 px only inside **2.68 m** at the streamed 1920 px width. Trusted enrollment and verification are unaffected, since the Issue12 contract already uses a fixed close zone, but searching for a person *by face reference* at night requires closing to about 2.7 m while staying inside the 4 m navigable bubble. The mission logic does not express that.

**Both results are bounded operating cases, which Issue10 explicitly permits â€” but the bounds are material and belong in front of the owner rather than assumed away.** Neither changes the C1 BOM: a bigger lamp fails the energy gate and a narrower beam defeats the tracking it serves.

### 2026-09-11 â€” C1: security anchor driver written and its transaction validated

No purchases, vendor contact, external commitments or firmware upload. C1 remains **provisional**; Issue11 remains **claimed, not complete**; the $1,000 ceiling is unchanged. Artefacts: `docs/hardware/candidate-c1-2026-09-11/atecc608-anchor.lua` and `atecc608-protocol-check.py` with results alongside. **10 of 10 checks pass.**

**The wake is feasible, from source rather than assumption.** ArduPilot's ChibiOS HAL defaults `HAL_I2C_MAX_CLOCK` to **100000** (`libraries/AP_HAL_ChibiOS/I2CDevice.cpp:54`, comment: "default to 100kHz clock for maximum reliability") and the MicoAir743v2 hwdef does not override it. The `lua_get_i2c_device` binding accepts a per-device bus clock and the ChibiOS `I2CDevice` constructor only ever *lowers* the bus, never raises it. At 100 kHz a write to I2C address 0x00 clocks eight zero bits and holds SDA low about **80 us**, against the documented **60 us** tWLO. At 400 kHz it would be 20 us and fail; the driver records that the bus must not be raised. `SCRIPTING_MAX_NUM_I2C_DEVICE` is 4, and C1 needs two handles (device plus wake address), leaving two.

**Device parameters are documented, no longer inferred.** Counter command opcode **0x24** with mode 0x00 read / 0x01 increment, two monotonic counters in the Configuration zone, maximum **2,097,151**, CRC-16 polynomial **0x8005** initialised to zero, LSB transmitted first. This closes the earlier note that counter capability was inferred from the ATECC508A/608A family without verification.

**The CRC implementation is externally validated**, not merely self-consistent: the published ATECC608 wake response `04 11 33 43` has the CRC of its first two bytes as its last two. The implementation computes `33 43`.

**The tested revocation behaviour survives the swap.** This is the result that matters for the requirement. `phone_drone_feasibility/state_anchor.py` depends only on an abstract `Anchor(identity, generation)`, so it was driven end to end with a simulated hardware counter supplying `generation` in place of a TPM: roster revocation commits; restoring an old disk copy fails closed because the counter advanced; a crash before the counter leaves the old state valid with the counter untouched; a crash after the counter fails closed and refuses further change. The existing four-test `test_state_anchor` suite still passes unchanged. The USB TPM at $65 and 15 g can be replaced by a $4.95, 1.8 g part without losing the tested behaviour.

**Still unproven, and stated plainly:** no byte-level correctness against real silicon â€” the simulated device is a model of my reading of the documentation, so agreement with it proves nothing about the part; whether Lua's coarse scheduled slot can meet tWHI and command execution delays is unmeasured; counter slot provisioning, configuration-zone locking and the authorisation policy for who may increment are absent; key storage and attestation are not modelled, only the counter; and the Adafruit 4314 breakout is **currently out of stock**, so an equivalent source would have to be found before any purchase.

The security anchor moves from "unresolved, weakest link in C1" to "design validated at protocol and transaction level, device execution unproven".

### 2026-09-11 â€” C1: quantisation accuracy cost measured; link-loss re-analysed

No purchases, vendor contact, external commitments or firmware upload. C1 remains **provisional**; Issue11 remains **claimed, not complete**; the $1,000 ceiling is unchanged.

**Quantisation accuracy (T7).** Route 1 for the compute architecture â€” keep GroundingDINO, accept slow search â€” leans on int8 quantisation, so its accuracy cost was measured rather than assumed. Reused the repository's own retained parity path: same cached model revision `a2bb814d`, same public image, same processor, same 0.4/0.3 post-processing thresholds, four queries, FP32 ONNX against int8 MatMul-only ONNX. Result: **localisation is untouched** â€” every matched box at IoU **0.987** or better, so quantisation does not move boxes. **Scores shift by up to Â±0.0569**, and that cost one detection: 8 found by FP32, **7 matched, 1 missed, 0 spurious**. The loss was a borderline detection falling below the retained 0.4 threshold. Lowering the threshold might recover it at the cost of false positives; untested.

**The speedup is NOT established, and the earlier figure should not be quoted alone.** The isolated T2b probe measured 2.5x. This run, with both sessions alive in one process alongside Torch, measured **1.17x** (median 5.277 s FP32 against 4.496 s int8). The honest position is that the real speedup lies somewhere between and depends on memory and thread pressure that no host run reproduces for a phone.

**Link-loss re-analysis (T8).** C1's sensor routing changes what survives a phone failure, so the authority analysis was redone rather than inherited. **The change is a material improvement.** In revision-r3 the lidar reached the FC only through the phone (sensor â†’ CP2102N â†’ phone â†’ MAVLink â†’ FC), so a dead phone process took *all* obstacle awareness with it, leaving GNSS, IMU and RC for recovery â€” the worst combination in a dark GNSS-denied warehouse. Under C1 the lidar is on an FC UART with ArduPilot's own `AP_Proximity_LD06` driver and the rangefinder on FC I2C, so **a dead phone leaves the flight controller with live proximity and altitude data** for its native avoidance, Land and RTL. The consolidation motivated by cost and mass improves the failure mode that matters most. Internet loss, iPhone-link loss and RC loss are unchanged.

**New risks recorded:** the phone supplies USB VBUS to the FC as host, so a phone crash or reboot toggles VBUS and drops SERIAL0 â€” back-power behaviour on this board is unverified; native proximity avoidance versus the `phone-rc-priority.patch` authority rules is **reasoned but untested** (the patch gates companion commands, not native avoidance, which is the correct behaviour for a pilot taking over, but the retained 26-case SITL comparison does not cover it and would need extending); and acting confidently on a stale, vertically-sparse proximity picture during an unattended recovery is a hazard the map-validity work already flagged for the phone-side planner and which now applies to the FC-side planner too.

**One product question surfaced, not answered:** the coverage and dark-navigation results together mean that with a dead phone in a dark space the aircraft would recover with a partial obstacle picture and no visual pose source beyond a 4 m bubble. What the aircraft *should* do when it cannot see is a product decision, not an engineering parameter.

### 2026-09-11 â€” C1: avoidance/authority interaction settled at source; free work queue exhausted

No purchases, vendor contact, external commitments or firmware upload. C1 remains **provisional**; Issue11 remains **claimed, not complete**; the $1,000 ceiling is unchanged.

**Avoidance cannot be gated by the authority patch â€” established structurally, not by sampling.** The previous note listed this as reasoned but untested. The patch introduces exactly one predicate, `Copter::companion_radio_authority()`, and its call sites in the patched tree are exhaustively `ArduCopter/mode.cpp:344` (guarded by `reason == ModeReason::GCS_COMMAND`), seven sites in `ArduCopter/GCS_MAVLink_Copter.cpp`, and `ArduCopter/AP_Arming_Copter.cpp:677` (guarded by `AP_Arming::method_is_GCS`). **Every one is a GCS or companion command path.** Avoidance is applied inside the flight modes' own control loops â€” `mode_althold.cpp:70` on climb rate and `:80` on roll and pitch via `copter.avoid` â€” and `AC_Avoidance`, `AC_WPNav` and `AC_AttitudeControl` contain **zero** references to the predicate. The patch therefore cannot gate native proximity avoidance, and because the relevant call is in AltHold, **a pilot taking manual control keeps obstacle braking**. A behavioural SITL case would still be worth writing; the retained `sitl_rc_guard.py` harness is where it belongs and its 26 cases do not cover avoidance. A SITL build was started for that purpose and is not needed for the structural answer.

**The free-work queue is now exhausted.** Completed this session, all reproducible in `docs/hardware/candidate-c1-2026-09-11/`: firmware fit and the 416-byte authority-patch cost; ONNX Runtime footprint; quantisation and its accuracy cost; the CLIP alternative tested on localisation and failed; planar coverage geometry; dark-navigation arithmetic; the ATECC608 anchor driver and transaction check; link-loss re-analysis. Regression state: 35 `phone_drone_sim` tests pass, the C1 propulsion and system models reproduce a published revision-r3 result bit-exact, and the ATECC608 check passes 10 of 10.

**What now blocks further useful digital work.** Every remaining uncertainty needs either hardware or an owner decision:

- *Hardware only:* phone workload, memory and thermal behaviour; LiPo usable capacity at the modelled load; the propulsion model against a real motor and propeller; frame mass; ARCore tracking under vibration; ArduPilot avoidance on real LD06 returns; USB VBUS back-power on this board.
- *Owner decision only:* which compute route to take now that the cheap alternative has failed; whether the bounded operating cases are acceptable (wires never detected in time, open dark spaces unnavigable, face search requiring closure to 2.7 m); and which iOS signing route to use, since the paid route breaches the ceiling and the free route imposes a 7-day refresh obligation.

The purchase argument recorded in `hardware-dependency.md` has been restated: the ordering reason for declining the phone was that three stated requirements were answerable for free, and they now have been. That reasoning no longer applies, though no purchase is requested here.

### 2026-09-11 â€” C1: manual-takeover authority repair re-verified, 26/26 reproduced

No purchases, vendor contact, external commitments or firmware upload. C1 remains **provisional**; Issue11 remains **claimed, not complete**.

The firmware check established that the authority patch applies cleanly and costs 416 bytes. It did **not** establish that the patch still behaves correctly, and C1 claims to inherit a working repair, so that claim was tested rather than assumed.

Re-ran the retained 26-case SITL comparison against the retained hash-pinned binaries in `~/issue11-sitl/`, both variants. **Both reproduce exactly: patched PASS 26/26, official PASS 26/26, zero differences against the retained check results.** The manual-takeover repair C1 inherits is verified working, not merely present.

The retained harness writes into `docs/hardware/revision-r3/`, which is preserved evidence. The wrapper `docs/hardware/candidate-c1-2026-09-11/reverify-authority-repair.sh` backs those four files up, runs both variants, diffs the results, and **restores them byte-for-byte** on exit, including on failure. Confirmed restored. The comparison output is written to the candidate folder instead, at `authority-reverify-results.json`. No retained evidence was modified.

Combined with the source-level result that the patch's predicate is reachable only from GCS and companion command paths â€” so it cannot gate native proximity avoidance, and a pilot taking over into AltHold keeps obstacle braking â€” the manual-takeover behaviour is now the best-evidenced part of C1.

### 2026-09-11 â€” C1: 100 m link computed, radio conflict found; SITL avoidance probe abandoned

No purchases, vendor contact, external commitments or firmware upload. C1 remains **provisional**; Issue11 remains **claimed, not complete**; the $1,000 ceiling is unchanged.

**Correction to the previous checkpoint.** It claimed no digital check remained that could change the answer. That was wrong: the **100 m link had never been computed** in this project, unlike coverage and darkness which were quantified. It is arithmetic, not hardware, and it has now been done.

**The 100 m link: budget closes, but C1 created a radio conflict.** At 100 m the path budget gives -65.2 dBm at 2.4 GHz (+13.8 dB over a 19.5 Mbps link rate, ample for a 4 Mbps stream) and -73.7 dBm at 5.8 GHz (+5.3 dB). Adding the ground-reflected ray with the operator at 1.5 m, **2.4 GHz stays usable at every aircraft height tested (2, 5, 10, 20 m) while 5.8 GHz fails the 10 dB criterion at 2, 5 and 10 m** â€” exactly the heights used near people and indoors.

**The conflict:** C1 places the phone Wi-Fi radio about 0.15 m from the ELRS receiver. Free-space coupling at that spacing puts the phone's transmission at roughly **-8.7 dBm at the ELRS receiver, about 99 dB above its typical -108 dBm sensitivity**, and ELRS hops across the same 2.4 GHz band. This threatens the **independent manual takeover link** â€” a safety function, not the video. Wi-Fi on 2.4 GHz gives a working video link and desenses takeover; Wi-Fi on 5.8 GHz protects takeover and fails the video geometry at normal heights. Neither band satisfies both. **Separating the services requires moving the control link to 915 MHz**, which is a required BOM change. It is **not costed in** â€” sourcing needs vendor pages not retrieved. Estimated tens of dollars against $57.74-$74.87 of headroom on the free-signing route, so unlikely to break the ceiling, but that is an estimate and `bom.csv` is unchanged apart from a flag on the affected row.

**A second, self-inflicted conflict:** the heat spreader C1 budgets against phone throttling sits directly over the handset's antennas. Added for thermal reasons with no consideration of detuning or blockage; the two requirements pull against each other. Also flagged in `bom.csv`.

**SITL proximity-avoidance probe: abandoned, not established.** Attempted to verify that ArduPilot acts on injected proximity data. Four iterations, none of which reached any avoidance logic: the first skipped arming and takeoff so the aircraft never flew; the second was a patch that **silently no-opped** because the search string contained an escaped backslash and `str.replace` returns the original without complaining; the third reached arming and failed on throttle failsafe; the fourth added synthetic UDP RC mirroring the retained harness and still failed at arming, with the SITL log lost to the WSL temp namespace. **This is a defect in my harness, not a finding about ArduPilot**, and it implies nothing about whether avoidance works. Stopped because further diagnosis needs in-process STATUSTEXT capture and several more SITL cycles against a question whose answer is ordinary upstream behaviour. Recorded in `sitl-avoidance-results.json` with the full attempt history rather than dropped.

The separate source-level conclusion is unaffected and did not depend on that probe: the authority patch predicate is reachable only from GCS and companion command paths, with zero references in `AC_Avoidance`, `AC_WPNav` or `AC_AttitudeControl`, so it cannot gate native proximity avoidance.

### 2026-09-11 â€” C1: avoidance demonstrated end-to-end; RF and cooling conflicts resolved without a BOM change

No purchases, vendor contact or external commitments. Public product-page research only. C1 remains **provisional**; Issue11 remains **claimed, not complete**; the $1,000 ceiling holds with more headroom than before.

**Avoidance: PASS, demonstrated, not inferred.** After seven diagnostic iterations the SITL probe works against the retained hash-pinned `arducopter-rc-guard` binary and retained fixtures. Prearm demands proximity when `PRX1_TYPE=2` ("PreArm: PRX1: No Data"); the injected stream is echoed back as `DISTANCE_SENSOR` (current_distance 2000, min 19, max 2500, orientation 5), which is direct confirmation of ingestion; the aircraft arms after the radio selects Guided, takes off to 10.11 m, and with an obstacle inside the 4 m margin **travel drops from 213.65 m to 42.08 m, an 80.3 % reduction**, peak speed 5.45 to 1.00 m/s.

**The probe refuted one of my own source-inspection claims.** I had argued from the call graph that because avoidance is applied in `mode_althold.cpp`, a pilot taking over into AltHold keeps obstacle braking. **In AltHold there was no measurable limiting: 308.52 m clear against 312.97 m blocked.** Only Loiter restrained the aircraft. AltHold limits lean angle, which a full-forward stick defeats; Loiter limits velocity and stops. The call graph told me the code runs; it told me nothing about whether it restrains a determined pilot. **Obstacle protection during manual takeover is therefore NOT established** and is a new open design question. Whether AltHold's ineffectiveness is inherent or an `AVOID_ANGLE_MAX` consequence of the retained fixture was not determined.

Two of the seven failures were themselves informative: three rounds failed at arming because **the authority patch was refusing GCS arming without radio Guided readiness â€” the repair working as designed**, which I misread as a harness bug; and one patch **silently no-opped** because a search string contained an escaped backslash and `str.replace` returns the original without complaining, so a stale run nearly read as a repeated result. Full history in `sitl-avoidance.md`.

**RF coexistence: 915 MHz is NOT required, and my earlier conclusion was wrong.** I compared the interferer to receiver *sensitivity* and reported "99 dB above sensitivity". Sensitivity is noise-limited; a strong in-band interferer acts through blocking and desense. The decision-relevant quantity is control-link margin: **ELRS 2.4 GHz at 100 mW receives -60.2 dBm at 100 m against a -108 dBm sensitivity, about 48 dB of surplus**, and ExpressLRS documents 2.4 GHz LoRa as tolerating Wi-Fi noise reasonably at short range while warning against it for long range. C1 is a 100 m application. Supported options ranked in `link-budget.md`: Wi-Fi Direct or hotspot on **5 GHz** with ELRS staying on 2.4 (the Pixel 6a is dual-band Wi-Fi 6E with Wi-Fi Direct, so **zero BOM change**), antenna placement discipline per ExpressLRS guidance, a true-diversity receiver, and 915 MHz only as a fallback. The receiver row in `bom.csv` is **retained**, its pending-change flag removed.

**Cooling: conflict dissolved rather than traded.** The heat spreader sat over the handset's perimeter antennas. Rather than choose between thermal and RF, the cooling was re-derived from downwash the aircraft already produces: momentum theory gives **5.31 m/s** induced velocity at the disc, removing about **3.9 W at a 25 K rise** against an estimated 6 W load, where still air would need an impossible 147 C surface. Revision: ducted downwash over the phone's back with any conductive spreader confined to the inboard SoC footprint, clear of the perimeter frame. `PHONECOOL` goes from 15 g / $10.00 to **10 g / $6.00**. The thermal requirement is unchanged and now met by airflow. Honest caveat: the back settles near **65 C** at the conservative case â€” adequate, not generous, and not a thermal qualification.

**Updated delivered cost:** **$920.81 at 8 % tax / $937.86 at 10 %** on the free-signing route, $79.19 and $62.14 under the ceiling. The paid Apple Developer route remains over at $1,027.73 / $1,046.76.

**No product-level tradeoff requires the owner at this point.** Every item this round resolved into an implementation choice within delegated authority.

### 2026-09-11 â€” C1A digital package completed and reviewed

Continued from the reconciled checkpoint without restarting. Verified tool access first (KiCad CLI 10.0.6; official Fusion loopback MCP initialize, tools/list and a read-only listing of the ten open documents; `.mcp.json` added as the supported Claude project configuration, effective in a new session), then delegated component-dimension sourcing to a bounded subagent and integrated its DOC/EST results.

Resolved the answerable gaps: manual-takeover protection (new T13 SITL probe, PASS: Loiter stops, AltHold unprotected, EKF failsafe lands, AltHold available, Loiter refused without position); recovery branches configured and mapped to the contract; compute route 1 selected; cooling re-derived for the actual layout; RF reconciled to the receiver position. Corrected four design errors found while integrating (30 A fuse under the 35.3 A full-command current; XT60 on an EC5 pack; lamp bracket in front of the lens; phone intruding into the tray) and one margin failure (4,000 mAh pack at -0.1 % after sourced masses; 5,000 mAh design point, +148 g, +$5).

Produced the integrated deliverables: parametric layout with mass/CG/frustum/laser/clearance checks; native Fusion build and exports with interference and mesh verification; four drawing sheets; harness, manifest, native KiCad schematic (ERC 0), parameters and 33 checks; authority/recovery interfaces; resource allocation; operating envelope and speed/altitude estimates; assembly instructions; 17 prepared physical tests; traceability; integrated package check 37/37. Regressions pass (35 simulator, 65 feasibility, revision-r3 electrical, anchor protocol, T9 authority). Preserved revision-r3 and R2 evidence untouched.

Completion is digital only. Physical qualification, receiving measurements and Issue12 companion software remain open as listed in the checkpoint. No purchase, vendor contact, fabrication, firmware upload, commit or push occurred.

### 2026-09-11 â€” Completion claim reconciled; status corrected to conditionally complete

At the owner's direction, reconciled the earlier "complete" claim with the unresolved product decisions. Result: the digital package is **conditionally complete**. The cost criterion is met only on the free app-signing route, whose terms are now quoted from primary sources (Apple: 7-day profiles, 3 apps per device, 10 App IDs; AltStore: apps expire after 7 days, refresh needs AltServer on the same Wi-Fi, installs `.ipa` files; GitHub: standard runners free on public repositories, 2,000 minutes on private ones). Whether that obligation is a usable app is the owner's decision; the paid route is over the ceiling by $74-94 and no capability-preserving cut closes it.

Classified every other bound against Issue10: wires and open dark interiors are bounded cases the requirement text permits (validation T-AV-1, T-DARK-1); face search by closing to 2.7 m is Issue10's repositioning rule; slow search has no rate requirement; AltHold takeover protection is not required; folding is a preference. Corrected the envelope: outdoor darkness is navigable by GNSS, the bubble limits perception and indoor pose.

Closed the remaining digital feasibility items that bear on hardware choices: measurable mission cases computed from the camera and lidar geometry (face 2.8 m; person 42.7 m by camera and 12 m by lidar; 1,139 m2 searched or 4,892 m2 scouted in the useful time); the flight controller forwards only eight 45-degree proximity sectors to the phone (pinned source), so the phone-side planner design and the +$16 raw-scan option are recorded. Added T-SRCH-1, T-SCOUT-1, T-FOLLOW-1 and T-APP-1 to the prepared programme. The one remaining optional digital item, loading the search model in a 6 GB Android emulator, needs about 1.5 GB of free SDK downloads and gives weak positive evidence; recorded, not run. No established check was repeated; no purchase, fabrication, upload or Git publication occurred.

### 2026-09-11 (night) â€” Handoff during acceptance-gap reconciliation

Owner direction: keep Issue11 incomplete, preserve C1A, resolve whether the 8-sector proximity interface supports required planning/avoidance/recovery, do not treat GNSS as obstacle safety in darkness or geometry as recognition performance, separate sourced app pricing from the unverified workflow, evaluate engineering alternatives before any product decision. Work done and remaining is in the checkpoint above; T14 was left running with retrieval instructions. Scripts saved: `sitl-oa-planning-probe.py`, `face-scale-probe.py` (results written), `mission-cases.py`, `app-delivery.md` (pricing sourced, workflow unverified). No established check was repeated. No purchase, fabrication, upload, commit or push.

### 2026-09-11 (resumed) — Bounded side-entry feasibility assignment: repair fails

Owner authorized only the prepared assignment. Claude reproduced the five
`ld19-slender-gear-results.json` cases bit-exactly through the unchanged
`mesh-entry-braking.replay`, confirmed session 18704 absent on Windows and WSL,
and ran `side-entry-feasibility-screen.py` (model venv; 35 replays, 17 fail).
Decision and case table: [side-entry-feasibility-decision.md](../../../docs/hardware/candidate-c1-2026-09-11/side-entry-feasibility-decision.md).
Findings: the 2 m criterion is centre separation in the replays while T14's 2 m
is vehicle-to-obstacle clearance (both reported); the 5.1189 m guard is a
no-contact guard. The inherited trace's sinusoidal bank returned through zero;
a wind-balanced sustained roll of 1–2 degrees toward a 1.2 m entrant removes all
returns (6.9 mm margin) and ends in contact. The admitted 1.2-degree gap makes the
sourced 4.7625 mm rod mask two adjacent rays; a 0.3 m entrant centred behind a
leg is hidden until 0.51 s, and the braking ramp costs 0.227 m, so Variant 1
fails 8 of 10 named cases including level (1.810 m). Variant 2 (plane lowered
0.15/0.25/0.35 m on longer rods, camera kept at 1.3 m) passes bank/altitude
cases only from 0.25 m (2.049 m) but never the level leg-shadow case (1.825 m);
0.25 m and 0.35 m put the ground return inside the guard under braking pitch
plus 2-degree roll and add 86–105 g of rod before brackets. Lowering flight
height is excluded by the retained 1.25 m search-time failure. Untested and not
credited: a rod at or under 3.16 mm with a 0.25 m drop. Prior `ld19-low-entry`
and `mesh-entry-braking` results are stale by hash and were preserved, not
regenerated. No commit, purchase, contact, device or physical action. Work paused
at the assignment's stopping condition; the next continuation needs new owner
direction.
