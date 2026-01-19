local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.window_decorations = "RESIZE"
config.colors = {
	cursor_bg = '#C7C7C7',
	cursor_fg = '#FFFFFF',
}

config.unix_domains = {
	{
		name = 'local-domain',
	},
	{
		name = 'custom_ssh_domain',
		--[[ Having a `unix_domain` instead of an `ssh_domain` is a hack
		It is needed because the cloud desktop uses wssh as a proxy

		References:
		https://github.com/wezterm/wezterm/issues/3437#issuecomment-1494628747

		I could not get it to work with native `ssh_domain`.
		This approach is very reliable. Just as reliable as an ad-hoc ssh.
		]]
		proxy_command = {
			'ssh',
			'-o',
			'RemoteCommand=none',
			'-T',
			'-A',
			'clouddesk',
			'wezterm',
			'cli',
			'proxy'
		},
	},
}

config.default_gui_startup_args = { 'connect', 'local-domain' }

-- Disable Font Ligatures
-- https://wezterm.org/config/font-shaping.html
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

require('keyboard_shortcuts').apply_to_config(config)

return config
