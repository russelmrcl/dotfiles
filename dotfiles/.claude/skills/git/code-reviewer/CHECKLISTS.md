# Checklists

One section per axis. CLAUDE.md of the project wins over these lists. Stack sections apply only when the project uses that stack (check `package.json` and CLAUDE.md).

## Standards

- Correctness: logic errors, edge cases, missing `await`, race conditions
- Architecture: breaks existing patterns, circular deps, premature abstraction
- Performance: N+1, missing pagination, blocking the event loop
- Error handling: unhandled rejections, swallowed errors
- Tests: critical logic untested, tests coupled to implementation

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
