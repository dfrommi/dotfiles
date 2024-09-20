local wezterm = require("wezterm")

local config = {
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

config.disable_default_key_bindings = true

local tmux = function(mods, key, target)
	local act = wezterm.action

	return {
		key = key,
		mods = mods,
		action = act.Multiple({
			act.SendKey({ key = "a", mods = "CTRL" }),
			act.SendKey({ key = target }),
		}),
	}
end

config.keys = {
	tmux("CMD", "[", "n"),
	tmux("CMD", "]", "e"),
	tmux("CMD", "n", "t"),
	tmux("CMD|SHIFT", "[", "i"),
	tmux("CMD|SHIFT", "]", "o"),
	tmux("CMD|SHIFT", "n", "g"),
	tmux("CMD", "l", "/"),
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
