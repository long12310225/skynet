local skynet = require "skynet"
local gateserver = require "snax.gateserver"
local netpack = require "skynet.netpack"
local handler = {}
local CMD = {}
local agents = {}
--注册 client 消息专门用来将接收到的网络数据转发给 agent,不需要解包，也不需要打包
skynet.register_protocol {
    name = "client",
    id = skynet.PTYPE_CLIENT,
}
function handler.connect(fd, ipaddr)
    skynet.error("ipaddr:", ipaddr, "fd:", fd, "connect")
    gateserver.openclient(fd)
    local agent = skynet.newservice("myagent", fd)
    agents[fd] = agent
end

--连接成功就启动一个 agent 来代理
function handler.disconnect(fd) --断开连接后，agent 服务退出
    skynet.error("fd:", fd, "disconnect")
    local agent = agents[fd]
    if (agent) then
        --通过发送消息的方式来退出不要使用 skynet.kill(agent)
        skynet.send(agent, "lua", "quit")
        agents[fd] = nil
    end
end

function handler.message(fd, msg, sz)
    local agent = agents[fd]
    skynet.redirect(agent, 0, "client", 0, msg, sz) --收到消息就转发给 agent end function handler.error(fd, msg)
    skynet.closeclient(fd)

end

function handler.warning(fd, size)
    skynet.skynet("warning fd=", fd, "unsend data over 1M")
end

function handler.open(source, conf)
    skynet.error("open by ", skynet.address(source))
    skynet.error("listen on", conf.port)
    skynet.error("client max", conf.maxclient)
    skynet.error("nodelay", conf.nodelay)

end

function CMD.kick(source, fd)
    skynet.error("source:", skynet.address(source), "kick fd:", fd)
    gateserver.closeclient(fd)
end

function handler.command(cmd, source, ...)
    local f = assert(CMD[cmd])
    return f(source, ...)
end

gateserver.start(handler)
