return {
  {
    -- This plugin adds indentation guides to Neovim.
    -- It uses Neovim's virtual text feature and no conceal.

    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
      },
      scope = { enabled = false },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "nvim-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },
  {
    -- The goal of this plugin is to automatically detect 
    -- the indentation style used in a buffer and updating 
    -- the buffer options accordingly
    "nmac427/guess-indent.nvim",
    enabled = false,
    event = { "BufReadPre" },
    opts = {},
  }
}