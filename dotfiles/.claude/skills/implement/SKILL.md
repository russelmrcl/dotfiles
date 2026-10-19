---
name: implement
description: 'Execute a saved feature plan phase by phase, test-first.'
argument-hint: '[path to plan, default: newest .scratch/plan-*.md]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash, Edit, Write, Skill, AskUserQuestion
disable-model-invocation: true
---

Implement the plan: $ARGUMENTS

No argument: use the newest `.scratch/plan-*.md`. No plan found: say so, point to `/feature-plan`, and stop.

## Steps

1. **Prepare.**
   1. Read the plan fully, plus CLAUDE.md and 1-2 existing files of the same kind.
   2. Run `git status`. Uncommitted changes unrelated to the plan: ask before continuing.
   3. Find where to start: the first phase with unticked tasks. Ticked phases are done; start there on a resumed plan.
   4. In one message show the remaining phases, the seams, and the plan's "Open questions and assumptions". Ask the open questions and let me confirm or correct each assumption.

   Done when I have confirmed the phase list and the assumptions.

2. **Run one phase at a time:**
   1. Call the Skill tool with "tdd" and pass the phase as the argument. Tell it the seams are already confirmed, so it skips its seam step.
   2. Implement just enough to go green. Follow existing patterns; add no abstraction the plan does not call for.
   3. Verify with the project's own scripts (check `package.json` or the repo's equivalent): the phase's tests, the type-check, and lint on touched files. Done when all three are green.
   4. Tick off the phase's tasks in the plan file.
   5. **Report** in the Output format, then ask with the AskUserQuestion tool: "Next phase" (recommended), "Continue all", "Stop here". "Continue all" runs the remaining phases without asking again, but every phase still has to pass its gate, and a red gate stops the run. Failed gate: ask instead "Fix and retry" / "Stop here". Done when I have picked an option.

3. **Final report.** Check every item of the plan's Definition of Done and mark it met, with the evidence, or not met. Done when no item is unchecked. Suggest `/code-reviewer` and `/commit` as next steps.

## Output

Per phase:

- **Phase:** name
- **Tests:** pass/fail counts
- **Type-check and lint:** result
- **Deviations:** what differs from the plan, or "none"
- **Next:** the next phase

Final report: phases done, files changed, tests added, Definition of Done checklist, deviations, open items.

## Rules

- A deviation from the plan (new dependency, changed API shape, schema change): stop and ask first. Once decided, record it under a "Deviations" heading in the plan file so a new session sees it.
- Stack and coding rules come from CLAUDE.md.
- Leave changes in the working tree; staging, committing and pushing are mine.

## Gotchas

- A plan is a hypothesis. When the code contradicts it, say so.
- A red gate stops the run, also after "Continue all".
- Note unrelated issues you spot and list them in the final report.
