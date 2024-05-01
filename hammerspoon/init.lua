hs.logger.defaultLogLevel = "debug"
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true

require("hs.ipc")
if not hs.ipc.cliStatus("/opt/homebrew") then
	hs.ipc.cliInstall("/opt/homebrew")
end

spoon.SpoonInstall:andUse("EmmyLua")

spoon.SpoonInstall:andUse("RecursiveBinder")
-- spoon.RecursiveBinder.escapeKey = { {}, "escape" } -- Press escape to abort

local log = hs.logger.new("main")

require("keys.umlaut")
require("keys.cmd_r")
require("keys.trigger")
-- require("menubar.init")

-- Show minimized window when app receives focus
hs.application.watcher
	.new(function(name, event, app)
		if event == hs.application.watcher.activated and app:focusedWindow() == nil then
			local firstWindow = app:allWindows()[1]
			if firstWindow then
				log.d("Unminimizing window of " .. name)
				firstWindow:focus()
				firstWindow:unminimize()
			end
		end
	end)
	:start()
