local skynet = require "skynet"
local mc = require "skynet.multicast"
local channel
function task()
    local i = 0
    while (i < 100) do
        skynet.sleep(100)
        channel:publish("data" .. i)
        i = i + 1
        --skynet.error("i:", i)
    end
    channel:delete()
    skynet.exit()
end

skynet.start(function()
    channel = mc.new()
    skynet.error("new channel Id,", channel.channel)
    skynet.fork(task)
end)
