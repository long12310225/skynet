local skynet = require "skynet"
local uuid = require("uuid")

skynet.start(function()
    print("here's a new uuid: ", uuid())
    local gate = skynet.newservice("simplemsgserver")
    skynet.call(gate, "lua", "open", {
        port = 8002,
        maxclient = 64,
        servername = "sample",
    })
    local uid = "test"
    local secret = "123"
    local subid = skynet.call(gate, "lua", "login", uid, secret)
    skynet.error("lua login subid", subid)
    skynet.call(gate, "lua", "logout", uid, subid)
    skynet.call(gate, "lua", "kick", uid, subid)
    skynet.call(gate, "lua", "close")
end)
