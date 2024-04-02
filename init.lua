require("core.options")
require("core.lazy")

if vim.fn.argc(-1) == 0 then
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("ModernNeovim", { clear = true }),
    pattern = "VeryLazy",
    callback = function()
      require("core.autocmds")
      require("core.keymaps")
      require("core.contextmenu")
    end,
  })
else
  require("core.autocmds")
  require("core.keymaps")
  require("core.contextmenu")
end
