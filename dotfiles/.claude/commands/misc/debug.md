---
description: Analyze errors, stacktraces, and bugs to find root cause and fix
model: claude-sonnet-4-6
allowed-tools: Read, Glob, Grep, Bash
---

Debug the following: $ARGUMENTS

## Instructions

Read all relevant files before analyzing — never guess without seeing the actual code.

<thinking>
Analyze internally:
- What does the error actually say? (don't paraphrase, read it literally)
- Where exactly does it originate? (file, line, function)
- What's the call stack telling me?
- Is this a type error, runtime error, logic error, or config issue?
- What changed recently that could have caused this?
- Are there similar patterns elsewhere in the codebase that work correctly?
</thinking>

If no error is provided, ask for:
1. The error message / stacktrace
2. What was expected vs what happened
3. When it started occurring

## Output

### Root Cause
What's actually broken and why — be specific, cite file and line.

### Fix
The exact change needed. Show before/after if helpful.

### Why It Happened
Brief explanation — helps avoid the same mistake again.

### Verify
How to confirm the fix worked:
```bash
# command to verify
```

### Watch Out For
Any related areas that could have the same issue.
