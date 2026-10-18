---
name: pr
description: 'Write a PR title and body from the branch diff.'
argument-hint: '[base branch, default main]'
model: claude-sonnet-5-5
allowed-tools: Bash
disable-model-invocation: true
---

Write a PR description for the current branch against `${ARGUMENTS:-main}`.

## Steps

1. **Read the branch.** Nothing to diff (empty `git log <base>..HEAD`): say so and stop.

   ```bash
   git branch --show-current
   git log <base>..HEAD --oneline
   git diff <base>...HEAD --stat
   git diff <base>...HEAD
   ```

2. **Write the title.** Conventional Commit style, max 72 chars. A ticket key in the branch name (`LF-42-...`) becomes a prefix: `LF-42: feat(export): add CSV export`.
3. **Write the body** from the template below.
4. **Print** title and body as plain text to copy. Offer `gh pr create` as a next step.

## Body template

```markdown
## Summary

<smallest view that makes the point: pseudocode, call tree, file tree, or a diff sketch. No preamble.>

## Evidence

- **Before:** <failing test / output / screenshot>
  **After:** <passing test / output / screenshot>

## Merge danger

**Door:** one-way | two-way (can this be undone by reverting?)
**Blast radius:** <one word: none / module / service / data / users>
<only if non-trivial: migrations, API contract changes, env vars, rollout order>

## How to test

1. ...
```

## Gotchas

- Claim only what the diff shows. No evidence for Before/After: write "not captured".
- Shared-contract changes (API shape, DB schema, shared types) belong under Merge danger.
- Pushing and `gh pr create` happen only when I ask.
