--
-- Umlaut
--
function keyCode(text)
  return function() hs.eventtap.keyStrokes(text) end
end

hs.hotkey.bind({'alt'},          'a', nil, keyCode('ä'), nil, nil)
hs.hotkey.bind({'shift', 'alt'}, 'a', nil, keyCode('Ä'), nil, nil)
hs.hotkey.bind({'alt'},          'u', nil, keyCode('ü'), nil, nil)
hs.hotkey.bind({'shift', 'alt'}, 'u', nil, keyCode('Ü'), nil, nil)
hs.hotkey.bind({'alt'},          'o', nil, keyCode('ö'), nil, nil)
hs.hotkey.bind({'shift', 'alt'}, 'o', nil, keyCode('Ö'), nil, nil)
hs.hotkey.bind({'alt'},          's', nil, keyCode('ß'), nil, nil)
hs.hotkey.bind({'alt'},          'e', nil, keyCode('€'), nil, nil)

--
-- CapsLock as Hyper
--

-- A global variable for the Hyper Mode
hyper_k = hs.hotkey.modal.new()

-- create binding for all externally used Hyper key bindings
mappedHyperKeys = {'i', 'v', '/'}
for k,v in ipairs(mappedHyperKeys) do
  hyper_k:bind({}, v, nil, function()
    hs.eventtap.keyStroke({"cmd","alt","shift","ctrl"}, v)
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

---
--- Right CMD as Hammerspoon trigger key
---
cmdR_k = hs.hotkey.modal.new()

function launch(appname)
  hs.application.launchOrFocus(appname)
  cmdR_k.triggered = true
end

singleapps = {
  {'e', 'Atom'},
  {'b', 'Google Chrome'},
  {'t', 'iTerm'}
}

for i,app in ipairs(singleapps) do
  cmdR_k:bind({}, app[1], function() launch(app[2]); cmdR_k:exit(); end)
end

pressedCmdR = function()
  cmdR_k.triggered = false
  cmdR_k:enter()
end

releasedCmdR = function()
  cmdR_k:exit()
  if not cmdR_k.triggered then
    --hs.eventtap.keyStroke({}, 'F16')
    launch('iTerm')
  end
end

-- Bind the Hyper key (as mapped in Karabiner)
hs.hotkey.bind({}, 'F17', pressedCmdR, releasedCmdR)
