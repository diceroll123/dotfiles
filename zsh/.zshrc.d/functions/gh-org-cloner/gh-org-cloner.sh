#!/bin/bash

# Pre-requisites:
# - gh (GitHub CLI)
# - fzf (Fuzzy Finder)
# - bat (A better cat)

# TODO: make this more generic and modular

function gh_org_cloner() {
    # Get all organizations, sort them, and pick one with fzf
    # I'll probably only use this at work
    ORG=$(gh api user/memberships/orgs --paginate --jq '.[] | .organization.login' \
      | sort \
      | fzf --prompt="Select an organization: ")

    if [ -z "$ORG" ]; then
      echo "No organization selected."
      exit 1
    fi

    # Fetch all repositories for the selected organization, sort, and pick with fzf
    REPOS=$(gh api orgs/"$ORG"/repos --paginate --jq '.[] | .name' \
      | sort \
      | fzf -m \
        --prompt="Select repositories to clone: " \
        --preview='
            README_URL=$(gh api repos/'"$ORG"'/{1}/contents --jq '\''.[] | select(.name | test("README.md"; "i")) | .download_url'\'' 2>/dev/null)
            if [ -n "$README_URL" ]; then
                curl -s "$README_URL" | bat --style=plain --paging=always --language=markdown --color=always
            else
                echo "No README found for {1}"
            fi')

    if [ -z "$REPOS" ]; then
      echo "No repositories selected."
      exit 1
    fi

    echo "Cloning selected repositories..."
    echo "$REPOS" | while IFS= read -r REPO; do
        git clone "https://github.com/$ORG/$REPO"
    done
}
