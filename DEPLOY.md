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
cp -r dotfiles/.claude/commands/ ~/.claude/commands/
```
