---
description: "Use when the user wants a plan before building (\"plan this feature\", \"wie gehen wir das an\", \"technical design\"). Reads the codebase, then outputs design, test seams, phased tasks, risks and the DB choice (MongoDB vs PostgreSQL) with reasoning."
argument-hint: "[feature description or ticket]"
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Write
---

Create an implementation plan for: $ARGUMENTS

Read the codebase first to understand existing architecture and patterns before planning.
Use stack and conventions from CLAUDE.md.

## Instructions

<thinking>
Analyze internally:
- Where does this fit in the existing codebase?
- What already exists that can be reused?
- MongoDB vs PostgreSQL — which and why?
- What are the real risks and unknowns?
- Realistic effort estimate (S/M/L) — add buffer for unknowns
</thinking>

## Output

### 1. Feature Overview
- Problem it solves + who it's for
- Key functionality

### 2. Technical Design
- Component structure
- API endpoints
- DB schema + which DB and why
- Data flow: Frontend → API → DB → Response

### 3. Testing Seams
Propose the seams to test at (existing ones preferred, highest level possible, ideally one) with one line each on what it catches and what it misses. Don't list file paths or code snippets in the spec — they go stale; describe modules and interfaces instead.

### 4. Implementation Plan

**Phase 1: Foundation**
- [ ] Task

**Phase 2: Core Feature**
- [ ] Task

**Phase 3: Polish**
- [ ] Task

### 5. File Changes
**New:** list files
**Modified:** list files + reason

### 6. Dependencies
```bash
npm install package-name
```

### 7. Risks
List potential risks with impact and mitigation:
- **[Risk]** (High/Mid/Low) — mitigation strategy

### 8. Definition of Done
- [ ] Feature works as specified
- [ ] TypeScript strict — kein `any`
- [ ] Zod validation auf allen DTOs
- [ ] Error handling komplett
- [ ] Loading states
- [ ] Tests passing
- [ ] No console errors

## Save the plan

After presenting the plan, write it to `.scratch/plan-<short-slug>.md` (create the folder if needed; this is the only file you may write). End with exactly:

> Plan saved to `<path>`. Review/edit it, then run `/dev:implement <path>` — ideally in a fresh session.

Do not start implementing.

## Gotchas

- Read the code before planning; a plan that ignores existing patterns is wrong.
- Always state MongoDB vs PostgreSQL and why, even when the answer is "unchanged".
- No file paths or code snippets in the design text — they go stale. Paths belong in File Changes only.
- Don't estimate in days; use S/M/L plus the main unknown.
