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
ZSH_THEME="robbyrussell"

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
alias ll="ls -al"
alias config="vi ~/.zshrc"
alias reload="source ~/.zshrc"
alias vim="vi"

# -------
# Claude Claude
# -------
alias cc="claude"
alias ccp="claude --permission-mode plan"

# -------
# GIT ALIASES
# -------
alias g="git"
alias gm="git checkout main"
alias gs="git status"
alias gb="git branch"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gm="git checkout main"
alias ga="git add"
alias gaa="git add ."
alias gp="git push"
alias gpl="git pull"