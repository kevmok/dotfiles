#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BREWFILE="$DOTFILES_DIR/Brewfile"

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

info() { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[x]${NC} $1"; }

usage() {
    cat <<'EOF'
Usage: ./setup-dev-env.sh [step]

Steps:
  prereqs   Install or verify Xcode Command Line Tools and Homebrew
  packages  Install or update baseline Homebrew packages from Brewfile
  dotfiles  Run dotfiles symlink bootstrap
  post      Finish local setup reminders (secrets, gh auth, ssh)

Examples:
  ./setup-dev-env.sh           # run all steps in order
  ./setup-dev-env.sh packages  # rerun only package installation
  ./setup-dev-env.sh dotfiles  # rerun only symlink bootstrap
EOF
}

has_cmd() {
    command -v "$1" >/dev/null 2>&1
}

ensure_xcode_clt() {
    if xcode-select -p >/dev/null 2>&1; then
        info "Xcode Command Line Tools already installed"
        return 0
    fi

    warn "Xcode Command Line Tools not found"
    warn "Run: xcode-select --install"
    return 1
}

ensure_homebrew() {
    if has_cmd brew; then
        info "Homebrew already installed"
        return 0
    fi

    warn "Homebrew not found"
    warn "Install it with: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    return 1
}

run_prereqs() {
    info "Step 1/4: verifying developer prerequisites"
    local ok=0
    ensure_xcode_clt || ok=1
    ensure_homebrew || ok=1

    if [[ $ok -ne 0 ]]; then
        error "Install missing prerequisites, then rerun ./setup-dev-env.sh prereqs"
        exit 1
    fi
}

run_packages() {
    info "Step 2/4: installing baseline Homebrew packages"

    if ! has_cmd brew; then
        error "Homebrew is required before running the packages step"
        exit 1
    fi

    if [[ ! -f "$BREWFILE" ]]; then
        error "Brewfile not found at $BREWFILE"
        exit 1
    fi

    brew bundle --file "$BREWFILE"
}

run_dotfiles() {
    info "Step 3/4: linking dotfiles"
    "$DOTFILES_DIR/install.sh"
}

run_post() {
    info "Step 4/4: post-setup checklist"

    if [[ -f "$DOTFILES_DIR/secrets.sh" ]]; then
        info "secrets.sh already exists"
    else
        warn "Create and fill secrets: cp "$DOTFILES_DIR/secrets.example" "$DOTFILES_DIR/secrets.sh" && \$EDITOR "$DOTFILES_DIR/secrets.sh""
    fi

    if has_cmd gh; then
        info "Verify GitHub CLI auth with: gh auth status"
    else
        warn "gh is not installed yet; rerun packages after Homebrew is ready"
    fi

    warn "If this is a new Mac, set up SSH for GitHub:"
    warn "  ssh-keygen -t ed25519 -C \"mok.kevin11@gmail.com\""
    warn "  /usr/bin/ssh-add --apple-use-keychain ~/.ssh/id_ed25519"
    warn "  gh ssh-key add ~/.ssh/id_ed25519.pub --type authentication --title \"MacBook\""
    warn "  ssh -T git@github.com"
    warn "Reload shell when done: source ~/.zshrc"
}

run_all() {
    run_prereqs
    run_packages
    run_dotfiles
    run_post
    info "Developer environment setup complete"
}

main() {
    local step="${1:-all}"

    case "$step" in
        all)
            run_all
            ;;
        prereqs)
            run_prereqs
            ;;
        packages)
            run_packages
            ;;
        dotfiles)
            run_dotfiles
            ;;
        post)
            run_post
            ;;
        -h|--help|help)
            usage
            ;;
        *)
            error "Unknown step: $step"
            usage
            exit 1
            ;;
    esac
}

main "$@"
