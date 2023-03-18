local skynet = require "skynet"
local socket = require "skynet.socket"
skynet.start(function()
    local addr = "0.0.0.0:8001"
    skynet.error("listen " .. addr)
    local lId = socket.listen(addr)
    assert(lId)
    socket.start(lId, function(cId, addr)
        skynet.error(addr .. " accepted")
        socket.start(cId)
        local str = socket.read(cId)
        if str then
            socket.write(cId, string.upper(str))
        end
        --放弃控制权
        socket.abandon(cId)
        skynet.newservice("socketagent", cId, addr)
    end)
end)
