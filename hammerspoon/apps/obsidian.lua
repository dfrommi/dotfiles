local obj = {}
obj.__index = obj

local log = hs.logger.new("obsidian")

local vaultsPath = "/Users/dennis/Library/Mobile Documents/iCloud~md~obsidian/Documents"

function obj.new(app)
	local self = setmetatable({}, obj)
	self.app = app
	return self
end

function obj:findBufferKeyCombo()
	hs.eventtap.keyStroke({ "cmd" }, "p", nil, self.app)
end

function obj.createNote()
	hs.urlevent.openURL("obsidian://new?vault=Brain")
end

return obj
