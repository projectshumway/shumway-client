dofile('factory_reset.lua')

if file.open("config.lua", "r") then
  settings = file.readline()
  file.close()

  id, sp, u, p = string.match(settings, "id={(.+)}:sp={(.+)}:u={(.+)}:p={(.+)}")
  wifi.setmode(wifi.STATION)
  wifi.sta.config(id, sp)

  tmr.alarm(0, 10000, 0, function()
    dofile("sta_mode.lua")
  end)
else
  c={} c.ssid="SHUMWAY" c.pwd="shumway1"
  wifi.setmode(wifi.SOFTAP)
  wifi.ap.config(c)

  tmr.alarm(0, 3000, 0, function()
    dofile("ap_mode.lua")
  end)
end
