local msgserver = require "snax.msgserver"
local crypt = require "skynet.crypt"
local skynet = require "skynet"

local subid = 0
local server = {} --一张表，里面需要实现特定回调接口
local servername

--外部发消息来调用，用于注册
function server.login_handler(uid, secret)
    skynet.error("login_handler invoke", uid, secret)
    subid = subid + 1
    --通过uid及subid获得username
    local username = msgserver.username(uid, subid, servername)
    skynet.error("uid", uid, "login,username", username)
    msgserver.login(username, secret) --正在登陆
    return subid
end

--外部发消息来调用，用于注销
function server.logout_handler(uid, subid)
    skynet.error("logout_handler invoke", uid, subid)
    local username = msgserver.username(uid, subid, servername)
    msgserver.logout(username)
end

--外部发消息来调用，用于关闭连接
function server.kick_handler(uid, subid)
    skynet.error("kick_handler invoke", uid, subid)
end

--当客户端断开连接，此回调函数会被调用
function server.disconnect_handler(username)
    skynet.error("disconnect_handler invoke", username)
end

--当接收到客户端请求，此回调函数会被调用，你需要提供应答
function server.request_handler(username, msg)
    skynet.error("request_handler invoke", username, msg)
    return string.upper(msg)
end

--监听成功此回调函数会被调用
function server.register_handler(name)
    skynet.error("register_handler invoke", name)
    servername = name
end

msgserver.start(server)
