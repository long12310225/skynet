local skynet = require "skynet"
require "skynet.manager"
skynet.register_protocol {
    name = "system",
    id = skynet.PTYPE_SYSTEM,
    unpack = skynet.unpack,
}
skynet.start(function()
    skynet.dispatch("system", function(session, address, ...)
        skynet.ret(skynet.pack("hello world"))
    end)
    skynet.register ".othermsg"
end)
