---
name: code-reviewer
description: 'Use when the user asks to review code, a diff, a branch, or a PR ("review", "take a look", "is this safe to merge"). Reviews standards, spec and security separately, with parallel subagents for larger changes, and gives a merge verdict.'
argument-hint: '[base ref, branch, or path; default: uncommitted changes]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash, Agent
---

Review the following: $ARGUMENTS

## Steps

### 1. Pin the diff

No argument: uncommitted and branch changes.

```bash
git status --short
git diff HEAD
```

Argument is a ref or branch: `git diff <ref>...HEAD` and `git log <ref>..HEAD --oneline`.
Argument is a path: review that path.
Empty diff: ask what to review and stop.

Count changed files and lines with `git diff --stat`. Done when you know the diff, its size and its commit list.

### 2. Find the spec

Look for a ticket key in the branch name or commit messages, a path passed as argument, or a file under `docs/`, `specs/`, `.scratch/`. Not found: ask once. Still none: write "no spec available" and skip the Spec axis.

### 3. Choose the mode

| Condition                                                                                            | Mode                                 |
| ---------------------------------------------------------------------------------------------------- | ------------------------------------ |
| ≤ 5 files **and** ≤ 200 changed lines **and** nothing security-sensitive                             | **Single**: review all axes yourself |
| Larger, **or** touches auth, permissions, input handling, crypto, secrets, SQL/queries, file uploads | **Parallel**: one subagent per axis  |

State the mode and the reason in one line.

### 4a. Single mode

Read the changed files plus imports and tests. Use CLAUDE.md for conventions. Go through the Standards, Spec and Security checklists yourself.

### 4b. Parallel mode

Spawn the subagents **in one message** with the `Agent` tool so they run in parallel. Each gets the diff command, the commit list and its brief below, and none sees another's findings. Each reports under 400 words, every finding with `file:line` and the failure scenario.

- **Standards agent:** CLAUDE.md rules plus patterns in 2-3 comparable existing files. Check against the Standards checklist; skip what ESLint, Prettier and tsc enforce.
- **Spec agent:** the spec text in full. Report (a) requirements missing or partial, (b) behavior added that was not asked for, (c) requirements implemented wrongly, quoting the spec line for each. Skipped without a spec.
- **Security agent:** the Security checklist only. Trace untrusted input from entry point to sink; report no theoretical issue without a path.

Keep the three reports separate, unmerged and unranked against each other.

## Checklists

**Standards**

- Correctness: logic errors, edge cases, missing `await`, race conditions
- TypeScript: strict violations, `any`, unsafe assertions, missing validation on external data
- Architecture: breaks existing patterns, circular deps, premature abstraction
- NestJS: DI scope and circular deps, guard/pipe/interceptor/filter order, DTO validation on every endpoint, correct HTTP exceptions and status codes
- Performance: N+1, missing pagination, blocking the event loop
- Error handling: unhandled rejections, swallowed errors
- Tests: critical logic untested, tests coupled to implementation

**Security**

- Injection (SQL/NoSQL/shell/HTML), unvalidated input reaching a sink
- Missing or wrong authn/authz checks, IDOR, over-broad guards
- Secrets in code, logs or errors; sensitive data in responses
- CORS, rate limits, file upload handling, SSRF
- New dependencies with known issues

## Output

### 🔴 Critical (fix before merge)

### 🟡 Warning (should fix)

### 🟢 Suggestions

Each as `file:line`: issue, failure scenario, fix hint.

### Per axis

| Axis      | Result                                               | Worst finding |
| --------- | ---------------------------------------------------- | ------------- |
| Standards | Pass / Issues                                        |               |
| Spec      | Pass / Issues / no spec available                    |               |
| Security  | Pass / Issues / not run (single mode: covered above) |               |

### What's good

Briefly.

### Merge verdict

Ready / Fix criticals first / Major rework needed, with one sentence why.

## Gotchas

- Review the diff, not whole files. Pre-existing issues are Suggestions at most.
- Subagents have no conversation context: paste the diff command, spec and checklist into each prompt.
- Launch the subagents in a single message; separate messages run them one after another.
- A missing spec is not a Spec failure.
- Every finding carries a concrete failure scenario and exact `file:line`.
- The review is read-only: no comments posted, nothing staged or committed.
