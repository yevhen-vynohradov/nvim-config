return {
  {
    "max397574/better-escape.nvim",
    enabled = true,
    event = "InsertEnter",
    config = function()
      require("better_escape").setup {
        mapping = { "jk" },
      }
    end,
  },
  {
    "TheBlob42/houdini.nvim",
    enabled = false,
    event = "VeryLazy",
    opts = {
      escape_sequences = {
        ["t"] = "<ESC>",
        ["c"] = "<ESC>",
      },
    },
  },
}
