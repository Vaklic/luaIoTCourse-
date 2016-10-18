socket = require('socket')
string = require('string')

function startProgram(address, port)
	local check = false
	local udp = socket.udp()
	repeat
		udp.setsockname(udp, address, port)
		local dataField, dst_ip, dst_port = udp.receivefrom(udp)
		local uniqueID, mesType, value = parseDataField(dataField)
		io.write('Recive message. IP from: ' ..dst_ip, '; Port from: ' ..dst_port, '; Message ID: ', uniqueID, '; Message type: ' ..mesType, '; Message data: ' ..value, '\n')
	until check == true
	udp.close(udp)
end

function parseDataField(dataField)
	data = ''
	local uniqueID = string.sub(dataField, 1, 16)
	local mesType = string.sub(dataField, 17, 17)
	local value = string.sub(dataField, 18, -1)
	return uniqueID, mesType, value
end

if(#arg == 2) then
	startProgram(arg[1], arg[2])
else 
	io.write([[Wrong Parameters!
Type of command: sudo lua5.1 <server_address> <server_port>]])
end

