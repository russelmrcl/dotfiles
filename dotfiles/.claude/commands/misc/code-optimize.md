---
description: Analyze and optimize code for performance, memory, and efficiency
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Edit, Write
---

Optimize the following code: $ARGUMENTS

If no argument given, ask what should be optimized.

Read all relevant files first to understand context and existing patterns.
Use stack and conventions from CLAUDE.md.

## Instructions

<thinking>
Analyze internally before changing anything:
- Where are the actual bottlenecks? (don't guess, find them)
- React: unnecessary re-renders, missing memo, inline functions?
- DB: N+1 queries, missing indexes, over-fetching fields?
- Bundle: heavy imports, missing lazy loading, no code splitting?
- Memory: missing useEffect cleanup, event listener leaks, intervals?
- Is the optimization worth the added complexity?
</thinking>

## Optimization Priorities
1. Measure first — don't optimize what isn't slow
2. DB queries (indexes, N+1, pagination, field selection)
3. React renders (memo, useMemo, useCallback where justified)
4. Bundle size (dynamic imports, tree-shaking, heavy deps)
5. Network (caching, debounce, parallel requests)
6. Memory leaks (useEffect cleanup, listeners, timers)

## Output

### 1. Bottlenecks Found
What's actually slow and why — no premature optimization.

### 2. Optimized Code
Improved version with changes applied.

### 3. What Changed & Why
Per change: what, why, expected impact.

### 4. Trade-offs
Complexity added vs performance gained — be honest.

### 5. Next Steps
Further improvements that were out of scope.

Don't sacrifice readability for micro-optimizations.
