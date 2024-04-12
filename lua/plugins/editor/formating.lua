return {
  {
    "stevearc/conform.nvim",
    enabled = true,
    lazy = true,
    event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
    config = function()
      local conform = require("conform")
  
      conform.setup({
        formatters_by_ft = {
          javascript = { "prettierd", "eslint_d" },
          typescript = { "prettierd", "eslint_d" },
          javascriptreact = { "prettierd", "eslint_d" },
          typescriptreact = { "prettierd", "eslint_d" },
          css = { "prettierd" },
          scss = { "prettierd" },
          sass = { "prettierd" },
          html = { "prettierd" },
          json = { "prettierd" },
          yaml = { "prettierd" },
          markdown = { "prettierd" },
          lua = { "stylua" },
          sql = { "sql-formatter" },
        },
        --format_on_save = {
        --lsp_fallback = true,
        --async = false,
        --timeout_ms = 1000,
        --},
      })
  
      vim.keymap.set({ "n", "v" }, "<leader>mp", function()
        conform.format({
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        })
      end, { desc = "Format file or range (in visual mode)" })
    end,
  },
  -- {
  --   "stevearc/conform.nvim",
  --   enabled = false,
  --   event = "BufReadPre",
  --   opts = {},
  -- },
  {
    -- A framework for running functions 
    -- on Tree-sitter nodes, and updating 
    -- the buffer with the result.
    
    "ckolkey/ts-node-action",
    enabled = true,
    dependencies = { "nvim-treesitter" },
    opts = {},
    keys = {
      {
        "<leader>ln",
        function()
          require("ts-node-action").node_action()
        end,
        desc = "Node Action",
      },
    },
  },
  {
    -- Neovim plugin for splitting/joining blocks of code 
    -- like arrays, hashes, statements, objects, 
    -- dictionaries, etc.

    "Wansmer/treesj",
    enabled = true,
    cmd = { "TSJToggle", "TSJSplit", "TSJJoin" },
    keys = {
      { "<leader>lj", "<cmd>TSJToggle<cr>", desc = "Toggle Split/Join" },
    },
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup {
        use_default_keymaps = false,
      }
    end,
  },
}