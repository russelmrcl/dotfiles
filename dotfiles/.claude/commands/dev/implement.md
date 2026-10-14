---
description: 'Use when a plan from /dev:feature-plan exists and the user wants it built ("implement the plan", "setz den Plan um"). Executes the saved plan phase by phase, test-first, stopping after each phase.'
argument-hint: '[path to plan, default: newest .scratch/plan-*.md]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash, Edit, Write
disable-model-invocation: true
---

Implement the plan: $ARGUMENTS

No argument → use the newest `.scratch/plan-*.md`. No plan found → say so and stop; don't invent one.

## Before starting

1. Read the plan fully, plus CLAUDE.md and 1–2 existing files of the same kind.
2. `git status` — uncommitted changes unrelated to the plan → ask before continuing.
3. List the phases and the seams from the plan, and confirm in one message. Open questions in the plan → ask them now.

## Per phase

1. Tests first at the plan's seams (see `/dev:tdd` rules: red before green, one slice at a time).
2. Implement just enough to go green. Follow existing patterns; no new abstractions the plan doesn't call for.
3. Verify, using the project's own scripts from `package.json`: `npx tsc --noEmit`, the phase's tests, lint on touched files. Fix failures before reporting; a phase is done only when all three are green.
4. **Stop and report** with the actual command output summary (pass/fail counts, tsc errors), deviations from the plan, what's next. Wait for "weiter" before the next phase.

## Rules

- Deviating from the plan (new dependency, changed API shape, schema change) → stop and ask first.
- Tick off finished tasks in the plan file so a new session can resume.
- TypeScript strict, no `any`, validate all DTOs.
- Never stage, commit, or push. Leave changes in the working tree.

## Final report

Phases done, files changed, tests added, deviations, anything left open. Suggest `/git:code-reviewer` and `/git:commit` as next steps.

## Gotchas

- A plan is a hypothesis; if the code contradicts it, say so instead of forcing it.
- Don't run all phases in one go — the stop after each phase is the point.
- Don't "fix" unrelated issues you notice; list them at the end.
