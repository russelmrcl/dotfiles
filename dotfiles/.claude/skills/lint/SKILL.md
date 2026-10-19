---
name: lint
description: 'Run ESLint with fixes, resolve the rest by hand, then Prettier and tsc.'
argument-hint: '[path, default: .]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash, Edit, Write
disable-model-invocation: true
---

Run a full lint and format pass on: $ARGUMENTS

No argument: use `.` (the entire project) as `<target>` in every command below.

## Steps

### 0. Detect the setup

Read `package.json`.

- `next`: `npx next lint` instead of plain ESLint
- `expo`: `npx expo lint`
- Otherwise: `npx eslint <target>`
- Prettier via `eslint-plugin-prettier`: step 4 may be redundant
- Monorepo (nx/turborepo): lint per package

### 1. Run ESLint

```bash
npx eslint <target> --format=json
```

Errors found: step 2. Clean: skip to step 4.

### 2. Fix automatically

```bash
npx eslint <target> --fix
```

### 3. Fix the rest manually

For each violation `--fix` could not resolve, read the file, understand the context and fix the cause. Disable a rule only with a legitimate reason, as an `eslint-disable` comment with the reason on the same line. Re-run `npx eslint <target>`. Done when ESLint is fully clean.

### 4. Run Prettier

```bash
npx prettier <target> --write
```

### 5. Type-check (TypeScript)

```bash
npx tsc --noEmit
```

Report any new type errors the fixes introduced.

## Output

- **ESLint:** violations found, the rules that triggered most, auto-fixed vs manually fixed
- **Prettier:** confirmation it ran, files formatted
- **Summary:** clean or issues remaining, plus any disabled rule with its reason

## Gotchas

- Prettier runs last. With the ESLint prettier plugin, check for a config conflict first.
- Disable a whole file only when it is generated.
