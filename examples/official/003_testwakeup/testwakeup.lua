local skynet = require "skynet"
local cos = {}

function task1()
    skynet.error("task1 begin task")
    skynet.error("task1 wait")
    skynet.wait()
    --skynet.wait(coroutine.running())
    skynet.error("task1 end task")
end

function task2()
    skynet.error("task2 begin task")
    skynet.error("task2 wait")
    skynet.wakeup(cos[1]) --task2唤醒task1
    skynet.timeout(500, task1)
    skynet.error("task2 end task")
end

skynet.start(function()
    cos[1] = skynet.fork(task1)
    cos[2] = skynet.fork(task2)
end)
