return {
  { "nacro90/numb.nvim",    event = "BufReadPre", config = true },
  {
    "ggandor/flit.nvim",
    enabled = false,
    keys = function()
      local ret = {}
      for _, key in ipairs { "f", "F", "t", "T" } do
        ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
      end
      return ret
    end,
    opts = { labeled_modes = "nx" },
  },
  {
    "ggandor/leap.nvim",
    enabled = false,
    keys = {
      { "s",  mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S",  mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function(_, opts)
      local leap = require("leap")
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    vscode = true,
    opts = {},
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
    },
  },
  {
    "abecodes/tabout.nvim",
    enabled = false,
    event = "InsertEnter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "hrsh7th/nvim-cmp",
    },
    config = true,
  },
  {
    "ThePrimeagen/harpoon",
    --stylua: ignore
    keys = {
      { "<leader>ja", function() require("harpoon.mark").add_file() end,            desc = "Add File" },
      { "<leader>jm", function() require("harpoon.ui").toggle_quick_menu() end,     desc = "File Menu" },
      { "<leader>jc", function() require("harpoon.cmd-ui").toggle_quick_menu() end, desc = "Command Menu" },
      { "<leader>1",  function() require("harpoon.ui").nav_file(1) end,             desc = "File 1" },
      { "<leader>2",  function() require("harpoon.ui").nav_file(2) end,             desc = "File 2" },
      { "<leader>3",  function() require("harpoon.term").gotoTerminal(1) end,       desc = "Terminal 1" },
      { "<leader>4",  function() require("harpoon.term").gotoTerminal(2) end,       desc = "Terminal 2" },
      { "<leader>5",  function() require("harpoon.term").sendCommand(1, 1) end,     desc = "Command 1" },
      { "<leader>6",  function() require("harpoon.term").sendCommand(1, 2) end,     desc = "Command 2" },
    },
    opts = {
      global_settings = {
        save_on_toggle = true,
        enter_on_sendcmd = true,
      },
    },
  },
  { "chentoast/marks.nvim", event = "BufReadPre", opts = {} },
  {
    "LeonHeidelbach/trailblazer.nvim",
    enabled = true,
    keys = {
      "<a-l>",
      { "<leader>ma", require("utils.motion").add_trail_mark_stack, desc = "TrailBlazer: Add Stack" },
      {
        "<leader>md",
        require("utils.motion").delete_trail_mark_stack,
        desc = "TrailBlazer: Delete Stack",
      },
      {
        "<leader>mg",
        function()
          require("utils.motion").get_available_stacks(true)
        end,
        desc = "TrailBlazer: Get Stacks",
      },
      {
        "<leader>ms",
        "<Cmd>TrailBlazerSaveSession<CR>",
        desc = "TrailBlazer: Save Session",
      },
      {
        "<leader>ml",
        "<Cmd>TrailBlazerLoadSession<CR>",
        desc = "Trailblazer: Load Session",
      },
    },
    opts = function()
      local bookmark = require("config.icons").ui.BookMark
      return {
        auto_save_trailblazer_state_on_exit = true,
        auto_load_trailblazer_state_on_enter = false,
        trail_mark_symbol_line_indicators_enabled = true,
        trail_options = {
          newest_mark_symbol = bookmark,
          cursor_mark_symbol = bookmark,
          next_mark_symbol = bookmark,
          previous_mark_symbol = bookmark,
          number_line_color_enabled = false,
        },
        mappings = {
          nv = {
            motions = {
              peek_move_next_down = "<a-k>",
              peek_move_previous_up = "<a-j>",
            },
          },
        },
      }
    end,
  },
  {
    "cbochs/portal.nvim",
    keys = {
      { "<C-o>", "<cmd>Portal jumplist backward<cr>",   desc = "Jump Backward" },
      { "<C-i>", "<cmd>Portal jumplist forward<cr>",    desc = "Jump Forward" },
      { "g;",    "<cmd>Portal changelist backward<cr>", desc = "Change Backward" },
      { "g,",    "<cmd>Portal changelist forward<cr>",  desc = "Change Forward" },
    },
    dependencies = {
      "cbochs/grapple.nvim",
      "ThePrimeagen/harpoon",
    },
    enabled = false,
  },
  {
    "echasnovski/mini.jump",
    enabled = false,
    opts = {},
    keys = { "f", "F", "t", "T" },
    config = function(_, opts)
      require("mini.jump").setup(opts)
    end,
  },
  {
    "echasnovski/mini.move",
    enabled = false,
    opts = {},
    keys = { "<<M-h>", "<M-l>", "<M-j>", "<M-k>" },
    config = function(_, opts)
      require("mini.move").setup(opts)
    end,
  },
}
