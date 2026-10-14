---
description: "Use when something is broken, throwing, failing, flaky or slow (\"debug\", \"warum geht das nicht\", \"error\", stacktrace pasted). Builds a red/green feedback loop first, then finds the root cause."
argument-hint: "[error message, stacktrace, or symptom]"
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash, Edit
---

Debug the following: $ARGUMENTS

If no error is provided, ask for: (1) exact error/stacktrace, (2) expected vs actual, (3) when it started.

Read the relevant code before theorising. Use stack and conventions from CLAUDE.md. Redact secrets (tokens, auth headers) in anything you quote.

## Process

### 1. Build a feedback loop (this is the skill)
Find ONE command you can run unattended that goes red on exactly this bug and green once fixed:
failing test → curl/HTTP script → CLI with fixture → replayed payload → throwaway harness → `git bisect run`.
Make it fast (seconds) and deterministic (pin time, seed RNG). For flaky bugs, raise the reproduction rate instead.
Run it once and show the output. No red-capable command → no hypotheses. If you can't build one, say what you tried and ask the user.

### 2. Minimise
Cut inputs, config and steps one at a time until every remaining element is load-bearing. This becomes the regression test.

### 3. Hypothesise
List 3–5 ranked, falsifiable hypotheses: "If X is the cause, then changing Y makes the bug disappear."
Show the list before testing — the user often knows what's already ruled out.

### 4. Instrument
One variable at a time. Prefer a debugger/REPL over logs; never "log everything".
Tag every temporary log with `[DEBUG-xxxx]` so cleanup is one grep.

### 5. Fix + verify
Fix the root cause, not the symptom. Re-run the loop (green), then the wider test suite.
Keep the minimised repro as a regression test where a seam exists. Remove all `[DEBUG-xxxx]` logs.

## Output

Keep it as short as the bug allows (a trivial bug gets a trivial answer).

- **Root cause:** what and why, with `file:line` evidence
- **Fix:** the change (before/after if helpful)
- **Verified by:** the loop command + result
- **Blast radius:** same pattern elsewhere? (only if found)

## Gotchas

- Theorising from the code before a failing command exists is the failure mode. Loop first.
- Reproduce the user's exact symptom, not a nearby one.
- "Log everything" hides the signal; one tagged probe per hypothesis.
- Remove every `[DEBUG-xxxx]` log before finishing.
