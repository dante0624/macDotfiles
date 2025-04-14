if ! pgrep -x "Xquartz" > /dev/null; then
	open -a XQuartz
	sleep 2
fi

/opt/X11/bin/xmessage -timeout 1 -buttons "" " "
