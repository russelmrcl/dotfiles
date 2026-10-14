---
description: 'Use when the user asks to review code, a diff, a branch, or a PR ("review", "schau drüber", "is this safe to merge"). Reviews standards, spec and security separately — with parallel subagents for larger changes — and gives a merge verdict.'
argument-hint: '[base ref, branch, or path; default: uncommitted changes]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash, Agent
---

Review the following: $ARGUMENTS

## 1. Pin the diff

No argument → uncommitted and branch changes:

```bash
git status --short
git diff HEAD
```

Argument is a ref/branch → `git diff <ref>...HEAD` and `git log <ref>..HEAD --oneline`.
Argument is a path → review that path.
Empty diff → ask what to review and stop.

Count changed files and lines (`git diff --stat`).

## 2. Find the spec

Ticket key in branch name or commit messages, a path passed as argument, or a file under `docs/`, `specs/`, `.scratch/`. Not found → ask once. Still none → "no spec available", skip the Spec axis.

## 3. Choose the mode

Multi-agent only when it earns its cost:

| Condition                                                                                            | Mode                                  |
| ---------------------------------------------------------------------------------------------------- | ------------------------------------- |
| ≤ 5 files **and** ≤ 200 changed lines **and** nothing security-sensitive                             | **Single** — review all axes yourself |
| Larger, **or** touches auth, permissions, input handling, crypto, secrets, SQL/queries, file uploads | **Parallel** — one subagent per axis  |

Say which mode you chose and why, in one line.

## 4a. Single mode

Read changed files plus imports and tests. Use CLAUDE.md for conventions. Go through the Standards, Spec and Security checklists below yourself.

## 4b. Parallel mode

Spawn the subagents **in one message** with the `Agent` tool so they run in parallel. Each gets: the diff command, the commit list, and its brief below. They must not see each other's findings. Each reports under 400 words, every finding with `file:line` and the failure scenario.

- **Standards agent** — brief: CLAUDE.md rules + patterns in 2–3 comparable existing files. Check against the Standards checklist. Skip what ESLint/Prettier/tsc enforce.
- **Spec agent** — brief: the spec text (pass it in full). Report (a) requirements missing or partial, (b) behavior added that wasn't asked for, (c) requirements implemented wrongly. Quote the spec line for each. Skipped if no spec.
- **Security agent** — brief: the Security checklist only. Trace untrusted input from the entry point to its sink; don't report theoretical issues without a path.

Do **not** merge or re-rank the reports; the axes are separate on purpose.

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
- Secrets in code/logs/errors, sensitive data in responses
- CORS, rate limits, file upload handling, SSRF
- New dependencies with known issues

## Output

### 🔴 Critical (fix before merge)

### 🟡 Warning (should fix)

### 🟢 Suggestions

Each as `file:line` — issue — why/failure scenario — fix hint.

### Per axis

| Axis      | Result                                               | Worst finding |
| --------- | ---------------------------------------------------- | ------------- |
| Standards | Pass / Issues                                        |               |
| Spec      | Pass / Issues / no spec available                    |               |
| Security  | Pass / Issues / not run (single mode: covered above) |               |

### ✅ What's good

Briefly.

### Merge-Readiness

Ready / Fix criticals first / Major rework needed — one sentence why.

Be direct. Cite exact file and line numbers.

## Gotchas

- Review the diff, not whole files; pre-existing issues are Suggestions at most.
- Subagents have no conversation context: paste the diff command, spec and checklist into each prompt.
- Launch the subagents in a single message, otherwise they run one after another.
- A missing spec is not a Spec failure.
- Don't report a finding without a concrete failure scenario.
- Never post comments, stage, or commit.
