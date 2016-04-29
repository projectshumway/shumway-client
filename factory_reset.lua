function factory_reset_listen()
  print('ping')
  tmr.stop(6)
  if(gpio.read(1) == 0) then
    print('waiting 3 secs')
    tmr.alarm(6, 3000, 0, function()
      if(gpio.read(1) == 0) then
        print('factory resetting')
        file.remove('config.lua')
        node.restart()
      end
    end)
  else
    tmr.alarm(6, 1000, 0, function()
      factory_reset_listen()
    end)
  end
end
