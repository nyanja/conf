#!/usr/bin/env zsh

typeset -A mapping
mapping=(
    hammerspoon.lua   .hammerspoon/init.lua
    zshrc             .zshrc
    gitconfig         .gitconfig
    gitignore_global  .gitignore_global
    tmux.conf         .tmux.conf
    karabiner.json    .config/karabiner/karabiner.json
    spacemacs         .spacemacs
    spacemacs_layers  .emacs.d/private
    doom              .doom.d
    emacs-profiles.el .emacs-profiles.el
)

for src in ${(k)mapping}; do
    dst=~/${mapping[$src]}
    if [ ! -L "$dst" ]; then
        echo "$src -> $dst"
        mkdir -p "$(dirname "$dst")"
        ln -s "${0:a:h}/$src" "$dst"
    fi
done
