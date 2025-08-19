local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

M.quick_select_url_and_open = wezterm.action.QuickSelectArgs({
	label = "open url",
	patterns = { "https?://\\S+" }, -- override matches just to http(s) links
	skip_action_on_paste = true,
	action = wezterm.action_callback(function(window, pane)
		local url = window:get_selection_text_for_pane(pane)
		if url and #url > 0 then
			wezterm.open_with(url) -- default browser
		end
	end),
})

wezterm.on("scrollback-to-nvim", function(window, pane)
	local rows = pane:get_dimensions().scrollback_rows
	local text = pane:get_lines_as_text(rows) or ""
	if text == "" then
		window:toast_notification("WezTerm", "Scrollback is empty", nil, 2000)
		return
	end

	-- Write to a temp file (macOS: lives under /var/folders...)
	local tmp = os.tmpname()
	local f = io.open(tmp, "w")
	if not f then
		window:toast_notification("WezTerm", "Failed to create temp file", nil, 2500)
		return
	end
	f:write(text)
	f:close()

	-- Open Neovim in a right split; read-only, no swap; enable system clipboard
	local cmd =
		string.format([[nvim -R -n -c 'set clipboard=unnamedplus' -c 'file Scrollback' -c 'normal! GH' %q]], tmp)

	window:perform_action(
		act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
			command = { args = { "/opt/homebrew/bin/fish", "-l", "-c", cmd } },
		}),
		pane
	)
end)

M.scrollback_to_nvim = act.EmitEvent("scrollback-to-nvim")

return M
