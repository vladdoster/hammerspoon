local obj = {}
obj.__index = obj

-- Metadata
obj.name = 'SafariFix'
obj.version = '0.1'
obj.author = 'Vladislav Doster <mvdoster@gmail.org>'
obj.homepage = 'https://github.com/Hammerspoon/Spoons'
obj.license = 'MIT - https://opensource.org/licenses/MIT'

--- SafariFix.logger
--- Variable
--- Logger object used within SafariFix.
obj.logger = hs.logger.new('SafariFix')
obj.logger.setLogLevel('info')
local log = obj.logger

local et = hs.eventtap
local events = et.event.types
local win = hs.window
local app = hs.application

obj.ignoreEscape = et.new({ events.keyDown }, function(e)
    local keyCode = e:getKeyCode()
    if keyCode == 53 then
        log.i('Ignored escape keypress')
        -- event is deleted
        return true
    end
end)

obj.applicationWatcher = function(appName, eventType, _)
    if appName == 'Safari' then
        if eventType == app.watcher.activated and win.focusedWindow():isFullscreen() then
            obj.ignoreEscape:start()
        elseif eventType == app.watcher.deactivated then
            obj.ignoreEscape:stop()
        end
    end
end

obj.appWatcher = app.watcher.new(obj.applicationWatcher)
obj.appWatcher:start()

return obj
