# Mac Web Dev Setup

Onboarding guide for a fresh Mac. Just follow the steps **in order**; no repo needed.

---

## 1. Command Line Tools

```bash
xcode-select --install
```

Wait for the installer to finish before continuing.

---

## 2. Homebrew

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

Make `brew` available in the current shell (Apple Silicon):

```bash
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
```

Check:

```bash
brew --version
```

---

## 3. Git & SSH

→ [Git & SSH setup](./git.md)

Do not skip the **identity** step (`user.name`, `user.email`). Check:

```bash
git config --global user.name
git config --global user.email
ssh -T git@github.com
```

---

## 4. Apps

→ [Apps](./apps.md)

Remove what you don't need, then run the **Install** blocks. They include Ghostty, Starship, Hack Nerd Font, Lazygit and Yazi.

Then open **Ghostty** and use it for all remaining steps. Set the font:

```bash
mkdir -p ~/.config/ghostty
echo 'font-family = "Hack Nerd Font"' >> ~/.config/ghostty/config
```

---

## 5. Shell: oh-my-zsh

Install without replacing `.zshrc` and without opening a new shell mid-script:

```bash
RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Install the plugins **into oh-my-zsh** (`brew install` puts them elsewhere, and `plugins=(…)` in `.zshrc` would not find them):

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting \
  ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

---

## 6. Node.js & Java

**Node.js via nvm**

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```

Load nvm in the current shell, then install:

```bash
export NVM_DIR="$HOME/.nvm" && . "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default 'lts/*'
```

**Java via SDKMAN**

```bash
curl -s "https://get.sdkman.io" | bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk install java
```

---

## 7. `.zshrc`

Do this **after** nvm and SDKMAN: their installers append to `~/.zshrc`, and this replaces the file with a clean version.

```bash
cat > ~/.zshrc <<'EOF'
# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv zsh)"
fpath+=(/opt/homebrew/share/zsh/site-functions)

# Tools
export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
export SDKMAN_DIR="$HOME/.sdkman"
export PATH="$HOME/.local/bin:$PATH"

# oh-my-zsh (prompt comes from Starship)
ZSH_THEME=""
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# SDKMAN
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# JetBrains Toolbox
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"

# Aliases
alias c="clear"
alias ..="cd .."
alias config="vi ~/.zshrc"
alias reload="source ~/.zshrc"
alias vim="vi"
alias dev="npm run dev"
alias i="npm install"
alias cc="claude"
alias ccr="claude --resume"
alias yy="yazi"
alias ll="lazygit"

# Starship (keep last)
eval "$(starship init zsh)"
EOF

source ~/.zshrc
```

Optional prompt config (icons, git status, Node version): → [Starship setup](./starship.md)

---

## 8. Claude Code

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

The binary lands in `~/.local/bin`, already on `PATH` from step 7. Log in once:

```bash
claude
```

---

## 9. Verify

```bash
brew --version
git config --global user.name && git config --global user.email
ssh -T git@github.com
node -v && npm -v
java -version
claude --version
```

Checklist:

- [ ] Prompt shows icons (Hack Nerd Font active in Ghostty)
- [ ] Typing a previous command shows a grey autosuggestion
- [ ] Valid commands turn green, invalid ones red (syntax highlighting)
- [ ] `ll` opens Lazygit, `yy` opens Yazi, `cc` starts Claude Code
- [ ] A test commit shows your name and email: `git log -1 --format='%an <%ae>'`

---

## Optional

- **JetBrains Toolbox**: sign in and install IDEs from there.
- **Docker Desktop**: start it once to finish setup.
- **Raycast / Rectangle**: grant Accessibility permission in *System Settings → Privacy & Security*.
