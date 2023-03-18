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

local cId, addr = ...
cId = tonumber(cId)
skynet.start(function()
    skynet.fork(function()
        echo(cId, addr)
        skynet.exit()
    end)
end)
