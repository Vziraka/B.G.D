# Produce the frozen-baseline hardware build package

Type: task
Status: claimed
Blocked by: 10

## Current checkpoint

**Claimed and unreleased; hardware paused by the owner on September 9.** The owner requests PC application completion first and anticipates a substantial hardware change involving 3D printing. Preserve the current baseline and holds; no printed redesign or manufacturing decision has been approved. Earlier digital-execution permissions do not override this pause.

**On resumption:** settle the 3D-printing design scope and assess affected interfaces before continuing the isolator/fastener joint, AIO service corridor and [electrical evidence holds](../../../electronics/engineering-handoff.md). H01–H12, electrical protection/rating evidence and mass/cost reconciliation remain unfinished. [Received-frame measurements](../../../cad/received-frame-inspection-gate.md) still gate sensitive fabrication of the preserved design.

Q75/Q74 and all approved requirements remain. This ticket does not authorize purchases, physical fabrication/operation, firmware upload or PC-ticket implementation; the PC workstream has its own authorization. Historical checkpoints below retain their evidence but do not reinstate superseded stops.

## Scope

Q75 approves the conditional hardware architecture and authorizes the next artifact stage. Complete the dimensioned custom fabrication drawings, final pin-level harness/netlist, firmware/configuration manifest and safety/state truth tables in [the hardware package](../../../docs/hardware/baseline-r1/README.md). Keep all requirements and components frozen unless new evidence exposes a genuine incompatibility or requirement failure; then redesign only the affected subsystem and record the impact.

No hardware purchase without explicit procurement authorization. No physical operation, firmware upload or implementation of the eight PC tickets.

## Acceptance

- Every custom assembly in the buildability gate has a drawing or an explicit evidence-based design-release hold; never substitute an unmeasured dimension with an invented fact.
- Every electrical interface has source/destination pins, power domain, gauge, length, connector/termination, protection and supporting hardware.
- Firmware is tied to an immutable release/commit and artifact hash; measured commissioning values remain distinct from paper-fixed values.
- Safety/state tables preserve M1 manual learning, later biometric-enabled arming, independent in-flight takeover, protected reserve and recipient-only landed/disarmed release.
- Cross-check geometry, source provenance, net/resource conflicts, quantities, mass/cost impact and requirement traceability. A package with unresolved design holds is not marked released for fabrication or flight.

## Comments

### 2026-09-03 — Started after Q75

Issue10 is resolved as planning complete. This task owns the engineering artifacts and their release readiness. Physical acceptance remains pending in V01–V40 and procurement is not authorized.

### 2026-09-03 — Initial R1 artifact package and R1.1 correction

Created19 dimensioned SVG study sheets plus vector PDF/cut list,135-record harness/netlist and topology,43-row pin allocation, source/hash firmware manifests, safety/state truth tables and73 acceptance trace mappings. Root/delegated reviews and mechanical corrections are recorded in [review-record](../../../docs/hardware/baseline-r1/review-record.md).

**Actual incompatibility found:** the selected$8 QS8-S item is a two-pack series adapter. Under Q75's explicit affected-subsystem authorization, replace only that interface with another genuine bare QS8 male and existing8AWG stock/qualified solder process. The charging connector remains separate; selected battery, motors, props, frame, FC and sensors stay unchanged. Correct switch polarity, all four AHCT channels and the short D500 USB cable at the same interface-definition stage.

**Not complete:** H01–H12 in [mechanical-build](../../../docs/hardware/baseline-r1/mechanical-build.md) explicitly identify unfinished slider/mast/gear/latch/guard/carrier/route details and source-dependent interfaces. These are detailed-engineering holds, not falsely classified as physical tests. The old70g main-path allocation and100g support allocation are exceeded by partial accounting; [mass/cost reconciliation](../../../docs/hardware/baseline-r1/mass-cost-impact.md) must finish before updated propulsion/endurance and complete-price claims. Stock ArduPilot cannot supply the approved all-path biometric gate; mandatory FC implementation and its fault tests remain required.

