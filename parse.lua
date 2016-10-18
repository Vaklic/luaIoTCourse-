string = require('string')

str = "https://192.168.4.101/gpio/8/on"
arr = {}

n = string.find(str, "://")

arr[1] = string.sub(str, 1, n-1)

n = n + 3

for ix = 2, 5 do 
	local k = string.find(str, "/", n)
	if k == nil then
		k = -1
	else
		k = k - 1
	end
	arr[ix] = string.sub(str, n, k)
	n = k + 2
end

for iy = 1, #arr do
	io.write(arr[iy])
end
