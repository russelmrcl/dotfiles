---
description: Plan feature implementation with technical specifications
allowed-tools: Read, Glob, Grep, WebFetch, Bash, mcp__context7__resolve-library-id, mcp__context7__get-library-docs
---

Create an implementation plan for the ticket: $ARGUMENTS

$ARGUMENTS is always a ticket prefix + number, e.g. `LF-123`. If it doesn't match that pattern, ask the user for a valid ticket ID before doing anything else.

Fetch the ticket first (resolve the ticket system's base URL from CLAUDE.md or repo config; otherwise ask) and extract:
- Title, description, acceptance criteria
- Priority, labels, linked tickets
- Any attached designs or specs (note their URLs)

**Create the branch immediately after fetching the ticket, before writing the plan:**
1. Derive a short-title slug from the ticket title (lowercase, kebab-case, ~3-5 words, no filler words).
2. Branch name format: `<prefix>-<number>-<short-title>` (e.g. `LF-123-add-user-export`). The ticket prefix keeps the exact casing it has in Jira (e.g. `KPN-455`, not `kpn-455`) — never lowercase it. Only the short-title slug is lowercase. If the repo's existing branches (`git branch -a`) show a different convention for the prefix casing, flag that mismatch instead of silently picking one.
3. Check current branch is clean (`git status`) — if there are uncommitted changes, stop and ask before switching.
4. Run `git checkout -b <branch-name>` from the repo's default branch (or current branch if already up to date — confirm with `git fetch` + comparison, don't assume).
5. Report the created branch name to the user.

Then read the codebase to understand existing patterns:
- CLAUDE.md for stack conventions
- Relevant modules based on the feature domain
- Existing similar features for patterns to reuse

**If the ticket involves a migration, a new library, or an upgrade of an existing dependency:** check whether Context7 (`mcp__context7__resolve-library-id` / `mcp__context7__get-library-docs`) or another up-to-date documentation tool is available. If so:
1. Call `resolve-library-id` with the library name to get its Context7 ID (e.g. `/vercel/next.js`) — skip this if a Context7 ID is already known/pinned.
2. Call `get-library-docs` with that ID and a topic focused on the migration (e.g. "migration", "breaking changes", "v14 to v15").
3. Base the migration steps and API contract on what these docs actually say, not on training knowledge — library APIs and migration paths change between versions and training data goes stale.
4. Note in the plan which library ID/version Context7 resolved, so it can be spot-checked if something looks off.
If no such tool is available, note in "Open Questions" that library docs should be double-checked manually before implementation.

<thinking>
Analyze internally:

**Ticket:**
- What exactly is the AC (acceptance criteria)?
- Are there edge cases or ambiguities in the ticket? Flag them.
- What's the priority/deadline impact?

**Architecture:**
- Where does this fit in the existing codebase?
- What already exists that can be reused?
- Which layer owns this? (UI / API / DB / service)
- Any cross-cutting concerns? (auth, permissions, caching, events)

**Risk:**
- What are the real unknowns?
- External dependencies (third-party APIs, other teams)?
- Data migration needed?
- Realistic time estimate — then add 50%
</thinking>

## Output

### 0. Ticket Summary
| Field | Value |
|-------|-------|
| ID | `LF-XX` |
| Title | ... |
| Branch | `LF-XX-short-title` |
| Priority | High / Mid / Low |
| AC | bullet list |
| Open questions | anything ambiguous in the ticket |

---

### 1. Feature Overview
- **Problem:** what breaks or is missing today
- **User:** who is affected and how
- **Scope:** what's in, what's explicitly out

### 2. Technical Design

**Architecture decision:**
Which pattern, why, and what was considered + rejected.

**Component structure:**
Derive this from the actual codebase, not a generic template:
1. Check CLAUDE.md for stated conventions on folder/file organization.
2. Cross-check against 2-3 existing similar features (via Glob/Grep) to see what's actually followed.
3. If CLAUDE.md and the real structure disagree, follow the real structure and flag the discrepancy in "Open Questions."
4. Only fall back to a generic layout (below) if no prior art exists in the codebase:
```
feature/
├── components/    # UI only
├── hooks/         # state + data fetching
├── api/           # route handlers
├── services/      # business logic
└── types.ts       # shared types
```

**API contract:**
```ts
// POST /api/feature
Request:  { field: string }
Response: { id: string; field: string; createdAt: Date }
Errors:   400 (validation) | 401 (auth) | 409 (conflict)
```

**Data model:**
Any schema changes or new entities.

---

### 3. Implementation Plan

Tasks are ordered by dependency — don't start a task if its blocker isn't done.

**Phase 1 — Foundation** (Est: X h)
- [ ] Task — *why this first*
- [ ] Task — *blocks: Phase 2, Task 3*

**Phase 2 — Core** (Est: X h)
- [ ] Task
- [ ] Task — *blocked by: Phase 1*

**Phase 3 — Polish + Hardening** (Est: X h)
- [ ] Error states + loading skeletons
- [ ] Edge cases from AC
- [ ] Accessibility pass (keyboard nav, ARIA)
- [ ] Run `code-cleanup` skill on all touched files (dead code, `any`, DRY, etc. — see DoD)

**Total estimate:** X h *(optimistic)* → Y h *(realistic)*

---

### 4. File Changes
| Action | File | Reason |
|--------|------|--------|
| Create | `feature/types.ts` | shared types |
| Modify | `lib/api/router.ts` | register new route |
| Modify | `db/schema.ts` | new table |

---

### 5. Dependencies
```bash
npm install package-name   # reason
```
Flag any dependency with security concerns or large bundle impact.

---

### 6. Risks
| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Risk description | High/Mid/Low | High/Mid/Low | What to do |

---

### 7. Open Questions
Things that need clarification before or during implementation:
- [ ] Question → *who to ask*

---

### 8. Definition of Done
**Functional:**
- [ ] All AC from ticket met
- [ ] Edge cases handled (list them)
- [ ] Error states for all failure paths

**Code quality:**
- [ ] Run the `code-cleanup` skill on all files touched by this feature before marking done — don't re-derive a quality checklist here, that skill already owns it
- [ ] Zod/JOI validation auf allen DTOs (feature-specific, not covered by code-cleanup)

**Tests:**
- [ ] Unit tests für business logic
- [ ] Integration test für API endpoint
- [ ] E2E für happy path (falls relevant)

**Review ready:**
- [ ] PR description linked to ticket
- [ ] Self-review done
- [ ] No debug code