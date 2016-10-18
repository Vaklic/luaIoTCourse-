function proceedData(conn, IoType, pin, func, value)
    print(IoType, pin, func, value) 
    if IoType == 'gpio' then
        print(IoType) 
        if(func == 'w') then
            print(func, value) 
            gpio.mode(pin, gpio.OUTPUT)
            if value == 0 then
                gpio.write(pin, gpio.LOW)
            else
                gpio.write(pin, gpio.HIGH)
            end
            conn:send(tostring("<h1>" ..pin .." pin turn to " ..value .."</h1>"))
        else
            print(func, value) 
            gpio.mode(pin, gpio.INPUT)
            local v = gpio.read(pin) 
            conn:send("<h1>Value of "..pin.." pin is "..v.."</h1>")
        end
    else
        print(IoType, pin, func) 
        local v = adc.read(0) 
        conn:send("<h1>Value of adc pin is "..v.."</h1>")
    end
end

function proceedString(conn,str)
    local err = 0
    
    local labelHost = string.find(str, 'Host:')
    local endLabelHost = string.find(str, '\n', labelHost)
    local hostIP = string.sub(str, labelHost + 6, endLabelHost-1)

    local getLabel = string.find(str, 'GET')
    local getEndLabel = string.find(str, 'HTTP/1.1', getLabel)
    local getPayload = string.sub(str, getLabel + 4, getEndLabel-2)

    local labelIoType = string.find(getPayload, 'gpio')
    local endLabelIoType = nil
    local IoType = nil
    local pin = nil
    
    if labelIoType == nil then
        labelIoType = string.find(getPayload, 'aio')
        if labelIoType == nil then
            return err
        else
            IoType = 'aio'
            endLabelIoType = string.find(getPayload, '&')
            pin = string.sub(getPayload, labelIoType + 4, endLabelIoType-1)
        end
    else
        IoType = 'gpio'
        endLabelIoType = string.find(getPayload, '&')
        pin = string.sub(getPayload, labelIoType + 5, endLabelIoType-1)
    end
    pin = tonumber(pin)

    local labelFunc = string.find(getPayload, 'func')
    local endLabelFunc = string.find(getPayload, '&', labelFunc)
    local func = string.sub(getPayload, labelFunc+5, endLabelFunc-1)

    local labelValue = string.find(getPayload, 'value')

    local value = tonumber(string.sub(getPayload, labelValue + 6))
    if value ~= nil then err = 1 end
    if err ~= 0 then
        proceedData(conn, IoType, pin, func, value)
    end
end

function startConnect()
    ipStatus = wifi.sta.status()
    print(ipStatus)

    wifi.setmode(wifi.STATION)
    wifi.sta.config("ASUS", "Bonch0909876")

    count = 0;
    if wifi.sta.status() == 5 then
        ip = wifi.sta.getip()
        print(ip)
    
        srv=net.createServer(net.TCP)
            srv:listen(80, function(conn)
            conn:on("receive", function(conn,payload)
                proceedString(conn,payload)
            end)
            conn:on("sent", function(conn) conn:close() end)
        end)
    else 
        --tmr.delay(500000)
        --startConnect()
    end
end

startConnect()
