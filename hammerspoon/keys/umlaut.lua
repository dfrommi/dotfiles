local function keyStroke(key)
	return hs.fnutils.partial(hs.eventtap.keyStrokes, key)
end

hs.hotkey.bind({ "alt" }, "a", nil, keyStroke("ä"), nil, nil)
hs.hotkey.bind({ "alt", "shift" }, "a", nil, keyStroke("Ä"), nil, nil)
hs.hotkey.bind({ "alt" }, "u", nil, keyStroke("ü"), nil, nil)
hs.hotkey.bind({ "alt", "shift" }, "u", nil, keyStroke("Ü"), nil, nil)
hs.hotkey.bind({ "alt" }, "o", nil, keyStroke("ö"), nil, nil)
hs.hotkey.bind({ "alt", "shift" }, "o", nil, keyStroke("Ö"), nil, nil)
hs.hotkey.bind({ "alt" }, "s", nil, keyStroke("ß"), nil, nil)
hs.hotkey.bind({ "alt" }, "e", nil, keyStroke("€"), nil, nil)
