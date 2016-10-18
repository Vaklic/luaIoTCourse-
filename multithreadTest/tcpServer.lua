local math = require('math')
local string = require('string')
local socket = require('socket')
local threads = require('threads')
local inspect = require('inspect')

local threadArray = {}
local numberOfThread = 0
local threadCode = [[
	local threads = require('threads')
	
	local tcp = socket.tcp()
	tcp:bind(address, port)
	
	local cond = threads.Condition(%d)
	
	str, err = sock:receive()
	while not err do
		print("Thread "..threadNum.." str = "..str.."\n")
		str, err = sock:receive()
	end
	sock:close()
	
	cond:signal()
]]

print('| waiting for thread...')

local address, port = '*', 10000
local threadArray = {}
local countOfThreads = 0

		
while true do
	if tcp:listen() then
		local sock = tcp:accept()
		if sock ~= nil then
			countOfThreads = countOfThreads + 1
			
			threadArray[countOfThreads] = {}
			threadArray[countOfThreads]['cond'] = threads.Condition()
			threadArray[countOfThreads]['thread'] = threads.Thread(string.format(threadCode, threadArray[countOfThreads]['cond']:id()))
			
			socket.sleep(1)
		end
	end
end
print('| thread finished!')

for ix = 0, countOfThreads, 1 do
	threadArray[countOfThreads]['thread']:free()
	threadArray[countOfThreads]['cond']:free()
end
