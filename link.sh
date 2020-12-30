#!/usr/bin/env zsh

typeset -A mapping
mapping=(
    hammerspoon.lua .hammerspoon/init.lua
    zshrc .zshrc
    gitconfig .gitconfig
    gitignore_global .gitignore_global
    tmux.conf .tmux.conf
    karabiner.json .config/karabiner/karabiner.json
    spacemacs .spacemacs
    spacemacs_layers .emacs.d/private
)

for src in ${(k)mapping}; do
    dst=~/${mapping[$src]}
    if [ ! -L "$dst" ]; then
        echo "$src -> $dst"
        mkdir -p "$(dirname "$dst")"
        ln -s "$PWD/$src" "$dst"
    fi
done
