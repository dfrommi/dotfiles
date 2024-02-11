local M = {}

local log = hs.logger.new("yabai")

function M.m(commands)
	for _, cmd in ipairs(commands) do
		log.d("Sending message: " .. cmd)
		os.execute("/opt/homebrew/bin/yabai -m " .. cmd)
	end
end

function M.current_space_info()
	local info, _ = hs.execute("/opt/homebrew/bin/yabai -m query --spaces --space")
	return hs.json.decode(info)
end

function M.stacked()
	return M.current_space_info()["type"] ~= "bsp"
end

function M.goToSpace(nameOrId)
	M.m({ "space --focus " .. nameOrId })
end

function M.moveToSpace(nameOrId)
	M.m({ "window --space " .. nameOrId, "space --focus " .. nameOrId })
end

function M.leftOrFirst()
	M.m({ "window --focus " .. (M.stacked() and "stack.first" or "west") })
end

function M.downOrNext()
	M.m({ "window --focus " .. (M.stacked() and "stack.next" or "south") })
end

function M.upOrPrev()
	M.m({ "window --focus " .. (M.stacked() and "stack.prev" or "north") })
end

function M.rightOrLast()
	M.m({ "window --focus " .. (M.stacked() and "stack.last" or "east") })
end

function M.stack()
	M.m({ "space --layout stack" })
end

function M.unstack()
	M.m({ "space --layout bsp" })
end

function M.rotate()
	M.m({ "space --rotate 270" })
end

function M.rotateBack()
	M.m({ "space --rotate 90" })
end

function M.prevSpace()
	M.m({ "space --focus recent" })
end

function M.equalSize()
	M.m({ "space --balance" })
end

function M.toggleFloat()
	M.m({ "window --toggle float", "window --grid 4:4:1:1:2:2" })
end

return M
