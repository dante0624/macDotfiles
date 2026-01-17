local wezterm = require('wezterm')
local workspaces_tracker = require('workspaces_tracker')

local M = {}

local leader = { key = 'Space', mods = 'CMD' }
local keys = {
	-- Workspaces
	{
		key = 'w',
		mods = 'LEADER',
		action = wezterm.action.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = 'Bold' } },
				{ Foreground = { AnsiColor = 'White' } },
				{ Text = 'Enter name for (possibly new) workspace' },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line and #line > 0 then
					window:perform_action(
						wezterm.action.SwitchToWorkspace({ name = line }),
						pane
					)
				end
			end),
		}),
	},
	{
		key = 's', -- For "select" a workspace
		mods = 'LEADER',
		action = wezterm.action.ShowLauncherArgs({ flags = 'WORKSPACES' })
	},
	{
		key = 'a', -- For "alternate" between two workspaces
		mods = 'LEADER',
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(
				wezterm.action.SwitchToWorkspace({
					name = workspaces_tracker.prior,
				}),
				pane
			)
		end),
	},

	-- Tabs
	{
		key = 'o', -- For "open" a tab
		mods = 'CMD',
		action = wezterm.action.ActivateKeyTable({ name = 'activate_tab' }),
	},
	{
		key = 'e', -- No explanation, just matches the neovim config
		mods = 'LEADER',
		-- Asks to confirm if the process it is closing isn't in this list:
		-- https://wezterm.org/config/lua/config/skip_close_confirmation_for_processes_named.html
		action = wezterm.action.CloseCurrentTab({ confirm = true }),
	},
	{
		key = 'LeftArrow',
		mods = 'CMD|SHIFT',
		action = wezterm.action.MoveTabRelative(-1),
	},
	{
		key = 'RightArrow',
		mods = 'CMD|SHIFT',
		action = wezterm.action.MoveTabRelative(1),
	},

	-- Panes
	{
		key = 'r', -- For "resize" panes
		mods = 'LEADER',
		action = wezterm.action.ActivateKeyTable({
			name = 'resize_pane',
			one_shot = false,
		}),
	},
	{
		key = 'h',
		mods = 'LEADER|SHIFT',
		action = wezterm.action.SplitPane({ direction = 'Left' }),
	},
	{
		key = 'j',
		mods = 'LEADER|SHIFT',
		action = wezterm.action.SplitPane({ direction = 'Down' }),
	},
	{
		key = 'k',
		mods = 'LEADER|SHIFT',
		action = wezterm.action.SplitPane({ direction = 'Up' }),
	},
	{
		key = 'l',
		mods = 'LEADER|SHIFT',
		action = wezterm.action.SplitPane({ direction = 'Right' }),
	},
	{
		key = 'h',
		mods = 'LEADER',
		action = wezterm.action.ActivatePaneDirection('Left'),
	},
	{
		key = 'j',
		mods = 'LEADER',
		action = wezterm.action.ActivatePaneDirection('Down'),
	},
	{
		key = 'k',
		mods = 'LEADER',
		action = wezterm.action.ActivatePaneDirection('Up'),
	},
	{
		key = 'l',
		mods = 'LEADER',
		action = wezterm.action.ActivatePaneDirection('Right'),
	},
	{
		key = 'p',
		mods = 'LEADER',
		action = wezterm.action.PaneSelect,
	},

	-- Meant for fish to handle these sequence of keys
	-- https://fishshell.com/docs/current/interactive.html#emacs-mode-commands
	{
		key = 'Enter',
		mods = 'CMD',
		action = wezterm.action.SendKey({ key = 'Enter', mods = 'OPT' }),
	},
	{
		key = 'Enter',
		mods = 'OPT',
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = 'Enter',
		mods = 'CTRL',
		action = wezterm.action.SendKey({ key = 'Enter', mods = 'OPT' }),
	},
	{
		key = 'Enter',
		mods = 'SHIFT',
		action = wezterm.action.SendKey({ key = 'Enter', mods = 'OPT' }),
	},

	{
		key = 'Backspace',
		mods = 'CMD',
		action = wezterm.action.SendKey({ key = 'u', mods = 'CTRL' }),
	},
	{
		key = 'Backspace',
		mods = 'CTRL',
		action = wezterm.action.SendKey({ key = 'k', mods = 'CTRL' }),
	},
	{
		key = 'Backspace',
		mods = 'SHIFT',
		action = wezterm.action.SendKey({ key = 'Backspace', mods = 'OPT' }),
	},

	{
		key = 'LeftArrow',
		mods = 'CMD',
		action = wezterm.action.SendKey({ key = 'a', mods = 'CTRL' }),
	},
	{
		key = 'RightArrow',
		mods = 'CMD',
		action = wezterm.action.SendKey({ key = 'e', mods = 'CTRL' }),
	},

	-- Misc re-mappings
	{
		key = 'm', -- For full "menu"
		mods = 'CMD',
		action = wezterm.action.ShowLauncher,
	},
	{
		key = 'd',
		mods = 'CMD',
		action = wezterm.action.ShowDebugOverlay,
	},
	{
		key = 'f',
		mods = 'CMD|SHIFT',
		action = wezterm.action.ToggleFullScreen,
	},
	{
		key = 'v', -- For "visual" or "VIM" mode
		mods = 'LEADER',
		action = wezterm.action.ActivateCopyMode,
	},
	{
		key = 'q',
		mods = 'LEADER',
		action = wezterm.action.QuickSelect,
	},
	{
		key = 'r',
		mods = 'CMD|SHIFT',
		action = wezterm.action.ReloadConfiguration,
	},

	{
		key = 'v',
		mods = 'CMD|SHIFT',
		action = wezterm.action.PasteFrom('Clipboard'),
	},
	{
		key = 'c',
		mods = 'CMD|SHIFT',
		action = wezterm.action.CopyTo('Clipboard'),
	},
}

-- Most come from neovim config
local swap_cmd_and_control_keys = {
	'a',
	'h',
	'j',
	'k',
	'l',
	'p', -- Useful in shell for getting prior command
	'n', -- Useful in shell for getting next command
	'r', -- Useful in shell for searching back for a command
	's',
	'v',
	'x',
	'y',
}

for _, letter in ipairs(swap_cmd_and_control_keys) do
	table.insert(keys, {
		key = letter,
		mods = 'CMD',
		action = wezterm.action.SendKey({ key = letter, mods = 'CTRL' }),
	})
end

local key_tables = {
	resize_pane = {
		{
			key = 'h',
			action = wezterm.action.AdjustPaneSize({ 'Left', 1 }),
		},
		{
			key = 'j',
			action = wezterm.action.AdjustPaneSize({ 'Down', 1 })
		},
		{
			key = 'k',
			action = wezterm.action.AdjustPaneSize({ 'Up', 1 })
		},
		{
			key = 'l',
			action = wezterm.action.AdjustPaneSize({ 'Right', 1 })
		},
		{
			-- Cancel the mode by pressing escape
			key = 'Escape',
			action = 'PopKeyTable'
		},
	},
	activate_tab = {},
}

local center_keyboard_row = {
	'a',
	's',
	'd',
	'f',
	'g',
	'h',
	'j',
	'k',
	'l',
}

for index, letter in ipairs(center_keyboard_row) do
	table.insert(key_tables.activate_tab, {
		key = letter,
		action = wezterm.action.ActivateTab(index - 1)
	})
end

function M.apply_to_config(config)
	config.leader = leader
	config.keys = keys
	config.key_tables = key_tables
end

return M
