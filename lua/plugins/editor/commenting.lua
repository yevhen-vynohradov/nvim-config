return {
  {
    "numToStr/Comment.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "gc",  mode = { "n", "v" } },
      { "gcc", mode = { "n", "v" } },
      { "gbc", mode = { "n", "v" } }
    },
    config = function(_, opts)
      -- import comment plugin safely
      local comment = require("Comment")
      local ts_context_commentstring = require("ts_context_commentstring.integrations.comment_nvim")

      opts.ignore = "^$"
      opts.pre_hook = ts_context_commentstring.create_pre_hook()

      comment.setup(opts)
    end,
  },
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    config = function()
      local todoComments = require("todo-comments")

      todoComments.setup({
        keywords = {
          TODO = {
            alt = { "todo" },
          },
        },
        search = {
          args = {
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--hidden",
          },
        },
      })
    end,
    -- stylua: ignore
    keys = {
      { "]t",         function() require("todo-comments").jump_next() end, desc = "Next ToDo comment" },
      { "[t",         function() require("todo-comments").jump_prev() end, desc = "Previous ToDo comment" },
      { "<leader>lt", "<cmd>TodoTrouble<cr>",                              desc = "ToDo (Trouble)" },
      { "<leader>lT", "<cmd>TodoTelescope<cr>",                            desc = "ToDo" },
    },
  },
  {
    "echasnovski/mini.comment",
    event = "VeryLazy",
    opts = {
      hooks = {
        pre = function()
          require("ts_context_commentstring.internal").update_commentstring {}
        end,
      },
    },
    config = function(_, opts)
      require("mini.comment").setup(opts)
    end,
  },
}
