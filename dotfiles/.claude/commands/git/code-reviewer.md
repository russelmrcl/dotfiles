---
description: Review code for bugs, security issues, and best practices
argument-hint: "[base ref, branch, or path; default: uncommitted changes]"
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash
---

Review the following: $ARGUMENTS

If no argument given, review the current uncommitted and branch changes:
```bash
git status --short
git diff HEAD
```
If there are no changes, ask what should be reviewed.

Read all relevant files to understand full context before reviewing.
Use conventions and stack from CLAUDE.md.

## Instructions

<thinking>
Analyze internally across these dimensions:
- Correctness: bugs, edge cases, logic errors
- Security: vulnerabilities, injection risks, exposed secrets
- TypeScript: strict violations, implicit any, missing types
- Architecture: violates existing patterns in the codebase?
- Performance: unnecessary re-renders, N+1 queries, missing indexes
- Error handling: unhandled promises, missing try/catch
- NestJS specific: DI scope and circular deps, guard/pipe/interceptor/filter order, DTO validation (`class-validator` or Zod pipe) on every endpoint, correct HTTP exceptions/status codes, missing `await` in async providers
</thinking>

## Two axes

Review along two separate axes and never merge them into one ranking:

- **Standards** — does the change follow CLAUDE.md and the patterns already in the repo? (dimensions above)
- **Spec** — does it do what was asked? Find the spec: ticket key in commit messages/branch name, a path passed as argument, or a file under `docs/`/`specs/`. None found → ask once; if there's none, report "no spec available" and skip this axis.

Spec findings: (a) requirements missing or partial, (b) behavior added that wasn't asked for, (c) requirements implemented wrongly. Quote the spec line for each.

A change can pass one axis and fail the other — report both explicitly.

## Output

### 🔴 Critical (fix before merge)
Issues that cause bugs or security vulnerabilities.

### 🟡 Warning (should fix)
Code smell, bad patterns, maintainability issues.

### 🟢 Suggestions (nice to have)
Minor improvements, style, readability.

### 📋 Spec
Missing / scope creep / wrong — each with the quoted requirement. Or "no spec available".

### ✅ What's good
Briefly note what's done well — keeps feedback balanced.

### Merge-Readiness
Ready / Fix criticals first / Major rework needed — one sentence why.

Be direct. No sugarcoating. Cite exact file and line numbers.
