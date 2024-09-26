local wezterm = require("wezterm")

local config = {
	default_prog = { "/opt/homebrew/bin/fish", "-l" },
	color_scheme = "Catppuccin Mocha",

	enable_tab_bar = false,
	font_size = 14.0,
	font = wezterm.font("Hack Nerd Font Mono"),

	window_decorations = "RESIZE",

	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}

local tmux = function(mods, key, target)
	local act = wezterm.action

	return {
		key = key,
		mods = mods,
		action = act.Multiple({
			act.SendKey({ key = "b", mods = "CTRL" }),
			act.SendKey({ key = target }),
		}),
	}
end

config.disable_default_key_bindings = true
-- config.debug_key_events = true
config.keys = {
	{ mods = "CMD", key = " ", action = wezterm.action.SendKey({ mods = "CTRL", key = "b" }) },
	tmux("CMD", "[", "n"),
	tmux("CMD", "]", "o"),
	tmux("CMD", "n", "w"),
	-- {} as [] is not working
	tmux("CMD|SHIFT", "{", "e"),
	tmux("CMD|SHIFT", "}", "i"),
	tmux("CMD|SHIFT", "n", "W"),
	tmux("CMD", "l", "/"),
	{ key = "c", mods = "SUPER", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "v", mods = "SUPER", action = wezterm.action.PasteFrom("Clipboard") },
}

config.mouse_bindings = {
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

return config
