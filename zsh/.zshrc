unsetopt PROMPT_SP

# General variables
export VISUAL="nvim"
export EDITOR="nvim"
export XDG_CONFIG_HOME="$HOME/.config"

# Workspace variables
export DOTFILES="$HOME/dotfiles"

# set Starship PATH
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

export XDG_DATA_DIRS="/opt/homebrew/share:$XDG_DATA_DIRS"
. "$HOME/.cargo/env"

eval "$(brew shellenv)"
autoload -U +X compinit && compinit

# oh-my-zsh
plugins=(
  fzf
  gh
  git
  starship
  zoxide
)
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
source_recursively "$HOME/dotfiles/personal" "zsh_*.sh"

# brew installations activation (new mac systems brew path: opt/homebrew , not usr/local )
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
