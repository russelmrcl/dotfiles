---
description: Build a feature or fix a bug test-first (red → green), one vertical slice at a time
argument-hint: "[feature or bug]"
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash, Edit, Write
---

Implement test-first: $ARGUMENTS

If no argument, ask what to build or fix.

Read CLAUDE.md and 1–2 existing tests first. Match the project's runner (vitest/jest, check `package.json`) and test layout.

## Seams first

A seam is the public boundary you test at (an HTTP route, an exported service function) — never internals.
Before writing any test, propose the seams (prefer existing, fewer is better, one note each on what it catches/misses) and **confirm them with me**.

## Loop

Repeat per behavior — one seam, one test, one minimal implementation:

1. **Red** — write one test for one behavior; run it; confirm it fails for the right reason.
2. **Green** — write just enough code to pass; run it.
3. Next behavior. Each test responds to what the last cycle taught you.

## Rules

- Never write all tests first, then all code (horizontal slicing).
- Test behavior via the public interface; refactoring must not break tests.
- No mocks of your own modules — only at system boundaries (network, clock, DB driver).
- No tautological asserts (`expect(add(a,b)).toBe(a+b)`): expected values come from a literal or the spec.
- NestJS: test at the HTTP level (`Test.createTestingModule` + supertest) — assert `status` and `body`, not provider internals. Override providers only at boundaries (DB, external APIs).
- Don't refactor during the loop; do it once all slices are green.

## Output

After each cycle, one line: `RED <test> → GREEN <what was added>`.
At the end: tests added, seams used, anything deliberately left untested.
