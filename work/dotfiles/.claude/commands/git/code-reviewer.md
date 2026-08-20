---
description: Review code for bugs, security issues, and best practices
model: claude-sonnet-4-6
allowed-tools: Read, Glob, Grep, Bash
---

Review: $ARGUMENTS

No argument → review the current working directory.

Read all relevant files first — CLAUDE.md for conventions, then target code including imports, tests, types.

## Instructions

### Step 0 — Detect stack

```bash
cat package.json
```

Adjust review profile based on what's found:
- `koa` → check middleware order, `ctx.body`/`ctx.status` always set, `next()` called, async try/catch, `app.on('error')` exists
- `@fluentui/react-components` → Fluent primitives over raw HTML, `makeStyles` over inline styles, FluentProvider scope, a11y on icon-only buttons
- `react` → hook rules, missing keys, state mutation, useEffect cleanup
- DB layer (prisma/drizzle) → N+1, over-fetching, missing pagination
- Auth present → extra scrutiny on every check

<thinking>
Go through all dimensions — skip none:

Correctness: logic errors, falsy traps, edge cases, missing await, race conditions, mutations
Security: user input in queries/HTML/shell, secrets logged, auth checks, CORS, sensitive data in errors
TypeScript: any, missing return types, unsafe type assertions, missing Zod/JOI on external data
Architecture: violates existing patterns, single responsibility, premature abstractions, circular deps
Performance: unnecessary re-renders, N+1, missing pagination, sync blocking event loop
Error handling: unhandled rejections, missing try/catch on I/O, no API fallback
Maintainability: magic values, functions >50 lines, misleading names, duplicated logic
Tests: critical logic untested, testing implementation not behavior
Stack-specific: apply profile from Step 0
</thinking>

## GitHub PR Comments

After the review is complete, present the full report and ask:

> "Ready to post these as GitHub PR comments — go ahead?"

Wait for confirmation before running any `gh` commands.

Once confirmed, post inline comments on the exact file + line using the GitHub CLI:

```bash
# Get current PR number
gh pr view --json number

# Post inline review comment
gh api repos/{owner}/{repo}/pulls/{pr}/comments \
  --method POST \
  --field body="comment" \
  --field commit_id="$(git rev-parse HEAD)" \
  --field path="file.ts" \
  --field line=42
```

Comment rules:
- Max 1-2 sentences per comment — no essays
- State the issue + why, optionally a fix hint
- No "you should" / "you might want to" — direct and neutral
- Criticals get a comment, warnings get a comment, suggestions only if impactful
- Don't post "What's good" as comments — that stays in the chat summary only

## Output

Direct, no sugarcoating. Every issue with exact file + line.

### Critical — fix before merge

| # | Issue | File:Line | Why critical |
|---|-------|-----------|-------------|

```ts
// before / after per issue
```

### Warning — should fix

| # | Issue | File:Line | Impact |
|---|-------|-----------|--------|

### Suggestion — nice to have

| # | Issue | File:Line | Benefit |
|---|-------|-----------|---------|

### What's good

- `file.ts` — reason

### Overall

| Dimension | Status | Note |
|-----------|--------|------|
| Correctness | Clean / Issues | |
| Security | Clean / Issues | |
| TypeScript | Strict / Loose | |
| Architecture | On-pattern / Off-pattern | |
| Performance | Fine / Bottlenecks | |
| Error Handling | Complete / Gaps | |
| Test Coverage | Adequate / Missing | |

**Merge-Readiness:** Ready / Fix criticals first / Major rework needed

### Recommendation

State plainly what to fix before merging, based on what was found:

- No criticals, no warnings → "Ready to merge as-is."
- Only criticals → "Fix the criticals only — warnings can be follow-up work."
- Only warnings → "No criticals. Warnings are optional but recommend fixing [list which, if any are cheap/high-impact] before merge; the rest can be follow-up."
- Both → "Fix criticals before merge. Of the warnings, [list which ones] are worth fixing now because [reason — e.g. touches the same file, cheap fix, security-adjacent]; the rest can be follow-up tickets."

1-2 sentences max. Be specific about *which* warnings, if any, are worth bundling in now — don't just say "fix warnings too" without justification.