Issue11 remains **claimed**, not resolved. No further user approval is needed to continue ordinary engineering within Q75. Purchase remains forbidden without explicit procurement authorization; no PC-ticket implementation was started here.

### 2026-09-04 — Digital engineering architecture stage

Created the CAD/electronics architecture requested before procurement. The [stage report](../../../cad/stage-report.md) records the read-only Fusion/KiCad environment audit, source-of-truth rules, 61-row component/CAD inventory, planned Fusion master tree, 13-item fabrication backlog, planned KiCad hierarchy and 27 digital checks covering all 33 distinct buildability gates.

The authoritative TBS Source One V6 7-inch DXF is pinned to commit 232ccff173c556d23cc857f0c07a6eaa66ddbc41 and its existing ignored cache was rehashed. Master axes are X right, Y forward, Z up, with XY origin at the motor-axis centroid. The source is 2D manufacturing geometry and does not establish assembled Z.

No Fusion master assembly or KiCad schematic is claimed. Fusion GUI/API control is not demonstrated; KiCad CLI version access is demonstrated. The exact next task is CAD-T01: import/inspect the pinned frame DXF in Fusion at 1:1 mm and verify its profiles, motor centres and hole datums before adding components. This task stops before detailed CAD generation as requested.

PC Ticket 2 code/tests/spec/issues, the shared map/root ignore/configuration and all unrelated working-tree changes were intentionally left unchanged. No purchase, installation, fabrication, physical operation, stash, reset, commit or push occurred. Issue 11 remains claimed.

### 2026-09-05 — Architecture-stage revalidation

Re-ran the requested environment/workspace audit without detailed CAD generation. Fusion remains 2704.1.53 with no demonstrated shell/API document control; KiCad CLI10.0.6 remains callable by full path. The engineering checker passes all61 inventory rows,13 custom work items,27 digital checks/33 source gates and the pinned Source One cache hash.

Corrected the inventory taxonomy to the user's exact latest definitions: self-created models based on manufacturer dimensions are class4 simplified envelopes, not class2 authoritative third-party CAD. No class1 or class2 model is claimed without an acquired model. Updated validation outcomes to the exact `STILL REQUIRES ...` labels. No BOM, requirement, component or architecture changed.

Stopped before CAD-T01 as requested. PC implementation and all unrelated working-tree changes remain untouched; no purchase, installation, fabrication, commit or push occurred.

### 2026-09-05 — Integration investigation before CAD-T01

At the user's explicit change of sequence, paused frame-reference work and completed the [Fusion/KiCad/Codex integration investigation](../../../docs/research/fusion-kicad-codex-integration-2026-09-05.md). Installed Fusion 2704.1.53 ships the official MCP library and schema variants; Codex supports compatible transport. Actual connection, tools and script access remain untested. Recommended official local Fusion MCP with the official API as complement/fallback, and installed KiCad CLI plus native-file authoring for the present harness/schematic work. Third-party candidates were inspected without execution or installation.

No configuration, application preference, permission or listener was changed. The user's latest instruction requires approval before integration commissioning. After that approval and appropriate connection checks, resume the exact CAD-T01 learning/measurement task, preserving its provisional extraction artifacts and final review checkpoint. No Fusion import/reference component has yet been verified. PC Ticket 2, Q75 and Q74 remain unaffected; issue11 stays claimed.

### 2026-09-05 — Approved official Fusion MCP commissioning

The user's "Approve" authorized the preceding limited commissioning proposal. Enabled Autodesk's official loopback MCP preference and created the project-local inspection profile; no third-party installation or global Codex/KiCad configuration change. Handshake, live four-tool discovery, blank-document inspection and API-doc queries succeeded. The installed Codex CLI recognizes the profile. See the [commissioning report](../../../docs/research/fusion-local-mcp-commissioning-2026-09-05.md) and linked captured evidence.

Actual modeling uses a general Python tool, which remains disabled under the proposal's privilege-review gate. Native tool attachment to this running task and client prompt enforcement remain unverified; direct diagnostic HTTP reads do not prove those controls. Refresh/check this hardware task only, without disturbing PC Ticket 2, before testing the native read tool. General script execution needs explicit privilege approval and verified client control; do not bypass the disabled tool with HTTP writes.

