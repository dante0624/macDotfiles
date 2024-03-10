# Make sure that .zshrc file exists, as we may add things to it
if ! [ -f "$HOME/.zshrc" ]; then
	touch "$HOME/.zshrc"
fi

# Tell .zshrc to source a file that has my ZShell Preferences
shellPreferences="source \"$(find ~+ -type f -name 'shellPreferences.zsh')\""
if ! grep -q "$shellPreferences" "$HOME/.zshrc"
then
  echo $shellPreferences >> "$HOME/.zshrc"
fi

# Set up my neovim config
if [ ! -e "$HOME/.config/nvim/init.lua" ]
then
	git clone "https://github.com/dante0624/nvim_config" "$HOME/.config/nvim/"
fi

# Make nvim the default editor for git
git config --global core.editor "nvim"

# Create a soft link for my intelliJ vim config
ideavimPreferences=$(find ~+ -type f -name "ideavim.vim")
if [ ! -e "$HOME/.ideavimrc" ]
then
  ln -s $ideavimPreferences "$HOME/.ideavimrc"
fi

# Ovwrite several preferences, saved as Plists at ~/Library/Preferences/
# Some preferences we are overwritting also have a GUI found at:
#	1. System Settings -> Keyboard -> Keyboard Shortcuts
#	2. In the application itself (application menu bar -> settings)


# First change general Mac Settings 
# Need to restart computer for changes to be seen

# Modify Keyboard Shortcuts -> App Shortcuts -> All Applications
cp globalPreferences.xml globalBinary
plutil -convert binary1 globalBinary
mv globalBinary ~/Library/Preferences/.GlobalPreferences.plist

# Modify Keyboard Shortcuts -> (LaunchPad & Doc, Mission Control)
cp hotKeys.xml hotKeysBinary
plutil -convert binary1 hotKeysBinary
mv hotKeysBinary ~/Library/Preferences/com.apple.symbolichotkeys.plist


# Set iTerm Preferences
# This shell script must be called from something other than iterm itself!!!
cp itermPreferences.xml itermBinary
plutil -convert binary1 itermBinary
mv itermBinary ~/Library/Preferences/com.googlecode.iterm2.plist
# Iterm keeps its prefernces in RAM and when you close iTerm they get written

# So if you open iTerm, run this script, then close iTerm it will:
# 1. loads the default settings from the hard drive into RAM
# 2. A user runs the script, which updates only the hard drive
# 3. iTerm closes and saves the default settings back onto the hard drive

# Set Amethyst preferences
cp amethystPreferences.xml amethystBinary
plutil -convert binary1 amethystBinary
mv amethystBinary ~/Library/Preferences/com.amethyst.Amethyst.plist

# Modify misc mac settings
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock expose-group-apps -bool false
defaults write com.apple.spaces spans-displays -bool true
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false
