---
description: Analyze errors, stacktraces, and bugs to find root cause and fix
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash
---

Debug: $ARGUMENTS

No argument → ask:
1. Full error message + stacktrace (not paraphrased)
2. Expected vs actual behavior
3. When it started — specific change, deploy, or random?
4. Reproducible always or flaky?

Read all relevant files before touching anything.

## Instructions

### Step 0 — Detect stack

```bash
cat package.json
```

Adjust error profile:
- `koa` → middleware not calling `next()`, `ctx.body` never set → implicit 404, error handler not first, async throws not caught, `app.on('error')` missing
- `@fluentui/react-components` → FluentProvider wrong scope, `makeStyles` called outside component, theme token undefined
- `react` → hook rule violations, stale closures, missing keys, infinite useEffect loop
- `react-native` → metro bundler errors, native module issues, platform-specific
- DB layer → constraint violations, connection pool exhausted, query timeout

<thinking>
Dissect the error literally:

Type: TypeError / ReferenceError / SyntaxError / Network / Custom
Origin: file + line + function from stacktrace — minified? need source map
Call stack: what triggered what?

Root cause candidates:
- Type mismatch → expected shape vs actual?
- Async: missing await, race condition, unhandled rejection?
- Null/undefined: where was it supposed to be defined?
- Stale closure: value captured from previous render?
- Config/env: missing env var, wrong environment?
- Dependency update: did something change recently?

Context clues:
- Dev but not prod (or vice versa)? → build pipeline
- Consistent or flaky? → race condition / timing
- Only specific users/data? → edge case, missing null check
- Same pattern works elsewhere? → what's different here?
Stack-specific: apply profile from Step 0
</thinking>

## Output

### Classification

| Field | Value |
|-------|-------|
| Type | TypeError / Runtime / Logic / Config / Network |
| Layer | UI / State / API / DB / Build |
| Severity | Crash / Degraded / Cosmetic |
| Reproducibility | Always / Flaky / Condition-dependent |

### Root Cause

**What:** one sentence.
**Why:** exact mechanism — not "value is undefined", but *why* it's undefined at that point.
**Evidence:** file + line + snippet.

### Fix

```ts
// before
// after
```

All affected files — no partial fixes.

### Why It Happened

One paragraph — actual cause, not symptom description.

### Verify

```bash
# command or test to confirm
```

### Blast Radius

Same pattern elsewhere that might have the same bug:
- `file:line` — why it's at risk

### Prevention

- [ ] Unit test for edge case
- [ ] Type guard / Zod schema on external data
- [ ] ESLint rule catching this pattern
- [ ] Error boundary around component