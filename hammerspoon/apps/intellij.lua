local obj = {}
obj.__index = obj

local log = hs.logger.new("intellij")

function obj.new(app)
	local self = setmetatable({}, obj)
	self.app = app
	return self
end

function obj:findBuffer()
	hs.eventtap.keyStroke({ "cmd", "shift" }, "a", nil, self.app)
end

return obj
