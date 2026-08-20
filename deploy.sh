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
deploy "dotfiles/.claude/commands/"     "$HOME/.claude/commands/"

echo ""
echo "Done. Reload zsh: source ~/.zshrc"
