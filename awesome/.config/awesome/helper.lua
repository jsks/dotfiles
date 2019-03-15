local io = io
local awful = awful
local tonumber = tonumber
local naughty = naughty
local beautiful = require("beautiful")
local require = require

module("helper")

-- Helper function from vicious (http://git.sysphere.org/vicious)
function escape(text)
    local xml_entities = {
        ["\""] = "&quot;",
        ["&"]  = "&amp;",
        ["'"]  = "&apos;",
        ["<"]  = "&lt;",
        [">"]  = "&gt;"
    }

    return text and text:gsub("[\"&'<>]", xml_entities)
end

-- Battery widget 
function battery_percent (adapter)
    local battery = io.open("/sys/class/power_supply/"..adapter.."/capacity")
    local status = io.open("/sys/class/power_supply/"..adapter.."/status")

    local current_percent = battery:read()
    local current_status = status:read()
    battery:close()
    status:close()

    if current_status:match("Charging") then
        battery_text = "Bat: <span color='"..beautiful.fg_battery_high .."'>"..current_percent.."</span>"
    elseif tonumber(current_percent) > 50 then
        battery_text = "Bat: <span color='"..beautiful.fg_battery_high .."'>"..current_percent.."</span>"
    else
        battery_text = "Bat: <span color='"..beautiful.fg_battery_low .."'>"..current_percent.."</span>"
    end

    return battery_text
end
