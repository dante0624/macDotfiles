# Make sure that .zshrc file exists, as we may add things to it
if ! [ -f "$HOME/.zshrc" ]; then
	touch "$HOME/.zshrc"
fi

# Make vim an alias for nvim
nvimAlias="alias vim='nvim'"
if  ! grep -q "$nvimAlias" "$HOME/.zshrc" 
then
	echo $nvimAlias >> "$HOME/.zshrc" 
fi

# Set up my neovim config
if [ ! -e "$HOME/.config/nvim/init.lua" ]
then
	git clone "https://github.com/dante0624/nvim_config" "$HOME/.config/nvim/"
fi

# Append oh-my-zsh preferences to .zshrc if it isn't there yet
if ! grep -q "oh-my-zsh" "$HOME/.zshrc"
then
	cat "omz-preferences.txt" >> "$HOME/.zshrc"
fi

# Some preferences we are settings can be found in:
#	1. In the application itself (application menu bar -> settings)
#	2. Under System Settings -> Keyboard -> Keyboard Shortcuts -> App Shortcuts

# Modify Appy Shortcuts -> All Applications
# Need to restart computer for changes to be seen
cp globalPreferences.xml globalBinary
plutil -convert binary1 globalBinary
mv globalBinary ~/Library/Preferences/.GlobalPreferences.plist


# Set iTerm Preferences
# Modify to the application itself and App Shorcuts > iTerm.app

# This shell script must be called from something other than iterm itself!!!
# Iterm keeps its prefernces in RAM and when you close iTerm they get written

# So if you open iTerm, run this script, then close iTerm it will:
# 1. loads the default settings from the hard drive into RAM
# 2. A user runs the script, which updates only the hard drive
# 3. iTerm closes and saves the default settings back onto the hard drive
cp itermPreferences.xml itermBinary
plutil -convert binary1 itermBinary
mv itermBinary ~/Library/Preferences/com.googlecode.iterm2.plist

# Set Amethyst preferences
cp amethystPreferences.xml amethystBinary
plutil -convert binary1 amethystBinary
mv amethystBinary ~/Library/Preferences/com.amethyst.Amethyst.plist

# Modify misc mac settings
defaults write ~/Library/Preferences/com.apple.dock autohide -bool true
defaults write ~/Library/Preferences/com.apple.dock mru-spaces -bool false
defaults write ~/Library/Preferences/com.apple.dock expose-group-apps -bool false
defaults write ~/Library/Preferences/com.apple.spaces spans-displays -bool true

