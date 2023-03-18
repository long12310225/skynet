local skynet = require "skynet"
skynet.init(function()
    skynet.error("server init")
end)
skynet.start(function()
    skynet.error("Server First Test")
    local name = skynet.getenv("myname")
    local age = skynet.getenv("myage")
    skynet.error("MyName is ", name, ",", age, " years old")

    --skynet.setenv("mynewname", "Tom2")
   -- skynet.setenv("mynewage", 22)
end)
