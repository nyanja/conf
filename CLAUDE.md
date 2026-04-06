# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Personal dotfiles for **Oleksandr Syletskyi** (nyancache). Config files are symlinked into `~` via `link.sh`.

## Symlink mapping (`link.sh`)

| Source | Target |
|--------|--------|
| `zshrc` | `~/.zshrc` |
| `gitconfig` | `~/.gitconfig` |
| `gitignore_global` | `~/.gitignore_global` |
| `tmux.conf` | `~/.tmux.conf` |
| `hammerspoon.lua` | `~/.hammerspoon/init.lua` |
| `karabiner/` | `~/.config/karabiner` |
| `spacemacs` | `~/.spacemacs` |
| `spacemacs_layers/` | `~/.emacs.spc/private` |
| `doom/` | `~/.doom.d` |
| `emacs/` | `~/.emacs.nc` |
| `emacs-profiles.el` | `~/.emacs-profiles.el` |

After editing, run `./link.sh` to create any missing symlinks. Existing symlinks are skipped (not overwritten).

## Key configuration details

- **Shell**: zsh with oh-my-zsh, af-magic theme. Secrets sourced from `~/.env.local`.
- **tmux**: prefix is `C-x` (not `C-b`). Windows 1-indexed. Mouse enabled.
- **Git**: editor is vim. Auth via `gh`. Global gitignore at `gitignore_global`.
- **Emacs**: chemacs2 multi-profile — `spc` (Spacemacs, default), `doom`, `nc`. Custom Spacemacs layer in `spacemacs_layers/nrn/`.
- **Karabiner**: `karabiner.json` is complex — home-row modifiers (a=arrows, d=numbers, f=brackets, s=symbols), dual-function modifier keys for language switching via Hammerspoon (F15–F18).
- **Node**: managed via fnm, pnpm preferred.

## Working with karabiner.json

The Karabiner config is a large JSON file with intricate modifier rules. When editing:
- Preserve the existing structure of `complex_modifications.rules`
- Each home-row modifier (a/s/d/f) has its own rule set with `from`/`to` mappings
- Dual-function keys use `to_if_alone` + `to_if_held_down` patterns
- Test changes by reloading Karabiner-Elements (it watches the file automatically)
