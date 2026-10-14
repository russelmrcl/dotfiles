# Mac Web Dev Setup

Onboarding guide for a fresh Mac. Follow the steps **in order**; each one builds on the previous.

| # | Step | Why this position |
|---|---|---|
| 0 | Command Line Tools | Homebrew and Git need them |
| 1 | Homebrew | Everything else installs through it |
| 2 | Git & SSH | Needed to clone this repo |
| 3 | Clone this repo | Source of all configs |
| 4 | Apps | Terminal, font and tools |
| 5 | Shell | oh-my-zsh + plugins |
| 6 | Node & Java | Runtimes |
| 7 | Claude Code | Needs Node and the shell PATH |
| 8 | Deploy configs | After oh-my-zsh, so it isn't overwritten |
| 9 | Verify | Checklist |

---

## 0. Command Line Tools

```bash
xcode-select --install
```

Wait for the installer to finish before continuing.

---

## 1. Homebrew

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

## 2. Git & SSH

→ [Git & SSH setup](./git.md)

Do not skip the **identity** step (`user.name`, `user.email`). Check:

```bash
git config --global user.name
git config --global user.email
ssh -T git@github.com
```

---

## 3. Clone this repo

```bash
mkdir -p ~/Developer/git && cd ~/Developer/git
git clone git@github.com:<your-user>/dotfiles.git
cd dotfiles
```

All following commands that use relative paths (`configs/…`, `dotfiles/…`) are run from this directory.

---

## 4. Apps

→ [Apps](./apps.md)

Remove what you don't need, then run the **Install** blocks. They include Ghostty, Starship, Hack Nerd Font, Lazygit and Yazi.

Afterwards, open Ghostty and use it for all remaining steps. Set the font in Ghostty to `Hack Nerd Font` (already in `configs/ghostty/config`, applied in step 8).

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

The plugin list itself (`git zsh-autosuggestions zsh-syntax-highlighting`) is already in `dotfiles/.zshrc`.

Prompt: → [Starship setup](./starship.md) (binary and font are installed in step 4; config is applied in step 8).

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

## 7. Claude Code

```bash
curl -fsSL https://claude.ai/install.sh | bash
```

The binary lands in `~/.local/bin`, which `.zshrc` already adds to `PATH`. Log in once:

```bash
claude
```

---

## 8. Deploy configs

From the repo root:

```bash
bash deploy.sh
```

This copies `.zshrc`, `.vimrc`, Ghostty, Starship and the Claude Code settings/commands (see [DEPLOY.md](../DEPLOY.md) for individual targets). Then open a **new** Ghostty window or run:

```bash
source ~/.zshrc
```

> `dotfiles/.zshrc` contains paths for the user `russelmarcelo` (Docker completions, JetBrains Toolbox). On another user account, adjust them after deploying.

---

## 9. Verify

```bash
brew --version
git config --global user.name && git config --global user.email
ssh -T git@github.com
node -v && npm -v
java -version
claude --version
echo $STARSHIP_SHELL    # prints "zsh" when Starship is active
```

Checklist:

- [ ] Prompt shows icons (Hack Nerd Font active in Ghostty)
- [ ] Typing a previous command shows a grey autosuggestion
- [ ] Valid commands turn green, invalid ones red (syntax highlighting)
- [ ] `ll` opens Lazygit, `yy` opens Yazi, `cc` starts Claude Code
- [ ] A test commit in any repo shows your name and email: `git log -1 --format='%an <%ae>'`

---

## Optional

- **JetBrains Toolbox**: installed via the apps list; sign in and install IDEs from there.
- **Docker Desktop**: start it once to finish setup; it adds its completions to `~/.docker`.
- **Raycast / Rectangle**: grant Accessibility permission in *System Settings → Privacy & Security*.
