skynet = require "skynet"
require "skynet.manager"
skynet.start(function()
    skynet.register(".testsendmsg")
    local testluamsg = skynet.localname(".testluamsg")
    --发送消息给message,发送成功后立即返回，r是0
    local r = skynet.send(testluamsg, "lua", 1, "hello world", true)
    skynet.error("skynet.send return value:", r)

    --通过pack打包发送
    r = skynet.rawsend(testluamsg, "lua", skynet.pack(2, "hello world2", false))
    skynet.error("skynet.rawsend return value:", r)
end)
