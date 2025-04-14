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

# Set up my tmux config
tmuxConfig=$(find ~+ -type f -name "tmux.conf")
mkdir -p "$HOME/.config/tmux"
ln -sf $tmuxConfig "$HOME/.config/tmux/tmux.conf"

# Set up my neovim config
if [ ! -e "$HOME/.config/nvim/init.lua" ]
then
	git clone "https://github.com/dante0624/nvim_config" "$HOME/.config/nvim/"
fi

# Make nvim the default editor for git
git config --global core.editor "nvim"

# Create a soft link for my intelliJ vim config
ideavimPreferences=$(find ~+ -type f -name "ideavim.vim")
ln -sf $ideavimPreferences "$HOME/.ideavimrc"

# Ovwrite several preferences, saved as Plists at ~/Library/Preferences/
# Some preferences we are overwritting also have a GUI found at:
#	1. System Settings -> Keyboard -> Keyboard Shortcuts
#	2. In the application itself (application menu bar -> settings)


# First change general Mac Settings 
# Need to restart computer for changes to be seen

# Modify Keyboard Shortcuts -> App Shortcuts -> All Applications
globalPreferences=$(find ~+ -type f -name "globalPreferences.xml")
cp $globalPreferences globalBinary
plutil -convert binary1 globalBinary
mv globalBinary ~/Library/Preferences/.GlobalPreferences.plist

# Modify Keyboard Shortcuts -> (LaunchPad & Doc, Mission Control)
hotKeys=$(find ~+ -type f -name "hotKeys.xml")
cp $hotKeys hotKeysBinary
plutil -convert binary1 hotKeysBinary
mv hotKeysBinary ~/Library/Preferences/com.apple.symbolichotkeys.plist


# Set iTerm Preferences
# This shell script must be called from something other than iterm itself!!!
itermPreferences=$(find ~+ -type f -name "itermPreferences.xml")
cp $itermPreferences itermBinary
plutil -convert binary1 itermBinary
mv itermBinary ~/Library/Preferences/com.googlecode.iterm2.plist
# Iterm keeps its prefernces in RAM and when you close iTerm they get written

# So if you open iTerm, run this script, then close iTerm it will:
# 1. loads the default settings from the hard drive into RAM
# 2. A user runs the script, which updates only the hard drive
# 3. iTerm closes and saves the default settings back onto the hard drive

# Set Amethyst preferences
amethystPreferences=$(find ~+ -type f -name "amethystPreferences.xml")
cp $amethystPreferences amethystBinary
plutil -convert binary1 amethystBinary
mv amethystBinary ~/Library/Preferences/com.amethyst.Amethyst.plist

# Set Xquartz preferences (don't begin xterm on startup)
xquartzPreferences=$(find ~+ -type f -name "xquartzPreferences.xml")
cp $xquartzPreferences xquartzBinary
plutil -convert binary1 xquartzBinary
mv xquartzBinary ~/Library/Preferences/org.xquartz.X11.plist

# Modify misc mac settings
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock expose-group-apps -bool false
defaults write com.apple.spaces spans-displays -bool true
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false


# Copy Launch Agents to the correct destination, so they begin on startup
amethystAgent=$(find ~+ -type f -name "startAmethyst.xml")
cp $amethystAgent ~/Library/LaunchAgents/personal.startAmethyst.plist

swapEscAndCapsLockAgent=$(find ~+ -type f -name "swapEscAndCapsLock.xml")
cp $swapEscAndCapsLockAgent ~/Library/LaunchAgents/personal.swapEscAndCapsLock.plist

xquartzWakeupScript=$(find ~+ -type f -name "xquartz_wakeup.sh")
xquartzAgent=$(find ~+ -type f -name "startXquartz.xml")
sed "s#PATH_TO_WAKEUP_SCRIPT#$xquartzWakeupScript#" $xquartzAgent > ~/Library/LaunchAgents/personal.startXquartz.plist

