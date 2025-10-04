setopt prompt_cr prompt_sp
PROMPT_EOL_MARK=

[[ -n "$SSH_CONNECTION" ]] && export TERM=xterm-256color

# General variables
export VISUAL="nvim"
export EDITOR="nvim"
export XDG_CONFIG_HOME="$HOME/.config"
export GH_PAGER=""

# Workspace variables
export DOTFILES="$HOME/dotfiles"
export PATH="/opt/homebrew/bin/:/opt/homebrew/opt/trash/bin/:$PATH"

eval "$(brew shellenv)"

# set Starship PATH
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

export XDG_DATA_DIRS="$HOMEBREW_PREFIX/share:$XDG_DATA_DIRS"
. "$HOME/.cargo/env"

fpath=($HOME/.docker/completions $fpath)
autoload -U +X compinit && compinit

# oh-my-zsh
plugins=(
  fzf
  gh
  git
  starship
  zoxide
)
DISABLE_AUTO_UPDATE=true
source $HOME/.oh-my-zsh/oh-my-zsh.sh

# Atuin
eval "$(atuin init zsh)"

source_recursively() {
  local file_path="$1"
  local name_pattern="$2"
  if [ -d "$file_path" ]; then
    while read -r f; do source "$f"; done < <(find "$file_path" -name "$name_pattern" | sort)
  fi
}

# source zsh files in .zshrc.d
source_recursively "$HOME/.zshrc.d/" "*.sh"
# source private zsh files in dotfiles
source_recursively "$DOTFILES/personal" "zsh_*.sh"

# brew installations activation
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
