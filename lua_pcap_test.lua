pcap = require 'pcaplua'

local function hexval(s)
	local fmt = string.rep ('%02X:', string.len(s))
	return string.format (fmt, string.byte(s,1,string.len(s)))
end

pcapObj, deviceName  = pcap.new_live_capture()

local data, comingTime, length = pcapObj:next()
print(string.format("%s (%X,%d):\n", os.date('%c', comingTime), length, length))

print ('------ ethernet frame ---------')
local eth = pcap.decode_ethernet (data)
print (hexval(eth.src), hexval(eth.dst), eth.type)

if eth.type == 8 then
	print ('-------- IP packet --------')
	local ip = pcap.decode_ip(eth.content)
	for k,v in pairs(ip) do
		if k ~= 'content' then
			print (k,v)
		end
	end

	local tcp, udp
	if ip.proto == 6 then
		print ('----- TCP packet ------')
		tcp = pcap.decode_tcp (ip.content)
		print(string.format())
	elseif ip.proto == 17 then
		print ('------- UDP packet --------')
		udp = pcap.decode_udp (ip.content)
		print (string.format ('sport:%d, dport:%d, len:%d, chksum:%d',
				udp.source_port, udp.dest_port, udp.length, udp.checksum))
	end
end
