local msgserver = require "snax.msgserver"
local crypt = require "skynet.crypt"
local skynet = require "skynet"

local loginservice = tonumber(...) --从启动参数获取登陆服务地址
local server = {} --一张表，需要实现指定回调接口
local servername
local subid = 0
--外部发消息来调用，一般是loginserver发消息来，你需要产生唯一subid，如果loginserver不允许multilogin,那么此函数不会重入
function server.login_handler(uid, secret)
    subid = subid + 1
    --通过uid及subid获得username
    local username = msgserver.username(uid, subid, servername)
    skynet.error("uid", uid, "login,username", username)
    msgserver.login(username, secret) --正在登陆
end

--外部发消息来调用，登出uid对应的登陆名
function server.logout_handler(uid, subid)
    local username = msgserver.username(uid, subid, servername)
    msgserver.logout(username)
end

--一般给loginserver发消息调用，可以作为登出操作
function server.kick_handler(uid, subid)
    server.logout_handler(uid, subid)
end

--当用户断开了连接，这个回调函数会被调用
function server.disconnect_handler(username)
    skynet.error("username", username)
end

--当接收到客户端网络请求，这个回调函数会被调用，需要返回应答
function server.request_handler(username, msg)
    skynet.error("recv", msg, "from", username)
    return string.upper(msg)
end

--注册登陆服务，主要告诉loginservice有这个登陆点存在
function server.register_handler(name)
    servername = name
    skynet.error("register", name)
    skynet.call(loginservice, "lua", "register_gate", servername, skynet.self())
end

msgserver.start(server)
