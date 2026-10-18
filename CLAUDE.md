# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

**toolbox** is a personal developer toolkit — dotfiles, app configs, onboarding docs, and Claude Code skills. There is no build pipeline or test suite; changes here are config/doc edits deployed manually to the host machine.

## Repository Structure

```
configs/       App-specific configs (Ghostty, Starship)
docs/          mac-setup/ (Mac web dev setup guides), claude-code/ (skills, best practices)
dotfiles/      Shell configs and Claude Code settings and skills
```

## Deploying Dotfiles

Files under `dotfiles/` are the source of truth and must be copied manually to their target locations:

| Source                           | Target                     |
| -------------------------------- | -------------------------- |
| `dotfiles/.zshrc`                | `~/.zshrc`                 |
| `dotfiles/.vimrc`                | `~/.vimrc`                 |
| `dotfiles/.claude/settings.json` | `~/.claude/settings.json`  |
| `dotfiles/.claude/skills/*/*/`   | `~/.claude/skills/<name>/` |
| `configs/ghostty/config`         | `~/.config/ghostty/config` |
| `configs/starship/starship.toml` | `~/.config/starship.toml`  |

After editing `.zshrc`, reload with:

```bash
source ~/.zshrc
```

## Claude Code Skills

Every slash command is a skill: `dotfiles/.claude/skills/<bucket>/<name>/SKILL.md`. Buckets (`dev`, `git`, `misc`, `productivity`) only organise the repo; `deploy.sh` copies each skill flat to `~/.claude/skills/<name>/`, so the slash command is `/<name>`.

### User-invoked

Reachable only when typed (`disable-model-invocation: true`).

| Skill            | Description                                                            |
| ---------------- | ---------------------------------------------------------------------- |
| `/commit`        | Write a Conventional Commit message from the staged diff and commit it |
| `/pr`            | Write a PR title and body from the branch diff                         |
| `/review-pr`     | Review a teammate PR/MR, draft inline comments, post as pending review |
| `/implement`     | Execute a saved feature plan phase by phase, test-first                |
| `/code-cleanup`  | Refactor and tidy code without changing behavior                       |
| `/code-optimize` | Find measured bottlenecks and optimize what is worth it                |
| `/lint`          | Run ESLint with fixes, then Prettier and tsc                           |
| `/grill-me`      | Stress-test a plan, one question at a time                             |
| `/handoff`       | Write a handoff note for a fresh session                               |
| `/wait-what`     | Re-explain the last message in plain language                          |

### Model-invoked

Typed or picked by Claude from the description.

| Skill            | Description                                                        |
| ---------------- | ------------------------------------------------------------------ |
| `/feature-plan`  | Plan a feature with design, test seams, phased tasks and DB choice |
| `/tdd`           | Build test-first, one vertical slice at a time                     |
| `/code-reviewer` | Review code for standards, spec and security; merge verdict        |
| `/code-explain`  | Explain code, scaled to its complexity                             |
| `/debug`         | Build a red/green feedback loop, then find the root cause          |
| `/chat-message`  | Write or rewrite a Slack/Teams/Discord message in a human voice    |

### Skill conventions

All skills share one shape (details in `docs/claude-code/writing-skills.md`):

- English only. Output language follows the user's input.
- Frontmatter order: `name`, `description`, `argument-hint`, `model`, `allowed-tools`, `disable-model-invocation`.
- User-invoked skills: one-line human-facing `description`, no trigger list. Model-invoked skills: `description` starts with "Use when" and names the distinct triggers.
- Body: one-line job with `$ARGUMENTS`, the no-argument behavior, `## Steps` (each ends on a completion criterion), `## Output` if the result has a fixed shape, `## Gotchas` last.
- One skill calls another through the instruction `Call the Skill tool with "<name>"`, and only model-invoked skills can be called that way.
- Skills reference `$ARGUMENTS` for inline targets and pull stack and conventions from the project's own `CLAUDE.md`.

## Tech Stack (implied by toolbox setup)

- **Runtime**: Node.js via `nvm`, Java via `SDKMAN`
- **Backend**: NestJS (referenced in code-reviewer conventions)
- **Language**: TypeScript strict — no `any`, Zod validation on all DTOs
- **Shell**: zsh + oh-my-zsh (`robbyrussell` theme, plugins: git, zsh-autosuggestions, zsh-syntax-highlighting)
- **Terminal**: Ghostty

## Conventions

- Conventional Commits (`feat`, `fix`, `refactor`, `chore`, `docs`, `test`, `style`, `perf`)
- The code reviewer checks: correctness, security, TypeScript strictness, NestJS module/DI structure, guard/pipe/interceptor order, error handling, and performance (N+1, re-renders)
- Feature plans always call out which DB (MongoDB vs PostgreSQL) and why
