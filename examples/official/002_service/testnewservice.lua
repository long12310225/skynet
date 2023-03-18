local skynet = require "skynet"
skynet.start(function()
    skynet.error("new service")
    skynet.newservice("server_1")
    --skynet.newservice("server_2")
    skynet.uniqueservice(true, "server_2") --全局唯一服务
    local us = skynet.queryservice(true, "server_2")
    skynet.sleep(500)
    skynet.error("us:", us)
    skynet.fork(task, 500)
    skynet.fork(task, 500)
end)

function task(timeout)
    skynet.error("fork co:", coroutine.running())
    skynet.error("begin sleep")
    skynet.sleep(timeout)
    skynet.error("end sleep")
    skynet.yield()
end
