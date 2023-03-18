local skynet = require "skynet"
local key, value = ...
function task()
    local r = skynet.send(".proxy", "lua", "set", key, value)
    skynet.error("mydb set Test", r)
    r = skynet.call(".proxy", "lua", "get", key)
    skynet.error("mydb get Test", r)
    skynet.exit()
end

skynet.start(function()
    skynet.fork(task)
end)
