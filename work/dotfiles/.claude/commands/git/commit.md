---
description: Analyze staged changes and generate a conventional commit message
model: claude-sonnet-5-5
allowed-tools: Bash
---

Generate a conventional commit message for the staged changes.

## Instructions

Extract the ticket from the current branch:
```bash
git rev-parse --abbrev-ref HEAD
```
- Found → prefix every variant with `TICKET: `
- Not found → no prefix, mention it briefly

Get the staged diff:
```bash
git diff --cached
```
Nothing staged → run `git status`, tell the user to stage first, stop.

### Pre-commit lint

```bash
git diff --cached --name-only
```

Pass staged files to `/lint` — if errors → stop, show violations, tell user to fix first.

<thinking>
- One logical change or multiple? If multiple → recommend splitting
- What changed, in as few words as possible?
- Ticket prefix from branch?

Rules:
- Max 72 chars total (including ticket prefix)
- No filler words ("update", "change", "some", "various")
- No period at the end
- Imperative mood ("add" not "added")
- Shorter is better
</thinking>

## Format

```
TICKET: short description of what changed
```

Good: `LF-42: fix redirect loop on token expiry`
Bad: `LF-42: fixed some bugs in the authentication module`

## Output

3 variants — short to even shorter.

Select prompt — pick with Enter, not by typing a number. "Custom" as last option.

- Variant picked → `git commit -m "message"`
- Custom → ask for input, then commit

No confirmation after committing.