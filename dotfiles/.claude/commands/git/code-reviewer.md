---
description: Review code for bugs, security issues, and best practices
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep
---

Review the following: $ARGUMENTS

If no argument given, review the current working directory.

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
- Koa specific: middleware order, ctx usage, missing status codes
</thinking>

## Output

### 🔴 Critical (fix before merge)
Issues that cause bugs or security vulnerabilities.

### 🟡 Warning (should fix)
Code smell, bad patterns, maintainability issues.

### 🟢 Suggestions (nice to have)
Minor improvements, style, readability.

### ✅ What's good
Briefly note what's done well — keeps feedback balanced.

Be direct. No sugarcoating. Cite exact file and line numbers.
