package.cpath = "luaclib/?.so"
local socket = require "client.socket"
local crypt = require "client.crypt"
local fd = assert(socket.connect("127.0.0.1", 8002))

local function writeline(fd, text)
    socket.send(fd, text .. "\n")
end

local function unpack_line(text)
    local from = text:find("\n", 1, true)
    if from then
        return text:sub(1, from - 1), text:sub(from + 1)
    end
    return nil, text
end

local last = ""

local function unpack_f(f)
    local function try_recv(fd, lastr)
        local result
        result, last = f(last)
        if result then
            return result, last
        end
        local r = socket.recv(fd)
        if not r then
            return nil, last
        end
        if r == "" then
            error "Server closed"
        end
        return f(last .. r)
    end

    return function()
        while true do
            local result
            result, last = try_recv(fd, last)
            if result then
                return result
            end
            socket.usleep(100)
        end
    end
end

local readline = unpack_f(unpack_line)
local challenge = crypt.base64decode(readline()) --接收challenge
local clientkey = crypt.randomkey()
--把clientkey换算后ckeys发送给服务器
writeline(fd, crypt.base64encode(crypt.dhexchange(clientkey)))

--服务器把serverkey换算后skeys发送给客户端，客户端用clientkey与skeys得出secret
local secret = crypt.dhsecret(crypt.base64decode(readline()), clientkey)

--secret一般是8字节，需要转换来显示
print("secret is ", crypt.hexencode(secret))

--加密时候需要直接传递secret字节
local hmac = crypt.hmac64(challenge, secret)
writeline(fd, crypt.base64encode(hmac))

local token = {
    server = "sample",
    user = "hello",
    pass = "password",
}

local function encode_token(token)
    return string.format("%s@%s:%s",
        crypt.base64encode(token.user),
        crypt.base64encode(token.server),
        crypt.base64encode(token.pass))
end

--使用DES加密token得到etoken
local etoken = crypt.desencode(secret, encode_token(token))
etoken = crypt.base64encode(etoken)
writeline(fd, etoken)

local result = readline()
print(result)
local code = tonumber(string.sub(result, 1, 3))
assert(code == 200)
socket.close(fd)
local subid = crypt.base64decode(string.sub(result, 5))
print("login ok subid=", subid)

local function send_request(v, session) --打包数据及session
    local size = #v + 4
    local package = string.pack(">I2", size) .. v .. string.pack(">I4", session)
    socket.send(fd, package)
    return v, session
end

local function recv_response(v)
    local size = #v - 5
    local content, ok, session = string.unpack("c" .. tostring(size) .. "B>I4", v)
    return ok ~= 0, content, session
end

local function unpack_package(text)
    local size = #text
    if size < 2 then
        return nil, size
    end
    local s = text:byte(1) * 256 + text:byte(2)
    if size < s + 2 then
        return nil, text
    end
    return text:sub(3, 2 + s), text:sub(3 + s)
end

local readpackage = unpack_f(unpack_package)

local function send_package(fd, pack)
    local package = string.pack(">s2", pack) --大端序，s计算字符串长度，2字节整型表示
    socket.send(fd, package)
end

local text = "echo"
local index = 1
print("connect")
fd = assert(socket.connect("127.0.0.1", 8002))
last = ""
local handshake = string.format("%s@%s#%s:%d", crypt.base64encode(token.user),
    crypt.base64encode(token.server), crypt.base64encode(subid), index) --index用于断链恢复
local hmac = crypt.hmac64(crypt.hashkey(handshake), secret) --加密握手hash值得到hmac，防篡改
send_package(fd, handshake .. ":" .. crypt.base64encode(hmac)) --发送handshake
print(readpackage()) --接收应答
print("====>", send_request(text, 0)) --发送请求，并同时将当前sessiuon 0 组合发送，session用于匹配应答
print("<====", recv_response(readpackage()))
print("disconnect")
socket.close()
