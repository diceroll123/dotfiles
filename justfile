# Regenerate the Brewfile from currently installed packages (skips Mac App Store, local cargo installs, and Brewfile.studio entries)
brew-dump:
    brew bundle dump --file=./Brewfile --force --no-mas
    cargo install --list | sed -nE 's/^([^ ]+) v[^ ]+ \(\/.*\):$/\1/p' | while read -r crate; do sed -i '' "/^cargo \"$crate\"/d" Brewfile; done
    grep -vxFf Brewfile.studio Brewfile > Brewfile.tmp; mv Brewfile.tmp Brewfile

# Install everything listed in the Brewfile
brew-install:
    brew bundle install --file=./Brewfile
