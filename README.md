# dotfiles

Personal developer toolkit — dotfiles, app configs, and onboarding docs for Mac web dev setup.

## Structure

```
configs/       App configs (Ghostty, Starship)
docs/          Onboarding guides
dotfiles/      Shell configs and Claude Code commands
work/          Work-specific dotfiles and commands
```

## Docs

- [Mac Setup](docs/setup.md) — full Mac web dev onboarding
- [Git & SSH](docs/git.md) — SSH keys for GitHub & GitLab
- [Starship](docs/starship.md) — prompt setup
- [Apps → Work](docs/apps/work.md) — work macbook app list
- [Apps → Personal](docs/apps/personal.md) — personal macbook app list

## Deploy

| Source | Target |
|---|---|
| `dotfiles/.zshrc` | `~/.zshrc` |
| `dotfiles/.vimrc` | `~/.vimrc` |
| `dotfiles/.claude/settings.json` | `~/.claude/settings.json` |
| `dotfiles/.claude/commands/` | `~/.claude/commands/` |
| `configs/ghostty/config` | `~/.config/ghostty/config` |
| `configs/starship/starship.toml` | `~/.config/starship.toml` |
