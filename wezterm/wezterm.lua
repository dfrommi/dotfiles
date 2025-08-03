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

	enable_tab_bar = true,
	use_fancy_tab_bar = false,
	show_tabs_in_tab_bar = true,
	show_new_tab_button_in_tab_bar = false,
	font_size = 14.0,
	font = wezterm.font("Hack Nerd Font Mono"),

	window_decorations = "RESIZE",

	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},

	status_update_interval = 1000,

	-- Multiplexing configuration
	default_workspace = "main",
	max_fps = 60,
	
	-- Tab bar styling
	tab_bar_at_bottom = false,
	hide_tab_bar_if_only_one_tab = false,
	tab_max_width = 32,
}

config.disable_default_key_bindings = true

-- Leader key mode (like tmux)
config.leader = { key = "\\", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
	-- Tab navigation
	{ key = "[", mods = "CMD", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "]", mods = "CMD", action = wezterm.action.ActivateTabRelative(1) },

	-- New tab/window
	{ key = "n", mods = "CMD", action = wezterm.action.SpawnTab("CurrentPaneDomain") },

	-- Split panes
	{ key = "'", mods = "CMD", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = " ", mods = "CMD", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Navigate panes (vim-style hjkl)
	{ key = "h", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Right") },

	-- Workspace management
	{ key = "w", mods = "CMD", action = wezterm.action.ShowLauncherArgs({ flags = "WORKSPACES" }) },
	{
		key = "w",
		mods = "CMD|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter name for new workspace",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(wezterm.action.SwitchToWorkspace({ name = line }), pane)
				end
			end),
		}),
	},
	{ key = "[", mods = "CMD|SHIFT", action = wezterm.action.SwitchWorkspaceRelative(-1) },
	{ key = "]", mods = "CMD|SHIFT", action = wezterm.action.SwitchWorkspaceRelative(1) },

	-- Close tab/pane
	{ key = "x", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },

	-- Leader key commands
	{ key = "r", mods = "LEADER", action = wezterm.action.PromptInputLine({
		description = "Enter new tab title:",
		action = wezterm.action_callback(function(window, pane, line)
			if line then
				window:active_tab():set_title(line)
			end
		end),
	}) },
	{ key = "R", mods = "LEADER|SHIFT", action = wezterm.action.PromptInputLine({
		description = "Enter new workspace name:",
		action = wezterm.action_callback(function(window, pane, line)
			if line then
				window:perform_action(wezterm.action.SwitchToWorkspace({ name = line }), pane)
			end
		end),
	}) },

	-- Copy/paste
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

-- Catppuccin Mocha colors
local colors = {
	rosewater = "#f5e0dc",
	flamingo = "#f2cdcd",
	pink = "#f5c2e7",
	mauve = "#cba6f7",
	red = "#f38ba8",
	maroon = "#eba0ac",
	peach = "#fab387",
	yellow = "#f9e2af",
	green = "#a6e3a1",
	teal = "#94e2d5",
	sky = "#89dceb",
	sapphire = "#74c7ec",
	blue = "#89b4fa",
	lavender = "#b4befe",
	text = "#cdd6f4",
	subtext1 = "#bac2de",
	subtext0 = "#a6adc8",
	overlay2 = "#9399b2",
	overlay1 = "#7f849c",
	overlay0 = "#6c7086",
	surface2 = "#585b70",
	surface1 = "#45475a",
	surface0 = "#313244",
	base = "#1e1e2e",
	mantle = "#181825",
	crust = "#11111b",
}

local function tab_title(tab_info)
	local title = tab_info.tab_title
	if title and #title > 0 then
		return title
	end
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local edge_background = colors.base
	local background = colors.surface0
	local foreground = colors.text

	if tab.is_active then
		background = colors.mauve
		foreground = colors.base
	elseif hover then
		background = colors.surface1
		foreground = colors.text
	end

	local edge_foreground = background

	local title = tab_title(tab)
	title = wezterm.truncate_right(title, max_width - 2)

	return {
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = "" },
		{ Background = { Color = background } },
		{ Foreground = { Color = foreground } },
		{ Text = " " .. title .. " " },
		{ Background = { Color = edge_background } },
		{ Foreground = { Color = edge_foreground } },
		{ Text = "" },
	}
end)

wezterm.on("update-right-status", function(window, pane)
	local current_workspace = window:active_workspace()
	local workspace_names = wezterm.mux.get_workspace_names()
	
	local elements = {}
	
	for i, name in ipairs(workspace_names) do
		local is_active = name == current_workspace
		local bg_color = is_active and colors.mauve or colors.surface1
		local fg_color = is_active and colors.base or colors.text
		
		-- Add left-pointing separator
		table.insert(elements, { Background = { Color = colors.base } })
		table.insert(elements, { Foreground = { Color = bg_color } })
		table.insert(elements, { Text = "" })
		
		-- Add workspace name
		table.insert(elements, { Background = { Color = bg_color } })
		table.insert(elements, { Foreground = { Color = fg_color } })
		table.insert(elements, { Text = " " .. name .. " " })
	end

	window:set_right_status(wezterm.format(elements))
end)

return config
