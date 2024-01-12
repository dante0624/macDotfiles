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
if ! [ -d "$HOME/.oh-my-zsh/" ]; then
	sh omz-installer.sh --unattended --keep-zshrc
else
	echo "Oh-my-zsh already installed at $HOME/.oh-my-zsh/"
fi
