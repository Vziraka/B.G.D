# Shared Codex / Claude Code workflow

## Sources of truth

- [CLAUDE.md](../../CLAUDE.md) holds shared project rules for Claude Code, Codex, and Cursor; [AGENTS.md](../../AGENTS.md) routes Codex there. Keep project policy here or in `docs/agents/`, rather than installing it into every skill.
- Live index: [CURRENT.md](../CURRENT.md) and the [increment 1+2 BOM](../increment-1-2-bom.md). The [map](../../.scratch/biometric-guard-drone/map.md) is workstream status. Tickets hold dated decisions. An agent suggestion is not approval.
- [CONTEXT.md](../../CONTEXT.md) is the glossary; use [domain rules](domain.md) for terminology.
- `docs/research/`, leftover `cad/` / `electronics/`, and `Gemini_recommendation_and_how.md` are historical. Open them only to recover a named dated claim. Recheck changing facts before purchase or flight.

## Context and task continuity

Continue a task while its objective and context remain useful. An independent objective, conflicting ownership or repeatedly lost context can justify a fresh task; there is no universal token cutoff or mandatory reset per ticket. Create a separate user task only when requested. Subagents return bounded findings, evidence, changed files and uncertainty; the main agent integrates and verifies.

Before compaction or handoff when possible, refresh the existing ticket's short checkpoint: outcome/status, decisions with reasons or source links, evidence and limits, remaining dependency and next action. Update when these change, not after every command. Preserve unique decisions in dated comments; avoid another rolling status document.

After compaction or a fresh start, read the checkpoint and relevant current files. Recheck source evidence before consequential decisions. Summaries do not prove an assumption, test or permission exists. Recover missing context or state the gap while continuing independent work.

## Shared skills on Windows

### Build coaching

The project [build-coach skill](../../.agents/skills/build-coach/SKILL.md) reads the live index and existing ticket checkpoint, chooses the next available build/test step, reviews the result and records progress there. It uses the owner's separately installed `step-by-step-coach` for concise novice guidance. It stores no second parts list or plan. On the owner's Codex host, `~/.codex/skills/build-coach` points to this repository skill so it can also be invoked from a projectless task; the teaching skill stays reusable outside B.G.D. The current checkpoint pointer is maintained in CURRENT.md.

### Shared project skill files

On this checkout, `.claude/skills/` folders are junctions to `.agents/skills/`: both paths address the same files. Maintain `.agents/skills/` and preserve local modifications. Git records both paths as ordinary files, so other checkouts may contain independent copies.

Before changing skills elsewhere, inspect links and compare contents. On Windows:

```powershell
Get-ChildItem -Force .claude/skills | Select-Object Name, LinkType, Target
```

Reconcile unique edits; obtain authorization before replacing directories or reinstalling skills. After an approved change, verify both tools see equivalent content.

## Research and worktrees

Research worktrees are allowed working copies, not the primary handoff location. The `.claude` name does not make their content Claude-only.

- Identify the checkout with `git worktree list --porcelain`; inspect status and preserve existing work. Verify current shared instructions, relevant decisions and evidence against the main checkout. A branch name does not establish freshness, especially for uncommitted or ignored context.
- Coordinate claims and decision updates in the main tracker with its current owner. Avoid conflicting ticket histories across worktrees.
- Preserve findings in the main `docs/research/` with date and source branch/commit. Identify uncommitted sources and record their hashes; the base commit does not contain them. Compare the copy to its source and distinguish historical findings from revalidated claims.
- Link retained evidence from the ticket and research index. Update the map only when its navigation, workstream status or next action changes. Follow the [tracker resolution rule](issue-tracker.md).
- Report unsaved-to-Git work. Ignore rules neither save nor delete it. Commits, pushes, merges and worktree removal require user authorization. Keep worktrees and original sources until unique content is accounted for and cleanup is explicitly approved; copying a report does not authorize deleting its source.
