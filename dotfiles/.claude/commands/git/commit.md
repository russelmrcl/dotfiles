---
description: Analyze staged changes and generate a conventional commit message
disable-model-invocation: true
model: claude-sonnet-5-5
allowed-tools: Bash, AskUserQuestion
---

Generate a conventional commit message for the current staged changes.

## Instructions

First, get the staged diff:
```bash
git diff --cached
```

If nothing is staged, run:
```bash
git status
```
And tell the user to stage their changes first — do not proceed.

Check the branch name for a ticket key (e.g. `LF-42-...`):
```bash
git rev-parse --abbrev-ref HEAD
```
- Found → prefix every variant with `TICKET: `
- Not found → no prefix

<thinking>
Analyze the diff internally:
- What type of change is this? (feat/fix/refactor/chore/docs/test/style/perf)
- Which scope? (which module, component, or service was touched)
- What's the actual change in one line?
- Are there breaking changes?
- Is it one logical change or multiple? If multiple → suggest splitting
</thinking>

## Format

`type(scope): description` — imperative mood, max 72 chars (including any ticket prefix), no period at the end, no filler words.

## Output

Generate exactly 3 variants (most → least specific).

Present them with the AskUserQuestion tool so the user picks with Enter. The tool adds "Other" automatically for a custom message.

Once the user selects:
- A variant → run `git commit -m "<selected message>"`
- Custom text → commit with that message

Do not stage anything yourself and do not push.
