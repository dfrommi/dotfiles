local obj = {}
obj.__index = obj

local log = hs.logger.new("leader")

local pressed = function(self)
	self.triggered = false
	self.modal:enter()
end

local released = function(self)
	self.modal:exit()
	if not self.triggered and self.handler then
		self.handler()
	end
	self.triggered = false
end

function obj.new(key)
	local self = setmetatable({}, obj)

	self.key = key
	self.modal = hs.hotkey.modal.new()
	self.triggered = false
	self.hander = nil

	hs.hotkey.bind({}, key, function()
		pressed(self)
	end, function()
		released(self)
	end)

	return self
end

function obj:tap(action)
	self.handler = action
end

function obj:mod(key, action)
	self.modal:bind({}, key, function()
		action()
		self.triggered = true
	end)
end

function obj:modShift(key, action)
	self.modal:bind({ "shift" }, key, function()
		action()
		self.triggered = true
	end)
end

return obj
