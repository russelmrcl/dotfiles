---
name: apply-review
description: Apply PR review comments from CodeRabbit, GitHub co-workers, or any code review tool. Pulls review comments directly from GitHub via gh if no comments are pasted, reads the full PR diff, and applies the ones that make sense. Use whenever the user says "apply the PR review", "apply CodeRabbit comments", "go through the PR feedback", references a PR number/URL, or pastes review comments directly.
model: claude-sonnet-4-6
allowed-tools: Bash, gh
---

# PR Review Apply

Takes PR review comments (CodeRabbit, co-worker, GitHub review) and applies the ones that are plausible — after verifying against the actual code.

## Workflow

### Step 1 — Get the comments

**Case A: User pasted comments** → parse directly from user message.

**Case B: User references a PR (number, URL, or "the current PR") but didn't paste anything** → pull via `gh`:

```bash
# Identify PR if not given explicitly
gh pr view --json number,title,url

# Review comments (CodeRabbit, human reviewers) — inline on diff
gh api repos/{owner}/{repo}/pulls/{pr_number}/comments --paginate

# Top-level review verdicts (APPROVED/CHANGES_REQUESTED + body)
gh api repos/{owner}/{repo}/pulls/{pr_number}/reviews --paginate

# General PR conversation comments (not tied to a diff line)
gh api repos/{owner}/{repo}/issues/{pr_number}/comments --paginate
```

If `owner`/`repo` aren't obvious, derive from `git remote get-url origin` or `gh repo view --json owner,name`.

Extract per comment:
- File + line (if given)
- Author (bot vs. human — matters for Step 4 tone)
- What the reviewer said
- What they suggest changing (if explicit)

Dedupe: CodeRabbit sometimes posts the same nitpick as both an inline comment and a top-level summary comment — treat as one.

### Step 2 — Get the PR diff

Always pull the actual changes, not just the commented-on lines — reviewers often miss things, and full diff context is needed to judge plausibility correctly.

```bash
gh pr diff {pr_number}
# or, if already on the branch locally:
git diff main...HEAD
```

Walk the full diff, not just files with comments on them. If something is clearly wrong but no reviewer caught it, surface it under "Needs your input" — don't silently apply unrequested fixes.

### Step 3 — Detect stack

```bash
cat package.json
cat CLAUDE.md 2>/dev/null
```

Relevant for judging plausibility:
- `koa` → middleware patterns, ctx usage
- `@fluentui/react-components` → Fluent primitives, makeStyles
- `react` → hook rules, render patterns
- DB layer → query patterns
- TypeScript → strictness level

### Step 4 — Read the actual code

For every comment that references a file → read it before making any judgment.

```bash
# read each referenced file
```

Don't apply or dismiss any comment without seeing the code it refers to. Never guess.

### Step 5 — Evaluate each comment

For each comment, decide:

| Verdict | Criteria |
|---------|----------|
| **Apply** | Correct, improves the code, aligns with codebase patterns |
| **Apply with modification** | Right idea, but suggestion doesn't fit the codebase exactly |
| **Skip** | Wrong, outdated, based on misunderstanding, style preference only, or breaks existing patterns |
| **Ask** | Can't determine without more context — surface to user |

Plausibility signals:
- Does the reviewer understand the actual intent of the code?
- Does the suggestion align with patterns already used in the codebase?
- Is it a correctness issue or just a style opinion?
- CodeRabbit specific: flag its nitpicks/suggestions differently from its "issues" — nitpicks are often skippable
- Co-worker comments: take tone into account — "should probably" vs "must fix"

### Step 6 — Apply

Apply all "Apply" and "Apply with modification" verdicts.

Rules:
- Minimal change — fix what the comment addresses, don't refactor surrounding code
- TypeScript strict — no `any` introduced while fixing
- If a fix touches a shared type or API contract → flag it before applying
- After all changes: `npx tsc --noEmit`

### Step 7 — Run tests

Detect test runner from `package.json`:

| If present | Run |
|------------|-----|
| `vitest` | `npx vitest run` |
| `jest` | `npx jest --passWithNoTests` |
| none found | skip, note it |

- Tests pass → continue
- Tests fail → check if caused by the applied changes
  - Yes → fix before continuing, don't revert the comment fix
  - Pre-existing failure → note it in the report, don't fix (out of scope)

### Step 8 — Run lint

Run `/lint` on all changed files. Fix any errors introduced by the applied changes.

### Step 9 — Report

Present a clear summary:

**Applied (X):**
| Comment | File:Line | What was changed |
|---------|-----------|-----------------|
| "..." | `file.ts:42` | description of fix |

**Applied with modification (X):**
| Comment | File:Line | Original suggestion | What was done instead | Why |
|---------|-----------|--------------------|-----------------------|-----|

**Skipped (X):**
| Comment | Reason |
|---------|--------|
| "..." | Wrong — the code actually handles this because... |
| "..." | Style preference, not a correctness issue |
| "..." | Outdated — this was already fixed in X |

**Needs your input (X):**
| Comment | Why it needs a decision |
|---------|------------------------|
| "..." | Could go two ways — option A does X, option B does Y |

**Found in diff, not flagged by any reviewer (X):**
| File:Line | Issue | Severity |
|-----------|-------|----------|
| `file.ts:42` | description | correctness / style / security |

---

## Edge cases

**Conflicting comments** — two reviewers say opposite things → surface both, don't pick one silently.

**Comment references deleted code** → note it as stale, skip.

**Auto-generated CodeRabbit nitpick on working code** → skip unless it's a real correctness issue.

**Comment is vague** ("this looks off") → read the code, make a judgment call, note what was done and why.

**Comment suggests a pattern not used in the codebase** → apply with modification to match existing patterns, explain why.

**`gh` not authenticated or no repo access** → tell the user directly (`gh auth status`), don't silently fall back to asking for pasted comments unless they confirm.

**No PR number/URL given and can't be inferred** → ask which PR, don't guess.