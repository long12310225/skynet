skynet = require "skynet"
require "skynet.manager"
skynet.register_protocol {
    name = "system",
    id = skynet.PTYPE_SYSTEM,
}
skynet.start(function()
    local othermsg = skynet.localname(".othermsg")
    local r = skynet.unpack(skynet.rawcall(othermsg, "systems", skynet.pack(1, "hello world", true)))
    skynet.error("skynet.call return value:", r)
end)
