# Shared Codex / Claude Code workflow

## Sources of truth

- [CLAUDE.md](../../CLAUDE.md) holds shared project rules; [AGENTS.md](../../AGENTS.md) routes Codex there. Keep project policy here or in `docs/agents/`, rather than installing it into every skill.
- The [map](../../.scratch/biometric-guard-drone/map.md) is a short starting index. Tickets hold current checkpoints and dated decisions; linked artifacts hold evidence. Later explicit user decisions supersede earlier recommendations. An agent suggestion is not approval.
- [CONTEXT.md](../../CONTEXT.md) is the glossary; use [domain rules](domain.md) for terminology and architectural decisions. [Project Idea](../../Project%20Idea.md) and [Gemini recommendations](../../Gemini_recommendation_and_how.md) preserve original intent, alongside later decisions.
- [Research](../research/README.md) has dates and provenance. Historical proposals do not override confirmed choices. Recheck changing facts before installation, purchase or operational use.

## Context and task continuity

Continue a task while its objective and context remain useful. An independent objective, conflicting ownership or repeatedly lost context can justify a fresh task; there is no universal token cutoff or mandatory reset per ticket. Create a separate user task only when requested. Subagents return bounded findings, evidence, changed files and uncertainty; the main agent integrates and verifies.

Before compaction or handoff when possible, refresh the existing ticket's short checkpoint: outcome/status, decisions with reasons or source links, evidence and limits, remaining dependency and next action. Update when these change, not after every command. Preserve unique decisions in dated comments; avoid another rolling status document.

After compaction or a fresh start, read the checkpoint and relevant current files. Recheck source evidence before consequential decisions. Summaries do not prove an assumption, test or permission exists. Recover missing context or state the gap while continuing independent work.

## Shared skills on Windows

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
