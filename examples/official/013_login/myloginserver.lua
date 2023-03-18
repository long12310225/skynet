local login = require "snax.loginserver"
local crypt = require "skynet.crypt"
local skynet = require "skynet"

local server = {
    host = "127.0.0.1",
    port = 8001,
    multilogin = false, --不允许重复登陆
    name = "login_master",
}
function server.auth_handler(token)
    -- token=base64(user)@base64(server):base64(password)
    local user, server, password = token:match("([^@]+)@([^:]+):(.+)")
    user = crypt.base64decode(user)
    server = crypt.base64decode(server)
    password = crypt.base64decode(password)
    skynet.error(string.format("%s@%s:%s", user, server, password))
    assert(password == "password", "Invalid password")
    return server, user
end

local subid = 0
function server.login_handler(server, uid, secret)
    skynet.error(string.format("%s@%s is login,secret is %s", uid, server, crypt.hexencode(secret)))
    subid = subid + 1
    skynet.sleep(500)
    return subid
end

local CMD = {}
function CMD.register_gate(server, address)
    skynet.error("cmd register_gate")
end

function server.command_handler(command, ...)
    local f = assert(CMD[command])
    return f(...)
end

login(server)
