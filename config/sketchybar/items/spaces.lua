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

  space:subscribe("mouse.clicked", function(env)
    if env.BUTTON == "other" then
      space_popup:set({ background = { image = "space." .. env.SID } })
      space:set({ popup = { drawing = "toggle" } })
    else
      local op = (env.BUTTON == "right") and "--destroy" or "--focus"
      sbar.exec("yabai -m space " .. op .. " " .. env.SID)
    end
  end)

  -- Fallback for when yabai space switching is broken (uncomment and comment the above)
  -- local digit_keycodes = {
  --   [1] = 18, [2] = 19, [3] = 20, [4] = 21, [5] = 23,
  --   [6] = 22, [7] = 26, [8] = 28, [9] = 25, [0] = 29,
  -- }

  -- space:subscribe("mouse.clicked", function(env)
  --   if env.BUTTON == "other" then
  --     space_popup:set({ background = { image = "space." .. env.SID } })
  --     space:set({ popup = { drawing = "toggle" } })
  --   elseif env.BUTTON == "right" then
  --     sbar.exec("yabai -m space --destroy " .. env.SID)
  --   else
  --     local n = tonumber(env.SID) % 10
  --     local kc = digit_keycodes[n]
  --     sbar.exec("osascript -e 'tell application \"System Events\" to key code " .. kc .. " using control down'")
  --   end
  -- end)

  space:subscribe("mouse.exited", function(_)
    space:set({ popup = { drawing = false } })
  end)
end

local space_window_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

-- sketchybar only reports windows that are on screen, so the windows of a hidden
-- (cmd+h) or minimized app are missing from space_windows_change. Those are
-- looked up through yabai instead, so that their space stays in the bar.
local visible_apps = {}
local hidden_apps = {}

local function render(idx)
  if spaces[idx] == nil then return end

  local apps = {}
  for app, _ in pairs(visible_apps[idx] or {}) do apps[app] = true end
  for app, _ in pairs(hidden_apps[idx] or {}) do apps[app] = true end

  local names = {}
  for app, _ in pairs(apps) do names[#names + 1] = app end
  table.sort(names)

  local icon_line = ""
  for _, app in ipairs(names) do
    local lookup = app_icons[app]
    local icon = ((lookup == nil) and app_icons["default"] or lookup)
    icon_line = icon_line .. " " .. icon
  end

  local no_app = #names == 0
  if no_app then
    icon_line = " —"
  end

  has_apps[idx] = not no_app
  refresh(idx)

  sbar.animate("tanh", 10, function()
    spaces[idx]:set({ label = icon_line })
  end)
end

local function sync_hidden_apps()
  sbar.exec("yabai -m query --windows", function(windows)
    -- Not a table when yabai is not running; keep what sketchybar reported.
    if type(windows) ~= "table" then return end

    local found = {}
    for _, window in ipairs(windows) do
      local hidden = window["is-hidden"] or window["is-minimized"]
      if hidden and window.subrole == "AXStandardWindow" then
        found[window.space] = found[window.space] or {}
        found[window.space][window.app] = true
      end
    end

    local previous = hidden_apps
    hidden_apps = found

    for idx = 1, #spaces do
      local changed = false
      for app, _ in pairs(found[idx] or {}) do
        if not (previous[idx] and previous[idx][app]) then changed = true end
      end
      for app, _ in pairs(previous[idx] or {}) do
        if not (found[idx] and found[idx][app]) then changed = true end
      end
      if changed then render(idx) end
    end
  end)
end

space_window_observer:subscribe("space_windows_change", function(env)
  local idx = env.INFO.space
  visible_apps[idx] = env.INFO.apps
  render(idx)
  sync_hidden_apps()
end)

-- Triggered by ~/.config/yabai/restore_spaces.sh: moving a hidden window to
-- another space does not cause a space_windows_change.
sbar.add("event", "spaces_restored")
space_window_observer:subscribe("spaces_restored", function(_)
  sync_hidden_apps()
end)

sync_hidden_apps()
