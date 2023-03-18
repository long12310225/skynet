local skynet = require "skynet"

skynet.start(function()
    skynet.error("Server First Test")
    local name = skynet.getenv("myname")
    local age = skynet.getenv("myage")
    skynet.error("MyName is ", name, ",", age, " years old")
end)
