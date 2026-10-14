---
description: Analyze staged changes and generate a conventional commit message
model: claude-sonnet-5-5
allowed-tools: Bash
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

<thinking>
Analyze the diff internally:
- What type of change is this? (feat/fix/refactor/chore/docs/test/style)
- Which scope? (which module, component, or service was touched)
- What's the actual change in one line?
- Are there breaking changes?
- Is it one logical change or multiple? If multiple → suggest splitting
</thinking>

## Commit Format
**Types:** `feat` `fix` `refactor` `chore` `docs` `test` `style` `perf`

## Output

Generate exactly 3 commit message variants (most → least specific).

Then present them as a **select prompt** — list the options so the user can pick by pressing Enter on their selection, not by typing a number. Include a "Custom" option as the last choice.

Once the user selects an option:
- If it's one of the variants → immediately run `git commit -m "<selected message>"`
- If it's "Custom" → ask them to type their message, then commit

Keep messages under 72 characters. No period at the end.

Once confirmed, run:
```bash
git commit -m "chosen message"
```

Keep messages under 72 characters. No fluff, no period at the end.
