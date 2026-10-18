---
name: feature-plan
description: 'Use when the user wants a plan before building ("plan this feature", "how do we approach this", "technical design"). Reads the codebase, then outputs design, test seams, phased tasks, risks and the DB choice (MongoDB vs PostgreSQL) with reasoning.'
argument-hint: '[feature description or ticket]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Write
---

Create an implementation plan for: $ARGUMENTS

No argument: ask what to plan. Use stack and conventions from CLAUDE.md.

## Steps

1. **Read the code.** Find where the feature fits, which existing modules and patterns it reuses, and what it touches. Done when you can name the modules to reuse and the ones to change.
2. **Choose the DB.** MongoDB or PostgreSQL, with the reason, even when the answer is "unchanged". Done when the choice and its reason are one sentence each.
3. **Draft the plan** using the Output sections below. Estimate effort as S/M/L plus the main unknown.
4. **Save it.** Write the plan to `.scratch/plan-<short-slug>.md` (create the folder if needed; this is the only file you may write). Done when the file exists and the reply ends with exactly:

   > Plan saved to `<path>`. Review or edit it, then run `/implement <path>`, ideally in a fresh session.

Implementation starts in `/implement`, not here.

## Output

### 1. Feature Overview

- Problem it solves and who it is for
- Key functionality

### 2. Technical Design

- Component structure
- API endpoints
- DB schema, and which DB and why
- Data flow: Frontend → API → DB → Response

### 3. Testing Seams

Propose the seams to test at (existing ones preferred, highest level possible, ideally one) with one line each on what it catches and what it misses. Describe modules and interfaces instead of file paths or code snippets.

### 4. Implementation Plan

**Phase 1: Foundation**

- [ ] Task

**Phase 2: Core Feature**

- [ ] Task

**Phase 3: Polish**

- [ ] Task

### 5. File Changes

**New:** list files
**Modified:** list files and reason

### 6. Dependencies

```bash
npm install package-name
```

### 7. Risks

- **[Risk]** (High/Mid/Low): mitigation

### 8. Definition of Done

- [ ] Feature works as specified
- [ ] TypeScript strict, no `any`
- [ ] Zod validation on all DTOs
- [ ] Error handling complete
- [ ] Loading states
- [ ] Tests passing
- [ ] No console errors

## Gotchas

- A plan that ignores existing patterns is wrong; read before planning.
- File paths and code snippets go stale. Paths belong in File Changes only.
- Estimate in S/M/L, never in days.
