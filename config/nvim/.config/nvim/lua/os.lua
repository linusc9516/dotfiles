local M = {}

if vim.fn.has("mac") == 1 then
    M.is_mac = true
    M.is_linux = false
    M.font_size = 14
else
    M.is_mac = false
    M.is_linux = true
    M.font_size = 12
end

-- Detect WSL specifically
M.is_wsl = vim.fn.has("wsl") == 1

return M
