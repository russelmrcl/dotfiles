---
description: Analyze and optimize code for performance, memory, and efficiency
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Edit, Write, Bash
---

Optimize: $ARGUMENTS

No argument → ask: specific file/function, or general pass?

Read all relevant files first — CLAUDE.md, then target code + imports.

## Instructions

### Step 0 — Detect stack

```bash
cat package.json
```

Adjust optimization profile:
- `koa` → async middleware bottlenecks, blocking sync ops in request handlers, missing connection pooling
- `@fluentui/react-components` → `makeStyles` over inline styles, named icon imports (not wildcard), FluentProvider not re-mounted unnecessarily
- `react` → re-renders, memo, stale closures, useEffect cleanup
- DB layer → N+1, over-fetching, missing indexes, no pagination
- Bundler (vite/webpack) → dynamic imports, tree-shaking, heavy deps

<thinking>
Find actual bottlenecks — no guessing:

React: unnecessary re-renders, inline functions breaking memo, useMemo without expensive computation (over-optimization), context causing full subtree re-render, missing useEffect cleanup
Data: N+1, over-fetching fields, no pagination, missing indexes, waterfall requests → Promise.all
Bundle: heavy non-tree-shaken imports, missing dynamic imports, unoptimized images
Network: no debounce on user-triggered requests, no caching (react-query/swr), sequential requests
Memory: useEffect without cleanup, event listeners never removed, intervals not cleared

Complexity check: is this worth the added code complexity? What's the realistic gain?
Stack-specific: apply profile from Step 0
</thinking>

## Optimization Priorities

1. Measure first — don't optimize what isn't slow
2. Data layer — N+1, indexes, over-fetching (biggest real-world impact)
3. Network — parallel requests, caching, debounce
4. Memory leaks — correctness before perf
5. React renders — memo/useMemo only where measurably expensive
6. Bundle — dynamic imports, tree-shaking, dep swaps
7. Micro-optimizations — last resort only

## Output

### Bottlenecks Found

| # | Issue | Category | Impact | Evidence |
|---|-------|----------|--------|----------|

### Optimized Code

Full version — not a diff. Comments only where why isn't obvious.

### What Changed & Why

One line per change, impact quantified where possible.

### Trade-offs

| Change | Complexity added | Perf gained | Worth it? |
|--------|-----------------|-------------|-----------|

### What Was Not Optimized & Why

Explicit non-changes with reason.

### Next Steps

- [ ] Concrete follow-up with expected impact