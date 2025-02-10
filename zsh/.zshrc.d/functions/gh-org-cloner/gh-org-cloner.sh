#!/bin/bash

# Pre-requisites:
# - gh (GitHub CLI)
# - fzf (Fuzzy Finder)
# - bat (A better cat)
select_org() {
  # Get all organizations, sort them, and pick one with fzf
  ORG=$(gh api user/memberships/orgs --paginate --jq '.[] | .organization.login' |
    sort |
    fzf --prompt="Select an organization: ")
  if [ -z "$ORG" ]; then
    echo "No organization selected." >&2
    return 1
  fi
  echo "$ORG"
}

select_repos() {
  local ORG=$1
  # Fetch all repositories for the selected organization, sort, and pick with fzf (supports multiple selection, using TAB)
  REPOS=$(gh api orgs/"$ORG"/repos --paginate --jq '.[] | .name' |
    sort |
    fzf -m \
      --prompt="Select repositories to clone from $ORG: " \
      --preview='
      README_URL=$(gh api repos/'"$ORG"'/{1}/contents --jq '\''.[] | select(.name | test("README.md"; "i")) | .download_url'\'' 2>/dev/null)
      if [ -n "$README_URL" ]; then
        curl -s "$README_URL" | bat --style=plain --paging=always --language=markdown --color=always
      else
        echo "No README found for {1}"
      fi')
  if [ -z "$REPOS" ]; then
    echo "No repositories selected." >&2
    return 1
  fi

  # Add the organization name to the selected repositories
  REPOS_WITH_ORG=$(echo "$REPOS" | sed "s/^/$ORG\//")

  echo "$REPOS_WITH_ORG"
}

gh_org_cloner() {
  local ORG=$(select_org) || return 1
  local REPOS=$(select_repos "$ORG") || return 1
  echo "Cloning selected repositories..."
  echo "$REPOS" | xargs -n1 gh repo clone
}
