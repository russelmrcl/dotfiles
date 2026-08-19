#  Mac Web Dev Setup
 
A quick onboarding guide to get your Mac ready for web development.
 
---
 
## 1. Homebrew
 
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
 
Add to your shell profile after install:
 
```bash
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
```
 
---
 
## 2. Terminal & Shell
 
**Ghostty** (recommended terminal):
 
```bash
brew install --cask ghostty
```
 
**oh-my-zsh:**
 
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
 
Useful plugins to add to `~/.zshrc`:
 
```zsh
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
```
 
Install the plugins:
 
```bash
brew install zsh-autosuggestions zsh-syntax-highlighting
```
 
---
 
## 3. Git & GitHub / GitLab

[git setup](../onboarding/git/README.md)
 
---
 
## 4. Node.js (via nvm)
 
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
```
 
```bash
nvm install --lts
nvm use --lts
```
 
---
 
## 5. Java (via SDKMAN)
 
```bash
curl -s "https://get.sdkman.io" | bash
sdk install java
```
 
---

## 6. JetBrains Toolbox
 
```bash
brew install --cask jetbrains-toolbox
```
 
---

## 7. `.zshrc`

[.zshrc](../../dotfiles/.zshrc)

