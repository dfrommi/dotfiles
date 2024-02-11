local cmdR = require("util.leader").new("f17")

local sk = spoon.RecursiveBinder.singleKey
local yabai = require("util.yabai")
local obsidian = require("apps.obsidian").new(nil) --TODO
local app = require("apps.core")
local launch = app.launch

local intellij = hs.application.nameForBundleID("com.jetbrains.intellij.ce") == nil and "IntelliJ IDEA"
	or "IntelliJ IDEA CE"

cmdR:mod("a", function()
	launch("Kitty")
end)
cmdR:mod("a", function()
	launch("Safari")
end)
cmdR:mod("d", function()
	launch(intellij)
end)

cmdR:mod("return", function()
	yabai.goToSpace("misc")
end)
cmdR:modShift("return", function()
	yabai.moveToSpace("misc")
end)

-- Clipboard history Alfred
cmdR:mod("v", function()
	hs.eventtap.keyStroke({ "cmd", "alt", "shift", "ctrl" }, "v")
end)

local keys = {
	[sk("g", "Goto+")] = {
		[sk("t", "Terminal")] = function()
			launch("Kitty")
		end,
		[sk("b", "Browser")] = function()
			launch("Safari")
		end,
		[sk("i", "IntelliJ")] = function()
			launch(intellij)
		end,
		[sk("n", "Obsidian")] = function()
			launch("Obsidian")
		end,
		[sk("N", "New note")] = obsidian.createNote,
		[sk("1", "Space 1")] = function()
			yabai.goToSpace(1)
		end,
		[sk("2", "Space 2")] = function()
			yabai.goToSpace(2)
		end,
		[sk("3", "Space 3")] = function()
			yabai.goToSpace(3)
		end,
		[sk("4", "Space 4")] = function()
			yabai.goToSpace(4)
		end,
		[sk("5", "Space 5")] = function()
			yabai.goToSpace(5)
		end,
	},
	[sk("w", "Window+")] = {
		[sk("h", "left/first")] = yabai.leftOrFirst,
		[sk("j", "down/next")] = yabai.downOrNext,
		[sk("k", "up/prev")] = yabai.upOrPrev,
		[sk("l", "right/last")] = yabai.rightOrLast,
		[sk("=", "equal size")] = yabai.equalSize,
		[sk("r", "rotate")] = yabai.rotate,
		[sk("R", "rotate back")] = yabai.rotateBack,
		[sk("s", "stack")] = yabai.stack,
		[sk("S", "unstack")] = yabai.unstack,
		[sk("1", "Move to 1")] = function()
			yabai.moveToSpace(1)
		end,
		[sk("2", "Move to 2")] = function()
			yabai.moveToSpace(2)
		end,
		[sk("3", "Move to 3")] = function()
			yabai.moveToSpace(3)
		end,
		[sk("4", "Move to 4")] = function()
			yabai.moveToSpace(4)
		end,
		[sk("5", "Move to 5")] = function()
			yabai.moveToSpace(5)
		end,
	},
	--double tap
	[sk("f17", "Prev")] = yabai.prevSpace,

	[sk("f", "Find+")] = {
		[sk("b", "buffer")] = function()
			app.selectForFocused("findBuffer")
		end,
	},
}

local leaderBindings = spoon.RecursiveBinder.recursiveBind(keys, 3)
cmdR:tap(leaderBindings)
