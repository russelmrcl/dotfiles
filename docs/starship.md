# Starship Prompt

A fast, minimal, cross-shell prompt.

---

## 1. Install

```bash
brew install starship
```

---

## 2. Nerd Font

The config uses icons from **Hack Nerd Font**. Install it first:

```bash
brew install --cask font-hack-nerd-font
```

Then set it as the font in your terminal (Ghostty: `font-family = "Hack Nerd Font"`).

---

## 3. Apply config

```bash
cp configs/starship/starship.toml ~/.config/starship.toml
```

---

## 4. Enable in zsh

Add to the end of `~/.zshrc`:

```bash
eval "$(starship init zsh)"
```

Then reload:

```bash
source ~/.zshrc
```

---

## What the prompt shows

```
~/projects/my-repo on  main !
❯
```

| Segment | Shows |
|---|---|
| `directory` | Path, truncated to 3 levels |
| `git_branch` | Current branch (only in git repos) |
| `git_status` | `!` modified · `+` staged · `?` untracked · `↑↓` ahead/behind |
| `nodejs` | Node version (when in a Node project) |
| `package` | Version from `package.json` |
| `cmd_duration` | Execution time for commands over 2s |
| `character` | `❯` green on success · `❯` red on error |
