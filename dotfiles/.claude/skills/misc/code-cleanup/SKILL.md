---
name: code-cleanup
description: 'Refactor and tidy code without changing behavior. Presents findings first, edits after you agree.'
argument-hint: '[file, function, or branch]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Edit, Write
disable-model-invocation: true
---

Refactor the following code: $ARGUMENTS

No argument: ask what to refactor. Use stack and conventions from CLAUDE.md.

## Steps

1. **Read** the target, its callers, its tests and the patterns the codebase already uses. Done when you can name the pattern to stay consistent with. No tests around risky code: say so before touching it.
2. **Find issues** in this order: dead code (unused imports, variables, commented code), TypeScript (`any`, missing types or interfaces), duplication, nested ifs, functions over 50 lines, old-style patterns (optional chaining, nullish coalescing, destructuring).
3. **Present** the Output below and ask before editing any file. Done when I have said yes.
4. **Apply** the agreed changes and re-run the project's tests, tsc and lint.

## Refactor priorities

1. Remove dead code
2. Fix TypeScript: no `any`, proper interfaces, utility types
3. DRY: extract duplicated logic
4. Early returns over nested ifs
5. Single responsibility: split functions over 50 lines
6. Modern patterns: optional chaining, nullish coalescing, destructuring

## Output

1. **Issues found:** short list, what is wrong and why.
2. **Refactored code:** the clean version.
3. **What changed and why:** one line per change.
4. **Further improvements:** out-of-scope ideas.

## Gotchas

- Behavior stays identical.
- Stay inside the requested scope or branch diff; other smells go to Further improvements.
- The codebase's existing pattern wins over a new one.
- Nothing is staged or committed.
