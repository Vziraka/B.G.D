# B.G.D

## Project context

Start with the [project map](.scratch/biometric-guard-drone/map.md) and the relevant ticket's current checkpoint. Consult its latest comments and linked requirements/evidence for the work at hand; read older history when resolving a conflict or recovering a decision's reason. Tickets hold the authoritative detail.

## Current delivery boundary

Build the current product through [Issue11 hardware engineering](.scratch/biometric-guard-drone/issues/11-hardware-build-package.md) and [Issue12 phone/onboard interaction](.scratch/biometric-guard-drone/issues/12-phone-onboard-interaction.md). The Windows PC is the development host, but the standalone PC biometric product is retired and has no active ticket, acceptance gate or cleanup requirement. Treat `.scratch/pc-biometric-desk/`, `docs/pc-biometric/`, `pc_biometric/`, `packaging/` and PC-only tests as dormant historical material; consult them only for a specifically relevant precedent. Reactivating, extending, validating or packaging that product requires a new explicit owner direction.

For context handoff, research, worktrees or skill maintenance, use [the shared workflow](docs/agents/workflow.md).

## Working with the owner

The owner is learning hardware and software through this project. Explain results and consequential decisions in plain language, defining unfamiliar terms when needed. Own routine engineering decisions and execution within the authorized scope. Teach what the owner needs for an upcoming decision or physical step, without making routine development wait for lessons or code review. Provide deeper lessons and quizzes when requested.

## Execution

Carry the authorized outcome through investigation, implementation, verification and repair. Resolve routine design choices, build missing prerequisites within scope, and try another supported approach when one fails. Continue useful independent work while awaiting an input. Stop only at a genuine dependency or authorization boundary, identifying what would unblock it.

Use available files, manufacturer documentation, CAD and measurements before asking the owner to find information. Separate documented facts, calculated results, assumptions and physical evidence. Simulation or synthetic tests do not establish real biometric accuracy, mechanical fit or flight readiness.

Preserve approved requirements. Escalate a consequential cost/scope tradeoff, unresolved user intent or a required physical action; explain the evidence and recommend a concrete path. Existing task authorization carries forward. A restriction from an old task applies to that scope unless a later decision supersedes it.

## Skills and verification

Use skills when they help the current work and grilling when requested or needed to settle consequential ambiguity. For B.G.D, a skill's default approval cadence or one-ticket/session limit does not require stopping an already authorized outcome. Do not require a full skill pipeline or repeated approval of routine test cases.

Choose tests for observable requirements, credible failures and security boundaries. Run focused checks while changing code and the relevant full suite before handoff. Keep costly repetition opt-in; avoid tests for incidental implementation details or more documentation without a maintenance purpose. Preserve meaningful regression and acceptance coverage.

Use subagents for useful bounded work with clear ownership. The main agent owns integration, verification and the next action; the owner should not have to relay context between agents.

## Project references

### Issue tracker

Issues live as local markdown files under `.scratch/<feature>/` in this repo. See `docs/agents/issue-tracker.md`.

### Triage labels

Default label vocabulary: `needs-triage`, `needs-info`, `ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context: `CONTEXT.md` and `docs/adr/` at the repo root. See `docs/agents/domain.md`.
