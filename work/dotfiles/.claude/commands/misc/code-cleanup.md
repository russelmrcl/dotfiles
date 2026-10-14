---
description: Refactor and clean up code following best practices
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Edit, Write
---

Refactor: $ARGUMENTS

If no argument → ask: file path, specific function, or general cleanup?

### Step 0 — Detect scope: branch/PR cleanup vs general cleanup

```bash
git branch --show-current
git status --porcelain
```

If a PR/branch argument is given (e.g. a branch name, PR number, or "this branch"/"this PR"), or if the current branch isn't the default branch, treat this as a **PR cleanup** — scope the review to what this branch actually changed, not the whole file:

```bash
# find the base branch this branch diverged from
git merge-base --fork-point origin/main HEAD 2>/dev/null || git merge-base main HEAD 2>/dev/null || git merge-base master HEAD

# list changed files
git diff --name-only <base>...HEAD

# full diff, with context
git diff <base>...HEAD

# commit history on this branch, to understand intent/order of changes
git log <base>..HEAD --oneline
```

If `gh` is available and it's an open PR, prefer:
```bash
gh pr diff
gh pr view --json title,body,commits
```

Only clean up lines/blocks touched by this branch's commits — don't refactor pre-existing code outside the diff unless it's directly adjacent and needed to make the change coherent (e.g. a helper only used by the new code). If something outside the diff is bad but untouched, note it in Follow-up, not in the refactor itself.

Otherwise (no branch/PR context, plain file/function/general request) → proceed as general cleanup on the given scope.

Read all relevant files first — understand context and existing patterns before touching anything. Check CLAUDE.md for conventions.

<thinking>
Analyze before changing anything:

**Code smells:**
- Dead code (unused imports, variables, unreachable branches, commented-out blocks)
- Duplication — same logic in >1 place?
- Functions doing too much (>50 lines, >1 responsibility)
- Naming — is it obvious what this does without reading the body?

**TypeScript:**
- `any` usage — what's the actual type?
- Missing return types on exported functions
- Interfaces vs types — what does the codebase use consistently?
- Utility types that should replace manual type definitions (Partial, Pick, Omit, Record)

**Patterns:**
- What patterns exist in the codebase? Don't introduce a new one.
- Optional chaining / nullish coalescing missing?
- Early returns over nested ifs?
- Async/await consistent, no .then() mixing?

**Comments:**
- Remove comments that just describe what the code does (the code should speak for itself)
- Remove commented-out code blocks
- Remove obvious/redundant comments (`// increment i` above `i++`)
- Keep comments that explain *why* something is done in a non-obvious way
- Shorten long comments — if it needs 3 sentences to explain, the code is probably the problem
- If code is genuinely complex → max 1 line, explain the why not the what

**Scope check:**
- What's the minimal change for maximum impact?
- What's risky to touch (side effects, shared state, external contracts)?
- What should NOT be changed — note it explicitly
</thinking>

## Refactor Priorities

**PR cleanup mode:** apply only within the diff scope from Step 0. Judge each commit's changes against the rest of the branch too — e.g. a variable renamed in commit 2 but not in commit 4's new code, a pattern introduced early that later commits ignore, leftover debug code from an earlier commit that a later commit made obsolete.

Apply in order — stop if a lower priority would require risky changes:

1. **Dead code** — unused imports, variables, commented-out blocks, unreachable branches
2. **Comments** — remove what/obvious comments, shorten long ones, keep only why-comments
3. **TypeScript** — no `any`, proper interfaces, missing return types, utility types
4. **DRY** — extract duplicated logic into a shared util or hook
5. **Control flow** — early returns over nested ifs, guard clauses first
6. **Single responsibility** — split functions >50 lines or with >1 clear job
7. **Modern syntax** — optional chaining, nullish coalescing, destructuring, const assertions
8. **Naming** — rename only if the current name is actively misleading

## Output

**PR cleanup mode:** open with one line naming the branch, base, and number of commits/files in scope (e.g. "Cleaning up `feature/x` — 4 commits, 6 files changed vs `main`.").

### 1. Issues Found

| # | Issue | Severity | Location |
|---|-------|----------|----------|
| 1 | Description | High / Mid / Low | `file:line` |

Severity guide: **High** = bug risk or type unsafety / **Mid** = maintainability / **Low** = style

---

### 2. Refactored Code

Full refactored version — not a diff, the actual clean code.
Inline comments only where the *why* isn't obvious from the code itself.

---

### 3. What Changed & Why

One line per change — no obvious stuff:
- `extractXYZ()` — logic was duplicated in 3 places, now single source of truth
- Replaced `any` with `ApiResponse<T>` — was masking a runtime shape mismatch
- Flipped condition to early return — removed 2 levels of nesting

---

### 4. What Was Not Changed & Why

Be explicit about intentional non-changes:
- `legacyMapper()` — has side effects, out of scope
- API response shape — external contract, can't change unilaterally

---

### 5. Follow-up (Optional)

Improvements that are valid but out of scope for this refactor:
- [ ] Improvement — *why it's worth it*
- [ ] Improvement — *what it unblocks*

Don't over-engineer. Pragmatic over perfect.

## Applying Changes (PR cleanup mode)

After presenting the output, ask:

> "Want me to apply these changes directly to the branch?"

Wait for confirmation. If confirmed, edit the files directly. Do not stage, commit, or push — leave the changes as uncommitted edits in the working tree for the user to review and commit themselves.