Resumed independent CAD-T01 preparation: corrected the provisional DXF verifier's section handling, measured mounting pitches, curved-profile limitations and proposed right-handed axes. Source checks and the architecture manifest check pass. [Import readiness](../../../cad/reference/source-one-v6-7in/import-readiness.md) records the remaining front/layer/datum review. No import, BGD_MASTER, native archive or detailed custom CAD is claimed. Q75/Q74, procurement prohibition, PC implementation and unrelated changes remain untouched. Issue11 stays claimed.

### 2026-09-05 — Native connection follow-up after Continue

The current task still reports `unknown MCP server 'bgd_fusion'`, despite a successful fresh official Fusion initialization and the CLI recognizing the existing project inspection profile. Reopening this task did not load the integration. A read-only attempt through the CLI's supported existing app-server proxy failed to connect to its default control socket; no app-server daemon, new model task or listener was started. The protocol schema confirms reload is a client operation covering loaded tasks, not a demonstrated per-task refresh available here.

Next human-side diagnostic is to inspect **Codex Settings → MCP servers** for `bgd_fusion` and its status before choosing the documented MCP restart control. Do not repeat the unverified reopen-only instruction, restart the whole app during PC work, or add a duplicate global server. Python modeling remains disabled and no frame import is claimed. Only this hardware issue/environment note changed during the follow-up; PC Ticket2 and existing unrelated changes remain untouched.

### 2026-09-05 — Native Fusion inspection works after app restart

The current task now exposes `fusion_mcp_read` and successfully used it to list the open blank document and read official DXF/unit API documentation. The native catalog matches the inspection-only project configuration. The connection-loading blocker is resolved; prior unknown-server notes are historical.

Execute remains disabled. Its general Python privileges need the explicit decision retained by the commissioning proposal. [Current status and exact proposed permission/configuration](../../../cad/fusion-connection-status.md) defines reviewed CAD-T01 scripts, no unrelated documents, no network/process execution, non-overwriting repository outputs and a stop at frame-reference review. Per-call prompt enforcement is not claimed: the recommendation requires informed task-specific authorization rather than assuming prompts provide containment. No modeling/import or PC work occurred, and no configuration was changed this turn.

### 2026-09-05 — Broad digital hardware engineering execution authorized

The user explicitly approves Fusion Python/API for the whole B.G.D. Issue11 digital engineering effort, not just frame-reference scripts. Continue autonomously with pinned-frame verification, master assembly, custom mechanical design, placement, digital checks, drawings/exports, repository records and appropriate KiCad engineering. Resolve evidence-based design choices without reopening approved requirements. The former CAD-T01-only permission and required stage stop are superseded.

Q75/Q74 and existing Issue11 artifacts remain controlling. Redesign the smallest affected subsystem only when evidence reveals incompatibility or requirement failure. Distinguish documented facts, calculations, assumptions and physical gates. No purchase/spending authorization, physical fabrication/operation, physical firmware upload or destructive/irreversible action outside the engineering workspace. PC work remains separate. Enabled the existing official MCP Execute tool in the project configuration; no third-party installation or global configuration change. The official loopback transport can carry authorized scripts without interrupting another task for catalog refresh.

### 2026-09-05 — Executed CAD reference and adapter screen; frame evidence gate

Fusion Python executed successfully through the approved official MCP. Created actual `BGD_MASTER`, verified10mm units and1:1 pinned-source motor centres, copied exact curved profiles, and saved a local F3D/adapter STEP/preview with hashes. [Current evidence and continuation gate](../../../cad/engineering-progress-2026-09-05.md) supersedes historical claims that no master/import exists. The final captured partial model contains16 visible solids and zero solid intersections; it omits major aircraft and frame hardware and is not a complete buildability pass.

An actual study-geometry conflict affects only M01: the55mm blank overlaps four nominal frame standoffs. A48mm candidate retains both mounting patterns and gives1.3833mm nominal clearance, with calculated blank mass6.6294g instead of8.7636g. The revised dimensioned study and STEP are unreleased pending H01 fastener/grommet/services/structural checks. No purchased subsystem or requirement changed.

