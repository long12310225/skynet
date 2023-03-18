local skynet = require "skynet"
skynet.start(function()
    skynet.error("Server start")
    local gateserver = skynet.newservice("mygateserver2")
    skynet.call(gateserver, "lua", "open", {
        port = 8002,
        maxclient = 64,
        nodelay = true, --是否延迟tcp
    })
    skynet.error("gate server start on", 8002)
    skynet.exit()
end)
