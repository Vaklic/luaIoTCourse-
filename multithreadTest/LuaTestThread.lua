local llthreads = require("llthreads")

local thread_code = [[
    local param = ...
    print(param["sock"])
]]

local thread_number = 100
local arr = {}
arr[1] = "Hasasasa"
local thread = llthreads.new(thread_code, {["thread"]=thread_number, ["sock"]=arr[1]})
assert(thread:start(true))

local socket = require("socket")
socket.sleep(2) -- give detached thread some time to run.
