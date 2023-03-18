local skynet = require "skynet"
require "skynet.manager"
local key, value = ...
function task()
    local r = skynet.send(".mydb", "lua", "set", key, value)
    skynet.error("mydb set Test", r)
    r = skynet.call(".mydb", "lua", "get", key)
    skynet.error("mydb get Test", r)
    skynet.exit()
end

skynet.start(function()
    skynet.fork(task)
end)