The pinned July DXF's2mm plate labeling disagrees with the current manufacturer's2.5mm bottom specification. Stack hypothesis A obstructed the intended mounting paths; B clears modeled solids/axes but remains an engineering hypothesis. Frame-dependent release needs authoritative current-revision/assembly confirmation or a clearly named incoming-part measurement gate. An unsent technical inquiry is included in the report. No manufacturer message, purchase or physical measurement is claimed.

H01–H12, complete mass/cost/endurance accounting and full aircraft layout remain unfinished. Existing harness/pins/firmware/safety tables are retained; no native KiCad ERC/DRC or complete fabrication package is claimed. Q74 remains mandatory. This is an evidence checkpoint at a frame-source gate, not Issue11 completion. PC code/tests/issues and unrelated work were left untouched; no Git publication occurred.

### 2026-09-05 — Focused frame-revision resolution attempt and review stop

At the user's requested narrow checkpoint, completed a primary-source revision audit and read-only native Fusion geometry recheck. See [nine-part mechanical review and prepared inquiry](../../../cad/reference/source-one-v6-7in/revision-resolution.md), [dimension/confidence register](../../../cad/reference/source-one-v6-7in/dimension-register.csv), and [manufacturer-source research](../../../docs/research/source-one-v6-revision-audit-2026-09-05.md).

Q75 identifies the exact retail configuration Source One V6 7-inch DC (`prod:source1v6`), but not a manufacturing lot or supplier-confirmed drawing change level. The live published7-inch file is still the pinned July07 drawing. Its2mm labels are actual TEXT entities, while `$THICKNESS` is0.0. No first-party evidence resolves the conflict with the current2.5mm product-page bottom plate. Classification: **documentation conflict remains unresolved**. No newer7-inch revision or verified layer/Z-stack assignment was asserted.

No Fusion geometry or F3D/STEP/drawing changed. The unchanged hypothesis-B model passes its prior16-body intersection screen; the48mm bare adapter gives minimum1.3833129101mm standoff gap and2mm middle-plate gap. This is not final adapter qualification. Dampers, USB/SD, power bends, bus/harness, screw depths and airflow/service space remain explicitly unverified. Motor-slot geometry was measured from all four source arms; no safe motor screw engagement or current-stock fit was inferred.

Stopped for owner review as requested, before release or large-scale CAD. The concise TBS inquiry is prepared, **not sent**, and requires messaging authorization. After manufacturer evidence, the exact next CAD task is a versioned confirmed frame stack with omitted structural/fastener envelopes followed by the full AIO mount/service audit. Issue11 remains claimed; no Q75/Q74 change, procurement, fabrication, physical operation or PC work occurred.

### 2026-09-05 local — User-directed robust design; no TBS correspondence dependency

The user explicitly prohibits sending the prepared TBS inquiry and authorizes continued conservative digital work. Neither 2.0 nor 2.5 mm is selected as authoritative. The documented range plus chosen allowances, worst-case method, results and limitations are in [the robust AIO review](../../../cad/robust-aio-review.md). Historical source reports remain unchanged evidence; their correspondence/review stop is superseded here.

The 48 mm outline fails the chosen 1 mm clearance target under an admissible case (0.136 mm). A new separate 45 mm Fusion envelope study yields a conservative 1.039 mm planar bound. The full mounting assembly does not pass: conditional topology-B under/top fastener bounds are 0.342/0.485 mm, generic all-side service reservation collides, and actual connector/wire/joint details remain unfinished. Original BGD_MASTER and old F3D/STEP are unchanged and unreleased. Unknown assembly order and the two unassigned 20 mm supports cannot be manufactured into certainty by a thickness envelope.

[RF-GATE-01](../../../cad/received-frame-inspection-gate.md) requires measured plate/arm/spacer thicknesses, support locations/lengths, assembled stack, hole centers, fastener geometry and actual clearances before dimension-sensitive fabrication. Receipt alone does not qualify unfinished CAD. The next CAD task is the actual isolator/fastener joint and AIO USB/SD/power service corridor, resolving both sub-1 mm margins and rerunning bounds/collisions. CAD continues without TBS; no purchase, fabrication, physical operation, Q75/Q74 change, PC implementation or Git publication occurred. Status remains claimed.

