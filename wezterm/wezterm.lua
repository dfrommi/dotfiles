local wezterm = require("wezterm")

local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
local scrollback = require("scrollback")

local theme_name = "Catppuccin Mocha"

local function set_appearance_in_shell(apearance)
	wezterm.background_child_process({
		"/opt/homebrew/bin/fish",
		"-c",
		"theme_mode " .. apearance,
	})
end

local config = wezterm.config_builder()
config.color_scheme = theme_name

config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = true
config.show_new_tab_button_in_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = false
config.tab_max_width = 32

config.font_size = 14.0
config.font = wezterm.font("Hack Nerd Font Mono")

-- Ensure tab bar uses the same font with powerline support
config.window_frame = {
	font = wezterm.font("Hack Nerd Font Mono"),
	font_size = 14.0,
}

config.window_padding = {
	left = 20,
	right = 20,
	top = 20,
	bottom = 20,
}

config.window_decorations = "RESIZE"

local scheme = wezterm.get_builtin_color_schemes()["Catppuccin Mocha"]
-- scheme.tab_bar.background = "#1e1e2e"
config.color_schemes = {
	["Catppuccin Mocha"] = scheme,
	["Catppuccin Latte"] = wezterm.get_builtin_color_schemes()["Catppuccin Latte"],
}
set_appearance_in_shell("dark")

config.disable_default_key_bindings = true

-- Leader key mode (like tmux)
config.leader = { key = "\\", mods = "CTRL", timeout_milliseconds = 1000 }

local function basename(path)
	return path and path:match("[^/]+$")
end

local function process_matches(pane, process_name)
	local info = pane:get_foreground_process_info()
	if not info then
		return false
	end

	return basename(info.executable) == process_name
		or basename(info.name) == process_name
		or (info.argv and basename(info.argv[1]) == process_name)
end

local function activate_tab_with_process(window, pane, process_name)
	local active_cwd = pane:get_current_working_dir()
	if not active_cwd then
		return
	end

	local active_path = active_cwd.file_path
	if not active_path then
		return
	end

	for _, tab in ipairs(window:mux_window():tabs()) do
		for _, candidate in ipairs(tab:panes()) do
			local cwd = candidate:get_current_working_dir()

			if process_matches(candidate, process_name) and cwd and cwd.file_path == active_path then
				tab:activate()
				return
			end
		end
	end
end

local function activate_process_tab(process_name)
	return wezterm.action_callback(function(window, pane)
		activate_tab_with_process(window, pane, process_name)
	end)
end

config.keys = {
	-- Shift-Enter fix/workaound
	{
		key = "Enter",
		mods = "SHIFT",
		action = wezterm.action.SendString("\x1b[13;2u"),
	},

	-- Tab navigation
	{ key = "g", mods = "LEADER", action = activate_process_tab("lazygit") },
	{ key = "e", mods = "LEADER", action = activate_process_tab("nvim") },
	{ key = "p", mods = "LEADER", action = activate_process_tab("pi") },
	{ key = "[", mods = "CMD", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "]", mods = "CMD", action = wezterm.action.ActivateTabRelative(1) },
	{ key = "n", mods = "LEADER", action = wezterm.action.MoveTabRelative(-1) },
	{ key = "o", mods = "LEADER", action = wezterm.action.MoveTabRelative(1) },

	-- Workspace navigation
	{ key = "[", mods = "CMD|SHIFT", action = wezterm.action.SwitchWorkspaceRelative(-1) },
	{ key = "]", mods = "CMD|SHIFT", action = wezterm.action.SwitchWorkspaceRelative(1) },

	-- split
	{ key = "v", mods = "LEADER", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "s", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- Unsplit: move all panes into individual tabs
	{
		key = "u",
		mods = "LEADER",
		action = wezterm.action_callback(function(window, pane)
			local tab = window:active_tab()
			for _, p in ipairs(tab:panes()) do
				if p:pane_id() ~= pane:pane_id() then
					p:move_to_new_tab()
				end
			end
		end),
	},

	--search
	{
		key = "f",
		mods = "LEADER",
		action = wezterm.action.Search("CurrentSelectionOrEmptyString"),
	},

	-- Copy/paste
	{ key = "c", mods = "CMD", action = wezterm.action.CopyTo("Clipboard") },
	{ key = "v", mods = "CMD", action = wezterm.action.PasteFrom("Clipboard") },
	{
		key = "c",
		mods = "LEADER",
		action = wezterm.action.QuickSelect,
	},
	{
		key = "C",
		mods = "LEADER",
		action = wezterm.action.ActivateCopyMode,
	},
	{
		key = "x", -- like gx in vim
		mods = "LEADER",
		action = scrollback.quick_select_url_and_open,
	},
	{
		key = "V",
		mods = "LEADER",
		action = scrollback.scrollback_to_nvim,
		--action = wezterm.action.EmitEvent("scrollback-to-nvim"),
	},

	-- New tab/window
	{ key = "w", mods = "LEADER", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{
		key = "r",
		mods = "LEADER",
		action = wezterm.action.PromptInputLine({
			description = "Enter new tab title:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	-- Workspace management
	{
		key = "w",
		mods = "LEADER|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter name for new workspace",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(wezterm.action.SwitchToWorkspace({ name = line }), pane)
				end
			end),
		}),
	},
	{
		key = "r",
		mods = "LEADER|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter new workspace title:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_workspace():set_title(line)
				end
			end),
		}),
	},
}

