local colors = require("colors")

local sizes = io.popen("~/.config/yabai/scripts/screen_sizes.sh"):read("*l") or ""
local bar_h, _, y_off = sizes:match("(%d+) (%d+) (%d+)")

-- Equivalent to the --bar domain
sbar.bar({
  topmost = "window",
  height = tonumber(bar_h) or 32,
  color = colors.bar.bg,
  y_offset = tonumber(y_off) or 2,
  padding_right = 3,
  padding_left = 3,
  notch_width = 180,
  notch_offset = 0,
})