Separate electrical handoff received: [E1 engineering handoff](../../../electronics/engineering-handoff.md) records a logical native schematic and validation evidence, not physical harness release. Its E01 resistor-prose mismatch, 80 mm supplied fan leads versus older 150 mm assumption, unknown fan voltage tolerance and unsupported lamp maximum remain integration follow-ups. These records and electronics/** were not modified by this mechanical task; PC work remains untouched. The handoff's older mechanical stop statement is superseded by the user direction above.

### 2026-09-06 UTC — Limited shared electrical-record reconciliation

At the Electrical agent's coordination request, corrected the three switch pull-up entries in pin-allocation.csv, pi_reference.switch_contract in firmware-manifest.json and the corresponding paragraph in firmware-manifest.md to the controlling R1.1 R6/R7 value of 4.7 kΩ. The separate U1 input pull-downs remain 10 kΩ. No circuit, software implementation or firmware image changed.

Corrected W060/W061 in harness-netlist.csv from the unsupported 150 mm factory lead claim to the [Adafruit 3368 manufacturer's nominal 80 mm](https://www.adafruit.com/product/3368), rechecked September 6 UTC. This is supplied-tail length, not usable routed reach, a released cut length or approval of the fan's 5.2 V connection. Both rows explicitly hold routing/termination and any extension. No extension, joint, mass saving or installed route is selected or credited. Actual stock lead tolerance, stripping/termination and service slack reduce usable reach and require confirmation. Fan voltage tolerance remains Electrical's evidence hold.

JSON parsing and CSV structure/row counts (43 pins; 135 harness records) passed. Files changed: docs/hardware/baseline-r1/{pin-allocation.csv,firmware-manifest.json,firmware-manifest.md,harness-netlist.csv} and this issue comment. Electrical owns refreshing its input hashes and source-drift review; electronics/** and PC files were not edited. No CAD geometry, Q75/Q74, procurement, fabrication or physical-operation change.

### 2026-09-06 UTC — Electrical continuation evidence checkpoint

Reviewed the Electrical agent's [current handoff](../../../electronics/engineering-handoff.md) and [component evidence review](../../../electronics/component-evidence-review.md). The agent incorporated the exact E01/E05 shared corrections and reports unchanged native schematic geometry/connectivity (18 source files byte-identical), retained zero-violation ERC, refreshed input provenance and rejected shared-record regression mutations. Conditional I2C cases, TFmini voltage-drop ceilings and independent-rail acceptance cases improve the evidence package; they are not physical qualification.

New release holds: E10 lacks a demonstrated protection guarantee within the BEC12S-PRO's documented two-second output-short tolerance; input-fuse timing and unknown converter fault current do not establish it. E11 lacks exact rating evidence for the Generic Pololu2180/2181 AWG20 connector assemblies; JST RCY family ratings do not automatically certify them. Neither finding is a proven physical failure or an authorized hardware substitution. Electrical retains investigation ownership.

Mechanical route constraint: include all supplied 14 AWG FHM holder pigtail and splice length in the existing maximum30mm unfused path; counting only added wire is insufficient. No route, cut length, extension or mass credit is released. These evidence holds reinforce that the complete BOM is not purchase-ready. CAD can continue within the robust-design boundary; RF-GATE-01, unfinished mechanical/electrical design and Q74 remain. Issue11 stays claimed/incomplete. Only this issue comment was added by the shared owner; no baseline, electronics, CAD geometry or PC files changed.

### 2026-09-09 — Hardware paused; current work preserved

The owner requests a reviewed Git checkpoint, completion of the PC application, and a grilling session for its plan/design. Hardware work is paused for a future substantial change involving 3D printing. Preserve the existing engineering and open holds. No printer, material, printed component, altered geometry or manufacturing method has been selected by this request. The hardware pause supersedes earlier directions to continue digital engineering until the owner resumes it.
