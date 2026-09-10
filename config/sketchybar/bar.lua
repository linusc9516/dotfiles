local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  topmost = "window",
  height = 32,
  color = colors.bar.bg,
  y_offset = 2,
  padding_right = 3,
  padding_left = 3,
  notch_width = 180,
  notch_offset = 0,
})
