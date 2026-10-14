# New Mac Setup

A map, not a script. Do the **Base** steps in order, then pick only the guides for tools you actually use.

---

## Base (everyone, in this order)

| # | Guide | Why first |
|---|---|---|
| 1 | [Homebrew](guides/homebrew.md) | Command Line Tools + package manager; everything else installs through it |
| 2 | [Git & SSH](guides/git.md) | Identity and keys, needed to clone any repo |
| 3 | [Apps](apps.md) | One list of apps and CLI tools; delete what you don't use |

---

## Pick what you use

| I want… | Guide |
|---|---|
| A terminal | [Terminal (Ghostty)](guides/terminal.md) |
| A nicer shell (plugins, aliases) | [Shell (zsh, oh-my-zsh)](guides/shell.md) |
| A prompt | [Starship](guides/starship.md) |
| Node.js | [Node.js (nvm)](guides/node.md) |
| Java | [Java (SDKMAN)](guides/java.md) |
| Claude Code | [Claude Code](guides/claude-code.md) |

Each guide stands alone: what it does, how to install, how to verify.

---

## Configs from this repo

Ready-made configs live in the repo; copy only the ones you want:

| Config | Source | Target |
|---|---|---|
| zsh | `dotfiles/.zshrc` | `~/.zshrc` |
| vim | `dotfiles/.vimrc` | `~/.vimrc` |
| Ghostty | `configs/ghostty/config` | `~/.config/ghostty/config` |
| Starship | `configs/starship/starship.toml` | `~/.config/starship.toml` |
| Claude Code | `dotfiles/.claude/` | `~/.claude/` |

All at once: `bash deploy.sh` (see [DEPLOY.md](../DEPLOY.md)).

---

## Done when

```bash
brew --version
git config --global user.name && git config --global user.email
ssh -T git@github.com
```

All three print something sensible. Everything else is verified in its own guide.
