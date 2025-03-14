#!/bin/bash

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until script has finished
keep_sudo_alive() {
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done 2>/dev/null &
    sudo_pid=$!
}

# Start keep-alive and trap the exit to kill it
keep_sudo_alive
trap 'kill "$sudo_pid" 2>/dev/null' EXIT

# Set variable for macOS detection
function is_macos() {
    [[ "$OSTYPE" =~ ^darwin ]] || return 1
}

if is_macos; then
    echo "macOS detected..."

    # Close any open System Preferences panes, to prevent them from overriding
    # settings we’re about to change
    osascript -e 'tell application "System Preferences" to quit'

    # Install xCode cli tools
    if xcode-select -p &>/dev/null; then
        echo "Xcode already installed"
    else
        echo "Installing commandline tools..."
        xcode-select --install
    fi

    ## MacOS settings
    echo "Changing macOS defaults..."

    # Hide login string in terminal
    touch ~/.hushlogin

    # Trackpad: map bottom right corner to right-click
    defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
    defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool TRUE

    # Disable automatic capitalization as it’s annoying when typing code
    defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

    # Disable smart dashes as they’re annoying when typing code
    defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

    # Disable automatic period substitution as it’s annoying when typing code
    defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

    # Disable smart quotes as they’re annoying when typing code
    defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

    # Disable auto-correct
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

    # Finder: show hidden files by default
    defaults write com.apple.finder AppleShowAllFiles -bool true

    # Finder: show all filename extensions
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true

    # Finder: show status bar
    defaults write com.apple.finder ShowStatusBar -bool true

    # Finder: show path bar
    defaults write com.apple.finder ShowPathbar -bool true

    # Display full POSIX path as Finder window title
    defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

    # Keep folders on top when sorting by name
    defaults write com.apple.finder _FXSortFoldersFirst -bool true

    # When performing a search, search the current folder by default
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

    # Disable the warning when changing a file extension
    defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

    # Avoid creating .DS_Store files on network or USB volumes
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
    defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

    # Drag windows from anywhere
    defaults write -g NSWindowShouldDragOnGesture -bool true

    # Disable the “Are you sure you want to open this application?” dialog
    # defaults write com.apple.LaunchServices LSQuarantine -bool false

    # Show the ~/Library folder
    chflags nohidden ~/Library && xattr -d com.apple.FinderInfo ~/Library

    # Show the /Volumes folder
    sudo chflags nohidden /Volumes

    # Hide desktop icons
    # defaults write com.apple.finder CreateDesktop -bool false && killall Finder

    # Automatically hide and show the Dock
    defaults write com.apple.Dock autohide -bool TRUE

    # Set a blazingly fast keyboard repeat rate
    defaults write NSGlobalDomain KeyRepeat -int 1
    defaults write InitialKeyRepeat -int 10
fi

# Install oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Install uv
if ! command -v uv &>/dev/null; then
    echo "uv not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://astral.sh/uv/install.sh)"
fi

# Install Homebrew
if ! command -v brew &>/dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
brew analytics off

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

## Taps
echo "Tapping Brew..."
# {
brew tap yannjor/krabby
brew install krabby
brew install lkrms/misc/pretty-php
brew install noahgorstein/tap/jqp
# }

## Formulae
echo "Installing Brew Formulae..."
# {
brew install atuin
brew install awscli
brew install bash-language-server
brew install bat
brew install bat-extras
brew install btop
brew install cbonsai
brew install cmatrix
brew install coreutils
brew install delta
brew install docker
brew install entr
brew install eza
brew install fd
brew install fzf
brew install gh
[ -n "$is_macos" ] && brew install ghostty
brew install halp
brew install jq
brew install lazydocker
brew install lazygit
brew install lolcat
brew install luarocks
brew install lua-language-server
brew install make
brew install neofetch
brew install neovim
brew install node
brew install onefetch
brew install parallel
brew install pngquant
brew install poppler
brew install pre-commit
brew install pyright
brew install rich-cli
brew install ripgrep
brew install ruff
brew install sccache
brew install sevenzip
brew install shfmt
brew install ssh-copy-id
brew install starship
brew install stow
brew install tectonic
brew install tlrc
brew install tmux
brew install tokei
[ -n "$is_macos" ] && brew install trash
brew install tree
brew install tree-sitter
brew install watch
brew install wget
brew install yank
brew install yazi
brew install yq
brew install zoxide
brew install zsh-autosuggestions
brew install zsh-syntax-highlighting
# }

## Casks
echo "Installing Brew Casks..."
# {
[ -n "$is_macos" ] && brew install --cask 1password
[ -n "$is_macos" ] && brew install --cask firefox
brew install --cask font-hack-nerd-font
brew install --cask font-jetbrains-mono-nerd-font
[ -n "$is_macos" ] && brew install --cask font-sf-pro
[ -n "$is_macos" ] && brew install --cask github
[ -n "$is_macos" ] && brew install --cask google-chrome
[ -n "$is_macos" ] && brew install --cask obsidian
[ -n "$is_macos" ] && brew install --cask raycast
[ -n "$is_macos" ] && brew install --cask sublime-text
[ -n "$is_macos" ] && brew install --cask visual-studio-code
# }

## Cargo installations
# for when things are not available in Brew
cargo install repgrep

## NPM installations
npm install -g cronstrue

echo "Running brew cleanup..."
brew cleanup

## Github CLI extensions
if gh auth status &>/dev/null; then
    gh extension install github/gh-copilot
    gh extension install meiji163/gh-notify
else
    echo "GitHub CLI not authenticated. Skipping gh extensions."
fi

# Stow new dotfiles using stow.sh
echo "Stowing new dotfiles..."
source ./stow.sh

echo "Dotfiles setup complete!"
