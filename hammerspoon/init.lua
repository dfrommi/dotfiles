--
-- Environment setup
--
local log=hs.logger.new('init','verbose')
local browser = hs.urlevent.getDefaultHandler("http")
local browserName = browser == 'com.google.chrome' and 'Google Chrome' or 'Safari'

--
-- Umlaut
--
function keyStroke(text)
  return function() hs.eventtap.keyStrokes(text) end
end

hs.hotkey.bind({'alt'},          'a', nil, keyStroke('ä'), nil, nil)
hs.hotkey.bind({'alt', 'shift'}, 'a', nil, keyStroke('Ä'), nil, nil)
hs.hotkey.bind({'alt'},          'u', nil, keyStroke('ü'), nil, nil)
hs.hotkey.bind({'alt', 'shift'}, 'u', nil, keyStroke('Ü'), nil, nil)
hs.hotkey.bind({'alt'},          'o', nil, keyStroke('ö'), nil, nil)
hs.hotkey.bind({'alt', 'shift'}, 'o', nil, keyStroke('Ö'), nil, nil)
hs.hotkey.bind({'alt'},          's', nil, keyStroke('ß'), nil, nil)
hs.hotkey.bind({'alt'},          'e', nil, keyStroke('€'), nil, nil)

--
-- CapsLock as Hyper
--
function launch(appname, modal)
  hs.application.launchOrFocus(appname)
  modal.triggered = true
end

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
    hs.eventtap.keyStroke({"cmd","alt","shift","ctrl"}, 'SPACE')
  end
end

-- Bind the Hyper key (as mapped in Karabiner)
hs.hotkey.bind({}, 'F19', pressedHyper, releasedHyper)

---
--- Right CMD as Hammerspoon trigger key
---
cmdR_k = hs.hotkey.modal.new()

singleapps = {
  {'e', 'Visual Studio Code'},
  {'b', browserName},
  {'t', 'Trello'},
  {'f', 'Franz'},
  {'m', 'Spotify'},
  {'i', 'IntelliJ IDEA'}
}

for i,app in ipairs(singleapps) do
  cmdR_k:bind({}, app[1], function() launch(app[2], cmdR_k); cmdR_k.triggered = true; end)
end

-- 1Password shortcut
cmdR_k:bind({}, '\\', function() hs.eventtap.keyStroke({'cmd', 'alt'}, '\\'); cmdR_k.triggered = true; end)

-- lock screen shortcut
cmdR_k:bind({}, 'l', function() hs.caffeinate.lockScreen(); cmdR_k.triggered = true; end)


pressedCmdR = function()
  cmdR_k.triggered = false
  cmdR_k:enter()
end

releasedCmdR = function()
  cmdR_k:exit()
  if not cmdR_k.triggered then
    --hs.eventtap.keyStroke({}, 'F16')
    launch('iTerm', cmdR_k)
  end
end

-- Bind the Hyper key (as mapped in Karabiner)
hs.hotkey.bind({}, 'F17', pressedCmdR, releasedCmdR)
