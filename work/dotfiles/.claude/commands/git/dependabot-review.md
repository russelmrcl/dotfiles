---
description: Use this skill whenever a Dependabot PR needs to be reviewed before merging. Triggers on phrases like "dependabot PR", "dependency update", "should I merge this?", "bump X from Y to Z", or when the user pastes a Dependabot PR title/description. Analyzes what changed, what could break, runs relevant tests, and gives a clear merge/hold verdict.
model: claude-sonnet-4-6
allowed-tools: Bash
---

# Dependabot PR Review

Analyzes a dependency update from Dependabot and determines if it's safe to merge.

## Workflow

### Step 1 — Parse the update

Extract from the PR title/description or $ARGUMENTS:

- Package name
- Version bump: `X.Y.Z → A.B.C`
- Bump type: patch / minor / major

### Step 2 — Detect stack

```bash
cat package.json
```

- What's the actual role of this package? (build tool, runtime dep, type-only, dev-only)
- Is it a direct dep or transitive?
- `devDependencies` → lower risk, but still check build + lint
- `dependencies` → runtime, higher risk

### Step 3 — Assess risk

**Patch** (1.2.3 → 1.2.4) — bug fixes only, low risk
**Minor** (1.2.3 → 1.3.0) — new features, backwards compatible in theory, medium risk
**Major** (1.2.3 → 2.0.0) — breaking changes likely, high risk

Check the changelog / release notes:

```bash
gh pr view <PR_NUMBER> --json body
```

Look for:

- Breaking changes explicitly called out
- Deprecations that affect used APIs
- Security fixes (if yes → merge priority goes up)
- Known issues in the new version
  Cross-reference with how the package is used in the codebase:

```bash
grep -r "package-name" src/ --include="*.ts" --include="*.tsx" -l
```

Read the files that import it — what APIs are actually used?

### Step 4 — Run type-check

```bash
npx tsc --noEmit
```

New type errors after the bump → flag immediately, don't merge.

### Step 5 — Run tests

Detect test runner:

| If present | Run                          |
| ---------- | ---------------------------- |
| `vitest`   | `npx vitest run`             |
| `jest`     | `npx jest --passWithNoTests` |
| none       | skip, note it                |

Focus on test files that use or are adjacent to the updated package.

If tests fail → check if caused by the bump:

- Yes → hold, report what broke
- Pre-existing → note separately, don't block merge because of it

### Step 6 — Run lint

Run `/lint` on the project.

New lint errors after bump → flag, but usually not a merge blocker unless in critical paths.

### Step 7 — Stack-specific checks

**React / Fluent UI (`@fluentui/react-components`):**

- UI component library bump → check if any component API changed
- Note visual regression risk (can't auto-test)
  **Koa:**
- Middleware package bump → check if middleware signature changed
- Check all `app.use()` call sites
  **Build tools (vite, webpack, esbuild):**

```bash
npm run build
```

**TypeScript itself:**

- Full type-check, watch for new strict errors
  **ESLint / Prettier:**
- Run lint — new rules may fire on existing code

### Step 8 — Verdict

| Verdict                 | When                                                     |
| ----------------------- | -------------------------------------------------------- |
| **Merge**               | All checks pass, no breaking changes in used APIs        |
| **Merge with note**     | Passing, but deprecations to address later               |
| **Hold — fix first**    | Type errors, failing tests, or breaking API changes      |
| **Hold — manual check** | Major bump, UI library, or core runtime dep (react, koa) |

---

## Report

**Package:** `name` `old → new` (patch / minor / major)
**Risk level:** Low / Medium / High
**Used in:** X files — list key ones
**APIs used from this package:** list what's actually called

**Checks:**
| Check | Result | Note |
|-------|--------|------|
| Type-check | Pass / Fail | |
| Tests | Pass / Fail / Skipped | |
| Lint | Pass / Warnings | |
| Build | Pass / Fail / Skipped | |

**Changelog highlights:** only what's relevant to how the package is used

**Verdict:** Merge / Merge with note / Hold — fix first / Hold — manual check

**Reason:** one sentence
