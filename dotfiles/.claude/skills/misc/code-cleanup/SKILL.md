---
name: code-cleanup
description: 'Tidy the code you name without changing behavior, applying only the findings you pick (lint errors: use lint; the current diff: use simplify).'
argument-hint: '[file, function, or branch]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash, Edit, Write, AskUserQuestion
disable-model-invocation: true
---

Tidy the following code: $ARGUMENTS

No argument: ask what to tidy. Use stack and conventions from CLAUDE.md. Behavior stays identical.

## Steps

1. **Check the starting point.** Run `git status --short`. Uncommitted changes: ask whether to commit or stash first, or to continue anyway. Done when the diff will hold only the refactoring, or I chose to continue.
2. **Read** the target, its callers, its tests and the patterns the codebase already uses. Done when you can name the pattern to stay consistent with and the callers of every exported symbol in scope.
3. **Take the baseline.** Run the project's tests, type-check and lint from its own scripts (`package.json` or the repo's equivalent) and record the results. Done when you hold the baseline. A red baseline: say so; the cleanup must leave it no worse.
4. **Find the findings** in the priority order below. Number each one and label it:
   - **safe:** mechanical, behavior cannot change (dead code, unused imports, local renames, early returns, extractions that move code unchanged).
   - **judgement:** could change behavior at an edge case (`||` to `??`, `a && a.b` to `a?.b`, reordering, merging branches, changing an exported type).

   No tests cover the target: offer only the safe findings that tests are not needed for (dead code, unused imports), and list the rest under "Not covered by tests". Done when every finding has a number, label, `file:line` and a one-line change.

5. **Let me pick.** Show the findings (Output below), then ask with `AskUserQuestion`: all safe findings / all judgement findings / pick individually / nothing. "Pick individually": ask multi-select questions of up to 4 findings each. Done when I have chosen.
6. **Apply** the chosen findings, then re-run the baseline commands. Done when tests, type-check and lint are no worse than the baseline. A regression: undo the change that caused it and report it. Show `git diff --stat` and the diff of every non-trivial change.

## Priority order

1. Dead code: unused imports, variables, commented-out code. "Unused" needs proof: search the whole repo and its config, counting dynamic uses (DI providers and decorators, reflection, string-based imports) as uses. No proof, no deletion.
2. Types: in a TypeScript project, no `any`, proper interfaces, utility types.
3. Duplication: extract logic repeated in three places or more.
4. Nesting: early returns over nested ifs.
5. Functions too long to follow: split by responsibility.
6. Idiom upgrades (optional chaining, nullish coalescing, destructuring): **judgement** unless the old and new forms are provably identical.

Exported names, signatures and behavior stay as they are, unless I approve a change together with updates to every caller.

## Output

Numbered findings: `#n [safe|judgement] file:line: change, why`. Then:

- **Not covered by tests:** findings held back, with the reason.
- **Further improvements:** out-of-scope ideas.

After applying: the diff, and a table of tests, type-check and lint, baseline against after.

## Gotchas

- Stay inside the requested scope or branch diff; other smells go to Further improvements.
- The codebase's existing pattern wins over a new one.
- Nothing is staged or committed.
