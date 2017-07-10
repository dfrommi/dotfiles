local hyper = {"ctrl", "alt", "cmd", "shift"}

hs.grid.setMargins({0, 0})
hs.grid.setGrid('12x12', nil)
hs.window.animationDuration = 0 -- disable animations

local grid = {
  topHalf = '0,0 12x6',
  topThird = '0,0 12x4',
  topTwoThirds = '0,0 12x8',
  rightHalf = '6,0 6x12',
  rightThird = '8,0 4x12',
  rightTwoThirds = '4,0 8x12',
  bottomHalf = '0,6 12x6',
  bottomThird = '0,8 12x4',
  bottomTwoThirds = '0,4 12x8',
  leftHalf = '0,0 6x12',
  leftThird = '0,0 4x12',
  leftTwoThirds = '0,0 8x12',
  topLeft = '0,0 6x6',
  topLeftTwoThirds = '0,0 8x8',
  topLeftThreeQuarter = '0,0 9x9',
  topLeftAlmostFullScreen = '0,0 11x11',
  topRight = '6,0 6x6',
  bottomRight = '6,6 6x6',
  bottomLeft = '0,6 6x6',
  fullScreen = '0,0 12x12',
  centeredBig = '3,0 6x12',
  centeredSmall = '3,3 6x6',
}

local lastSeenChain = nil
local lastSeenWindow = nil

-- Chain the specified movement commands.
--
-- This is like the "chain" feature in Slate, but with a couple of enhancements:
--
--  - Chains always start on the screen the window is currently on.
--  - A chain will be reset after 2 seconds of inactivity, or on switching from
--    one chain to another, or on switching from one app to another, or from one
--    window to another.
--
function chain(movements)
  local chainResetInterval = 2 -- seconds
  local cycleLength = #movements
  local sequenceNumber = 1

  return function()
    if hs.window.focusedWindow()
    then
      local win = hs.window.frontmostWindow()
      local id = win:id()
      local now = hs.timer.secondsSinceEpoch()
      local screen = win:screen()

      if
        lastSeenChain ~= movements or
        lastSeenAt < now - chainResetInterval or
        lastSeenWindow ~= id
      then
        sequenceNumber = 1
        lastSeenChain = movements
      end
      lastSeenAt = now
      lastSeenWindow = id

      hs.grid.set(win, movements[sequenceNumber], screen)
      sequenceNumber = sequenceNumber % cycleLength + 1
    end
  end
end

hs.hotkey.bind(hyper, "k", chain({
  grid.fullScreen,
  grid.topLeftAlmostFullScreen,
  grid.topLeftThreeQuarter,
  grid.topLeftTwoThirds,
  grid.topLeft,
}))

hs.hotkey.bind(hyper, "j", chain({
  grid.leftHalf,
  grid.leftTwoThirds,
  grid.leftThird,
}))

hs.hotkey.bind(hyper, "l", chain({
  grid.rightHalf,
  grid.rightTwoThirds,
  grid.rightThird,
}))

-- hs.hotkey.bind(hyper,"o", chain({
--   grid.topRight,
-- }))
--
-- hs.hotkey.bind(hyper,".", chain({
--   grid.bottomRight,
-- }))
--
-- hs.hotkey.bind(hyper,"u", chain({
--   grid.topLeft,
-- }))
--
-- hs.hotkey.bind(hyper,"m", chain({
--   grid.bottomLeft,
-- }))
