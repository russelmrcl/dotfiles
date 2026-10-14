---
description: 'Use when the user wants code tidied or refactored without changing behavior ("clean up", "refactor", "aufräumen"). Presents findings and the cleaned version, then asks before editing.'
disable-model-invocation: true
argument-hint: '[file, function, or branch]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Edit, Write
---

Refactor the following code: $ARGUMENTS

If no argument given, ask what should be refactored.

Read all relevant files first to understand context and existing patterns before changing anything.
Use stack and conventions from CLAUDE.md.

## Instructions

<thinking>
Analyze internally before touching anything:
- What code smells exist? (naming, duplication, complexity, dead code)
- What TypeScript violations? (any, missing types, missing interfaces)
- What patterns are already used in the codebase? Stay consistent.
- What's the minimal change for maximum improvement? Don't over-engineer.
</thinking>

## Refactor Priorities

1. Remove dead code (unused imports, variables, commented code)
2. Fix TypeScript (no `any`, proper interfaces, utility types)
3. DRY — extract duplicated logic
4. Early returns over nested ifs
5. Single responsibility — split functions >50 lines
6. Modern patterns (optional chaining, nullish coalescing, destructuring)

## Output

### 1. Issues Found

Short list — what's wrong and why.

### 2. Refactored Code

Clean version with changes applied.

### 3. What Changed & Why

Brief explanation per change. No obvious comments.

### 4. Further Improvements

Optional enhancements that were out of scope.

Don't over-engineer. Pragmatic improvements over perfect abstractions.

Present the result first and ask before editing files. Do not stage or commit.

## Gotchas

- Behavior must not change; if tests don't exist, say so before touching risky code.
- Stay inside the requested scope or branch diff; out-of-scope smells go to Follow-up.
- Don't introduce a new pattern when the codebase already has one.
- Never stage or commit.
