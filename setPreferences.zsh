# Some preferences we are settings can be found in:
#	1. In the application itself (application menu bar -> settings)
#	2. Under System Settings -> Keyboard -> Keyboard Shortcuts -> App Shortcuts

# Modify Appy Shortcuts -> All Applications
# Need to restart computer for changes to be seen
cp globalPreferences.xml globalBinary
plutil -convert binary1 globalBinary
mv globalBinary ~/Library/Preferences/.GlobalPreferences.plist

# Set up my neovim config
if [ ! -e "$HOME/.config/nvim/init.lua" ]
then
	git clone "https://github.com/dante0624/nvim_config" "$HOME/.config/nvim/"
fi

# Make vim an alias for nvim
nvimAlias="alias vim='nvim'"
if  ! grep -q "$nvimAlias" "$HOME/.zshrc" 
then
	echo $nvimAlias >> "$HOME/.zshrc" 
fi


# Update Iterm
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

# Update Amethyst preferences
cp amethystPreferences.xml amethystBinary
plutil -convert binary1 amethystBinary
mv amethystBinary ~/Library/Preferences/com.amethyst.Amethyst.plist

# Append oh-my-zsh config to .zshrc if it isn't there yet
if ! grep -q "oh-my-zsh" "$HOME/.zshrc"
then
	cat "oh-my-zsh-setup.txt" >> "$HOME/.zshrc"
fi

# Modify misc mac settings
# Autohiding the menu bar is part of .GlobalPreferences.plist
defaults write ~/Library/Preferences/com.apple.dock autohide -bool true
defaults write ~/Library/Preferences/com.apple.dock mru-spaces -bool false
defaults write ~/Library/Preferences/com.apple.dock expose-group-apps -bool false
defaults write ~/Library/Preferences/com.apple.spaces spans-displays -bool true

