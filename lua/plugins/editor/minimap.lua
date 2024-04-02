return {
  {
    "echasnovski/mini.map",
    opts = {},
    keys = {
      --stylua: ignore
      { "<leader>vm", function() require("mini.map").toggle {} end, desc = "Toggle Minimap", },
    },
    config = function(_, opts)
      require("mini.map").setup(opts)
    end,
  },
  {
    "gorbit99/codewindow.nvim",
    enabled = false,
    keys = { { "<leader>m", mode = { "n", "v" } } },
    config = function()
      local codewindow = require("codewindow")
      codewindow.setup()
      codewindow.apply_default_keybinds()
    end,
  },
  {
    "lewis6991/satellite.nvim",
    enabled = function()
      return vim.fn.has "nvim-0.10.0" == 1
    end,
    event = { "BufReadPre" },
    opts = {},
  },
}