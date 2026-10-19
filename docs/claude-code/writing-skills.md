# Writing Skills

How to write skills that behave predictably.
Sources: Matt Pocock's `skills` repo (`writing-for-agents`, `.agents/invocation.md`) and `shanraisshan/claude-code-best-practice`.

---

## 1. Layout

Every slash command in this repo is a skill, one folder per skill:

```
dotfiles/.claude/skills/<bucket>/<name>/SKILL.md   # + optional references/ folder for reference files
```

Buckets (`dev`, `git`, `misc`, `productivity`) organise the repo only. `deploy.sh` copies each skill flat to `~/.claude/skills/<name>/`, so the command is `/<name>`. Skill names are lowercase with hyphens and unique across buckets. Reference files (checklists, templates, scripts) live in a `references/` folder next to `SKILL.md` and are reached through a link in it.

## 2. Frontmatter

Fixed field order:

```yaml
---
name: code-reviewer
description: 'Use when … (the trigger, not a summary)'
argument-hint: '[path or ref]'
model: claude-sonnet-5-5
allowed-tools: Read, Glob, Grep, Bash
disable-model-invocation: true # only the user may run it
---
```

| Field                      | Rule                                                                                                                                            |
| -------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| `name`                     | Equals the folder name.                                                                                                                         |
| `description`              | Model-invoked: starts with "Use when …" and names the distinct triggers. User-invoked: one human-facing line, no trigger list. English only.    |
| `allowed-tools`            | Grant exactly what the steps need. Missing tools cause silent permission prompts or dead ends (e.g. a select prompt without `AskUserQuestion`). |
| `disable-model-invocation` | Set for anything with side effects (commit, deploy, cleanup) so Claude never fires it on its own. It makes the skill user-invoked.              |
| `argument-hint`            | Shows in autocomplete; document what `$ARGUMENTS` expects. Omit when the skill takes no arguments.                                              |

### Invocation

- **Model-invoked** (default): Claude can reach the skill from its description, other skills can call it, and you can still type it. The description sits in context every turn, so it pays for that reach.
- **User-invoked** (`disable-model-invocation: true`): only you can fire it, no description cost, but you must remember it exists.

Choose model-invoked only when Claude must reach the skill on its own or another skill must call it. A skill calls another with `Call the Skill tool with "<name>"`, which works for model-invoked targets only. For a user-invoked target, tell the user to run `/<name>`.

### Body shape

1. One-line job with `$ARGUMENTS`.
2. The no-argument behavior in one line (ask, or a default).
3. `## Steps`: a numbered list, or `### N. Title` subsections when steps are long. Each ends on a completion criterion.
4. `## Output` when the result has a fixed shape.
5. `## Gotchas` last.

Reference material (checklists, rules, platform notes) goes between Output and Gotchas under its own heading.

## 3. Writing principles

### The description is a pointer

The wording of the description, not the body, decides how reliably the skill is reached.

- Front-load the trigger.
- One trigger per distinct case; synonyms for the same case are noise.
- Drop identity the body already carries.

### Two budgets

- **Context load**: always-loaded text (CLAUDE.md lines, descriptions) costs tokens and attention every turn.
- **Cognitive load**: how much _you_ must remember about which skill exists. Spend it where human judgement matters.

### Information hierarchy

1. **In-file steps**: what the agent does, in order.
2. **In-file reference**: rules and checklists consulted on demand.
3. **Disclosed reference**: separate files, loaded only when a pointer fires.

Inline what every branch needs; push behind a pointer what only some branches need. Keep a concept's definition, rules and caveats under one heading (co-location).

### Every step ends on a completion criterion

- _Clear_: the agent can tell done from not-done.
- _Demanding_: it forces real work. "Every modified module accounted for" beats "produce a change list".

Vague criteria cause premature completion. Sharpen the bound first; split a sequence only if later steps keep tempting the agent to rush.

### Leading words

A compact term from the model's pretraining (_tracer bullet_, _red_, _tight loop_, _vertical slice_) anchors behavior in one token. Pick a few, use them consistently, and replace multi-sentence restatements with them.

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

- [ ] `name` equals the folder; frontmatter fields in the fixed order
- [ ] Model-invoked: description starts with "Use when …" and names distinct triggers. User-invoked: one-line summary, no triggers
- [ ] English only
- [ ] `allowed-tools` matches the steps; nothing missing, nothing extra
- [ ] Side-effect skills have `disable-model-invocation: true`
- [ ] Every step has a checkable completion criterion
- [ ] No negations where a positive instruction works
- [ ] No no-ops, no restated config
- [ ] Gotchas section present
- [ ] Never stages, commits or pushes unless that is the skill's job

---

For workflow habits (planning, verification, hooks, context, git), see [best-practices.md](best-practices.md).
