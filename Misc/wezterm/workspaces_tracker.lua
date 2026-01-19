local wezterm = require('wezterm')

--[[ This module has two responsibilities:
1. Keep track of the current and prior workspaces, so they can be toggled
2. Display the current workspace name in the top-right corner
]]
local M = {
	current = nil,
	prior = nil,
}

wezterm.on('update-right-status', function(window, _)
	local active_workspace_name = window:active_workspace()
	window:set_right_status(active_workspace_name .. '    ')

	-- Initialize on first run
	if M.current == nil then
		M.current = active_workspace_name
		M.prior = active_workspace_name
	end

	if active_workspace_name ~= M.current then
		M.prior = M.current
		M.current = active_workspace_name
	end
end)

return M
