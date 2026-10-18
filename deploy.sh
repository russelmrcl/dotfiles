#!/bin/bash

# Deploy dotfiles and configs to this Mac.
# Run from the repo root: bash deploy.sh

set -e

REPO="$(cd "$(dirname "$0")" && pwd)"

deploy() {
  local src="$REPO/$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  cp -r "$src" "$dst"
  echo "✓ $1 → $dst"
}

echo "Deploying configs..."
echo ""

deploy "configs/starship/starship.toml"  "$HOME/.config/starship.toml"
deploy "configs/ghostty/config"          "$HOME/.config/ghostty/config"
deploy "dotfiles/.zshrc"                 "$HOME/.zshrc"
deploy "dotfiles/.vimrc"                 "$HOME/.vimrc"
deploy "dotfiles/.claude/settings.json" "$HOME/.claude/settings.json"

# Skills are bucketed in the repo (dev/git/misc/productivity) but Claude Code
# reads them flat from ~/.claude/skills/<name>/.
for skill_md in "$REPO"/dotfiles/.claude/skills/*/*/SKILL.md; do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  dst="$HOME/.claude/skills/$name"
  mkdir -p "$HOME/.claude/skills"
  if [ -d "$dst" ]; then rm -r "$dst"; fi
  cp -R "$src" "$dst"
  echo "✓ skill $name → $dst"
done

echo ""
echo "Done. Reload zsh: source ~/.zshrc"
