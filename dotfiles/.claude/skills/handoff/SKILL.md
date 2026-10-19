---
name: handoff
description: 'Write a handoff note so a fresh session can continue the work.'
argument-hint: '[what the next session will be used for]'
model: claude-sonnet-5-5
allowed-tools: Bash, Write
disable-model-invocation: true
---

Write a handoff document so a fresh agent can continue this work. $ARGUMENTS

If `$ARGUMENTS` names the next session's focus, tailor the document to it.

## Steps

1. **Collect** the state of the conversation: goal, what is done, decisions, blockers.
2. **Write** the document to `${TMPDIR:-/tmp}/handoff-<short-topic>.md`, outside the repo, using the structure below. Reference specs, tickets, commits and diffs by path, URL or SHA instead of copying them. Redact secrets and personal data.
3. **Print** the file path. Done when the path is printed.

## Structure

1. **Goal:** one paragraph
2. **State:** done / in progress / not started
3. **Decisions:** what was decided and why, so nobody re-litigates it
4. **Open questions and blockers**
5. **Next steps:** concrete, ordered
6. **Pointers:** files, branches, tickets, commands to run first
7. **Suggested skills:** which skills the next agent should call the Skill tool for

## Gotchas

- The note lives outside the repo; it never gets staged or committed.
- A pointer beats a copy: a pasted spec goes stale, a path stays right.
