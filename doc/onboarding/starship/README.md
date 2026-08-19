# Starship Prompt

A fast, minimal, cross-shell prompt.

---

## 1. Install

```bash
brew install starship
```

---

## 2. Enable in zsh

Add to the end of `~/.zshrc`:

```bash
eval "$(starship init zsh)"
```

Then reload:

```bash
source ~/.zshrc
```

---

## 3. Apply config

Copy the config from this repo:

```bash
cp configs/starship/starship.toml ~/.config/starship.toml
```

---

## 4. Install Nerd Font

The config uses icons from **Hack Nerd Font**. Install it:

```bash
brew install --cask font-hack-nerd-font
```

Then set it as the font in your terminal (Ghostty: `font-family = "Hack Nerd Font"`).

---

## What the config shows

```
~/projects/my-repo  main ✗  v20.11.0  500ms  ❯
```

| Segment | Shows |
|---|---|
| `directory` | Full path, never truncated |
| `git_branch` | Current branch with  icon |
| `git_status` | Staged, modified, untracked, ahead/behind |
| `nodejs` | Node version (when in a Node project) |
| `package` | Package version from `package.json` |
| `cmd_duration` | Execution time for commands over 500ms |
| `character` | `❯` on success, `✗` on error |
