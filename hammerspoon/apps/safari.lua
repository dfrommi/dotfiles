local obj = {}
obj.__index = obj

local log = hs.logger.new("safari")

function obj.new()
	return setmetatable({}, obj)
end

local function getAllOpenSafariTabs()
	local jxaScript = [[
        function run() {
            var Safari = Application('Safari');
            var windows = Safari.windows();
            var tabsInfo = [];
            var currentWindow = Safari.windows[0]; // Assuming the front window is the current window
            var currentTab = currentWindow.currentTab();

            for (var i = 0; i < windows.length; i++) {
                var tabs = windows[i].tabs();
                for (var j = 0; j < tabs.length; j++) {
                    var tab = tabs[j];
                    // Exclude the current (active) tab
                    if (!(i == 0 && tab.index() == currentTab.index())) {
                        tabsInfo.push({
                            title: tab.name(),
                            url: tab.url()
                        });
                    }
                }
            }

            return JSON.stringify(tabsInfo);
        }
    ]]

	-- Execute the JXA script
	local ok, result = hs.osascript.javascript(jxaScript)
	if ok then
		local tabs = hs.json.decode(result)
		return tabs
	else
		log.e("Failed to retrieve Safari tabs via JXA")
		return {}
	end
end

local function focusTabInSafari(tabTitle)
	local script = [[
        tell application "Safari"
            repeat with aWindow in every window
                repeat with aTab in every tab of aWindow
                    if (name of aTab) contains "]] .. tabTitle .. [[" then
                        set current tab of aWindow to aTab
                        set index of aWindow to 1
                        tell application "System Events" to tell process "Safari" to set frontmost to true
                        return
                    end if
                end repeat
            end repeat
        end tell
    ]]
	hs.osascript.applescript(script)
end

function obj:findBufferChoices()
	local tabs = getAllOpenSafariTabs()
	return hs.fnutils.imap(tabs, function(tab)
		return { text = tab.title, subText = tab.url }
	end)
end

function obj:findBufferSelected(choice)
	focusTabInSafari(choice.text)
end

return obj
