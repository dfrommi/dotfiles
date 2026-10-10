hs.logger.defaultLogLevel = "debug"
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true

spoon.SpoonInstall:andUse("EmmyLua")

local log = hs.logger.new("main")

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
