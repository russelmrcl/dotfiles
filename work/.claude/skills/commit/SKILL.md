---
name: commit
description: 'Write a Conventional Commit message from the staged diff and commit the variant you pick.'
model: claude-sonnet-5-5
allowed-tools: Bash, AskUserQuestion
disable-model-invocation: true
---

Generate a Conventional Commit message for the staged changes.

## Steps

1. **Read the diff.** Run `git diff --cached`. Empty: run `git status`, tell me to stage my changes first, and stop. Unstaged changes are not committed and you do not stage them.
2. **Find the ticket.** Run `git rev-parse --abbrev-ref HEAD`. A ticket key in the branch name (e.g. `LF-42-...`) prefixes every variant as `TICKET: `; otherwise no prefix. Never invent a key.
3. **Classify the change:** type (feat, fix, refactor, chore, docs, test, style, perf), scope (module, component or service touched), the change in one line, breaking or not. Many unrelated files or several logical changes: recommend splitting before writing any message.
4. **Write 3 variants,** most to least specific. Format: `type(scope): description`, imperative mood, max 72 chars including any ticket prefix, no trailing period. If `git log -10 --format=%s` shows the repo does not use Conventional Commits (e.g. `WC-665 add smoke tests`), match that style instead: `TICKET description`, no type or scope.
5. **Let me pick** with the AskUserQuestion tool (it adds "Other" for a custom message). Then run `git commit -m "<selected message>"`. Done when the commit exists.

## Gotchas

- Commit only; no staging, no push, no `--amend` unless asked.
- On `main` or `master`: stop and tell me to switch to a feature branch.
