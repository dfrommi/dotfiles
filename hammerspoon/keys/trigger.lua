local alfred = require("util.leader").new("f19")

for _, k in ipairs({ "i", "v", "/", "d" }) do
	alfred:mod(k, function()
		hs.eventtap.keyStroke({ "cmd", "alt", "shift", "ctrl" }, k)
	end)
end

alfred:tap(function()
	hs.eventtap.keyStroke({ "cmd", "alt", "shift", "ctrl" }, "SPACE")
end)
