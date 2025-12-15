#  Make sure that .zshrc file exists, as we may add things to it
if ! [ -f "$HOME/.zshrc" ]; then
	echo "Creating new .zshrc file in $HOME"
	touch "$HOME/.zshrc"
fi

# Tell .zshrc to source a file that has my ZShell Preferences
shellPreferencesSourceLine="source \"$HOME/macDotfiles/Misc/shellPreferences.zsh\""
if ! grep -q "$shellPreferencesSourceLine" "$HOME/.zshrc"
then
  echo "Adding line to $HOME/.zsrhc to source my shell preferences"
  echo $shellPreferencesSourceLine >> "$HOME/.zshrc"
fi

# Set up my tmux config
echo "Setting up tmux config"
mkdir -p "$HOME/.config/tmux"
ln -sf "$HOME/macDotfiles/Misc/tmux.conf" "$HOME/.config/tmux/tmux.conf"

# Set up my neovim config
if [ ! -e "$HOME/.config/nvim/init.lua" ]
then
	echo "Pulling down neovim config"
	git clone "https://github.com/dante0624/nvim_config" "$HOME/.config/nvim/"
fi

# Make nvim the default editor for git
git config --global core.editor "nvim"

# Create a soft link for my intelliJ vim config
ln -sf "$HOME/macDotfiles/Misc/ideavim.vim" "$HOME/.ideavimrc"

# Ovwrite several preferences, saved as Plists at $HOME/Library/Preferences/
# Some preferences we are overwritting also have a GUI found at:
#	1. System Settings -> Keyboard -> Keyboard Shortcuts
#	2. In the application itself (application menu bar -> settings)
echo "Setting several macOS and application preferences"

# First change general Mac Settings 
# Need to restart computer for changes to be seen

# Modify Keyboard Shortcuts -> App Shortcuts -> All Applications
plutil -convert binary1 -o "$HOME/Library/Preferences/.GlobalPreferences.plist" "$HOME/macDotfiles/Preferences/globalPreferences.xml"

# Modify Keyboard Shortcuts -> App Shortcuts -> Firefox
plutil -convert binary1 -o "$HOME/Library/Preferences/org.mozilla.firefox.plist" "$HOME/macDotfiles/Preferences/firefoxPreferences.xml"

# Modify Keyboard Shortcuts -> (LaunchPad & Doc, Mission Control)
plutil -convert binary1 -o "$HOME/Library/Preferences/com.apple.symbolichotkeys.plist" "$HOME/macDotfiles/Preferences/hotKeys.xml"

# Set iTerm Preferences
# This shell script must be called from something other than iterm itself!!!
plutil -convert binary1 -o "$HOME/Library/Preferences/com.googlecode.iterm2.plist" "$HOME/macDotfiles/Preferences/itermPreferences.xml"
# Iterm keeps its prefernces in RAM and when you close iTerm they get written

# So if you open iTerm, run this script, then close iTerm it will:
# 1. loads the default settings from the hard drive into RAM
# 2. A user runs the script, which updates only the hard drive
# 3. iTerm closes and saves the default settings back onto the hard drive

# Set Amethyst preferences
plutil -convert binary1 -o "$HOME/Library/Preferences/com.amethyst.Amethyst.plist" "$HOME/macDotfiles/Preferences/amethystPreferences.xml"

# Modify misc mac settings
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock expose-group-apps -bool false
defaults write com.apple.spaces spans-displays -bool true
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# Compile my window selector script and create symlink
echo "Compiling MyWindowSelector.swift with optimizations."
swiftc -O "$HOME/macDotfiles/MyWindowSelector/MyWindowSelector.swift" -o "$HOME/macDotfiles/MyWindowSelector/my-window-selector"
echo "Done compiling"
if ! [ -f "/usr/local/bin/my-window-selector" ]; then
	echo "Creating symbolic link at /usr/local/bin/my-window-selector. This requires sudo"
	sudo ln -sf "$HOME/macDotfiles/MyWindowSelector/my-window-selector" "/usr/local/bin/my-window-selector"
fi

# Copy Launch Agents to the correct destination, so they begin on startup
# For some reason, LaunchAgents tend to be xml files with the plist extension
echo "Copying launch agent files to the correct location"
cp "$HOME/macDotfiles/LaunchAgents/startAmethyst.xml" "$HOME/Library/LaunchAgents/personal.startAmethyst.plist"
cp "$HOME/macDotfiles/LaunchAgents/swapEscAndCapsLock.xml" "$HOME/Library/LaunchAgents/personal.swapEscAndCapsLock.plist"
cp "$HOME/macDotfiles/LaunchAgents/startMyWindowSelector.xml" "$HOME/Library/LaunchAgents/personal.startMyWindowSelector.plist"

