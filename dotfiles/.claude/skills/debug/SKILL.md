---
name: debug
description: 'Use when something is broken, throwing, failing, flaky or slow ("debug", "why does this fail", "error", stacktrace pasted). Builds a red/green feedback loop first, then finds the root cause.'
argument-hint: '[error message, stacktrace, or symptom]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash, Edit
---

Debug the following: $ARGUMENTS

No error provided: ask for (1) the exact error or stacktrace, (2) expected vs actual, (3) when it started.

Read the relevant code before theorising. Use stack and conventions from CLAUDE.md. Redact secrets (tokens, auth headers) in anything you quote.

## Steps

### 1. Build a feedback loop

This step is the skill. Find ONE command you can run unattended that goes red on exactly this bug and green once it is fixed: failing test, curl or HTTP script, CLI with fixture, replayed payload, throwaway harness, `git bisect run`. Make it fast (seconds) and deterministic (pin time, seed RNG). For flaky bugs, raise the reproduction rate instead.

Done when you have run it once and shown the red output. Without a red-capable command, form no hypotheses: say what you tried and ask me.

### 2. Minimise

Cut inputs, config and steps one at a time until every remaining element is load-bearing. The result becomes the regression test.

### 3. Hypothesise

List 3-5 ranked, falsifiable hypotheses: "If X is the cause, changing Y makes the bug disappear." Show the list before testing; I often know what is already ruled out.

### 4. Instrument

Change one variable at a time. Prefer a debugger or REPL over logs. Tag every temporary log with `[DEBUG-xxxx]` so cleanup is one grep.

### 5. Fix and verify

Fix the root cause. Re-run the loop (green), then the wider test suite. Keep the minimised repro as a regression test where a seam exists. Done when every `[DEBUG-xxxx]` log is gone.

## Output

As short as the bug allows; a trivial bug gets a trivial answer.

- **Root cause:** what and why, with `file:line` evidence
- **Fix:** the change (before/after if helpful)
- **Verified by:** the loop command and its result
- **Blast radius:** the same pattern elsewhere (only if found)

## Gotchas

- Reproduce my exact symptom, not a nearby one.
- One tagged probe per hypothesis.
