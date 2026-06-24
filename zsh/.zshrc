# Load homebrew env
eval "$(brew shellenv)"


# ══════════════════════════════════════════════════════════════════════════════
# Antidote Plugin Manager
# ══════════════════════════════════════════════════════════════════════════════
source ~/.antidote/antidote.zsh
antidote load ~/dotfiles/zsh/zsh_plugins.txt

# ------------------------------
# Initialize completions (required for fzf-tab)
# ------------------------------
autoload -U compinit
compinit -C

# ══════════════════════════════════════════════════════════════════════════════
# SECRETS
# ══════════════════════════════════════════════════════════════════════════════
[[ -f "$HOME/dotfiles/secrets.sh" ]] && source "$HOME/dotfiles/secrets.sh"

# ══════════════════════════════════════════════════════════════════════════════
# ZSH OPTIONS
# ══════════════════════════════════════════════════════════════════════════════
setopt AUTO_CD              # cd by typing directory name
setopt CORRECT              # spell correction for commands
setopt HIST_IGNORE_DUPS     # no duplicate entries in history
setopt HIST_IGNORE_SPACE    # don't save commands starting with space
setopt SHARE_HISTORY        # share history between sessions
setopt EXTENDED_HISTORY     # add timestamps to history

HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000

# ══════════════════════════════════════════════════════════════════════════════
# PATH
# ══════════════════════════════════════════════════════════════════════════════
typeset -U path  # Remove duplicates from PATH

path=(
    "/opt/homebrew/bin"
    "$HOME/.pyenv/bin"
    "$HOME/.bun/bin"
    "$HOME/Library/pnpm"
    "$HOME/.opencode/bin"
    "$HOME/dotfiles/claude"
    $path
)
export PATH

# ══════════════════════════════════════════════════════════════════════════════
# ENVIRONMENT VARIABLES
# ══════════════════════════════════════════════════════════════════════════════
export PYENV_ROOT="$HOME/.pyenv"
export BUN_INSTALL="$HOME/.bun"
export PNPM_HOME="$HOME/Library/pnpm"

# ══════════════════════════════════════════════════════════════════════════════
# ALIASES - Navigation
# ══════════════════════════════════════════════════════════════════════════════
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias f='open -a Finder ./'

# ══════════════════════════════════════════════════════════════════════════════
# ALIASES - Git
# ══════════════════════════════════════════════════════════════════════════════
alias g='git'
alias gits='git status'
alias gita='git add'
alias gitaa='git add --all'
alias gitr='git pull --rebase origin main'
alias gitd='git diff'
alias gitds='git diff --staged'
alias lg='lazygit'
alias gcae='git commit -a --amend'
alias gcaef='git commit -a --amend --no-edit --no-verify'
alias gce='git commit --amend --no-edit'
alias gpf='git push -f'
alias gitstash='git stash'
alias gitstashpop='git stash pop'

# ══════════════════════════════════════════════════════════════════════════════
# ALIASES - Tools
# ══════════════════════════════════════════════════════════════════════════════
alias sourceme="source $HOME/dotfiles/zsh/.zshrc"
alias ozsh="zed $HOME/dotfiles/zsh/.zshrc"
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"


# ══════════════════════════════════════════════════════════════════════════════
# FUNCTIONS - Git Workflow
# ══════════════════════════════════════════════════════════════════════════════
gum() { git switch main && git fetch && git pull; }
gnew() { git switch main && git switch --create "$1" && glog; }
gbnew() { git switch --create "$1" && glog; }
gdel() { git branch -D "$1"; }
cmit() { git add . && git commit -m "$1" && git push; }
glog() { git log --pretty='%C(yellow)%h %C(cyan)%cd %Cblue%aN%C(auto)%d %Creset%s' --graph --date=relative --date-order; }
prfix() { git add . && git commit -a --amend --no-edit --no-verify && git push; }
gclean() { git clean -f -d; }
gsoft() { git reset --soft HEAD~1; }
ghard() { git reset --hard HEAD; }
gitcleanup() { git switch main && git branch | grep -vE '^\*|main|master|dev' | xargs git branch -D; }

# ══════════════════════════════════════════════════════════════════════════════
# TOOL INITIALIZATIONS
# ══════════════════════════════════════════════════════════════════════════════
# Pyenv
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# Bun completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Jujutsu completions
source <(COMPLETE=zsh jj 2>/dev/null) || true

source <(fzf --zsh)           # fzf key bindings (Ctrl+R etc.)
eval "$(zoxide init zsh)"     # zoxide
eval "$(atuin init zsh)"      # Atuin history
eval "$(starship init zsh)"   # Starship prompt

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# opencode
export PATH=/Users/kevin/.opencode/bin:$PATH

. "$HOME/.local/bin/env"

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# >>> grok installer >>>
export PATH="$HOME/.grok/bin:$PATH"
fpath=(~/.grok/completions/zsh $fpath)
autoload -Uz compinit && compinit -C
# <<< grok installer <<<

# >>> railway initialize >>>
source "$HOME/.railway/env"
# <<< railway initialize <<<
