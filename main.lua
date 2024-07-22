local multiplier = 1.4
local max_speed = 60
local osd_time = 10

function increase_shuttle()
    local play_dir = mp.get_property("play-dir")
    if play_dir == "backward" and get_speed() == 1 then
        mp.set_property("play-dir", "+")
    end


    if play_dir == "forward" then
        increase_speed()
    else
        decrease_speed()
    end

    print_osd()
end

function decrease_shuttle()
    local play_dir = mp.get_property("play-dir")
    if play_dir == "forward" and get_speed() == 1 then
        mp.set_property("play-dir", "-")
    end

    if play_dir == "backward" then
        increase_speed()
    else
        decrease_speed()
    end
    print_osd()
end

function toogle_shutlle(direction)
   local play_dir = mp.get_property("play-dir")
   print(direction)
   if direction == "forward" then
      if play_dir ~= direction then
         mp.set_property("play-dir", "+")
         mp.set_property("speed", 1)
      else
         increase_shuttle()
      end
   end

    if direction == "backward" then
      if play_dir ~= direction then
         mp.set_property("play-dir", "-")
         mp.set_property("speed", 1)
      else
         decrease_shuttle()
      end
   end

   print_osd()
end


function increase_speed()
    local speed = get_speed() * multiplier

    if speed < max_speed then
        mp.set_property("speed", speed)
    end
end

function decrease_speed()
    local speed = get_speed() * (1 / multiplier)

    if speed > 1 then
        mp.set_property("speed", speed)
    else
        mp.set_property("speed", 1)
    end
end

function print_osd()
    local play_dir = mp.get_property("play-dir")

    local direction_icon = "⥤"
    local text = "Speed: "
    if play_dir == "backward" then
        direction_icon = "⥢"
        text = "Speed: -"
    end

    mp.osd_message(direction_icon .. " " .. text .. get_speed(), osd_time)

    if get_speed() == 1 and play_dir == "forward" then
        mp.osd_message("")
    end
end

function get_speed()
    return roundToTwoDecimals(tonumber(mp.get_property("speed")))
end

function roundToTwoDecimals(num)
    local mult = 10 ^ 2
    return math.floor(num * mult + 0.5) / mult
end

mp.add_key_binding("8", "increase_shuttle", increase_shuttle)
mp.add_key_binding("7", "decrease_shuttle", decrease_shuttle)
mp.add_key_binding("z", "toggle_shutlle_backward", function() toogle_shutlle("backward") end)
mp.add_key_binding("x", "restart_shutlle", function() toogle_shutlle("forward") end)
