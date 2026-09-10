local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local battery = sbar.add("item", "widgets.battery", {
  position = "right",
  icon = {
    font = {
      style = settings.font.style_map["Regular"],
      size = 12.0,
    }
  },
  label = { font = { family = settings.font.numbers } },
  update_freq = 180,
  popup = { align = "center" }
})

local remaining_time = sbar.add("item", {
  position = "popup." .. battery.name,
  icon = {
    string = "Time remaining:",
    width = 100,
    align = "left"
  },
  label = {
    string = "??:??h",
    width = 100,
    align = "right"
  },
})


battery:subscribe({"routine", "power_source_change", "system_woke"}, function()
  sbar.exec("pmset -g batt", function(batt_info)
    local icon = "!"
    local label = "?"

    local found, _, charge = batt_info:find("(%d+)%%")
    if found then
      charge = tonumber(charge)
      label = charge .. "%"
    end

    local color = colors.green
    local charging, _, _ = batt_info:find("AC Power")

    local bar_length = 10
    local half_units_total = bar_length * 2
    local step = 100 / half_units_total

    local half_units = math.ceil((charge or 0) / step)
    half_units = math.max(0, math.min(half_units_total, half_units))

    local full_boxes  = math.floor(half_units / 2)
    local has_half    = (half_units % 2 == 1)
    local empty_boxes = bar_length - full_boxes - (has_half and 1 or 0)

    local bar = string.rep("■", full_boxes)
            .. (has_half and "◧" or "")
            .. string.rep("□", empty_boxes)

    if charging then
      icon = "􀋥" .. bar 
    else
      icon = bar
    end

    if found and charge == 0 then
      color = colors.red
    elseif found and charge <= 15 then
      color = colors.red
    elseif found and charge <= 30 then
      color = colors.orange
    elseif found and charge <= 45 then
      color = colors.yellow
    end

    local lead = ""
    if found and charge < 10 then
      lead = "0"
    end

    battery:set({
      icon = {
        string = icon,
        color = color
      },
      label = { string = lead .. label },
    })
  end)
end)

battery:subscribe("mouse.clicked", function(env)
  local drawing = battery:query().popup.drawing
  battery:set( { popup = { drawing = "toggle" } })

  if drawing == "off" then
    sbar.exec("pmset -g batt", function(batt_info)
      local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
      local label = found and remaining .. "h" or "No estimate"
      remaining_time:set( { label = label })
    end)
  end
end)

sbar.add("bracket", "widgets.battery.bracket", { battery.name }, {
  background = { color = colors.bg1 }
})

sbar.add("item", "widgets.battery.padding", {
  position = "right",
  width = settings.group_paddings
})