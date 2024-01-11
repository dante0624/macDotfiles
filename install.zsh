# Installs a nerd font
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font

# Installs my neovim telescope dependencies
brew install ripgrep
brew install fd

# Install neovim
brew install neovim

# Install Mac Specific Stuff
brew install iterm2
brew install --cask amethyst

# Install oh-my-zsh but does not update any .zshrc config file or anything
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
