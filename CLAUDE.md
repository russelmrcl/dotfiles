# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Purpose

**toolbox** is a personal developer toolkit — dotfiles, app configs, onboarding docs, and Claude Code slash commands. There is no build pipeline or test suite; changes here are config/doc edits deployed manually to the host machine.

## Repository Structure

```
configs/       App-specific configs (Ghostty, Starship)
docs/          mac-setup/ (Mac web dev setup guides), claude-code/ (skills, best practices)
dotfiles/      Shell configs and Claude Code settings/commands
```

## Deploying Dotfiles

Files under `dotfiles/` are the source of truth and must be copied manually to their target locations:

| Source                           | Target                     |
| -------------------------------- | -------------------------- |
| `dotfiles/.zshrc`                | `~/.zshrc`                 |
| `dotfiles/.vimrc`                | `~/.vimrc`                 |
| `dotfiles/.claude/settings.json` | `~/.claude/settings.json`  |
| `dotfiles/.claude/commands/`     | `~/.claude/commands/`      |
| `configs/ghostty/config`         | `~/.config/ghostty/config` |
| `configs/starship/starship.toml` | `~/.config/starship.toml`  |

After editing `.zshrc`, reload with:

```bash
source ~/.zshrc
```

## Claude Code Slash Commands

Custom slash commands live in `dotfiles/.claude/commands/` and are available after deployment to `~/.claude/commands/`:

| Command                   | Description                                                              |
| ------------------------- | ------------------------------------------------------------------------ |
| `/git:commit`             | Generate a conventional commit message from staged diff                  |
| `/git:code-reviewer`      | Review code for bugs, security, TypeScript, and NestJS patterns          |
| `/dev:feature-plan`       | Plan a feature with technical design and phased tasks                    |
| `/misc:code-cleanup`      | Refactor and clean up code                                               |
| `/misc:code-explain`      | Explain complex code sections                                            |
| `/misc:code-optimize`     | Optimize for performance/memory                                          |
| `/misc:debug`             | Analyze errors and find root cause                                       |
| `/misc:lint`              | Run ESLint + Prettier                                                    |
| `/dev:implement`          | Execute a saved feature plan phase by phase, test-first                  |
| `/dev:tdd`                | Build test-first, one vertical slice at a time                           |
| `/git:pr`                 | Write a PR title and body from the branch diff                           |
| `/git:review-pr`          | Review a teammate's PR/MR, draft inline comments, post as pending review |
| `/productivity:grill-me`  | Interview me about a plan until it holds up                              |
| `/productivity:handoff`   | Write a handoff note for a fresh session                                 |
| `/productivity:wait-what` | Re-explain the last message simply (German)                              |

Commands reference `$ARGUMENTS` for inline targets and pull stack/conventions from the project's own `CLAUDE.md`.

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
