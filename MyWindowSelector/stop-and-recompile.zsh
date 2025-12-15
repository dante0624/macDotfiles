echo "Booting-out my-window-selector, if the process is already tracked"
if launchctl print "gui/$(id -u)/com.user.mywindowselector" &> /dev/null; then
    echo "my-window-selector is already tracked, booting it out"
	launchctl bootout "gui/$(id -u)/com.user.mywindowselector"
else
	echo "my-window-selector wasn't tracked, nothing to boot-out"
fi
echo

echo "Recompiling the swift application"
swiftc -O "$HOME/macDotfiles/MyWindowSelector/MyWindowSelector.swift" -o "$HOME/macDotfiles/MyWindowSelector/my-window-selector"
echo "Done compiling"
echo

echo "Note that you will need to reset permissions each time the binary is changed"
echo "See if my-window-selector already has permissions in System Settings -> Privacy & Security -> Accessibility"
echo "If so, remove that row completely by clicking it and then -"
echo
echo "If you fail to do so, the binary will enter a weird state"
echo "It will look like the permission are granted, but they actually aren't"
echo "Then the new binary will always fail to listen for keypresses"
echo
echo "Note that after permissions are removed, you will need to run the binary twice"
echo "The first time it will fail to listen for keypresses, but will request the permissions"
echo "At this point, you should grant the permissions"
echo "Then run it again and it will succeed"

