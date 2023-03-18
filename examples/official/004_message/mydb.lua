local skynet = require "skynet"
require "skynet.manager"
local db = {}
local command = {}
local queue = require "skynet.queue"
local cs = queue()
function command.GET(key)
    skynet.sleep(1000)
    return db[key]
end

function command.SET(key, value)
    db[key] = value
end

skynet.start(function()
    skynet.dispatch("lua", function(session, address, cmd, ...)
        local response = skynet.response(skynet.pack)
        skynet.fork(function(cmd, ...)
            skynet.sleep(500)
            cmd = cmd:upper()
            local f = command[cmd]
            if f then
                --skynet.retpack(f(...))
                response(true, cs(f, ...)) --使用response可以在不同协程间处理返回,使用cs可以严格的按顺序执行
            else
                skynet.error(string.format("Unknown command %s", tostring(cmd)))
            end
        end, cmd, ...)
    end)
    skynet.register ".mydb" --给当前服务注册个名字，用于其他服务给当前服务发送消息
end)
