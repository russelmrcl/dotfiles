# Deploy

Copy configs from this repo to your Mac. Run from the repo root.

---

## All at once

```bash
bash deploy.sh
```

---

## Individual

### Starship

```bash
cp configs/starship/starship.toml ~/.config/starship.toml
```

### Ghostty

```bash
cp configs/ghostty/config ~/.config/ghostty/config
```

### zsh

```bash
cp dotfiles/.zshrc ~/.zshrc && source ~/.zshrc
```

### Vim

```bash
cp dotfiles/.vimrc ~/.vimrc
```

### Claude Code

```bash
cp dotfiles/.claude/settings.json ~/.claude/settings.json
for d in dotfiles/.claude/skills/*/; do
  n="$(basename "$d")"
  mkdir -p ~/.claude/skills
  rm -r ~/.claude/skills/"$n" 2>/dev/null
  cp -R "$d" ~/.claude/skills/"$n"
done
```
