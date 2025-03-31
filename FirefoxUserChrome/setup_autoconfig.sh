FIREFOX_DIR="/Applications/Firefox.app/Contents/Resources"
AUTOCONFIG_DIR="/Users/dante/macDotfiles/FirefoxUserChrome"

# Link userChrome.js
ln -s -f "$AUTOCONFIG_DIR/userChrome.js" "$FIREFOX_DIR/userChrome.js"

# Link autoconfig.js
mkdir -p "$FIREFOX_DIR/defaults/pref"
ln -s -f "$AUTOCONFIG_DIR/autoconfig.js" "$FIREFOX_DIR/defaults/pref/autoconfig.js"

