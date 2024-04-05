return {
  {
    "tpope/vim-surround",
    event = "BufReadPre",
    enabled = false
  },
  {
    "kylechui/nvim-surround",
    opts = {},
    event = { "BufReadPre", "BufNewFile" },
    version = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = true,
  },
}
