skynet = require "skynet"
require "skynet.manager"
skynet.start(function()
    skynet.register(".testcallmsg")
    --发送需要返回的消息
    local r = skynet.call(".testluamsg", "lua", 1, "hello world", true)
    skynet.error("skynet.call return value:", r)
    r = skynet.unpack(skynet.rawcall(".testluamsg", "lua", skynet.pack(2, "hello world2", false)))
    skynet.error("skynet.rawcall return value:", r)
end)
