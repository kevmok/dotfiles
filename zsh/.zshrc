# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

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
    "$HOME/.local/bin"
    "/opt/homebrew/bin"
    "/opt/homebrew/opt/python@3.10/bin"
    "/opt/homebrew/opt/postgresql@15/bin"
    "$HOME/.pyenv/bin"
    "$HOME/.bun/bin"
    "$HOME/Library/pnpm"
    "$HOME/miniforge3/bin"
    "$HOME/.vscode-dotnet-sdk/.dotnet"
    "$HOME/.codeium/windsurf/bin"
    "$HOME/.opencode/bin"
    "$HOME/.antigravity/antigravity/bin"
    "$HOME/dotfiles/claude"
    "$(go env GOPATH 2>/dev/null)/bin"
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
alias tm='task-master'
alias brow='arch --x86_64 /usr/local/Homebrew/bin/brew'

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
# FUNCTIONS - Docker/AI Tools
# ══════════════════════════════════════════════════════════════════════════════
openhands() {
    docker run -it --rm --pull=always \
        -e SANDBOX_RUNTIME_CONTAINER_IMAGE=docker.all-hands.dev/all-hands-ai/runtime:0.20-nikolaik \
        -e LOG_ALL_EVENTS=true \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v ~/.openhands-state:/.openhands-state \
        -p 3000:3000 \
        --add-host host.docker.internal:host-gateway \
        --name openhands-app \
        docker.all-hands.dev/all-hands-ai/openhands:0.20
}

# ══════════════════════════════════════════════════════════════════════════════
# TOOL INITIALIZATIONS
# ══════════════════════════════════════════════════════════════════════════════
# Pyenv
if command -v pyenv &>/dev/null; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
fi

# Conda/Mamba
if [[ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]]; then
    source "$HOME/miniforge3/etc/profile.d/conda.sh"
fi
if [[ -f "$HOME/miniforge3/etc/profile.d/mamba.sh" ]]; then
    source "$HOME/miniforge3/etc/profile.d/mamba.sh"
fi

# Kubectl aliases
[[ -f ~/.kubectl_aliases ]] && source ~/.kubectl_aliases
kubectl() { echo "+ kubectl $@" >&2; command kubectl "$@"; }

# Bun completions
[[ -s "$HOME/.bun/_bun" ]] && source "$HOME/.bun/_bun"

# Jujutsu completions
source <(COMPLETE=zsh jj 2>/dev/null) || true

# Starship prompt
eval "$(starship init zsh)"

# Atuin shell history
eval "$(atuin init zsh)"

# Fig export (legacy)
[[ -f "$HOME/fig-export/dotfiles/dotfile.zsh" ]] && source "$HOME/fig-export/dotfiles/dotfile.zsh"

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

# bun completions
[ -s "/Users/kevin/.bun/_bun" ] && source "/Users/kevin/.bun/_bun"
