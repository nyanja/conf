# Dotfiles

Personal configuration files for macOS development environment.


## Emacs Configuration

Uses [chemacs2](https://github.com/plexus/chemacs2) to manage multiple Emacs distributions.

### Profiles

| Profile | Directory      | Command              |
|---------|----------------|----------------------|
| spc     | `~/.emacs.spc` | `emacs --with-profile spc` (default) |
| doom    | `~/.emacs.doom`| `emacs --with-profile doom` |
| nc      | `~/.emacs.nc`  | `emacs --with-profile nc` |

Profiles are defined in `emacs-profiles.el` (linked to `~/.emacs-profiles.el`).

### Spacemacs Setup

The main configuration is in `spacemacs` (linked to `~/.spacemacs`).

**Key layers:**
- `clojure` - CIDER, clj-kondo, clj-refactor
- `lsp` - Language Server Protocol support
- `nrn` - Custom personal layer

## Requirements

- [chemacs2](https://github.com/plexus/chemacs2) - Clone to `~/.emacs.d`
- [Spacemacs](https://github.com/syl20bnr/spacemacs) - Clone to `~/.emacs.spc`
- Font: Iosevka SS04
