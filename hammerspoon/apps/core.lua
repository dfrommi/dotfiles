local M = {}

local Safari = require("apps.safari")
local IntelliJ = require("apps.intellij")
local Obsidian = require("apps.obsidian")

function M.launch(appname)
	local app = hs.application.find(appname)

	if app then
		app:mainWindow():focus()
	else
		hs.application.launchOrFocus(appname)
	end
end

function M.of(app)
	if app:name() == "Safari" then
		return Safari.new()
	elseif app:bundleID() == "com.jetbrains.intellij.ce" then
		return IntelliJ.new(app)
	elseif app:bundleID() == "md.obsidian" then
		return Obsidian.new(app)
	end
end

function M.focused()
	local app = hs.application.frontmostApplication()
	return M.of(app)
end

function M.selectForFocused(name)
	local activeApp = M.focused()

	if activeApp[name] then
		activeApp[name](activeApp)
		return
	end

	local choicesName = name .. "Choices"
	local choicesSelectName = name .. "Selected"

	if not activeApp[choicesName] then
		return
	end

	local chooser = hs.chooser.new(function(choice)
		if choice and activeApp[choicesSelectName] then
			activeApp[choicesSelectName](activeApp, choice)
		end
	end)

	chooser:choices(activeApp[choicesName](activeApp))
	chooser:show()
end

return M
