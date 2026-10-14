---
description: Run ESLint, fix all violations, then run Prettier if clean
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash, Edit, Write
---

Run a full lint and format pass on: $ARGUMENTS

If no argument → run on the entire project.

## Instructions

### Step 0 — Detect stack

```bash
cat package.json
```

| If package.json contains | Use |
|--------------------------|-----|
| `next` | `npx next lint` |
| `expo` | `npx expo lint` |
| `react-native` (bare) | `npx eslint --ext .ts,.tsx` |
| `koa` (backend) | `npx eslint --ext .ts,.js` |
| `react` / Fluent UI | `npx eslint --ext .ts,.tsx,.js,.jsx` |
| unknown | `npx eslint` → ask user to confirm scope |

Also check:
- Prettier via `eslint-plugin-prettier`? → Step 4 may be redundant
- `husky`/`lint-staged`? → note duplication
- Monorepo (nx/turborepo)? → lint per package

### Step 1 — Baseline

Run the detected command with `--format=json 2>/dev/null`. Count errors vs warnings, group by rule.

If zero issues → skip to Step 4.

### Step 2 — Auto-fix

Same command + `--fix`. Re-run to see what remains.

### Step 3 — Manual fixes

For each remaining violation: read context, fix properly.
`// eslint-disable` only as last resort — inline comment required explaining why.
Never disable an entire file unless it's generated code.
Re-run until exit code 0 before continuing.

### Step 4 — Prettier

```bash
npx prettier $ARGUMENTS --write
```

Prettier wins on formatting conflicts with ESLint.

### Step 5 — Type-check (if TypeScript)

```bash
npx tsc --noEmit
```

Report new type errors introduced by fixes.

## Output

### ESLint

| Metric | Before | After |
|--------|--------|-------|
| Errors | X | 0 |
| Warnings | X | X |

**Top violations:**
| Rule | Count | Auto-fixed |
|------|-------|------------|

**Rules disabled (if any):**
| File | Rule | Reason |
|------|------|--------|

### Summary

`✓ Clean` or `⚠ X warnings remaining` + whether they're intentional