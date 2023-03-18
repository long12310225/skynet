local skynet = require "skynet"
skynet.start(function()
    local login = skynet.newservice("mylogin")
    local gate = skynet.newservice("mymsgserver", login)
    skynet.call(gate, "lua", "open", {
        port = 8002,
        maxclient = 64,
        servername = "sample",
    })
end)
