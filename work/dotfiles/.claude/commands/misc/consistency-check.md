---
description: Check a newly built feature for consistency with CLAUDE.md conventions, project structure, and existing code patterns
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Edit, Write
---

Consistency Check: $ARGUMENTS

If no argument → ask: which feature, folder, or file(s) were just built?

## Step 1 — Gather Ground Truth (do this before judging anything)

1. **Find and read all CLAUDE.md files** — root-level and any nested ones inside the directories touched by the new feature. Nested CLAUDE.md files override/extend root rules for their subtree — treat them as the more specific authority.
2. **Map the project structure** (Glob) — where do comparable things live? How are folders/files/modules named? Is there a clear pattern (e.g. `features/*/components`, `services/*Service.ts`, `hooks/use*.ts`)?
3. **Find 1–3 existing features that are structurally similar** to the new one (Grep/Glob by naming pattern, not just by feeling similar). These are the actual precedent — not an idealized "best practice."
4. **Read the new feature's code in full** — every file it touches or adds.

Do not start comparing until steps 1–4 are done. Guessing at conventions instead of reading them is the main failure mode this command exists to prevent.

<thinking>
Compare the new feature against what was gathered, not against generic best practices:

**CLAUDE.md compliance:**
- Does the feature follow every explicit rule stated in the relevant CLAUDE.md(s)?
- Any rule that was silently ignored or worked around?
- Anything the feature does that CLAUDE.md explicitly forbids?

**Structural consistency:**
- Is the feature placed where similar features live, following the same folder/file layout?
- Do file names, component names, and export patterns match the existing convention?
- Same layering (e.g. UI / hooks / services / types split) as comparable features?

**Code pattern consistency:**
- Same state-management approach as similar features (not a new one introduced for no reason)?
- Same error-handling approach (thrown errors vs result objects vs try/catch wrapper, etc.)?
- Same data-fetching pattern (same client, same hook wrapper, same loading/error shape)?
- Same typing style (interfaces vs types, shared vs duplicated types)?
- Same import ordering/aliasing conventions?
- If there's a test convention elsewhere, does this feature follow it (same file location, same test utils)?

**Genuine deviations vs necessary ones:**
- Is a difference actually inconsistency, or does the new feature have a real reason to diverge (new requirement, different constraint)? Flag both, but label which is which.
</thinking>

## Output

### 1. Sources Checked
List which CLAUDE.md files were read and which existing features were used as the comparison baseline. If no CLAUDE.md exists, say so explicitly.

### 2. Consistency Findings

| # | Area | Finding | Severity | Location |
|---|------|---------|----------|----------|
| 1 | CLAUDE.md / Structure / Pattern | Description | High / Mid / Low | `file:line` |

Severity guide: **High** = violates an explicit CLAUDE.md rule or breaks a structural contract other code relies on / **Mid** = diverges from established pattern without reason / **Low** = minor naming/style drift

---

### 3. Aligned With Conventions
Explicitly list what the feature already does correctly — so it's clear what not to touch.

---

### 4. Suggested Fixes
Concrete edits to bring the feature in line, ordered by severity. For each: what to change and which existing file it should now match.

---

### 5. Intentional Deviations (if any)
Cases where the new feature differs from precedent for a legitimate reason (new requirement/constraint) — call these out so they aren't "fixed" by mistake later.

---

### 6. Open Questions
Anything ambiguous — e.g. two existing features use conflicting patterns and CLAUDE.md doesn't say which is canonical. Ask rather than pick one silently.

Don't over-engineer. The goal is one consistent codebase, not a rewrite.