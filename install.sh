#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

info() { echo -e "${GREEN}[+]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
error() { echo -e "${RED}[x]${NC} $1"; }

# Backup existing file if it's not already a symlink to dotfiles
backup_if_needed() {
    local target="$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        mkdir -p "$BACKUP_DIR"
        mv "$target" "$BACKUP_DIR/"
        warn "Backed up $(basename "$target") to $BACKUP_DIR"
    elif [[ -L "$target" ]]; then
        rm "$target"  # Remove old symlink
    fi
}

# Create symlink with parent directory creation
link() {
    local src="$1"
    local dest="$2"
    
    if [[ ! -e "$src" ]]; then
        error "Source not found: $src"
        return 1
    fi
    
    # Create parent directory if needed
    mkdir -p "$(dirname "$dest")"
    
    backup_if_needed "$dest"
    ln -sf "$src" "$dest"
    info "Linked $(basename "$src") → $dest"
}

echo "╔════════════════════════════════════╗"
echo "║     Dotfiles Installation          ║"
echo "╚════════════════════════════════════╝"
echo ""

# ─────────────────────────────────────────
# Shell
# ─────────────────────────────────────────
info "Setting up shell..."
link "$DOTFILES/zsh/.zshrc" "$HOME/.zshrc"

# ─────────────────────────────────────────
# Git
# ─────────────────────────────────────────
info "Setting up git..."
link "$DOTFILES/git/.gitconfig" "$HOME/.gitconfig"
link "$DOTFILES/git/.gitignore_global" "$HOME/.gitignore_global"

# ─────────────────────────────────────────
# Starship prompt
# ─────────────────────────────────────────
info "Setting up starship..."
link "$DOTFILES/starship/starship.toml" "$HOME/.config/starship.toml"

# ─────────────────────────────────────────
# Claude CLI (add to PATH via symlink)
# ─────────────────────────────────────────
info "Setting up claude scripts..."
mkdir -p "$HOME/.local/bin"
link "$DOTFILES/claude/statusline.sh" "$HOME/.local/bin/claude-statusline"

# ─────────────────────────────────────────
# Ghostty terminal
# ─────────────────────────────────────────
info "Setting up ghostty..."
link "$DOTFILES/ghostty/config" "$HOME/.config/ghostty/config"

# ─────────────────────────────────────────
# Atuin (shell history)
# ─────────────────────────────────────────
info "Setting up atuin..."
link "$DOTFILES/atuin/config.toml" "$HOME/.config/atuin/config.toml"

# ─────────────────────────────────────────
# Jujutsu (VCS)
# ─────────────────────────────────────────
info "Setting up jj..."
link "$DOTFILES/jj/config.toml" "$HOME/.config/jj/config.toml"

# ─────────────────────────────────────────
# Zed (editor)
# ─────────────────────────────────────────
info "Setting up zed..."
link "$DOTFILES/zed/settings.json" "$HOME/.config/zed/settings.json"
link "$DOTFILES/zed/keymap.json" "$HOME/.config/zed/keymap.json"

# ─────────────────────────────────────────
# OpenCode
# ─────────────────────────────────────────
info "Setting up opencode..."
link "$DOTFILES/opencode/opencode.json" "$HOME/.config/opencode/opencode.json"
link "$DOTFILES/opencode/oh-my-opencode.json" "$HOME/.config/opencode/oh-my-opencode.json"

# OpenCode commands
for cmd in "$DOTFILES/opencode/commands"/*.md; do
    [[ -f "$cmd" ]] && link "$cmd" "$HOME/.config/opencode/command/$(basename "$cmd")"
done

# OpenCode skills
for skill_dir in "$DOTFILES/opencode/skills"/*/; do
    [[ -d "$skill_dir" ]] && link "$skill_dir" "$HOME/.config/opencode/skills/$(basename "$skill_dir")"
done

# OpenCode agents
for agent in "$DOTFILES/opencode/agent"/*.md; do
    [[ -f "$agent" ]] && link "$agent" "$HOME/.config/opencode/agent/$(basename "$agent")"
done

# ─────────────────────────────────────────
# Secrets
# ─────────────────────────────────────────
if [[ ! -f "$DOTFILES/secrets.sh" ]]; then
    warn "Creating secrets.sh from template..."
    cp "$DOTFILES/secrets.example" "$DOTFILES/secrets.sh"
    warn "Edit $DOTFILES/secrets.sh to add your API keys"
fi

echo ""
echo "════════════════════════════════════════"
info "Done! Reload shell: source ~/.zshrc"
echo "════════════════════════════════════════"
