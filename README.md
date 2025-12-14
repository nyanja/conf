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

## Keybindings

### Global keyboard shortcuts
#### Karabiner

**Simple Modifications:**
| From | To |
|------|-----|
| Caps Lock | Left Control |

**Dual-Function Keys:**
| Key | Tap | Hold |
|-----|-----|------|
| Control | Escape | Control |
| Enter | Enter | Right Control |
| Left Option | F15 (→ Spanish) | Option |
| Left Cmd | F16 (→ ABC) | Cmd |
| Right Cmd | F17 (→ Russian) | Cmd |
| Right Option | F18 (→ Ukrainian) | Option |

**Home Row Modifiers:**

`a` + key → Arrow navigation:
|     |     |     |     |     |     |     |     |     |     |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| q | w | e | r | t | y | u | i | o | p |
| `a` | s | d | f | g | `←` | `↓` | `↑` | `→` | `⏎` |
| z | x | c | v | b | n | m | , | . | / |

`d` + key → Numbers:
|     |     |     |     |     |     |     |     |     |     |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| q | w | e | r | t | y | `7` | `8` | `9` | p |
| a | s | `d` | f | g | h | `4` | `5` | `6` | `0` |
| z | x | c | v | b | n | `1` | `2` | `3` | / |

`f` + key → Brackets/Symbols:
|     |     |     |     |     |     |     |     |     |     |     |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| q | w | e | r | t | `{` | `@` | `#` | `}` | p | [ |
| a | s | d | `f` | g | `(` | `-` | `_` | `)` | `:` | `"` |
| z | x | c | v | b | `[` | `=` | `+` | `]` | `?` |

`s` + key → Symbols:
|     |     |     |     |     |     |     |     |     |     |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| q | w | e | r | t | y | `&` | `*` | `~` | p |
| a | `s` | d | f | g | h | `$` | `%` | `^` | ; |
| z | x | c | v | b | n | `!` | `@` | `#` | `\` |

#### Hammerspoon

Keyboard layout switching (triggered by Karabiner via F-keys):
| Trigger | Layout |
|---------|--------|
| F15 (Left Option tap) | Spanish |
| F16 (Left Cmd tap) | ABC |
| F17 (Right Cmd tap) | Russian |
| F18 (Right Option tap) | Ukrainian |

### Spacemacs (nrn layer)

**Hyper (Cmd) bindings:**
| Key | Action |
|-----|--------|
| H-s | Save buffer |
| H-q | Save and quit |
| H-x | Cut |
| H-c | Copy |
| H-v | Paste |
| H-f | Helm swoop |
| H-w | Kill buffer |
| H-= | Zoom in |
| H-- | Zoom out |
| H-/ | Comment line |
| H-← | Previous buffer |
| H-→ | Next buffer |

**Smartparens (structural editing):**
| Key | Action |
|-----|--------|
| H-h | Backward slurp |
| H-j | Backward barf |
| H-k | Forward barf |
| H-l | Forward slurp |
| M-h | Backward kill symbol |
| M-l | Kill symbol |
| M-s | Splice sexp |
| M-a | Splice killing around |

**Leader keys:**
| Key | Action |
|-----|--------|
| SPC d r | Sort/align Clojure requires |
| SPC d c a | Clear CIDER aliases |
| SPC d k f | Find API handler |
| SPC d k r | Reload replica |
| SPC d k d | Reload dev |

## Requirements

- [chemacs2](https://github.com/plexus/chemacs2) - Clone to `~/.emacs.d`
- [Spacemacs](https://github.com/syl20bnr/spacemacs) - Clone to `~/.emacs.spc`
- Font: Iosevka SS04
