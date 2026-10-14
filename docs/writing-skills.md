# Writing Skills

How to write slash commands / skills that behave predictably.
Sources: Matt Pocock's `skills` repo (`writing-for-agents`) and `shanraisshan/claude-code-best-practice`.

---

## 1. Commands vs. skills

| | `commands/<name>.md` | `skills/<name>/SKILL.md` |
|---|---|---|
| Shape | single file | folder |
| Namespacing | subfolder → `git:commit` | name from directory or `name:` |
| Bundled files | no | scripts, templates, reference docs |
| Slash command | yes | yes |

Use a **command** for a single prompt. Use a **skill** when the prompt needs supporting files (checklists, templates, scripts).

## 2. Frontmatter

```yaml
---
description: "Use when … (the trigger, not a summary)"
argument-hint: "[path or ref]"
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash
disable-model-invocation: true   # only the user may run it
context: fork                    # run in an isolated subagent context
---
```

| Field | Rule |
|---|---|
| `description` | Starts with the trigger: "Use when …". It is always in context and decides *when* the skill loads. |
| `allowed-tools` | Grant exactly what the steps need. Missing tools cause silent permission prompts or dead ends (e.g. a select prompt without `AskUserQuestion`). |
| `disable-model-invocation` | Set for anything with side effects (commit, deploy, cleanup) so Claude never fires it on its own. |
| `argument-hint` | Shows in autocomplete; document what `$ARGUMENTS` expects. |
| `context: fork` | For noisy work (review, debugging) that would otherwise fill the main session. |

## 3. Writing principles

### The description is a pointer
The wording of the description, not the body, decides how reliably the skill is reached.

- Front-load the trigger.
- One trigger per distinct case; synonyms for the same case are noise.
- Drop identity the body already carries.

### Two budgets
- **Context load**: always-loaded text (CLAUDE.md lines, descriptions) costs tokens and attention every turn.
- **Cognitive load**: how much *you* must remember about which skill exists. Spend it where human judgement matters.

### Information hierarchy
1. **In-file steps**: what the agent does, in order.
2. **In-file reference**: rules and checklists consulted on demand.
3. **Disclosed reference**: separate files, loaded only when a pointer fires.

Inline what every branch needs; push behind a pointer what only some branches need. Keep a concept's definition, rules and caveats under one heading (co-location).

### Every step ends on a completion criterion
- *Clear*: the agent can tell done from not-done.
- *Demanding*: it forces real work. "Every modified module accounted for" beats "produce a change list".

Vague criteria cause premature completion. Sharpen the bound first; split a sequence only if later steps keep tempting the agent to rush.

### Leading words
A compact term from the model's pretraining (*tracer bullet*, *red*, *tight loop*, *vertical slice*) anchors behavior in one token. Pick a few, use them consistently, and replace multi-sentence restatements with them.

### State the positive
"Don't do X" makes X more available. Write the target behavior: "Review the diff only" instead of "Don't review whole files".

### Prune
- **Single source of truth**: one place per meaning.
- Don't restate what the environment already says (`package.json` scripts, config, `--help`). Cache only what can't be found by looking: the unwritten convention, the reason, the gotcha.
- **No-ops**: delete instructions the model follows anyway ("be thorough", "write clean code").
- Check relevance on every edit; stale lines settle like sediment.

### Add a Gotchas section
The highest-signal part of a skill. Record each failure you actually observe, and extend the list over time.

## 4. Skill checklist

- [ ] Description starts with "Use when …" and names distinct triggers
- [ ] `allowed-tools` matches the steps; nothing missing, nothing extra
- [ ] Side-effect skills have `disable-model-invocation: true`
- [ ] Every step has a checkable completion criterion
- [ ] No negations where a positive instruction works
- [ ] No no-ops, no restated config
- [ ] Gotchas section present
- [ ] Never stages, commits or pushes unless that is the skill's job

---

For workflow habits (planning, verification, hooks, context, git), see [claude-code-best-practices.md](claude-code-best-practices.md).
