# Fusion, KiCad and Codex integration investigation

Date: 2026-09-05. Status: **investigation complete; integration approval pending**.
Repository base: `68e00796f56d1975b05efa8e8f3c5c5fd504b6ac`; this report is an uncommitted working-tree artifact. Its companion [evidence manifest](fusion-kicad-codex-integration-evidence-2026-09-05.json) records its hash and inspected sources.

## Recommendation

Use **Codex → Autodesk's official local Fusion MCP → the running Fusion application**, complemented by reviewed, repository-managed Fusion Python API operations. Use **Codex → explicit KiCad file edits → installed kicad-cli validation/exports** for the present six-sheet harness/schematic task. Reconsider a KiCad MCP only when repeated editing or live PCB interaction supplies a demonstrated benefit.

The installed Fusion includes official MCP implementation assets. No third-party Fusion add-in is necessary to attempt this route. However, a successful live connection and the exact tools exposed by this installation remain untested. Do not promise that every bundled schema variant will appear in the live catalog.

No packages, add-ins, MCP entries, application settings, permissions or listeners were installed, changed or enabled. No remote repository code was executed. PC Ticket 2 and the interrupted CAD files were left untouched during this investigation. Q75 and Q74 remain unchanged. The user's latest instruction requires approval before integration changes; CAD-T01 resumes afterward, following the approved route.

## Comparison: capabilities

| Route | Direct control | Read/inspect | Write/create | CAD or schematic creation | Validation | Save/export |
|---|---|---|---|---|---|---|
| Official Fusion MCP | Live Fusion session | Bundled geometry, parameters, profiles, document, timeline and screenshot queries; active variant pending | Bundled create/update/delete and execute schemas | Sketches/features/parameters directly; components, joints and DXF through official API if script execution is exposed | Geometry queries and API measurements; requires result checks | Document save is bundled; neutral/archive export through API if execution available |
| Fusion Python/API | In-process script or add-in; needs a launch mechanism | Detailed object model, transforms, geometry and physical properties | Broad API editing | Sketches, components, occurrences, joints, parameters and DXF import | API measurements and model/feature checks | Native save plus F3D/STEP and supported exports |
| Faust Machines Fusion MCP | stdio bridge to Fusion add-in | Scene, components, bounds, properties, measurements | Named tools plus arbitrary Python | Sketches, assemblies, joints, parameters; no dedicated DXF import in reviewed tool list | Measurement/interference tools advertised; not tested here | F3D/STEP/STL tools |
| KiCad CLI + file edits | CLI controls jobs; file edits are a separate authoring operation | Netlists, rendered schematic/PCB, reports; file inspection | CLI is not a symbol/wire editing API; Codex can author native files separately | Native schematic files can be created/edited and then parsed/rendered/checked | Official ERC/DRC, including CLI failure exit codes | Netlist/BOM/PDF/SVG; PCB Gerber/drill/position/STEP and other exports |
| KiCad MCP Pro (oaslananka) | stdio or optional HTTP; PCB IPC plus CLI/file backends | Project, symbols, nets, sheets, board and reports | Tools for schematic/PCB editing; operation-dependent backend and limitations | Symbols/wires/labels/hierarchy and PCB tooling; schematic round-trip caveats | Wraps CLI ERC/DRC plus additional checks | CLI-backed manufacturing exports; separate manufacturing mode |
| Official Fusion Data MCP | Autodesk cloud data services | Hubs/projects/folders/items | Data organization and access administration | No established live sketch/assembly authoring role | No mechanical qualification role | Data management; not a substitute for local geometry export |

## Comparison: deployment and suitability

