---
description: 'Use when the user wants lint/format fixed ("lint", "eslint", "prettier", "fix lint errors"). Runs ESLint with fixes, resolves the rest by hand, then Prettier and tsc.'
disable-model-invocation: true
argument-hint: '[path, default: .]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash, Edit, Write
---

Run a full lint and format pass on: $ARGUMENTS

If no argument given, use `.` (entire project) as the target in all commands below.

## Instructions

### Step 0: Detect setup

```bash
cat package.json
```

- `next` → `npx next lint` instead of plain ESLint
- `expo` → `npx expo lint`
- Otherwise → `npx eslint <target>`
- Prettier via `eslint-plugin-prettier`? → Step 4 may be redundant
- Monorepo (nx/turborepo)? → lint per package

### Step 1: Run ESLint

```bash
npx eslint <target> --format=json
```

Analyze the output:

- If errors found → go to Step 2
- If clean → skip to Step 4

### Step 2: Fix Automatically

```bash
npx eslint <target> --fix
```

### Step 3: Fix Remaining Manually

For violations that `--fix` couldn't resolve:

- Read the affected file
- Understand the context
- Fix properly — don't just suppress with `// eslint-disable`
- Only disable a rule if there is a legitimate reason, and add a comment explaining why

Re-run ESLint after manual fixes to confirm clean:

```bash
npx eslint <target>
```

Do not proceed to Step 4 until ESLint is fully clean.

### Step 4: Run Prettier

```bash
npx prettier <target> --write
```

### Step 5: Type-check (if TypeScript)

```bash
npx tsc --noEmit
```

Report any new type errors introduced by the fixes.

## Output

### ESLint Results

- How many violations found
- Which rules triggered most
- What was auto-fixed vs manually fixed

### Prettier

- Confirmation it ran
- Files formatted

### Summary

- Overall status: clean or issues remaining
- Any rules that were disabled + reason why

## Gotchas

- No argument means `.`, not an empty path.
- `eslint-disable` needs a reason on the same line; never disable a whole file unless generated.
- Prettier runs last; if ESLint has prettier plugin, check for a config conflict first.
- Report new `tsc` errors caused by auto-fixes.
