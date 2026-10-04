-- Language servers. Installed outside Neovim (uv tool / brew), so no plugin is needed.
-- Uses the built-in LSP config API (Neovim 0.11+).

-- Nearest project .venv (uv creates one per project), so pyright sees its packages
local function project_python(root_dir)
  local venv = vim.fs.find(".venv", { path = root_dir, upward = true, type = "directory" })[1]
  return venv and (venv .. "/bin/python") or nil
end

local servers = {
  basedpyright = {
    cmd = { "basedpyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
    settings = { basedpyright = { analysis = { typeCheckingMode = "standard" } } },
    before_init = function(_, config)
      local py = project_python(config.root_dir)
      if py then
        config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
          python = { pythonPath = py },
        })
      end
    end,
  },
  ruff = {
    cmd = { "ruff", "server" },
    filetypes = { "python" },
    root_markers = { "pyproject.toml", "ruff.toml", ".ruff.toml", ".git" },
  },
  lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = { ".luarc.json", ".git" },
    settings = { Lua = { diagnostics = { globals = { "vim" } } } },
  },
}

for name, cfg in pairs(servers) do
  vim.lsp.config(name, cfg)
  if vim.fn.executable(cfg.cmd[1]) == 1 then
    vim.lsp.enable(name)
  end
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    local buf = ev.buf

    -- Built-in autocompletion; <C-y> accepts, <C-n>/<C-p> move
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, buf, { autotrigger = true })
    end

    if client.name == "ruff" then
      -- basedpyright already provides hover; avoid duplicate popups
      client.server_capabilities.hoverProvider = false

      -- ruff is the formatter: format on save
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = buf, id = client.id, timeout_ms = 2000 })
        end,
      })
    end

    vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = buf, desc = "Go to definition" })
    vim.keymap.set("n", "<leader>cf", function()
      vim.lsp.buf.format({ bufnr = buf, async = true })
    end, { buffer = buf, desc = "Format buffer" })
  end,
})
