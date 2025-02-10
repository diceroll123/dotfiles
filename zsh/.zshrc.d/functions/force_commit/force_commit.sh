#!/bin/bash

function force_commit() {
    # For when I don't want to think about, or write commit messages.
    # Automatically stages all changes and commits if anything is not staged.
    script_dir="$(cd "$(dirname "${(%):-%x}")" && pwd)"
    messages_file="$script_dir/commit_messages.txt"

    # Get the list of staged files
    staged_files=$(git diff --cached --name-only)

    # If there are no staged files, stage everything
    if [[ -z $staged_files ]]; then
        git add -A
        staged_files=$(git diff --cached --name-only)
    fi

    # If there are still no staged files, exit
    if [[ -z $staged_files ]]; then
        echo "No changes to commit."
        return 1
    fi

    # Count the number of staged files
    staged_count=$(echo "$staged_files" | wc -l)

    if [[ $staged_count -eq 1 ]]; then
        # Use the single file name in the commit message
        single_file=$(basename "$staged_files")
        git commit -m "Updated $single_file"
    else
        # Use a random message for multiple files
        random_message=$(rg -v '^\s*$' "$messages_file" | shuf -n 1)
        git commit -m "🤡🪄 $random_message"
    fi
}
