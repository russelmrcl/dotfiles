---
description: Run ESLint, fix all violations, then run Prettier if clean
model: claude-sonnet-4-6
allowed-tools: Read, Glob, Grep, Bash, Edit, Write
---

Run a full lint and format pass on: $ARGUMENTS

If no argument given, run on the entire project.

## Instructions

### Step 1: Run ESLint
```bash
npx eslint $ARGUMENTS --format=json
```

Analyze the output:
- If errors found → go to Step 2
- If clean → skip to Step 4

### Step 2: Fix Automatically
```bash
npx eslint $ARGUMENTS --fix
```

### Step 3: Fix Remaining Manually
For violations that `--fix` couldn't resolve:
- Read the affected file
- Understand the context
- Fix properly — don't just suppress with `// eslint-disable`
- Only disable a rule if there is a legitimate reason, and add a comment explaining why

Re-run ESLint after manual fixes to confirm clean:
```bash
npx eslint $ARGUMENTS
```

Do not proceed to Step 4 until ESLint is fully clean.

### Step 4: Run Prettier
```bash
npx prettier $ARGUMENTS --write
```

## Output

### ESLint Results
- How many violations found
- Which rules triggered most
- What was auto-fixed vs manually fixed

### Prettier
- Confirmation it ran
- Files formatted

### Summary
- Overall status: clean or issues remaining
- Any rules that were disabled + reason why