| Route | Codex compatibility | Setup complexity | Security boundary/risk | Maturity | B.G.D. usefulness |
|---|---|---|---|---|---|
| Official Fusion MCP | Documented HTTP transport matches Codex; local connection untested | Low: built-in toggle and client entry | Loopback, no authentication; live-session access; no demonstrated B.G.D.-only enforcement | Autodesk currently labels it General Availability; tools are dynamic | Preferred mechanical route, subject to commissioning |
| Fusion Python/API | Codex can author/read scripts; direct execution via MCP conditional | Low for manual script; higher for a custom bridge | Code runs with Fusion user's privileges; no automatic repository sandbox | Established official API; each method/version must be checked | Required complement and fallback |
| Faust Fusion MCP | Explicit Codex claim and stdio implementation | Medium: Python dependencies plus installed Fusion add-in | Unauthenticated TCP bridge; arbitrary Python; additional supply chain | Small community project, package metadata 0.1.0; no GitHub releases at inspection | No established advantage sufficient to justify installation |
| KiCad CLI + file edits | Demonstrated local CLI execution and filesystem access | Lowest; already installed | No extra listener; process still has current user's file rights | Official KiCad 10.0.6 | Preferred now for harness/schematics and traceable review |
| KiCad MCP Pro | Documented stdio/HTTP support and Codex configuration | Medium/high: Python 3.13+, many dependencies; optional IPC configuration | Project path guards, readonly default, tool profiles; not an OS sandbox | Active community project, self-described stable; specific editing limitations remain | Best control-oriented candidate in this focused comparison; defer adoption |
| Fusion Data MCP | Codex supports HTTP/OAuth; Autodesk account flow not tested here | Additional account consent and client configuration | Cloud account/project permissions, including administrative mutations | Autodesk labels General Availability | Omit: unnecessary permission scope for CAD-T01 |

