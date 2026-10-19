---
name: tdd
description: 'Use when the user wants to build a feature or fix a bug test-first ("TDD", "red green", "write the test first"). Works one vertical slice at a time at seams the user confirms.'
argument-hint: '[feature or bug]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash, Edit, Write
---

Implement test-first: $ARGUMENTS

No argument: ask what to build or fix.

## Steps

1. **Read.** CLAUDE.md and 1-2 existing tests. Match the project's runner (vitest or jest, check `package.json`) and test layout.
2. **Agree the seams.** A seam is the public boundary you test at (an HTTP route, an exported service function), never internals. Propose the seams (prefer existing ones, fewer is better, one note each on what it catches and misses) and confirm them with me. Done when I have confirmed; no test is written at an unconfirmed seam.
3. **Loop,** one seam, one test, one minimal implementation per behavior:
   1. **Red:** write one test for one behavior, run it, confirm it fails for the right reason.
   2. **Green:** write just enough code to pass, run it.
   3. Next behavior. Each test responds to what the last cycle taught you.
4. **Refactor** once all slices are green.

## Rules

- Work in vertical slices. Tests written all up front verify imagined behavior.
- Test behavior through the public interface, so a refactor never breaks a test.
- Mock only at system boundaries (network, clock, DB driver). Mocking your own modules is the usual sign the seam is wrong.
- Expected values come from a literal or the spec. `expect(add(a, b)).toBe(a + b)` passes by construction.
- NestJS: test at the HTTP level (`Test.createTestingModule` + supertest), assert `status` and `body`, and override providers only at boundaries (DB, external APIs).

## Output

After each cycle, one line: `RED <test> → GREEN <what was added>`.
At the end: tests added, seams used, anything deliberately left untested.

## Gotchas

- A test that never went red proves nothing; check the failure reason.
- Refactoring inside the loop hides which change turned a test green.
