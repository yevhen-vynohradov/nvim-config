return {
  {
    "lukas-reineke/indent-blankline.nvim",
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
          "Trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
    main = "ibl",
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