Official transport/deployment descriptions: [Autodesk overview](https://help.autodesk.com/view/fusion360/ENU/?guid=FMCP-OVERVIEW), [MCP product maturity](https://help.autodesk.com/view/ADSKMCP/ENU/), [Codex MCP documentation](https://learn.chatgpt.com/docs/extend/mcp). Detailed local-schema findings below supplement those public summaries.

## Autodesk Fusion: installed support and operations

### Installed evidence

The recorded deployment remains Fusion **2704.1.53**, independently read from `fusion_version.txt`. It contains `NsMCP10.dll` and `Fusion/Server/Fusion/Resources/MCP/`, including tool descriptions and JSON schemas. Binary strings include `MCPServerEnabled`, `MCPServerPort`, `127.0.0.1` and `localhost`. These are direct evidence that this build ships the implementation, not proof that the user's UI toggle, account entitlement or live service is currently available.

A read-only listener-table check found no listener on the documented default port 27182 at inspection. No HTTP initialization or tool call was attempted. We did not inspect or change the Fusion Preferences UI. Autodesk's connection guide does not state an exact minimum build or license tier; those facts remain unestablished. There is no evidence-based reason to update/reinstall Fusion merely to attempt enabling its already-bundled MCP.

### Setup requirements, after approval only

Open Fusion and keep it open. Autodesk documents **Preferences → General → API → Fusion MCP Server (runs locally on this device)**. The default endpoint is `http://127.0.0.1:27182/mcp`; a changed preference port requires a matching client URL. A Codex HTTP connection does not require the Claude-specific extension described in Autodesk's example. No Python package or third-party add-in is specified for this route. [Autodesk connection instructions](https://help.autodesk.com/view/ADSKMCP/ENU/?guid=ADSKMCP_FusionDesktopMcp_connecting_to_the_fusion_mcp_server_html).

The current public catalog calls the official local server **General Availability**, rather than preview. That does not establish stability of a 72 MB DXF import or guarantee a fixed tool schema. Some Autodesk deep links intermittently returned Page Not Found during retrieval; the overview, product catalog, indexed connection instructions and installed resources were cross-checked.

### What the bundled schemas establish

| Requested operation | Installed evidence | Qualification needed |
|---|---|---|
| Create/edit sketches | `CreateSchema`: `sketch`, `sketchEntity`, projection and sketch patterns; entities include line/circle/rectangle/ellipse | Live catalog and a scratch-design test; not all constraints/entities are established as standalone tools |
| Create/edit features | Extrude/revolve/fillet/hole/shell/patterns and other create/update/delete descriptions | Check target document and returned feature health |
| Parameters | `userParameter`; read user/model parameters; update support | Read expression/value back with units |
| Components/assemblies | No explicit component/joint constructor in the inspected Create enum | Official API via script, if exposed; otherwise manual API execution |
| Existing geometry | Read variants include bodies/faces/edges, centroids, lengths, areas, volumes, sketches/profiles, timeline, screenshots | The script-oriented read variant is smaller; actual availability must be discovered |
| Measurements | Length/area/volume/centroid queries are bundled | Exact motor-center distances and transforms need geometry/API calculations, not merely minimum surface distance |
| DXF import | No dedicated DXF operation in inspected typed schemas | API `createDXF2DImportOptions` then `importToTarget` |
| Save/open/close | Both Execute schema variants contain document operations | Unsaved document handling and save target must be checked; no unrelated document closure |
| Export | No dedicated export operation in inspected typed schemas | Official ExportManager through script/API, with output path and file verification |

`ExecuteSchema.json` explicitly allows `featureType="script"` with Python contents. Its bundled description specifies a `run` entry point and returned print/error output. **`ExecuteSchema_t2c.json` allows only document operations.** We cannot infer which variant is exposed remotely. Do not modify hidden flags or application resources to force script access.

The official API supports [component occurrences](https://help.autodesk.com/cloudhelp/ENU/Fusion-360-API/files/Occurrences_addNewComponent.htm), [DXF sketch import](https://help.autodesk.com/cloudhelp/ENU/Fusion-360-API/files/ImportManager_createDXF2DImportOptions.htm), [measurements](https://help.autodesk.com/cloudhelp/ENU/Fusion-360-API/files/MeasureManager_measureMinimumDistance.htm), and [archive export](https://help.autodesk.com/cloudhelp/ENU/Fusion-360-API/files/ExportManager_createFusionArchiveExportOptions.htm). Creation of import/export options alone does not perform the operation. API length values commonly use centimetres internally; millimetre display settings do not remove the need for explicit conversion and measured verification.

### Permissions and boundaries

The local MCP has no authentication according to Autodesk. Loopback limits remote reachability; it does not distinguish trusted from untrusted processes on this PC. We did not establish Origin validation, a per-tool server-side permission system, or an enforced project/document allowlist. Do not assume any exists.

The read schema can search across projects when a project filter is omitted. The active document is mutable shared application state. A repository configuration entry neither confines the signed-in Autodesk account nor prevents another local process from reaching the server. Python execution, if exposed, should be treated as code execution with Fusion's Windows-user privileges, including possible filesystem and network access. Undo is not rollback for external files or network effects.

Recommended operating controls: loopback only, enable for the CAD session, use a dedicated B.G.D. document, assert its identity before every mutation, serialize operations, permit only reviewed tool names, explicitly approve general script execution, and constrain our scripts' input/output paths. These reduce operator mistakes; they are **not a security sandbox**. Enforced protection against a malicious same-user process would require a separate OS security boundary, outside the current setup proposal.

## Official Fusion Data MCP

This is the cloud data-management service, with Autodesk account authentication and HTTP/OAuth client requirements. Its purpose includes hubs, projects, folders, items and permissions/collaborators. It does not require Fusion to remain open. These functions add cloud administrative scope rather than solve local DXF authoring. Do not connect it for this stage. Exact OAuth scopes, consent behavior and per-project restrictions were not proven in this environment. [Autodesk's service description](https://www.autodesk.com/products/fusion-360/blog/introducing-the-autodesk-fusion-data-mcp-server/).

## Traditional Python/API fallback

Fusion injects `adsk` into its own script/add-in environment. The earlier shell test established that invoking its bundled Python interpreter alone does not provide that environment. Codex can maintain reviewed scripts under `cad/scripts/`; the user can launch them through Fusion's Scripts and Add-Ins UI if the official MCP cannot run them. A persistent add-in can provide automation, but then its dispatcher, filesystem access and lifecycle become code we must review and maintain.

Prefer direct official MCP execution of a reviewed script where available. Otherwise retain manual invocation while Codex inspects exported results. Do not install a persistent bridge simply to eliminate one manual click. Maintain explicit document identity, source hashes, units, result measurements and exported revision evidence in either path.

## Third-party Fusion comparison

The strongest relevant comparison inspected was [faust-machines/fusion360-mcp-server](https://github.com/faust-machines/fusion360-mcp-server), at commit `0372f142385e582230bc6e68446df4f4d42ac829` (2026-08-03). The repository advertises 89 tools; a stdio Python server forwards to an in-Fusion add-in over localhost TCP port 9876. Source review confirmed socket dispatch without authentication. The catalog includes named modeling/assembly/inspection/export operations plus arbitrary Python. Python 3.10+, MCP, anyio and click are declared. Codex is explicitly named. No GitHub release was listed at inspection; package metadata is 0.1.0. The README warns of 30-second command timeouts and batching problems. Dedicated DXF import is absent from the reviewed catalog. These limits matter for our large source file. [Pinned socket implementation](https://github.com/faust-machines/fusion360-mcp-server/blob/0372f142385e582230bc6e68446df4f4d42ac829/addon/server/socket_server.py).

Its material advantage is a larger set of named convenience tools, potentially avoiding custom API snippets. That advantage does not yet justify an additional add-in, unauthenticated listener and supply chain when the official API can provide the operations. Do not use its optional bind-all/LAN recipe. Tool safety annotations are hints, not access enforcement. This was a focused source inspection, not a security certification or executed compatibility test.

Also inspected [Joe-Spencer/fusion-mcp-server](https://github.com/Joe-Spencer/fusion-mcp-server/tree/4dce1f696c20b4b9a40a0a5c4e168ec55b84d77f): last main-branch commit 2025-04-22; smaller sketch/parameter/resource surface, HTTP SSE at loopback port 3000 and a file-command fallback. It requires installing MCP into Fusion's bundled Python environment. Codex's current documented transport is Streamable HTTP rather than a promise of compatibility with this older SSE route. Its age, application-environment modification and smaller surface make it an inferior candidate. Authentication was not established in this limited review.

## KiCad: demonstrated CLI and MCP assessment

### Existing direct automation

Executed read-only `version` and help commands from `C:/Users/zvent/AppData/Local/Programs/KiCad/10.0/bin/kicad-cli.exe`; version is **10.0.6**. Installed help confirms schematic ERC/export and PCB DRC/export/import/render commands. ERC and DRC offer JSON reports and `--exit-code-violations`. This demonstrates executable access and command availability, **not that B.G.D. has passed ERC or DRC**; no B.G.D. schematic/board exists yet. [Official CLI reference](https://docs.kicad.org/10.0/en/cli/cli.html).

The CLI cannot place symbols/wires as a general interactive authoring API. Native-file editing must preserve UUIDs, symbol definitions, pin numbers, hierarchy, net labels, project paths and library mappings. For our six-sheet harness, build in a dedicated electrical directory, render each sheet, run ERC on the root schematic and compare exported nets with the approved harness/pin records. ERC cannot prove wire gauge, connector polarity, current capability, safe arming behavior or the accuracy of a modeled module's internal wiring.

KiCad's official IPC API is the modern live-plugin route. On KiCad 9/10 it requires a running GUI; exports still use the CLI. Its stable release scope is predominantly the PCB editor; a third-party tool claiming schematic operations may use file editing or require a different API/build. Do not transfer KiCad 11/master capabilities to 10.0.6. Windows transport uses named pipes. [Official IPC limitations](https://dev-docs.kicad.org/en/apis-and-binding/ipc-api/for-addon-developers/index.html).

### Best control-oriented candidate: KiCad MCP Pro

Reviewed [oaslananka/kicad-mcp-pro](https://github.com/oaslananka/kicad-mcp-pro/tree/2b18efabaa9230114ffb286ca0831dc517bb8b90), commit `2b18efabaa9230114ffb286ca0831dc517bb8b90` dated 2026-09-05; source package version 3.34.0. It is actively maintained and self-labels stable; this is not KiCad endorsement. It combines native-file edits, PCB IPC and CLI, exposing symbol/footprint/net/sheet operations plus ERC/DRC and exports. Its [capability matrix](https://github.com/oaslananka/kicad-mcp-pro/blob/2b18efabaa9230114ffb286ca0831dc517bb8b90/docs/compatibility/capability-parity.generated.md) explicitly documents a schematic-library global-label loss condition, guarded refusal/restoration, partial property editing and experimental pin/gate swaps. Safe arbitrary schematic round trips are therefore not established.

Source inspection of `config.py`, `path_safety.py` and `operating_modes.py` found an explicit workspace root, path resolution/containment checks, default readonly mode and separate write/manufacturing/experimental gates. stdio avoids an HTTP listener; HTTP/authentication and bridge modes are optional. Telemetry defaults off, but an inherited OTLP endpoint can enable it. The process still has its Windows user's rights: path guards are application controls, and their existence does not prove every tool calls them. Use a narrow `electronics` workspace, explicit environment and restricted tool list if later trialed. [Path guard source](https://github.com/oaslananka/kicad-mcp-pro/blob/2b18efabaa9230114ffb286ca0831dc517bb8b90/src/kicad_mcp/path_safety.py), [configuration source](https://github.com/oaslananka/kicad-mcp-pro/blob/2b18efabaa9230114ffb286ca0831dc517bb8b90/src/kicad_mcp/config.py).

Python 3.13+ is compatible with the installed system Python, but numerous MCP, KiCad, schematic-parser, validation and telemetry dependencies would need installation and review. No extra in-KiCad plugin is necessary for file/CLI operations; live PCB operations require IPC enabled and an editor running. Project creation/edits would require explicit write mode. Manufacturing exports exist but would stay outside the initial review profile. Package versions and artifact hashes must be pinned; do not execute a moving `uvx ... latest` recipe.

One concrete documentation defect: its pinned `.codex/config.example.toml` uses `[[mcp_servers]]`, while the current Codex format and the project's own client guide use `[mcp_servers.<name>]`. Do not copy the former. The core MCP protocol compatibility is documented; this particular example is inconsistent.

### Other KiCad candidates screened

[mixelpixx/KiCAD-MCP-Server](https://github.com/mixelpixx/KiCAD-MCP-Server/tree/aa53d52c2e37a13cb3574a6e0acf2c728b4d6bfb) has substantially broader community adoption and a v2.7.0 release dated 2026-08-20. Its architecture combines Node/TypeScript, Python, SWIG/IPC, kicad-skip and CLI. Recent documentation records fixes for schematic corruption and Windows process failures; live IPC remains described as experimental. It supplies symbol, hierarchy, net, validation and export tooling, but a comparably clear enforced workspace/readonly boundary was not established in the inspected files. Package metadata is also inconsistent between package.json 2.7.0 and pyproject.toml 2.4.0. More dependencies and overlap with existing CLI weaken its current B.G.D. case.

[obhox/kicad-mcp](https://github.com/obhox/kicad-mcp/tree/1b4872b7566afe1c18aa3a88867e0df28ab63db8) is a smaller Rust/IPC/file/CLI candidate with a July 2026 commit and claimed 171 tools. It was screened, not fully audited. Neither adoption counts nor tool counts establish safety or correct KiCad 10 schematic editing.

## Actual Codex configuration and proposed controls

Read-only local inspection found **codex-cli 0.148.0**, callable from the installed Codex `bin` directory. Its `mcp add --help` supports an HTTP URL or a stdio command. The active user configuration is `C:/Users/zvent/.codex/config.toml`; its explicit MCP table contains `node_repl`. No Fusion/KiCad entry was found there. Plugin-provided tools are separate from this explicit table. Sensitive environment/header/argument values were not printed or copied.

No `B.G.D./.codex/config.toml` exists, and no explicit B.G.D. trust entry was found in the inspected user file. A trusted project's `.codex/config.toml` is supported by current Codex documentation. Desktop/CLI/IDE share host configuration. Config scope controls discovery, **not server filesystem or document scope**; project configuration may also affect other tasks opened in this same repository. Do not reload or alter PC Ticket 2 to activate hardware tools. [Codex configuration reference](https://learn.chatgpt.com/docs/config-file/config-reference).

This task currently has unrestricted filesystem access and no approval prompt mechanism for shell escalation. Consequently, do not assume Codex's current shell environment sandboxes a CAD server. For MCP, documented tool allowlists and explicit prompt modes provide client-side controls, but host enforcement must be verified before granting writes. Generic dispatch tools require inspection of allowed operations; a tool named Read is not automatically harmless (the bundled schema includes document operations).

### Exact proposed setup shape — documentation only

After approval, prefer the B.G.D. project file rather than a global registration. Initial contents would be staged disabled until the tool catalog and client behavior can be checked:

```toml
[mcp_servers.bgd_fusion]
url = "http://127.0.0.1:27182/mcp"
enabled = false
startup_timeout_sec = 20
tool_timeout_sec = 120
default_tools_approval_mode = "prompt"
```

Then, in the hardware task only: enable the official Fusion preference, initialize the connection, enumerate tools without running modeling commands, select actual read/inspection tools for `enabled_tools`, and verify the client restrictions. Exact tool names must come from discovery; none are invented here. Change `enabled` only as part of that approved commissioning. A 120-second client timeout does not alter Fusion's server limit or establish that the large DXF import will finish.

The equivalent global CLI registration is `codex mcp add bgd_fusion --url http://127.0.0.1:27182/mcp`; it is **not recommended for project scoping and was not run**. No command is needed to register KiCad CLI as an MCP server.

If KiCad MCP is approved later, use a pinned installed executable over stdio with `KICAD_MCP_WORKSPACE_ROOT` and `KICAD_MCP_PROJECT_DIR` restricted to the electrical workspace, `KICAD_MCP_PROFILE=review`, `KICAD_MCP_OPERATING_MODE=readonly`, and an explicit KiCad CLI path. Do not enable HTTP, bridge, sourcing services, telemetry, or a general full tool profile by default. Installation is not part of the present recommendation.

## Approval scope and continuation

Recommended next approval is limited to **official local Fusion MCP commissioning**: enable its loopback endpoint, add/review B.G.D.-scoped Codex configuration, discover actual tools, check permission behavior and read a dedicated test document. No third-party installation or Fusion Data OAuth is included. If an exposed script tool is needed, review its broad privilege before enabling it; if unavailable, use the manual official API fallback without forcing a hidden feature.

After connection/permissions are established, resume the user's exact CAD-T01 learning task: pinned Source One source, 1:1 mm import, measured reference verification and traceable artifact. Preserve the already-started extraction files as provisional work; a Fusion import has not occurred. Do not proceed to detailed custom parts. The source-reference task still ends at the user's review checkpoint.

For a later write test, use a disposable B.G.D. document, create and measure a simple known dimension, verify units and export location, then test the actual DXF import separately. Capture native/export revisions and hashes, API/tool versions, transformation history and measurements in `cad/`. KiCad native sources and netlist/ERC evidence belong in `electronics/`; reconcile them with the approved harness and pin records. These checks qualify the integration, not the physical aircraft.

Remaining uncertainty is confined to live Fusion tool discovery/entitlement, script variant, actual permission enforcement, large-file import behavior and future native-file/IPC editing tests. None is a reason to install an unreviewed bridge now.
