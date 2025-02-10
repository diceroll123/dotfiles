. "$HOME/.cargo/env"

# uv
export PATH="$HOME/.local/bin:$PATH"

# add brew to path if we're on linux
if [ -d "/home/linuxbrew/.linuxbrew/bin" ]; then
  export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
fi
