#!/usr/bin/env bash

# Delete any and all .DS_Store files recursively
find . -name ".DS_Store" -delete

STOW_FOLDERS="atuin,bat,eza,ghostty,git,lazygit,nvim,starship,tmux,yazi,zsh"

# back up any existing .zsh* files
if [ -f ~/.zshrc ]; then
    echo "Backing up existing .zshrc to .zshrc.bak"
    mv ~/.zshrc ~/.zshrc.bak
fi
if [ -f ~/.zshenv ]; then
    echo "Backing up existing .zshenv to .zshenv.bak"
    mv ~/.zshenv ~/.zshenv.bak
fi
if [ -f ~/.zprofile ]; then
    echo "Backing up existing .zprofile to .zprofile.bak"
    mv ~/.zprofile ~/.zprofile.bak
fi

for folder in $(echo $STOW_FOLDERS | sed "s/,/ /g"); do
    echo "Stowing $folder"
    stow --target=$HOME -R $folder
done

./post-stow.sh
