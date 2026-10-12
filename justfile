# Regenerate the Brewfile from currently installed packages (skips Mac App Store and local cargo installs)
brew-dump:
    brew bundle dump --file=./Brewfile --force --no-mas
    cargo install --list | sed -nE 's/^([^ ]+) v[^ ]+ \(\/.*\):$/\1/p' | while read -r crate; do sed -i '' "/^cargo \"$crate\"/d" Brewfile; done
