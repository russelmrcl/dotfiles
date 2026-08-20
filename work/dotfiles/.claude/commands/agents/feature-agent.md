---
description: Full feature pipeline — from ticket to PR-ready code
model: claude-sonnet-4-6
allowed-tools: Read, Glob, Grep, Write, Edit, Bash, WebFetch
---

Ship feature: $ARGUMENTS

$ARGUMENTS = ticket URL / ticket ID / free-text description

This agent runs the full pipeline autonomously. It stops and asks only when a decision can't be made without human input.

---

## Pipeline

### Step 1 — Parse input

If ticket URL or ID → fetch and extract:
- Title, description, acceptance criteria
- Priority, labels, linked tickets
- Attached designs or specs (note URLs)

If free-text → use as-is, note that no ticket was found.

### Step 2 — Understand the codebase

```bash
cat package.json
cat CLAUDE.md
```

Read relevant modules based on feature domain. Find existing patterns to reuse — don't invent new abstractions.

### Step 3 — Plan

Run `/feature-plan $ARGUMENTS` internally.

Before continuing, surface:
- Open questions that block implementation
- Ambiguities in the AC
- Anything that requires a decision from the user

**Stop here if blockers exist.** Get answers, then continue.

### Step 4 — Implement

Execute the implementation plan from Step 3, phase by phase.

Rules:
- Follow patterns found in Step 2 — no new abstractions unless justified
- TypeScript strict — no `any`
- Zod/JOI on all external data
- `use client` only where interactions require it
- Fluent UI primitives over raw HTML (if `@fluentui/react-components` detected)
- Koa: always set `ctx.body` + `ctx.status`, always call `next()`, always try/catch async middleware

After each phase: verify it compiles and existing tests still pass.

```bash
npx tsc --noEmit
```

### Step 5 — Lint + format

Run `/lint` on all changed files.

If lint errors → fix before continuing. Never skip.

### Step 6 — Review own work

Run `/code-review` on all changed files.

Fix all criticals and warnings before continuing. Suggestions are optional.

### Step 7 — PR description

Generate PR description:

**Title:** `TICKET: type(scope): short description`

**Body:**
```
## What
[one paragraph — what was built and why]

## Changes
- file/component — what changed and why

## How to test
1. Step-by-step repro

## Checklist
- [ ] AC met
- [ ] TypeScript strict
- [ ] Lint clean
- [ ] Tests passing
- [ ] No console errors
```

---

## Stop conditions

Agent stops and asks the user when:
- AC is ambiguous and the wrong interpretation wastes significant time
- Implementation requires changing a shared contract (API shape, DB schema, shared types)
- A dependency needs to be added that has significant bundle/security impact
- Tests are failing and root cause isn't clear from the code

Everything else → decide and move on.