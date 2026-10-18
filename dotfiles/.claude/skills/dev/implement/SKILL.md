---
name: implement
description: 'Execute a saved feature plan phase by phase, test-first.'
argument-hint: '[path to plan, default: newest .scratch/plan-*.md]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash, Edit, Write
disable-model-invocation: true
---

Implement the plan: $ARGUMENTS

No argument: use the newest `.scratch/plan-*.md`. No plan found: say so and stop.

## Steps

1. **Prepare.** Read the plan fully, plus CLAUDE.md and 1-2 existing files of the same kind. Run `git status`; uncommitted changes unrelated to the plan: ask before continuing. List the phases and seams in one message and ask any open questions from the plan. Done when I have confirmed the phase list.
2. **Run one phase at a time:**
   1. Call the Skill tool with "tdd" and build the phase's behavior test-first at the plan's seams.
   2. Implement just enough to go green. Follow existing patterns; add no abstraction the plan does not call for.
   3. Verify with the project's own scripts from `package.json`: `npx tsc --noEmit`, the phase's tests, lint on touched files. Done when all three are green.
   4. **Stop and report:** pass/fail counts, tsc errors, deviations from the plan, what is next. Wait for "continue" before the next phase.
3. **Final report.** Phases done, files changed, tests added, deviations, open items. Suggest `/code-reviewer` and `/commit` as next steps.

## Rules

- A deviation from the plan (new dependency, changed API shape, schema change): stop and ask first.
- Tick off finished tasks in the plan file so a new session can resume.
- TypeScript strict, no `any`, validate all DTOs.
- Leave changes in the working tree; staging, committing and pushing are mine.

## Gotchas

- A plan is a hypothesis. When the code contradicts it, say so.
- The stop after each phase is the point; one phase per turn.
- Note unrelated issues you spot and list them in the final report.
