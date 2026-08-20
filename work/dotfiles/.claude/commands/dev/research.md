---
description: Checks whether a ticket, feature request, or argument is technically feasible by actually researching the relevant code repos (not guessing from the ticket text alone). Breaks the requirement down into needed capabilities (data source/interface, business logic, UI, infrastructure/config) and determines for each whether it already exists, partially exists, or must be built from scratch. ALWAYS use this skill when the user asks "is this technically feasible", "does this already exist in the code", "what's still missing for this", "does this ticket make sense", "can you assess/evaluate ticket X" or similar — even if no specific technical detail (like an endpoint) is mentioned. Also trigger on "estimate effort", "feasibility analysis", "gap analysis for feature Y".
model: claude-sonnet-4-6
allowed-tools: Bash, Grep, Glob, Read, WebFetch, WebSearch, Atlassian:search, Atlassian:getJiraIssue, Atlassian:searchJiraIssuesUsingJql, Atlassian:getConfluencePage
---

# Ticket Feasibility Check

This skill answers "Is X feasible / what's still missing?" not through speculation, but through actual research in the relevant repos. The output is a structured assessment that clearly separates: what was actually checked, what was found, and what is pure opinion/judgment.

## Core principle

**Don't guess when you can look it up. Don't claim when you couldn't look it up.**

Every statement in the final result must fall into one of these three categories:
- **RESEARCHED** – actually found/not found in the code/system
- **JUDGMENT** – opinion/assessment based on what was found (clearly labeled as such)
- **UNCLEAR** – could not be checked (no access, too vague, etc.) – do NOT silently skip, state it explicitly

## Tools

This skill relies on:
- **Code search/read** (`Bash`, `Grep`, `Glob`, `Read` in Claude Code, or the equivalent GitHub/GitLab MCP connector on claude.ai) to actually search repos instead of guessing.
- **Ticket/wiki context** (`Atlassian:*` tools, or whatever Jira/Confluence/Linear connector is available) to pull the full ticket, not just what the user pasted.
- **Web search/fetch** only for external docs (e.g. a third-party API's documentation), not as a substitute for reading the actual codebase.

Adjust the `allowed-tools` list above to whatever is actually connected in your environment — the important part is that at least one code-reading tool and one ticket-context tool are available before running Step 4.

## Workflow

### Step 1: Understand the ticket/requirement

Get the full context before researching anything:
- Ticket description, acceptance criteria, linked tickets/comments (e.g. via Atlassian/Jira tools, if connected)
- If no ticket system is connected and the user just gives text/an argument: that's fine too, go straight to step 2

If after this step the requirement is still too vague to research meaningfully (e.g. "improve the ticket" with no further content), ask briefly. Otherwise don't ask — proceed with a reasonable assumption and state it briefly.

### Step 2: Break down into needed capabilities

Don't think in narrow technical terms ("does endpoint X exist"), but decompose the requirement into generic categories of capabilities the system would need:

- **Data source/interface**: API endpoint, event, message queue consumer, DB table/column, CLI command, file import/export
- **Business logic/validation**: rules, calculations, state transitions, permission checks
- **UI/presentation**: components, views, forms (if relevant to the ticket)
- **Infrastructure/configuration**: feature flags, permissions, migrations, deployment prerequisites, external services

Not every category is relevant for every ticket — only list the ones actually needed.

### Step 3: Determine relevant repos

- If the user names repos: use those.
- If not: derive them from the ticket context (project, component, label) and briefly confirm with the user which repos will be checked before investing a lot of time in search — especially if there are several candidates.
- Check access (GitHub/GitLab tools, if connected). If a repo isn't accessible: state this explicitly in the final result, don't silently skip it.

### Step 4: Research each capability

For each capability from step 2, in each relevant repo:

1. **Search for domain terms, not just technical vocabulary.** Example: for "CSV export for users" don't just search `csv`/`export` — also look for existing export mechanisms for other formats, since these often reveal a reusable pattern.
2. **Look for similar/related implementations, not just exact matches.** A repo that already solves a similar use case is often more informative than searching for the exact term from the ticket.
3. **Classify:**
   - EXISTS: already exists, directly usable
   - PARTIAL: partially exists / similar pattern present, needs extension
   - MISSING: doesn't exist, needs to be built from scratch
   - UNCHECKED: could not be conclusively checked

4. **Important — "exists" ≠ "should be used":** If something is found that fits technically but is e.g. marked as legacy, slated for deprecation, or would obviously be used outside its intended purpose, note this separately — don't just mark it as "exists".

### Step 5: Structure the result

The final result should contain these parts, clearly separated:

**1. Summary** (2-3 sentences): Is it feasible, roughly how much already exists vs. is missing.

**2. Gap analysis table:**

| Capability | Status | Finding(s) | Note |
|---|---|---|---|
| e.g. CSV export endpoint | PARTIAL | `export/pdf_handler.go` | PDF export exists, pattern is transferable, but no generic export interface |

**3. Technically feasible vs. makes sense — treat separately:**
- *Technically feasible*: can be answered Yes/Partially/No + rationale, based on the research.
- *Makes sense*: this is a product/business question, not a purely technical one. Clearly mark this as JUDGMENT, not fact. If the skill lacks the business perspective (user need, priority, roadmap), say so openly instead of pretending it was factored in.

**4. Open questions / risks:** Often the most valuable part — unverified assumptions, missing access to repos, dependencies on other teams, possible architectural constraints not visible from the code (runtime behavior, team agreements, infra limits).

**5. Rough effort estimate** (S/M/L), only if enough research was done to support it. Otherwise leave it out or clearly flag it as a very rough guess rather than faking precision.

## Important guardrails

- **Never guess what's in the code.** Every "exists"/"doesn't exist" claim must be based on actual search. If it couldn't be checked: mark as UNCHECKED.
- **No repo access → make that transparent**, don't compensate by inferring from the ticket text or general knowledge of similar systems.
- **Separate opinion from fact.** The question "does this make sense" almost always has an opinion component — it must be marked as such (e.g. JUDGMENT) so the user doesn't confuse it with the researched feasibility.
- **Don't just deliver Yes/No.** The real value is the gap table and the open questions — a plain "yes, feasible" without these details misses the point of the skill.