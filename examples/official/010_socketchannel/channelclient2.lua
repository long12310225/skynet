local skynet = require "skynet"
require "skynet.manager"
local sc = require "skynet.socketchannel"
function dispatch(sock)
    local r = sock:readline()
    local session = tonumber(string.sub(r, 5))
    return session, true, r --返回值必须要有三个，第一个session
end

--创建一个 channel 对象出来，其中 host 可以是 ip 地址或者域名，port 是端口号。
local channel = sc.channel {
    host = "127.0.0.1",
    port = 8001,
    response = dispatch --处理消息的函数
}
local function task()
    local resp
    local i = 0
    while (i < 3) do
        skynet.fork(function(session)
            resp = channel:request("data" .. session .. "\n", session)
            skynet.error("recv", resp, session)
        end, i)
        i = i + 1
    end
end

skynet.start(function()
    skynet.fork(task)
end)
