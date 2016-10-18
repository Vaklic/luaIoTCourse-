local math = require('math')
local string = require('string')
local socket = require('socket')
local threads = require('threads')
local inspect = require('inspect')

function f(sock)
	local str, err = nil, nil
    while true do
		str = sock:receive()
		io.write(1)--string.format('%x', str))
		while str ~= nil do
			io.write(string.format("Thread 1, str = %o\n", str))
			str = sock:receive()
		end
		coroutine.yield()
    end
    sock:close()
--    return step
end

local address, port = '*', 10000
local threadArray = {}
local countOfThreads = 0

n = 5
cr = coroutine.create(f)

local tcp = socket.tcp()
tcp:bind(address, port)
		
tcp:listen()
local sock = tcp:accept()

while true do
	b,res = coroutine.resume(cr,sock)
	--print("Main cycle")
end
