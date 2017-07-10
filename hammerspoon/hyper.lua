--
-- CapsLock as Hyper
--

local hyper_mash = {"cmd","alt","shift","ctrl"}

-- A global variable for the Hyper Mode
local hyper_k = hs.hotkey.modal.new()

-- create binding for all externally used Hyper key bindings
local mappedHyperKeys = {'i', 'v', '/', 'j', 'k', 'l'}
for k,v in ipairs(mappedHyperKeys) do
  hyper_k:bind({}, v, nil, function()
    hs.eventtap.keyStroke(hyper_mash, v)
    hyper_k.triggered = true
  end)
end

-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
pressedHyper = function()
  hyper_k.triggered = false
  hyper_k:enter()
end

-- Leave Hyper Mode when CapsLock is released,
-- send F18 if no other keys are pressed.
releasedHyper = function()
  hyper_k:exit()
  if not hyper_k.triggered then
    hs.eventtap.keyStroke({}, 'F18')
  end
end

-- Bind the Hyper key (as mapped in Karabiner)
hs.hotkey.bind({}, 'F19', pressedHyper, releasedHyper)
