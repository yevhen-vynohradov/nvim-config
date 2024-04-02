return {
  {
    -- This plugin add sub-cursor to show scroll direction!!
    "gen740/SmoothCursor.nvim",
    enabled = false,
    event = { "BufReadPre" },
    config = function()
      require("smoothcursor").setup { fancy = { enable = true } }
    end,
  },
  {
    -- Smooth scrolling for ANY movement command
    "declancm/cinnamon.nvim",
    enabled = false,
    event = { "BufReadPre" },
    config = function()
      require("cinnamon").setup()
    end,
  },
}