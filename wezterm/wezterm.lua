local wezterm = require("wezterm")

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

function set_appearance_in_shell(apearance)
	wezterm.background_child_process({
		"/opt/homebrew/bin/fish",
		"-c",
		"theme_mode " .. apearance,
	})
end

function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		set_appearance_in_shell("dark")
		return "Catppuccin Mocha"
	else
		set_appearance_in_shell("light")
		return "Catppuccin Latte"
	end
end

local config = {
	--default_prog = { "/opt/homebrew/bin/fish", "-l" },
	--color_scheme = "Catppuccin Mocha",
	--color_scheme = "Catppuccin Latte",

	color_scheme = scheme_for_appearance(get_appearance()),

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
			act.SendKey({ key = "\\", mods = "CTRL" }),
			act.SendKey({ key = target }),
		}),
	}
end

config.disable_default_key_bindings = true
-- config.debug_key_events = true
config.keys = {
	-- { mods = "CMD", key = " ", action = wezterm.action.SendKey({ mods = "CTRL", key = "b" }) },
	tmux("CMD", "[", "n"),
	tmux("CMD", "]", "o"),
	tmux("CMD", "n", "w"),
	tmux("CMD", "'", "b"),
	tmux("CMD", " ", " "),
	-- {} as [] is not working
	tmux("CMD|SHIFT", "{", "e"),
	tmux("CMD|SHIFT", "}", "i"),
	tmux("CMD|SHIFT", "n", "W"),
	tmux("CMD", "l", "/"),
	--copy/paste with cmd c/v
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
