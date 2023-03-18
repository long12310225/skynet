local skynet = require "skynet"
local socket = require "skynet.socket"
function echo(cId, addr)
    socket.start(cId)
    while true do
        local str, endstr = socket.read(cId)
        --local str, endstr = socket.readline(cId,"\n")
        --local str, endstr = socket.readall(cId)
        if str then
            skynet.error("recv " .. str)
            socket.write(cId, string.upper(str)) --高优先级
            socket.lwrite(cId, str) --低优先级
        else
            socket.close(cId)
            skynet.error(addr .. " disconnect,endstr", endstr)
            return
        end
    end
end

function accept(cId, addr)
    skynet.error(addr .. " accept")
    skynet.fork(echo, cId, addr)
end

skynet.start(function()
    local addr = "0.0.0.0:8001"
    skynet.error("listen " .. addr)
    local lId = socket.listen(addr)
    --local lId = socket.listen("0.0.0.0",8001,128)
    assert(lId)
    socket.start(lId, accept)
end)
