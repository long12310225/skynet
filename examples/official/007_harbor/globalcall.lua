skynet = require "skynet"
harbor = require "skynet.harbor"
skynet.start(function()
    local globalluamsg = harbor.queryname("globalluamsg")
    local r = skynet.call(globalluamsg, "lua", "hello world")
    skynet.error("skynet.call return value:", r)
end)
