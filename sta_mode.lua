-- A simple http server
srv=net.createServer(net.TCP)
srv:listen(80,function(conn)
  conn:on("receive",function(conn,payload)
    print(payload)
    conn:send("<h1> Hello, NodeMcu.</h1>")
  end)
  conn:on("sent",function(conn) conn:close() end)
end)

local increment = 0

sntp.sync('pool.ntp.org')

-- re-sync once an hour
tmr.alarm(5, 3600000, 1, function()
  sntp.sync('pool.ntp.org')
end)

local pin = 3

function debounce (func)
    local last = 0
    local delay = 500000 -- 0.5 seconds

    return function (...)
        local now = tmr.now()
        local delta = now - last
        -- if delta < 0 then delta = delta + 2147483647 end; proposed because of delta rolling over
        if delta < delay then return end;

        last = now
        return func(...)
    end
end

function onChange ()
  sec, usec = rtctime.get()
  conn = net.createConnection(net.TCP, 0)
  conn:on("receive", function(conn, payload) print(payload) end )
  conn:on("connection", function(c)
    -- close needs to be in an after send event
    conn:send("GET /?timesec=" .. sec .. "." .. usec .. "&chipid=" .. node.chipid() .. " HTTP/1.1\r\nHost: shumway.herokuapp.com\r\n"
      .."Accept: */*\r\n\r\n")
    conn:close()
  end)
  conn:connect(80,"shumway.herokuapp.com")
end

gpio.mode(pin, gpio.INPUT) -- see https://github.com/hackhitchin/esp8266-co-uk/pull/1
gpio.trig(pin, 'up', debounce(onChange))





-- 500 at 8 kohm
