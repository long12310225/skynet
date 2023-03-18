local skynet = require "skynet"
local mc = require "skynet.multicast"
local channel
local channelId = ...
channelId = tonumber(channelId)

local function recvChannel(channel, source, msg, ...)
    skynet.error("channdl Id:", channel, "source:", skynet.address(source), "msg:", msg)
end

skynet.start(function()
    channel = mc.new {
        channel = channelId,
        dispatch = recvChannel,
    }
    channel:subscribe()
    skynet.timeout(500, function()
        channel:unsubscribe()
    end)
end)
