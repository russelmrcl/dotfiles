---
name: code-optimize
description: 'Find measured bottlenecks and optimize only what is worth the added complexity.'
argument-hint: '[file or function]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Edit, Write, Bash
disable-model-invocation: true
---

Optimize the following code: $ARGUMENTS

No argument: ask what to optimize. Use stack and conventions from CLAUDE.md.

## Steps

1. **Read** the target and the patterns the codebase already uses.
2. **Measure.** Find the actual bottleneck with a profiler, query plan, timing or bundle analysis. Done when you can state what you measured, how, and the number. Nothing slow found: say so and stop.
3. **Rank** the findings by layer: DB queries (indexes, N+1, pagination, field selection), React renders (memo, `useMemo`, `useCallback` where justified), bundle size (dynamic imports, tree-shaking, heavy deps), network (caching, debounce, parallel requests), memory leaks (`useEffect` cleanup, listeners, timers).
4. **Change** the top finding if the gain is worth the complexity. Re-measure. Done when the before and after numbers are side by side.

## Output

1. **Bottlenecks found:** what is slow, why, and the measurement.
2. **Optimized code:** the changes applied.
3. **What changed and why:** per change, what, why, measured impact.
4. **Trade-offs:** complexity added vs performance gained, including "not worth it".
5. **Next steps:** out-of-scope improvements.

## Gotchas

- `useMemo` and `useCallback` everywhere is a regression.
- Readability outweighs a micro-optimization.
