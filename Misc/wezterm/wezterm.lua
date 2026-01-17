local wezterm = require('wezterm')

local config = wezterm.config_builder()

config.window_decorations = "RESIZE"
config.colors = {
	cursor_bg = '#C7C7C7',
	cursor_fg = '#FFFFFF',
}

-- Disable Font Ligatures
-- https://wezterm.org/config/font-shaping.html
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

require('keyboard_shortcuts').apply_to_config(config)

return config
