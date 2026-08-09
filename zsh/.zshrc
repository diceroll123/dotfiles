# ============================================================================
# Shell Options
# ============================================================================
setopt prompt_cr prompt_sp
PROMPT_EOL_MARK=

# Some programs (nvim, atuin's Ctrl-R search, fzf, etc.) enable xterm mouse-tracking
# and bracketed-paste modes and are expected to disable them on exit. If a session
# dies uncleanly (e.g. SSH connection drops), that disable sequence never arrives and
# the terminal is left reading mouse movement as garbage input. Reset those modes
# before every prompt so the shell self-heals as soon as control returns to it.
_reset_terminal_modes() {
    printf '\e[?1000l\e[?1002l\e[?1003l\e[?1005l\e[?1006l\e[?1015l\e[?2004l'
}
precmd_functions+=(_reset_terminal_modes)

[[ -n "$SSH_CONNECTION" ]] && export TERM=xterm-256color

# ============================================================================
# Environment Variables
# ============================================================================
export VISUAL="nvim"
export EDITOR="nvim"
bindkey -e  # force emacs keymap; zsh else infers vi-mode from "nvim" containing "vi"
export XDG_CONFIG_HOME="$HOME/.config"
export GH_PAGER=""
export DOTFILES="$HOME/dotfiles"
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

# ============================================================================
# Path Configuration
# ============================================================================
export PATH="$HOME/.rd/bin:$PATH"
export PATH="$HOME/bins:$PATH"

_zsh_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/evals"
[[ -d "$_zsh_cache" ]] || mkdir -p "$_zsh_cache"
_eval_cached() {
  local name="$1" cmd="$2" bin="${3:-$(command -v ${1%%-*} 2>/dev/null)}"
  local cache="$_zsh_cache/$name"
  [[ ! -f "$cache" || ( -n "$bin" && "$bin" -nt "$cache" ) ]] && eval "$cmd" >| "$cache"
  source "$cache"
}
_eval_cached brew-shellenv "/opt/homebrew/bin/brew shellenv" /opt/homebrew/bin/brew
export PATH="$HOME/.cargo/bin:$PATH"
export XDG_DATA_DIRS="$HOMEBREW_PREFIX/share:$XDG_DATA_DIRS"

# ============================================================================
# Plugins & Tools
# ============================================================================
_eval_cached fzf "fzf --zsh"
_eval_cached atuin "atuin init zsh"
_eval_cached starship "starship init zsh"
unset -f _eval_cached

source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# ============================================================================
# Additional Configurations
# ============================================================================
source_recursively() {
  local file_path="$1" name_pattern="$2" f
  [[ -d "$file_path" ]] || return
  for f in "$file_path"/**/$~name_pattern(N.on); do source "$f"; done
}

# Source user configurations
source_recursively "$HOME/.zshrc.d/" "*.sh"
source_recursively "$DOTFILES/personal" "zsh_*.sh"

eval "$(zoxide init zsh)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
