function launch(appname, modal)
  hs.application.launchOrFocus(appname)
  modal.triggered = true
end

---
--- Right CMD as Hammerspoon trigger key
---
local cmdR_k = hs.hotkey.modal.new()

local singleapps = {
  {'e', 'Atom'},
  {'b', 'Safari'},
  {'t', 'iTerm'}
}

for i,app in ipairs(singleapps) do
  cmdR_k:bind({}, app[1], function() launch(app[2], cmdR_k); cmdR_k.triggered = true; end)
end

-- 1Password shortcut
cmdR_k:bind({}, '\\', function() hs.eventtap.keyStroke({'cmd'}, '\\'); cmdR_k.triggered = true; end)

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
