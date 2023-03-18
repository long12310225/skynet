local skynet = require "skynet"
local protobuf = require "protobuf"
skynet.start(function()
    protobuf.register_file("./protos/person.pb")
    skynet.error("protobuf register:persons.pb")
    stringbuffer = protobuf.encode("cs.Person", {
        name = "xiaoming",
        id = 1,
        email = "xxx@qq.com",
        phone = {
            {
                number = "111111",
                type = "MOBILE",
            },
            {
                number = "2222",
            },
            {
                number = "33333",
                type = "WORK",
            }
        }
    })
    local data = protobuf.decode("cs.Person", stringbuffer)
    skynet.error("decode name=" .. data.name .. ",id=" .. data.id .. ",email=" .. data.email)
    skynet.error("decode phone.type=" .. data.phone[1].type .. ",phone.number=" .. data.phone[1].number)
    skynet.error("decode phone.type=" .. data.phone[2].type .. ",phone.number=" .. data.phone[2].number)
    skynet.error("decode phone.type=" .. data.phone[3].type .. ",phone.number=" .. data.phone[3].number)
end)
