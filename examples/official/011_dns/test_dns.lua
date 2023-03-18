local skynet = require "skynet"
local dns = require "skynet.dns"
local cmd, domain = ...
local function task()
    local r, ips = skynet.call(".dnsservice", "lua", cmd, domain)
    skynet.error("dnsservice Test:", domain, r)
    skynet.exit()
end

skynet.start(function()
    skynet.error("nameserver:", dns.server())
    --skynet.error("nameserver:", dns.server("8.8.8.8",53))
    local ip, ips = dns.resolve("www.baidu.com")
    skynet.error("dns.resolve return:", ip)
    for k, v in pairs(ips) do
        skynet.error("baidu.com", v)
    end
    dns.flush()
    skynet.fork(task)
end)
