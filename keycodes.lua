local function Chinese()
    hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
end

local function English()
    hs.keycodes.currentSourceID("com.apple.keylayout.ABC")
end

-- 由hammer接管Raycast快捷键,这样hammer可以识别到Raycast的启动
hs.hotkey.bind({"alt"},"space", function()
    if hs.window.focusedWindow():application():name() == "Raycast" then
        local applicationObj =  hs.application.applicationsForBundleID("com.raycast.macos")
        applicationObj[1]:hide()
    else
        hs.application.launchOrFocusByBundleID("com.raycast.macos")
    end
end)  

-- app to expected ime config
local app2Ime = {
    {'/Applications/Raycast.app', 'English'},
    {'/Applications/IntelliJ IDEA.app', 'English'},
    {'/System/Applications/Utilities/Terminal.app', 'English'},
    -- {'/Applications/Google Chrome.app', 'Chinese'},
    -- {'/System/Library/CoreServices/Finder.app', 'English'},
    -- {'/Applications/DingTalk.app', 'Chinese'},
    -- {'/Applications/Kindle.app', 'English'},
    -- {'/Applications/NeteaseMusic.app', 'Chinese'},
    -- {'/Applications/微信.app', 'Chinese'},
    -- {'/Applications/System Preferences.app', 'English'},
    -- {'/Applications/Dash.app', 'English'},
    -- {'/Applications/MindNode.app', 'Chinese'},
    -- {'/Applications/Preview.app', 'Chinese'},
    -- {'/Applications/wechatwebdevtools.app', 'English'},
    -- {'/Applications/Sketch.app', 'English'},
}

function updateFocusAppInputMethod()
    local focusAppPath = hs.window.frontmostWindow():application():path()

    -- init match flag false
    local hasMatched = false
    
    for index, app in pairs(app2Ime) do
        local appPath = app[1]
        local expectedIme = app[2]

        if focusAppPath == appPath then
            -- set match flag true
            hasMatched = true
            if expectedIme == 'English' then
                -- hs.notify.new({title="Hammerspoon", informativeText="English"}):send()
                English()
            else
                -- hs.notify.new({title="Hammerspoon", informativeText="Chinese"}):send()
                Chinese()
            end
            break
        end

    end

    -- judge match flag,if value is false default sougou input
    if hasMatched == false then
        hs.notify.new({title="Hammerspoon", informativeText="pinyin"}):send()

        hs.keycodes.currentSourceID("com.sogou.inputmethod.sogou.pinyin")
    end
end

-- helper hotkey to figure out the app path and name of current focused window
hs.hotkey.bind({'ctrl', 'cmd'}, ".", function()
    hs.alert.show("App path:        "
    ..hs.window.focusedWindow():application():path()
    .."\n"
    .."App name:      "
    ..hs.window.focusedWindow():application():name()
    .."\n"
    .."IM source id:  "
    ..hs.keycodes.currentSourceID())
end)

-- Handle cursor focus and application's screen manage.
function applicationWatcher(appName, eventType, appObject)
    if (eventType == hs.application.watcher.activated) then
        -- hs.alert.show(hs.window.focusedWindow():application():name())
        updateFocusAppInputMethod()
    end
end

appWatcher = hs.application.watcher.new(applicationWatcher)
appWatcher:start()
