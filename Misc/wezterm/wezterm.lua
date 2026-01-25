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

--[[
Enable OSC52 clipboard querying (on this domain only). See:
1. https://github.com/wezterm/wezterm/pull/6239
2. https://github.com/Lenbok/wezterm/tree/osc52-read

Steps to getting remote OSC52 clipboard pasting to work:
1. Build from source on Macbook
  - Git clone https://github.com/Lenbok/wezterm
  - cd wezterm
  - git checkout osc52-read
  - cargo build --release
  - ./ci/deploy.sh # This will create a folder like WezTerm-macos-*
  - cd WezTerm-macos-*
  - cp -r WezTerm.app /Applications/
  - # Remove the git clone folder
  - # Create symlinks so the wezterm CLIs are on the path
  - # Create a symlink so the shell gets wezterm CLI completions
2. Build from source on remote machine
  - Git clone https://github.com/Lenbok/wezterm
  - cd wezterm
  - git checkout osc52-read
  - ./get-deps
  - cargo build --release
  - cd target/release
  - # cp the following to somewhere on the PATH:
    - strip-ansi-escapes
	- wezterm
	- wezterm-gui
	- wezterm-mux-server
  - # cp wezterm CLI shell completions
  - # Remove the git clone folder
3. Enable the configuration feature below on the remote wezterm config

Only uncomment the configuration feature below if:
1. This version of wezterm is built-from-source from the branch above
2. This domain needs to use OSC52 pasting
  - Not needed on local Macbook, because local neovim can use `pbpaste`
  - Only enable on local Macbook if OSC52 pasting in ad-hoc SSH (sus)
  - I advise only enabling in configurations on remote wezterm domains
]]
-- config.enable_osc52_clipboard_reading = true

require('keyboard_shortcuts').apply_to_config(config)

return config
