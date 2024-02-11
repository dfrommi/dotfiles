local M = {}

local log = hs.logger.new("menubar")

local app = require("apps.core")
local colors = require("colors")

local exe = "/opt/homebrew/bin/sketchybar"

local function execute(commands)
	local commandLine = exe .. " " .. table.concat(commands, " ")
	log.i("Executing " .. commandLine)
	local _, status = hs.execute(commandLine)

	if status then
		log.i("Update successful")
	else
		log.w("Failed updating Sketchybar")
	end
end

local function setItem(name, options)
	local params = {}
	for k, v in pairs(options) do
		table.insert(params, k .. "='" .. v .. "'")
	end

	return "--set " .. name .. " " .. table.concat(params, " ")
end

local function apply_tab_update(tabs)
	local commands = {}

	for i = 1, 9 do
		local tab = tabs[i]
		local command = ""
		if tab then
			command = setItem("tab." .. i, {
				label = tab.title,
				["icon.color"] = tab.is_active and colors.white or colors.grey,
				["label.color"] = tab.is_active and colors.blue or colors.grey,
				--["background.border_color"] = tab.is_active and colors.blue or colors.bg1,
				--["label.font.style"] = tab.is_active and "bold" or "regular",
				drawing = "on",
			})
		else
			command = setItem("tab." .. i, { drawing = "off" })
		end

		table.insert(commands, command)
	end

	execute(commands)
end

function M.refresh_tabs()
	local focusedApp = app.focused()

	local tabs = {}
	if focusedApp and focusedApp["tabs"] then
		tabs = focusedApp:tabs()
	end

	apply_tab_update(tabs)
end

local wf = hs.window.filter
wf.default:subscribe(wf.windowFocused, function(window)
	log.i("Focused " .. hs.inspect.inspect(window))
	M.refresh_tabs()
end)

return M
