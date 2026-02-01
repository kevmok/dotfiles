# DOTFILES KNOWLEDGE BASE

**Owner:** Kevin Mok  
**Last Updated:** 2026-02-01

## OVERVIEW

Personal dotfiles for macOS. Manages shell, git, terminal, editor, and AI tool configurations. Uses `install.sh` for symlink management.

---

## STRUCTURE

```
dotfiles/
├── atuin/config.toml       # Shell history → ~/.config/atuin/config.toml
├── claude/statusline.sh    # Claude CLI status → ~/.local/bin/claude-statusline
├── ghostty/config          # Terminal → ~/.config/ghostty/config
├── git/
│   ├── .gitconfig          # Git config → ~/.gitconfig
│   └── .gitignore_global   # Global gitignore → ~/.gitignore_global
├── jj/config.toml          # Jujutsu VCS → ~/.config/jj/config.toml
├── opencode/
│   ├── opencode.json       # OpenCode config → ~/.config/opencode/opencode.json
│   ├── oh-my-opencode.json # Agent config → ~/.config/opencode/oh-my-opencode.json
│   ├── agent/*.md          # Custom agents → ~/.config/opencode/agent/
│   ├── commands/*.md       # Custom commands → ~/.config/opencode/command/
│   └── skills/*/           # Custom skills → ~/.config/opencode/skills/
├── starship/starship.toml  # Prompt → ~/.config/starship.toml
├── zed/
│   ├── settings.json       # Editor settings → ~/.config/zed/settings.json
│   └── keymap.json         # Keybindings → ~/.config/zed/keymap.json
├── zsh/.zshrc              # Shell config → ~/.zshrc
├── install.sh              # Bootstrap script (idempotent)
├── secrets.example         # Template for API keys
└── secrets.sh              # GITIGNORED - actual secrets
```

---

## AI AGENT INSTRUCTIONS

### Adding a New Tool Configuration

1. Create a new directory: `mkdir <toolname>/`
2. Add config files to that directory
3. Update `install.sh` with new symlink(s):
   ```bash
   info "Setting up <toolname>..."
   link "$DOTFILES/<toolname>/config" "$HOME/.config/<toolname>/config"
   ```
4. Run `./install.sh` to test
5. Update this AGENTS.md file with the new tool

### Adding a New OpenCode Command

1. Create `opencode/commands/<command-name>.md`
2. Run `./install.sh` - it auto-symlinks all `.md` files in commands/
3. Command becomes available as `/<command-name>` in OpenCode

### Adding a New OpenCode Skill

1. Create directory: `opencode/skills/<skill-name>/`
2. Add `SKILL.md` with skill definition
3. Optionally add `references/` folder with supporting docs
4. Run `./install.sh` - it auto-symlinks skill directories

### Adding a New OpenCode Agent

1. Create `opencode/agent/<agent-name>.md`
2. Run `./install.sh` - it auto-symlinks all `.md` files in agent/

### Modifying Shell Config

- Edit `zsh/.zshrc`
- Aliases: Lines 55-90
- Functions: Lines 93-120  
- PATH: Lines 28-45
- After editing: `source ~/.zshrc` or use `sourceme` alias

### Adding Secrets/API Keys

1. Add template variable to `secrets.example`
2. Add actual value to `secrets.sh` (gitignored)
3. Source in `.zshrc`: Already handled via `source "$HOME/dotfiles/secrets.sh"`

---

## QUICK REFERENCE

| Task | Location |
|------|----------|
| Add shell alias | `zsh/.zshrc` |
| Add PATH entry | `zsh/.zshrc` (path array) |
| Add API key | `secrets.sh` |
| Git settings | `git/.gitconfig` |
| Starship prompt | `starship/starship.toml` |
| Terminal theme | `ghostty/config` |
| Editor settings | `zed/settings.json` |
| Editor keybinds | `zed/keymap.json` |
| Shell history | `atuin/config.toml` |
| OpenCode config | `opencode/opencode.json` |
| Add new tool | Create dir, update `install.sh` |

---

## TOOLS MANAGED

| Tool | Config | Target |
|------|--------|--------|
| Zsh | `zsh/.zshrc` | `~/.zshrc` |
| Git | `git/.gitconfig` | `~/.gitconfig` |
| Git (global ignore) | `git/.gitignore_global` | `~/.gitignore_global` |
| Starship | `starship/starship.toml` | `~/.config/starship.toml` |
| Ghostty | `ghostty/config` | `~/.config/ghostty/config` |
| Atuin | `atuin/config.toml` | `~/.config/atuin/config.toml` |
| Jujutsu | `jj/config.toml` | `~/.config/jj/config.toml` |
| Zed | `zed/*.json` | `~/.config/zed/*.json` |
| OpenCode | `opencode/*.json` | `~/.config/opencode/*.json` |
| OpenCode Commands | `opencode/commands/*.md` | `~/.config/opencode/command/*.md` |
| OpenCode Skills | `opencode/skills/*/` | `~/.config/opencode/skills/*/` |
| OpenCode Agents | `opencode/agent/*.md` | `~/.config/opencode/agent/*.md` |
| Claude CLI | `claude/statusline.sh` | `~/.local/bin/claude-statusline` |

---

## SHELL ALIASES & FUNCTIONS

```bash
# Navigation
..          # cd ..
ll          # ls -lah
f           # open Finder here

# Git
gits        # git status
gitaa       # git add --all
gitr        # git pull --rebase origin main
lg          # lazygit
cmit "msg"  # git add . && commit && push
glog        # pretty git log
gnew branch # create branch from main
prfix       # amend + force push

# Dotfiles
sourceme    # reload .zshrc
ozsh        # edit .zshrc in Zed
```

---

## CONVENTIONS

- **Directory = Tool**: Each subdirectory is named after the tool it configures
- **Symlinks via install.sh**: Run `./install.sh` to create all symlinks
- **Idempotent**: install.sh can be run multiple times safely
- **Backup**: Existing files are backed up to `~/.dotfiles-backup/` before symlinking
- **Secrets pattern**: `secrets.sh` is gitignored, template in `secrets.example`

---

## ANTI-PATTERNS

- NEVER commit `secrets.sh` or files matching `secrets*` (except `.example`)
- NEVER hardcode API keys in any config file
- NEVER edit files in `~/.config/` directly - edit in dotfiles/, run install.sh
- AVOID monolithic configs - prefer separate files per concern

---

## NEW MAC SETUP

```bash
# 1. Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# 2. Install dependencies
brew install git starship atuin pyenv bun lazygit jj ghostty
brew install --cask zed

# 3. Clone dotfiles
git clone <repo-url> ~/dotfiles

# 4. Run install script
cd ~/dotfiles && ./install.sh

# 5. Fill in secrets
cp secrets.example secrets.sh
$EDITOR secrets.sh

# 6. Reload shell
source ~/.zshrc
```

---

## TROUBLESHOOTING

| Issue | Solution |
|-------|----------|
| Symlink not working | Run `./install.sh` again |
| Changes not showing | Run `sourceme` or restart terminal |
| Permission denied | Check file permissions, may need `chmod +x` |
| Config not found | Verify target directory exists |
