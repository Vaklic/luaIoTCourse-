local socket = require('socket')
local math = require('math')    
local string = require('string')
                            
function randomString(len)                                             
	local retStr = ''                                              
	for i = 1, len, 1 do                                           
		retStr = retStr .. string.char(math.random(0x00, 0xFF))
	end          
	return retStr
end                             
                                
function sleep(sec)             
    socket.select(nil, nil, sec)           
end                                        
                                           
--local address, port = '31.148.99.65', 10000
local address, port = 'localhost', 10000
local tcp = socket.tcp()  
                          
tcp:connect(address, port)        
                                  
while true do                     
	tcp:send(randomString(15))
	sleep(0.5)                
end   
