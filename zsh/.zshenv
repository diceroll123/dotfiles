
. "$HOME/.cargo/env"

# uv
export PATH="$HOME/.local/bin:$PATH"

# Homebrew (in WSL)
if [ -d "/home/linuxbrew/.linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi
