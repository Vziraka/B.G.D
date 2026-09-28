# B.G.D

## Project context

These rules apply to **Claude Code**, **Codex** (via `AGENTS.md`), and **Cursor**.

Start at [docs/CURRENT.md](docs/CURRENT.md) and the [increment 1+2 BOM](docs/increment-1-2-bom.md). Then the [project map](.scratch/biometric-guard-drone/map.md) for workstream status. Tickets hold dated decisions; open a ticket when the live map is not enough.

Reach `cad/`, `electronics/`, `docs/research/`, and `Gemini_recommendation_and_how.md` only when the task is recovering a **named dated** historical decision. They are not the live design. Fusion MCP is for a later Pi-plate print, not C1 regeneration.

## Current delivery boundary

Live path: [docs/CURRENT.md](docs/CURRENT.md) and [increment 1+2 BOM](docs/increment-1-2-bom.md). Issue10 remains the product requirements. Issue11/C1 (Pixel, LD19, lamp, Fusion/KiCad package) is **abandoned** — do not continue it. Issue12’s v1 simulator is historical evidence; native phone work waits until after a hovering increment-1 quad.

The Windows PC is the development host. The standalone PC biometric product is deleted from this checkout; on-disk profiles under `%LOCALAPPDATA%\BGD\` stay untouched. Do not revive that app.

For context handoff, research, worktrees or skill maintenance, use [the shared workflow](docs/agents/workflow.md).

## Working with the owner

The owner is learning hardware and software through this project. Keep updates concise without omitting consequential information. Explain decisions in plain language, defining unfamiliar terms when needed. Own routine engineering decisions and execution within the authorized scope. Teach what the owner needs for an upcoming decision or physical step, without making routine development wait for lessons or code review. Provide deeper lessons and quizzes when requested.

## Execution

Carry the authorized outcome through investigation, implementation, verification and repair. Resolve routine design choices, build missing prerequisites within scope, and try another supported approach when one fails. Continue useful independent work while awaiting an input. Stop only at a genuine dependency or authorization boundary, identifying what would unblock it.

Explore existing products and designs, purchased components, custom work and hybrid solutions against the current requirements. Apply Issue10's current budget: maximum $1,000 for the usable system including aircraft, onboard equipment, one flight battery, controller, charger, required accessories, tax and shipping; strongly prefer less. Credit the existing phone, computer and free lab access. Show optional spares and development allowances separately; do not hide required system costs in those categories. Detailed work on over-budget configurations is paused pending the focused affordability review. Explain consequential tradeoffs and own routine selections. Available fabrication equipment expands the options rather than prescribing a process. Record sources, licenses and versions, and verify compatibility and important interfaces. Familiarity, source availability or a lower purchase price alone does not establish the best design.

Use available documentation and measurements before asking the owner to find information. Separate documented facts, calculated results, assumptions and physical evidence. Simulation or synthetic tests do not establish real biometric accuracy, mechanical fit or flight readiness.

Own architecture, components, engineering methods, implementation and development order. Revise engineering choices independently while preserving agreed product requirements and the user experience the owner deliberately required. Delegated details and accepted engineering recommendations remain revisable when they preserve those outcomes; recover decision provenance when uncertain. Difficulty or faster completion does not justify weakening requirements. Investigate alternatives and bring proposed requirement changes to the owner; until approved, unmet requirements remain required and unfinished.

Involve the owner when information only they can provide or authorization for spending, external commitments or physical action is needed. Existing authorization carries forward; historical architecture freezes and stage stops do not govern a later authorized revision. Current requirements live in Issue10's checkpoint; dated calculations remain evidence for their original configurations. Distinguish intermediate-stage completion from completion of the whole product.

Reduce uncertainty and the cost of physical validation using methods proportionate to the question. Select useful research, analysis, simulation or established-design evidence rather than exhausting a fixed checklist. When physical evidence is necessary, prepare the smallest decisive test with acceptance criteria and continue independent work. Machine access does not establish operator training; plan novice-feasible fabrication and identify tasks requiring qualified assistance.

## Skills and verification

Use skills when they help the current work and grilling when requested or needed to settle consequential ambiguity. For B.G.D, a skill's default approval cadence or one-ticket/session limit does not require stopping an already authorized outcome. Do not require a full skill pipeline or repeated approval of routine test cases. Grilling is for unresolved product choices, not decisions already delegated to engineering. Skill preferences for minimal changes do not freeze an architecture that the owner has reopened.

Choose tests for observable requirements, credible failures and security boundaries. Run focused checks while changing code and the relevant full suite before handoff. Keep costly repetition opt-in; avoid tests for incidental implementation details or more documentation without a maintenance purpose. Preserve meaningful regression and acceptance coverage.

Use subagents for useful bounded work with clear ownership. The main agent owns integration, verification and the next action; the owner should not have to relay context between agents.

## Project references

### Issue tracker

Issues live as local markdown files under `.scratch/<feature>/` in this repo. See `docs/agents/issue-tracker.md`.

### Triage labels

Default label vocabulary: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `CONTEXT.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
