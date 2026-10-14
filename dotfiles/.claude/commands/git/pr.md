---
description: Write a pull request title and body from the current branch
argument-hint: "[base branch, default main]"
model: claude-sonnet-5-5
allowed-tools: Bash
disable-model-invocation: true
---

Write a PR description for the current branch against `${ARGUMENTS:-main}`.

```bash
git branch --show-current
git log <base>..HEAD --oneline
git diff <base>...HEAD --stat
git diff <base>...HEAD
```

Nothing to diff → say so and stop. Don't push or open the PR unless I ask.

## Title

Conventional Commit style, max 72 chars. If the branch name has a ticket key (`LF-42-...`), prefix it: `LF-42: feat(export): add CSV export`.

## Body

```markdown
## Summary
<smallest view that makes the point: pseudocode, call tree, file tree, or a diff sketch. No preamble.>

## Evidence
- **Before:** <failing test / output / screenshot>
  **After:** <passing test / output / screenshot>

## Merge danger
**Door:** one-way | two-way   (can this be undone by reverting?)
**Blast radius:** <one word: none / module / service / data / users>
<only if non-trivial: migrations, API contract changes, env vars, rollout order>

## How to test
1. ...
```

## Rules

- Only claim what the diff shows; if there's no evidence for Before/After, write "not captured" instead of inventing it.
- Flag shared-contract changes (API shape, DB schema, shared types) under Merge danger.
- Output the title and body as plain text for me to copy. Offer `gh pr create` as a next step.
