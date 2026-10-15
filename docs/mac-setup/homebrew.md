# Homebrew

Package manager for macOS. Installs CLI tools (`brew install`) and apps (`brew install --cask`).

## Install

1. Command Line Tools (Git, compilers):

   ```bash
   xcode-select --install
   ```

   Wait until the installer finishes.

2. Homebrew:

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

3. Put `brew` on the PATH (Apple Silicon). Add to `~/.zshrc`:

   ```bash
   eval "$(/opt/homebrew/bin/brew shellenv zsh)"
   ```

   Then reload: `source ~/.zshrc`.

## Verify

```bash
brew --version
brew doctor
```

## Daily use

```bash
brew install <formula>          # CLI tool
brew install --cask <app>       # GUI app
brew upgrade                    # update everything
brew list                       # what is installed
```

## Troubleshooting

**`brew: command not found`**: step 3 is missing, or the shell wasn't reloaded.
