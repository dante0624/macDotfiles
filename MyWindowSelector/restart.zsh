echo "Booting-out my-window-selector, if the process is already tracked"
if launchctl print "gui/$(id -u)/com.user.mywindowselector" &> /dev/null; then
    echo "my-window-selector is already tracked, booting it out"
	launchctl bootout "gui/$(id -u)/com.user.mywindowselector"
else
	echo "my-window-selector wasn't tracked, nothing to boot-out"
fi
echo

echo "Bootstrapping my window selector"
launchctl bootstrap "gui/$(id -u)" "$HOME/Library/LaunchAgents/personal.startMyWindowSelector.plist"

echo "Run 'launchctl list | grep mywindowselector' to see the status"
echo "13 means it failed to create the tap, likely due to permissions"
echo "0 means it is successful"
