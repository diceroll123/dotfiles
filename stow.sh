#!/usr/bin/env bash

# Delete any and all .DS_Store files recursively
find . -name ".DS_Store" -delete

STOW_FOLDERS="atuin,bat,btop,eza,ghview,ghostty,git,lazygit,nvim,starship,tmux,yazi,zsh"

backup_if_different() {
    local src="$1" dest="$2"
    [ -f "$dest" ] || return
    if ! diff -q "$src" "$dest" &>/dev/null; then
        echo "Backing up existing $(basename "$dest") to $(basename "$dest").bak"
        mv "$dest" "${dest}.bak"
    fi
}

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
backup_if_different "$SCRIPT_DIR/zsh/.zshrc"  ~/.zshrc
backup_if_different "$SCRIPT_DIR/zsh/.zshenv" ~/.zshenv
if [ -f ~/.zprofile ]; then
    echo "Backing up existing .zprofile to .zprofile.bak"
    mv ~/.zprofile ~/.zprofile.bak
fi

for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g"); do
    echo "Stowing $folder"
    stow --target=$HOME -R $folder
done

if [ -f "$DOTFILES/personal/stow.sh" ]; then
    bash "$DOTFILES/personal/stow.sh"
fi

./post-stow.sh
