return {
  {
    -- All the lua functions I don't want to write twice.
    "nvim-lua/plenary.nvim",
    enabled = true,
  },
  {
    -- Let the repeat command repeat plugin maps
    "tpope/vim-repeat",
    enabled = true,
    event = "VeryLazy",
  },
  {
    -- Bundle of more than 30 new textobjects for Neovim
    -- nvim-treesitter-textobjects already does an excellent job 
    -- when it comes to using Treesitter for text objects, such as 
    -- function arguments or loops. This plugin's goal is therefore 
    -- not to provide textobjects already offered 
    -- by nvim-treesitter-textobjects.
    "chrisgrieser/nvim-various-textobjs",
    enabled = false,
    event = "VeryLazy",
    config = function()
      require("various-textobjs").setup { useDefaultKeymaps = true }
    end,
  },
  {
    -- Find and display URLs from a variety of search contexts
    "axieax/urlview.nvim",
    enabled = false,
    event = "VeryLazy",
    cmd = { "UrlView" }
  },
  {
    "uga-rosa/ccc.nvim",
    opts = {},
    cmd = { "CccPick", "CccConvert", "CccHighlighterEnable", "CccHighlighterDisable", "CccHighlighterToggle" },
    keys = {
      { "<leader>zC", desc = "+Color" },
      { "<leader>zCp", "<cmd>CccPick<cr>", desc = "Pick" },
      { "<leader>zCc", "<cmd>CccConvert<cr>", desc = "Convert" },
      { "<leader>zCh", "<cmd>CccHighlighterToggle<cr>", desc = "Toggle Highlighter" },
    },
  },
}
