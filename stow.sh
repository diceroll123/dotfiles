#!/bin/zsh

# Delete any and all .DS_Store files recursively
find . -name ".DS_Store" -delete

STOW_FOLDERS="atuin,bat,eza,ghostty,git,lazygit,nvim,starship,tmux,yazi,zsh"

for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g"); do
    echo "Stowing $folder"
    stow --target=$HOME -R $folder
done
