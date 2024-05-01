--
-- Environment setup
--
local log=hs.logger.new('init','verbose')
local intellijName = hs.application.nameForBundleID('com.jetbrains.intellij.ce') == nil and 'IntelliJ IDEA' or 'IntelliJ IDEA CE'

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
  local app = hs.application.find(appname)
  
  if app then
    app:mainWindow():focus()
  else
    hs.application.launchOrFocus(appname)
  end

  modal.triggered = true
end

-- A global variable for the Hyper Mode
hyper_k = hs.hotkey.modal.new()

-- create binding for all externally used Hyper key bindings
mappedHyperKeys = {'i', 'v', '/', 'd'}
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
  {'b', 'Arc'},
  {'i', intellijName},
  {'t', 'Microsoft Teams'},
  {'o', 'Microsoft Outlook'},
  {'r', 'Rocket.Chat'}
}

for i,app in ipairs(singleapps) do
  cmdR_k:bind({}, app[1], function() launch(app[2], cmdR_k); cmdR_k.triggered = true; end)
end

-- 1Password shortcut
-- cmdR_k:bind({}, '\\', function() hs.eventtap.keyStroke({'cmd', 'alt'}, '\\'); cmdR_k.triggered = true; end)
-- cmdR_k:bind({}, 'p', function() hs.eventtap.keyStroke({'cmd', 'alt'}, 'p'); cmdR_k.triggered = true; end)
for i,key in ipairs({'p','v','k'}) do
  cmdR_k:bind({}, key, function() hs.eventtap.keyStroke({'cmd','alt','shift','ctrl'}, key); cmdR_k.triggered = true; end)
end

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
    launch('Kitty', cmdR_k)
  end
end

-- Bind the right command-key (as mapped in Karabiner)
hs.hotkey.bind({}, 'F17', pressedCmdR, releasedCmdR)


--
-- AviDemux special hotkeys
--
avidemuxHotkeys = {
  hs.hotkey.new(nil, "z", nil, function()
    hs.application.find("Avidemux2.8.app"):selectMenuItem({"Edit", "Set Marker A"})
  end),
  hs.hotkey.new(nil, "x", nil, function()
    hs.application.find("Avidemux2.8.app"):selectMenuItem({"Edit", "Delete"})
  end),
  hs.hotkey.new(nil, "c", nil, function()
    local app = hs.application.find("Avidemux2.8.app")
    app:selectMenuItem({"Edit", "Set Marker B"})
    app:selectMenuItem({"Edit", "Delete"})
  end)  
}

function enableAviDemuxBinds()
  for k,v in pairs(avidemuxHotkeys) do
    v:enable()
  end
end

function disableAviDemuxBinds()
  for k,v in pairs(avidemuxHotkeys) do
    v:disable()
  end
end

local wf=hs.window.filter

wf_avidemux = wf.new{'Avidemux2.8.app'}
wf_avidemux:subscribe(wf.windowFocused, enableAviDemuxBinds)
wf_avidemux:subscribe(wf.windowUnfocused, disableAviDemuxBinds)
