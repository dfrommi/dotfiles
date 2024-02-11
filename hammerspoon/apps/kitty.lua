local obj = {}
obj.__index = obj

local log = hs.logger.new("kitty")

function obj.new(app)
	local self = setmetatable({}, obj)
	self.pid = app:pid()
	return self
end

function obj:kitten(cmd)
	log.i("executing kitten " .. cmd)
	local info, ok =
		hs.execute("/Applications/kitty.app/Contents/MacOS/kitten @ --to unix:/tmp/.kitty-" .. self.pid .. " " .. cmd)
	return info, ok
end

function obj:tabs()
	local info, ok = self:kitten("ls")
	if ok == nil then
		log.w("Error listing Kitty-tabs")
		return {}
	end

	local result = hs.json.decode(info)
	local items = {}

	for _, window in ipairs(result) do
		if window.is_focused then
			for _, tab in ipairs(window.tabs) do
				table.insert(items, {
					id = { window_id = window.id, tab_id = tab.id },
					title = tab.title,
					is_active = tab.is_focused,
				})
			end
		end
	end

	return items
end

function obj:findBufferChoices()
	local choices = {}
	for _, tab in ipairs(self:tabs()) do
		if not tab.is_active then
			table.insert(choices, {
				["text"] = tab.title,
				["kitten"] = {
					"focus-window -m id:" .. tab.id.window_id,
					"focus-tab -m id:" .. tab.id.tab_id,
				},
			})
		end
	end

	return choices
end

function obj:findBufferSelected(choice)
	log.d("Kitty action selected: " .. hs.inspect.inspect(choice))
	if choice.kitten then
		for _, cmd in ipairs(choice.kitten) do
			self:kitten(cmd)
		end
	end
end

return obj
