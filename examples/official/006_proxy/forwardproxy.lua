local skynet = require "skynet"
require "skynet.manager"
skynet.register_protocol {
    name = "system",
    id = skynet.PTYPE_SYSTEM,
    unpack = function(...) --不解包直接返回
        return ...
    end
}
local forward_map = {
    [skynet.PTYPE_LUA] = skynet.PTYPE_SYSTEM,
    [skynet.PTYPE_RESPONSE] = skynet.PTYPE_RESPONSE
}
local realsvr = ...
skynet.forward_type(forward_map, function()
    skynet.dispatch("system", function(session, source, msg, sz)
        skynet.ret(skynet.rawcall(realsvr, "lua", msg, sz))
    end)
    skynet.register(".proxy")
end)

