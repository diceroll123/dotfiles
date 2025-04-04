#!/bin/bash

# make a temp dir and go to it
tmp() {
    cd "$(mktemp -d)"
}

# Create a new directory and enter it
mkd() {
	mkdir -p "$@" && cd "$_";
}

# Script to find every single file and opens in neovim
# alias set as zz in .zshrc
search_with_zoxide() {
    if [ -z "$1" ]; then
        # use fd with fzf to select & open a file when no args are provided
        file="$(fd --type f -H -E .git -E .git-crypt -E .cache -E .backup | fzf --height=70% --preview='bat -n --color=always --line-range :500 {}')"
        if [ -n "$file" ]; then
            nvim "$file"
        fi
    else
        # Handle when an arg is provided
        lines=$(zoxide query -l | xargs -I {} fd --type f -H -E .git -E .git-crypt -E .cache -E .backup -E .vscode "$1" {} | fzf --no-sort) # Initial filter attempt with fzf
        line_count="$(echo "$lines" | wc -l | xargs)" # Trim any leading spaces

        if [ -n "$lines" ] && [ "$line_count" -eq 1 ]; then
            # looks for the exact ones and opens it
            file="$lines"
            nvim "$file"
        elif [ -n "$lines" ]; then
            # If multiple files are found, allow further selection using fzf and bat for preview
            file=$(echo "$lines" | fzf --query="$1" --height=70% --preview='bat -n --color=always --line-range :500 {}')
            if [ -n "$file" ]; then
                nvim "$file"
            fi
        else
            echo "No matches found." >&2
        fi
    fi
}

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	/bin/rm -f -- "$tmp"
}

function lg() {
    export LAZYGIT_NEW_DIR_FILE=$(mktemp)

    lazygit "$@"

    if [ -f $LAZYGIT_NEW_DIR_FILE ]; then
        cd "$(cat $LAZYGIT_NEW_DIR_FILE)"
        /bin/rm -f $LAZYGIT_NEW_DIR_FILE > /dev/null
    fi
}

# Colormap
function colormap() {
    for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}; done
}

function mp4fix() {
    for f in *.mp4.part; do ffmpeg -i "$f" -c copy "${f%.part}" -y && rm "$f"; done
}
