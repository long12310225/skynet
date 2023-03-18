local skynet = require "skynet"
local socket = require "skynet.socket"
skynet.start(function()
    local addr = "0.0.0.0:8001"
    skynet.error("listen " .. addr)
    local lId = socket.listen(addr)
    assert(lId)
    socket.start(lId, function(cId, addr)
        skynet.error(addr .. " accepted")
        skynet.newservice("socketagent", cId, addr)
    end)
end)
