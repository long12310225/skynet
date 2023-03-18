local login = require "snax.loginserver"
local crypt = require "skynet.crypt"
local skynet = require "skynet"
local server_list = {}

local server = {
    host = "127.0.0.1",
    port = 8081,
    multilogin = false, --不允许重入
    name = "login_master",
}

function server.auth_handler(token)
    --base64(usr)@base64(server):base64(password)
    local user, server, password = token:match("([^@]+)@([^:]+):(.+)")
    user = crypt.base64decode(user)
    server = crypt.base64decode(server)
    password = crypt.base64decode(password)
    skynet.error(string.format("%s@%s:%s", user, server, password))
    return server, user
end

function server.login_handler(server, uid, secret)
    local msgserver = assert(server_list[server], "unknow server")
    skynet.error(string.format("%s%s is login,secret is %s", uid, server, crypt.hexencode(secret)))
    --将uid及secret发送给登陆点，告诉登陆点，这个uid可以登陆，并且让登陆点返回一个subid
    local subid = skynet.call(msgserver, "lua", "login", uid, secret)
    return subid
end

local CMD = {}
function CMD.register_gate(server, addr) --指令 register_gate
    skynet.error("cmd register_gate")
    server_list[server] = addr --记录已经启动的登陆点
end

function server.command_handler(command, ...) --重载此函数，可以实现外部服务通过指令操作server
    local f = assert(CMD[command])
    return f(...)
end

login(server)
