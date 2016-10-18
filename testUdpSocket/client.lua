socket = require('socket')
math = require('math')

function sleep(sec)
    socket.select(nil, nil, sec)
end

function startProgram(address, port, destAddress, destPort, uniqueID, mesType, mesSize)
	local udp = socket.udp()
	udp.setsockname(udp, address, port)
	local dataField = formDataField(uniqueID, mesType, mesSize)
	udp.sendto(udp, dataField, destAddress, destPort)
	udp.close(udp)
end

function formDataField(uniqueID, mesType, mesSize)
	data = ''
	for ix=0, tonumber(mesSize) do
		data = data .. tostring(math.random(0,16))
	end 
	return tostring(uniqueID) .. tostring(mesType) .. tostring(data)
end

if(#arg == 9) then
	for ix = 0, tonumber(arg[8]) do
		startProgram(arg[1], arg[2], arg[3], arg[4], arg[5], arg[6], arg[7])
		sleep(tonumber(arg[9]))
	end
else 
	io.write([[Wrong Parameters!
Type of command: sudo lua5.1 <source_ip> <source_port> <dest_ip> <dest_port> <unique_message_ID> <message_type> <message_size> <quantity_of_message> <delay_time>]])
end