-- WINDOW SPLITS
smart_splits.apply_to_config(config, {
	direction_keys = { "n", "e", "i", "o" },
	modifiers = {
		move = "CTRL",
		resize = "META",
	},
	log_level = "info",
})

-- MOUSE SUPPORT
config.mouse_bindings = {
	-- Ctrl-click will open the link under the mouse cursor
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = wezterm.action.OpenLinkAtMouseCursor,
	},
}

-- TAB BAR
-- colors: https://github.com/catppuccin/wezterm/blob/main/dist/catppuccin-mocha.toml
-- icons: https://wezterm.org/config/lua/wezterm/nerdfonts.html
wezterm.on("update-status", function(window, pane)
	local current_workspace = window:active_workspace()
	local workspace_names = wezterm.mux.get_workspace_names()

	local left = {
		{ Background = { Color = scheme.tab_bar.active_tab.bg_color } },
		{ Foreground = { Color = scheme.tab_bar.active_tab.fg_color } },
		{ Attribute = { Intensity = "Bold" } },
		{ Text = " " .. current_workspace .. " " },
		{ Background = { Color = scheme.tab_bar.active_tab.fg_color } },
		{ Foreground = { Color = scheme.tab_bar.active_tab.bg_color } },
		{ Attribute = { Intensity = "Normal" } },
		{ Text = wezterm.nerdfonts.pl_left_hard_divider .. "  " },
	}

	local right = {}
	for i, name in ipairs(workspace_names) do
		local is_active = name == current_workspace
		local colors = is_active and scheme.tab_bar.new_tab_hover or scheme.tab_bar.new_tab
		local intensity = is_active and "Bold" or "Normal"
		local marker = is_active and "*" or ""

		table.insert(right, { Foreground = { Color = colors.fg_color } })
		table.insert(right, { Background = { Color = colors.bg_color } })
		table.insert(right, { Attribute = { Intensity = intensity } })
		table.insert(right, { Text = " " .. name .. marker .. " " })
	end

	window:set_left_status(wezterm.format(left))
	window:set_right_status(wezterm.format(right))
end)

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local title = tab_title(tab)
	local fg_color = tab.is_active and scheme.ansi[3] or scheme.tab_bar.new_tab.fg_color
	local bg_color = tab.is_active and scheme.tab_bar.new_tab_hover.bg_color or scheme.tab_bar.new_tab.bg_color
	local tabbar_bg = scheme.tab_bar.background

	return {
		--{ Text = wezterm.nerdfonts.ple_upper_left_triangle .. " " },
		{ Background = { Color = tabbar_bg } },
		{ Text = " " },

		--{ Background = { Color = colors.bg_color } },
		{ Foreground = { Color = bg_color } },
		{ Text = wezterm.nerdfonts.ple_lower_right_triangle },

		{ Background = { Color = bg_color } },
		{ Foreground = { Color = fg_color } },
		{ Text = " " .. title .. " " },

		{ Foreground = { Color = bg_color } },
		{ Background = { Color = tabbar_bg } },
		{ Text = wezterm.nerdfonts.ple_upper_left_triangle },
	}
end)

return config
