# Issue tracker: Local Markdown

Issues and specs (you may know a spec as a PRD) for this repo live as markdown files in `.scratch/`.

## Conventions

- One feature per directory: `.scratch/<feature-slug>/`
- The spec is `.scratch/<feature-slug>/spec.md`
- Implementation issues are one file per ticket at `.scratch/<feature-slug>/issues/<NN>-<slug>.md`, numbered from `01` — never a single combined tickets file
- Triage state is recorded as a `Status:` line near the top of each implementation issue file (see `triage-labels.md` for the role strings); decision tickets use the wayfinding states below
- Keep a short editable `## Current checkpoint` near the top of active or long tickets: outcome/status, controlling decisions and evidence links, genuine remaining dependencies and next action. Append unique decisions and corrections under `## Comments`; do not transcribe whole conversations or command logs.

## When a skill says "publish to the issue tracker"

Create a new file under `.scratch/<feature-slug>/` (creating the directory if needed).

## When a skill says "fetch the relevant ticket"

Read its current checkpoint and relevant latest comments, then the linked requirements/evidence needed for the task. Consult older history to resolve ambiguity or recover rationale, rather than loading it all by default.

## Wayfinding operations

Used by `/wayfinder`. The **map** is a file with one **child** file per ticket.

- **Map**: `.scratch/<effort>/map.md` — the Notes / Decisions-so-far / Fog body.
- **Child ticket**: `.scratch/<effort>/issues/NN-<slug>.md`, numbered from `01`, with the question in the body. A `Type:` line records the ticket type (`research`/`prototype`/`grilling`/`task`); a `Status:` line records `open`/`claimed`/`resolved`.
- **Blocking**: a `Blocked by: NN, NN` line records dependencies. Name which work requires each unresolved result. Independent authorized preparation can continue; do not mark a dependency resolved to bypass its acceptance requirements.
- **Frontier**: choose unclaimed work that advances the authorized outcome and has its required inputs. Number order is a fallback, not a reason to ignore useful independent work. Coordinate with existing owners.
- **Claim**: set `Status: claimed` and save before any work.
- **Resolve**: when the ticket's acceptance criteria are met, record the answer and evidence under `## Answer`, set `Status: resolved`, and update its checkpoint and map pointer. Keep developmental completion distinct from outstanding physical or human acceptance.

## History and handoff

- Append confirmed decisions and later corrections under `## Comments`. Retain earlier answers as history, with a dated pointer when a newer decision supersedes them.
- Refresh the checkpoint when status, a decision or the next action changes. Update affected map pointers without duplicating the decision log. Historical stop instructions remain history when a cited later authorization supersedes them.
- The B.G.D map and issue Markdown are eligible for Git tracking; other scratch files remain ignored. Visibility is not a commit or backup. Review these records before staging or publishing them.
- For a future effort or spec, explicitly approve the corresponding ignore-rule exception before relying on Git to preserve it. A file under `.scratch/` is not automatically durable.
- Research preservation and cross-worktree handoff follow [the shared workflow](workflow.md).
