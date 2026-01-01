# ============================================================================
# Shell Options
# ============================================================================
setopt prompt_cr prompt_sp
PROMPT_EOL_MARK=

[[ -n "$SSH_CONNECTION" ]] && export TERM=xterm-256color

# ============================================================================
# Environment Variables
# ============================================================================
export VISUAL="nvim"
export EDITOR="nvim"
export XDG_CONFIG_HOME="$HOME/.config"
export GH_PAGER=""
export DOTFILES="$HOME/dotfiles"
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

# ============================================================================
# Path Configuration
# ============================================================================
export PATH="$HOME/.rd/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"
export XDG_DATA_DIRS="$HOMEBREW_PREFIX/share:$XDG_DATA_DIRS"

# Cargo (only if .cargo/env exists)
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# ============================================================================
# Completions (lazy-loaded on first tab)
# ============================================================================
fpath=($HOME/.docker/completions $fpath)

autoload -Uz compinit
_lazy_compinit() {
  unfunction _lazy_compinit
  compinit -C
  zle expand-or-complete
}
zle -N _lazy_compinit
bindkey '^I' _lazy_compinit  # Tab triggers lazy load

# ============================================================================
# Plugins & Tools
# ============================================================================
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"
eval "$(starship init zsh)"

# Lazy-load gh completions (on first gh<Tab>)
gh() {
  unfunction gh
  eval "$(command gh completion -s zsh)"
  command gh "$@"
}

source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ============================================================================
# Additional Configurations
# ============================================================================
source_recursively() {
  local file_path="$1"
  local name_pattern="$2"
  if [ -d "$file_path" ]; then
    while read -r f; do source "$f"; done < <(find "$file_path" -name "$name_pattern" | sort)
  fi
}

# Source user configurations
source_recursively "$HOME/.zshrc.d/" "*.sh"
source_recursively "$DOTFILES/personal" "zsh_*.sh"
