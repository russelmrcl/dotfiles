---
description: "Use when the user wants to continue in a fresh session or hand work to another agent (\"handoff\", \"übergabe\", \"new session\"). Writes a compact note to $TMPDIR, not the repo."
argument-hint: "[what the next session will be used for]"
model: claude-sonnet-5-5
allowed-tools: Bash, Write
disable-model-invocation: true
---

Write a handoff document so a fresh agent can continue this work. $ARGUMENTS

- Save to `${TMPDIR:-/tmp}/handoff-<short-topic>.md` — not into the repo.
- Don't duplicate what's already in specs, tickets, commits or diffs: reference by path/URL/SHA.
- Redact secrets and personal data.

## Structure

1. **Goal** — one paragraph
2. **State** — done / in progress / not started
3. **Decisions** — what was decided and why (so they aren't re-litigated)
4. **Open questions & blockers**
5. **Next steps** — concrete, ordered
6. **Pointers** — files, branches, tickets, commands to run first
7. **Suggested skills** — which slash commands the next agent should use

If `$ARGUMENTS` names the next session's focus, tailor the doc to it.
End by printing the file path.

## Gotchas

- Reference specs/tickets/commits by path or URL; don't copy their content.
- Redact secrets and personal data.
- Save outside the working tree and print the path.
