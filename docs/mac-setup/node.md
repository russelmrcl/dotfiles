# Node.js (nvm)

Node version manager: install several Node versions and switch per project.

## Install

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
```

Load nvm in the current shell, then install the LTS version:

```bash
export NVM_DIR="$HOME/.nvm" && . "$NVM_DIR/nvm.sh"
nvm install --lts
nvm alias default 'lts/*'
```

The installer adds the nvm loader to `~/.zshrc`. If you copied `dotfiles/.zshrc`, it is already there.

## Verify

```bash
node -v
npm -v
```

## Daily use

```bash
nvm ls                # installed versions
nvm use 20            # switch for this shell
nvm install --lts     # newest LTS
```

A project can pin its version in `.nvmrc`; run `nvm use` in that directory.
