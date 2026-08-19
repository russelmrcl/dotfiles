---
description: Plan feature implementation with technical specifications
model: claude-sonnet-4-6
allowed-tools: Read, Glob, Grep
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
- Realistic time estimate — then double it
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

### 3. Implementation Plan

**Phase 1: Foundation** (Day 1)
- [ ] Task

**Phase 2: Core Feature** (Day 2-3)
- [ ] Task

**Phase 3: Polish** (Day 4)
- [ ] Task

### 4. File Changes
**New:** list files
**Modified:** list files + reason

### 5. Dependencies
```bash
npm install package-name
```

### 6. Risks
List potential risks with impact and mitigation:
- **[Risk]** (High/Mid/Low) — mitigation strategy

### 7. Definition of Done
- [ ] Feature works as specified
- [ ] TypeScript strict — kein `any`
- [ ] Zod validation auf allen DTOs
- [ ] Error handling komplett
- [ ] Loading states
- [ ] Tests passing
- [ ] No console errors
