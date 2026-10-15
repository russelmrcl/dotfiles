# Claude Code Best Practices

Habits and workflows that improve Claude Code output.
Sources: Matt Pocock's `skills` repo and `shanraisshan/claude-code-best-practice`.
For writing the skills themselves, see [writing-skills.md](writing-skills.md).

---

## Plan → approve → execute

1. Start in **plan mode**.
2. Give a minimal spec and let Claude **interview you** (`AskUserQuestion`) until ambiguity is gone.
3. Save the plan to a file, review it (second Claude as "staff engineer" or another model).
4. Execute in a **fresh session**, phase by phase.

## Plan in vertical slices

AI defaults to horizontal phases (DB → API → UI), which delays feedback. Cut **tracer bullets** that cross all layers, each phase with its own tests.

## Always give Claude a way to verify

Tests, `tsc`, lint, browser. Verification is the largest single lever on output quality. Make it a step, not a hope.

## Debug feedback-loop first

1. Build a fast, deterministic reproduction (the loop goes _red_).
2. Minimise it.
3. Form hypotheses; add tagged logs.
4. Fix, then confirm the loop goes green.

## Review on separate axes

- **Standards**, **Spec**, **Security**, reported separately.
- For larger or security-sensitive diffs: one subagent per axis, launched in a single message, reports not merged.
- A fresh context finds more than the author's context.

## Enforce with hooks, not prompts

Anything that must _always_ happen belongs in a hook:

| Hook          | Use                                                       |
| ------------- | --------------------------------------------------------- |
| `PostToolUse` | auto-format after edits                                   |
| `PreToolUse`  | block destructive commands (`git push --force`, `rm -rf`) |
| `Stop`        | nudge to run tests / verify before finishing              |

## Permissions

Use wildcard allowlists (`Bash(npm run *)`) instead of `--dangerously-skip-permissions`. `/less-permission-prompts` builds an allowlist from session history.

## Manage context

- Watch `/context`; stay below ~40%.
- `/rewind` instead of corrective follow-up prompts.
- Subagents for research and review so the main context stays clean.
- Keep `CLAUDE.md` under 200 lines; move detail into files behind pointers.
- `/handoff` before a new session.

## Git

- Small PRs (median ~120 lines), one feature each, squash-merge.
- Commit when a task completes.
- Never let automation stage, commit or push unless asked.

## Prompting

- "Grill me on these changes before the PR."
- After a mediocre fix: "Knowing everything you know now, scrap this and implement the elegant solution."
- For bugs: paste the error, say "fix", don't micromanage.
- Prototype beats PRD: build several cheap versions.
