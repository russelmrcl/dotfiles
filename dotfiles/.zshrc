# -------
# Homebrew
# -------
eval "$(/opt/homebrew/bin/brew shellenv zsh)"

# -------
# fpath
# -------
fpath+=(/opt/homebrew/share/zsh/site-functions)
fpath+=(/Users/russelmarcelo/.docker/completions)

# -------
# tools
# -------
export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
export SDKMAN_DIR="$HOME/.sdkman"
export PATH="$HOME/.local/bin:$PATH"

# -------
# oh-my-zsh
# -------
ZSH_THEME=""

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# -------
# nvm
# -------
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# -------
# sdkman
# -------
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# -------
# JetBrains Toolbox
# -------
export PATH="$PATH:/Users/russelmarcelo/Library/Application Support/JetBrains/Toolbox/scripts"

# -------
# Aliases
# -------
alias c="clear"
alias ..="cd .."
alias config="vi ~/.zshrc"
alias reload="source ~/.zshrc"
alias vim="vi"

# -------
# npm
# -------
alias dev="npm run dev"
alias i="npm install"

# -------
# Claude Code
# -------
alias cc="claude"
alias ccr="claude --resume"

# -------
# Apps
# -------
alias yy="yazi"
alias ll="lazygit"

# -------
# Starship
# -------
eval "$(starship init zsh)"