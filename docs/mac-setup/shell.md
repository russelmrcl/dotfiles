# Shell (zsh, oh-my-zsh)

zsh is the macOS default. oh-my-zsh adds plugins and aliases; it is optional.

## Install oh-my-zsh

Keep your `.zshrc` and stay in the current shell:

```bash
RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Plugins

Clone plugins **into oh-my-zsh**. `brew install` puts them elsewhere, and `plugins=(…)` would not find them.

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Enable them in `~/.zshrc`:

```zsh
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```

## Ready-made config

`dotfiles/.zshrc` in this repo contains the full setup (Homebrew, nvm, SDKMAN, aliases, Starship). Copy it, then adjust the user-specific paths (Docker completions, JetBrains Toolbox):

```bash
cp dotfiles/.zshrc ~/.zshrc
source ~/.zshrc
```

## Verify

- Typing a previous command shows a grey autosuggestion
- Valid commands turn green, invalid ones red
