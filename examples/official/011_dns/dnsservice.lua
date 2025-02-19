local skynet = require "skynet"
require "skynet.manager"
local dns = require "skynet.dns"
local command = {}
function command.FLUSH()
    return dns.flush()
end

function command.GETIP(domain)
    return dns.resolve(domain)
end

skynet.start(function()
    dns.server()
    skynet.dispatch("lua", function(session, address, cmd, ...)
        cmd = cmd:upper()
        local f = command[cmd]
        if f then
            skynet.retpack(f(...))
        else
            skynet.error(string.format("Unknown command %s", tostring(cmd)))
        end
    end)
    skynet.register ".dnsservice"
end)
