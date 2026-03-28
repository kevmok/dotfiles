# dotfiles

Personal macOS dotfiles and developer environment bootstrap.

This repo is designed to be **rerunnable** on a new machine: you can run the top-level setup script again whenever the baseline changes.

## Quick start

```bash
git clone <repo-url> ~/dotfiles
cd ~/dotfiles
./setup-dev-env.sh
$EDITOR secrets.sh
source ~/.zshrc
```

## What to run

- `./setup-dev-env.sh` — full developer environment setup
- `./setup-dev-env.sh packages` — install or update Homebrew baseline packages from `Brewfile`
- `./setup-dev-env.sh dotfiles` — rerun dotfile symlink/bootstrap only
- `./setup-dev-env.sh post` — install Bun/OpenCode if missing and rerun final setup tasks
- `./install.sh` — lower-level symlink/bootstrap script only

## Setup flow

`./setup-dev-env.sh` runs these steps in order:

1. `prereqs` — verify Xcode Command Line Tools and Homebrew
2. `packages` — install baseline packages from `Brewfile`
3. `dotfiles` — link repo-managed config files into `$HOME` / `~/.config`
4. `post` — install Bun/OpenCode if missing, then remind you to finish secrets, GitHub CLI auth, and SSH setup

Run `./setup-dev-env.sh --help` to see the step-level usage.

## Repo guide

- `AGENTS.md` — agent-focused repo knowledge and new-machine setup notes
- `Brewfile` — lean baseline Homebrew packages
- `setup-dev-env.sh` — top-level rerunnable machine setup
- `install.sh` — idempotent symlink/bootstrap step
- `zsh/`, `git/`, `starship/`, `ghostty/`, `atuin/`, `opencode/`, `zed/` — managed config directories

## Notes

- `secrets.sh` is local and gitignored; fill it from `secrets.example`
- Bun and OpenCode are installed by `./setup-dev-env.sh` if they are missing
- OpenCode config is included in this repo, so a new machine will inherit your current OpenCode setup
- Machine-specific shell extras should live outside the baseline flow when possible
