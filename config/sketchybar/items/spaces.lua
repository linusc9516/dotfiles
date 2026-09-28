local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local spaces = {}
local brackets = {}
local selected = {}
local has_apps = {}

local function refresh(i)
  local show = selected[i] or has_apps[i]
  spaces[i]:set({ drawing = show })
  brackets[i]:set({ drawing = show })
end

for i = 1, 10, 1 do
  local space = sbar.add("space", "space." .. i, {
    space = i,
    icon = {
      font = { family = settings.font.numbers },
      string = i % 10,
      padding_left = 8,
      padding_right = 4,
      color = colors.white,
      highlight_color = colors.accent,
    },
    label = {
      padding_right = 12,
      color = colors.grey,
      highlight_color = colors.white,
      font = "sketchybar-app-font:Regular:16.0",
      y_offset = -1,
    },
    padding_right = 3,
    padding_left = 3,
    background = {
      color = colors.bg1,
      border_width = 2,
      border_color = colors.transparent,
    },
    popup = { background = { border_width = 5, border_color = colors.black } }
  })

  spaces[i] = space
  selected[i] = false
  has_apps[i] = true

  local space_bracket = sbar.add("bracket", { space.name }, {
    background = {
      color = colors.transparent,
      border_color = colors.bg2,
      height = 28,
      border_width = 2,
    }
  })
  brackets[i] = space_bracket

  local space_popup = sbar.add("item", {
    position = "popup." .. space.name,
    padding_left = 0,
    padding_right = 0,
    background = {
      drawing = true,
      image = {
        corner_radius = 9,
        scale = 0.2
      }
    }
  })

  space:subscribe("space_change", function(env)
    local is_selected = env.SELECTED == "true"
    selected[i] = is_selected
    space:set({
      icon = { highlight = is_selected },
      label = { highlight = is_selected },
      background = { border_color = is_selected and colors.accent or colors.bg2 }
    })
    -- Cannot explain why removing brackets will bomb sketchybar
    space_bracket:set({
      background = { border_color = colors.transparent }
    }) 
    refresh(i)
  end)

  -- Uncomment when yabai switch space fixed
  -- space:subscribe("mouse.clicked", function(env)
  --   if env.BUTTON == "other" then
  --     space_popup:set({ background = { image = "space." .. env.SID } })
  --     space:set({ popup = { drawing = "toggle" } })
  --   else
  --     local op = (env.BUTTON == "right") and "--destroy" or "--focus"
  --     sbar.exec("yabai -m space " .. op .. " " .. env.SID)
  --   end
  -- end)

 local digit_keycodes = {
    [1] = 18, [2] = 19, [3] = 20, [4] = 21, [5] = 23,
    [6] = 22, [7] = 26, [8] = 28, [9] = 25, [0] = 29,
  }

  space:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "other" then
      space_popup:set({ background = { image = "space." .. env.SID } })
      space:set({ popup = { drawing = "toggle" } })
    elseif env.BUTTON == "right" then
      sbar.exec("yabai -m space --destroy " .. env.SID)
    else
      local n = tonumber(env.SID) % 10
      local kc = digit_keycodes[n]
      sbar.exec("osascript -e 'tell application \"System Events\" to key code " .. kc .. " using control down'")
    end
  end)

  space:subscribe("mouse.exited", function(_)
    space:set({ popup = { drawing = false } })
  end)
end

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

space_window_observer:subscribe("space_windows_change", function(env)
  local icon_line = ""
  local no_app = true
  -- local n = 0
  for app, _ in pairs(env.INFO.apps) do
    no_app = false
    -- n = n + 1
    -- if n > 2 then
    --   icon_line = icon_line .. " ⋯"
    --   break
    -- end
    local lookup = app_icons[app]
    local icon = ((lookup == nil) and app_icons["default"] or lookup)
    icon_line = icon_line .. " " .. icon
  end

  if no_app then
    icon_line = " —"
  end

  local idx = env.INFO.space
  has_apps[idx] = not no_app
  refresh(idx)

  sbar.animate("tanh", 10, function()
    spaces[idx]:set({ label = icon_line })
  end)
end)