# Checklists

One section per axis. The Callers, Scale and Lean items are adapted from [ponytail](https://github.com/DietrichGebert/ponytail) (MIT). CLAUDE.md of the project wins over these lists. Stack sections apply only when the project uses that stack (check `package.json` and CLAUDE.md).

## Standards

- Correctness: logic errors, edge cases (empty, zero, last item, rounding, time zones), missing `await`, race conditions
- Callers: every caller of a changed signature, return value or behavior still works; a fix applied in one caller while the shared function stays broken
- Architecture: breaks existing patterns, circular deps, premature abstraction
- Scale and speed: judge against the expected load from the README or deploy config, and say which you assumed. Check-then-write races, the same work done by every process, memory or lists that only grow, a query per item (N+1), missing pagination, O(n²) on big input, per-process state that must be shared, blocking the event loop. Big slowdowns are findings; small wins are Suggestions.
- Error handling: unhandled rejections, swallowed errors
- Tests: risky new logic (a branch, a parser, money, security, data writes, a bug fix) with no test that fails when it breaks; tests coupled to implementation. One good test, not coverage.
- Lean (every extra line must be read, tested and fixed later):
  - delete: dead code, unused options, speculative features
  - reuse: the repo already has this helper (name the path)
  - stdlib or native: the standard library or platform does it, or a new dependency for a few lines
  - yagni: abstraction with one implementation, config nobody sets
  - merge: near-copies that must change together
  - split: one function doing several unrelated jobs; split by job, never by line count

### TypeScript

- Strict violations, `any`, unsafe assertions
- Missing validation on external data

### NestJS (`@nestjs/core` in `package.json`)

- DI scope and circular deps
- Guard, pipe, interceptor and filter order
- DTO validation on every endpoint
- Correct HTTP exceptions and status codes

### React

- Unnecessary re-renders, missing effect cleanup, inline functions in hot paths

## Spec

Brief is in `SKILL.md`: missing or partial requirements, unrequested behavior, wrongly implemented requirements, each with the quoted spec line.

## Security

- Injection (SQL/NoSQL/shell/HTML), unvalidated input reaching a sink
- Missing or wrong authn/authz checks, IDOR, over-broad guards
- Secrets in code, logs or errors; sensitive data in responses
- CORS, rate limits, file upload handling, SSRF
- New dependencies with known issues
