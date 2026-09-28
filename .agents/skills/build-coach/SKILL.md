---
name: build-coach
description: Resume and guide the B.G.D drone build or camera desk test from the existing project checkpoint, explain the next step, review its result, and record progress. Use when the owner asks to continue the build, prepare or assemble received parts, or work through a project test.
---

# B.G.D build coach

## Read the current state

Use the B.G.D checkout supplied by the user or current project. On this host it is `C:/Users/zvent/Downloads/B.G.D`. Read its `AGENTS.md` / `CLAUDE.md`, `docs/CURRENT.md`, `docs/increment-1-2-bom.md`, and `.scratch/biometric-guard-drone/map.md`. Follow the current checkpoint pointer before selecting work. Read older ticket history only to resolve a specific gap.

For teaching, use the installed `step-by-step-coach` skill. On this host its entrypoint is `C:/Users/zvent/.codex/skills/step-by-step-coach/SKILL.md`. Read it when first applying it. If unavailable on another host, retain the owner's core preference: one short step, unfamiliar words explained, a visible success result, then wait for their observed result. Do not block useful work merely because that optional teaching skill is missing.

## Choose and explain the next step

- Resume from evidence, not the last proposed plan. Distinguish ordered, received, assembled, powered, and passed. A shopping listing or compatibility check is not a physical test.
- Choose the smallest useful step whose prerequisites are available. Preparation can continue while deliveries are pending. Do not reopen settled product choices or repeat questions already answered in the live checkpoint.
- Use the existing parts list and product requirements; keep no separate shopping list, budget, or mission plan in this skill. A received substitute must be identified and checked before its instructions are used.
- For a user-performed step, state the action, brief reason, expected visible result, and what result to report. Wait before the next dependent physical action. Provide exact connector orientation and power state from the relevant device instructions when assembling hardware.
- For delegated software or documentation work, complete authorized work and appropriate verification without turning it into a mandatory lesson.
- Before a performance test, record its configuration, representative cases and measurable acceptance criteria. Avoid moving the criteria after seeing the result. Keep camera tracking separate from aircraft following, face matching separate from liveness, and a desk-test pass separate from flight qualification.
- If a step fails, diagnose one meaningful cause at a time. Record the failure and continue independent preparation where useful. Do not silently replace parts, expand spending or relax product requirements to obtain a pass.

## Record the result

Maintain the existing active ticket checkpoint identified by `docs/CURRENT.md`; do not create another rolling progress document. Record the date, completed action/configuration, observed or user-reported evidence, result and limits, remaining dependency, and next action. Keep large logs in an appropriate existing test/evidence location and link them.

Update `docs/CURRENT.md` and the project map when the phase or next action changes, and the existing shopping list when purchases or received parts change. Append significant decisions to the ticket's dated comments. Preserve historical evidence and unrelated edits. Report what changed and what the owner does next in a short handoff.
